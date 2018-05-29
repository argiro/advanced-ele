
//-----------------------------------------------------------------------------------------------------
//                               University of Torino - Department of Physics
//                                   via Giuria 1 10125, Torino, Italy
//-----------------------------------------------------------------------------------------------------
// [Filename]       uart_tx_dummy.v  [FINAL LAB PROJECT]
// [Project]        Advanced Electronics Laboratory course
// [Authors]        Luca Pacher - pacher@to.infn.it
// [Language]       Verilog 2001 [IEEE Std. 1364-1995]
// [Created]        May 22, 2018
// [Modified]       May 22, 2018
// [Description]    Dummy UART RX unit to issue a 'start' from PC through on-board USB/UART bridge.
//                  This moduke assumes to have an all-zeroes payload (i.e. the 'NULL' ASCII character
//                  is sent from PC) and just detects the IDLE-to-START transition.
//                  A realistic implementation uses a FSM to oversample and de-serialize input data
//                  and a FIFO to properly interface the receiver with the user logic.
// [Notes]          -
// [Version]        1.0
// [Revisions]      22.05.2018 - Created
//-----------------------------------------------------------------------------------------------------


// Dependencies:
//
// n/a


`timescale 1ns / 1ps

module uart_rx_dummy (

   input  wire clk,                   // on-board 100 MHz system clock
   input  wire rx_lane,               // serial input stream
   output wire rx_probe,              // **DEBUG: send the re-synched serial input stream to oscilloscope probe
   output wire start_uart             // start flag generated from this dummy UART RX unit

   ) ;


   ///////////////////////////////
   //   clock-domain crossing   //
   ///////////////////////////////

   // as a first step, re-synchronize the serial input stream with the FPGA clock domain

   reg q0 = 1'b1 ;
   reg q1 = 1'b1 ;
   reg q2 = 1'b1 ;

   always @(posedge clk) begin         // **NOTE: these DFFs are just delay elements! No need for a dedicated reset !
      q0 <= rx_lane ;
      q1 <= q0 ;
      q2 <= q1 ;
   end

   wire rx_lane_synch ;
   assign rx_lane_synch = q2 ;         // this signal is now properly synch. with the on-boad 100 MHz clock



   /////////////////////////////////
   //   IDLE-to-START detection   //
   /////////////////////////////////

   // normally, rx_lane = 1'b1, the communication starts with a 1->0 transition

   reg start_ff = 1'b0 ;

   always @(posedge clk) begin
      if(rx_lane_synch == 1'b0)
         start_ff = 1'b1 ;                // IDLE to START detected, then assume all-zeroes payload (NULL ASCII character, 0x00)
       else
         start_ff = 1'b0 ;
   end   // always

   assign start_uart = start_ff ;         // then a single-clock pulse is generated in top-level module



   ////////////////////////////
   //   oscilloscope probe   //
   ////////////////////////////

   assign rx_probe = rx_lane_synch ;   // buffer the re-synch. signal to oscilloscope probe
   //assign rx_probe = start_ff ;


endmodule


