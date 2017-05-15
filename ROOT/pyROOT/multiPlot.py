
#-----------------------------------------------------------------------------------------------------
#                               University of Torino - Department of Physics
#                                   via Giuria 1 10125, Torino, Italy
#-----------------------------------------------------------------------------------------------------
# [Filename]      multiPlot.py
# [Project]       Advanced Electronics Laboratory course
# [Author]        Luca Pacher - pacher@to.infn.it
# [Language]      Python/ROOT
# [Created]       May 15, 2017
# [Modified]      May 15, 2017
# [Description]   Usage of TMultiGraph for multiple plots at the same time
# 
# [Notes]         Run the script interactively using
#
#                    % python -i multiPlot.py
#
# [Version]       1.0
# [Revisions]     15.05.2017 - Created
#-----------------------------------------------------------------------------------------------------


## import ROOT components
import ROOT

## import C-style arrays from the Python standard library
import array

## create an empty LIST to store TGraph/TGraphErrors objects
gr = []

## create a first TGraph, e.g. using arrays
xData = array.array('f', [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0] )
yData = array.array('f', [1.1, 1.9, 2.7, 4.2, 5.8, 6.3, 7.1, 7.9] )

gr.append( ROOT.TGraph( len(xData), xData, yData) )
gr[0].SetName("gr1")

## create a second TGraph, e.g. from file
gr.append( ROOT.TGraph("data.dat") )
gr[1].SetName("gr2")

## create a third TGraphErrors, e.g. from file
gr.append( ROOT.TGraphErrors("dataErrors.dat") )
gr[2].SetName("gr3")

## combine all plots into a single TMultiGraph
mgr = ROOT.TMultiGraph("mgr", "TMultiGraph example")

## add single plots to the multi-graph
mgr.Add( gr[0] )
mgr.Add( gr[1] )
mgr.Add( gr[2] )

## better solution for many plots...
#for i in range(len(gr) ) :
#	mgr.Add( gr[i] )

## draw the TMultiGraph
mgr.Draw("AP")


## markers
gr[0].SetMarkerStyle(21) ; gr[0].SetMarkerSize(0.7)
gr[1].SetMarkerStyle(25) ; gr[1].SetMarkerSize(0.7)
gr[2].SetMarkerStyle(20) ; gr[2].SetMarkerSize(0.9)


## cosmetics (axis, grids, log scales etc.)
mgr.GetXaxis().SetTitle("x-data")
mgr.GetYaxis().SetTitle("y-data")

#mgr.GetXaxis().CenterTitle()
#mgr.GetXaxis().SetLabelSize(...)
#mgr.GetXaxis().SetLabelFont(...)
#mgr.GetXaxis().SetTitleSize(...)
#mgr.GetXaxis().SetTitleFont(...)  etc.

ROOT.gPad.SetGridx()
ROOT.gPad.SetGridy()

#ROOT.gPad.SetLogx()
#ROOT.gPad.SetLogy()


## fit data with predefined functions
gr[0].Fit("pol1")
gr[1].Fit("pol2")


## additional cosmetics on fit functions
fit1 = gr[0].GetFunction("pol1") ; fit2 = gr[1].GetFunction("pol2")

fit1.SetNpx(10000)
fit1.SetLineWidth(1)
fit1.SetLineColor(ROOT.kRed)

fit2.SetNpx(10000)
fit2.SetLineWidth(1)
fit2.SetLineColor(ROOT.kBlue)


## make changes
ROOT.gPad.Modified()
ROOT.gPad.Update()


c2 = ROOT.TCanvas("c2", "New TCanvas")
c2.cd()
fit2.Draw()


