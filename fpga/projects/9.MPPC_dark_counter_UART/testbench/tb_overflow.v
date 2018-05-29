`timescale 1ns / 1ps

module tb_overflow ;

   reg clk = 1'b0 ;
   always #5 clk = ~ clk ;

   reg rst_button = 1'b0 ;
   reg start_button = 1'b0 ;

   reg rx_lane = 1'b1 ;


   MPPC_dark_counter_UART DUT (

      .clk          (          clk ),
      .rst_button   ( reset_button ),
      .start_button ( start_button ),
      .RxD          (      rx_lane )

      ) ;


   initial begin

      #1000 rx_lane = 1'b0 ;
      #2000 rx_lane = 1'b1 ;

   end


endmodule

