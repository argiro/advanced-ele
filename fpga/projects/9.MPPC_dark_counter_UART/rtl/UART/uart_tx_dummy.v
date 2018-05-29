
//-----------------------------------------------------------------------------------------------------
//                               University of Torino - Department of Physics
//                                   via Giuria 1 10125, Torino, Italy
//-----------------------------------------------------------------------------------------------------
// [Filename]       uart_tx_Nbytes.v  [FINAL LAB PROJECT]
// [Project]        Advanced Electronics Laboratory course
// [Authors]        Luca Pacher - pacher@to.infn.it
// [Language]       Verilog 2001 [IEEE Std. 1364-1995]
// [Created]        May 6, 2017
// [Modified]       May 8, 2017
// [Description]    Simplified UART TX unit using a one-hot bit counter to keep track of data-alignment.
//                  Additional implementations using FSM are available too.
//
// [Notes]          Use the Nbytes Verilog parameter to customize the number of BYTES (ASCII characters)
//                  transmitted over RS-232 serial protocol.
//
// [Version]        1.0
// [Revisions]      06.05.2017 - Created
//-----------------------------------------------------------------------------------------------------


// Dependencies:
//
// n/a


`timescale 1ns / 1ps


module uart_tx_Nbytes (clk, tx_start, tx_en, tx_data, tx_lane) ;

   parameter Nbytes = 1 ;

   input wire clk ;                            // on-board 100 MHz system clock 
   input wire tx_start ;                       // start of transmission (e.g. a push-button or a single-clock pulse flag, more in general from a FIFO-empty flag)
   input wire tx_en ;                          // single-clock pulse enable, determines the proper Baud-rate
   input wire [(Nbytes*8)-1:0] tx_data ;       // data-width of payload data to be trasmitted
   output reg tx_lane ;                        // serial output stream 


   // create a one-hot bit counter to keep track of data alignment

   reg [Nbytes*(1+8+1):0] bit_count ;

   always @(posedge clk ) begin

      if( tx_start == 1'b1 ) begin
         bit_count[0]                 <= 1'b1 ;              // reset shift register outputs with 1000 ... 00000
         bit_count[Nbytes*(1+8+1):1] <= 'b0  ;
      end

      else if( tx_en == 1'b1 )
         bit_count[Nbytes*(1+8+1):0] <= { bit_count[Nbytes*(1+8+1)-1:0] , 1'b0 } ;   // shift-right using concatenation, just once per Baud-rate "tick"

   end   // always


   // compose the TX serial stream according to RS-232 standard

   integer k ;

   always @(posedge clk ) begin

      tx_lane <= 1'b1 ;                                                                    // IDLE

      // loop over the number of bytes to be trasmitted
      for( k = 0; k < Nbytes; k = k+1 ) begin    

            if( bit_count[1 + 10*k] == 1'b1 ) tx_lane <= 1'b0 ;                            // START bit

            else if( bit_count[ 2 + 10*k] == 1'b1 ) tx_lane <= tx_data[0 + 8*k] ;          // LSB first
            else if( bit_count[ 3 + 10*k] == 1'b1 ) tx_lane <= tx_data[1 + 8*k] ;
            else if( bit_count[ 4 + 10*k] == 1'b1 ) tx_lane <= tx_data[2 + 8*k] ;
            else if( bit_count[ 5 + 10*k] == 1'b1 ) tx_lane <= tx_data[3 + 8*k] ;
            else if( bit_count[ 6 + 10*k] == 1'b1 ) tx_lane <= tx_data[4 + 8*k] ;
            else if( bit_count[ 7 + 10*k] == 1'b1 ) tx_lane <= tx_data[5 + 8*k] ;
            else if( bit_count[ 8 + 10*k] == 1'b1 ) tx_lane <= tx_data[6 + 8*k] ;
            else if( bit_count[ 9 + 10*k] == 1'b1 ) tx_lane <= tx_data[7 + 8*k] ;

            else if( bit_count[10 + 10*k] == 1'b1 ) tx_lane <= 1'b1 ;                      // STOP bit

      end   // for k
   end   // always

endmodule

