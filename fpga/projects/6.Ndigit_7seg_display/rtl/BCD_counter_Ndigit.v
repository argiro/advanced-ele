
`timescale 1ns / 100ps


// Dependences:
//
// $RTL_DIR/BCD_counter_en.v



module BCD_counter_Ndigit(clk, rst, en, BCD) ;

   parameter Ndigit = 3 ;

   input clk ;
   input rst ;
   input en ;
   output [Ndigit*4-1:0] BCD ;



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
