
#-----------------------------------------------------------------------------------------------------
#                               University of Torino - Department of Physics
#                                   via Giuria 1 10125, Torino, Italy
#-----------------------------------------------------------------------------------------------------
# [Filename]       flow.tcl
# [Project]        Advanced Electronics Laboratory course
# [Author]         Luca Pacher - pacher@to.infn.it
# [Language]       Tcl/Xilinx Vivado Tcl commands
# [Created]        Mar 23, 2016
# [Modified]       May 04, 2016
# [Description]    Tcl script to run the complete Xilinx Vivado implementation flow in non-project mode
# [Notes]          The script is executed by using
#
#                     linux% make flow
#
# [Version]        1.0
# [Revisions]      23.03.2016 - Created
#                  04.05.2016 - Added design reporting statements
#-----------------------------------------------------------------------------------------------------



###########################################################
##   RTL SOURCES SETUP  (project-dependent parameters)   ##
###########################################################


## HDL sources directory
set RTL_DIR  $::env(PWD)/../rtl


## top-level design module
set TOP  inverter


## list of HDL files
set RTL_SOURCES [list $RTL_DIR/inverter.v ]




####################################################################
##   DESIGN  IMPORT  (parse RTL sources and design constraints)   ##
####################################################################


## target FPGA (Digilent Arty development board)
set PART xc7a35ticsg324-1L


## design constraints directory
set XDC_DIR  $::env(PWD)/../constraints


## scripts directory
set TCL_DIR $::env(PWD)/scripts


## results directory
set OUT_DIR  $::env(PWD)/results


## reports directory
set RPT_DIR  $::env(PWD)/reports


## read and parse HDL sources
read_verilog  $RTL_SOURCES


#set_part $PART
#set_property top $TOP [current_fileset]


## read an parse design constraints
read_xdc  $XDC_DIR/$TOP.xdc




###################
##   SYNTHESIS   ##
###################


## synthesize the design
synth_design -top $TOP -part $PART


## write a database for the synthesized design
write_checkpoint -force $OUT_DIR/checkpoints/synthesis
#read_checkpoint -force $OUT_DIR/checkpoints/synthesis


## generate post-synthesis reports
report_utilization -file $RPT_DIR/synthesis/post_syn_utilization.rpt
report_timing -file $RPT_DIR/synthesis/post_syn_timing.rpt




###################
##   PLACEMENT   ##
###################

## place the design
place_design


## write a database for the routed design
write_checkpoint -force $OUT_DIR/checkpoints/placement


## generate post-routing reports
report_utilization -file $RPT_DIR/placement/post_placement_utilization.rpt
report_timing -file $RPT_DIR/placement/post_placement_timing.rpt



#################
##   ROUTING   ##
#################

## route the design
route_design


## write a database for the routed design
write_checkpoint -force $OUT_DIR/checkpoints/routing


## generate post-routing reports
report_utilization -file $RPT_DIR/routing/post_routing_utilization.rpt
report_timing -file $RPT_DIR/routing/post_routing_timing.rpt
report_power -file $RPT_DIR/routing/post_routing_power.rpt
report_drc -file $RPT_DIR/routing/post_routing_drc.rpt



###################
##   BITSTREAM   ##
###################


## generate bitstream
write_bitstream -force $OUT_DIR/bitstream/$TOP.bit


## optionally, download the bitstream to target FPGA
#source  $TCL_DIR/download.tcl


## optionally, start the GUI and debug synthesis/place-and-route results
#start_gui

