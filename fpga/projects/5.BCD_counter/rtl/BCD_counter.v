
//-----------------------------------------------------------------------------------------------------
//                               University of Torino - Department of Physics
//                                   via Giuria 1 10125, Torino, Italy
//-----------------------------------------------------------------------------------------------------
// [Filename]       BCD_counter.v
// [Project]        Advanced Electronics Laboratory course
// [Author]         Luca Pacher - pacher@to.infn.it
// [Language]       Verilog 2001 [IEEE Std. 1364-2001]
// [Created]        Mar 02, 2016
// [Modified]       May 09, 2016
// [Description]    Free-running binary-coded decimal (BCD) counter
// [Notes]          -
// [Version]        1.0
// [Revisions]      02.03.2016 - Created
//-----------------------------------------------------------------------------------------------------


`timescale 1ns / 100ps

module BCD_counter(

   input clk,
   input rst,
   output reg [3:0] BCD ) ;
   

   always @(posedge clk) begin 	                            // synchronous reset
   //always @(posedge clk or posedge rst) begin             // asynchronous reset

      if( rst == 1'b1 )
         BCD <= 4'b0000 ;

      else begin

         if( BCD == 4'b1001 )     // force the count roll-over at 9
            BCD <= 4'b0000 ;
         else
            BCD <= BCD + 4'b0001 ;
      end
   end // always

endmodule
