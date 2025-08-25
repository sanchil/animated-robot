//+------------------------------------------------------------------+
//|                                                SanStrategies.mqh |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <Sandeep/v1/SanSignals-v1.mqh>
#include <Sandeep/v1/SanHSIG-v1.mqh>
#include <Sandeep/v1/SanSignalTypes-v1.mqh>


ORDERPARAMS       op1;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class SanStrategies {
 private:
   int  ticket;
   
 public:
   SanStrategies();
   SanStrategies(SanSignals &sig, const INDDATA &indData, int shift);
   ~SanStrategies();

   SS s;
   SanSignals si;
   HSIG h;
   INDDATA iData;

   SIGBUFF           imaSt1(const INDDATA &indData);
   string            getJsonData(const INDDATA &indData,SANSIGNALS &s, HSIG &h,SanUtils& util,int shift=1);
   bool              writeOHLCVJsonData(string filename, const INDDATA &indData, SanUtils& util,int shift=1);

};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SanStrategies::SanStrategies() {

}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SanStrategies::SanStrategies(SanSignals &sig, const INDDATA &indData, int shift):s(sig,indData,shift),h(s,util) {
   iData = indData;
   si = sig;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SanStrategies::~SanStrategies() {
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SIGBUFF SanStrategies::imaSt1(const INDDATA &indData) {

   SIGBUFF sigBuff;
   iData = indData;
// Print("imaSt1: ima30 current 1: "+indData.ima30[1]+" :ima30 5: "+ indData.ima30[5]+" :ima30 10: "+ indData.ima30[10]+" :21:" + indData.ima30[21]);
// Set the trade strategy used by EA to open and close trades
   sigBuff.buff3[0]=(int)STRATEGYTYPE::IMACLOSE;

   int totalOrders=OrdersTotal();
//  util.initTrade();
   SAN_SIGNAL tradePosition = SAN_SIGNAL::NOSIG;
   SAN_SIGNAL dominantSIG = SAN_SIGNAL::NOSIG;
//SAN_SIGNAL dominantTrendSIG = SAN_SIGNAL::NOSIG;
//SAN_SIGNAL dominantTrendCPSIG = SAN_SIGNAL::NOSIG;
//SAN_SIGNAL mainFastSIG = SAN_SIGNAL::NOSIG;
//SAN_SIGNAL slopeFastSIG = SAN_SIGNAL::NOSIG;
//SAN_SIGNAL rsiFastSIG = SAN_SIGNAL::NOSIG;
   SAN_SIGNAL commonSIG = SAN_SIGNAL::NOSIG;
//   SANTREND cp120SIG = SANTREND::NOTREND;



   if(totalOrders>0) {
      for(int i=0; i<totalOrders; i++) {
         if(OrderSelect(i,SELECT_BY_POS)) {
            if(OrderType()==OP_BUY)
               tradePosition=SAN_SIGNAL::BUY;
            if(OrderType()==OP_SELL)
               tradePosition=SAN_SIGNAL::SELL;
            if((OrderType()!=OP_SELL)&&(OrderType()!=OP_BUY)&&(OrderType()!=OP_SELLLIMIT)&&(OrderType()!=OP_BUYLIMIT)&&(OrderType()!=OP_SELLSTOP)&&(OrderType()!=OP_BUYSTOP))
               tradePosition=SAN_SIGNAL::NOSIG;
         }
      }
   }

   if(util.isNewBar()) {
      op1.NEWCANDLE = true;
      op1.TRADED=false;
      op1.MAXPIPS=0;
   }
   if(!(util.isNewBar()) && (totalOrders > 0)) {
      op1.NEWCANDLE = false;
      op1.TRADED=true;
   }

   TRENDSTRUCT tRatioTrend;

   int SHIFT = (indData.shift || 1);


   SS ss(sig,indData,SHIFT);
   s = ss;
   SAN_SIGNAL openSIG = SAN_SIGNAL::NOSIG;
   SAN_SIGNAL closeSIG = SAN_SIGNAL::NOSIG;

// ################# Open Signal ###################################################

   bool spreadBool = (indData.currSpread < tl.spreadLimit);

//################################################################
//################################################################
   bool openOrder = (op1.NEWCANDLE && (totalOrders==0));
   bool closeOrder = (!op1.NEWCANDLE && (totalOrders>0));
   SANTREND slopeTrendSIG = ss.trendRatioSIG;
   SIGMAVARIABILITY varSIG = ss.ima120SDSIG;
   bool spreadVolBool = (spreadBool && (ss.volSIG==SAN_SIGNAL::TRADE));


//################################################################
//################################################################

//   bool trendBool = (sb.healthyTrendBool && sb.healthyTrendStrengthBool && !sb.flatTrendBool);
   bool atrBool = ((ss.atrSIG == SANTRENDSTRENGTH::NORMAL)||(ss.atrSIG == SANTRENDSTRENGTH::HIGH));
   bool sig5TrendBool = ((ss.sig5!=SAN_SIGNAL::NOSIG) && (ss.sig5==ss.priceActionSIG) && (ss.sig5==ss.adxSIG) && atrBool);
//   bool tradeBool = (ss.tradeSIG==SAN_SIGNAL::TRADE);
   bool mfiSIGBool = ((ss.mfiSIG == SAN_SIGNAL::BUY)||(ss.mfiSIG == SAN_SIGNAL::SELL));
   bool mfiTradeTrendBool = (ss.mfiSIG==util.convTrendToSig(slopeTrendSIG));
   bool slopeTrendBool = ((slopeTrendSIG==SANTREND::UP)||(slopeTrendSIG==SANTREND::DOWN));

//########################################################################################

   DataTransport varDt = sig.varSIG(ss.ima30SDSIG,ss.ima120SDSIG,ss.ima240SDSIG);
   bool varPosBool = varDt.matrixBool[0];
   bool varNegBool = varDt.matrixBool[1];
   bool varFlatBool = varDt.matrixBool[2];
   bool varBool = varDt.matrixBool[3];


//########################################################################################


   bool noVolWindPressure = ((ss.volSIG==SAN_SIGNAL::REVERSETRADE)||(ss.volSIG==SAN_SIGNAL::CLOSE));
//bool noVarBool = (variabilityVal==0);
   bool noVarBool = (!varBool);

   bool candleVol120Bool = (((ss.candleVol120SIG==SAN_SIGNAL::SELL)&&varNegBool)||((ss.candleVol120SIG==SAN_SIGNAL::BUY)&&varPosBool));
   bool slopeVarBool = (ss.slopeVarSIG==SAN_SIGNAL::SELL||ss.slopeVarSIG==SAN_SIGNAL::BUY);

   HSIG hSig(ss, util);
   h = hSig;
   dominantSIG = sig.dominantTrendSIG(ss,hSig);

   bool notFlatBool = (varBool && (varPosBool||varNegBool) && (hSig.mktType==MKTTYP::MKTTR));
   bool flatBool = (varFlatBool && (hSig.mktType==MKTTYP::MKTFLAT));

//##################################################################################
   bool basicOpenVolBool = (spreadVolBool && notFlatBool);
   bool basicOpenBool = (spreadBool);
//##################################################################################


   bool slopeTrendVarBool = (basicOpenBool && slopeTrendBool);
   bool candleVolVar120Bool = (basicOpenVolBool && candleVol120Bool);

   bool fastOpenTrade1 = (spreadBool  && (ss.candleImaSIG!=SAN_SIGNAL::NOSIG));
//   bool fastOpenTrade2 = (spreadBool && sb.starBool);
   bool fastOpenTrade3 = ((hSig.dominantTrendSIG!=SAN_SIGNAL::NOSIG)&&((hSig.slopeFastSIG==hSig.dominantTrendSIG) || (hSig.mainFastSIG==hSig.dominantTrendSIG)));
   bool fastOpenTrade4 = (slopeTrendVarBool && (ss.ima1430SIG!=SAN_SIGNAL::NOSIG) && (ss.ima1430SIG==hSig.dominantTrendSIG));   // ss.ima514SIG
   bool fastOpenTrade5 = (slopeTrendVarBool && (ss.slopeVarSIG!=SAN_SIGNAL::NOSIG) && (ss.slopeVarSIG==hSig.dominantTrendSIG));  // ss.slopeVarSIG
   bool fastOpenTrade6 = (candleVolVar120Bool && (ss.candleVol120SIG!=SAN_SIGNAL::NOSIG) && (ss.candleVol120SIG==hSig.dominantTrendSIG));  // ss.candleVol120SIG
//
//// #################################################################################
   bool fastOpenTrade10 = (fastOpenTrade3||fastOpenTrade4||fastOpenTrade5||fastOpenTrade6);
   //bool fastOpenTrade11 = (slopeTrendVarBool && (dominantSIG!=SAN_SIGNAL::NOSIG) && (dominantSIG!=SAN_SIGNAL::CLOSE) && (dominantSIG!=SAN_SIGNAL::SIDEWAYS));
   bool fastOpenTrade11 = (basicOpenBool && ((dominantSIG==SAN_SIGNAL::BUY)||(dominantSIG==SAN_SIGNAL::SELL)));
   bool fastOpenTrade12 = (fastOpenTrade11 && (dominantSIG==hSig.mainFastSIG));
   bool fastOpenTrade13 = (fastOpenTrade11 && (dominantSIG==hSig.slopeFastSIG));
//   bool fastOpenTrade14 = (fastOpenTrade11 && (dominantSIG==hSig.rsiFastSIG));
   bool fastOpenTrade15 = (slopeTrendVarBool && (ss.fsig5!=SAN_SIGNAL::NOSIG) && (ss.fsig5!=SAN_SIGNAL::CLOSE));


   bool closeLoss = (ss.lossSIG == SAN_SIGNAL::CLOSE);
//bool closeProfitLoss = ((_Period >= PERIOD_M1) && (ss.profitPercentageSIG == SAN_SIGNAL::CLOSE));
   bool closeProfitLoss = ((_Period >= PERIOD_M1) && (ss.profitSIG == SAN_SIGNAL::CLOSE));

   bool closeTrade1 = (noVolWindPressure && (
                          (ss.candleVol120SIG==SAN_SIGNAL::SIDEWAYS)
                          ||(ss.slopeVarSIG==SAN_SIGNAL::SIDEWAYS)
                          ||(ss.trendRatioSIG==SANTREND::FLAT)
                          ||(ss.trendRatioSIG==SANTREND::FLATUP)
                          ||(ss.trendRatioSIG==SANTREND::FLATDOWN)));

   bool closeTrade2 = ((dominantSIG == SAN_SIGNAL::CLOSE)||(util.oppSignal(dominantSIG,tradePosition)));
   bool closeTradeL1 = (closeTrade2);

//#################################################################################

//#################################################################################
// Open and close signals
//#################################################################################
   bool openCandleIma = (fastOpenTrade1);
   bool openTradeTrend = (fastOpenTrade3);//||fastOpenTrade4);
   bool openSlope = (fastOpenTrade11);//||fastOpenTrade4);
   bool openCandleVol = (fastOpenTrade12||fastOpenTrade13);
//   bool openStar = (fastOpenTrade2);
//   bool closeFlatTrade = (spreadBool &&  ((flatBool)||(dominantSIG==SAN_SIGNAL::SIDEWAYS)));
   bool closeFlatTrade = (spreadBool && (dominantSIG==SAN_SIGNAL::SIDEWAYS));

   bool closeTrade = (closeTradeL1);
   bool noCloseConditions = (!closeFlatTrade);

//#################################################################################

//   stats.hilbertTransform(indData.close,ss.hilbertAmp,ss.hilbertPhase,21,5);
//   stats.dftTransform(indData.close,ss.dftMag,ss.dftPhase,ss.dftPower,8);

   //stats.hilbertTransform(indData.close,hilbertAmp,ss.hilbertPhase,21,5);
//   double iSIg[] =  {147.404, 147.393, 147.385, 147.389,0,0,0,0};

//   stats.dftTransform(iSIg,ss.dftMag,ss.dftPhase,ss.dftPower,8);
//   stats.hilbertTransform(iSIg,ss.hilbertAmp,ss.hilbertPhase,8,3);
   
   
   bool shortCycle = false;
   bool longCycle = false;
   bool allCycle = false;

   if(false && closeOrder && closeLoss) {
      closeSIG = SAN_SIGNAL::CLOSE;
      sigBuff.buff3[0] = (int)STRATEGYTYPE::CLOSEPOSITIONS;
      Print("[imaSt1]: closeLoss CLOSE detected:."+ util.getSigString(closeSIG));
   } else if(false && closeOrder && closeProfitLoss) {
      closeSIG = SAN_SIGNAL::CLOSE;
      sigBuff.buff3[0] = (int)STRATEGYTYPE::CLOSEPOSITIONS;
      Print("[imaSt1]: profitPercentage CLOSE detected:."+ util.getSigString(closeSIG));
   } else if(false && closeOrder && closeFlatTrade) {
      closeSIG = SAN_SIGNAL::CLOSE;
      sigBuff.buff3[0] = (int)STRATEGYTYPE::CLOSEPOSITIONS;
      Print("[imaSt1]: closeFlatTrade CLOSE detected:."+ util.getSigString(closeSIG));
   } else if(openTradeTrend && noCloseConditions && allCycle) {
      commonSIG=ss.ima1430SIG;
      if(openOrder)
         openSIG = commonSIG;
      closeSIG = commonSIG;
      commonSIG=SAN_SIGNAL::NOSIG;
   } else if(openSlope && noCloseConditions) {
      commonSIG=dominantSIG;
      if(openOrder)
         openSIG = commonSIG;
      closeSIG = commonSIG;
      // Print("[imaSt1]: openSlope OPEN and CLOSE detected:."+ openSlope+" SIG: "+util.getSigString(commonSIG));
      commonSIG=SAN_SIGNAL::NOSIG;
   } else if(openCandleVol && noCloseConditions && allCycle) {
      commonSIG=dominantSIG;
      if(openOrder)
         openSIG = commonSIG;
      closeSIG = commonSIG;
      commonSIG=SAN_SIGNAL::NOSIG;
   } else if(openCandleIma && allCycle) {
      commonSIG=ss.candleImaSIG;
      if(openOrder)
         ss.openSIG = commonSIG;
      ss.closeSIG = commonSIG;
   } else if(true && closeOrder && closeTrade) { // && !openCandleIma)// && !slowMfi)
      closeSIG = SAN_SIGNAL::CLOSE;
      sigBuff.buff3[0] = (int)STRATEGYTYPE::CLOSEPOSITIONS;
      Print("[imaSt1]: closeTrade: "+closeTrade+" close detected: "+ util.getSigString(closeSIG));
      //util.writeData("close_order.txt",""[imaSt1]: closeTrade4: "+closeTrade5+" close detected: "+ util.getSigString(ss.closeSIG));
   }



   //if(!closeTrade)
   if((!closeFlatTrade)&&(!closeTrade))
      ss.openSIG = openSIG;
   ss.closeSIG = closeSIG;



//##############################################################################################
//##############################################################################################

   sigBuff.buff1[0]=(int)ss.openSIG;
   sigBuff.buff2[0]=(int)ss.closeSIG;
//sigBuff.buff4[0] = (int)ss.tradeSIG;
   sigBuff.buff4[0] = (int)hSig.mktType;


   //double c[];
   //stats.sigMeanDeTrend(indData.close,c,5);
   //Print("DETREND: c0: "+c[0]+" c1: "+c[1]+"c2: "+c[2]+"c3: "+c[3]+"c4: "+c[4]+" new mean: "+ stats.mean(c));

//Print("[CLOSE SIG]:: closeTradeL5: "+closeTradeL5+" 9: "+closeTrade9+"11: "+closeTrade11+" 12: "+closeTrade12+" 16: "+closeTrade16+" 14: "+closeTrade14+" 26: "+closeTrade26+" 27: "+closeTrade27+" 28: "+closeTrade28+" 29: "+closeTrade29);
//Print("[SLOW]:: IMA30120TR240: "+util.getSigString(hSig.dominantTrendIma120SIG)+" trendRatioSIG: "+util.getSigString(slopeTrendSIG)+" CP120 : "+util.getSigString(ss.cpScatterSIG)+" ima30120SIG: "+util.getSigString(ss.ima30120SIG)+" ima120240SIG: "+util.getSigString(ss.ima120240SIG)+" fsig120: "+util.getSigString(ss.fsig120)+" fsig240: "+util.getSigString(ss.fsig240)+" sig30: "+util.getSigString(ss.sig30)+" sig120: "+util.getSigString(ss.sig120)+" sig240: "+util.getSigString(ss.sig240));
//Print("[FAST]::  ima514:: "+util.getSigString(ss.ima514SIG)+" ima1430: "+util.getSigString(ss.ima1430SIG)+" fIma514: "+util.getSigString(ss.fastIma514SIG)+" fIma1430: "+util.getSigString(ss.fastIma1430SIG)+" fIma30120: "+util.getSigString(ss.fastIma30120SIG)+" fIma120240: "+util.getSigString(ss.fastIma120240SIG)+": RSI::"+util.getSigString(ss.rsiSIG));
//Print("[BOOLS]: basicOpenBool: "+basicOpenBool+" basicOpenVolBool: "+basicOpenVolBool+" slopeTrendBool: "+slopeTrendBool+" varBool:"+varBool+" vol: "+util.getSigString(ss.volSIG));
// Print("[TIME] : Current: "+ TimeToString(TimeCurrent(), TIME_DATE|TIME_MINUTES)+" GMT: "+ TimeToString(TimeGMT(), TIME_DATE|TIME_MINUTES));

   // Print("[MAIN][SLOW]:: domSIG: "+util.getSigString(dominantSIG)+" trendSIG:: "+util.getSigString(hSig.dominantTrendSIG)+" dom240:: "+util.getSigString(hSig.dominant240SIG)+" IMA120240TR240:: "+util.getSigString(hSig.dominantTrendIma240SIG)+" dom120:: "+util.getSigString(hSig.dominant120SIG)+" IMA30120TR240:: "+util.getSigString(hSig.dominantTrendIma120SIG)+" cpSlopeVarFAST: "+util.getSigString(hSig.cpSlopeVarFastSIG)+" VolVar: "+util.getSigString(hSig.domVolVarSIG)+" TrCP: "+util.getSigString(hSig.dominantTrendCPSIG)+" TrIMA: "+util.getSigString(hSig.domTrIMA));
//   Print("[MAIN][SLOW]:: domSIG: "+util.getSigString(dominantSIG)+" trendSIG:: "+util.getSigString(hSig.dominantTrendSIG)+" fastSIG:: "+util.getSigString(hSig.fastSIG)+" IMA120240TR240:: "+util.getSigString(hSig.dominantTrendIma240SIG)+" dom120:: "+util.getSigString(hSig.dominant120SIG)+" IMA30120TR240:: "+util.getSigString(hSig.dominantTrendIma120SIG)+" cpSlopeVarFAST: "+util.getSigString(hSig.cpSlopeVarFastSIG)+" VolVar: "+util.getSigString(hSig.domVolVarSIG)+" TrCP: "+util.getSigString(hSig.dominantTrendCPSIG)+" TrIMA: "+util.getSigString(hSig.domTrIMA));
//   Print("[MAIN][FAST]:: mainFast: "+util.getSigString(hSig.mainFastSIG)+" slopeFast: "+util.getSigString(hSig.slopeFastSIG)+" rsiFAST: "+util.getSigString(hSig.rsiFastSIG)+" cpFAST: "+util.getSigString(hSig.cpFastSIG)+" candleVol120SIG: "+util.getSigString(ss.candleVol120SIG)+" slopeSIG: "+util.getSigString(ss.slopeVarSIG)+" CP120: "+util.getSigString(ss.cpScatterSIG)+" ima1430: "+util.getSigString(ss.ima1430SIG));
   //Print("[MAIN][SLOW]:: domSIG: "+util.getSigString(dominantSIG)+" trendSIG:: "+util.getSigString(hSig.dominantTrendSIG)+" fastSIG:: "+util.getSigString(hSig.fastSIG));
   //Print("[MAIN][FAST]:: candleVol120SIG: "+util.getSigString(ss.candleVol120SIG)+" slopeSIG: "+util.getSigString(ss.slopeVarSIG)+" CP120: "+util.getSigString(ss.cpScatterSIG)+" ima1430: "+util.getSigString(ss.ima1430SIG));

   //Print("[BASICBOOLS] :: basicOpenBool: "+basicOpenBool+" spreadBool: "+spreadBool+" notFlatBool: "+notFlatBool+" openSlope: "+openSlope);



   Print("[CLOSE]:: CloseSIG:"+util.getSigString(ss.closeSIG)+" closeTrade: "+closeTrade+" CloseFlat: "+closeFlatTrade+" SimpleClose14_30:: "+util.getSigString(hSig.simpleTrend_14_30_SIG));
//   Print("[OPEN] :: Trade Sig: "+util.getSigString(hSig.tradeSIG)+" Base Slope: "+util.getSigString(hSig.baseSlopeSIG)+" Base Trend: "+util.getSigString(hSig.baseTrendSIG)+" domSIG: "+util.getSigString(dominantSIG)+" fastSIG: "+util.getSigString(hSig.fastSIG)+" 5_14:"+util.getSigString(hSig.simple_5_14_SIG)+" Slope30: "+util.getSigString(hSig.simpleSlope_30_SIG)+" c_SIG: "+util.getSigString(hSig.c_SIG)+" cp120: "+util.getSigString(hSig.cpSlopeCandle120SIG)+" volSIG:"+ util.getSigString(ss.volSIG)+" domTrCP: "+util.getSigString(hSig.dominantTrendCPSIG));//+" trendSIG:: "+util.getSigString(hSig.dominantTrendSIG)+" domTrCPSIG: "+util.getSigString(hSig.dominantTrendCPSIG));
   Print("[OPEN] :: domSIG: "+util.getSigString(dominantSIG)+" c_SIG: "+util.getSigString(hSig.c_SIG)+" fastSIG: "+util.getSigString(hSig.fastSIG)+" 5_14:"+util.getSigString(hSig.simple_5_14_SIG)+" Slope30: "+util.getSigString(hSig.simpleSlope_30_SIG)+" cp120: "+util.getSigString(hSig.cpSlopeCandle120SIG)+" volSIG:"+ util.getSigString(ss.volSIG)+" domTrCP: "+util.getSigString(hSig.dominantTrendCPSIG)+" trendSIG:: "+util.getSigString(hSig.dominantTrendSIG));
   Print("[OPEN][MKT] :: Trade Sig: "+util.getSigString(hSig.tradeSIG)+" Base Slope: "+util.getSigString(hSig.baseSlopeSIG)+" Base Trend: "+util.getSigString(hSig.baseTrendSIG));

   //Print("[HILBERT] :: Amp0: "+ss.hilbertAmp[0]+" Amp1: "+ss.hilbertAmp[1]+" Amp2: "+ss.hilbertAmp[2]+" Amp3: "+ss.hilbertAmp[3]+" Amp4: "+ss.hilbertAmp[4]+" Amp5: "+ss.hilbertAmp[5]+" Amp6: "+ss.hilbertAmp[6]+" Amp7: "+ss.hilbertAmp[7]);
   //Print("[HILBERT] :: Phase0: "+ss.hilbertPhase[0]+" Phase1: "+ss.hilbertPhase[1]+" Phase2: "+ss.hilbertPhase[2]+" Phase3: "+ss.hilbertPhase[3]+" Phase4: "+ss.hilbertPhase[4]+" Phase5: "+ss.hilbertPhase[5]+" Phase6: "+ss.hilbertPhase[6]+" Phase7: "+ss.hilbertPhase[7]);
   //Print("[DFT] :: Mag0: "+ss.dftMag[0]+" Mag1: "+ss.dftMag[1]+" Mag2: "+ss.dftMag[2]+" Mag3: "+ss.dftMag[3]+" Mag4: "+ss.dftMag[4]+" Mag5: "+ss.dftMag[5]+" Mag6: "+ss.dftMag[6]+" Mag7: "+ss.dftMag[7]);
   //Print("[DFT] :: Phase1: "+ss.dftPhase[0]+" Phase1: "+ss.dftPhase[1]+" Phase2: "+ss.dftPhase[2]+" Phase3: "+ss.dftPhase[3]+" Phase4: "+ss.dftPhase[4]+" Phase5: "+ss.dftPhase[5]+" Phase6: "+ss.dftPhase[7]+" Phase7: "+ss.dftPhase[7]);
   //Print("[DFT] :: Power1: "+ss.dftPower[0]+" Power1: "+ss.dftPower[1]+" Power2: "+ss.dftPower[2]+" Power3: "+ss.dftPower[3]+" Power4: "+ss.dftPower[4]+" Power5: "+ss.dftPower[5]+" Power6: "+ss.dftPower[7]+" Power7: "+ss.dftPower[7]);

//   Print("[VARBOOLS]: varBool: "+varBool+" varBoolDt: "+ss.varDt.matrixBool[3] +" varPosBool: "+varPosBool+" varPosBoolDt: "+ss.varDt.matrixBool[0]+" varNegBool: "+varNegBool+" varNegBoolDt: "+ss.varDt.matrixBool[1]+" varFlatBool: "+varFlatBool+" varFlatBoolDt: "+ss.varDt.matrixBool[2]);
   //Print("[SLOPES]: FAST: "+ imaSlopesData.matrixD[0]+" : "+(0.15+(1.5*0.1))+" MEDIUM: "+imaSlopesData.matrixD[1]+" : "+(0.15+0.1)+" SLOW: "+imaSlopesData.matrixD[2]+" : 0.15  :SLOWWIDE: "+imaSlopesData.matrixD[3]+" : 0.1");
// Print("[TREND]:: tr5: "+util.getSigString(ss.trendRatio5SIG)+" tr14: "+util.getSigString(ss.trendRatio14SIG)+" tr30: "+util.getSigString(ss.trendRatio30SIG)+" tr120: "+util.getSigString(ss.trendRatio120SIG)+" tr240: "+util.getSigString(ss.trendRatio240SIG)+" tr500: "+util.getSigString(ss.trendRatio500SIG));
// Print("[VARIANCE]:: cpSDSIG: "+util.getSigString(ss.cpSDSIG)+" ima30SDSIG: "+util.getSigString(ss.ima30SDSIG)+" ima120SDSIG: "+util.getSigString(varSIG)+" ima240SDSIG: "+util.getSigString(ss.ima240SDSIG)+" ima500SDSIG: "+util.getSigString(ss.ima500SDSIG));
// Print("[TRADEABILITY]:: volSIG: "+util.getSigString(ss.volSIG)+" varBool: "+varBool+" varPosBool: "+varPosBool+" varNegBool: "+varNegBool+" ima120SDSIG: "+util.getSigString(varSIG));
// Print("openCandleVol: "+openCandleVol+" openSlope: "+openSlope+" closeProfitLoss: "+closeProfitLoss+" fastOpenTrade11: "+fastOpenTrade11+" fastOpenTrade12: "+fastOpenTrade12+" fastOpenTrade13: "+fastOpenTrade13);
// Print("[CLUSTER] ratios: rFM: "+ss.clusterSIG.matrixD[0]+" rMS: "+ss.clusterSIG.matrixD[1]+" rFS: "+ss.clusterSIG.matrixD[2]);
// Print("[SIG][FIMA]:: fIma514: "+util.getSigString(ss.fastIma514SIG)+" fIma1430: "+util.getSigString(ss.fastIma1430SIG)+" fIma30120: "+util.getSigString(ss.fastIma30120SIG)+" fIma120240: "+util.getSigString(ss.fastIma120240SIG)+" fIma240500: "+util.getSigString(ss.fastIma240500SIG));
// Print("[SIG][IMA] :: ima514:: "+util.getSigString(ss.ima514SIG)+" ima1430: "+util.getSigString(ss.ima1430SIG)+" ima30120: "+util.getSigString(ss.ima30120SIG)+" ima120240: "+util.getSigString(ss.ima120240SIG)+" ima240500: "+util.getSigString(ss.ima240500SIG));
// Print("[SIG][FSIG]:: fSig5: "+util.getSigString(ss.fsig5)+" fSig14: "+util.getSigString(ss.fsig14)+" fSig30: "+util.getSigString(ss.fsig30)+" fSig120: "+util.getSigString(ss.fsig120)+" fSig240: "+util.getSigString(ss.fsig240)+" fSig500: "+util.getSigString(ss.fsig500));
// Print("[SIG][SIG] :: sig5: "+util.getSigString(ss.sig5)+" sig14: "+util.getSigString(ss.sig14)+" sig30: "+util.getSigString(ss.sig30)+" sig120: "+util.getSigString(ss.sig120)+" sig240: "+util.getSigString(ss.sig240)+" sig500: "+util.getSigString(ss.sig500));
//   Print("[MARKET]: Mkt Type: "+util.getSigString(hSig.mktType)+" Trade strategy: "+util.getSigString(hSig.trdStgy)+" Base Trend: "+util.getSigString(hSig.baseTrendSIG)+" Base Slope: "+util.getSigString(hSig.baseSlopeSIG)+" var: "+varBool+" varFlat: "+varFlatBool+" slpTrVar: "+slopeTrendVarBool+" fastSIG: "+util.getSigString(hSig.fastSIG));
//   Print("[MARKET]: Mkt Type: "+util.getSigString(hSig.mktType)+" Trade strategy: "+util.getSigString(hSig.trdStgy)+" var: "+varBool+" varFlat: "+varFlatBool+" slpTrVar: "+slopeTrendVarBool);
   Print("[SIGNAL]: New Candle: "+op1.NEWCANDLE+" Spread: "+indData.currSpread+" CurrPos: "+util.getSigString(tradePosition)+" OpenSIG:"+util.getSigString(ss.openSIG)+" CloseSIG:"+util.getSigString(ss.closeSIG)+" closeTrade: "+closeTrade+" CloseFlat: "+closeFlatTrade+" PL:"+util.getSigString(ss.profitPercentageSIG)+" Loss:"+util.getSigString(ss.lossSIG)+" basicOpenBool: "+basicOpenBool);

   return sigBuff;
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string SanStrategies::getJsonData(const INDDATA &indData, SANSIGNALS &s, HSIG &h, SanUtils& util, int shift=1) {
   string prntStr = "";
   string prntStrOpen = "{ ";
   string prntStrClose = " }";
   prntStr += prntStrOpen;

   DataTransport dt14 = s.imaSlope5Data; //sig.slopeSIGData(indData.ima14, 5, 21, 1);
   DataTransport dt30 = s.imaSlope30Data;//sig.slopeSIGData(indData.ima30, 5, 21, 1);
   DataTransport dt120 = s.imaSlope120Data;//sig.slopeSIGData(indData.ima120, 5, 21, 1);
   DataTransport dt240 = s.baseSlopeData;//sig.slopeSIGData(indData.ima240, 5, 21, 1);
   DataTransport dt500 = s.imaSlope500Data;//sig.slopeSIGData(indData.ima500, 5, 21, 1);
   DataTransport stdCPSlope = s.stdCPSlope; //sig.slopeSIGData(indData.std, 5, 21, 1);
   DataTransport obvCPSlope = s.obvCPSlope; //sig.slopeSIGData(indData.obv, 5, 21, 1);
   DataTransport clusterData = s.clusterData;//sig.clusterData(indData.ima30[1], indData.ima120[1], indData.ima240[1]);
   DataTransport slopeRatioData = s.slopeRatioData; //sig.slopeRatioData(dt30, dt120, dt240);

   //SAN_SIGNAL c_SIG = sig.cSIG(indData, util, 1);
   //SAN_SIGNAL c_SIG = h.cSIG(s, util, 1);
//   SAN_SIGNAL baseSIG = sig.slopeSIG(dt240, 2);

   SAN_SIGNAL tradeSIG = h.cSIG(s, util, 1);

   SAN_SIGNAL TRADESIG = (indData.currSpread < tl.spreadLimit) ? tradeSIG : SAN_SIGNAL::NOTRADE;

   // Validate numeric values
   double spread = (int)MarketInfo(_Symbol, MODE_SPREAD);
   double open = Open[1];
   double high = High[1];
   double low = Low[1];
   double close = Close[1];
   double volume = Volume[1];
   double stdDevCp = indData.std[1];
   double atr = indData.atr[1];
   double rsi = indData.rsi[1];

   double slopeIMA14 = dt14.matrixD[0];
   double slopeIMA30 = dt30.matrixD[0];
   double slopeIMA120 = dt120.matrixD[0];
   double slopeIMA240 = dt240.matrixD[0];
   double slopeIMA500 = dt500.matrixD[0];
   double stdSlope = stdCPSlope.matrixD[0];
   double obvSlope = obvCPSlope.matrixD[0];
   double rfm = clusterData.matrixD[0];
   double rms = clusterData.matrixD[1];
   double rfs = clusterData.matrixD[2];
   double fMSR = slopeRatioData.matrixD[0];
   double fMSWR = slopeRatioData.matrixD[1];
   double movingAvg5 = indData.ima5[1];
   double movingAvg14 = indData.ima14[1];
   double movingAvg30 = indData.ima30[1];
   double movingAvg60 = indData.ima60[1];
   double movingAvg120 = indData.ima120[1];
   double movingAvg240 = indData.ima240[1];
   double movingAvg500 = indData.ima500[1];

//   double dftMag0 = s.dftMag[0];
//   double dftMag1 = s.dftMag[1];
//   double dftMag2 = s.dftMag[2];
//   double dftMag3 = s.dftMag[3];
//   double dftMag4 = s.dftMag[4];
//   double dftMag5 = s.dftMag[5];
//   double dftMag6 = s.dftMag[6];
//   double dftMag7 = s.dftMag[7];
//
//   double dftPhase0 = s.dftPhase[0];
//   double dftPhase1 = s.dftPhase[1];
//   double dftPhase2 = s.dftPhase[2];
//   double dftPhase3 = s.dftPhase[3];
//   double dftPhase4 = s.dftPhase[4];
//   double dftPhase5 = s.dftPhase[5];
//   double dftPhase6 = s.dftPhase[6];
//   double dftPhase7 = s.dftPhase[7];
//
//   double dftPower0 = s.dftPower[0];
//   double dftPower1 = s.dftPower[1];
//   double dftPower2 = s.dftPower[2];
//   double dftPower3 = s.dftPower[3];
//   double dftPower4 = s.dftPower[4];
//   double dftPower5 = s.dftPower[5];
//   double dftPower6 = s.dftPower[6];
//   double dftPower7 = s.dftPower[7];



   // Use MathIsValidNumber to validate
   spread = (spread > 0 && MathIsValidNumber(spread)) ? spread : 0.0;
   open = (open > 0 && MathIsValidNumber(open)) ? open : 0.0;
   high = (high > 0 && MathIsValidNumber(high)) ? high : 0.0;
   low = (low > 0 && MathIsValidNumber(low)) ? low : 0.0;
   close = (close > 0 && MathIsValidNumber(close)) ? close : 0.0;
   volume = (volume > 0 && MathIsValidNumber(volume)) ? volume : 0.0;
   stdDevCp = MathIsValidNumber(stdDevCp) ? stdDevCp : 0.0;
   atr = MathIsValidNumber(atr) ? atr : 0.0;
   rsi = MathIsValidNumber(rsi) ? rsi : 0.0;
   slopeIMA14 = MathIsValidNumber(slopeIMA14) ? slopeIMA14 : 0.0;
   slopeIMA30 = MathIsValidNumber(slopeIMA30) ? slopeIMA30 : 0.0;
   slopeIMA120 = MathIsValidNumber(slopeIMA120) ? slopeIMA120 : 0.0;
   slopeIMA240 = MathIsValidNumber(slopeIMA240) ? slopeIMA240 : 0.0;
   slopeIMA500 = MathIsValidNumber(slopeIMA500) ? slopeIMA500 : 0.0;
   stdSlope = MathIsValidNumber(stdSlope) ? stdSlope : 0.0;
   obvSlope = MathIsValidNumber(obvSlope) ? obvSlope : 0.0;
   rfm = MathIsValidNumber(rfm) ? rfm : 0.0;
   rms = MathIsValidNumber(rms) ? rms : 0.0;
   rfs = MathIsValidNumber(rfs) ? rfs : 0.0;
   fMSR = MathIsValidNumber(fMSR) ? fMSR : 0.0;
   fMSWR = MathIsValidNumber(fMSWR) ? fMSWR : 0.0;
   movingAvg5 = MathIsValidNumber(movingAvg5) ? movingAvg5 : 0.0;
   movingAvg14 = MathIsValidNumber(movingAvg14) ? movingAvg14 : 0.0;
   movingAvg30 = MathIsValidNumber(movingAvg30) ? movingAvg30 : 0.0;
   movingAvg60 = MathIsValidNumber(movingAvg60) ? movingAvg60 : 0.0;
   movingAvg120 = MathIsValidNumber(movingAvg120) ? movingAvg120 : 0.0;
   movingAvg240 = MathIsValidNumber(movingAvg240) ? movingAvg240 : 0.0;
   movingAvg500 = MathIsValidNumber(movingAvg500) ? movingAvg500 : 0.0;

//   dftMag0 = MathIsValidNumber(dftMag0) ? dftMag0 : 0.0;
//   dftMag1 = MathIsValidNumber(dftMag1) ? dftMag1 : 0.0;
//   dftMag2 = MathIsValidNumber(dftMag2) ? dftMag2 : 0.0;
//   dftMag3 = MathIsValidNumber(dftMag3) ? dftMag3 : 0.0;
//   dftMag4 = MathIsValidNumber(dftMag4) ? dftMag4 : 0.0;
//   dftMag5 = MathIsValidNumber(dftMag5) ? dftMag5 : 0.0;
//   dftMag6 = MathIsValidNumber(dftMag6) ? dftMag6 : 0.0;
//   dftMag7 = MathIsValidNumber(dftMag7) ? dftMag7 : 0.0;
//
//   dftPhase0 = MathIsValidNumber(dftPhase0) ? dftPhase0 : 0.0;
//   dftPhase1 = MathIsValidNumber(dftPhase1) ? dftPhase1 : 0.0;
//   dftPhase2 = MathIsValidNumber(dftPhase2) ? dftPhase2 : 0.0;
//   dftPhase3 = MathIsValidNumber(dftPhase3) ? dftPhase3 : 0.0;
//   dftPhase4 = MathIsValidNumber(dftPhase4) ? dftPhase4 : 0.0;
//   dftPhase5 = MathIsValidNumber(dftPhase5) ? dftPhase5 : 0.0;
//   dftPhase6 = MathIsValidNumber(dftPhase6) ? dftPhase6 : 0.0;
//   dftPhase7 = MathIsValidNumber(dftPhase7) ? dftPhase7 : 0.0;
//
//   dftPower0 = MathIsValidNumber(dftPower0) ? dftPower0 : 0.0;
//   dftPower1 = MathIsValidNumber(dftPower1) ? dftPower1 : 0.0;
//   dftPower2 = MathIsValidNumber(dftPower2) ? dftPower2 : 0.0;
//   dftPower3 = MathIsValidNumber(dftPower3) ? dftPower3 : 0.0;
//   dftPower4 = MathIsValidNumber(dftPower4) ? dftPower4 : 0.0;
//   dftPower5 = MathIsValidNumber(dftPower5) ? dftPower5 : 0.0;
//   dftPower6 = MathIsValidNumber(dftPower6) ? dftPower6 : 0.0;
//   dftPower7 = MathIsValidNumber(dftPower7) ? dftPower7 : 0.0;

   // Log invalid values for debugging
   if (!MathIsValidNumber(stdDevCp)) Print("Invalid StdDevCp: ", stdDevCp);
   if (!MathIsValidNumber(atr)) Print("Invalid ATR: ", atr);
   if (!MathIsValidNumber(rsi)) Print("Invalid RSI: ", rsi);
   if (!MathIsValidNumber(slopeIMA14)) Print("Invalid SlopeIMA14: ", slopeIMA14);
   if (!MathIsValidNumber(slopeIMA30)) Print("Invalid SlopeIMA30: ", slopeIMA30);
   if (!MathIsValidNumber(slopeIMA120)) Print("Invalid SlopeIMA120: ", slopeIMA120);
   if (!MathIsValidNumber(slopeIMA240)) Print("Invalid SlopeIMA240: ", slopeIMA240);
   if (!MathIsValidNumber(slopeIMA500)) Print("Invalid SlopeIMA500: ", slopeIMA500);
   if (!MathIsValidNumber(stdSlope)) Print("Invalid STDSlope: ", stdSlope);
   if (!MathIsValidNumber(obvSlope)) Print("Invalid OBVSlope: ", stdSlope);
   if (!MathIsValidNumber(rfm)) Print("Invalid RFM: ", rfm);
   if (!MathIsValidNumber(rms)) Print("Invalid RMS: ", rms);
   if (!MathIsValidNumber(rfs)) Print("Invalid RFS: ", rfs);
   if (!MathIsValidNumber(fMSR)) Print("Invalid fMSR: ", fMSR);
   if (!MathIsValidNumber(fMSWR)) Print("Invalid fMSWR: ", fMSWR);
   if (!MathIsValidNumber(movingAvg5)) Print("Invalid MovingAvg5: ", movingAvg5);
   if (!MathIsValidNumber(movingAvg14)) Print("Invalid MovingAvg14: ", movingAvg14);
   if (!MathIsValidNumber(movingAvg30)) Print("Invalid MovingAvg30: ", movingAvg30);
   if (!MathIsValidNumber(movingAvg60)) Print("Invalid MovingAvg60: ", movingAvg60);
   if (!MathIsValidNumber(movingAvg120)) Print("Invalid MovingAvg120: ", movingAvg120);
   if (!MathIsValidNumber(movingAvg240)) Print("Invalid MovingAvg240: ", movingAvg240);
   if (!MathIsValidNumber(movingAvg500)) Print("Invalid MovingAvg500: ", movingAvg500);

   prntStr += " \"DateTime\":\"" + TimeToString(TimeCurrent(), TIME_DATE|TIME_MINUTES) + "\",";
   prntStr += " \"CurrencyPair\":\"" + util.getSymbolString(Symbol()) + "\",";
   prntStr += " \"TimeFrame\":\"" + util.getSymbolString(Period()) + "\",";
   prntStr += " \"Spread\":" + DoubleToString(spread, 0) + ",";
   prntStr += " \"Open\":" + DoubleToString(open, 8) + ",";
   prntStr += " \"High\":" + DoubleToString(high, 8) + ",";
   prntStr += " \"Low\":" + DoubleToString(low, 8) + ",";
   prntStr += " \"Close\":" + DoubleToString(close, 8) + ",";
   prntStr += " \"Volume\":" + DoubleToString(volume, 8) + ",";
   prntStr += " \"StdDevCp\":" + DoubleToString(stdDevCp, 8) + ",";
   prntStr += " \"ATR\":" + DoubleToString(atr, 8) + ",";
   prntStr += " \"RSI\":" + DoubleToString(rsi, 8) + ",";
   prntStr += " \"SlopeIMA14\":" + DoubleToString(slopeIMA14, 8) + ",";
   prntStr += " \"SlopeIMA30\":" + DoubleToString(slopeIMA30, 8) + ",";
   prntStr += " \"SlopeIMA120\":" + DoubleToString(slopeIMA120, 8) + ",";
   prntStr += " \"SlopeIMA240\":" + DoubleToString(slopeIMA240, 8) + ",";
   prntStr += " \"SlopeIMA500\":" + DoubleToString(slopeIMA500, 8) + ",";
   prntStr += " \"STDSlope\":" + DoubleToString(stdSlope, 8) + ",";
//   prntStr += " \"OBVSlope\":" + DoubleToString(obvSlope, 8) + ",";
   prntStr += " \"RFM\":" + DoubleToString(rfm, 8) + ",";
   prntStr += " \"RMS\":" + DoubleToString(rms, 8) + ",";
   prntStr += " \"RFS\":" + DoubleToString(rfs, 8) + ",";
   prntStr += " \"fMSR\":" + DoubleToString(fMSR, 8) + ",";
   prntStr += " \"fMSWR\":" + DoubleToString(fMSWR, 8) + ",";
   prntStr += " \"MovingAvg5\":" + DoubleToString(movingAvg5, 8) + ",";
   prntStr += " \"MovingAvg14\":" + DoubleToString(movingAvg14, 8) + ",";
   prntStr += " \"MovingAvg30\":" + DoubleToString(movingAvg30, 8) + ",";
   prntStr += " \"MovingAvg60\":" + DoubleToString(movingAvg60, 8) + ",";
   prntStr += " \"MovingAvg120\":" + DoubleToString(movingAvg120, 8) + ",";
   prntStr += " \"MovingAvg240\":" + DoubleToString(movingAvg240, 8) + ",";
   prntStr += " \"MovingAvg500\":" + DoubleToString(movingAvg500, 8) + ",";

   //prntStr += " \"dftMag0\":" + DoubleToString(dftMag0, 8) + ",";
   //prntStr += " \"dftMag1\":" + DoubleToString(dftMag1, 8) + ",";
   //prntStr += " \"dftMag2\":" + DoubleToString(dftMag2, 8) + ",";
   //prntStr += " \"dftMag3\":" + DoubleToString(dftMag3, 8) + ",";
   //prntStr += " \"dftMag4\":" + DoubleToString(dftMag4, 8) + ",";
   //prntStr += " \"dftMag5\":" + DoubleToString(dftMag5, 8) + ",";
   //prntStr += " \"dftMag6\":" + DoubleToString(dftMag6, 8) + ",";
   //prntStr += " \"dftMag7\":" + DoubleToString(dftMag7, 8) + ",";
   //prntStr += " \"dftPhase0\":" + DoubleToString(dftPhase0, 8) + ",";
   //prntStr += " \"dftPhase1\":" + DoubleToString(dftPhase1, 8) + ",";
   //prntStr += " \"dftPhase2\":" + DoubleToString(dftPhase2, 8) + ",";
   //prntStr += " \"dftPhase3\":" + DoubleToString(dftPhase3, 8) + ",";
   //prntStr += " \"dftPhase4\":" + DoubleToString(dftPhase4, 8) + ",";
   //prntStr += " \"dftPhase5\":" + DoubleToString(dftPhase5, 8) + ",";
   //prntStr += " \"dftPhase6\":" + DoubleToString(dftPhase6, 8) + ",";
   //prntStr += " \"dftPhase7\":" + DoubleToString(dftPhase7, 8) + ",";
   //prntStr += " \"dftPower0\":" + DoubleToString(dftPower0, 8) + ",";
   //prntStr += " \"dftPower1\":" + DoubleToString(dftPower1, 8) + ",";
   //prntStr += " \"dftPower2\":" + DoubleToString(dftPower2, 8) + ",";
   //prntStr += " \"dftPower3\":" + DoubleToString(dftPower3, 8) + ",";
   //prntStr += " \"dftPower4\":" + DoubleToString(dftPower4, 8) + ",";
   //prntStr += " \"dftPower5\":" + DoubleToString(dftPower5, 8) + ",";
   //prntStr += " \"dftPower6\":" + DoubleToString(dftPower6, 8) + ",";
   //prntStr += " \"dftPower7\":" + DoubleToString(dftPower7, 8) + ",";

   prntStr += " \"TRADESIG\":\"" + util.getSigString(TRADESIG) + "\"";
   prntStr += prntStrClose;
   return prntStr;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//bool SanStrategies::writeOHLCVJsonData(string filename, const INDDATA &indData, SanSignals &sig, SanUtils& util, int shift=1) {
bool SanStrategies::writeOHLCVJsonData(string filename, const INDDATA &indData, SanUtils& util, int shift=1) {

//   string data = getJsonData(indData, sig, util, shift);
   string data = getJsonData(indData,s,h,util, shift);

   int fileHandle = FileOpen(filename, FILE_TXT|FILE_WRITE|FILE_READ);
   if(fileHandle == INVALID_HANDLE) {
      Print("Error opening file: ", GetLastError());
      return false;
   }
   if(fileHandle != INVALID_HANDLE) {
      FileSeek(fileHandle, 0, SEEK_END);
      FileWriteString(fileHandle, data + "\n");
      FileClose(fileHandle);
      return true;
   } else {
      Print("Failed to open file for appending.");
      return false;
   }
}



SanStrategies st1;

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
