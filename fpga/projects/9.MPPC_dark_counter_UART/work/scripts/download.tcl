
#-----------------------------------------------------------------------------------------------------
#                               University of Torino - Department of Physics
#                                   via Giuria 1 10125, Torino, Italy
#-----------------------------------------------------------------------------------------------------
# [Filename]       download.tcl
# [Project]        Advanced Electronics Laboratory course
# [Author]         Luca Pacher - pacher@to.infn.it
# [Language]       Tcl/Xilinx Vivado Tcl commands
# [Created]        Mar 23, 2016
# [Modified]       May 21, 2018
# [Description]    Standalone bitstream download script using Xilinx Vivado Hardware Manager Tcl commands
# [Notes]          The script is executed with:
#
#                     linux% make download
#
#                  Alternatively, source the script at the Vivado command prompt:
#
#                     vivado% source ./scripts/download.tcl
#
# [Version]        1.0
# [Revisions]      23.03.2016 - Created
#                  21.05.2018 - Removed UNIX-only $(PWD) references with OS-independent
#                               built-in [pwd] Tcl command
#-----------------------------------------------------------------------------------------------------

## project-dependent parameters
## design name
set TOP   MPPC_dark_counter_UART


## bitstream file
set OUT_DIR  [pwd]/results
set BITFILE  ${OUT_DIR}/bitstream/${TOP}.bit


## server setup (local machine) 
set SERVER   localhost
set PORT     3121


## connect to the server
open_hw
connect_hw_server -url ${SERVER}:${PORT} -verbose
puts "Current hardware server set to [get_hw_servers]"


## specify target FPGA
## manually
#current_hw_target  [get_hw_targets */xilinx_tcf/Digilent/210319788446A]

## automatically
open_hw_target
current_hw_device [lindex [get_hw_devices] 0]
refresh_hw_device -update_hw_probes false [lindex [get_hw_devices] 0]


## specify bitstream file
set_property  PROGRAM.FILE  ${BITFILE}  [lindex [get_hw_devices] 0]


## specify JTAG TCK frequency (Hz)
#set_property  PARAM.FREQUENCY  125000  [get_hw_targets */xilinx_tcf/Digilent/210319788783A]


## download the firmware to target FPGA
program_hw_devices  [lindex [get_hw_devices] 0]


## terminate the connection when done
disconnect_hw_server  [current_hw_server]

