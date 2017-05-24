
//-----------------------------------------------------------------------------------------------------
//                               University of Torino - Department of Physics
//                                   via Giuria 1 10125, Torino, Italy
//-----------------------------------------------------------------------------------------------------
// [Filename]       BCD_counter_Ndigit.v
// [Project]        Advanced Electronics Laboratory course
// [Author]         Luca Pacher - pacher@to.infn.it
// [Language]       Verilog 2001 [IEEE Std. 1364-2001]
// [Created]        Mar 02, 2016
// [Modified]       May 09, 2016
// [Description]    Parameterizable N-digit BCD counter
// [Notes]          -
// [Version]        1.0
// [Revisions]      02.03.2016 - Created
//-----------------------------------------------------------------------------------------------------


`timescale 1ns / 100ps


// Dependences:
//
// $RTL_DIR/BCD_counter_en.v



module BCD_counter_Ndigit(clk, rst, en, BCD) ;

   parameter  Ndigit = 3 ;

   input   clk ;
   input   rst ;
   input   en ;
   output  [Ndigit*4-1:0] BCD ;



   wire [Ndigit:0] carryout ;   // roll-over flags

   assign carryout[0] = en ;


   generate
      genvar k ;

      for(k = 0; k < Ndigit; k = k+1) begin : digit  

         BCD_counter_en   digit(

            .clk      (             clk ),
            .rst      (             rst ),
            .en       (     carryout[k] ),
            .BCD      (  BCD[4*k+3:4*k] ),
            .carryout (   carryout[k+1] )

         ) ;

      end // for

   endgenerate

endmodule
