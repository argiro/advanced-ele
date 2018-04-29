
//-----------------------------------------------------------------------------------------------------
//                               University of Torino - Department of Physics
//                                   via Giuria 1 10125, Torino, Italy
//-----------------------------------------------------------------------------------------------------
// [Filename]       MPPC_dark_counter_UART.v  [FINAL LAB PROJECT]
// [Project]        Advanced Electronics Laboratory course
// [Authors]        Luca Pacher - pacher@to.infn.it
// [Language]       Verilog 2001 [IEEE Std. 1364-1995]
// [Created]        May  6, 2017
// [Modified]       May 22, 2017
// [Description]    Firmware for SiPM dark-counter connected to a simplified TX-only UART block
//                  for simple FPGA-to-PC data transmission.
//
// [Notes]          This code assumes to send 8-digits count transactions.
//
// [Version]        1.0
// [Revisions]      06.05.2017 - Created
//-----------------------------------------------------------------------------------------------------


// Dependencies:
//
// $RTL_DIR/BCD_counter_Ndigit.v
// $RTL_DIR/seven_seg_decoder.v
// $RTL_DIR/UART/BCD_to_char.v
// $RTL_DIR/UART/uart_tx_Nbytes.v


`timescale 1ns / 1ps                         // for simulation-purposes only


`define  Ndigit  8                           // total number of digits, here defined as a Verilog MACRO
`define  Nbytes  9                           // number of BYTES to be transmitted over RS-232 serial protocol to PC (8-digits + '\n' character)


module  MPPC_dark_counter_UART (

   input   wire clk,                         // on-board 100 MHz clock source
   input   wire rst,                         // global ASYNCHRONOUS reset (e.g. push-button)
   input   wire start,                       // push-button or slide switch
   input   wire disc_pulse,                  // DISC output pulse (3.3V CMOS)

   // status flags
   output  wire busy,                        // map these flags to some LEDs to indicate that counting is ongoing or completed  
   output  wire finish,

   output  wire segA,                        // 7-segment diplay LEDs
   output  wire segB,
   output  wire segC,
   output  wire segD,
   output  wire segE,
   output  wire segF,
   output  wire segG,
   output  reg [(`Ndigit-1):0] seg_anode,    // 7-segment diplay anodes array with one-hot encoding 

   // UART interface
   output wire probe,                        // output serial line, to oscilloscope probe
   output wire TxD,                          // output serial line, to PC
   input  wire RxD                           // input serial line (not implemented)

   ) ;


   // just for debug purposes, send the TxD serial output to a test-point on the board
   assign probe = TxD ;


   // free-running counter for on-board 100 MHz clock division and slicing

   reg [26:0] clk_count ;

   always @(posedge clk) begin
      clk_count <= clk_count + 1'b1 ;
   end



   // timer clock
   wire    clk_time_counter ;

   //assign  clk_time_counter = clk_count[24] ;
   assign  clk_time_counter = clk_count[25] ;              // 100 MHz / 2^(25+1) = 1.49 Hz, ~ 0.7s for each count
   //assign  clk_time_counter = clk_count[26] ;
   //assign  clk_time_counter = clk_count[27] ;


   // control slice for multiplexing anodes and BCD-boundles
   wire [2:0] count_slice ;

   assign count_slice = clk_count[20:18] ;                // this choice determines the refresh frequency for 7-segment diplay digits



   //-------------------------   START logic   -------------------------------//


   // push-button debouncer (single-pulse generator)

   reg start_synch_q0, start_synch_q1, start_synch_q2 ;    // D-FlipFlops outputs

   always @(posedge clk or posedge rst) begin

      if( rst == 1'b1 ) begin                   // asynchronous, active-high reset

         start_synch_q0 <= 1'b0 ;
         start_synch_q1 <= 1'b0 ;
         start_synch_q2 <= 1'b0 ;
      end

      else begin
      
         start_synch_q0 <= start ;              // from push-button or slide switch
         start_synch_q1 <= start_synch_q0 ;
         start_synch_q2 <= start_synch_q0 & (~ start_synch_q1) ;
      end
   end

   wire    start_pulse ;
   assign  start_pulse = start_synch_q2 ;



   // register the START-flag into a 1-bit register

   reg start_reg ;

   always @(posedge clk or posedge rst) begin

      if( rst == 1'b1 )            // asynchronous, active-high reset  
         start_reg <= 1'b0 ;

      else
         if(start_pulse == 1'b1)   // else... what happens ?
            start_reg <= 1'b1 ;
   end



   //-------------------------   TIMER counter   -------------------------------//

   reg [4:0] time_count ;


   // max. count, defines the overall acquisition window in terms of clk_time_counter cycles
   wire [4:0] time_count_max = 5'd11 ;


   always @(posedge clk_time_counter or posedge rst) begin

      if( rst == 1'b1 )           // asynchronous, active-high reset
         time_count <= 'b0 ;

      else
         if( (start_reg == 1'b1) && (time_count < time_count_max ) )   // else... what happens ?
            time_count <= time_count + 1'b1 ;

   end




   //-------------------------   STOP logic   -------------------------------//


   // register the STOP-flag into a 1-bit register

   reg stop_reg ;

   always @(posedge clk or posedge rst) begin

      if( rst == 1'b1 )           // asynchronous, active-high reset   
         stop_reg <= 1'b0 ;
      else
         if( time_count == time_count_max )   // count-overflow reached, genenerate and register a flag for this condition
            stop_reg <= 1'b1 ;
   end

   
   // combine start/stop flags to generate a count-enable for the BCD counter
   wire    dark_counter_en ;
   assign  dark_counter_en = start_reg & (~stop_reg) ;

   // status flags
   assign busy = dark_counter_en ;
   assign finish = stop_reg ;



   //------------------------   BCD counter   -------------------------------//   

   // instantiate an N-digit BCD counter to count the number of dark-count pulses

   wire [(`Ndigit*4)-1:0] BCD_dark_count ;

   BCD_counter_Ndigit  #( .Ndigit(`Ndigit) )   dark_counter (

      .clk  (                      disc_pulse ),           // from DISC
      .rst  (                             rst ),
      .en   (                 dark_counter_en ),
      .BCD  ( BCD_dark_count[(`Ndigit*4)-1:0] )

      ) ;




   //-------------------------   7-segment display multiplexing logic   -------------------------------//

   // multiplex BCD slices

   reg [3:0] BCD_mux ;

   always @(*) begin   // pure combinational block

      case( count_slice )

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

         seg_anode[i] = ( count_slice == i ) ;

      end  // for
   end  // always






   //-------------------------   7-segment decoder   -------------------------------//


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



   //-------------------------   BCD-to-ASCII conversion   -------------------------------//


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




   //-------------------------   TX-DATA   -------------------------------//

   // payload data to be trasmitted over RS-232


   // **NOTE: According to RS-232 LSB is transmitted first!
   //         Hence send 8'hA = '\n' (new-line) character first

   wire [(`Nbytes)*8-1:0] tx_data ;
   assign tx_data = { 8'hA , char_0 , char_1 , char_2 , char_3 , char_4 , char_5 , char_6 , char_7 } ;





   //-------------------------   BAUD-RATE GENERATOR   -------------------------------//

   // generate a ~9.6 kHz single-clock pulse Baud-rate for data trasmission by dividing
   // the on-bard 100 MHz clock by 10415

   // 14-bit free-running counter
   reg [13:0] count ;

   always @(posedge clk)
      if( count == 10414 )
         count <= 'b0 ;                               // force the roll-over 
      else
         count <= count + 1'b1 ;

   wire tx_en ;
   assign tx_en = ( count == 0 ) ? 1'b1 : 1'b0 ;     // assert a single-clock pulse each time the counter resets





   //-------------------------   UART TX UNIT   -------------------------------//

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


   // simplified UART TX unit

   uart_tx_Nbytes   #( .Nbytes(`Nbytes) )   uart_tx (

      .clk       (                      clk ),
      .tx_start  (                 tx_start ),
      .tx_en     (                    tx_en ),
      .tx_data   ( tx_data[(`Nbytes)*8-1:0] ),
      .tx_lane   (                      TxD )

      ) ;


endmodule

