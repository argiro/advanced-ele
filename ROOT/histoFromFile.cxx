
//-----------------------------------------------------------------------------------------------------
//                               University of Torino - Department of Physics
//                                   via Giuria 1 10125, Torino, Italy
//-----------------------------------------------------------------------------------------------------
// [Filename]       histoFromFile.cxx
// [Project]        Advanced Electronics Laboratory course
// [Author]         Luca Pacher - pacher@to.infn.it
// [Language]       ROOT/C++
// [Created]        Jun 01, 2016
// [Modified]       Jun 01, 2016
// [Description]    Simple un-named ROOT script to histogram and fit a set of data stored on an external
//                  plain text files
// [Notes]          Execute the script at the ROOT command prompt with
//
//                     root[] .x histoFromFile.cxx
//
// [Version]        1.0
// [Revisions]      01.06.2016 - Created
//-----------------------------------------------------------------------------------------------------


{
   gROOT->Reset() ;
   gStyle->SetOptStat("emr") ;   // show into the statistics box the number of Entries, the Mean and the RMS  
  

   double  xMin  = 0.0 ;
   double  xMax  = 2.0 ;
   int     Nbins = 6 ;
   
   TH1F *histo = new TH1F("histo", "HistogramTitle", Nbins, xMin, xMax) ;   
   
   
   // input file
   ifstream fileName("histoRawData.txt") ; 

   // value ;
   double xval;

   // read data from ASCII file   
   while(fileName >> xval){
   
      histo->Fill(xval) ;
	  printf("Reading value %g \n", xval) ;
   }
   
   fileName.close();
  
   //gPad->SetGridx();
   //gPad->SetGridy();
 

   
   // for a 'bare' histogram with just white bars
   histo->SetFillStyle(0);
   histo->Draw("BAR");

   
   
   // x-axis
   histo->GetXaxis()->SetTitle("x-values [unit]");
   //histo->GetXaxis()->SetTitleFont(132);
   //histo->GetXaxis()->SetTitleSize(0.055);
   //histo->GetXaxis()->SetTitleOffset(1.1);
   //histo->GetXaxis()->SetLabelFont(132);
   //histo->GetXaxis()->SetLabelSize(0.04);




   // y-axis
   histo->GetYaxis()->SetRangeUser(0.0, 6.0);
   histo->GetYaxis()->SetTitle("entries / <bin width>");
   histo->GetYaxis()->CenterTitle();
   //histo->GetYaxis()->SetTitleOffset(0.9);
   //histo->GetYaxis()->SetTitleFont(132);
   //histo->GetYaxis()->SetTitleSize(0.055);
   //histo->GetYaxis()->SetLabelFont(132);
   //histo->GetYaxis()->SetLabelSize(0.04);

   
   // optionally, FIT experimental data with a pre-defined function

   //double xMin = 0.0 ;
   //double xMax = 2.0 ;
   
   histo->Fit("gaus", "", "", xMin, xMax) ;         // gaussian fit
      
   // if you need to work on fit results, retrieve a pointer to the fit function
   
   TF1 *fit = histo->GetFunction("gaus") ;
   
   double po, p1 ;
   
   p0 = fit->GetParameter(0) ;
   p1 = fit->GetParameter(1) ;   
   
   printf("Fit results: p0 = %f  p1 = %f \n", p0, p1 ) ;
   
   // show fit results
   //gStyle->SetOptFit(1) ;
  
   
   
   gPad->Modified();
   gPad->Update();
   
   
}
