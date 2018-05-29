
#-----------------------------------------------------------------------------------------------------
#                               University of Torino - Department of Physics
#                                   via Giuria 1 10125, Torino, Italy
#-----------------------------------------------------------------------------------------------------
# [Filename]       xflow.tcl
# [Project]        Advanced Electronics Laboratory course
# [Author]         Luca Pacher - pacher@to.infn.it
# [Language]       Tcl/Xilinx Vivado Tcl commands
# [Created]        Mar 23, 2016
# [Modified]       Apr 27, 2017
# [Description]    Tcl script to run the complete Xilinx Vivado implementation flow in non-project mode
# [Notes]          The script is executed by using
#
#                     linux% make xflow [aliased to make bit]
#
# [Version]        1.0
# [Revisions]      23.03.2016 - Created
#                  04.05.2016 - Added design reporting statements
#                  27.04.2017 - Removed UNIX-only $(PWD) references with OS-independent
#                               built-in [pwd] Tcl command
#-----------------------------------------------------------------------------------------------------



###########################################################
##   RTL SOURCES SETUP  (project-dependent parameters)   ##
###########################################################


## HDL sources directory
set RTL_DIR  [pwd]/../rtl


## top-level design module
set TOP  MPPC_dark_counter_UART
#set TOP  [find_top]

## list of HDL files
set RTL_SOURCES [list ${RTL_DIR}/MPPC_dark_counter_UART.v \
                      ${RTL_DIR}/debouncer.v              \
                      ${RTL_DIR}/BCD_counter_Ndigit.v     \
                      ${RTL_DIR}/BCD_counter_en.v         \
                      ${RTL_DIR}/seven_seg_decoder.v      \
                      ${RTL_DIR}/UART/BCD_to_char.v       \
                      ${RTL_DIR}/UART/uart_rx_dummy.v     \
                      ${RTL_DIR}/UART/uart_tx_dummy.v ]




####################################################################
##   DESIGN  IMPORT  (parse RTL sources and design constraints)   ##
####################################################################


## target FPGA (Digilent Arty7 development board)
set PART xc7a35ticsg324-1L


## design constraints directory
set XDC_DIR  [pwd]/../constraints


## scripts directory
set TCL_DIR  [pwd]/scripts


## results directory
set OUT_DIR  [pwd]/results


## reports directory
set RPT_DIR  [pwd]/reports


## read and parse HDL sources
read_verilog  ${RTL_SOURCES}

#read_verilog  ${VLOG_SOURCES}
#read_vhdl     ${VHDL_SOURCES}

#set_part ${PART}
#set_property top ${TOP} [current_fileset]



#########################
##   RTL ELABORATION   ##
#########################

## elaborate RTL source files into a schematic
synth_design -rtl -top ${TOP} -part ${PART} -flatten_hierarchy none -name rtl_1


##########################
##   MAPPED SYNTHESIS   ##
##########################

## read and parse design constraints
read_xdc  ${XDC_DIR}/${TOP}.xdc


## synthesize the design
synth_design -top ${TOP} -part ${PART} -flatten_hierarchy full -name syn_1


## write a database for the synthesized design
write_checkpoint -force ${OUT_DIR}/checkpoints/synthesis
#read_checkpoint -force ${OUT_DIR}/checkpoints/synthesis


## generate post-synthesis reports
report_utilization -file ${RPT_DIR}/synthesis/post_syn_utilization.rpt
report_timing -file ${RPT_DIR}/synthesis/post_syn_timing.rpt




###################
##   PLACEMENT   ##
###################

## place the design
place_design -verbose
#place_design -no_timing_driven -verbose


## write a database for the routed design
write_checkpoint -force ${OUT_DIR}/checkpoints/placement


## generate post-routing reports
report_utilization -file ${RPT_DIR}/placement/post_placement_utilization.rpt
report_timing -file ${RPT_DIR}/placement/post_placement_timing.rpt



#################
##   ROUTING   ##
#################

## route the design
route_design
#route_design -no_timing_driven -verbose


## write a database for the routed design
write_checkpoint -force ${OUT_DIR}/checkpoints/routing


## generate post-routing reports
report_utilization -file ${RPT_DIR}/routing/post_routing_utilization.rpt
report_timing -file ${RPT_DIR}/routing/post_routing_timing.rpt
report_power -file ${RPT_DIR}/routing/post_routing_power.rpt
report_drc -file ${RPT_DIR}/routing/post_routing_drc.rpt



###################
##   BITSTREAM   ##
###################


## generate bitstream
#write_bitstream -force ${OUT_DIR}/bitstream/${TOP}.bit
write_bitstream -force -bin_file ${OUT_DIR}/bitstream/${TOP}.bit


## optionally, download the bitstream to target FPGA
#source ${TCL_DIR}/download.tcl


## optionally, start the GUI and debug synthesis/place-and-route schematic results
#start_gui
#stop_gui

