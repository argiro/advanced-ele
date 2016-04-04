//-----------------------------------------------------------------------------------------------------
//                               University of Torino - Department of Physics
//                                   via Giuria 1 10125, Torino, Italy
//-----------------------------------------------------------------------------------------------------
// [File name]      inverter2.v
// [Project]        Adavanced Electronics Laboratory course
// [Author]         Luca Pacher - pacher@to.infn.it
// [Language]       Verilog 1995 [IEEE Std. 1364-1995]
// [Created]        Mar 02, 2016
// [Modified]       Mar 02, 2016
// [Description]    Simple Verilog description for a NOT-gate (inverter) using behavioural statements 
//                  similar to traditional software languages
// [Notes]          -
// [Version]        1.0
// [Revisions]      02.03.2016 - Created
//-----------------------------------------------------------------------------------------------------


`timescale 1ns / 100ps


module inverter(X, ZN) ;

   input  X  ;
   output ZN ;

   wire X  ;
   reg  ZN ;      // NOTE how the output is now defined as a VARIABLE



   // behavioural description using a PROCEDURAL BLOCK

   always @(X)
   begin
      if( X == 0 )     // all statements within this PROCEDURAL BLOCK are executed SEQUENTIALLY as in traditional software languages
         ZN = 1 ;      // WHENEWVER a signal specified in the SENSITIVITY LIST changes  
      else
         ZN = 0 ;
   end


endmodule

