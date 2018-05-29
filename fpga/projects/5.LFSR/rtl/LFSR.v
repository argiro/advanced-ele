
//-----------------------------------------------------------------------------------------------------
//                               University of Torino - Department of Physics
//                                   via Giuria 1 10125, Torino, Italy
//-----------------------------------------------------------------------------------------------------
// [Filename]       LFSR.v
// [Project]        Advanced Electronics Laboratory course
// [Author]         Luca Pacher - pacher@to.infn.it
// [Language]       Verilog 2001 [IEEE Std. 1364-2001]
// [Created]        Nov 21, 2017
// [Modified]       Nov 21, 2017
// [Description]    Simple Pseudo-Random Bit Sequence (PRBS) generator using a Linear Feedback
//                  Shift Register (LFSR)
// [Notes]          -
// [Version]        1.0
// [Revisions]      21.11.2017 - Created
//-----------------------------------------------------------------------------------------------------


`timescale 1ns / 1ps


module LFSR (

   input  wire clk,      // 100 MHz FPGA master clock
   output wire PRBS      // output pseudo-random bit sequence

   ) ;


   // free-running counter (clock divider)
   reg [3:0] count = 4'b0000 ;

   wire [3:0] count_max = 4'd3 ;

   always @(posedge clk)
      if(count == count_max)
         count <= 'b0 ;           // force the roll-over
      else
         count <= count + 1 ;


   wire clk_LFSR ;

   //assign clk_LFSR = clk ;              // 100 MHz
   //assign clk_LFSR = count[0] ;         // 50 MHz
   //assign clk_LFSR = count[1] ;           // 25 MHz


   reg [7:0] LFSR = 8'hFF ;               // seed


   /*
   always @(posedge clk_LFSR) begin       // **BAD design practice !!! Why ???

      LFSR[0] <= LFSR[7] ;
      LFSR[1] <= LFSR[0] ;
      LFSR[2] <= LFSR[1] ^ LFSR[7] ; 
      LFSR[3] <= LFSR[2] ^ LFSR[7] ;
      LFSR[4] <= LFSR[3] ^ LFSR[7] ;
      LFSR[5] <= LFSR[4] ;
      LFSR[6] <= LFSR[5] ;
      LFSR[7] <= LFSR[6] ;

   end   // always
   */

   always @(posedge clk) begin       // **GOOD design practice !!! Why ???

      if( count ==  ) begin

         LFSR[0] <= LFSR[7] ;
         LFSR[1] <= LFSR[0] ;
         LFSR[2] <= LFSR[1] ^ LFSR[7] ; 
         LFSR[3] <= LFSR[2] ^ LFSR[7] ;
         LFSR[4] <= LFSR[3] ^ LFSR[7] ;
         LFSR[5] <= LFSR[4] ;
         LFSR[6] <= LFSR[5] ;
         LFSR[7] <= LFSR[6] ;

      end
   end   // always

   assign PRBS = LFSR[7] ;

endmodule

