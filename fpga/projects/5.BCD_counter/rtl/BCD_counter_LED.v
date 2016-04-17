
`timescale 1ns / 100ps

// Dependences:
//
// $RTL_DIR/BCD_counter.v


module BCD_counter_LED(

   input clk,
   input rst,
   output [3:0] count_LED,
   output carry_LED   ) ;
   
   
   // clock divider

   reg [27:0] count ;
   wire clk_div ;
   
   
   always @(posedge clk) begin
      count = count + 1 ;   
   end // always
   
   assign clk_div = count[25] ;
   //assign clk_div = count[26] ;
   //assign clk_div = count[27] ;

   // BCD counter

   wire [3:0] BCD ;
   BCD_counter BCD(
      .clk  ( clk_div ),
      .rst  (     rst ),
      .BCD  (     BCD )
   ) ;      

   assign count_LED = BCD ;
   assign carry_LED = ( BCD == 4'b1001 ) ? 1'b1 : 1'b0 ;

   
endmodule
