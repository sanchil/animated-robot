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


ORDERPARAMS       op1;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class SanStrategies {
 private:
   int               ticket;

   struct SS:public SANSIGNALS {

      SS(SanSignals &sig, const INDDATA &indData, const int SHIFT) {
           //initBase();
         //Print("SS: ima30 current 1: "+indData.ima30[1]+" :ima30 5: "+ indData.ima30[5]+" :ima30 10: "+ indData.ima30[10]+" :21:" + indData.ima30[21]);
         //########################################################################################################
         //########################################################################################################

//         //    tradeSIG = sig.tradeSignal(indData.std[SHIFT],indData.mfi[SHIFT],indData.atr,indData.adx[SHIFT],indData.adxPlus[SHIFT],indData.adxMinus[SHIFT]);
//         adxSIG =  sig.adxSIG(indData.adx[SHIFT],indData.adxPlus[SHIFT],indData.adxMinus[SHIFT]);
//         atrSIG =  sig.atrSIG(indData.atr,21);
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
           //rsiSIG = sig.rsiSIG(indData.rsi,21,1);
//         imaSlopesData = sig.slopeFastMediumSlow(indData.ima30,indData.ima120,indData.ima240,5,10,1);


         priceActionSIG =  sig.priceActionCandleSIG(indData.open,indData.high,indData.low,indData.close);
         volSIG =  sig.volumeSIG_v2(indData.tick_volume,60,11,SHIFT);

         profitSIG = sig.closeOnProfitSIG(indData.currProfit,indData.closeProfit,0);
         profitPercentageSIG = sig.closeOnProfitPercentageSIG(indData.currProfit,indData.maxProfit,indData.closeProfit);
         lossSIG = sig.closeOnLossSIG(indData.stopLoss,0);

         fsig5 = sig.fastSlowSIG(indData.close[SHIFT], indData.ima5[SHIFT],21);
         fsig14 = sig.fastSlowSIG(indData.close[SHIFT], indData.ima14[SHIFT],21);
         fsig30 = sig.fastSlowSIG(indData.close[SHIFT], indData.ima30[SHIFT],21);
         fsig120 = sig.fastSlowSIG(indData.close[SHIFT], indData.ima120[SHIFT],21);
         fsig240 = sig.fastSlowSIG(indData.close[SHIFT], indData.ima240[SHIFT],21);
         fsig500 = sig.fastSlowSIG(indData.close[SHIFT], indData.ima500[SHIFT],21);
         sig5 = sig.fastSlowTrendSIG(indData.close, indData.ima5,21,1);
         sig14 = sig.fastSlowTrendSIG(indData.close, indData.ima14,21,1);
         sig30 = sig.fastSlowTrendSIG(indData.close, indData.ima30,21,1);
         sig120 = sig.fastSlowTrendSIG(indData.close, indData.ima120,21,1);
         sig240 = sig.fastSlowTrendSIG(indData.close, indData.ima240,21,1);
         sig500 = sig.fastSlowTrendSIG(indData.close, indData.ima500,21,1);


         cpSDSIG = sig.stdDevSIG(indData.close,"CP",21,SHIFT);
         ima5SDSIG = sig.stdDevSIG(indData.ima5,"IMA5",21,SHIFT);
         ima14SDSIG = sig.stdDevSIG(indData.ima14,"IMA14",21,SHIFT);
         ima30SDSIG = sig.stdDevSIG(indData.ima30,"IMA30",21,SHIFT);
         ima120SDSIG = sig.stdDevSIG(indData.ima120,"IMA120",21,SHIFT);
         ima240SDSIG = sig.stdDevSIG(indData.ima240,"IMA240",21,SHIFT);
         ima500SDSIG = sig.stdDevSIG(indData.ima500,"IMA500",21,SHIFT);

         candleVolSIG = sig.candleVolSIG_v1(indData.open,indData.close,indData.tick_volume,60,SHIFT);
         candleVol120SIG = sig.candleVolSIG_v1(indData.open,indData.close,indData.tick_volume,120,SHIFT);

         slopeVarSIG = sig.slopeVarSIG(indData.ima30,indData.ima120,indData.ima240,5,10,1);


         cpScatter21SIG = sig.trendScatterPlotSIG(indData.close,"Scatter-CP",0.1,21);
         cpScatterSIG = sig.trendScatterPlotSIG(indData.close,"Scatter-CP",0.1,120);


         trendRatio5SIG = sig.trendRatioSIG(indData.ima5,"IMA5",2,21);
         trendRatio14SIG = sig.trendRatioSIG(indData.ima14,"IMA14",2,21);
         trendRatio30SIG = sig.trendRatioSIG(indData.ima30,"IMA30",2,21);
         trendRatio120SIG = sig.trendRatioSIG(indData.ima120,"IMA120",2,21);
         trendRatio240SIG = sig.trendRatioSIG(indData.ima240,"IMA240",2,21);
         trendRatio500SIG = sig.trendRatioSIG(indData.ima500,"IMA500",2,21);
         trendRatioSIG = trendRatio120SIG;

         clusterSIG = sig.clusterSIG(indData.ima30[1],indData.ima120[1],indData.ima240[1]);
         //############# DataTransport vars used in HSIG mostly ########################################


         imaSlope14Data=sig.slopeSIGData(indData.ima14,5,21,1);
         imaSlope30Data=sig.slopeSIGData(indData.ima30,5,21,1);
         imaSlope120Data=sig.slopeSIGData(indData.ima120,5,21,1);
         baseSlopeData=sig.slopeSIGData(indData.ima240,5,21,1);
         imaSlope500Data=sig.slopeSIGData(indData.ima500,5,21,1);
         stdCPSlope = sig.slopeSIGData(indData.std,5,21,1);
         
         //simpleSlope_14_SIG = sig.slopeSIG(imaSlope14Data,0);   
         //simpleSlope_30_SIG = sig.slopeSIG(imaSlope30Data,0);
         //simpleSlope_120_SIG = sig.slopeSIG(imaSlope120Data,1);
         //simpleSlope_240_SIG = sig.slopeSIG(baseSlopeData,2);   
               
         slopeRatioData = sig.slopeRatioData(imaSlope30Data,imaSlope120Data,baseSlopeData);         
         //c_SIG = sig.cSIG(indData,util,1);

         //#############################################################################################

//        varDt = sig.varSIG(ima30SDSIG,ima120SDSIG,ima240SDSIG);

      }

      ~SS() {}

      void   printSignalStruct(SanUtils &util) {
         double currSpread = (int)MarketInfo(_Symbol,MODE_SPREAD);
         Print("profitPercentageSIG: "+util.getSigString(profitPercentageSIG)+" lossSIG: "+util.getSigString(lossSIG)+" profitSIG: "+util.getSigString(profitSIG)+" cpSDSIG: "+util.getSigString(cpSDSIG)+" ima5SDSIG: "+util.getSigString(ima5SDSIG)+" ima14SDSIG: "+util.getSigString(ima14SDSIG)+" ima30SDSIG: "+util.getSigString(ima30SDSIG)+" ima120SDSIG: "+util.getSigString(ima120SDSIG));
         Print("ScatterTrend: "+util.getSigString(trendScatterSIG)+" ScatterTrend5: "+util.getSigString(trendScatter5SIG)+" ScatterTrend14: "+util.getSigString(trendScatter14SIG)+" ScatterTrend30: "+util.getSigString(trendScatter30SIG)+" trendVolSIG: "+util.getSigString(trendVolRatioSIG)+" trendVolStrengthSIG: "+util.getSigString(trendVolRatioStrengthSIG)+" trendRatioSIG: "+util.getSigString(trendRatioSIG));
         Print("Trend slope: "+util.getSigString(trendSlopeSIG)+" Trend5 slope: "+util.getSigString(trendSlope5SIG)+" Trend14 slope: "+util.getSigString(trendSlope14SIG)+" Trend30 slope: "+util.getSigString(trendSlope30SIG)+" slopeVarSIG:"+util.getSigString(slopeVarSIG)+" acfTrendSIG: "+util.getSigString(acfTrendSIG)+" acfStrengthSIG: "+util.getSigString(acfStrengthSIG));
         Print("priceActionSIG: "+util.getSigString(priceActionSIG)+" volSIG: "+util.getSigString(volSIG)+" candleImaSIG: "+util.getSigString(candleImaSIG)+" candleVolSIG: "+util.getSigString(candleVolSIG)+" candlePattStarSIG: "+util.getSigString(candlePattStarSIG)+" adxSIG: "+util.getSigString(adxSIG)+" atrSIG: "+util.getSigString(atrSIG)+" mfiSIG: "+util.getSigString(mfiSIG));
         Print("sig5: "+util.getSigString(sig5)+" sig14: "+util.getSigString(sig14)+" sig30: "+util.getSigString(sig30)+" ima514SIG: "+util.getSigString(ima514SIG)+" ima1430SIG: "+util.getSigString(ima1430SIG)+" ima530SIG: "+util.getSigString(ima530SIG)+" ima530_21SIG: "+util.getSigString(ima530_21SIG)+" ima30120SIG: "+util.getSigString(ima30120SIG));
         Print("fsig5: "+util.getSigString(fsig5)+" fsig14: "+util.getSigString(fsig14)+" fsig30: "+util.getSigString(fsig30)+" fastIma514SIG: "+util.getSigString(fastIma514SIG)+" fastIma1430SIG: "+util.getSigString(fastIma1430SIG)+" fastIma530SIG: "+util.getSigString(fastIma530SIG)+" fastIma30120SIG: "+util.getSigString(fastIma30120SIG));
         Print("Spread: "+currSpread+" openSIG: "+util.getSigString(openSIG)+" closeSIG: "+util.getSigString(closeSIG)+" tradeSIG: "+util.getSigString(tradeSIG));
      }
   };


 public:
   SanStrategies();
   ~SanStrategies();
   SIGBUFF           imaSt1(const INDDATA &indData);
   SIGBUFF           paSt1(const INDDATA &indData);
   SIGBUFF           paSt2(const INDDATA &indData);
   SAN_SIGNAL        getSlopeSIG(const DataTransport& signalDt, const int signalType=0);
   string            getJsonData(const INDDATA &indData,SanSignals &sig, SanUtils& util,int shift=1);
   bool              writeOHLCVJsonData(string filename, const INDDATA &indData,SanSignals &sig, SanUtils& util,int shift=1);
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SanStrategies::SanStrategies() {

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
   SAN_SIGNAL openSIG = SAN_SIGNAL::NOSIG;
   SAN_SIGNAL closeSIG = SAN_SIGNAL::NOSIG;

// ################# Open Signal ###################################################

   bool spreadBool = (indData.currSpread < tl.spreadLimit);

//   SANSIGBOOL sb(ss);
//   sb.spreadBool = spreadBool;
//   sb.printStruct();

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
   bool tradeBool = (ss.tradeSIG==SAN_SIGNAL::TRADE);
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
   dominantSIG = sig.dominantTrendSIG(ss,hSig);

   bool notFlatBool = (varBool && (varPosBool||varNegBool) && (hSig.mktType==MKTTYP::MKTTR));
   bool flatBool = (varFlatBool && (hSig.mktType==MKTTYP::MKTFLAT));

   bool basicOpenVolBool = (spreadVolBool && notFlatBool);
   bool basicOpenBool = (spreadBool && notFlatBool);

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

//Print("[CLOSE SIG]:: closeTradeL5: "+closeTradeL5+" 9: "+closeTrade9+"11: "+closeTrade11+" 12: "+closeTrade12+" 16: "+closeTrade16+" 14: "+closeTrade14+" 26: "+closeTrade26+" 27: "+closeTrade27+" 28: "+closeTrade28+" 29: "+closeTrade29);
//Print("[SLOW]:: IMA30120TR240: "+util.getSigString(hSig.dominantTrendIma120SIG)+" trendRatioSIG: "+util.getSigString(slopeTrendSIG)+" CP120 : "+util.getSigString(ss.cpScatterSIG)+" ima30120SIG: "+util.getSigString(ss.ima30120SIG)+" ima120240SIG: "+util.getSigString(ss.ima120240SIG)+" fsig120: "+util.getSigString(ss.fsig120)+" fsig240: "+util.getSigString(ss.fsig240)+" sig30: "+util.getSigString(ss.sig30)+" sig120: "+util.getSigString(ss.sig120)+" sig240: "+util.getSigString(ss.sig240));
//Print("[FAST]::  ima514:: "+util.getSigString(ss.ima514SIG)+" ima1430: "+util.getSigString(ss.ima1430SIG)+" fIma514: "+util.getSigString(ss.fastIma514SIG)+" fIma1430: "+util.getSigString(ss.fastIma1430SIG)+" fIma30120: "+util.getSigString(ss.fastIma30120SIG)+" fIma120240: "+util.getSigString(ss.fastIma120240SIG)+": RSI::"+util.getSigString(ss.rsiSIG));
//Print("[BOOLS]: basicOpenBool: "+basicOpenBool+" basicOpenVolBool: "+basicOpenVolBool+" slopeTrendBool: "+slopeTrendBool+" varBool:"+varBool+" vol: "+util.getSigString(ss.volSIG));
// Print("[TIME] : Current: "+ TimeToString(TimeCurrent(), TIME_DATE|TIME_MINUTES)+" GMT: "+ TimeToString(TimeGMT(), TIME_DATE|TIME_MINUTES));

   // Print("[MAIN][SLOW]:: domSIG: "+util.getSigString(dominantSIG)+" trendSIG:: "+util.getSigString(hSig.dominantTrendSIG)+" dom240:: "+util.getSigString(hSig.dominant240SIG)+" IMA120240TR240:: "+util.getSigString(hSig.dominantTrendIma240SIG)+" dom120:: "+util.getSigString(hSig.dominant120SIG)+" IMA30120TR240:: "+util.getSigString(hSig.dominantTrendIma120SIG)+" cpSlopeVarFAST: "+util.getSigString(hSig.cpSlopeVarFastSIG)+" VolVar: "+util.getSigString(hSig.domVolVarSIG)+" TrCP: "+util.getSigString(hSig.dominantTrendCPSIG)+" TrIMA: "+util.getSigString(hSig.domTrIMA));
//   Print("[MAIN][SLOW]:: domSIG: "+util.getSigString(dominantSIG)+" trendSIG:: "+util.getSigString(hSig.dominantTrendSIG)+" fastSIG:: "+util.getSigString(hSig.fastSIG)+" IMA120240TR240:: "+util.getSigString(hSig.dominantTrendIma240SIG)+" dom120:: "+util.getSigString(hSig.dominant120SIG)+" IMA30120TR240:: "+util.getSigString(hSig.dominantTrendIma120SIG)+" cpSlopeVarFAST: "+util.getSigString(hSig.cpSlopeVarFastSIG)+" VolVar: "+util.getSigString(hSig.domVolVarSIG)+" TrCP: "+util.getSigString(hSig.dominantTrendCPSIG)+" TrIMA: "+util.getSigString(hSig.domTrIMA));
//   Print("[MAIN][FAST]:: mainFast: "+util.getSigString(hSig.mainFastSIG)+" slopeFast: "+util.getSigString(hSig.slopeFastSIG)+" rsiFAST: "+util.getSigString(hSig.rsiFastSIG)+" cpFAST: "+util.getSigString(hSig.cpFastSIG)+" candleVol120SIG: "+util.getSigString(ss.candleVol120SIG)+" slopeSIG: "+util.getSigString(ss.slopeVarSIG)+" CP120: "+util.getSigString(ss.cpScatterSIG)+" ima1430: "+util.getSigString(ss.ima1430SIG));

   Print("[MAIN][SLOW]:: domSIG: "+util.getSigString(dominantSIG)+" trendSIG:: "+util.getSigString(hSig.dominantTrendSIG)+" fastSIG:: "+util.getSigString(hSig.fastSIG));
   //Print("[MAIN][FAST]:: candleVol120SIG: "+util.getSigString(ss.candleVol120SIG)+" slopeSIG: "+util.getSigString(ss.slopeVarSIG)+" CP120: "+util.getSigString(ss.cpScatterSIG)+" ima1430: "+util.getSigString(ss.ima1430SIG));
   Print("[CLOSE] :: CloseSIG:"+util.getSigString(ss.closeSIG)+" closeTrade: "+closeTrade+" CloseFlat: "+closeFlatTrade+" SimpleClose14_30:: "+util.getSigString(hSig.simpleTrend_14_30_SIG));
   Print("[OPEN] ::  fastSIG: "+util.getSigString(hSig.fastSIG)+" simpleSig_5_14:"+util.getSigString(hSig.simple_5_14_SIG)+" Slope30: "+util.getSigString(hSig.simpleSlope_30_SIG)+" c_SIG: "+util.getSigString(hSig.c_SIG)+" Base Trend: "+util.getSigString(hSig.baseTrendSIG)+" Base Slope: "+util.getSigString(hSig.baseSlopeSIG));

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
   Print("[MARKET]: Mkt Type: "+util.getSigString(hSig.mktType)+" Trade strategy: "+util.getSigString(hSig.trdStgy)+" var: "+varBool+" varFlat: "+varFlatBool+" slpTrVar: "+slopeTrendVarBool);
   Print("[SIGNAL]: New Candle: "+op1.NEWCANDLE+" Spread: "+indData.currSpread+" CurrPos: "+util.getSigString(tradePosition)+" OpenSIG:"+util.getSigString(ss.openSIG)+" CloseSIG:"+util.getSigString(ss.closeSIG)+" closeTrade: "+closeTrade+" CloseFlat: "+closeFlatTrade+" PL:"+util.getSigString(ss.profitPercentageSIG)+" Loss:"+util.getSigString(ss.lossSIG));

   return sigBuff;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string SanStrategies::getJsonData(const INDDATA &indData, SanSignals &sig, SanUtils& util, int shift=1) {
   string prntStr="";
   string prntStrOpen="{ ";
   string prntStrClose=" }";
   prntStr += prntStrOpen;
   DataTransport dt14 = sig.slopeSIGData(indData.ima14,5,21,1);
   DataTransport dt30 = sig.slopeSIGData(indData.ima30,5,21,1);
   DataTransport dt120 = sig.slopeSIGData(indData.ima120,5,21,1);
   DataTransport dt240 = sig.slopeSIGData(indData.ima240,5,21,1);
   DataTransport dt500 = sig.slopeSIGData(indData.ima500,5,21,1);
   DataTransport stdCPSlope = sig.slopeSIGData(indData.std,5,21,1);//
   DataTransport clusterData = sig.clusterSIG(indData.ima30[1],indData.ima120[1],indData.ima240[1]);
   DataTransport slopeRatioData = sig.slopeRatioData(dt30,dt120,dt240);
   
   SAN_SIGNAL c_SIG = sig.cSIG(indData,util,1);
   SAN_SIGNAL baseSIG = sig.slopeSIG(dt240,2);
   //SAN_SIGNAL tradeSIG = (c_SIG==baseSIG)?c_SIG:SAN_SIGNAL::NOSIG;
   SAN_SIGNAL tradeSIG = c_SIG;
   
   
   SAN_SIGNAL TRADESIG = (indData.currSpread < tl.spreadLimit)?
//                         sig.slopeSIG(dt30,0)
                         tradeSIG
                         :
                         SAN_SIGNAL::NOTRADE;
       

   prntStr += " \"DateTime\":\""+(TimeToString(TimeCurrent(), TIME_DATE|TIME_MINUTES))+"\",";
   prntStr += " \"CurrencyPair\":\""+util.getSymbolString(Symbol())+"\",";
   prntStr += " \"TimeFrame\":\""+util.getSymbolString(Period())+"\",";
   prntStr += " \"Spread\":"+(int)MarketInfo(_Symbol,MODE_SPREAD)+",";
   prntStr += " \"Open\":"+DoubleToString(Open[1],8)+",";
   prntStr += " \"High\":"+DoubleToString(High[1],8)+",";
   prntStr += " \"Low\":"+DoubleToString(Low[1],8)+",";
   prntStr += " \"Close\":"+DoubleToString(Close[1],8)+",";
   prntStr += " \"Volume\":"+DoubleToString(Volume[1],8)+",";
   prntStr += " \"StdDevCp\":"+DoubleToString(indData.std[1],8)+",";
   prntStr += " \"ATR\":"+DoubleToString(indData.atr[1],8)+",";
   prntStr += " \"RSI\":"+DoubleToString(indData.rsi[1],8)+",";

   prntStr += " \"SlopeIMA14\":"+DoubleToString(dt14.matrixD[0],8)+",";
   prntStr += " \"SlopeIMA30\":"+DoubleToString(dt30.matrixD[0],8)+",";
   prntStr += " \"SlopeIMA120\":"+DoubleToString(dt120.matrixD[0],8)+",";
   prntStr += " \"SlopeIMA240\":"+DoubleToString(dt240.matrixD[0],8)+",";
   prntStr += " \"SlopeIMA500\":"+DoubleToString(dt500.matrixD[0],8)+",";
   prntStr += " \"STDSlope\":"+DoubleToString(stdCPSlope.matrixD[0],8)+",";
   prntStr += " \"RFM\":"+DoubleToString(clusterData.matrixD[0],8)+",";
   prntStr += " \"RMS\":"+DoubleToString(clusterData.matrixD[1],8)+",";
   prntStr += " \"RFS\":"+DoubleToString(clusterData.matrixD[2],8)+",";
   prntStr += " \"fMSR\":"+DoubleToString(slopeRatioData.matrixD[0],8)+",";
   prntStr += " \"fMSWR\":"+DoubleToString(slopeRatioData.matrixD[1],8)+",";

   prntStr += " \"MovingAvg5\":"+DoubleToString(indData.ima5[1],8)+",";
   prntStr += " \"MovingAvg14\":"+DoubleToString(indData.ima14[1],8)+",";
   prntStr += " \"MovingAvg30\":"+DoubleToString(indData.ima30[1],8)+",";
   prntStr += " \"MovingAvg60\":"+DoubleToString(indData.ima60[1],8)+",";
   prntStr += " \"MovingAvg120\":"+DoubleToString(indData.ima120[1],8)+",";
   prntStr += " \"MovingAvg240\":"+DoubleToString(indData.ima240[1],8)+",";
   prntStr += " \"MovingAvg500\":"+DoubleToString(indData.ima500[1],8)+",";
   prntStr += " \"ORDER\":\""+util.getSigString(TRADESIG)+"\"";

   prntStr += prntStrClose;
   return prntStr;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SanStrategies::writeOHLCVJsonData(string filename, const INDDATA &indData, SanSignals &sig, SanUtils& util,int shift=1) {
   string data = getJsonData(indData,sig,util,shift);
   int fileHandle = FileOpen(filename, FILE_CSV|FILE_WRITE|FILE_READ);
   if(fileHandle == INVALID_HANDLE) {
      Print("Error opening file: ", GetLastError());
      return false;
   }
   if(fileHandle != INVALID_HANDLE) {
      FileSeek(fileHandle, 0, SEEK_END);
      FileWrite(fileHandle, data);
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
