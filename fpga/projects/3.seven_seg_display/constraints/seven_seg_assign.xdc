
#-----------------------------------------------------------------------------------------------------
#                               University of Torino - Department of Physics
#                                   via Giuria 1 10125, Torino, Italy
#-----------------------------------------------------------------------------------------------------
# [Filename]       seven_seg_assign.xdc
# [Project]        Advanced Electronics Laboratory course
# [Author]         Luca Pacher - pacher@to.infn.it
# [Language]       Xilinx Design Constraints (XDC) Tcl commands
# [Created]        Mar 16, 2016
# [Modified]       Mar 16, 2016
# [Description]    Implementation constraints for Verilog module seven_seg_assign.v
# [Notes]          All pin positions and electrical properties refer to the Digilent Arty 
#                  development board
# [Version]        1.0
# [Revisions]      16.03.2016 - Created
#-----------------------------------------------------------------------------------------------------


## JA header mapping (but feel free to change the physical pin assignment)

set_property -dict { PACKAGE_PIN D13   IOSTANDARD LVCMOS33 } [get_ports segA  ]
set_property -dict { PACKAGE_PIN G13   IOSTANDARD LVCMOS33 } [get_ports segB  ]
set_property -dict { PACKAGE_PIN B18   IOSTANDARD LVCMOS33 } [get_ports segC  ]
set_property -dict { PACKAGE_PIN B11   IOSTANDARD LVCMOS33 } [get_ports segD  ]
set_property -dict { PACKAGE_PIN A18   IOSTANDARD LVCMOS33 } [get_ports segE  ]
set_property -dict { PACKAGE_PIN A11   IOSTANDARD LVCMOS33 } [get_ports segF  ]
set_property -dict { PACKAGE_PIN K16   IOSTANDARD LVCMOS33 } [get_ports segG  ]
set_property -dict { PACKAGE_PIN D12   IOSTANDARD LVCMOS33 } [get_ports segDP ]





