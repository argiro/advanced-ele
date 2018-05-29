
//-----------------------------------------------------------------------------------------------------
//                               University of Torino - Department of Physics
//                                   via Giuria 1 10125, Torino, Italy
//-----------------------------------------------------------------------------------------------------
// [Filename]       debouncer.v
// [Project]        Advanced Electronics Laboratory course
// [Author]         Luca Pacher - pacher@to.infn.it
// [Language]       Verilog 2001 [IEEE Std. 1364-2001]
// [Created]        May 21, 2018
// [Modified]       May 21, 2018
// [Description]    Simple push-button debouncer with 0.5 kHz or 1 kHz low sampling frequency.
// [Notes]          -
// [Version]        1.0
// [Revisions]      21.05.2018 - Created
//-----------------------------------------------------------------------------------------------------


// Dependencies:
//
// n/a


`timescale 1ns / 1ps


module debouncer (

   input  clk,            // on-board 100 MHz clock
   //input  rst,          // dedicated reset push-button  => **NOT NEEDED** DFF here are used just as delay elements !
   input  button,         // glitching push-button input
   output pulse           // clean single-pulse output

   ) ;



   ////////////////////////////////////////
   //   low-frequency 'tick' generator   //
   ////////////////////////////////////////

   // the glitching on a push-button lasts for milli-seconds before disappear
   // hence the push-button signal must be sampled at ~1 kHz frequency, not at 100 MHz !
   // however, **AVOID** to generate a new clock with a clock-divider, generate
   // a 1 kHz single-pulse 'tick' to enable the logic in the single-pulse generator instead

   // 20-bit free-running counter
   reg [19:0] count = 'b0 ;

   // 1 kHz 'tick" clock-enable for the single-pulse generatpor, asserted when the counter resets
   reg enable = 1'b0 ;

   always @(posedge clk) begin

      if( count == 50000-1) begin          // 0.5 kHz clock-enable
      //if( count == 100000-1) begin       // 1 kHz clock-enable
         count <= 'b0 ;
         enable = 1'b1 ;
      end
      else begin
         count <= count + 1 ;
         enable <= 1'b0 ;
      end
   end   // always


   ////////////////////////////////
   //   single-pulse generator   //
   ////////////////////////////////

   reg q0 = 1'b0 ;   // DFF outputs, initialized at zero inside the FPGA (these FlipFlops works only as delay elements)
   reg q1 = 1'b0 ;
   reg q2 = 1'b0 ;

   always @(posedge clk) begin   // **NOTE: the clock running in the process is the on-board master clock running at 100 MHz
                                 //         but the logic is enabled at 1 kHz frequency ! (good design practice)
      //if( rst == 1'b1 ) begin
      //   q0 <= 1'b0 ;
      //   q1 <= 1'b0 ;
      //   q2 <= 1'b0 ;
      //end

      //else if( enable == 1'b1 ) begin
      if(enable) begin
         q0 <= button ;                      // from push-button
         q1 <= q0 ;
         q2 <= q0 & (~q1) ;
      end
   end

   assign pulse = q2 ;

endmodule

