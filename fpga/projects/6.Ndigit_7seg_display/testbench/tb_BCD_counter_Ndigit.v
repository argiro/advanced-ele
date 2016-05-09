
//-----------------------------------------------------------------------------------------------------
//                               University of Torino - Department of Physics
//                                   via Giuria 1 10125, Torino, Italy
//-----------------------------------------------------------------------------------------------------
// [Filename]       tb_BCD_counter_Ndigit.v [TESTBENCH]
// [Project]        Advanced Electronics Laboratory course
// [Author]         Luca Pacher - pacher@to.infn.it
// [Language]       Verilog 2001 [IEEE Std. 1364-2001]
// [Created]        Mar 02, 2016
// [Modified]       May 09, 2016
// [Description]    Testbench for N-digit BCD counter
// [Notes]          -
// [Version]        1.0
// [Revisions]      02.03.2016 - Created
//-----------------------------------------------------------------------------------------------------



`timescale 1ns / 100ps


module tb_BCD_counter_Ndigit ;

   reg clk = 1'b0 ;
   reg rst = 1'b1 ;

   reg en = 1'b0 ;


   wire [11:0] BCD ;

   wire [3:0] digit_0, digit_1, digit_2 ;

   assign digit_0 = BCD[3 :0] ;
   assign digit_1 = BCD[7 :4] ;
   assign digit_2 = BCD[11:8] ;


   // clock generator
   always #100 clk = ~clk ;




   BCD_counter_Ndigit   #(3) DUT(

      .clk (  clk ),
      .rst (  rst ),
      .en  (   en ),
      .BCD (  BCD )
      
      ) ;

   

   initial begin
      #500 rst = 1'b0 ;
      #800 en = 1'b1 ;
      //#600 en = 1'b0 ;
      #(200*1030) $finish ;
   end

endmodule

