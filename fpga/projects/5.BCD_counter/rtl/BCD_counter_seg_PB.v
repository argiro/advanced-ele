 
`timescale 1ns / 100ps 
 
// Dependences: 
// 
// $RTL_DIR/BCD_counter.v
// $RTL_DIR/seg_decoder.v 
 
//`define DEBOUNCE 
 
module BCD_counter_seg_PB( 
 
   input  BTN, 
   input  rst, 
 
   //input  clk, 
   
   output segA, 
   output segB, 
   output segC, 
   output segD, 
   output segE, 
   output segF, 
   output segG, 
   output segDP ) ; 
 

 
   // enable/disable the usage of a single-pulse generator as a debouncer
    
   `ifdef DEBOUNCE 
   reg q0, q1, q2 ; 
    
   always @(posedge clk) begin 
      q0 <= BTN ; 
      q1 <= q0 ; 
      q2 <= q0 & (~q1) ; 
   end 
   `endif 
    
   // BCD counter 
 
   wire [3:0] BCD ;
 
   BCD_counter  counter(
 
      .clk  (  BTN ), 
      .rst  (  rst ), 
      .BCD  (  BCD )
 
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
