
//-----------------------------------------------------------------------------------------------------
//                               University of Torino - Department of Physics
//                                   via Giuria 1 10125, Torino, Italy
//-----------------------------------------------------------------------------------------------------
// [Filename]       scurve.cxx
// [Project]        Advanced Electronics Laboratory course
// [Author]         Luca Pacher - pacher@to.infn.it
// [Language]       ROOT/C++
// [Created]        May 23, 2016
// [Modified]       May 23, 2016
// [Description]    Simple un-named ROOT script to plot and fit a data set with an error function (s-curve)
// [Notes]          Execute the script at the ROOT command prompt with
//
//                     root[] .x scurve.cxx
//
// [Version]        1.0
// [Revisions]      23.05.2016 - Created
//-----------------------------------------------------------------------------------------------------


{
   gROOT->Reset();
   //gStyle->SetOptStat("emr");

   
   // set TDR style for plots
   gStyle->SetCanvasBorderSize(0);
   gStyle->SetCanvasBorderMode(0);
   //gStyle->SetCanvasDefH(600);
   //gStyle->SetCanvasDefW(600);

   //gStyle->SetGridStyle(0);
   //gStyle->SetGridWidth(1);
   //gStyle->SetGridColor(kBlack);

   TGraph *gr = new TGraph("scurve.txt", "%lg %lg");  // "%lg"
   
   
   
   //gPad->SetGridx();
   //gPad->SetGridy();

   
   
   gr->SetMarkerStyle(21);
   gr->SetMarkerSize(0.8); 
	  
	  
   gr->SetTitle("  ");
   gr->Draw("AP");	  

   /*

   // x-axis
   gr->GetXaxis()->SetRangeUser(800, 4000);
   gr->GetXaxis()->SetTitle("injected charge  [electrons]");
   gr->GetXaxis()->SetTitleFont(132);
   gr->GetXaxis()->SetTitleSize(0.055);
   gr->GetXaxis()->SetTitleOffset(1.1);
   gr->GetXaxis()->SetLabelFont(132);
   gr->GetXaxis()->SetLabelSize(0.04);




   // y-axis
   gr->GetYaxis()->SetRangeUser(0.001, 1.1);
   gr->GetYaxis()->SetTitle("efficiency");
   gr->GetYaxis()->CenterTitle();
   gr->GetYaxis()->SetTitleOffset(0.9);
   gr->GetYaxis()->SetTitleFont(132);
   gr->GetYaxis()->SetTitleSize(0.055);
   gr->GetYaxis()->SetLabelFont(132);
   gr->GetYaxis()->SetLabelSize(0.04);

   */

   // sigmoid fit
   TF1  *f = new TF1("f","[2]*(TMath::Erfc( ((x-[0])/[1] )/TMath::Sqrt(2) ) )", 0.0, 35.0); 

   f->SetParLimits(0, 0.0, 30.0);
   f->SetParLimits(1, 1.0, 10.0);
   f->SetParLimits(2, 0.0, 8176256);

   f->SetNpx(1000);
   f->SetLineColor(1);
   f->SetLineWidth(2);
   
   gr->Fit("f");
 


   double  mu    = f->GetParameter(0) ;
   double  sigma = f->GetParameter(1) ;  cout << sigma ;
   
   
   TF1  *f2 = new TF1("f2","gaus", 0.0, 35.0) ; 
   
   f2->SetNpx(1000);
   //f2->SetLineColor(1);
   f2->SetLineWidth(2);
   
   
   f2->SetParameter(0,5e6) ;
   f2->SetParameter(1,mu) ;
   f2->SetParameter(2,sigma) ;
   
   f2->Draw("same") ;
   
     
}
