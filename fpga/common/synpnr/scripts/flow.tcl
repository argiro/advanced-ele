
#-----------------------------------------------------------------------------------------------------
#                               University of Torino - Department of Physics
#                                   via Giuria 1 10125, Torino, Italy
#-----------------------------------------------------------------------------------------------------
# [Filename]       flow.tcl
# [Project]        Advanced Electronics Laboratory course
# [Author]         Luca Pacher - pacher@to.infn.it
# [Language]       Tcl/Xilinx Vivado Tcl commands
# [Created]        Mar 23, 2016
# [Modified]       Mar 29, 2016
# [Description]    Tcl script to run the complete Xilinx Vivado implementation flow in non-project mode
# [Notes]          The script is executed by using
#
#                     linux% make flow
#
# [Version]        1.0
# [Revisions]      23.03.2016 - Created
#-----------------------------------------------------------------------------------------------------

## HDL sources directory
set RTL_DIR  $::env(PWD)/../rtl

## project-dependent parameters

## top-level design module
set TOP  inverter

## list of HDL files
set RTL_SOURCES [list $RTL_DIR/inverter.v ]

######################################################################################################

## target FPGA (Digilent Arty development board)
set PART xc7a35ticsg324-1L


## design constraints directory
set XDC_DIR  $::env(PWD)/../constraints


## scripts directory
set TCL_DIR $::env(PWD)/scripts


## results directory
set OUT_DIR  $::env(PWD)/results


## read and parse HDL sources
read_verilog  $RTL_SOURCES


#set_part $PART
#set_property top $TOP [current_fileset]


## read an parse design constraints
read_xdc  $XDC_DIR/$TOP.xdc


## synthesize the design
synth_design -top $TOP -part $PART


## place the design
place_design


## route the design
route_design


## generate bitstream
write_bitstream -force $OUT_DIR/bitstream/$TOP.bit


## optionally, download the bitstream to target FPGA
source  $TCL_DIR/download.tcl
