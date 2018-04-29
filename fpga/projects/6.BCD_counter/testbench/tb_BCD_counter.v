
//-----------------------------------------------------------------------------------------------------
//                               University of Torino - Department of Physics
//                                   via Giuria 1 10125, Torino, Italy
//-----------------------------------------------------------------------------------------------------
// [Filename]       tb_BCD_counter.v [TESTBENCH]
// [Project]        Advanced Electronics Laboratory course
// [Author]         Luca Pacher - pacher@to.infn.it
// [Language]       Verilog 2001 [IEEE Std. 1364-2001]
// [Created]        Mar 02, 2016
// [Modified]       May 09, 2016
// [Description]    Testbench for a single BCD counter
// [Notes]          -
// [Version]        1.0
// [Revisions]      02.03.2016 - Created
//-----------------------------------------------------------------------------------------------------



`timescale 1ns / 100ps

module tb_BCD_counter ;

   reg clk = 1'b0 ;
   reg rst = 1'b1 ;

   wire [3:0] LED ;

   // clock generator
   always #100 clk = ~clk ;

   
   BCD_counter   DUT(

      .clk (  clk ),
      .rst (  rst ),
      .BCD (  LED )
      
      ) ;
   

   initial begin
      #500 rst = 1'b0 ;
      #8000 $finish ;
   end

endmodule
