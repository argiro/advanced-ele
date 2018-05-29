
//-----------------------------------------------------------------------------------------------------
//                               University of Torino - Department of Physics
//                                   via Giuria 1 10125, Torino, Italy
//-----------------------------------------------------------------------------------------------------
// [Filename]       MPPC_dark_counter_UART.v  [FINAL LAB PROJECT]
// [Project]        Advanced Electronics Laboratory course
// [Authors]        Luca Pacher - pacher@to.infn.it
// [Language]       Verilog 2001 [IEEE Std. 1364-1995]
// [Created]        May  6, 2017
// [Modified]       May 22, 2018
// [Description]    Firmware for SiPM dark-counter connected to a simplified TX-only UART block
//                  for simple FPGA-to-PC data transmission.
//
// [Notes]          This code assumes to send 8-digits count transactions.
//
// [Version]        1.0
// [Revisions]      06.05.2017 - Created
//                  22.05.2018 - Added check on dark-count overflow, programmable TIMER counter
//                               with 1ms time resolution
//-----------------------------------------------------------------------------------------------------


// Dependencies:
//
// $RTL_DIR/debouncer.v
// $RTL_DIR/BCD_counter_Ndigit.v
// $RTL_DIR/seven_seg_decoder.v
// $RTL_DIR/UART/BCD_to_char.v
// $RTL_DIR/UART/uart_rx_dummy.v
// $RTL_DIR/UART/uart_tx_dummy.v


`timescale 1ns / 1ps                         // for simulation-purposes only


`define  Ndigit  8                           // total number of digits, here defined as a Verilog MACRO
`define  Nbytes  9                           // number of BYTES to be transmitted over RS-232 serial protocol to PC (8-digits + '\n' character)

`define ACQUISITION_TIME 10000               // 20-bit integer => T = (`ACQUISITION_TIME) x (1ms time resolution)

