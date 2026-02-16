//+------------------------------------------------------------------+
//|                                           StressTestGeometry.mq4 |
//|                                  Copyright 2026, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart() {
   Print("=== STARTING GEOMETRY STRESS TEST ===");
   
   // We will simulate 3 different Volatility Environments
   double simulatedATR[] = {0.0005, 0.0015, 0.0030}; // Quiet, Normal, Wild (Pips)
   
   for(int a = 0; a < 3; a++) {
      double atr = simulatedATR[a];
      double floor = atr * 0.30; // Our 30% Structural Floor
      
      PrintFormat(">>> ENVIRONMENT: ATR = %.5f | Structural Floor = %.5f", atr, floor);
      Print("----------------------------------------------------------");
      
      // Simulate Slow Slopes from "Flat" to "Powerful"
      for(double sSlope = 0.0000; sSlope <= (atr * 0.6); sSlope += (atr * 0.1)) {
         
         // Simulate a "Perfect Fan" where Fast is 1.5x Medium, and Medium is 1.2x Slow
         double mSlope = sSlope * 1.2;
         double fSlope = mSlope * 1.5;
         
         // 1. Check Floor Logic
         string floorStatus = (sSlope >= floor) ? "SOLID" : "HOLLOW";
         
         // 2. Check Ratio Logic (Fast / Slow)
         double rawRatio = (sSlope > 0) ? (fSlope / sSlope) : 0;
         
         // 3. Map to fMSR_norm (your 0.8/0.5/0.1 logic)
         double fMSR_norm = 0;
         if(rawRatio > 0.80)      fMSR_norm = 1.00;
         else if(rawRatio > 0.50) fMSR_norm = 0.75;
         else if(rawRatio > 0.10) fMSR_norm = 0.30;
         
         // 4. THE VETO: If floor is hollow, fMSR is forced to 0
         double finalFMSR = (sSlope >= floor) ? fMSR_norm : 0.00;

         PrintFormat("SlowSlope: %.5f | Ratio: %.2f | Floor: %s | FINAL fMSR: %.2f", 
                     sSlope, rawRatio, floorStatus, finalFMSR);
      }
      Print(" ");
   }
   Print("=== STRESS TEST COMPLETE ===");
}
//+------------------------------------------------------------------+
