
`timescale 1ns / 1ps

module tb_LFSR ;

   reg clk = 1'b0 ;   // 100 MHz FPGA clock

   always #10 clk = ~ clk ;


   wire PRBS ;

   LFSR   DUT (.clk(clk), .PRBS(PRBS) ) ;

endmodule




