
//-----------------------------------------------------------------------------------------------------
//                               University of Torino - Department of Physics
//                                   via Giuria 1 10125, Torino, Italy
//-----------------------------------------------------------------------------------------------------
// [File name]      gates.v
// [Project]        Adavanced Electronics Laboratory course
// [Author]         <group>
// [Language]       Verilog 2001 [IEEE Std. 1364-2001]
// [Created]        -
// [Modified]       -
// [Description]    -                  
// [Notes]          Complete the following code-skeleton to implement basic logic operations using
//                  concurrent assignments
// [Version]        1.0
// [Revisions]      -
//-----------------------------------------------------------------------------------------------------


`timescale 1ns / 100ps


module gates(

   input  A,          // Verilog-2001 port declaration, more compact
   input  B,
   output [5:0] Z     // note that Z is a 6-bit width ouput BUS

   ) ;


   // Available Verilog logical operators are:
   // 
   // AND  &
   // OR   | 
   // NOT  ~
   // XOR  ^ 


   // AND
   assign Z[0] = ...


   // NAND
   assign Z[1] = ...


   // OR
   ...


   // NOR
   ...


   // XOR
   ...


   // XNOR
   ...



endmodule

