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
   string            getJsonData(const INDDATA &indData, SANSIGNALS &s, HSIG &h, SanUtils& util, int shift = 1);
   bool              writeOHLCVJsonData(string filename, const INDDATA &indData, SanUtils& util, int shift = 1);
//   string            printArray(const double& arrVal[], string mainLabel, string loopLabel, int BEGIN=0,int END=8);

};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SanStrategies::SanStrategies() {}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SanStrategies::SanStrategies(SanSignals &sig, const INDDATA &indData, int shift): s(sig, indData, shift), h(s, util) {
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
   sigBuff.buff3[0] = (int)STRATEGYTYPE::IMACLOSE;
   int totalOrders = OrdersTotal();
   SAN_SIGNAL tradePosition = SAN_SIGNAL::NOSIG;
   SAN_SIGNAL dominantSIG = SAN_SIGNAL::NOSIG;
   SAN_SIGNAL commonSIG = SAN_SIGNAL::NOSIG;
   datetime tradeStartTime = 0;
//   SANTREND cp120SIG = SANTREND::NOTREND;
   if(totalOrders > 0) {
      for(int i = 0; i < totalOrders; i++) {
         if(OrderSelect(i, SELECT_BY_POS)) {
            tradeStartTime = OrderOpenTime();
            if(OrderType() == OP_BUY)
               tradePosition = SAN_SIGNAL::BUY;
            if(OrderType() == OP_SELL)
               tradePosition = SAN_SIGNAL::SELL;
            if((OrderType() != OP_SELL) && (OrderType() != OP_BUY) && (OrderType() != OP_SELLLIMIT) && (OrderType() != OP_BUYLIMIT) && (OrderType() != OP_SELLSTOP) && (OrderType() != OP_BUYSTOP))
               tradePosition = SAN_SIGNAL::NOSIG;
         }
      }
   }
   if(util.isNewBar()) {
      op1.NEWCANDLE = true;
      op1.TRADED = false;
      op1.MAXPIPS = 0;
   }
   if(!(util.isNewBar()) && (totalOrders > 0)) {
      op1.NEWCANDLE = false;
      op1.TRADED = true;
   }
   TRENDSTRUCT tRatioTrend;
   int SHIFT = (indData.shift || 1);
   SS ss(sig, indData, SHIFT);
   s = ss;
   SAN_SIGNAL openSIG = SAN_SIGNAL::NOSIG;
   SAN_SIGNAL closeSIG = SAN_SIGNAL::NOSIG;
// ################# Open Signal ###################################################
   bool spreadBool = (indData.currSpread < tl.spreadLimit);
//################################################################
//################################################################
   //bool openOrder = (util.isNewBar() && (totalOrders == 0));
   //bool closeOrder = (!(util.isNewBar()) && (totalOrders > 0));

   bool openOrder = (op1.NEWCANDLE && (totalOrders == 0));
   bool closeOrder = (!op1.NEWCANDLE && (totalOrders > 0));



   SANTREND slopeTrendSIG = ss.trendRatioSIG;
   SIGMAVARIABILITY varSIG = ss.ima120SDSIG;
   bool spreadVolBool = (spreadBool && (ss.volSIG == SAN_SIGNAL::TRADE));
//################################################################
//################################################################
//   bool trendBool = (sb.healthyTrendBool && sb.healthyTrendStrengthBool && !sb.flatTrendBool);
   bool atrBool = (ss.atrSIG == SAN_SIGNAL::TRADE);
   bool sig5TrendBool = ((ss.sig5 != SAN_SIGNAL::NOSIG) && (ss.sig5 == ss.priceActionSIG) && (ss.sig5 == ss.adxSIG) && atrBool);
//   bool tradeBool = (ss.tradeSIG==SAN_SIGNAL::TRADE);
   bool mfiSIGBool = ((ss.mfiSIG == SAN_SIGNAL::BUY) || (ss.mfiSIG == SAN_SIGNAL::SELL));
   bool mfiTradeTrendBool = (ss.mfiSIG == util.convTrendToSig(slopeTrendSIG));
   bool slopeTrendBool = ((slopeTrendSIG == SANTREND::UP) || (slopeTrendSIG == SANTREND::DOWN));
//########################################################################################
   DataTransport varDt = sig.varSIG(ss.ima30SDSIG, ss.ima120SDSIG, ss.ima240SDSIG);
   bool varPosBool = varDt.matrixBool[0];
   bool varNegBool = varDt.matrixBool[1];
   bool varFlatBool = varDt.matrixBool[2];
   bool varBool = varDt.matrixBool[3];
//########################################################################################
   bool noVolWindPressure = ((ss.volSIG == SAN_SIGNAL::REVERSETRADE) || (ss.volSIG == SAN_SIGNAL::CLOSE));
//bool noVarBool = (variabilityVal==0);
   bool noVarBool = (!varBool);
   bool candleVol120Bool = (((ss.candleVol120SIG == SAN_SIGNAL::SELL) && varNegBool) || ((ss.candleVol120SIG == SAN_SIGNAL::BUY) && varPosBool));
   bool slopeVarBool = (ss.slopeVarSIG == SAN_SIGNAL::SELL || ss.slopeVarSIG == SAN_SIGNAL::BUY);
   HSIG hSig(ss, util);
   h = hSig;
   dominantSIG = sig.dominantTrendSIG(ss, hSig);
   bool notFlatBool = (varBool && (varPosBool || varNegBool) && (hSig.mktType == MKTTYP::MKTTR));
   bool flatBool = (varFlatBool && (hSig.mktType == MKTTYP::MKTFLAT));
//##################################################################################
   bool basicOpenVolBool = (spreadVolBool && notFlatBool);
   bool basicOpenBool = (spreadBool);
//##################################################################################
   bool slopeTrendVarBool = (basicOpenBool && slopeTrendBool);
   bool candleVolVar120Bool = (basicOpenVolBool && candleVol120Bool);
   bool fastOpenTrade1 = (spreadBool  && (ss.candleImaSIG != SAN_SIGNAL::NOSIG));
//   bool fastOpenTrade2 = (spreadBool && sb.starBool);
   //bool fastOpenTrade3 = ((hSig.dominantTrendSIG!=SAN_SIGNAL::NOSIG)&&((hSig.slopeFastSIG==hSig.dominantTrendSIG) || (hSig.mainFastSIG==hSig.dominantTrendSIG)));
   bool fastOpenTrade3 = ((hSig.slopeFastSIG != SAN_SIGNAL::NOSIG) && (hSig.slopeFastSIG == hSig.mainFastSIG));
   //bool fastOpenTrade4 = (slopeTrendVarBool && (ss.ima1430SIG!=SAN_SIGNAL::NOSIG) && (ss.ima1430SIG==hSig.dominantTrendSIG));   // ss.ima514SIG
   //bool fastOpenTrade5 = (slopeTrendVarBool && (ss.slopeVarSIG!=SAN_SIGNAL::NOSIG) && (ss.slopeVarSIG==hSig.dominantTrendSIG));  // ss.slopeVarSIG
   //bool fastOpenTrade6 = (candleVolVar120Bool && (ss.candleVol120SIG!=SAN_SIGNAL::NOSIG) && (ss.candleVol120SIG==hSig.dominantTrendSIG));  // ss.candleVol120SIG
//
//// #################################################################################
   //bool fastOpenTrade10 = (fastOpenTrade3||fastOpenTrade4||fastOpenTrade5||fastOpenTrade6);
   //bool fastOpenTrade11 = (slopeTrendVarBool && (dominantSIG!=SAN_SIGNAL::NOSIG) && (dominantSIG!=SAN_SIGNAL::CLOSE) && (dominantSIG!=SAN_SIGNAL::SIDEWAYS));
   bool fastOpenTrade11 = (basicOpenBool && ((dominantSIG == SAN_SIGNAL::BUY) || (dominantSIG == SAN_SIGNAL::SELL)));
   bool fastOpenTrade12 = (fastOpenTrade11 && (dominantSIG == hSig.mainFastSIG));
   bool fastOpenTrade13 = (fastOpenTrade11 && (dominantSIG == hSig.slopeFastSIG));
//   bool fastOpenTrade14 = (fastOpenTrade11 && (dominantSIG==hSig.rsiFastSIG));
   bool fastOpenTrade15 = (slopeTrendVarBool && (ss.fsig5 != SAN_SIGNAL::NOSIG) && (ss.fsig5 != SAN_SIGNAL::CLOSE));
   bool closeLoss = (ss.lossSIG == SAN_SIGNAL::CLOSE);
//bool closeProfitLoss = ((_Period >= PERIOD_M1) && (ss.profitPercentageSIG == SAN_SIGNAL::CLOSE));
   bool closeProfitLoss = ((_Period >= PERIOD_M1) && (ss.profitSIG == SAN_SIGNAL::CLOSE));
   bool closeTrade1 = (noVolWindPressure && (
                          (ss.candleVol120SIG == SAN_SIGNAL::SIDEWAYS)
                          || (ss.slopeVarSIG == SAN_SIGNAL::SIDEWAYS)
                          || (ss.trendRatioSIG == SANTREND::FLAT)
                          || (ss.trendRatioSIG == SANTREND::FLATUP)
                          || (ss.trendRatioSIG == SANTREND::FLATDOWN)));
   bool closeTrade2 = ((dominantSIG == SAN_SIGNAL::CLOSE) || (util.oppSignal(dominantSIG, tradePosition)));
   bool closeTradeL1 = (closeTrade2);
//#################################################################################
//#################################################################################
// Open and close signals
//#################################################################################
   bool openCandleIma = (fastOpenTrade1);
   bool openTradeTrend = (fastOpenTrade3);//||fastOpenTrade4);
   bool openSlope = (fastOpenTrade11);//||fastOpenTrade4);
   bool openCandleVol = (fastOpenTrade12 || fastOpenTrade13);
   bool closeFlatTrade = (spreadBool && (dominantSIG == SAN_SIGNAL::SIDEWAYS));
   bool closeTrade = (closeTradeL1);
   bool noCloseConditions = (!closeFlatTrade);
//#################################################################################
   double cutOff = stats.maxVal<double>(indData.currSpread, 0.5 * (indData.std[1] / util.getPipValue(_Symbol)));
//   Print("Max of "+indData.currSpread+" & "+(indData.std[1]/util.getPipValue(_Symbol)) +" = "+cutOff);
   bool shortCycle = false;
   bool longCycle = false;
   bool allCycle = false;
   if(false && closeOrder && closeLoss) {
      closeSIG = SAN_SIGNAL::CLOSE;
      sigBuff.buff3[0] = (int)STRATEGYTYPE::CLOSEPOSITIONS;
      Print("[imaSt1]: closeLoss CLOSE detected:." + util.getSigString(closeSIG));
   } else if(false && closeOrder && closeProfitLoss) {
      closeSIG = SAN_SIGNAL::CLOSE;
      sigBuff.buff3[0] = (int)STRATEGYTYPE::CLOSEPOSITIONS;
      Print("[imaSt1]: profitPercentage CLOSE detected:." + util.getSigString(closeSIG));
   } else if(false && closeOrder && closeFlatTrade) {
      closeSIG = SAN_SIGNAL::CLOSE;
      sigBuff.buff3[0] = (int)STRATEGYTYPE::CLOSEPOSITIONS;
      Print("[imaSt1]: closeFlatTrade CLOSE detected:." + util.getSigString(closeSIG));
   } else if(openTradeTrend && noCloseConditions && allCycle) {
      commonSIG = ss.ima1430SIG;
      if(openOrder)
         openSIG = commonSIG;
      closeSIG = commonSIG;
      commonSIG = SAN_SIGNAL::NOSIG;
   } else if(openSlope && noCloseConditions) {
      commonSIG = dominantSIG;
      if(openOrder)
         openSIG = commonSIG;
      closeSIG = commonSIG;
      // Print("[imaSt1]: openSlope OPEN and CLOSE detected:."+ openSlope+" SIG: "+util.getSigString(commonSIG));
      commonSIG = SAN_SIGNAL::NOSIG;
   } else if(openCandleVol && noCloseConditions && allCycle) {
      commonSIG = dominantSIG;
      if(openOrder)
         openSIG = commonSIG;
      closeSIG = commonSIG;
      commonSIG = SAN_SIGNAL::NOSIG;
   } else if(openCandleIma && allCycle) {
      commonSIG = ss.candleImaSIG;
      if(openOrder)
         ss.openSIG = commonSIG;
      ss.closeSIG = commonSIG;
   } else if(true && closeOrder && closeTrade) { // && !openCandleIma)// && !slowMfi)
      closeSIG = SAN_SIGNAL::CLOSE;
      sigBuff.buff3[0] = (int)STRATEGYTYPE::CLOSEPOSITIONS;
      Print("[imaSt1]: closeTrade: " + closeTrade + " close detected: " + util.getSigString(closeSIG));
      //util.writeData("close_order.txt",""[imaSt1]: closeTrade4: "+closeTrade5+" close detected: "+ util.getSigString(ss.closeSIG));
   }
   //if(!closeTrade)
   if((!closeFlatTrade) && (!closeTrade))
      ss.openSIG = openSIG;
   ss.closeSIG = closeSIG;
//##############################################################################################
//##############################################################################################
   sigBuff.buff1[0] = (int)ss.openSIG;
   sigBuff.buff2[0] = (int)ss.closeSIG;
// sigBuff.buff4[0] = (int)ss.tradeSIG;
   sigBuff.buff4[0] = (int)hSig.mktType;
   //double c[];
   //stats.sigMeanDeTrend(indData.close,c,5);
   //Print("DETREND: c0: "+c[0]+" c1: "+c[1]+"c2: "+c[2]+"c3: "+c[3]+"c4: "+c[4]+" new mean: "+ stats.mean(c));
// Print("[TIME] : Current: "+ TimeToString(TimeCurrent(), TIME_DATE|TIME_MINUTES)+" GMT: "+ TimeToString(TimeGMT(), TIME_DATE|TIME_MINUTES));
   Print("[SLOW COPEN]:: cp120: " + util.getSigString(hSig.cpSlopeCandle120SIG)  + " cCloseSIG3: " + util.getSigString(hSig.composite_CloseSIG_3) + " cCloseSIG4: " + util.getSigString(hSig.composite_CloseSIG_4)  + " tradeSlopeSig: "+ util.getSigString(ss.tradeSlopeSIG)); 
   Print("[FAST COPEN]:: slope120: " + util.getSigString(hSig.slopeCandle120SIG) + " cCloseSIG1: " + util.getSigString(hSig.composite_CloseSIG_1) + " cCloseSIG2: " + util.getSigString(hSig.composite_CloseSIG_2) + " cCloseSIG5: " + util.getSigString(hSig.composite_CloseSIG_5) + " cCloseSIG7: " + util.getSigString(hSig.composite_CloseSIG_7));
   Print("[OPEN] :: domSIG: " + util.getSigString(dominantSIG) +" c_SIG: " + util.getSigString(hSig.c_SIG)+" Slope30: " + util.getSigString(hSig.simpleSlope_30_SIG) + " fastSIG: " + util.getSigString(hSig.fastSIG) + " obvCPSIG: " + util.getSigString(ss.obvCPSIG) + " cpScatt: " + util.getSigString(ss.cpScatterSIG) + " sVarSIG: " + util.getSigString(ss.slopeVarSIG) + " cV120SIG: " + util.getSigString(ss.candleVol120SIG)+" volatility: "+util.getSigString(ss.volatilitySIG)); //+" hilbertDftSIG: "+util.getSigString((SAN_SIGNAL)ss.hilbertDftSIG.val[0]));

   //Print("[OPEN OBVSIG] :: obvSlp120SIG: " + util.getSigString(hSig.obvSlp120SIG) + " obvCp120SIG: " + util.getSigString(hSig.obvCp120SIG) + " obvFastSIG: " + util.getSigString(hSig.obvFastSIG));

   Print("[TRADESIG] :: Trade Sig: " + util.getSigString(hSig.tradeSIG) + " Base Slope: " + util.getSigString(hSig.baseSlopeSIG) + " Base Slope: " + ss.baseSlopeData.val1 + " rsiSIG: " + util.getSigString(ss.rsiSIG) + " volSIG:" + util.getSigString(ss.volSIG) + " volSlopeSIG: " + util.getSigString(ss.volSlopeSIG) + " atr: " + util.getSigString(ss.atrSIG)); 
   return sigBuff;
}

