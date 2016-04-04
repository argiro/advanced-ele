
//-----------------------------------------------------------------------------------------------------
//                               University of Torino - Department of Physics
//                                   via Giuria 1 10125, Torino, Italy
//-----------------------------------------------------------------------------------------------------
// [File name]      tb_inverter.v
// [Project]        Adavanced Electronics Laboratory course
// [Author]         Luca Pacher - pacher@to.infn.it
// [Language]       Verilog 1995 [IEEE Std. 1364-1995]
// [Created]        Mar 02, 2016
// [Modified]       Mar 02, 2016
// [Description]    Simple Verilog testbench for a NOT-gate (inverter) using an HDL stimulus
// [Notes]          -
// [Version]        1.0
// [Revisions]      02.03.2016 - Created
//-----------------------------------------------------------------------------------------------------


`timescale 1ns / 100ps

module tb_inverter ;    // this is a testbench module, that is a Verilog module without I/O ports


   // declare as VARIABLE (reg) the driving signal for our inverter
   reg switch ;


   // declare as NET (wire) the output driven by the inverter
   wire LED ;


   // instantiate the DUT (Device Under Test, aka Module Under Test)

   inverter  DUT(

      .X  (  switch ),    // the port-mapping is explicitely performed BY-NAME (recommended!)
      .ZN (     LED )

      ) ;



   // this is instead a port-mapping performed BY-POSITION, but please DON'T USE THIS STYLE
   // if you want to make your code more readable and to allow a much easier debug !

   //inverter   DUT(switch, LED) ;



   // stimulus generation using a sequential initial block
   // this is the second type of PROCEDURAL statement offered by the Verilog language, 
   // the code is executed only ONCE and it is used only for simulation purposes (NOT-synthesizable!)

   initial
   begin

      #0     switch = 1'b0 ;     // this is a better syntax to be used for logic constants, i.e. <size>'<radix><value> 
      #100   switch = 1'b1 ;
      #500   switch = 1'b0 ;
      #50    switch = 1'b1 ;     // all DELAYS are specified in terms of time-units

      #800   $finish ;           // Verilog offers many built-in functions (NOT-synthesizable!) named TASKS that can be used in testbenches 

   end


endmodule

