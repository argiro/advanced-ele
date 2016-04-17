

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