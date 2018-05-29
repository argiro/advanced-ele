
#-----------------------------------------------------------------------------------------------------
#                               University of Torino - Department of Physics
#                                   via Giuria 1 10125, Torino, Italy
#-----------------------------------------------------------------------------------------------------
# [Filename]       MPPC_dark_counter_UART.xdc [FINAL LAB PROJECT]
# [Project]        Advanced Electronics Laboratory course
# [Author]         Luca Pacher - pacher@to.infn.it
# [Language]       Xilinx Design Constraints (XDC) Tcl commands
# [Created]        May  6, 2017
# [Modified]       May 22, 2018
# [Description]    Constraints file for MPPC dark-counter with UART TX unit.
# [Notes]          -
# [Version]        1.0
# [Revisions]      06.05.2017 - Created
#                  22.05.2018 - Added test_mode, probes and UART RX
#-----------------------------------------------------------------------------------------------------


#######################################
##   on-board 100 MHz clock signal   ##
#######################################

set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports clk]
create_clock -period 10.000 -name clk -waveform {0.000 5.000} -add [get_ports clk]



##################################
##   start/reset push-buttons   ##
##################################

set_property -dict { PACKAGE_PIN D9  IOSTANDARD LVCMOS33 } [get_ports start_button] ;  # BTN0 - START counting
set_property -dict { PACKAGE_PIN C9  IOSTANDARD LVCMOS33 } [get_ports rst_button] ;    # BTN1 - RESET count



#####################
##   status LEDs   ##
#####################

set_property -dict { PACKAGE_PIN H5  IOSTANDARD LVCMOS33 } [get_ports busy] ;     # LED0
set_property -dict { PACKAGE_PIN T10 IOSTANDARD LVCMOS33 } [get_ports done] ;     # LED7
set_property -dict { PACKAGE_PIN G4  IOSTANDARD LVCMOS33 } [get_ports overflow]


###############################################################################
##   dark-counter input pulse from comparator output or from a push-button   ##
###############################################################################


## test-mode MUX
set_property -dict { PACKAGE_PIN A8 IOSTANDARD LVCMOS33 } [get_ports test_mode] ; # SW0


## **DEBUG: for test-purposes, map the DISC output as a push-button to check proper functionality
set_property -dict { PACKAGE_PIN B8  IOSTANDARD LVCMOS33 } [get_ports test_pulse] ; # BTN3


## normal operations
#
# **WARN: check wheter it is better to use a PMOD with or without 200 ohm series resistance !
#set_property -dict { PACKAGE_PIN K16  IOSTANDARD LVCMOS33 } [get_ports disc_pulse] ;              # JA[10], 200 ohm series resistance
set_property -dict { PACKAGE_PIN U12  IOSTANDARD LVCMOS33 } [get_ports disc_pulse] ;               # JC[1], **NO** 200 ohm series resistance

## **NOTE: Use the following statement to avoid placement/routing errors on input signal
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets disc_pulse_IBUF]



###########################################
##   7-segment display LEDs and anodes   ##
###########################################

## **NOTE: Use PMOD JA or JD headers for 7-segment display modules
##         if you want to avoid placing series-resistors for LEDs

## JA header
set_property -dict { PACKAGE_PIN G13  IOSTANDARD LVCMOS33 } [get_ports segA] ;   # JA[1], 200 ohm
set_property -dict { PACKAGE_PIN B11  IOSTANDARD LVCMOS33 } [get_ports segB] ;   # JA[2], 200 ohm
set_property -dict { PACKAGE_PIN A11  IOSTANDARD LVCMOS33 } [get_ports segC] ;   # JA[3], 200 ohm
set_property -dict { PACKAGE_PIN D12  IOSTANDARD LVCMOS33 } [get_ports segD] ;   # JA[4], 200 ohm
set_property -dict { PACKAGE_PIN D13  IOSTANDARD LVCMOS33 } [get_ports segE] ;   # JA[7], 200 ohm
set_property -dict { PACKAGE_PIN B18  IOSTANDARD LVCMOS33 } [get_ports segF] ;   # JA[8], 200 ohm
set_property -dict { PACKAGE_PIN A18  IOSTANDARD LVCMOS33 } [get_ports segG] ;   # JA[9], 200 ohm

## JD header
#set_property -dict { PACKAGE_PIN D4  IOSTANDARD LVCMOS33 } [get_ports segA] ;   # JD[1], 200 ohm
#set_property -dict { PACKAGE_PIN D3  IOSTANDARD LVCMOS33 } [get_ports segB] ;   # JD[1], 200 ohm
#set_property -dict { PACKAGE_PIN F4  IOSTANDARD LVCMOS33 } [get_ports segC] ;   # JD[1], 200 ohm
#set_property -dict { PACKAGE_PIN F3  IOSTANDARD LVCMOS33 } [get_ports segD] ;   # JD[1], 200 ohm
#set_property -dict { PACKAGE_PIN E2  IOSTANDARD LVCMOS33 } [get_ports segE] ;   # JD[1], 200 ohm
#set_property -dict { PACKAGE_PIN D2  IOSTANDARD LVCMOS33 } [get_ports segF] ;   # JD[1], 200 ohm
#set_property -dict { PACKAGE_PIN H2  IOSTANDARD LVCMOS33 } [get_ports segG] ;   # JD[1], 200 ohm

## anodes on header JB
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
set_property -dict { PACKAGE_PIN A9   IOSTANDARD LVCMOS33 } [get_ports RxD]



#####################################
##   debug probes (oscilloscope)   ##
#####################################

set_property -dict { PACKAGE_PIN V15  IOSTANDARD LVCMOS33 } [get_ports disc_pulse_probe] ;  # ChipKIT IO0
set_property -dict { PACKAGE_PIN U16  IOSTANDARD LVCMOS33 } [get_ports rx_probe] ;          # ChipKIT IO1
set_property -dict { PACKAGE_PIN P14  IOSTANDARD LVCMOS33 } [get_ports tx_probe] ;          # ChipKIT IO2


