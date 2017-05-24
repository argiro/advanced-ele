
#-----------------------------------------------------------------------------------------------------
#                               University of Torino - Department of Physics
#                                   via Giuria 1 10125, Torino, Italy
#-----------------------------------------------------------------------------------------------------
# [Filename]       MPPC_dark_counter_UART.xdc [FINAL LAB PROJECT]
# [Project]        Advanced Electronics Laboratory course
# [Author]         Luca Pacher - pacher@to.infn.it
# [Language]       Xilinx Design Constraints (XDC) Tcl commands
# [Created]        May  6, 2017
# [Modified]       May 22, 2017
# [Description]    Constraints file for MPPC dark-counter with UART TX unit.
# [Notes]          -
# [Version]        1.0
# [Revisions]      06.05.2017 - Created
#-----------------------------------------------------------------------------------------------------


#######################################
##   on-board 100 MHz clock signal   ##
#######################################

set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports clk]
create_clock -period 10.000 -name clk -waveform {0.000 5.000} -add [get_ports clk]



##################################
##   start/reset push-buttons   ##
##################################

set_property -dict { PACKAGE_PIN D9  IOSTANDARD LVCMOS33 } [get_ports start] ;  # BTN0 - START counting
set_property -dict { PACKAGE_PIN C9  IOSTANDARD LVCMOS33 } [get_ports rst] ;    # BTN1 - RESET count



#####################
##   status LEDs   ##
#####################

set_property -dict { PACKAGE_PIN H5  IOSTANDARD LVCMOS33 } [get_ports busy] ;     # LED0
set_property -dict { PACKAGE_PIN T10 IOSTANDARD LVCMOS33 } [get_ports finish] ;   # LED3



###############################################################################
##   dark-counter input pulse from comparator output or from a push-button   ##
###############################################################################

## **DEBUG: For test-purposes, map the DISC output as a push-button to check proper functionality
set_property -dict { PACKAGE_PIN B8  IOSTANDARD LVCMOS33 } [get_ports disc_pulse] ; # BTN3


## normal operations
#set_property -dict { PACKAGE_PIN U12  IOSTANDARD LVCMOS33 } [get_ports disc_pulse] ; # JC1_p


## **NOTE: Use the following statement to avoid placement/routing errors on input signal
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets disc_pulse_IBUF]



###########################################
##   7-segment display LEDs and anodes   ##
###########################################

## **NOTE: Use PMOD JA or JD headers for segments if you want to avoid placing series-resistors for LEDs
##         and JB or JC (without serires-resistors) to increase the brightness of the DIGITS !


set_property -dict { PACKAGE_PIN G13  IOSTANDARD LVCMOS33 } [get_ports segA] ;   # JA1
set_property -dict { PACKAGE_PIN B11  IOSTANDARD LVCMOS33 } [get_ports segB] ;   # JA2
set_property -dict { PACKAGE_PIN A11  IOSTANDARD LVCMOS33 } [get_ports segC] ;   # JA3
set_property -dict { PACKAGE_PIN D12  IOSTANDARD LVCMOS33 } [get_ports segD] ;   # JA4
set_property -dict { PACKAGE_PIN D13  IOSTANDARD LVCMOS33 } [get_ports segE] ;   # JA7
set_property -dict { PACKAGE_PIN B18  IOSTANDARD LVCMOS33 } [get_ports segF] ;   # JA8
set_property -dict { PACKAGE_PIN A18  IOSTANDARD LVCMOS33 } [get_ports segG] ;   # JA9


set_property -dict { PACKAGE_PIN E15   IOSTANDARD LVCMOS33 } [get_ports { seg_anode[0] }]
set_property -dict { PACKAGE_PIN E16   IOSTANDARD LVCMOS33 } [get_ports { seg_anode[1] }]
set_property -dict { PACKAGE_PIN D15   IOSTANDARD LVCMOS33 } [get_ports { seg_anode[2] }]
set_property -dict { PACKAGE_PIN C15   IOSTANDARD LVCMOS33 } [get_ports { seg_anode[3] }]
set_property -dict { PACKAGE_PIN J17   IOSTANDARD LVCMOS33 } [get_ports { seg_anode[4] }]
set_property -dict { PACKAGE_PIN J18   IOSTANDARD LVCMOS33 } [get_ports { seg_anode[5] }]
set_property -dict { PACKAGE_PIN K15   IOSTANDARD LVCMOS33 } [get_ports { seg_anode[6] }]
set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { seg_anode[7] }]



############################
##   USB/UART interface   ##
############################

set_property -dict { PACKAGE_PIN D10  IOSTANDARD LVCMOS33 } [get_ports TxD]



####################################
##   debug probe (oscilloscope)   ##
####################################

set_property -dict { PACKAGE_PIN V15  IOSTANDARD LVCMOS33 } [get_ports probe] ;   # IO_0
