
//-----------------------------------------------------------------------------------------------------
//                               University of Torino - Department of Physics
//                                   via Giuria 1 10125, Torino, Italy
//-----------------------------------------------------------------------------------------------------
// [Filename]       seven_seg_decoder.v
// [Project]        Advanced Electronics Laboratory course
// [Author]         <group>
// [Language]       Verilog 2001 [IEEE Std. 1364-1995]
// [Created]        -
// [Modified]       -
// [Description]    Complete the following code-skeleton to implement a BCD to 7-segments display
//                  decoder.
//
// [Notes]          Available 7-segments display modules are **COMMON ANODE** devices.
//
// [Version]        1.0
// [Revisions]      -
//-----------------------------------------------------------------------------------------------------

`timescale 1ns / 100ps

module seven_seg_decoder (

   input [3:0] BCD,

   output reg segA,
   output reg segB,
   output reg segC,
   output reg segD,
   output reg segE,
   output reg segF,
   output reg segG,
   output reg segDP  ) ;


   always @(*) begin
   
      case(BCD)
                                                                        //  a b c d e f g DP
         4'b0000  :  {segA, segB, segC, segD, segE, segF, segG, segDP} = 8'b0_0_0_0_0_0_1_1 ;  //  0
         4'b0001  :  {segA, segB, segC, segD, segE, segF, segG, segDP} = ...                ;  //  1
         4'b0010  :  {segA, segB, segC, segD, segE, segF, segG, segDP} = ...                ;  //  2
         4'b0011  :  {segA, segB, segC, segD, segE, segF, segG, segDP} = ...                ;  //  3
         4'b0100  :  {segA, segB, segC, segD, segE, segF, segG, segDP} = ...                ;  //  4
         4'b0101  :  {segA, segB, segC, segD, segE, segF, segG, segDP} = ...                ;  //  5
         4'b0110  :  {segA, segB, segC, segD, segE, segF, segG, segDP} = ...                ;  //  6
         4'b0111  :  {segA, segB, segC, segD, segE, segF, segG, segDP} = ...                ;  //  7
         4'b1000  :  {segA, segB, segC, segD, segE, segF, segG, segDP} = ...                ;  //  8
         4'b1001  :  {segA, segB, segC, segD, segE, segF, segG, segDP} = ...                ;  //  9

         default  :  {segA, segB, segC, segD, segE, segF, segG, segDP} = 8'b11111101 ; // minus sign otherwise

      endcase
   end

endmodule
