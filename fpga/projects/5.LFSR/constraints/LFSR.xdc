
#-----------------------------------------------------------------------------------------------------
#                               University of Torino - Department of Physics
#                                   via Giuria 1 10125, Torino, Italy
#-----------------------------------------------------------------------------------------------------
# [Filename]       LFSR.xdc
# [Project]        Advanced Electronics Laboratory course
# [Author]         Luca Pacher - pacher@to.infn.it
# [Language]       Xilinx Design Constraints (XDC) Tcl commands
# [Created]        Nov 21, 2017
# [Modified]       Nov 21, 2017
# [Description]    Implementation constraints for Verilog module LFSR.v
# [Notes]          All pin positions and electrical properties refer to the Digilent Arty
#                  development board
# [Version]        1.0
# [Revisions]      21.11.2017 - Created
#-----------------------------------------------------------------------------------------------------


## on-board 100 MHz clock
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports clk]
create_clock -period 10.000 -name clk -waveform {0.000 5.000} -add [get_ports clk]


## map PRBS output to PMOD JA, pin 1
set_property -dict {PACKAGE_PIN G13 IOSTANDARD LVCMOS33} [get_ports PRBS]

