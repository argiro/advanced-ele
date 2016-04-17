
#-----------------------------------------------------------------------------------------------------
#                               University of Torino - Department of Physics
#                                   via Giuria 1 10125, Torino, Italy
#-----------------------------------------------------------------------------------------------------
# [Filename]       gates.xdc
# [Project]        Advanced Electronics Laboratory course
# [Author]         Luca Pacher - pacher@to.infn.it
# [Language]       Xilinx Design Constraints (XDC) Tcl commands
# [Created]        Mar 22, 2016
# [Modified]       Mar 22, 2016
# [Description]    Implementation constraints for Verilog modules gates.v and gates2.v
# [Notes]          All pin positions and electrical properties refer to the Digilent Arty 
#                  development board
# [Version]        1.0
# [Revisions]      22.03.2016 - Created
#-----------------------------------------------------------------------------------------------------


## slide swiches

set_property -dict { PACKAGE_PIN A8   IOSTANDARD LVCMOS33} [get_ports A ]
set_property -dict { PACKAGE_PIN C11  IOSTANDARD LVCMOS33} [get_ports B ]



## standard LEDs

set_property -dict { PACKAGE_PIN H5  IOSTANDARD LVCMOS33 } [get_ports { Z[0] }]
set_property -dict { PACKAGE_PIN J5  IOSTANDARD LVCMOS33 } [get_ports { Z[1] }]
set_property -dict { PACKAGE_PIN T9  IOSTANDARD LVCMOS33 } [get_ports { Z[2] }]
set_property -dict { PACKAGE_PIN T10 IOSTANDARD LVCMOS33 } [get_ports { Z[3] }]



## RGB LEDs (red-only)

set_property -dict { PACKAGE_PIN G6  IOSTANDARD LVCMOS33 } [get_ports { Z[4] }]
set_property -dict { PACKAGE_PIN G3  IOSTANDARD LVCMOS33 } [get_ports { Z[5] }]
