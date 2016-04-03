#-----------------------------------------------------------------------------------------------------
#                               University of Torino - Department of Physics
#                                   via Giuria 1 10125, Torino, Italy
#-----------------------------------------------------------------------------------------------------
# [File name]      run.tcl
# [Project]        Adavanced Elecrtonics Laboratory course
# [Author]         Luca Pacher - pacher@to.infn.it
# [Language]       Tcl/Xilinx Xsim Tcl simulation commands
# [Created]        Apr 04, 2016
# [Modified]       Apr 04, 2016
# [Description]    Sample simulation commands for the Xsim simulator
# [Notes]          -
# [Version]        1.0
# [Revisions]      04.04.2015 - Created
#-----------------------------------------------------------------------------------------------------


## choose which signals will be plotted in the waveform window
# wave_add ...


## run the entire simulatio until a $finish or a $stop statement is encountered in testbench
run all


## run the simulation for a certain amoutn of time
#run 720ns
#run 2.5us


## reset the simulation to t=0
#restart
