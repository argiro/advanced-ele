#-----------------------------------------------------------------------------------------------------
#                               University of Torino - Department of Physics
#                                   via Giuria 1 10125, Torino, Italy
#-----------------------------------------------------------------------------------------------------
# [Filename]       run.tcl
# [Project]        Advanced Electronics Laboratory course
# [Author]         Luca Pacher - pacher@to.infn.it
# [Language]       Tcl/Xilinx Vivado Tcl commands
# [Created]        Apr 04, 2016
# [Modified]       Apr 04, 2016
# [Description]    Sample simulation commands for the Xsim simulator
# [Notes]          -
# [Version]        1.0
# [Revisions]      04.04.2016 - Created
#-----------------------------------------------------------------------------------------------------


## choose which signals will be plotted in the waveform window
# add_wave /tb_module/clk
# add_wave /tb_module/rst
# add_wave /tb_module/DUT/rst


## run the entire simulation until a $finish or a $stop statement is encountered in the testbench
run all


## run the simulation for a certain amount of time
#run 720 ns
#run 2.5 us


## reset the simulation to t=0
#restart
