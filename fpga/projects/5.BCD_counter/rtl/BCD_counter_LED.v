
//-----------------------------------------------------------------------------------------------------
//                               University of Torino - Department of Physics
//                                   via Giuria 1 10125, Torino, Italy
//-----------------------------------------------------------------------------------------------------
// [Filename]       BCD_counter_LED.v
// [Project]        Advanced Electronics Laboratory course
// [Author]         Luca Pacher - pacher@to.infn.it
// [Language]       Verilog 2001 [IEEE Std. 1364-2001]
// [Created]        Mar 02, 2016
// [Modified]       May 09, 2016
// [Description]    Top-level wrapper for the free-running BCD counter
// [Notes]          -
// [Version]        1.0
// [Revisions]      02.03.2016 - Created
//-----------------------------------------------------------------------------------------------------


`timescale 1ns / 100ps


// Dependences:
//
// $RTL_DIR/BCD_counter.v


module BCD_counter_LED(

   input   clk,
   input   rst,
   output  [3:0] count_LED,
   output  carry_LED

   ) ;
   
   
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

   wire [3:0] BCD ;    //  4-bit internal bus


   BCD_counter BCD(

      .clk  ( clk_div ),
      .rst  (     rst ),
      .BCD  (     BCD )

   ) ;      

   assign count_LED = BCD ;
   assign carry_LED = ( BCD == 4'b1001 ) ? 1'b1 : 1'b0 ;


endmodule
