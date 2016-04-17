
//-----------------------------------------------------------------------------------------------------
//                               University of Torino - Department of Physics
//                                   via Giuria 1 10125, Torino, Italy
//-----------------------------------------------------------------------------------------------------
// [Filename]       seven_seg_assign.v
// [Project]        Advanced Electronics Laboratory course
// [Author]         Luca Pacher - pacher@to.infn.it
// [Language]       Verilog 2001 [IEEE Std. 1364-2001]
// [Created]        Mar 16, 2016
// [Modified]       Mar 16, 2016
// [Description]    Simple driving module for a 7-segments display using logic constants
// [Notes]          -
// [Version]        1.0
// [Revisions]      16.03.2016 - Created
//-----------------------------------------------------------------------------------------------------


`timescale 1ns / 100ps

module seven_seg_assign(

   output  segA,
   output  segB,
   output  segC,
   output  segD,
   output  segE,
   output  segF,
   output  segG,
   output  segDP ) ;

                                                               //a b c d e f g DP
   assign {segA, segB, segC, segD, segE, segF, segG, segDP} = 8'b0_0_1_0_0_1_0_1 ;   // direct assignment of LED controls


endmodule
