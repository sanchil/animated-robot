//+------------------------------------------------------------------+
//|                                               SanSignalTypes.mqh |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+

//#include <Sandeep/v1/SanTypes-v1.mqh>
#include <Sandeep/v1/SanSignals-v1.mqh>

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class SS: public SANSIGNALS {
 private:
   double            iSIg[];
 public:
   SS();
   SS(SanSignals &sig, const INDDATA &indData, const int SHIFT);
   ~SS();
   void              SS::printSignalStruct(SanUtils &util);

};


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SS::SS() {}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SS::~SS() {}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SS::SS(SanSignals &sig, const INDDATA &indData, const int SHIFT) {
//initBase();
//Print("SS: ima30 current 1: "+indData.ima30[1]+" :ima30 5: "+ indData.ima30[5]+" :ima30 10: "+ indData.ima30[10]+" :21:" + indData.ima30[21]);
//########################################################################################################
//########################################################################################################
//         //    tradeSIG = sig.tradeSignal(indData.std[SHIFT],indData.mfi[SHIFT],indData.atr,indData.adx[SHIFT],indData.adxPlus[SHIFT],indData.adxMinus[SHIFT]);
//         adxSIG =  sig.adxSIG(indData.adx[SHIFT],indData.adxPlus[SHIFT],indData.adxMinus[SHIFT]);
//
//         fastIma514SIG = sig.fastSlowSIG(indData.ima5[SHIFT],indData.ima14[SHIFT],21);
//         fastIma1430SIG = sig.fastSlowSIG(indData.ima14[SHIFT],indData.ima30[SHIFT],21);
//         fastIma530SIG = sig.fastSlowSIG(indData.ima5[SHIFT],indData.ima30[SHIFT],21);
//         fastIma30120SIG = sig.fastSlowSIG(indData.ima30[SHIFT],indData.ima120[SHIFT],21);
//         fastIma120240SIG = sig.fastSlowSIG(indData.ima120[SHIFT],indData.ima240[SHIFT],21);
//         fastIma240500SIG = sig.fastSlowSIG(indData.ima240[SHIFT],indData.ima500[SHIFT],21);
//         ima514SIG = sig.fastSlowTrendSIG(indData.ima5,indData.ima14,21,1);
//         ima1430SIG = sig.fastSlowTrendSIG(indData.ima14,indData.ima30,21,1);
//         ima30120SIG = sig.fastSlowTrendSIG(indData.ima30,indData.ima120,21,1);
//         ima30240SIG = sig.fastSlowTrendSIG(indData.ima30,indData.ima240,21,1);
//         ima120240SIG = sig.fastSlowTrendSIG(indData.ima120,indData.ima240,21,1);
//         ima120500SIG = sig.fastSlowTrendSIG(indData.ima120,indData.ima500,21,1);
//         ima240500SIG = sig.fastSlowTrendSIG(indData.ima240,indData.ima500,21,1);
//         ima530SIG = sig.fastSlowTrendSIG(indData.ima5,indData.ima30,21,1);
//         ima530_21SIG = sig.fastSlowTrendSIG(indData.ima5,indData.ima30,21,1);
//         candleImaSIG = sig.candleImaSIG(indData.open,indData.close,indData.ima5,indData.ima14,indData.ima30,5,SHIFT);
//         //   sig.pVElastSIG(indData.open,indData.close,indData.tick_volume,21,SHIFT);
//         candlePattStarSIG = sig.candleStar(indData.open,indData.high,indData.low,indData.close,0.1,0.5,21,1);
//         //trendRatioSIG = sig.trendRatioSIG(indData.ima30,"IMA30",21);
//         //slopeVarSIG = sig.slopeVarSIG(indData.ima14,indData.ima30,indData.ima120,21,1);
//         //slopeVarSIG = sig.slopeVarSIG(indData.ima5,indData.ima14,indData.ima30,21,1);
//         //slopeVarSIG = sig.slopeVarSIG(indData.ima30,indData.ima120,indData.ima240,21,1);
//         //imaSlopesData = sig.slopeVarData(indData.ima30,indData.ima120,indData.ima240,21,1);
//         //mfiSIG = sig.mfiSIG(indData.mfi,trendSlopeSIG,10,1);
//         mfiSIG = sig.mfiSIG(indData.mfi,trendRatioSIG,21,1);
//         tradeVolVarSIG = sig.tradeVolVarSignal(volSIG,ima30SDSIG,ima120SDSIG,ima240SDSIG);
//         trendSlope5SIG = sig.trendSlopeSIG(indData.ima5,"IMA5",21);
//         trendSlope14SIG = sig.trendSlopeSIG(indData.ima14,"IMA14",21);
//         trendSlope30SIG = sig.trendSlopeSIG(indData.ima30,"IMA30",21);
//         trendSlopeSIG = trendSlope5SIG;
//         //trendRatioSIG = sig.trendRatioSIG(indData.ima30,"IMA30",2,21);
//         //adxCovDivSIG = sig.adxCovDivSIG(indData.adx,indData.adxPlus,indData.adxMinus);
//         rsiSIG = sig.rsiSIG(indData.rsi,21,1);
//         imaSlopesData = sig.slopeFastMediumSlow(indData.ima30,indData.ima120,indData.ima240,5,10,1);
   atrSIG =  sig.atrSIG(indData.atr, 21);
   rsiSIG = sig.rsiSIG(indData.rsi[1], 40, 60);
   priceActionSIG =  sig.priceActionCandleSIG(indData.open, indData.high, indData.low, indData.close);
   volSIG =  sig.volumeSIG_v2(indData.tick_volume, 60, 11, SHIFT);
   volSlopeSIG = sig.volScatterSlopeSIG(indData.tick_volume, 100, 0.1, SHIFT);
   profitSIG = sig.closeOnProfitSIG(indData.currProfit, indData.closeProfit, 0);
   profitPercentageSIG = sig.closeOnProfitPercentageSIG(indData.currProfit, indData.maxProfit, indData.closeProfit);
   lossSIG = sig.closeOnLossSIG(indData.stopLoss, 0);
   fsig5 = sig.fastSlowSIG(indData.close[SHIFT], indData.ima5[SHIFT], 21);
   fsig14 = sig.fastSlowSIG(indData.close[SHIFT], indData.ima14[SHIFT], 21);
   fsig30 = sig.fastSlowSIG(indData.close[SHIFT], indData.ima30[SHIFT], 21);
   fsig60 = sig.fastSlowSIG(indData.close[SHIFT], indData.ima60[SHIFT], 21);
   fsig120 = sig.fastSlowSIG(indData.close[SHIFT], indData.ima120[SHIFT], 21);
   fsig240 = sig.fastSlowSIG(indData.close[SHIFT], indData.ima240[SHIFT], 21);
   fsig500 = sig.fastSlowSIG(indData.close[SHIFT], indData.ima500[SHIFT], 21);
   sig5 = sig.fastSlowTrendSIG(indData.close, indData.ima5, 21, 1);
   sig14 = sig.fastSlowTrendSIG(indData.close, indData.ima14, 21, 1);
   sig30 = sig.fastSlowTrendSIG(indData.close, indData.ima30, 21, 1);
   sig120 = sig.fastSlowTrendSIG(indData.close, indData.ima120, 21, 1);
   sig240 = sig.fastSlowTrendSIG(indData.close, indData.ima240, 21, 1);
   sig500 = sig.fastSlowTrendSIG(indData.close, indData.ima500, 21, 1);
   cpSDSIG = sig.stdDevSIG(indData.close, "CP", 21, SHIFT);
   ima5SDSIG = sig.stdDevSIG(indData.ima5, "IMA5", 21, SHIFT);
   ima14SDSIG = sig.stdDevSIG(indData.ima14, "IMA14", 21, SHIFT);
   ima30SDSIG = sig.stdDevSIG(indData.ima30, "IMA30", 21, SHIFT);
   ima120SDSIG = sig.stdDevSIG(indData.ima120, "IMA120", 21, SHIFT);
   ima240SDSIG = sig.stdDevSIG(indData.ima240, "IMA240", 21, SHIFT);
   ima500SDSIG = sig.stdDevSIG(indData.ima500, "IMA500", 21, SHIFT);
   candleVolSIG = sig.candleVolSIG_v1(indData.open, indData.close, indData.tick_volume, 60, SHIFT);
   candleVol120SIG = sig.candleVolSIG_v1(indData.open, indData.close, indData.tick_volume, 120, SHIFT);   
   candleVol120SIG_V2 = sig.candleVolSIG_v2(indData.open, indData.close, indData.tick_volume, 120, SHIFT);
   
   //slopeVarSIG = sig.slopeVarSIG(indData.ima30,indData.ima120,indData.ima240,5,10,1);
   slopeVarSIG = sig.slopeVarSIG(indData.ima5, indData.ima14, indData.ima30, 5, 10, 1);
   cpScatter21SIG = sig.trendScatterPlotSIG(indData.close, "Scatter-CP", 0.04, 21);
   cpScatterSIG = sig.trendScatterPlotSIG(indData.close, "Scatter-CP", 0.04, 120);
   trendRatio5SIG = sig.trendRatioSIG(indData.ima5, "IMA5", 2, 21);
   trendRatio14SIG = sig.trendRatioSIG(indData.ima14, "IMA14", 2, 21);
   trendRatio30SIG = sig.trendRatioSIG(indData.ima30, "IMA30", 2, 21);
   trendRatio120SIG = sig.trendRatioSIG(indData.ima120, "IMA120", 2, 21);
   trendRatio240SIG = sig.trendRatioSIG(indData.ima240, "IMA240", 2, 21);
   trendRatio500SIG = sig.trendRatioSIG(indData.ima500, "IMA500", 2, 21);
   trendRatioSIG = trendRatio120SIG;
//############# DataTransport vars used in HSIG mostly ########################################
   imaSlope5Data = sig.slopeSIGData(indData.ima5, 5, 21, 1);
   imaSlope14Data = sig.slopeSIGData(indData.ima14, 5, 21, 1);
   imaSlope30Data = sig.slopeSIGData(indData.ima30, 5, 21, 1);
   imaSlope120Data = sig.slopeSIGData(indData.ima120, 5, 21, 1);
   baseSlopeData = sig.slopeSIGData(indData.ima240, 5, 21, 1);
   imaSlope500Data = sig.slopeSIGData(indData.ima500, 5, 21, 1);
   stdCPSlope = sig.slopeSIGData(indData.std, 5, 21, 1);
   stdOPSlope = sig.slopeSIGData(indData.stdOpen, 5, 21, 1);
   obvCPSlope = sig.slopeSIGData(indData.obv, 5, 21, 1);
   obvCPSIG = sig.obvCPSIG(indData.obv, 5, 21, 1);
   tradeSlopeSIG = sig.tradeSlopeSIG(imaSlope120Data, baseSlopeData, indData.magicnumber);
   volatilitySIG = sig.volatilitySlopeSignal(stdOPSlope,stdCPSlope);
   clusterData = sig.clusterData(indData.ima5[1], indData.ima14[1], indData.ima30[1]);
   slopeRatioData = sig.slopeRatioData(imaSlope5Data, imaSlope14Data, imaSlope30Data);
   //c_SIG = sig.cSIG(indData,util,1);
//#############################################################################################
//        varDt = sig.varSIG(ima30SDSIG,ima120SDSIG,ima240SDSIG);
   //stats.hilbertTransform(indData.close,hilbertAmp,hilbertPhase,8,3);
//   stats.dftTransform(indData.close,dftMag,dftPhase,dftPower,8);
//   hilbertDftSIG = sig.hilbertDftSIG(indData.close,indData.currSpread,(indData.std[1]/util.getPipValue(_Symbol)),16,5);
//   hilbertDftSIG = sig.hilbertDftSIG(indData.close,indData.rsi[1],indData.currSpread,(indData.std[1]/util.getPipValue(_Symbol)),8,3);
//   hilbertSIG = sig.hilbertSIG(indData.close,indData.currSpread,(indData.std[1]/util.getPipValue(_Symbol)),8,3);
//   dftSIG = sig.dftSIG(indData.close,8);
   atrVolData = sig.atrVolDt(indData.atr, indData.tick_volume, 10, 1, 1);
   candleVolData = sig.candleVolDt(indData.open, indData.close, indData.tick_volume, 10, 1, 1);
   //sig.openCloseDt(indData.open,indData.close,10,1,1);
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void   SS::printSignalStruct(SanUtils &util) {
   double currSpread = (int)MarketInfo(_Symbol, MODE_SPREAD);
   Print("profitPercentageSIG: " + util.getSigString(profitPercentageSIG) + " lossSIG: " + util.getSigString(lossSIG) + " profitSIG: " + util.getSigString(profitSIG) + " cpSDSIG: " + util.getSigString(cpSDSIG) + " ima5SDSIG: " + util.getSigString(ima5SDSIG) + " ima14SDSIG: " + util.getSigString(ima14SDSIG) + " ima30SDSIG: " + util.getSigString(ima30SDSIG) + " ima120SDSIG: " + util.getSigString(ima120SDSIG));
   Print("ScatterTrend: " + util.getSigString(trendScatterSIG) + " ScatterTrend5: " + util.getSigString(trendScatter5SIG) + " ScatterTrend14: " + util.getSigString(trendScatter14SIG) + " ScatterTrend30: " + util.getSigString(trendScatter30SIG) + " trendVolSIG: " + util.getSigString(trendVolRatioSIG) + " trendVolStrengthSIG: " + util.getSigString(trendVolRatioStrengthSIG) + " trendRatioSIG: " + util.getSigString(trendRatioSIG));
   Print("Trend slope: " + util.getSigString(trendSlopeSIG) + " Trend5 slope: " + util.getSigString(trendSlope5SIG) + " Trend14 slope: " + util.getSigString(trendSlope14SIG) + " Trend30 slope: " + util.getSigString(trendSlope30SIG) + " slopeVarSIG:" + util.getSigString(slopeVarSIG) + " acfTrendSIG: " + util.getSigString(acfTrendSIG) + " acfStrengthSIG: " + util.getSigString(acfStrengthSIG));
   Print("priceActionSIG: " + util.getSigString(priceActionSIG) + " volSIG: " + util.getSigString(volSIG) + " candleImaSIG: " + util.getSigString(candleImaSIG) + " candleVolSIG: " + util.getSigString(candleVolSIG) + " candlePattStarSIG: " + util.getSigString(candlePattStarSIG) + " adxSIG: " + util.getSigString(adxSIG) + " atrSIG: " + util.getSigString(atrSIG) + " mfiSIG: " + util.getSigString(mfiSIG));
   Print("sig5: " + util.getSigString(sig5) + " sig14: " + util.getSigString(sig14) + " sig30: " + util.getSigString(sig30) + " ima514SIG: " + util.getSigString(ima514SIG) + " ima1430SIG: " + util.getSigString(ima1430SIG) + " ima530SIG: " + util.getSigString(ima530SIG) + " ima530_21SIG: " + util.getSigString(ima530_21SIG) + " ima30120SIG: " + util.getSigString(ima30120SIG));
   Print("fsig5: " + util.getSigString(fsig5) + " fsig14: " + util.getSigString(fsig14) + " fsig30: " + util.getSigString(fsig30) + " fastIma514SIG: " + util.getSigString(fastIma514SIG) + " fastIma1430SIG: " + util.getSigString(fastIma1430SIG) + " fastIma530SIG: " + util.getSigString(fastIma530SIG) + " fastIma30120SIG: " + util.getSigString(fastIma30120SIG));
   Print("Spread: " + currSpread + " openSIG: " + util.getSigString(openSIG) + " closeSIG: " + util.getSigString(closeSIG));
}
//+------------------------------------------------------------------+
