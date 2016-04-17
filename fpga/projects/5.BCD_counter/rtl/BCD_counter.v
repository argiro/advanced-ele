
`timescale 1ns / 100ps

module BCD_counter(

   input clk,
   input rst,
   output reg [3:0] BCD ) ;
   

   always @(posedge clk or posedge rst) begin
      if( rst == 1'b1 )           // asynchronous reset !
         BCD <= 4'b0000 ;
      else begin
         if( BCD == 4'b1001 )     // force the count roll-over at 9
            BCD <= 4'b0000 ;
         else
            BCD <= BCD + 1 ;
      end
   end

endmodule
