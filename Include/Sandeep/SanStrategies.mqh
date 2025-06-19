//+------------------------------------------------------------------+
//|                                                SanStrategies.mqh |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include <Sandeep/SanSignals.mqh>


ORDERPARAMS       op1;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class SanStrategies
  {
private:
   int               ticket;

   struct SS:public SANSIGNALS
     {

                     SS(SanSignals &sig, const INDDATA &indData, const int SHIFT)
        {
         //Print("SS: ima30 current 1: "+indData.ima30[1]+" :ima30 5: "+ indData.ima30[5]+" :ima30 10: "+ indData.ima30[10]+" :21:" + indData.ima30[21]);
         tradeSIG = sig.tradeSignal(indData.std[SHIFT],indData.mfi[SHIFT],indData.atr,indData.adx[SHIFT],indData.adxPlus[SHIFT],indData.adxMinus[SHIFT]);

         adxSIG =  sig.adxSIG(indData.adx[SHIFT],indData.adxPlus[SHIFT],indData.adxMinus[SHIFT]);
         atrSIG =  sig.atrSIG(indData.atr,21);
         priceActionSIG =  sig.priceActionCandleSIG(indData.open,indData.high,indData.low,indData.close);

         fastIma514SIG = sig.fastSlowSIG(indData.ima5[SHIFT],indData.ima14[SHIFT],21);
         fastIma1430SIG = sig.fastSlowSIG(indData.ima14[SHIFT],indData.ima30[SHIFT],21);
         fastIma530SIG = sig.fastSlowSIG(indData.ima5[SHIFT],indData.ima30[SHIFT],21);
         fastIma30120SIG = sig.fastSlowSIG(indData.ima30[SHIFT],indData.ima120[SHIFT],21);
         fastIma120240SIG = sig.fastSlowSIG(indData.ima120[SHIFT],indData.ima240[SHIFT],21);
         fastIma240500SIG = sig.fastSlowSIG(indData.ima240[SHIFT],indData.ima500[SHIFT],21);
         ima514SIG = sig.fastSlowTrendSIG(indData.ima5,indData.ima14,21,1);
         ima1430SIG = sig.fastSlowTrendSIG(indData.ima14,indData.ima30,21,1);
         ima30120SIG = sig.fastSlowTrendSIG(indData.ima30,indData.ima120,21,1);
         ima30240SIG = sig.fastSlowTrendSIG(indData.ima30,indData.ima240,21,1);
         ima120240SIG = sig.fastSlowTrendSIG(indData.ima120,indData.ima240,21,1);
         ima120500SIG = sig.fastSlowTrendSIG(indData.ima120,indData.ima500,21,1);
         ima240500SIG = sig.fastSlowTrendSIG(indData.ima240,indData.ima500,21,1);
         ima530SIG = sig.fastSlowTrendSIG(indData.ima5,indData.ima30,21,1);
         ima530_21SIG = sig.fastSlowTrendSIG(indData.ima5,indData.ima30,21,1);

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
         candleImaSIG = sig.candleImaSIG(indData.open,indData.close,indData.ima5,indData.ima14,indData.ima30,5,SHIFT);

         volSIG =  sig.volumeSIG_v2(indData.tick_volume,60,11,SHIFT);

         //        adxCovDivSIG = sig.adxCovDivSIG(indData.adx,indData.adxPlus,indData.adxMinus);

         cpSDSIG = sig.stdDevSIG(indData.close,"CP",21,SHIFT);
         ima5SDSIG = sig.stdDevSIG(indData.ima5,"IMA5",21,SHIFT);
         ima14SDSIG = sig.stdDevSIG(indData.ima14,"IMA14",21,SHIFT);
         ima30SDSIG = sig.stdDevSIG(indData.ima30,"IMA30",21,SHIFT);
         ima120SDSIG = sig.stdDevSIG(indData.ima120,"IMA120",21,SHIFT);
         ima240SDSIG = sig.stdDevSIG(indData.ima240,"IMA240",21,SHIFT);
         ima500SDSIG = sig.stdDevSIG(indData.ima500,"IMA500",21,SHIFT);

         candleVolSIG = sig.candleVolSIG_v1(indData.open,indData.close,indData.tick_volume,60,SHIFT);
         candleVol120SIG = sig.candleVolSIG_v1(indData.open,indData.close,indData.tick_volume,120,SHIFT);
         //   sig.pVElastSIG(indData.open,indData.close,indData.tick_volume,21,SHIFT);
         candlePattStarSIG = sig.candleStar(indData.open,indData.high,indData.low,indData.close,0.1,0.5,21,1);
         //trendRatioSIG = sig.trendRatioSIG(indData.ima30,"IMA30",21);
         //slopeVarSIG = sig.slopeVarSIG(indData.ima14,indData.ima30,indData.ima120,21,1);
         //slopeVarSIG = sig.slopeVarSIG(indData.ima5,indData.ima14,indData.ima30,21,1);
         slopeVarSIG = sig.slopeVarSIG(indData.ima30,indData.ima120,indData.ima240,21,1);
         cpScatter21SIG = sig.trendScatterPlotSIG(indData.close,"Scatter-CP",0.1,21);
         cpScatterSIG = sig.trendScatterPlotSIG(indData.close,"Scatter-CP",0.1,120);

         //         trendScatter5SIG = sig.trendScatterPlotSIG(indData.ima5,"Scatter-IMA5",0.1,21);
         //         trendScatter14SIG = sig.trendScatterPlotSIG(indData.ima14,"Scatter-IMA14",0.1,21);
         //         trendScatter30SIG =sig.trendScatterPlotSIG(indData.ima30,"Scatter-IMA30",0.1,21);
         //
         trendSlope5SIG = sig.trendSlopeSIG(indData.ima5,"IMA5",21);
         trendSlope14SIG = sig.trendSlopeSIG(indData.ima14,"IMA14",21);
         trendSlope30SIG = sig.trendSlopeSIG(indData.ima30,"IMA30",21);
         trendSlopeSIG = trendSlope5SIG;
         //trendRatioSIG = sig.trendRatioSIG(indData.ima30,"IMA30",2,21);

         trendRatio5SIG = sig.trendRatioSIG(indData.ima5,"IMA5",2,21);
         trendRatio14SIG = sig.trendRatioSIG(indData.ima14,"IMA14",2,21);
         trendRatio30SIG = sig.trendRatioSIG(indData.ima30,"IMA30",2,21);
         trendRatio120SIG = sig.trendRatioSIG(indData.ima120,"IMA120",2,21);
         trendRatio240SIG = sig.trendRatioSIG(indData.ima240,"IMA240",2,21);
         trendRatio500SIG = sig.trendRatioSIG(indData.ima500,"IMA500",2,21);

         trendRatioSIG = trendRatio120SIG;

         //trendSumSig = sig.trendSIG(trendRatio5SIG,trendRatio120SIG,trendRatio500SIG);


         //mfiSIG = sig.mfiSIG(indData.mfi,trendSlopeSIG,10,1);
         mfiSIG = sig.mfiSIG(indData.mfi,trendRatioSIG,21,1);
         rsiSIG = sig.rsiSIG(indData.rsi,21,1);
         tradeVolVarSIG = sig.tradeVolVarSignal(volSIG,ima30SDSIG,ima120SDSIG,ima240SDSIG);
         clusterSIG = sig.clusterSIG(indData.ima30[1],indData.ima120[1],indData.ima240[1]);

        }

                    ~SS() {}

      void              printSignalStruct(SanUtils &util)
        {
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

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SanStrategies::SanStrategies()
  {

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SanStrategies::~SanStrategies()
  {
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SIGBUFF SanStrategies::imaSt1(const INDDATA &indData)
  {
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



   if(totalOrders>0)
     {
      for(int i=0; i<totalOrders; i++)
        {
         if(OrderSelect(i,SELECT_BY_POS))
           {
            if(OrderType()==OP_BUY)
               tradePosition=SAN_SIGNAL::BUY;
            if(OrderType()==OP_SELL)
               tradePosition=SAN_SIGNAL::SELL;
            if((OrderType()!=OP_SELL)&&(OrderType()!=OP_BUY)&&(OrderType()!=OP_SELLLIMIT)&&(OrderType()!=OP_BUYLIMIT)&&(OrderType()!=OP_SELLSTOP)&&(OrderType()!=OP_BUYSTOP))
               tradePosition=SAN_SIGNAL::NOSIG;
           }
        }
     }

   if(util.isNewBar())
     {
      op1.NEWCANDLE = true;
      op1.TRADED=false;
      op1.MAXPIPS=0;
     }
   if(!(util.isNewBar()) && (totalOrders > 0))
     {
      op1.NEWCANDLE = false;
      op1.TRADED=true;
     }
//
//   double candleSizePips = ((indData.close[0]-indData.close[1])/Point());
//   double candlePipSpeed = op1.pipsPerTick(candleSizePips);
//
//   if((candleSizePips!=NULL)||(candleSizePips!=0)||(candleSizePips!=EMPTY_VALUE))
//     {
//      op1.MAXPIPS = candleSizePips;
//      // Print("Current candle Pip Size: "+candleSizePips +" MaxPips: "+op1.MAXPIPS);
//     }
//
//   if(candlePipSpeed!=EMPTY)
//      //  Print("Pips per tick since new candle: "+candlePipSpeed);

   TRENDSTRUCT tRatioTrend;

   int SHIFT = (indData.shift || 1);

   SS ss(sig,indData,SHIFT);
   SAN_SIGNAL openSIG = SAN_SIGNAL::NOSIG;
   SAN_SIGNAL closeSIG = SAN_SIGNAL::NOSIG;

// ################# Open Signal ###################################################

   bool spreadBool = (indData.currSpread < tl.spreadLimit);

   SANSIGBOOL sb(ss);
   sb.spreadBool = spreadBool;
//   sb.printStruct();

//################################################################
//################################################################
//bool openOrder = ((totalOrders==0));
   bool openOrder = (op1.NEWCANDLE && (totalOrders==0));
   bool closeOrder = (!op1.NEWCANDLE && (totalOrders>0));
//SANTREND slopeTrendSIG = ss.acfTrendSIG;
   SANTREND slopeTrendSIG = ss.trendRatioSIG;
   SIGMAVARIABILITY varSIG = ss.ima120SDSIG;
   bool spreadVolBool = (sb.spreadBool && (ss.volSIG==SAN_SIGNAL::TRADE));


//################################################################
//################################################################

   bool trendBool = (sb.healthyTrendBool && sb.healthyTrendStrengthBool && !sb.flatTrendBool);
   bool atrBool = ((ss.atrSIG == SANTRENDSTRENGTH::NORMAL)||(ss.atrSIG == SANTRENDSTRENGTH::HIGH));
   bool sig5TrendBool = ((ss.sig5!=SAN_SIGNAL::NOSIG) && (ss.sig5==ss.priceActionSIG) && (ss.sig5==ss.adxSIG) && atrBool);
   bool tradeBool = (ss.tradeSIG==SAN_SIGNAL::TRADE);
   bool mfiSIGBool = ((ss.mfiSIG == SAN_SIGNAL::BUY)||(ss.mfiSIG == SAN_SIGNAL::SELL));
   bool mfiTradeTrendBool = (ss.mfiSIG==util.convTrendToSig(slopeTrendSIG));
   bool slopeTrendBool = ((slopeTrendSIG==SANTREND::UP)||(slopeTrendSIG==SANTREND::DOWN));

//########################################################################################

   double var30Val = util.getSigVarBool(ss.ima30SDSIG);
   bool var30Bool = ((var30Val!=0) && ((var30Val==1.314)||(var30Val==-1.314)));
   bool var30PosBool = ((var30Val!=0) && (var30Val==1.314));
   bool var30NegBool = ((var30Val!=0) && (var30Val==-1.314));
   bool var30FlatBool = (var30Val==0);

   double var120Val = util.getSigVarBool(ss.ima120SDSIG);
   bool var120Bool = ((var120Val!=0) && ((var120Val==1.314)||(var120Val==-1.314)));
   bool var120PosBool = ((var120Val!=0) && (var120Val==1.314));
   bool var120NegBool = ((var120Val!=0) && (var120Val==-1.314));
   bool var120FlatBool = (var120Val==0);

   double var240Val = util.getSigVarBool(ss.ima240SDSIG);
   bool var240Bool = ((var240Val!=0) && ((var240Val==1.314)||(var240Val==-1.314)));
   bool var240PosBool = ((var240Val!=0) && (var240Val==1.314));
   bool var240NegBool = ((var240Val!=0) && (var240Val==-1.314));
   bool var240FlatBool = (var240Val==0);

   bool varBool = (var30Bool&&var120Bool&&var240Bool);
   bool varPosBool = (varBool && (var30PosBool&&var120PosBool&&var240PosBool));
   bool varNegBool = (varBool && (var30NegBool&&var120NegBool&&var240NegBool));
   bool varFlatBool = (var30FlatBool||var120FlatBool||var240FlatBool);

//########################################################################################


   bool noVolWindPressure = ((ss.volSIG==SAN_SIGNAL::REVERSETRADE)||(ss.volSIG==SAN_SIGNAL::CLOSE));
//bool noVarBool = (variabilityVal==0);
   bool noVarBool = (!varBool);

   bool candleVol120Bool = (((ss.candleVol120SIG==SAN_SIGNAL::SELL)&&varNegBool)||((ss.candleVol120SIG==SAN_SIGNAL::BUY)&&varPosBool));
   bool slopeVarBool = (ss.slopeVarSIG==SAN_SIGNAL::SELL||ss.slopeVarSIG==SAN_SIGNAL::BUY);

   HSIG hSig(ss, util);
   dominantSIG = sig.dominantTrendSIG(ss,hSig);

//bool notFlatBool = (varBool &&(((slopeTrendSIG!=SANTREND::FLAT)&&(slopeTrendSIG!=SANTREND::NOTREND))||((ss.candleVol120SIG!=SAN_SIGNAL::SIDEWAYS)&&(ss.candleVol120SIG!=SAN_SIGNAL::NOSIG))));
//bool flatBool = (noVarBool && ((slopeTrendSIG==SANTREND::FLAT)||(ss.candleVol120SIG==SAN_SIGNAL::SIDEWAYS)||(ss.slopeVarSIG==SAN_SIGNAL::SIDEWAYS)));

   bool notFlatBool = (varBool && (hSig.mktType==MKTTYP::MKTTR));
   bool flatBool = (varFlatBool && (hSig.mktType==MKTTYP::MKTFLAT));


   bool basicOpenVolBool = (spreadVolBool && notFlatBool);
   bool basicOpenBool = (spreadBool && notFlatBool);

//   bool slopeTrendVarBool = (basicOpenVolBool && slopeTrendBool && varBool);
   bool slopeTrendVarBool = (basicOpenBool && slopeTrendBool);
   bool candleVolVar120Bool = (basicOpenVolBool && candleVol120Bool);



   bool fastOpenTrade1 = (spreadBool  && (ss.candleImaSIG!=SAN_SIGNAL::NOSIG));
   bool fastOpenTrade2 = (spreadBool && sb.starBool);
   bool fastOpenTrade3 = ((hSig.dominantTrendSIG!=SAN_SIGNAL::NOSIG)&&((hSig.slopeFastSIG==hSig.dominantTrendSIG) || (hSig.mainFastSIG==hSig.dominantTrendSIG)));
   bool fastOpenTrade4 = (slopeTrendVarBool && (ss.ima1430SIG!=SAN_SIGNAL::NOSIG) && (ss.ima1430SIG==hSig.dominantTrendSIG));   // ss.ima514SIG
   bool fastOpenTrade5 = (slopeTrendVarBool && (ss.slopeVarSIG!=SAN_SIGNAL::NOSIG) && (ss.slopeVarSIG==hSig.dominantTrendSIG));  // ss.slopeVarSIG
   bool fastOpenTrade6 = (candleVolVar120Bool && (ss.candleVol120SIG!=SAN_SIGNAL::NOSIG) && (ss.candleVol120SIG==hSig.dominantTrendSIG));  // ss.candleVol120SIG
//
//// #################################################################################
   bool fastOpenTrade10 = (fastOpenTrade3||fastOpenTrade4||fastOpenTrade5||fastOpenTrade6);
   bool fastOpenTrade11 = (slopeTrendVarBool && (dominantSIG!=SAN_SIGNAL::NOSIG) && (dominantSIG!=SAN_SIGNAL::CLOSE) && (dominantSIG!=SAN_SIGNAL::SIDEWAYS));

   bool fastOpenTrade12 = (fastOpenTrade11 && (dominantSIG==hSig.mainFastSIG));
   bool fastOpenTrade13 = (fastOpenTrade11 && (dominantSIG==hSig.slopeFastSIG));
   bool fastOpenTrade14 = (fastOpenTrade11 && (dominantSIG==hSig.rsiFastSIG));
   bool fastOpenTrade15 = (slopeTrendVarBool && (ss.fsig5!=SAN_SIGNAL::NOSIG) && (ss.fsig5!=SAN_SIGNAL::CLOSE));


   bool closeLoss = (ss.lossSIG == SAN_SIGNAL::CLOSE);
//bool closeProfitLoss = ((_Period >= PERIOD_M1) && (ss.profitPercentageSIG == SAN_SIGNAL::CLOSE));
   bool closeProfitLoss = ((_Period >= PERIOD_M1) && (ss.profitSIG == SAN_SIGNAL::CLOSE));


//SAN_SIGNAL pp = SAN_SIGNAL::CLOSE;
//bool closeProfitLoss1 = ((_Period >= PERIOD_M1) && (pp == SAN_SIGNAL::CLOSE));
//Print("PP: "+ (closeProfitLoss1&&closeOrder));

//#################################################
//bool closeTrade1 = sb.flatTrendBool;
//bool closeTrade2 = (ss.trendSlopeSIG==SANTREND::FLAT);
//bool closeTrade3 = flatBool; //((ss.candleVol120SIG==SAN_SIGNAL::SIDEWAYS));//||(slopeTrendSIG==SANTREND::FLAT));

//#################################################
// Other signals based close
//#################################################
   bool closeTrade8 = (util.oppSignal(ss.ima514SIG,tradePosition));
   bool closeTrade9 = (util.oppSignal(ss.candleVol120SIG,tradePosition));
   bool closeTrade10 = (util.oppSignal(ss.ima1430SIG,tradePosition));
   bool closeTrade11 = (util.oppSignal(ss.slopeVarSIG,tradePosition));
   bool closeTrade12 = (util.oppSignal(util.convTrendToSig(slopeTrendSIG),tradePosition));
   bool closeTrade13 = (util.oppSignal(ss.ima1430SIG,ss.ima30120SIG));
   bool closeTrade14 = (util.oppSignal(ss.ima30120SIG,tradePosition));
   bool closeTrade15 = (util.oppSignal(ss.ima30240SIG,tradePosition));
   bool closeTrade16 = (util.oppSignal(ss.fastIma514SIG,dominantSIG) && util.oppSignal(ss.fastIma1430SIG,dominantSIG) && util.oppSignal(ss.fastIma30120SIG,dominantSIG));
   bool closeTrade17 = ((ss.fastIma514SIG != SAN_SIGNAL::NOSIG) && (ss.fastIma514SIG == ss.fastIma1430SIG) && (ss.fastIma1430SIG == ss.fastIma30120SIG));
   bool closeTrade18 = (util.oppSignal(hSig.mainFastSIG,dominantSIG));
   bool closeTrade19 = (util.oppSignal(hSig.slopeFastSIG,dominantSIG));
   bool closeTrade20 = (util.oppSignal(hSig.rsiFastSIG,dominantSIG));



//bool closeTrade19 = (closeTrade10 || closeTrade14);

//bool closeTrade26 = ((noVolWindPressure &&(closeTrade8&&closeTrade10&&closeTrade9))||closeTrade14);
   bool closeTrade26 = (noVolWindPressure && (
                           (ss.candleVol120SIG==SAN_SIGNAL::SIDEWAYS)
                           ||(ss.slopeVarSIG==SAN_SIGNAL::SIDEWAYS)
                           ||(ss.trendRatioSIG==SANTREND::FLAT)
                           ||(ss.trendRatioSIG==SANTREND::FLATUP)
                           ||(ss.trendRatioSIG==SANTREND::FLATDOWN)));

   bool closeTrade27 = (closeTrade16 && closeTrade17 && (dominantSIG!=SAN_SIGNAL::SIDEWAYS));
   bool closeTrade28 = ((closeTrade8&&closeTrade10)&&(closeTrade9||closeTrade11||closeTrade12));

   bool closeTrade29 = ((dominantSIG == SAN_SIGNAL::CLOSE)||(util.oppSignal(dominantSIG,tradePosition)));
   bool closeTradeL1 = (closeTrade14);
   bool closeTradeL2 = (closeTrade9||closeTrade14);
   bool closeTradeL3 = (closeTrade14||closeTrade26||closeTrade27||closeTrade28||closeTrade29);
   bool closeTradeL5 = (closeTrade29);
//   bool closeTradeL4 = (closeTrade14||closeTrade18||closeTrade19||closeTrade20||closeTrade26||closeTrade27||closeTrade28||closeTrade29);
//   bool closeTradeL3 = (closeTrade14||closeTrade26||closeTrade29);
// bool closeTradeL3 = (closeTrade14||closeTrade26||closeTrade27||closeTrade29);

//   bool closeTradeL3 = (closeTrade26||closeTrade28||closeTrade29);

//#################################################################################

//#################################################################################
// Open and close signals
//#################################################################################
   bool openCandleIma = (fastOpenTrade1);
   bool openTradeTrend = (fastOpenTrade3);//||fastOpenTrade4);
   bool openSlope = (fastOpenTrade11);//||fastOpenTrade4);
   bool openCandleVol = (fastOpenTrade12||fastOpenTrade13);
   bool openStar = (fastOpenTrade2);
   bool closeFlatTrade = (spreadBool && ((flatBool)||(dominantSIG!=SAN_SIGNAL::SIDEWAYS)));
   bool closeTrade = (closeTradeL5);
   bool noCloseConditions = (!closeFlatTrade);

//#################################################################################



   bool shortCycle = false;
   bool longCycle = false;
   bool allCycle = false;

   if(false && closeOrder && closeLoss)
     {
      closeSIG = SAN_SIGNAL::CLOSE;
      sigBuff.buff3[0] = (int)STRATEGYTYPE::CLOSEPOSITIONS;
      Print("[imaSt1]: closeLoss CLOSE detected:."+ util.getSigString(closeSIG));
     }
   else
      if(true && closeOrder && closeProfitLoss)
        {
         closeSIG = SAN_SIGNAL::CLOSE;
         sigBuff.buff3[0] = (int)STRATEGYTYPE::CLOSEPOSITIONS;
         Print("[imaSt1]: profitPercentage CLOSE detected:."+ util.getSigString(closeSIG));
        }
      else
         if(true && closeOrder && closeFlatTrade)
           {
            closeSIG = SAN_SIGNAL::CLOSE;
            sigBuff.buff3[0] = (int)STRATEGYTYPE::CLOSEPOSITIONS;
            Print("[imaSt1]: closeFlatTrade CLOSE detected:."+ util.getSigString(closeSIG));
           }
         else
            if(openTradeTrend && noCloseConditions && allCycle)
              {
               commonSIG=ss.ima1430SIG;
               if(openOrder)
                  openSIG = commonSIG;
               closeSIG = commonSIG;
               commonSIG=SAN_SIGNAL::NOSIG;
              }
            else
               if(openSlope && noCloseConditions)
                 {
                  commonSIG=dominantSIG;
                  if(openOrder)
                     openSIG = commonSIG;
                  closeSIG = commonSIG;
                  commonSIG=SAN_SIGNAL::NOSIG;
                 }
               else
                  if(openCandleVol && noCloseConditions && allCycle)
                    {
                     commonSIG=dominantSIG;
                     if(openOrder)
                        openSIG = commonSIG;
                     closeSIG = commonSIG;
                     commonSIG=SAN_SIGNAL::NOSIG;
                    }
                  else
                     if(openCandleIma && allCycle)
                       {
                        commonSIG=ss.candleImaSIG;
                        if(openOrder)
                           ss.openSIG = commonSIG;
                        ss.closeSIG = commonSIG;
                       }
                     else
                        if(false && closeOrder && closeTrade)// && !openCandleIma)// && !slowMfi)
                          {
                           closeSIG = SAN_SIGNAL::CLOSE;
                           sigBuff.buff3[0] = (int)STRATEGYTYPE::CLOSEPOSITIONS;
                           Print("[imaSt1]: closeTrade: "+closeTrade+" close detected: "+ util.getSigString(closeSIG));
                           //util.writeData("close_order.txt",""[imaSt1]: closeTrade4: "+closeTrade5+" close detected: "+ util.getSigString(ss.closeSIG));
                          }



   if(!closeTrade)
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

   Print("[MAIN][SLOW]:: domSIG: "+util.getSigString(dominantSIG)+" trendSIG:: "+util.getSigString(hSig.dominantTrendSIG)+" dom240:: "+util.getSigString(hSig.dominant240SIG)+" IMA120240TR240:: "+util.getSigString(hSig.dominantTrendIma240SIG)+" dom120:: "+util.getSigString(hSig.dominant120SIG)+" IMA30120TR240:: "+util.getSigString(hSig.dominantTrendIma120SIG)+" cpSlopeVarFAST: "+util.getSigString(hSig.cpSlopeVarFastSIG)+" VolVar: "+util.getSigString(hSig.domVolVarSIG)+" TrCP: "+util.getSigString(hSig.dominantTrendCPSIG)+" TrIMA: "+util.getSigString(hSig.domTrIMA));
   Print("[MAIN][FAST]:: mainFast: "+util.getSigString(hSig.mainFastSIG)+" slopeFast: "+util.getSigString(hSig.slopeFastSIG)+" rsiFAST: "+util.getSigString(hSig.rsiFastSIG)+" cpFAST: "+util.getSigString(hSig.cpFastSIG)+" candleVol120SIG: "+util.getSigString(ss.candleVol120SIG)+" slopeSIG: "+util.getSigString(ss.slopeVarSIG)+" CP120: "+util.getSigString(ss.cpScatterSIG)+" ima1430: "+util.getSigString(ss.ima1430SIG));
// Print("[TREND]:: tr5: "+util.getSigString(ss.trendRatio5SIG)+" tr14: "+util.getSigString(ss.trendRatio14SIG)+" tr30: "+util.getSigString(ss.trendRatio30SIG)+" tr120: "+util.getSigString(ss.trendRatio120SIG)+" tr240: "+util.getSigString(ss.trendRatio240SIG)+" tr500: "+util.getSigString(ss.trendRatio500SIG));
// Print("[VARIANCE]:: cpSDSIG: "+util.getSigString(ss.cpSDSIG)+" ima30SDSIG: "+util.getSigString(ss.ima30SDSIG)+" ima120SDSIG: "+util.getSigString(varSIG)+" ima240SDSIG: "+util.getSigString(ss.ima240SDSIG)+" ima500SDSIG: "+util.getSigString(ss.ima500SDSIG));
// Print("[TRADEABILITY]:: volSIG: "+util.getSigString(ss.volSIG)+" varBool: "+varBool+" varPosBool: "+varPosBool+" varNegBool: "+varNegBool+" ima120SDSIG: "+util.getSigString(varSIG));
// Print("openCandleVol: "+openCandleVol+" openSlope: "+openSlope+" closeProfitLoss: "+closeProfitLoss+" fastOpenTrade11: "+fastOpenTrade11+" fastOpenTrade12: "+fastOpenTrade12+" fastOpenTrade13: "+fastOpenTrade13);

// Print("[SIG][FIMA]:: fIma514: "+util.getSigString(ss.fastIma514SIG)+" fIma1430: "+util.getSigString(ss.fastIma1430SIG)+" fIma30120: "+util.getSigString(ss.fastIma30120SIG)+" fIma120240: "+util.getSigString(ss.fastIma120240SIG)+" fIma240500: "+util.getSigString(ss.fastIma240500SIG));
// Print("[SIG][IMA] :: ima514:: "+util.getSigString(ss.ima514SIG)+" ima1430: "+util.getSigString(ss.ima1430SIG)+" ima30120: "+util.getSigString(ss.ima30120SIG)+" ima120240: "+util.getSigString(ss.ima120240SIG)+" ima240500: "+util.getSigString(ss.ima240500SIG));
   Print("[SIG][FSIG]:: fSig5: "+util.getSigString(ss.fsig5)+" fSig14: "+util.getSigString(ss.fsig14)+" fSig30: "+util.getSigString(ss.fsig30)+" fSig120: "+util.getSigString(ss.fsig120)+" fSig240: "+util.getSigString(ss.fsig240)+" fSig500: "+util.getSigString(ss.fsig500));
//   Print("[SIG][SIG] :: sig5: "+util.getSigString(ss.sig5)+" sig14: "+util.getSigString(ss.sig14)+" sig30: "+util.getSigString(ss.sig30)+" sig120: "+util.getSigString(ss.sig120)+" sig240: "+util.getSigString(ss.sig240)+" sig500: "+util.getSigString(ss.sig500));

   Print("[newCandle]: "+op1.NEWCANDLE+" Spread: "+indData.currSpread+" CurrPos: "+util.getSigString(tradePosition)+" OpenSIG:"+util.getSigString(ss.openSIG)+" CloseSIG:"+util.getSigString(ss.closeSIG)+" closeTrade: "+closeTrade+" Flat: "+closeFlatTrade+" PL:"+util.getSigString(ss.profitPercentageSIG)+" Loss:"+util.getSigString(ss.lossSIG)+" Mkt Type: "+util.getSigString(hSig.mktType)+" var: "+varBool+" varFlat: "+varFlatBool+" slpTrVar: "+slopeTrendVarBool);

   return sigBuff;
  }




SanStrategies st1;

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
