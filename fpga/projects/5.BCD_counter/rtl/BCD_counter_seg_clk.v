
`timescale 1ns / 100ps

// Dependences:
//
// $RTL_DIR/BCD_counter.v
// $RTL_DIR/seg_decoder.v


module BCD_counter_seg_clk(

   input  clk,
   input  rst,

   output segA,
   output segB,
   output segC,
   output segD,
   output segE,
   output segF,
   output segG,
   output segDP ) ;


   // clock divider

   reg [27:0] count ;
   wire clk_div ;
   
   
   always @(posedge clk) begin
      count = count + 1 ;   
   end // always
   
   assign clk_div = count[24] ;
   //assign clk_div = count[26] ;
   //assign clk_div = count[27] ;

   // BCD counter

   wire [3:0] BCD ;

   BCD_counter  counter(

      .clk  ( clk_div ),
      .rst  (     rst ),
      .BCD  (     BCD )

   ) ;      



   // 7-segment decoder

   seg_decoder  decoder(

      .BCD   (   BCD ),
      .segA  (  segA ),
      .segB  (  segB ),
      .segC  (  segC ),
      .segD  (  segD ),
      .segE  (  segE ),
      .segF  (  segF ),
      .segG  (  segG ),
      .segDP ( segDP )

   ) ;

   
endmodule