module  MPPC_dark_counter_UART (

   // clock and control signals
   input   wire clk,                         // on-board 100 MHz clock source
   input   wire rst_button,                  // global ASYNCHRONOUS reseti, active-high (push-button)
   input   wire start_button,                // start flag (push-button)
   input   wire disc_pulse,                  // DISC output pulse (3.3V CMOS)

   // test-mode
   input wire test_mode,                     // MUX control (slide-switch)
   input wire test_pulse,                    // user pulse to check counting and UART transmission

   // status flags
   output  wire busy,                        // map these flags to some LEDs to indicate that counting is ongoing, completed or overflow
   output  wire done,
   output  wire overflow,

   // 7-segment display signals
   output  wire segA,                        // 7-segment diplay LEDs
   output  wire segB,
   output  wire segC,
   output  wire segD,
   output  wire segE,
   output  wire segF,
   output  wire segG,
   output  reg [(`Ndigit-1):0] seg_anode,    // 7-segment diplay anodes array with one-hot encoding 

   // USB/UART bridge interface
   output wire TxD,                          // output serial line, to PC
   input  wire RxD,                          // input serial line, from PC

   // **DEBUG: oscilloscope probes
   output wire disc_pulse_probe,             // buffered DISC pulse
   output wire rx_probe,                     // UART input serial line
   output wire tx_probe                      // UART output serial line

   ) ;



   ///////////////////////////////////////////////////////////////////////////////////////
   //   push-button debouncers (single-pulse generators at ~ 1kHz sampling frequency)   //
   ///////////////////////////////////////////////////////////////////////////////////////

   wire rst ;

   debouncer debouncer_0 (

      .clk    (        clk ),
      .button ( rst_button ),
      .pulse  (        rst )       // **SYNCHRONOUS, active-high

      ) ;


   wire start_ext ;

   debouncer debouncer_1 (

      .clk    (          clk ),
      .button ( start_button ),
      .pulse  (    start_ext )

      ) ;



   ////////////////////////////////////////
   //   dummy USB/UART bridge receiver   //
   ////////////////////////////////////////

   wire start_uart ;

   uart_rx_dummy   uart_rx (

      .clk        (        clk ),
      .rx_lane    (        RxD ),
      .start_uart ( start_uart ),
      .rx_probe   (   rx_probe )

      ) ;



   /////////////////////
   //   START logic   //
   /////////////////////

   // combine flags from push-button or from UART

   wire start_or ;
   assign start_or = start_ext | start_uart ;     // ~ ms pulse

   // single-clock pulse generator

   reg start_ff0 = 1'b0 ;
   reg start_ff1 = 1'b0 ;
   reg start_ff2 = 1'b0 ;
   reg start_ff3 = 1'b0 ; 

   always @(posedge clk) begin
      start_ff0 <= start_or ;
      start_ff1 <= start_ff0 ;
      start_ff2 <= start_ff0 & (~start_ff1) ;
      start_ff3 <= start_ff2 ;
   end   // always


   wire start_rst ; assign start_rst = start_ff2 ;             // use the first pulse to reset the dark-count value without the need of pressing a button
   wire start_pulse ; assign start_pulse = start_ff3 ;         // use the delayed pulse to start the counter

   // register start_pulse into a 1-bit register

   reg start_reg = 1'b0 ;

   always @(posedge clk) begin

      if( (rst == 1'b1) || (start_rst == 1'b1) )
         start_reg <= 1'b0 ;

      else if(start_pulse == 1'b1)
            start_reg <= 1'b1 ;     // and keep the value until an external reset or a new start is issued ...
   end   // always



   ///////////////////////////////////////////////////////////////////////////////////////////////
   //   free-running counters for 7-segment display anode multiplexing and acquisition window   //
   ///////////////////////////////////////////////////////////////////////////////////////////////

   // these free-running counters are used for 7-segment display anodes multiplexing and to determine the acquisition time

   reg [19:0] count_seg = 'b0 ;       // **NOTE: no need fo reset
   reg [19:0] count_timer = 'b0 ;     // **NOTE: no need for reset

   always @(posedge clk)
      count_seg <= count_seg + 1 ;

   always @(posedge clk) begin
      if( count_timer == 100000 -1)
         count_timer <= 'b0 ;               // force the roll-over at 1 kHz frequency, i.e. every 1 ms
      else
         count_timer <= count_timer + 1 ;
   end


   //
   // 1ms TIMER 'tick'
   //

   // generate a single-clock pulse 'tick' at each reset
   wire timer_clock_enable ;
   assign timer_clock_enable = ( count_timer == 1'b0 ) ? 1'b1 : 1'b0 ;


   //
   // 7-SEGMENT DISPLAY ANODES REFRESH
   //

   // control slice for multiplexing anodes and BCD-boundles
   wire [2:0] refresh_slice ;

   assign refresh_slice = count_seg[15:13] ;                // this choice determines the refresh frequency for 7-segment diplay digits



   ///////////////////////
   //   TIMER counter   //
   /////////////////////// 

   // another 20-bit counter
   reg [19:0] acquisition_count ;

   // max. count, defines the overall acquisition window in terms of ms
   wire [19:0] acquisition_time = `ACQUISITION_TIME ;     // 1ms x `ACQUISITION_TIME
   //wire [19:0] acquisition_time = 10000 ;     // 1ms x `ACQUISITION_TIME


   always @(posedge clk) begin

      if( (rst == 1'b1) || (start_rst == 1'b1) )
         acquisition_count <= 'b0 ;

      else
         if( (timer_clock_enable == 1'b1) && (start_reg == 1'b1) && (acquisition_count < acquisition_time ) )
            acquisition_count <= acquisition_count + 1'b1 ;

   end



   ////////////////////
   //   STOP logic   //
   ////////////////////

   // register the STOP-flag into a 1-bit register

   reg stop_reg =1'b0 ;

   always @(posedge clk) begin

      if( (rst == 1'b1) || (start_rst == 1'b1) )
         stop_reg <= 1'b0 ;
      else
         if( (acquisition_count == acquisition_time)  || (overflow == 1'b1) )
            stop_reg <= 1'b1 ;
   end



   /////////////////////////////
   //   N-digit BCD counter   //
   /////////////////////////////
   
   // combine start/stop flags and BCD counter overflow to generate a count-enable for the BCD counter

   wire    dark_counter_en ;
   //assign  dark_counter_en = start_reg & (~stop_reg) & (~overflow) ;    //  **COMBINATIONAL LOOP ! Vivado refuses to synthesisze this !
   assign  dark_counter_en = start_reg & (~stop_reg) ;

   // status flags
   assign busy = dark_counter_en ;
   assign done = stop_reg ;


   // MUX control (switch between test-mode and normal mode)

   wire pulse_count ;
   assign pulse_count = ( test_mode == 1'b1 ) ? test_pulse : disc_pulse ;


   // instantiate an N-digit BCD counter to count the number of dark-count pulses

   wire [(`Ndigit*4)-1:0] BCD ;                 // from the BCD counter
   wire [(`Ndigit*4)-1:0] BCD_dark_count ;      // take into account of overflow

   BCD_counter_Ndigit  #( .Ndigit(`Ndigit) )   dark_counter (

      //.clk      (                  ~clk ),         // **DEBUG: test overflow
      .clk      (           pulse_count ),           // from DISC or from PB
      .rst      (       rst | start_rst ),
      .en       (       dark_counter_en ),
      .BCD      (  BCD[(`Ndigit*4)-1:0] ),
      .overflow (              overflow )

      ) ;


   assign BCD_dark_count = ( overflow == 1'b0 ) ? BCD : {`Ndigit{4'b1001}} ;   // force 999...9 in case of overflow



   //////////////////////////////////////////////
   //   7-segment display multiplexing logic   //
   ////////////////////////////////////////////// 

   // multiplex BCD slices

   reg [3:0] BCD_mux ;

   always @(*) begin   // pure combinational block

      case( refresh_slice )

         0  :  BCD_mux[3:0] <= BCD_dark_count[ 3: 0] ;
         1  :  BCD_mux[3:0] <= BCD_dark_count[ 7: 4] ;
         2  :  BCD_mux[3:0] <= BCD_dark_count[11: 8] ;
         3  :  BCD_mux[3:0] <= BCD_dark_count[15:12] ;
         4  :  BCD_mux[3:0] <= BCD_dark_count[19:16] ;
         5  :  BCD_mux[3:0] <= BCD_dark_count[23:20] ;
         6  :  BCD_mux[3:0] <= BCD_dark_count[27:24] ;
         7  :  BCD_mux[3:0] <= BCD_dark_count[31:28] ;

         default : BCD_mux[3:0] <= BCD_dark_count[3:0] ;      // catch-all, in this case not mandatory

      endcase
   end  // always


   // multiplex ANODES using a binary to one-hot decoder

   //     slice   |    seg_anode
   //
   //       0     |    00000001
   //       1     |    00000010
   //       2     |    00000100
   //      etc.   |    10...000
   //
   //               _                  _
   // _____________/ \________________/ \____  seg_anode[2]
   //             _                  _
   // ___________/ \________________/ \______  seg_anode[1]
   //           _                  _
   // _________/ \________________/ \________  seg_anode[0]



   // compact procedural code using a Verilog for-loop

   integer i ;

   always @(*) begin   // pure combinational block

      for( i = 0 ; i < `Ndigit ; i = i+1 ) begin

         seg_anode[i] = ( refresh_slice == i ) ;

      end  // for
   end  // always

   // alternatively, use concurrent conditional assignments on wires

   //assign seg_anode[0] = ( refresh_slice == 0 ) ? 1'b1 : 1'b0 ;
   //assign seg_anode[1] = ( refresh_slice == 1 ) ? 1'b1 : 1'b0 ;
   //assign seg_anode[2] = ( refresh_slice == 2 ) ? 1'b1 : 1'b0 ;
   //assign seg_anode[3] = ... ;
   //assign seg_anode[4] = ... ;



   ///////////////////////////
   //   7-segment decoder   //
   ///////////////////////////

   seven_seg_decoder  decoder (

      .BCD   ( BCD_mux[3:0] ),
      .segA  (         segA ),
      .segB  (         segB ),
      .segC  (         segC ),
      .segD  (         segD ),
      .segE  (         segE ),
      .segF  (         segF ),
      .segG  (         segG ),
      .segDP (              )

   ) ;



   /////////////////////////////////
   //   BCD-to-ASCII conversion   //
   /////////////////////////////////


   // 8-bit (1-Byte) ASCII **CHARACTERS** to be trasmitted to the PC through RS-232 serial protocol

   wire [7:0] char_0 ;
   wire [7:0] char_1 ;
   wire [7:0] char_2 ;
   wire [7:0] char_3 ;
   wire [7:0] char_4 ;
   wire [7:0] char_5 ;
   wire [7:0] char_6 ;
   wire [7:0] char_7 ;


   BCD_to_char   BCD_to_char_0 (

      .BCD   ( BCD_dark_count[3:0] ),     // 1st DIGIT
      .char  (         char_0[7:0] )

      ) ;

   BCD_to_char   BCD_to_char_1 (

      .BCD   ( BCD_dark_count[7:4] ),     // 2nd DIGIT
      .char  (         char_1[7:0] )

      ) ;

   BCD_to_char   BCD_to_char_2 (

      .BCD   ( BCD_dark_count[11:8] ),    // 3rd DIGIT
      .char  (          char_2[7:0] )

      ) ;

   BCD_to_char   BCD_to_char_3 (

      .BCD   ( BCD_dark_count[15:12] ),   // 4th DIGIT
      .char  (           char_3[7:0] )

      ) ;

   BCD_to_char   BCD_to_char_4 (

      .BCD   ( BCD_dark_count[19:16] ),   // 5th DIGIT
      .char  (           char_4[7:0] )

      ) ;

   BCD_to_char   BCD_to_char_5 (

      .BCD   ( BCD_dark_count[23:20] ),   // 6th DIGIT
      .char  (           char_5[7:0] )

      ) ;

   BCD_to_char   BCD_to_char_6 (

      .BCD   ( BCD_dark_count[27:24] ),   // 7th DIGIT
      .char  (           char_6[7:0] )

      ) ;

   BCD_to_char   BCD_to_char_7 (

      .BCD   ( BCD_dark_count[31:28] ),   // 8th DIGIT
      .char  (           char_7[7:0] )

      ) ;



   //////////////////////////////////////////
   //   dummy USB/UART bridge trasmitter   //
   //////////////////////////////////////////

   //
   // PAYLOAD DATA to be trasmitted over RS-232
   //

   // **NOTE: According to RS-232 LSB is transmitted first!
   //         Hence send 8'hA = '\n' (new-line) character first

   wire [(`Nbytes)*8-1:0] tx_data ;
   assign tx_data = { 8'hA , char_0 , char_1 , char_2 , char_3 , char_4 , char_5 , char_6 , char_7 } ;


   //
   // BAUD-RATE GENERATOR
   //

   // generate a ~9.6 kHz single-clock pulse Baud-rate for data trasmission by dividing
   // the on-bard 100 MHz clock by 10415

   // 14-bit free-running counter
   reg [13:0] count_baudrate = 'b0 ;

   always @(posedge clk)
      if( count_baudrate == 10414 )
         count_baudrate <= 'b0 ;                               // force the roll-over 
      else
         count_baudrate <= count_baudrate + 1 ;

   wire tx_en ;
   assign tx_en = ( count_baudrate == 0 ) ? 1'b1 : 1'b0 ;     // assert a single-clock pulse each time the counter resets



   // generate a single-clock pulse tx_start flag from the stop_reg flag to initialize the serial
   // communication over RS-232 (alternatively, use a push-button to start transactions)

   reg tx_start_q0, tx_start_q1, tx_start_q2 ;           // D-FlipFlops outputs

   always @(posedge clk) begin

      tx_start_q0 <= stop_reg ;
      tx_start_q1 <= tx_start_q0 ;
      tx_start_q2 <= tx_start_q0 & (~ tx_start_q1) ;
   end

   wire tx_start ;
   assign tx_start = tx_start_q2 ;


   //
   // simplified UART TX unit
   //

   uart_tx_dummy  #( .Nbytes(`Nbytes) )   uart_tx (

      .clk       (                      clk ),
      .tx_start  (                 tx_start ),
      .tx_en     (                    tx_en ),
      .tx_data   ( tx_data[(`Nbytes)*8-1:0] ),
      .tx_lane   (                      TxD )

      ) ;


   /////////////////////////////
   //   oscilloscope probes   //
   /////////////////////////////

   // buffer DISC pulse from breadboard
   //assign disc_pulse_probe = disc_pulse ;
   assign disc_pulse_probe = pulse_count ;     // better, after test-mode MUX

   // just for debug purposes, send the TxD serial output to a test-point on the board
   assign tx_probe = TxD ;


endmodule

