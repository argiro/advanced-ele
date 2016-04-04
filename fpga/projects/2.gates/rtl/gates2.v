
//-----------------------------------------------------------------------------------------------------
//                               University of Torino - Department of Physics
//                                   via Giuria 1 10125, Torino, Italy
//-----------------------------------------------------------------------------------------------------
// [Filename]       gates2.v
// [Project]        Advanced Electronics Laboratory course
// [Author]         <group>
// [Language]       Verilog 2001 [IEEE Std. 1364-2001]
// [Created]        -
// [Modified]       -
// [Description]    -                  
// [Notes]          Complete the following code-skeleton to implement basic logic operations using 
//                  behavioural statements
// [Version]        1.0
// [Revisions]      -
//-----------------------------------------------------------------------------------------------------


`timescale 1ns / 100ps


module gates(

   input  A,              // Verilog-2001 port declaration, more compact
   input  B,
   output reg [5:0] Z     // **QUESTION - Why Z is now declared as reg ?

   ) ;


   // Available Verilog logical operators are:
   // 
   // AND  &
   // OR   | 
   // NOT  ~
   // XOR  ^ 



   // AND
   always @(*) begin

      case( {A,B} )        //  concatenation operator { , }, that's why Verilog uses begin/end instead of standard C/C++ brackets {}

         2'b00 :  Z[0] = 1'b0 ;
         2'b01 :  Z[0] = 1'b0 ;
         2'b10 :  Z[0] = 1'b0 ;
         2'b11 :  Z[0] = 1'b1 ;

      endcase
   end  // always



   // NAND
   ...



   // OR
   ...



   // NOR
   ...



   // XOR
   ...


   // XNOR
   ...


endmodule

