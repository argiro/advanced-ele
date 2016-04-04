
#-----------------------------------------------------------------------------------------------------
#                               University of Torino - Department of Physics
#                                   via Giuria 1 10125, Torino, Italy
#-----------------------------------------------------------------------------------------------------
# [Filename]       inverter.xdc
# [Project]        Advanced Electronics Laboratory course
# [Author]         Luca Pacher - pacher@to.infn.it
# [Language]       Xilinx Design Constraints (XDC) Tcl commands
# [Created]        Mar 22, 2016
# [Modified]       Mar 22, 2016
# [Description]    Implementation constraints for Verilog modules inverter.v and inverter2.v
# [Notes]          All pin positions and electrical properties refer to the Digilent Arty 
#                  development board
# [Version]        1.0
# [Revisions]      22.03.2016 - Created
#-----------------------------------------------------------------------------------------------------


## slide switch SW0
set_property -dict {PACKAGE_PIN A8 IOSTANDARD LVCMOS33} [get_ports X]


## **NOTE - Instead of using a dictionary you can also spefify the pin position
## and the electrical standard independentely with the following less compact syntax:

#set_property PACKAGE_PIN  A8        [get_ports X]
#set_property IOSTANDARD   LVCMOS33  [get_ports X]



## RGB LED LED0
set_property -dict {PACKAGE_PIN E1 IOSTANDARD LVCMOS33} [get_ports ZN]
