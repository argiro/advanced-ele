
#-----------------------------------------------------------------------------------------------------
#                               University of Torino - Department of Physics
#                                   via Giuria 1 10125, Torino, Italy
#-----------------------------------------------------------------------------------------------------
# [Filename]      plotDataFromFile.py
# [Project]       Advanced Electronics Laboratory course
# [Author]        Luca Pacher - pacher@to.infn.it
# [Language]      Python/ROOT
# [Created]       May 15, 2017
# [Modified]      May 15, 2017
# [Description]   Plot and fit a set of x-data vs. y-data stored on an external plain text file
# 
# [Notes]         Run the script interactively using
#
#                    % python -i plotDataArray.py
#
# [Version]       1.0
# [Revisions]     15.05.2017 - Created
#-----------------------------------------------------------------------------------------------------


## import ROOT components
from ROOT import TGraph, gPad, gStyle, TFile


## create a TGraph object from file

## blank-separated values
gr = TGraph("data.dat")                     # this default is equivalent to TGraph("data.dat", "%lg %lg") 
#gr = TGraph("data.dat", "%lg %lg")          # **NOTE: %lg is C-syntax for long-double

## comma-separated values
#gr = TGraph("data.csv", "%lg , %lg")         # the more general syntax is "%lg charSeparator %lg" e.g. "%lg ; %lg"
gr.SetName("gr")


## set marker size and style
gr.SetMarkerStyle(21)
gr.SetMarkerSize(0.7)


## set line width and style
gr.SetLineWidth(1)
gr.SetLineStyle(1)


## plot title
gr.SetTitle("Some title")


## x-axis setup
gr.GetXaxis().SetTitle("x-data")
gr.GetXaxis().CenterTitle()
#gr.GetXaxis().SetRangeUser(...)
#gr.GetXaxis().SetNdivisions(...)
#gr.GetXaxis().SetTickLength(...)
#gr.GetXaxis().SetLabelOffset(...)
#gr.GetXaxis().SetLabelSize(...)
#gr.GetXaxis().SetLabelFont(...)
#gr.GetXaxis().SetTitleOffset(...)
#gr.GetXaxis().SetTitleSize(...)
#gr.GetXaxis().SetTitleFont(...)


## y-axis setup
gr.GetYaxis().SetTitle("y-data")
gr.GetYaxis().CenterTitle()
#gr.GetYaxis().SetRangeUser(...)
#gr.GetYaxis().SetNdivisions(...)
#gr.GetYaxis().SetTickLength(...)
#gr.GetYaxis().SetLabelOffset(...)
#gr.GetYaxis().SetLabelSize(...)
#gr.GetYaxis().SetLabelFont(...)
#gr.GetYaxis().SetTitleOffset(...)
#gr.GetYaxis().SetTitleSize(...)
#gr.GetYaxis().SetTitleFont(...)


## draw the object (a new TCanvas in created by default)
gr.Draw("AP")           # draw Axis and Points
#gr.Draw("ACP")         # draw Axis, Points and a Curve line between points
#gr.Draw("ALP")         # draw Axis, Points and a straight Line between points


gPad.SetGridx()
gPad.SetGridy()

## optionally, FIT experimental data with a pre-defined function

xMin = 0.8 
xMax = 8.2

#gr.Fit("pol2")
gr.Fit("pol2", "RV", "", xMin, xMax)           # linear fit (pol2 = quadratic fit, pol3 = cubic fit etc.)

## the Fit() method uses the following general syntax:
#
# Fit("function", "fitOptions", "graphicalOptions", xMin, xMax)
#
# "function" can be a predefined function (e.g. "gaus", "landau", "expo", "pol0", "pol1", etc.)
# or a user-defined TF1 object
#
# "graphicalOptions" are the same of the Draw() method for histograms and graphs, you can leave it empty ""
#
# "fitOptions" are used to specify fitter options. Most important are:
#
# "Q"  - quiet mode
# "V"  - verbose mode  (the default is between Q and V)
# "M"  - improve fit results 
# "L"  - use the log-likelihood method (by default, chi-square method is used)
# "N"  - don't plot the fit result superimposed to the histogram/graph in the GUI
# "+"  - in case of multiple fits, keep all previous fits (by default, only the last fit is saved)


## what type of object is returned using the GetFunction() method ?
fit = gr.GetFunction("pol2")

#print type(fit)


fit.SetNpx(1000)
fit.SetLineWidth(1)
#fit.SetLineColor(...)
#fit.SetLineStyle(...)
#fit.SetLineWidth(...)



## show fit results
gStyle.SetOptFit(1)


## update the GUI after cosmetics changes
gPad.Modified()
gPad.Update()


## save the plot into a ROOT file
f = TFile("myGraphFromFile.root", "recreate")
gr.Write()
f.Close()
