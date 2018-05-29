
//-----------------------------------------------------------------------------------------------------
//                               University of Torino - Department of Physics
//                                   via Giuria 1 10125, Torino, Italy
//-----------------------------------------------------------------------------------------------------
// [Filename]       MPPC_dark_counter.v  [FINAL LAB PROJECT]
// [Project]        Advanced Electronics Laboratory course
// [Author]         Luca Pachwr - pacher@to.infn.it 
// [Language]       Verilog 2001 [IEEE Std. 1364-1995]
// [Created]        May 25, 2016
// [Modified]       May 25, 2016
// [Description]    Top RTL code for the MPPC dark-counter project.
// [Notes]          -
// [Version]        1.0
// [Revisions]      25.05.2016 - Created
//-----------------------------------------------------------------------------------------------------


`timescale 1ns / 100ps


// Dependencies:
//
// $RTL_DIR/debouncer.v
// $RTL_DIR/BCD_counter_Ndigit.v
// $RTL_DIR/seven_seg_decoder.v


`define  Ndigit  8   // 2x 4-digit 7-segment display modules


module  MPPC_dark_counter (

   input   clk,                    // on-board 100 MHz clock source
   input   rst,                    // global ASYNCHRONOUS reset (push-button)
   input   start,                  // push-button
   input   disc_pulse,             // DISC output pulse (3.3V CMOS)
   output  disc_probe,             // optionally, buffer the hit from DISC for the oscilloscope
   output  segA,
   output  segB,
   output  segC,
   output  segD,
   output  segE,
   output  segF,
   output  segG,
   output  reg [(`Ndigit-1):0] seg_anode     // anodes array with one-hot encoding

   ) ;

   // buffer on "analog" hit fed to FPGA
   assign disc_probe = disc_pulse ;


   // free-running counter for on-board 100 MHz clock division and slicing

   reg [26:0] clk_count ;

   always @(posedge clk) begin
      clk_count <= clk_count + 1'b1 ;
   end



   // timer clock
   wire    clk_time_counter ;
   assign  clk_time_counter = clk_count[25] ;           // 100 MHz / 2^(25+1) = 1.49 Hz, ~ 0.7s per count
   //assign  clk_time_counter = clk_count[26] ;


   // control slice for anodes multiplexing
   wire [... : 0] count_slice ;
   assign count_slice = count[... : ...] ;             // this choice determines the refresh frequency



   //-------------------------   START logic   -------------------------------//



   wire    start_pulse ;
   assign  start_pulse = start_synch_q2 ;



   // register the START-flag into a 1-bit register

   reg start_reg ;

   always @(posedge clk or posedge rst) begin

      if( rst == 1'b1 )            // asynch. reset  
         start_reg <= 1'b0 ;

      else
         if(start_pulse == 1'b1)
            start_reg <= 1'b1 ;
   end



   //-------------------------   TIMER counter   -------------------------------//

   reg [4:0] time_count ;


   wire [4:0] time_count_max = 5'b ... ;   // max. count, defines the overall acquisition window in terms of clk_time_counter cycles


   always @(posedge clk_time_counter or posedge rst) begin

      if( rst == 1'b1 )           // asynch. reset
         time_count <= 'b0 ;

      else
         if( (start_reg == 1'b1) && (time_count < time_count_max ) )
            time_count <= time_count + 1'b1 ;

   end




   //-------------------------   STOP logic   -------------------------------//


   // register the STOP-flag into a 1-bit register

   reg stop_reg ;

   always @(posedge clk or posedge rst) begin

      if( rst == 1'b1 )           // asynch. reset   
         stop_reg <= 1'b0 ;
      else
         if( time_count == time_count_max )
            stop_reg <= 1'b1 ;
   end



   /////////////////////////////
   //   N-digit BCD counter   //
   /////////////////////////////

   wire [(`Ndigit*4)-1:0] BCD_dark_count ;

   wire overflow ;
   assign overflow = (BCD_dark_count == 10**(`Ndigit) -1) ? 1'b1 : 1'b0 ;  // overflow flag when the count is 9999 ... 9
   
   // generate a count-enable for the BCD counter by combining start/stop flags or count-overflow at roll-over
   wire    dark_counter_en ;
   assign  dark_counter_en = start_reg & (~stop_reg) & (~overflow) ;

   
   
   BCD_counter_Ndigit  #(`Ndigit) dark_counter(

      .clk  (        disc_pulse ),
      .rst  (               rst ),
      .en   (   dark_counter_en ),
      .BCD  (    BCD_dark_count )
      //.overflow (               )       // alternatively whe can use also the last-digit overflow flag (lesser resources)

      ) ;




   //-------------------------   7-segment display multiplexing logic   -------------------------------//

   // multiplex BCD slices

   reg [3:0] BCD_mux ;

   always @(*) begin

      case( count_slice )

         0  :  BCD_mux <= BCD[ 3:0] ;
         1  :  BCD_mux <= BCD[ 7:4] ;
         2  :  BCD_mux <= BCD[...] ;
         //3 ...
         //4 ...

         default : BCD_mux <= BCD[3:0] ;      // latches inferred otherwise (catch-all)

      endcase
   end


   // anodes binary/one-hot decoder (procedural code)

   integer i ;

   always @(*) begin

      for( i = 0 ; i < `Ndigit ; i = i+1 ) begin

         seg_anode[i] = ( count_slice == i ) ;       // appreciate here the beauty of Verilog, this cannot be coded in VHDL without explicit type-casting ! 'i' is integer, 'count_slice' a bus...

      end  // for
   end  // always


   // alternatively, use concurrent conditional assignments on wires

   //assign seg_anode[0] = ( count_slice == ... ) ? 1'b1 : 1'b0 ;
   //assign seg_anode[1] = ( count_slice == ... ) ? 1'b1 : 1'b0 ;
   //assign seg_anode[2] = ( count_slice == ... ) ? 1'b1 : 1'b0 ;
   //assign seg_anode[3] = ... ;
   //assign seg_anode[4] = ... ;



   //-------------------------   7-segment decoder   -------------------------------//


   seven_seg_decoder  decoder(

      .BCD   (   BCD_mux ),
      .segA  (      segA ),
      .segB  (      segB ),
      .segC  (      segC ),
      .segD  (      segD ),
      .segE  (      segE ),
      .segF  (      segF ),
      .segG  (      segG ),
      .segDP (           )

   ) ;



endmodule
