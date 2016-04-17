
#-----------------------------------------------------------------------------------------------------
#                               University of Torino - Department of Physics
#                                   via Giuria 1 10125, Torino, Italy
#-----------------------------------------------------------------------------------------------------
# [Filename]       LED_blink.xdc
# [Project]        Advanced Electronics Laboratory course
# [Author]         Luca Pacher - pacher@to.infn.it
# [Language]       Xilinx Design Constraints (XDC) Tcl commands
# [Created]        Mar 02, 2016
# [Modified]       Mar 02, 2016
# [Description]    Implementation constraints for Verilog module LED_blink.v
# [Notes]          All pin positions and electrical properties refer to the Digilent Arty
#                  development board
# [Version]        1.0
# [Revisions]      02.03.2016 - Created
#-----------------------------------------------------------------------------------------------------

## 100 MHz clock
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports clk]
create_clock -period 10.000 -name clk -waveform {0.000 5.000} -add [get_ports clk]


## standard LED (LED7)
set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33} [get_ports LED]

