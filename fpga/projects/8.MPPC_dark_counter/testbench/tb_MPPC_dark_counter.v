

`timescale 1ns / 100ps

module tb_MPPC_dark_counter ;

   reg clk = 1'b0 ;

   reg rst = 1'b1 ;

   reg start = 1'b0 ;


   reg disc_pulse = 1'b0 ;


   // 100 MHz clock generator (10 ns clock period)
   always #5 clk = ~clk ;




   
   MPPC_dark_counter   DUT(

      .clk        (        clk ),
      .rst        (        rst ),
      .start      (      start ),
      .disc_pulse ( disc_pulse )
      
      ) ;
   

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