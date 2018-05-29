
#-----------------------------------------------------------------------------------------------------
#                               University of Torino - Department of Physics
#                                   via Giuria 1 10125, Torino, Italy
#-----------------------------------------------------------------------------------------------------
# [Filename]       Makefile
# [Project]        Advanced Electronics Laboratory course
# [Author]         Luca Pacher - pacher@to.infn.it
# [Language]       GNU Makefile
# [Created]        Mar 05, 2016
# [Modified]       May 21, 2018
# [Description]    Simple Makefile to run a complete non-project mode FPGA implementation flow using
#                  Xilinx Vivado.
# [Notes]          Edit $(TCL_DIR)/xflow.tcl and $(TCL_DIR)/download.tcl Tcl scripts in order to fit 
#                  your current HDL design 
# [Version]        1.0
# [Revisions]      05.03.2015 - Created
#                  21.05.2018 - Replaced UNIX-only $(PWD) with native and portable $(CURDIR) variable
#-----------------------------------------------------------------------------------------------------


## Tcl scripts directory
TCL_DIR = $(CURDIR)/scripts


## log files directory
LOG_DIR = $(CURDIR)/log


## outputs directory (bitstream, checkpoint snapshots)
OUT_DIR = $(CURDIR)/results


## reports directory
RPT_DIR = $(CURDIR)/reports


## some useful aliases
RM = rm -f
RMDIR = rm -rf
MKDIR = mkdir -p

## include targets implementation file
include  $(TCL_DIR)/Makefile.defs