////+------------------------------------------------------------------+
////|                                                                  |
////+------------------------------------------------------------------+
//string SanStrategies::printArray(const double& arrVal[], string mainLabel, string loopLabel, int BEGIN=0,int END=8) {
//   string printStr = "[ "+mainLabel+": ] ";
//
//   int SIZE = ArraySize(arrVal);
//   if(SIZE<END)END=SIZE;
//
//   for(int i=BEGIN; i<END; i++) {
//      printStr+= " "+loopLabel+"["+i+"]: "+arrVal[i]+"";
//   }
//
//   return printStr;
//}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string SanStrategies::getJsonData(const INDDATA &indData, SANSIGNALS &s, HSIG &h, SanUtils& util, int shift = 1) {
   string prntStr = "";
   string prntStrOpen = "{ ";
   string prntStrClose = " }";
   prntStr += prntStrOpen;
   DTYPE dt14 = s.imaSlope5Data; //sig.slopeSIGData(indData.ima14, 5, 21, 1);
   DTYPE dt30 = s.imaSlope30Data;//sig.slopeSIGData(indData.ima30, 5, 21, 1);
   DTYPE dt120 = s.imaSlope120Data;//sig.slopeSIGData(indData.ima120, 5, 21, 1);
   DTYPE dt240 = s.baseSlopeData;//sig.slopeSIGData(indData.ima240, 5, 21, 1);
   DTYPE dt500 = s.imaSlope500Data;//sig.slopeSIGData(indData.ima500, 5, 21, 1);
   DTYPE stdCPSlope = s.stdCPSlope; //sig.slopeSIGData(indData.std, 5, 21, 1);
   DTYPE obvCPSlope = s.obvCPSlope; //sig.slopeSIGData(indData.obv, 5, 21, 1);
   DataTransport clusterData = s.clusterData;//sig.clusterData(indData.ima30[1], indData.ima120[1], indData.ima240[1]);
   DataTransport slopeRatioData = s.slopeRatioData; //sig.slopeRatioData(dt30, dt120, dt240);
   D20TYPE hilbertDftData = s.hilbertDftSIG;
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
   double slopeIMA14 = dt14.val1;
   double slopeIMA30 = dt30.val1;
   double slopeIMA120 = dt120.val1;
   double slopeIMA240 = dt240.val1;
   double slopeIMA500 = dt500.val1;
   double stdSlope = stdCPSlope.val1;
   double obvSlope = obvCPSlope.val1;
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
   double hilbertIndex = hilbertDftData.val[1];
   double hilbertAmp = hilbertDftData.val[2];
   double hilbertPhase = hilbertDftData.val[3];
   double dftIndex = hilbertDftData.val[4];
   double dftMagnitude = hilbertDftData.val[5];
   double dftPhase = hilbertDftData.val[6];
   double dftPower = hilbertDftData.val[7];
   double hilbertSIZE = hilbertDftData.val[15];
   double hibertFILTER = hilbertDftData.val[16];
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
   hilbertIndex = MathIsValidNumber(hilbertIndex) ? hilbertIndex : 0.0;
   hilbertAmp = MathIsValidNumber(hilbertAmp) ? hilbertAmp : 0.0;
   hilbertPhase = MathIsValidNumber(hilbertPhase) ? hilbertPhase : 0.0;
   dftIndex = MathIsValidNumber(dftIndex) ? dftIndex : 0.0;
   dftMagnitude = MathIsValidNumber(dftMagnitude) ? dftMagnitude : 0.0;
   dftPhase = MathIsValidNumber(dftPhase) ? dftPhase : 0.0;
   dftPower = MathIsValidNumber(dftPower) ? dftPower : 0.0;
   hilbertSIZE = MathIsValidNumber(hilbertSIZE) ? hilbertSIZE : 0.0;
   hibertFILTER = MathIsValidNumber(hibertFILTER) ? hibertFILTER : 0.0;
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
   prntStr += " \"DateTime\":\"" + TimeToString(TimeCurrent(), TIME_DATE | TIME_MINUTES) + "\",";
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
   //prntStr += " \"hilbertIndex\":" + DoubleToString(hilbertIndex, 8) + ",";
   //prntStr += " \"hilbertAmp\":" + DoubleToString(hilbertAmp, 8) + ",";
   //prntStr += " \"hilbertPhase\":" + DoubleToString(hilbertPhase, 8) + ",";
   //prntStr += " \"dftIndex\":" + DoubleToString(dftIndex, 8) + ",";
   //prntStr += " \"dftMagnitude\":" + DoubleToString(dftMagnitude, 8) + ",";
   //prntStr += " \"dftPhase\":" + DoubleToString(dftPhase, 8) + ",";
   //prntStr += " \"dftPower\":" + DoubleToString(dftPower, 8) + ",";
   //prntStr += " \"hilbertSIZE\":" + DoubleToString(hilbertSIZE, 8) + ",";
   //prntStr += " \"hibertFILTER\":" + DoubleToString(hibertFILTER, 8) + ",";
   prntStr += " \"TRADESIG\":\"" + util.getSigString(TRADESIG) + "\"";
   prntStr += prntStrClose;
   return prntStr;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//bool SanStrategies::writeOHLCVJsonData(string filename, const INDDATA &indData, SanSignals &sig, SanUtils& util, int shift=1) {
bool SanStrategies::writeOHLCVJsonData(string filename, const INDDATA &indData, SanUtils& util, int shift = 1) {
//   string data = getJsonData(indData, sig, util, shift);
   string data = getJsonData(indData, s, h, util, shift);
   int fileHandle = FileOpen(filename, FILE_TXT | FILE_WRITE | FILE_READ);
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
