
//-----------------------------------------------------------------------------------------------------
//                               University of Torino - Department of Physics
//                                   via Giuria 1 10125, Torino, Italy
//-----------------------------------------------------------------------------------------------------
// [Filename]       inverter.v
// [Project]        Advanced Electronics Laboratory course
// [Author]         Luca Pacher - pacher@to.infn.it
// [Language]       Verilog 1995 [IEEE Std. 1364-1995]
// [Created]        Mar 02, 2016
// [Modified]       Mar 02, 2016
// [Description]    Simple Verilog description for a NOT-gate (inverter) using either a continuous
//                  assignment or a gate-primitive instantiation  
// [Notes]          -
// [Version]        1.0
// [Revisions]      02.03.2016 - Created
//-----------------------------------------------------------------------------------------------------


// this is a C-style single-line comment


/* this is another C-style comment
   but distributed across multiple lines */


`timescale 1ns / 100ps     // specify time-unit and time-precision, this is only for simulation purposes


module inverter(X, ZN) ;   // Verilog-95 port declaration

   input  X  ;
   output ZN ;

   wire X, ZN ;  // this is redountant, by default I/O ports are always considered NETS unless otherwise specified


   // continuous assignment
   assign ZN = ~ X ;


   // primitive instantiation
   //not(ZN, X) ;


endmodule

