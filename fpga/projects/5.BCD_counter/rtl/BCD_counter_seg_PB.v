

//-----------------------------------------------------------------------------------------------------
//                               University of Torino - Department of Physics
//                                   via Giuria 1 10125, Torino, Italy
//-----------------------------------------------------------------------------------------------------
// [Filename]       BCD_counter_seg_PB.v
// [Project]        Advanced Electronics Laboratory course
// [Author]         Luca Pacher - pacher@to.infn.it
// [Language]       Verilog 2001 [IEEE Std. 1364-2001]
// [Created]        Mar 02, 2016
// [Modified]       May 09, 2016
// [Description]    Top-level wrapper for BCD counter and 7-segment display modules
// [Notes]          Counter input clock mapped to external push-button
// [Version]        1.0
// [Revisions]      02.03.2016 - Created
//-----------------------------------------------------------------------------------------------------

 


`timescale 1ns / 100ps 
 
// Dependences: 
// 
// $RTL_DIR/BCD_counter.v
// $RTL_DIR/seven_seg_decoder.v


module BCD_counter_seg_PB(
 
   input   BTN, 
   input   rst, 
   output  segA, 
   output  segB, 
   output  segC, 
   output  segD, 
   output  segE, 
   output  segF, 
   output  segG ) ; 



   // BCD counter 
 
   wire [3:0] BCD ;   // internal 4-bit bus, required to interconnect the BCD counter with the 7-segment display decoder
 
   BCD_counter  counter(
 
      .clk  (  BTN ),   // input clock mapped to a push-button
      .rst  (  rst ), 
      .BCD  (  BCD )
 
   ) ;       



   // 7-segment display decoder

   seven_seg_decoder  decoder(

      .BCD   (   BCD ),
      .segA  (  segA ),
      .segB  (  segB ),
      .segC  (  segC ),
      .segD  (  segD ),
      .segE  (  segE ),
      .segF  (  segF ),
      .segG  (  segG ),
      .segDP (       )     // leave unconnected

   ) ;
 
    
endmodule 
