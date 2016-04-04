
#-----------------------------------------------------------------------------------------------------
#                               University of Torino - Department of Physics
#                                   via Giuria 1 10125, Torino, Italy
#-----------------------------------------------------------------------------------------------------
# [File name]      inverter.xdc
# [Project]        Adavanced Electronics Laboratory course
# [Author]         Luca Pacher - pacher@to.infn.it
# [Language]       Xilinx Design Constraints (XDC) Tcl commands
# [Created]        Mar 05, 2016
# [Modified]       Mar 05, 2016
# [Description]    Implementation constraints for Verilog modules inverter.v and inverter2.v
# [Notes]          All pin positions refer to Digilent Arty development board
# [Version]        1.0
# [Revisions]      05.03.2016 - Created
#-----------------------------------------------------------------------------------------------------


## slide switch SW0
set_property -dict {PACKAGE_PIN A8 IOSTANDARD LVCMOS33} [get_ports X]


## RGB LED LED0
set_property -dict {PACKAGE_PIN E1 IOSTANDARD LVCMOS33} [get_ports ZN]
