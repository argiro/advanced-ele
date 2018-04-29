
//-----------------------------------------------------------------------------------------------------
//                               University of Torino - Department of Physics
//                                   via Giuria 1 10125, Torino, Italy
//-----------------------------------------------------------------------------------------------------
// [Filename]       tb_MPPC_dark_counter.v  [TESTBENCH]
// [Project]        Advanced Electronics Laboratory course
// [Authors]        <group members>
// [Language]       Verilog 2001 [IEEE Std. 1364-1995]
// [Created]        May 25, 2016
// [Modified]       May 25, 2016
// [Description]    Simple testbench code for the MPPC dark-counter 
// [Notes]          -
// [Version]        1.0
// [Revisions]      25.05.2016 - Created
//-----------------------------------------------------------------------------------------------------


`timescale 1ns / 100ps

module tb_MPPC_dark_counter ;


   // simulation signals
   reg clk = 1'b0 ;
   reg rst = 1'b1 ;
   reg start = 1'b0 ;
   reg disc_pulse = 1'b0 ;


   // 100 MHz clock generator (10 ns clock period)
   always #5 clk = ~clk ;


   // module under test
   MPPC_dark_counter   DUT(

      .clk        (        clk ),
      .rst        (        rst ),
      .start      (      start ),
      .disc_pulse ( disc_pulse )
      
      ) ;
   

   // main simulation stimulus
   initial begin
      #500  rst = 1'b0 ;

      #127  start = 1'b1 ;
      #1000 start = 1'b0 ;

      #1000 disc_pulse = 1'b1 ;
      #1000 disc_pulse = 1'b0 ;
      #5000 disc_pulse = 1'b1 ;
      #1000 disc_pulse = 1'b0 ;

      //#8000 $finish ;
   end

endmodule

