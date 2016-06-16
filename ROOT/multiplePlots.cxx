
//-----------------------------------------------------------------------------------------------------
//                               University of Torino - Department of Physics
//                                   via Giuria 1 10125, Torino, Italy
//-----------------------------------------------------------------------------------------------------
// [Filename]       multiplePlots.cxx
// [Project]        Advanced Electronics Laboratory course
// [Author]         Luca Pacher - pacher@to.infn.it
// [Language]       ROOT/C++
// [Created]        May 23, 2016
// [Modified]       May 23, 2016
// [Description]    Simple un-named ROOT script to plot and fit multiple sets of x-data vs. y-data
//                  stored on external plain text files
// [Notes]          Execute the script at the ROOT command prompt with
//
//                     root[] .x multiplePlots.cxx
//
// [Version]        1.0
// [Revisions]      23.05.2016 - Created
//-----------------------------------------------------------------------------------------------------


{
   gROOT->Reset() ;

   //TGraphErrors  gr1("fileName1.txt") ;
   //TGraphErrors  gr2("fileName2.txt") ;

   
   TGraphErrors  *gr[2] ;    // you can also work with C++ arrays of objects (better solution, you can then use standard for-loops)
   
   gr[0] = new TGraphErrors("dataErrors.txt") ;
   gr[1] = new TGraphErrors("dataErrors2.txt") ;
   
   
   gr[0]->SetMarkerStyle(25) ; gr[0]->SetMarkerSize(0.8) ;
   gr[1]->SetMarkerStyle(21) ; gr[1]->SetMarkerSize(0.8) ;
   
   
   // you can combine several TGraph/TGraphErrors using TMultiGraph
   TMultiGraph  *mgr = new TMultiGraph() ;

   
   //mgr->Add( gr[0] ) ;
   //mgr->Add( gr[1] ) ;   

   // or you can use a much simpler C++ for-loop
   for(int i = 0 ; i < 2; ++i){ mgr->Add( gr[i] ) ; }
   
   mgr->SetTitle("plot title") ;
   
   mgr->Draw("AP") ;
   
   // x-axis setup
   mgr->GetXaxis()->SetTitle("x-axis [unit]") ;
   //mgr->GetXaxis()->CenterTitle() ;
   //mgr->GetXaxis()->SetRangeUser(...) ;
   //mgr->GetXaxis()->SetNdivisions(...) ;
   //mgr->GetXaxis()->SetTickLength(...) ;
   //mgr->GetXaxis()->SetLabelOffset(...) ;
   //mgr->GetXaxis()->SetLabelSize(...) ;  
   //mgr->GetXaxis()->SetLabelFont(...) ; 
   //mgr->GetXaxis()->SetTitleOffset(...) ;
   //mgr->GetXaxis()->SetTitleSize(...) ;   
   //mgr->GetXaxis()->SetTitleFont(...) ; 
   
   // y-axis setup
   mgr->GetYaxis()->SetTitle("y-axis [unit]") ;
   //mgr->GetYaxis()->CenterTitle() ;   
   //mgr->GetYaxis()->SetRangeUser(...) ;
   //mgr->GetYaxis()->SetNdivisions(...) ;
   //mgr->GetYaxis()->SetTickLength(...) ;
   //mgr->GetYaxis()->SetLabelOffset(...) ;
   //mgr->GetYaxis()->SetLabelSize(...) ;  
   //mgr->GetYaxis()->SetLabelFont(...) ; 
   //mgr->GetYaxis()->SetTitleOffset(...) ;
   //mgr->GetYaxis()->SetTitleSize(...) ;   
   //mgr->GetYaxis()->SetTitleFont(...) ; 

   
   // optionally, FIT experimental data with a pre-defined function

   double xMin = 0.0 ;
   double xMax = 12.0 ;
   
   gr[0]->Fit("pol1", "", "", xMin, xMax) ;         // linear fit (pol2 = quadratic fit, pol3 = cubic fit etc.)
   
   
   // if you need to work on fit results, retrieve a pointer to the fit function
   
   TF1 *fit = gr[0]->GetFunction("pol1") ;
   
   double po, p1 ;
   
   p0 = fit->GetParameter(0) ;
   p1 = fit->GetParameter(1) ;   
   
   printf("Fit results: p0 = %f  p1 = %f \n", p0, p1 ) ;
   
   // show fit results
   gStyle->SetOptFit(1) ;
   
   // add grids to the canvas
   //gStyle->SetGridStyle(0);
   //gStyle->SetGridWidth(1);
   //gStyle->SetGridColor(kBlack);
   gPad->SetGridx();
   gPad->SetGridy();

   // in case you need to set a Log scale
   //gPad->SetLogx() ;
   gPad->SetLogy() ;
   
   // update the canvas
   gPad->Modified();
   gPad->Update();
   
   
} // end script


