
#-----------------------------------------------------------------------------------------------------
#                               University of Torino - Department of Physics
#                                   via Giuria 1 10125, Torino, Italy
#-----------------------------------------------------------------------------------------------------
# [Filename]       Makefile
# [Project]        Advanced Electronics Laboratory course
# [Author]         Luca Pacher - pacher@to.infn.it
# [Language]       GNU Makefile
# [Created]        Mar 05, 2016
# [Modified]       Mar 05, 2016
# [Description]    Simple Makefile to run HDL simulations using Xilinx Vivado XSim simulator
# [Notes]          Edit the code in order to proper include HDL sources for your current design
# [Version]        1.0
# [Revisions]      05.03.2016 - Created
#-----------------------------------------------------------------------------------------------------


## simulation directory
SIM_DIR = ${PWD}/


## HDL sources directory
RTL_DIR = $(SIM_DIR)/../rtl


## testbench sources directory
TB_DIR = $(SIM_DIR)/../testbench


## top-level design module
TOP = tb_inverter


## list of HDL sources
RTL_SOURCES = $(RTL_DIR)/inverter.v


## list of testbench sources
TB_SOURCES = $(TB_DIR)/tb_inverter.v


## log files directory
LOG_DIR = $(SIM_DIR)/log


## compiled libraries directory
LIB_DIR = $(SIM_DIR)/lib



## work library (logical name, mapping to physical directory is contained in xsim.ini file)
WORK = worklib


## Verilog compiler executable
CC = xvlog


## compiler options 
CCFLAGS = --log $(LOG_DIR)/compile.log --work $(WORK)


## elaborator executable
LD = xelab


## elaborator options

SNAPSHOT = $(TOP).exe
LDFLAGS = --snapshot $(SNAPSHOT) --verbose 0 --log $(LOG_DIR)/elaborate.log --debug all


## simulator executable
SIM = xsim


## simulator options
SIMFLAGS = --log $(LOG_DIR)/simulation.log -gui


## some useful aliases
RM = rm -f
RMDIR = rm -rf



## include targets implementation file
include ./Makefile.defs
