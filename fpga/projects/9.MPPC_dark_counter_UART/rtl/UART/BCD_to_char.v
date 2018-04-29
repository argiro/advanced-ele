
//-----------------------------------------------------------------------------------------------------
//                               University of Torino - Department of Physics
//                                   via Giuria 1 10125, Torino, Italy
//-----------------------------------------------------------------------------------------------------
// [Filename]       BCD_to_char.v  [FINAL LAB PROJECT]
// [Project]        Advanced Electronics Laboratory course
// [Authors]        Luca Pacher - pacher@to.infn.it
// [Language]       Verilog 2001 [IEEE Std. 1364-1995]
// [Created]        May 8, 2017
// [Modified]       May 8, 2017
// [Description]    BCD to ASCII converter.
// [Notes]          -
// [Version]        1.0
// [Revisions]      08.05.2017 - Created
//-----------------------------------------------------------------------------------------------------


// Dependencies:
//
// n/a


`timescale 1ns / 1ps


module BCD_to_char (

   input wire [3:0] BCD,
   output reg [7:0] char

   ) ;


   always @(*) begin   // pure combinational block

      case( BCD[3:0] )

         0 : char = 8'd48 ;         // or 8'h30
         1 : char = 8'd49 ;         // or 8'h31
         2 : char = 8'd50 ;         // or 8'h32
         3 : char = 8'd51 ;         // or 8'h33
         4 : char = 8'd52 ;         // or 8'h34
         5 : char = 8'd53 ;         // or 8'h35
         6 : char = 8'd54 ;         // or 8'h36
         7 : char = 8'd55 ;         // or 8'h37
         8 : char = 8'd56 ;         // or 8'h38
         9 : char = 8'd57 ;         // or 8'h39

         default : char = 8'd63 ;   // print '?' otherwise

      endcase
   end

endmodule
