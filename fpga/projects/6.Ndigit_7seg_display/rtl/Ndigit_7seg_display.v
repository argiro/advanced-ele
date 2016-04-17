

// Dependences:
//
// $RTL_DIR/BCD_counter_Ndigit.v
// $RTL_DIR/sevenseg_decoder.v
// $RTL_DIR/BTN_debouncer.v

`timescale 1ns / 100ps

`define Ndigit 3

module Ndigit_7seg_display(

   input clk, rst, en,

   input BTN,
   
   output segA,
   output segB,
   output segC,
   output segD,
   output segE,
   output segF,
   output segG,
   output [2:0] seg_anode 
   
   ) ;

   // free-running counter
   reg [24:0] count ;
   
   always @(posedge clk) begin
      count <= count + 1 ;
   end
   
   // clock divider
   wire clk_div = count[22] ;    
   
   
   // control slice
   wire [1:0] count_slice ;
   assign count_slice = count[19:18] ;    // this choice determines the refresh frequency
   
   
   // optionally, add debouncing circuit
/* 
 
   wire BTN_debounced ;
   
   BTN_debouncer   debouncer(
   
      .btn     (            BTN ),
      .clk     (       count[2] ),    // use a 100 MHz/4 clock
      .LE_tick (                ),
      .FE_tick (                ),
      .pulse   (  BTN_debounced )
   ) ;
   
*/
   
   // 3-digit BCD counter
   wire [11:0] BCD ;

   BCD_counter_Ndigit  counter(

      //.clk  (  clk_div ),
      .clk  (      BTN ),
      //.clk  ( BTN_debounced ),
      .en   (       en ),
      .rst  (      rst ),
      .BCD  (      BCD )

   ) ;      


   // multiplex BCD slices
   
   reg [3:0] BCD_mux ;
   
   always @(*) begin
   
      case( count_slice )
   
         2'b00  :  BCD_mux <= BCD[3 :0] ;
         2'b01  :  BCD_mux <= BCD[7 :4] ;
         2'b10  :  BCD_mux <= BCD[11:8] ;
         
      endcase
   end
   
   
   // anodes decoder
   
   assign seg_anode[0] = ( count_slice == 2'b00 ) ? 1'b1 : 1'b0 ;
   assign seg_anode[1] = ( count_slice == 2'b01 ) ? 1'b1 : 1'b0 ;
   assign seg_anode[2] = ( count_slice == 2'b10 ) ? 1'b1 : 1'b0 ;
   

   //               _                  _
   // _____________/ \________________/ \____  seg_anode[2]
   //             _                  _
   // ___________/ \________________/ \______  seg_anode[1]
   //           _                  _
   // _________/ \________________/ \________  seg_anode[0]

   
   

   // 7-segment decoder

   seg_decoder  decoder(

      .BCD   (   BCD_mux ),
      .segA  (      segA ),
      .segB  (      segB ),
      .segC  (      segC ),
      .segD  (      segD ),
      .segE  (      segE ),
      .segF  (      segF ),
      .segG  (      segG ),
      .segDP (     segDP )

   ) ;


endmodule

