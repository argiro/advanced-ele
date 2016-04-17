
//-----------------------------------------------------------------------------------------------------
//                               University of Torino - Department of Physics
//                                   via Giuria 1 10125, Torino, Italy
//-----------------------------------------------------------------------------------------------------
// [Filename]       LED_blink.v
// [Project]        Advanced Electronics Laboratory course
// [Author]         Luca Pacher - pacher@to.infn.it
// [Language]       Verilog 2001 [IEEE Std. 1364-2001]
// [Created]        Mar 02, 2016
// [Modified]       Mar 02, 2016
// [Description]    LED blinker using a clock divider
// [Notes]          -
// [Version]        1.0
// [Revisions]      02.03.2016 - Created
//-----------------------------------------------------------------------------------------------------


`timescale 1ns / 100ps

module LED_blink(

   input clk,                        // 100 MHz external clock from on-board oscillator
   output LED ) ;


   // 28-bit free-running counter   
   reg [27:0] count ;

   always @(posedge clk) begin
      count = count + 1 ;            // **QUESTION - Where is the RESET for this counter ?
   end


   
   //assign LED = count[24] ;        // **QUESTION - Which is the blink frequency of the LED ?
   //assign LED = count[25] ;
   //assign LED = count[26] ;
   assign LED = count[27] ;

endmodule

