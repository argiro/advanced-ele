
`timescale 1ns / 100ps

module BCD_counter_en(

   input clk,
   input rst,
   input en,
   output reg [3:0] BCD,
   output carryout 

   ) ;
   

   always @(posedge clk) begin
      if( rst == 1'b1 )              // synchronous reset
         BCD <= 4'b0000 ;
      else begin
         if( en == 1'b1 ) begin
            if( BCD == 4'b1001 )     // force the count roll-over at 9
               BCD <= 4'b0000 ;
            else
               BCD <= BCD + 1 ;
         end
      end
   end


   assign carryout = ( (BCD == 4'b1001) && (en == 1'b1) ) ? 1'b1 : 1'b0 ;

endmodule
