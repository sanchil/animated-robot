//+------------------------------------------------------------------+
//|                                                SanStrategies.mqh |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include <Sandeep/SanUtils.mqh>




//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class SanSignals {
 private:
   int               ticket;
 public:
   SanSignals();
   ~SanSignals();
   void              sayMesg();



   SAN_SIGNAL        tradeSignal(const double ciStd,const double ciMfi, const double &atr[],const double ciAdxMain,const double ciAdxPlus,const double ciAdxMinus);
   SAN_SIGNAL        tradeVolVarSignal(const SAN_SIGNAL volSIG,const SIGMAVARIABILITY varFast,const SIGMAVARIABILITY varMedium,const SIGMAVARIABILITY varSlow,const SIGMAVARIABILITY varVerySlow=SIGMAVARIABILITY::SIGMA_NULL);
   SAN_SIGNAL        adxSIG(const double ciAdxMain,const double ciAdxPlus,const double ciAdxMinus);
   //SAN_SIGNAL        adxCovDivSIG(const double &ciAdxMain[],const double &ciAdxPlus[],const double &ciAdxMinus[]);
   SANTREND          trendScatterPlotSIG(const double &data[],string label="",const double slope=0.3,const int period=10,const int shift=1);
   SANTREND          trendSlopeSIG(const double &data[],string label="",const int period=10,const int shift=1);
   TRENDSTRUCT       _trendRatioSIG(const double &sig[],const int period=10,const int shift=1);
   SANTREND          trendRatioSIG(const double &sig[],string label="",const double slopeRatio=2,const int period=10,const int shift=1);
   TRENDSTRUCT       trendVolRatioSIG(const double &sig[],const double &vol[],const int period=10,const int shift=1);
   SAN_SIGNAL        trendSIG(SANTREND tr1, SANTREND tr2, SANTREND tr3, SANTREND tr4=EMPTY, SANTREND tr5=EMPTY, SANTREND tr6=EMPTY);

   DataTransport     clusterSIG(const double fast,const double medium,const double slow);
   DataTransport     varSIG(const SIGMAVARIABILITY fast,const SIGMAVARIABILITY medium,const SIGMAVARIABILITY slow);


   SAN_SIGNAL               priceActionCandleSIG(
      const double &open[],
      const double &high[],
      const double &low[],
      const double &close[],
      uint shift=1);

   SAN_SIGNAL        ima514SIG(
      const double imaHandle5,
      const double imaHandle14
   );
   SAN_SIGNAL        ima1430SIG(
      const double imaHandle14,
      const double imaHandle30
   );

   //SAN_SIGNAL            imaCandleCloseSIG(
   //   const double ima,
   //   const double close
   //);
   SANTRENDSTRENGTH        atrSIG(const double &atr[], const int period=10);
   TRENDSTRUCT       acfStdSIG(const double &sig[],const int period=10,const int shift=1);
   SAN_SIGNAL        mfiSIG(const double &sig[],SANTREND tradeTrend = SANTREND::NOTREND,const int period=10,const int shift=1);
   SAN_SIGNAL        rsiSIG(const double &sig[],const int period=10,const int shift=1);


   //   TRENDSTRUCT           closeTrendSIG(const double &close[],const int shift=1,const int period=10);
   SAN_SIGNAL        volumeSIG(const double &vol[],const int arrsize=10,const int shift=1);
   SAN_SIGNAL        volumeSIG_v2(const double &vol[],const int arrsize=10, const int VOLMIN = 11,const int shift=1);
   SAN_SIGNAL               closeOnProfitSIG(const double currProfit,const double closeProfit,const int pos);
   SAN_SIGNAL                closeOnProfitPercentageSIG(const double currProfit, const double adjustedProfit, const double closeProfit, const double percentage=0.05);
   SAN_SIGNAL               closeOnLossSIG(const double lossAmt=1.0, const int pos=0);
   const SIGMAVARIABILITY   stdDevSIG(const double &param[], string label="", const int period=10, const int shift=1);
   SAN_SIGNAL        candleImaSIG(
      const double &open[],
      const double &close[],
      const double &imaHandle5[],
      const double &imaHandle14[],
      const double &imaHandle30[],
      const int period=5,
      const int shift=1
   );
   SAN_SIGNAL        fastSlowSIG(
      const double fastSig,
      const double slowSig,
      const int factor=10
   );


   SAN_SIGNAL        fastSlowTrendSIG(
      const double &fast[],
      const double &slow[],
      const int period=5,
      const int shift=1
   );


   DataTransport     slopeVarData(
      const double &fast[],
      const double &medium[],
      const double &slow[],
      const int period=5,
      const int shift=1
   );


   SAN_SIGNAL        slopeVarSIG(
      const double &fast[],
      const double &medium[],
      const double &slow[],
      const int period=5,
      const int shift=1
   );

   DataTransport   slopeRatioData(
      const double &fast[],
      const double &medium[],
      const double &slow[],
      const int period=5,
      const int shift=1
   );


   CROSSOVER         signalCrossOver(
      const double &fast[],
      const double &slow[],
      const int period=5,
      const int shift=1
   );

   SAN_SIGNAL        candleVolSIG(
      const double &open[],
      const double &close[],
      const double &vol[],
      const int period=10,
      const int shift=1
   );

   SAN_SIGNAL        candleVolSIG_v1(
      const double &open[],
      const double &close[],
      const double &vol[],
      const int period=10,
      const int shift=1
   );

   SAN_SIGNAL        pVElastSIG(
      const double &open[],
      const double &close[],
      const double &vol[],
      const int period=10,
      const int shift=1
   );

   SAN_SIGNAL        candleStar(
      const double &open[],
      const double &high[],
      const double &low[],
      const double &close[],
      const double candleBodySize=0.1,
      const double slope=0.6,
      const int period=10,
      const int shift=1
   );

   SAN_SIGNAL        SanSignals::fastSigSlowTrendSIG(
      const SAN_SIGNAL &fastSig,
      const SANTREND &baseTrend
   );

   SAN_SIGNAL        dominantTrendSIG(
      const SANSIGNALS &ss,
      const HSIG &hSIG
   );

   struct CandleCharacter {
      double         upperTail;
      double         lowerTail;
      bool              redCandle;
      bool              greenCandle;
      bool              noBodyTailCandle;
      bool              noBodyUpperTailCandle;
      bool              noBodyLowerTailCandle;
      bool              bodyUpperTailCandle;
      bool              bodyLowerTailCandle;
      bool              noBodyCandle;
      bool              fullBodyRedCandle;
      bool              fullBodyGreenCandle;
      bool              fullBodyCandle;
      double            body;
      double            candleRange;
      double            bodyRatio;
      bool              tailDominates;
      bool              bodyDominates;

      CandleCharacter() {
         upperTail = -1;
         lowerTail = -1;
         redCandle = -1;
         greenCandle =  -1;
         noBodyTailCandle =  -1;
         noBodyUpperTailCandle = -1;
         noBodyLowerTailCandle = -1;
         bodyUpperTailCandle = -1;
         bodyLowerTailCandle = -1;
         noBodyCandle =  -1 ;
         fullBodyRedCandle =  -1;
         fullBodyGreenCandle =  -1;
         fullBodyCandle =  -1;
         body =   -1;
         candleRange =   -1;
         bodyRatio =  -1;
         tailDominates =  -1;
         bodyDominates =  -1 ;
      }


      CandleCharacter(
         const double &open[],
         const double &high[],
         const double &low[],
         const double &close[],
         const double limit,
         const int shift=1) {

         redCandle = (open[shift] > close[shift]);
         greenCandle = (open[shift] < close[shift]);
         noBodyCandle = ((open[shift] == close[shift]) && (low[shift] == high[shift])) ;
         noBodyTailCandle = ((open[shift] == close[shift]) && (low[shift] != high[shift]));

         if(!noBodyCandle && noBodyTailCandle && (fabs(open[shift]-low[shift])>0)) {
            noBodyUpperTailCandle = ((fabs(high[shift]-open[shift])/fabs(open[shift]-low[shift]))>(1-limit));
            noBodyLowerTailCandle = ((fabs(high[shift]-open[shift])/fabs(open[shift]-low[shift]))<=limit) ;
         } else if(!noBodyCandle && noBodyTailCandle && (fabs(open[shift]-low[shift])==0)) {
            noBodyUpperTailCandle = ((fabs(high[shift]-open[shift]))>(1-limit));
            noBodyLowerTailCandle = ((fabs(high[shift]-open[shift]))<=limit) ;
         }

         fullBodyRedCandle = (redCandle && (open[shift] == high[shift]) && (close[shift] == low[shift]));
         fullBodyGreenCandle = (greenCandle && (open[shift] == low[shift]) && (close[shift] == high[shift]));
         fullBodyCandle = (fullBodyRedCandle || fullBodyGreenCandle);
         body =  NormalizeDouble(fabs(open[shift]-close[shift]),_Digits);
         candleRange =  NormalizeDouble(fabs(high[shift]-low[shift]),_Digits);
         bodyRatio = (!noBodyTailCandle&&!fullBodyCandle && !noBodyCandle && (body>0)&&(candleRange>0))?NormalizeDouble((body/candleRange),2):NULL;
         tailDominates = (noBodyTailCandle || (bodyRatio <= limit));
         bodyDominates = (fullBodyCandle ||(bodyRatio > limit)) ;

         if((redCandle||noBodyTailCandle) && !fullBodyCandle && !noBodyCandle) {
            upperTail=(high[shift]-open[shift]);
            lowerTail=(close[shift]-low[shift]);
         } else if((greenCandle||noBodyTailCandle) && !fullBodyCandle && !noBodyCandle) {
            upperTail=(high[shift]-close[shift]);
            lowerTail=(open[shift]-low[shift]);
         }
         bodyUpperTailCandle = (tailDominates && (((upperTail==0)&&(lowerTail>0)) || ((upperTail!=0)&&(lowerTail!=0)&&(NormalizeDouble((fabs(upperTail)/fabs(lowerTail)),2)<=limit))));
         bodyLowerTailCandle = (tailDominates && (((lowerTail==0)&&(upperTail>0)) || ((upperTail!=0)&&(lowerTail!=0)&&(NormalizeDouble((fabs(lowerTail)/fabs(upperTail)),2)<=limit))));

      }
      ~CandleCharacter() {

         redCandle = NULL;
         greenCandle = NULL;
         noBodyTailCandle = NULL;
         noBodyCandle = NULL;
         fullBodyRedCandle = NULL;
         fullBodyGreenCandle = NULL;
         fullBodyCandle = NULL;
         body =  NULL;
         candleRange = NULL;
         bodyRatio = NULL;
         tailDominates = NULL;
         bodyDominates = NULL ;

      }

   };
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SanSignals::SanSignals() {

}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SanSignals::~SanSignals() {
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SanSignals::sayMesg() {
   ticket = 100;
// Print("CURRENT Ticket is :"+ticket);
}
//+------------------------------------------------------------------+



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL SanSignals::adxSIG(const double ciAdxMain,const double ciAdxPlus,const double ciAdxMinus) {
   /***********************
   //Strategy:
   //Use ADX along with +DI and -DI (Directional Movement Indicators) to identify:
   //Uptrend: +DI > -DI and ADX > 25.
   //Downtrend: -DI > +DI and ADX > 25.
   //Sideways Market: ADX < 20.
   ****/

   double plusMinusDiff = fabs(ciAdxPlus-ciAdxMinus);
   double adxPlusDiff = fabs(ciAdxMain-ciAdxPlus);
   double adxMinusDiff = fabs(ciAdxMain-ciAdxMinus);
   const int PROXIMITYLIMIT = 6;
   const int ADXLIMIT = 20;

   bool crossOver1 = ((plusMinusDiff > PROXIMITYLIMIT) && ((adxPlusDiff > PROXIMITYLIMIT) || (adxMinusDiff > PROXIMITYLIMIT))) ;
   bool crossOver2 = ((plusMinusDiff < PROXIMITYLIMIT) && (adxPlusDiff < PROXIMITYLIMIT) && (adxMinusDiff < PROXIMITYLIMIT)) ;
   bool crossOver = (crossOver1&&!crossOver2) ;

   bool buy1 = (ciAdxPlus > ciAdxMinus) && (ciAdxMain >= ADXLIMIT);
   bool sell1 = (ciAdxMinus > ciAdxPlus) && (ciAdxMain >= ADXLIMIT);
   bool sideways1 = (ciAdxMain < ADXLIMIT);

   ;

//bool crossOver = (crossOver1&&!crossOver2) ;

//   bool crossOver2 = ((plusMinusDiff > diffLimit) && (adxPlusDiff < diffLimit));
//   bool crossOver3 = ((plusMinusDiff > diffLimit) && (adxMinusDiff < diffLimit));

   bool buy = (crossOver && (ciAdxPlus > ciAdxMinus) && (ciAdxMain > ciAdxMinus) && buy1);
   bool sell = (crossOver && (ciAdxMinus > ciAdxPlus) && (ciAdxMain > ciAdxPlus) && sell1);


   if(buy)
      return SAN_SIGNAL::BUY;
   if(sell)
      return SAN_SIGNAL::SELL;
   if(crossOver2 || sideways1)
      return SAN_SIGNAL::SIDEWAYS;

   return SAN_SIGNAL::NOSIG;
}
//+------------------------------------------------------------------+

////+------------------------------------------------------------------+
////|                                                                  |
////+------------------------------------------------------------------+
//SAN_SIGNAL SanSignals::adxCovDivSIG(const double &ciAdxMain[],const double &ciAdxPlus[],const double &ciAdxMinus[])
//  {
//
//   int SHIFT=1;
//   int SIZE = ArraySize(ciAdxMain);
//   SANTREND adxTrend = SANTREND::NOTREND;
//
//   SAN_SIGNAL adxSig = adxSIG(ciAdxMain[SHIFT],ciAdxPlus[SHIFT],ciAdxMinus[SHIFT]);
//
//   if(adxSig == SAN_SIGNAL::NOSIG)
//      return SAN_SIGNAL::NOSIG;
//
//   if(adxSig == SAN_SIGNAL::BUY)
//     {
//
//      if(ciAdxMain[SHIFT] > ciAdxPlus[SHIFT])
//        {
//         adxTrend = stats.convDivTest(ciAdxMain,ciAdxPlus,10,1);
//        }
//      if(ciAdxMain[SHIFT] < ciAdxPlus[SHIFT])
//        {
//         adxTrend = stats.convDivTest(ciAdxPlus,ciAdxMain,10,1);
//        }
//
//      if((adxTrend == SANTREND::CONVUP)||(adxTrend == SANTREND::DIVUP)||(adxTrend == SANTREND::CONVDOWN))
//         return adxSig;
//
//     }
//
//   if(adxSig == SAN_SIGNAL::SELL)
//     {
//      if(ciAdxMain[SHIFT] > ciAdxMinus[SHIFT])
//        {
//         adxTrend = stats.convDivTest(ciAdxMain,ciAdxMinus,10,1);
//        };
//      if(ciAdxMain[SHIFT] < ciAdxMinus[SHIFT])
//        {
//         adxTrend = stats.convDivTest(ciAdxMinus,ciAdxMain,10,1);
//        }
//      if((adxTrend == SANTREND::CONVUP)||(adxTrend == SANTREND::DIVUP)||(adxTrend == SANTREND::CONVDOWN))
//         return adxSig;
//     }
//
//   return SAN_SIGNAL::NOSIG;
//  }
//

//+------------------------------------------------------------------+
//| When the fast signal moves over slow signal
// it is a buy and when a fast signal dives below a slow signal then it is a sell
// signal                                                      |
//+------------------------------------------------------------------+
SAN_SIGNAL SanSignals::fastSlowSIG(
   const double fastSig,
   const double slowSig,
   const int factor=10
) {
   const double upperFACTOR = 1+(factor/100);
   const double lowerFACTOR = 1-(factor/100);

   if((fastSig >= (lowerFACTOR*slowSig))&&(fastSig <= (upperFACTOR*slowSig)))
      return SAN_SIGNAL::SIDEWAYS;
   if(fastSig > (upperFACTOR*slowSig))
      return SAN_SIGNAL::BUY;
   if(fastSig < (lowerFACTOR*slowSig))
      return SAN_SIGNAL::SELL;
   return SAN_SIGNAL::NOSIG;
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL  SanSignals::fastSlowTrendSIG(
   const double &fast[],
   const double &slow[],
   const int period=5,
   const int shift=1
) {
   int above = 0;
   int flat = 0;
   int below = 0;

   if(shift>=period)
      return SAN_SIGNAL::NOSIG;

   for(int i=shift; i<=period; i++) {
      if(fast[i]==slow[i]) {
         ++flat;
      } else if(fast[i]>slow[i]) {
         ++above;
      } else if(fast[i]<slow[i]) {
         ++below;
      }

   }

//  Print("Cross overs: Above: "+above+" Below: "+below+" Flat: "+flat);

   bool preBool1 = ((flat>0) && (above==0) && (below==0));
   bool preBool2 = ((flat>0) && (above>0) && (below==0));
   bool preBool3 = ((flat>0) && (above==0) && (below>0));
   bool preBool4 = ((flat>0) && (above>0) && (below>0));

   bool preBool5 = ((flat==0) && (above>0)&&(below==0));
   bool preBool6 = ((flat==0)&&(above==0)&&(below>0));
   bool preBool7 = ((flat==0)&&(above>0)&&(below>0));

   bool flatBool5 = ((flat!=0)&&(above/flat)<=0.2);
   bool flatBool6 = ((flat!=0)&&(below/flat)<=0.2);

   bool flatBool7 = ((below!=0)&&((above/below)>=0.8)&&((above/below)<=1.2));
   bool flatBool8 = ((above!=0)&&((below/above)>=0.8)&&((below/above)<=1.2));

   bool flatBool9 = (preBool2 && flatBool5);
   bool flatBool10 = (preBool3 && flatBool6);
   bool flatBool11 = (preBool4 && (flatBool7||flatBool8));

   bool buyBool2 = ((above!=0)&&(below/above)<=0.2);
   bool buyBool3 = (preBool7 && buyBool2);
   bool buyBool4 = (preBool4 && buyBool2 && ((flat/above)<=0.2));

   bool sellBool2 = ((below!=0)&&(above/below)<=0.2);
   bool sellBool3 = (preBool7 && sellBool2);
   bool sellBool4 = (preBool4 && sellBool2 && ((flat/below)<=0.2));

   bool flatBool = (preBool1 || flatBool9 || flatBool10 || flatBool11);
   bool buyBool = (preBool5 || buyBool3 || buyBool4);
   bool sellBool = (preBool6 || sellBool3 || sellBool4);


   if(flatBool) {
      //return SAN_SIGNAL::NOSIG;
      return SAN_SIGNAL::SIDEWAYS;
   } else if(buyBool) {
      return SAN_SIGNAL::BUY;
   } else if(sellBool) {
      return SAN_SIGNAL::SELL;
   }

   return SAN_SIGNAL::NOSIG;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
DataTransport SanSignals::clusterSIG(const double fast,const double medium,const double slow=0) {
   DataTransport dt;
   int fastInt = fast;
   int mediumInt = medium;
   int slowInt = slow;
   double rFM = (fast/medium);
   double rMS = (medium/slow);
   double rFS = (fast/slow);
   double rDFM = fabs(fast-medium)/fabs((fast+medium)/2);
   double rDMS = fabs(medium-slow)/fabs((medium+slow)/2);
   double rDFS = fabs(fast-slow)/fabs((fast+slow)/2);


   if(fastInt==mediumInt) {
      rFM = ((fast-fastInt)/(medium-mediumInt));
   } else if(fastInt>mediumInt) {
      rFM = ((fast-mediumInt)/(medium-mediumInt));
   } else if(fastInt<mediumInt) {
      //rFM = ((fast-fastInt)/(medium-fastInt));
      rFM = -1*((medium-fastInt)/(fast-fastInt));
   }


   if(mediumInt==slowInt) {
      rMS = ((medium-mediumInt)/(slow-slowInt));
   } else if(mediumInt>slowInt) {
      rMS = ((medium-slowInt)/(slow-slowInt));
   } else if(mediumInt<slowInt) {
      // rMS = ((medium-mediumInt)/(slow-mediumInt));
      rMS = -1*((slow-mediumInt)/(medium-mediumInt));
   }

   if(fastInt==slowInt) {
      rFS = ((fast-fastInt)/(slow-slowInt));
   } else if(fastInt>slowInt) {
      rFS = ((fast-slowInt)/(slow-slowInt));
   } else if(fastInt<slowInt) {
      rFS = -1*((slow-fastInt)/(fast-fastInt));
   }
//   double gt=EMPTY_VALUE;
//   gt = (rFM>rMS)?rFM:rMS;
//   gt = (gt>rFS)?gt:rFS;

   double v1 = NormalizeDouble(((fastInt==mediumInt)?(fast-fastInt):((fastInt>mediumInt)?(fast-mediumInt):((fastInt<mediumInt)?(-1*(fast-fastInt)):EMPTY_VALUE))),4);
   double v2 = NormalizeDouble(((mediumInt==slowInt)?(medium-mediumInt):((mediumInt>slowInt)?(medium-slowInt):((mediumInt<slowInt)?(-1*(medium-mediumInt)):EMPTY_VALUE))),4);
   double v3 = NormalizeDouble(((fastInt==slowInt)?(slow-slowInt):((fastInt>slowInt)?(slow-slowInt):((fastInt<slowInt)?(-1*(slow-fastInt)):EMPTY_VALUE))),4);

//Print("[CLUSTER] ratios: rFM: "+NormalizeDouble(rFM,4)+" rMS: "+NormalizeDouble(rMS,4)+" rFS: "+NormalizeDouble(rFS,4));
//      +" fastInt: "+ fastInt+" mediumInt: "+ mediumInt+" slowInt: "+slowInt
//      +" fast: "+ v1
//      +" medium: "+ v2
//      +" slow: "+v3);

   dt.matrixD[0] =  NormalizeDouble(rFM,6);
   dt.matrixD[1] =  NormalizeDouble(rMS,6);
   dt.matrixD[2] =  NormalizeDouble(rFS,6);
//return NormalizeDouble(rFM,6);
   return dt;

}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
DataTransport   SanSignals::varSIG(const SIGMAVARIABILITY fast,const SIGMAVARIABILITY medium,const SIGMAVARIABILITY slow) {
   DataTransport dt;

   double var30Val = util.getSigVarBool(fast);
   bool var30Bool = ((var30Val!=0) && ((var30Val==1.314)||(var30Val==-1.314)));
   bool var30PosBool = ((var30Val!=0) && (var30Val==1.314));
   bool var30NegBool = ((var30Val!=0) && (var30Val==-1.314));
   bool var30FlatBool = (var30Val==0);

   double var120Val = util.getSigVarBool(medium);
   bool var120Bool = ((var120Val!=0) && ((var120Val==1.314)||(var120Val==-1.314)));
   bool var120PosBool = ((var120Val!=0) && (var120Val==1.314));
   bool var120NegBool = ((var120Val!=0) && (var120Val==-1.314));
   bool var120FlatBool = (var120Val==0);

   double var240Val = util.getSigVarBool(slow);
   bool var240Bool = ((var240Val!=0) && ((var240Val==1.314)||(var240Val==-1.314)));
   bool var240PosBool = ((var240Val!=0) && (var240Val==1.314));
   bool var240NegBool = ((var240Val!=0) && (var240Val==-1.314));
   bool var240FlatBool = (var240Val==0);

   bool varBool = (var30Bool && var120Bool && var240Bool);
   bool varPosBool = (varBool && (var30PosBool&&var120PosBool&&var240PosBool));
   bool varNegBool = (varBool && (var30NegBool&&var120NegBool&&var240NegBool));
   bool varFlatBool = (var30FlatBool||var120FlatBool||var240FlatBool);

   dt.matrixBool[0]= varPosBool;
   dt.matrixBool[1]= varNegBool;
   dt.matrixBool[2]= varFlatBool;
   dt.matrixBool[3]= varBool;

   return dt;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
DataTransport   SanSignals::slopeVarData(
   const double &fast[],
   const double &medium[],
   const double &slow[],
   const int period=5,
   const int shift=1
) {

   DataTransport dt;
   double tPoint = Point;
//int denom = period;
   const int DENOM = 3;

   dt.matrixD[0] = NormalizeDouble(((fast[shift]-fast[DENOM])/(DENOM*tPoint)),3);
   dt.matrixD[1] = NormalizeDouble(((medium[shift]-medium[DENOM])/(DENOM*tPoint)),3);
   dt.matrixD[2] = NormalizeDouble(((slow[shift]-slow[DENOM])/(DENOM*tPoint)),3);
   dt.matrixD[3] = NormalizeDouble(((slow[shift]-slow[period])/(period*tPoint)),3);
   return dt;
}



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL        SanSignals::slopeVarSIG(
   const double &fast[],
   const double &medium[],
   const double &slow[],
   const int period=5,
   const int shift=1
) {

   double fastSlope=0;
   double mediumSlope=0;
   double slowSlope=0;
   double slowSlopeWide=0;

//   double tPoint = Point;
////int denom = period;
//   const int DENOM = 3;

   const double slopeFactor = 0.1;
   const double SLOWSLOPEWIDE = 0.1;
   const double SLOWSLOPE = 0.15;
   const double MEDIUMSLOPE= (SLOWSLOPE+slopeFactor);
   double FASTSLOPE= (SLOWSLOPE+(1.5*slopeFactor));
//
////fastSlope = NormalizeDouble(((fast[shift]-fast[period])/(period*tPoint)),3);
////mediumSlope = NormalizeDouble(((medium[shift]-medium[period])/(period*tPoint)),3);
////slowSlope = NormalizeDouble(((slow[shift]-slow[period])/(period*tPoint)),3);
//   fastSlope = NormalizeDouble(((fast[shift]-fast[DENOM])/(DENOM*tPoint)),3);
//   mediumSlope = NormalizeDouble(((medium[shift]-medium[DENOM])/(DENOM*tPoint)),3);
//   slowSlope = NormalizeDouble(((slow[shift]-slow[DENOM])/(DENOM*tPoint)),3);
//   slowSlopeWide = NormalizeDouble(((slow[shift]-slow[period])/(period*tPoint)),3);

   DataTransport slopesData = slopeVarData(fast,medium,slow,period,shift);

   fastSlope = slopesData.matrixD[0];
   mediumSlope = slopesData.matrixD[1];
   slowSlope = slopesData.matrixD[2];
   slowSlopeWide = slopesData.matrixD[3];


   bool buy1 = ((slowSlopeWide>SLOWSLOPEWIDE)&&(mediumSlope>MEDIUMSLOPE)&&(fastSlope>FASTSLOPE));
   bool sell1 = ((slowSlopeWide<(-1*SLOWSLOPEWIDE))&&(mediumSlope<(-1*MEDIUMSLOPE))&&(fastSlope<(-1*FASTSLOPE)));

   bool close1 = ((slowSlopeWide>SLOWSLOPEWIDE)&&(mediumSlope>MEDIUMSLOPE)&&(fastSlope<(-1*FASTSLOPE)));
   bool close2 = ((slowSlopeWide<(-1*SLOWSLOPEWIDE))&&(mediumSlope<(-1*MEDIUMSLOPE))&&(fastSlope>FASTSLOPE));


   bool closeFast1 = ((slowSlopeWide>SLOWSLOPEWIDE)&&(mediumSlope>MEDIUMSLOPE)&&(fastSlope<(-1*FASTSLOPE)) && (slowSlopeWide>0.4)&&(slowSlope>0.5)&&(mediumSlope>0.9)) ;
   bool closeFast2 = ((slowSlopeWide<(-1*SLOWSLOPEWIDE))&&(mediumSlope<(-1*MEDIUMSLOPE))&&(fastSlope>FASTSLOPE) && (slowSlopeWide<-0.4)&&(slowSlope<-0.5)&&(mediumSlope<-0.9)) ;

   bool closeSlow1 = ((slowSlopeWide>SLOWSLOPEWIDE)&&(mediumSlope<MEDIUMSLOPE)&&(fastSlope<(-1*FASTSLOPE)) && (slowSlopeWide<=0.4)&&(slowSlope<=0.5));
   bool closeSlow2 = ((slowSlopeWide<(-1*SLOWSLOPEWIDE))&&(mediumSlope>(-1*MEDIUMSLOPE))&&(fastSlope>FASTSLOPE) && (slowSlopeWide>0.4)&&(slowSlope>0.5));



   bool flatSlowBool = ((slowSlopeWide>=(-1*SLOWSLOPEWIDE))&&(slowSlopeWide<=SLOWSLOPEWIDE));
   bool flatMediumBool = ((mediumSlope>=(-1*MEDIUMSLOPE))&&(mediumSlope<=MEDIUMSLOPE));
   bool flatFstBool = ((fastSlope>=(-1*FASTSLOPE)) && (fastSlope<=FASTSLOPE));

// bool sideWaysBool = (flatSlowBool && flatMediumBool && flatFstBool);
// bool sideWaysBool = (flatSlowBool||flatMediumBool||flatFstBool);
   bool sideWaysBool = (flatSlowBool||flatMediumBool);


   //Print("[SLOPES]: FAST: "+fastSlope+" : "+FASTSLOPE+" MEDIUM: "+mediumSlope+" : "+MEDIUMSLOPE+" SLOW: "+slowSlope+" : "+SLOWSLOPE+" :SLOWWIDE: "+slowSlopeWide+" : "+SLOWSLOPEWIDE+" buy1: "+buy1+" sell1: "+sell1+" sideWaysBool: "+sideWaysBool);

//Print("Sellbool : slow: "+(slowSlopeWide<(-1*SLOWSLOPE))+" medium: "+(mediumSlope<(-1*MEDIUMSLOPE))+" fast "+(fastSlope<(-1*FASTSLOPE)) );
//Print("Buybool : slow: "+(slowSlopeWide>SLOWSLOPE)+" medium: "+(mediumSlope>MEDIUMSLOPE)+" fast "+(fastSlope>FASTSLOPE) );

   if(sideWaysBool)
      return SAN_SIGNAL::SIDEWAYS;
   if(!sideWaysBool&&buy1)
      return SAN_SIGNAL::BUY;
   if(!sideWaysBool&&sell1)
      return SAN_SIGNAL::SELL;
//   if(close1||close2)
   if(closeSlow1||closeSlow2||closeFast1||closeFast2)
      return SAN_SIGNAL::CLOSE;

   return SAN_SIGNAL::NOSIG;
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
DataTransport     SanSignals::slopeRatioData(
   const double &fast[],
   const double &medium[],
   const double &slow[],
   const int period=5,
   const int shift=1
) {

   double fastSlope=0;
   double mediumSlope=0;
   double slowSlope=0;
   double slowSlopeWide=0;

   double fMR=0;
   double mSR=0;
   double mSWR=0;
   double fSR=0;
   double fSWR=0;
   double fMSR = 0;
   double fMSWR = 0;

   DataTransport slopesData = slopeVarData(fast,medium,slow,period,shift);
   DataTransport dt;
   fastSlope = slopesData.matrixD[0];
   mediumSlope = slopesData.matrixD[1];
   slowSlope = slopesData.matrixD[2];
   slowSlopeWide = slopesData.matrixD[3];

   fMR = ((fastSlope!=0)&&(mediumSlope!=0))?NormalizeDouble((fastSlope/mediumSlope),4):EMPTY_VALUE;
   mSR = ((mediumSlope!=0)&&(slowSlope!=0))?NormalizeDouble((mediumSlope/slowSlope),4):EMPTY_VALUE;
   mSWR = ((mediumSlope!=0)&&(slowSlopeWide!=0))?NormalizeDouble((mediumSlope/slowSlopeWide),4):EMPTY_VALUE;
   fSR = ((fastSlope!=0)&&(slowSlope!=0))?NormalizeDouble((fastSlope/slowSlope),4):EMPTY_VALUE;
   fSWR = ((fastSlope!=0)&&(slowSlopeWide!=0))?NormalizeDouble((fastSlope/slowSlopeWide),4):EMPTY_VALUE;
   fMSR = ((fMR!=0)&&(mSR!=0)&&(fMR!=EMPTY_VALUE)&&(mSR!=EMPTY_VALUE))?NormalizeDouble((fMR/mSR),4):EMPTY_VALUE;
   fMSWR = ((fMR!=0)&&(mSWR!=0)&&(fMR!=EMPTY_VALUE)&&(mSWR!=EMPTY_VALUE))?NormalizeDouble((fMR/mSWR),4):EMPTY_VALUE;

//   Print("[SLOPESRATIO] fMR: "+fMR+" mSR: "+mSR+" mSWR: "+mSWR+" fSR: "+fSR+" fSWR: "+fSWR+" fMSR: "+fMSR+" fMSWR: "+fMSWR);
   dt.matrixD[0]=fMSR;
   dt.matrixD[1]=fMSWR;
   dt.matrixD[2]=fMR;
   dt.matrixD[3]=mSR;
   dt.matrixD[4]=mSWR;

   return dt;
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CROSSOVER  SanSignals::signalCrossOver(
   const double &fast[],
   const double &slow[],
   const int period=5,
   const int shift=1
) {
   int above = 0;
   int below = 0;
   int multiple = 0;

   int crossOverBelowToAbove = 0;
   int crossOverAboveToBelow = 0;
   int crossOverMultiple = 0;

   for(int i=shift; i<=period; i++) {
      if((fast[i]<slow[i])&&(above==0)&&(multiple==0)) {
         below++;
      } else if((fast[i]>slow[i])&&(below>0)&&(above==0)&&(multiple==0)) {
         crossOverBelowToAbove++;
         above++;
      } else if((fast[i]>slow[i])&&(below>0)&&(above>0)&&(below>above)) {
         crossOverMultiple++;
         crossOverBelowToAbove++;
      } else if((fast[i]>slow[i])&&(below>0)&&(above>0)&&(above>below)) {
         crossOverMultiple++;
         crossOverAboveToBelow++;
      }

      if((fast[i]>slow[i])&&(below==0)&&(multiple==0)) {
         above++;
      } else if((fast[i]<slow[i])&&(above>0)&&(below==0)&&(multiple==0)) {
         crossOverAboveToBelow++;
         below++;
      } else if((fast[i]<slow[i])&&(above>0)&&(below>0)&&(above>below)) {
         crossOverMultiple++;
         crossOverAboveToBelow++;
      } else if((fast[i]<slow[i])&&(above>0)&&(below>0)&&(below>above)) {
         crossOverMultiple++;
         crossOverBelowToAbove++;
      }
   }

   if((crossOverMultiple>0)&&(crossOverBelowToAbove>1)&&(crossOverAboveToBelow>1)) {
      return CROSSOVER::MULTIPLE;
   } else if((crossOverMultiple==0)&&(crossOverBelowToAbove==1)&&(crossOverAboveToBelow==0)) {
      return CROSSOVER::BELOWTOABOVE;
   } else if((crossOverMultiple>0)&&(crossOverBelowToAbove==0)&&(crossOverAboveToBelow==1)) {
      return CROSSOVER::ABOVETOBELOW;
   }

   return CROSSOVER::NOCROSS;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//SAN_SIGNAL SanSignals::atrSIG(
SANTRENDSTRENGTH SanSignals::atrSIG(
   const double &atr[],
   const int period=10
) {
   const double ATRUPPERTRADELIMIT  = 0.7;
   const double ATRMIDDLETRADELIMIT  = 0.3;
   const double ATRLOWERTRADELIMIT  = 0.03;
   double max = atr[ArrayMaximum(atr,period)];
   double min = atr[ArrayMinimum(atr,period)];
   double range = (max-min);
   double lowerDiff = atr[1]-min;
   double upperDiff = max - atr[1];
   double ratio = EMPTY_VALUE;

   if((lowerDiff==0)&&(upperDiff!=0)) {
      //return SAN_SIGNAL::NOTRADE;
      return SANTRENDSTRENGTH::WEAK;
   }


   if((lowerDiff!=0)&&(upperDiff==0)) {
      //return SAN_SIGNAL::TRADE;
      return SANTRENDSTRENGTH::SUPERHIGH;
   }


   if((lowerDiff!=0)&&(range!=0)) {
      ratio = lowerDiff/range;
   }

//Print("ATR current: "+ atr[1]+" Atr in pips: "+ atr[1]/tPoint+" Ratio: "+ ratio);

//Print("Max ATR: "+ max+" Minimum ATR: "+min+" Ratio: "+ ratio);

//  if(((lowerDiff!=0)&&(upperDiff!=0))&&((upperDiff/lowerDiff)<=ATRTRADELIMIT))
   if((ratio!=EMPTY_VALUE)&&((ratio>=ATRMIDDLETRADELIMIT)&&(ratio<=ATRUPPERTRADELIMIT))) {
      return SANTRENDSTRENGTH::HIGH;
   } else if((ratio!=EMPTY_VALUE)&&((ratio>=ATRLOWERTRADELIMIT)&&(ratio<ATRMIDDLETRADELIMIT))) {
      return SANTRENDSTRENGTH::NORMAL;
   } else
      // if(((lowerDiff!=0)&&(upperDiff!=0))&&((lowerDiff/upperDiff) <=ATRTRADELIMIT))
      if((ratio!=EMPTY_VALUE)&&((ratio<ATRLOWERTRADELIMIT)||(ratio>ATRUPPERTRADELIMIT))) {
         return SANTRENDSTRENGTH::WEAK;
      }

   return SANTRENDSTRENGTH::POOR;
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL SanSignals::volumeSIG(const double &vol[],const int arrsize=10,const int shift=1) {

   double sum = 0;
   double avg = 0;
   double volPercentage = 0;
   int count = (arrsize+shift);
   for(int i = shift; i<count; i++) {
      sum +=vol[i];
   }
   avg = sum/count;
   volPercentage = vol[shift]/avg;

//  Print("Volume shift 1: "+vol[shift]+" Average: "+avg+" Percentage: "+ volPercentage);
   if(volPercentage < 0.9)
      return SAN_SIGNAL::CLOSE;
   if(volPercentage >= 0.9)
      return SAN_SIGNAL::OPEN;
   return SAN_SIGNAL::CLOSE;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL SanSignals::volumeSIG_v2(const double &vol[],const int arrsize=10, const int VOLMIN = 11, const int shift=1) {

   double sum1 = 0;
   double avg1 = 0;
   double sum2 = 0;
   double avg2 = 0;
//  const int VOLMIN = 11;

   double volPercentage = 0;
   double volPercentage2 = 0;

   int count = (arrsize);

   for(int i = shift; i<floor(count/2); i++) {
      sum1 +=vol[i];
   }
   avg1 = sum1/floor(count/2);

   for(int i = floor(count/2); i<count; i++) {
      sum2 +=vol[i];
   }

   avg2 = sum2/floor(count/2);


   volPercentage = avg1/avg2;

   double volPerMin = (sum1+sum2)/ArraySize(vol);
   double denom = 0;

   if(_Period == PERIOD_M1)
      denom=1;
   if(_Period == PERIOD_M5)
      denom=5;
   if(_Period == PERIOD_M15)
      denom=15;
   if(_Period == PERIOD_M30)
      denom=30;
   if(_Period == PERIOD_H1)
      denom=60;
   if(_Period == PERIOD_H4)
      denom=240;
   if(_Period == PERIOD_D1)
      denom=1440;

   volPerMin = volPerMin/denom;
   bool volPerMinBool = (volPerMin > VOLMIN);
//Print("New tick vol avg: "+NormalizeDouble(avg1,2)+" old avg: "+NormalizeDouble(avg2,2)+" volPercentage: "+ NormalizeDouble(volPercentage,2)+" Vol per min: "+ NormalizeDouble(volPerMin,2)+" Denom: "+denom);

   if(!volPerMinBool) {
      if((volPercentage <= 0.4))
         return SAN_SIGNAL::REVERSETRADE;
      if((volPercentage > 0.4) && (volPercentage <= 0.6))
         return SAN_SIGNAL::NOTRADE;
   }

   if(volPerMinBool) {
      if((volPercentage >= 0.4))
         return SAN_SIGNAL::TRADE;
      if((volPercentage < 0.4))
         return SAN_SIGNAL::NOTRADE;
      if((volPercentage <= 0.2))
         return SAN_SIGNAL::REVERSETRADE;
   }

//  Print("Volume shift 1: "+vol[shift]+" Average: "+avg+" Percentage: "+ volPercentage);

   return SAN_SIGNAL::CLOSE;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL SanSignals::priceActionCandleSIG(
   const double &open[],
   const double &high[],
   const double &low[],
   const double &close[],
   const uint shift=1) {

   double upperTail = NULL;
   double lowerTail = NULL;

   bool redCandle = (open[shift] > close[shift]);
   bool greenCandle = (open[shift] < close[shift]);
   bool noBodyTailCandle = ((open[shift] == close[shift]) && (low[shift] != high[shift]));
   bool noBodyCandle = ((open[shift] == close[shift]) && (low[shift] == high[shift])) ;

   if(noBodyCandle)
      return SAN_SIGNAL::NOSIG;


//   bool fullBodyCandle = ((open[shift] == high[shift]) && (close[shift] == low[shift]));

   bool fullBodyRedCandle = (redCandle && (open[shift] == high[shift]) && (close[shift] == low[shift]));
   bool fullBodyGreenCandle = (greenCandle && (open[shift] == low[shift]) && (close[shift] == high[shift]));
   bool fullBodyCandle = (fullBodyRedCandle || fullBodyGreenCandle);

//double upperTail = ((redCandle||noBodyTailCandle) && !fullBodyCandle && !noBodyCandle)?(high[1]-open[1]):(high[1]-close[1]);
//double lowerTail = ((redCandle||noBodyTailCandle) && !fullBodyCandle && !noBodyCandle)?(close[1]-low[1]):(open[1]-low[1]);

   if((redCandle||noBodyTailCandle) && !fullBodyCandle && !noBodyCandle) {
      upperTail=(high[shift]-open[shift]);
      lowerTail=(close[shift]-low[shift]);
   } else if((greenCandle||noBodyTailCandle) && !fullBodyCandle && !noBodyCandle) {
      upperTail=(high[shift]-close[shift]);
      lowerTail=(open[shift]-low[shift]);

   }


   double body =  NormalizeDouble(fabs(open[shift]-close[shift]),_Digits);


   double candleRange =  NormalizeDouble(fabs(high[shift]-low[shift]),_Digits);

   double bodyRatio = (!noBodyTailCandle&&!fullBodyCandle && !noBodyCandle && (body>0)&&(candleRange>0))?NormalizeDouble((body/candleRange),2):NULL;

   bool tailDominates = (noBodyTailCandle || (bodyRatio <= 0.35));
   bool bodyDominates = (fullBodyCandle ||(bodyRatio > 0.35)) ;
//   bool bodyDominates = (fullBodyCandle ||(bodyRatio > 0.65)) ;
//   Print("tailDominates: "+tailDominates+" bodyDominates: "+ bodyDominates+" body ratio: "+bodyRatio+" Candle range: "+candleRange);

   if(bodyDominates) {
      if(redCandle) {
         return SAN_SIGNAL::SELL;
      }
      if(greenCandle) {
         return SAN_SIGNAL::BUY;
      }
   }
   if(tailDominates) {
      if((upperTail==0)&& (lowerTail>0))
         return SAN_SIGNAL::BUY;
      if((lowerTail==0)&&(upperTail>0))
         return SAN_SIGNAL::SELL;
      if((upperTail!=0)&&(lowerTail!=0)&&(NormalizeDouble((fabs(upperTail)/fabs(lowerTail)),2)<=0.35))
         return SAN_SIGNAL::BUY;
      if((upperTail!=0)&&(lowerTail!=0)&&(NormalizeDouble((fabs(lowerTail)/fabs(upperTail)),2)<=0.35))
         //  if((upperTail!=0)&&(lowerTail!=0)&&(NormalizeDouble((fabs(upperTail)/fabs(lowerTail)),2)>0.65))
         return SAN_SIGNAL::SELL;
   }
   return SAN_SIGNAL::NOSIG;
}
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//const SAN_SIGNAL SanSignals::stdDevSIG(const double &param[],const double stdLimit, const int shift=1,const int period=10, string label="")
const SIGMAVARIABILITY SanSignals::stdDevSIG(const double &data[],string label="",const int period=10,const int shift=1) {
   double cpStdDev = 0;
   double mean = EMPTY_VALUE;
   double zScore = EMPTY_VALUE;
//   double ZSCORERANGE_TRADE = 0.7;
// ZSCORE constants
   double ZRESTSIGMA = 4;
   double Z35SIGMA = 3.5;
   double Z30SIGMA = 3.0;
   double Z25SIGMA = 2.5;
   double Z20SIGMA = 2.0;
   double Z16SIGMA = 1.6;
   double Z10SIGMA = 1;
   double ZHALFSIGMA = 0.5;
   double ZMEANRANGE = 0.1;
   double ZMEAN = 0.0;


//cpStdDev = stats.stdDev(data,shift,period)/tPoint;
//if(cpStdDev>stdLimit)
//return SAN_SIGNAL::TRADE;

   cpStdDev = stats.stdDev(data,shift,period);
   mean = stats.mean(data,period,shift);
   zScore = stats.zScore(data[shift],mean,cpStdDev);
// Print("["+label+"]:: stdDev: "+cpStdDev+" zScore: "+zScore+" mean: "+mean+"[-0.3 0.3] "+((zScore>=-0.3)&&(zScore<=0.3))+"[-2 2]  "+((zScore<=-1.0)||(zScore>=1.0)));

//if((zScore>=(-1*ZMEANRANGE))&&(zScore<=ZMEANRANGE))
//   return SIGMAVARIABILITY::SIGMA_MEAN;
//if((zScore>=(-1*ZHALFSIGMA))&&(zScore<=ZHALFSIGMA))
//   return SIGMAVARIABILITY::SIGMA_HALF;
//if((zScore>=(-1*Z10SIGMA))&&(zScore<=Z10SIGMA))
//   return SIGMAVARIABILITY::SIGMA_1;
//if((zScore>=(-1*Z16SIGMA))&&(zScore<=Z16SIGMA))
//   return SIGMAVARIABILITY::SIGMA_16;
//if((zScore>=(-1*Z20SIGMA))&&(zScore<=Z20SIGMA))
//   return SIGMAVARIABILITY::SIGMA_2;
//if((zScore>=(-1*Z30SIGMA))&&(zScore<=Z30SIGMA))
//   return SIGMAVARIABILITY::SIGMA_3;
//if((zScore<=(-1*ZRESTSIGMA))||(zScore>=ZRESTSIGMA))
//   return SIGMAVARIABILITY::SIGMA_REST;

//  Print("zScore: "+ NormalizeDouble(zScore,2));
   if((zScore==ZMEAN))
      return SIGMAVARIABILITY::SIGMA_MEAN;

   if((zScore>=(-1*ZMEANRANGE))&&(zScore<ZMEAN))
      return SIGMAVARIABILITY::SIGMANEG_MEAN;

   if((zScore>ZMEAN)&&(zScore<=ZMEANRANGE))
      return SIGMAVARIABILITY::SIGMAPOS_MEAN;

   if((zScore>=(-1*ZHALFSIGMA))&&(zScore<(-1*ZMEANRANGE)))//&&(data[shift]<data[shift+2]))
      return SIGMAVARIABILITY::SIGMANEG_HALF;
   if((zScore>ZMEANRANGE)&&(zScore<=ZHALFSIGMA))//&&(data[shift]>data[shift+2]))
      return SIGMAVARIABILITY::SIGMAPOS_HALF;

   if((zScore>=(-1*Z10SIGMA))&&(zScore<(-1*ZHALFSIGMA)))//&&(data[shift]<data[shift+2]))
      return SIGMAVARIABILITY::SIGMANEG_1;
   if((zScore>ZHALFSIGMA)&&(zScore<=Z10SIGMA))//&&(data[shift]>data[shift+2]))
      return SIGMAVARIABILITY::SIGMAPOS_1;

   if((zScore>=(-1*Z16SIGMA))&&(zScore<(-1*Z10SIGMA)))//&&(data[shift]<data[shift+2]))
      return SIGMAVARIABILITY::SIGMANEG_16;
   if((zScore>Z10SIGMA)&&(zScore<=Z16SIGMA))//&&(data[shift]>data[shift+2]))
      return SIGMAVARIABILITY::SIGMAPOS_16;

   if((zScore>=(-1*Z20SIGMA))&&(zScore<(-1*Z16SIGMA)))//&&(data[shift]<data[shift+2]))
      return SIGMAVARIABILITY::SIGMANEG_2;
   if((zScore>Z16SIGMA)&&(zScore<=Z20SIGMA))//&&(data[shift]>data[shift+2]))
      return SIGMAVARIABILITY::SIGMAPOS_2;

   if((zScore>=(-1*Z30SIGMA))&&(zScore<(-1*Z20SIGMA)))//&&(data[shift]<data[shift+2]))
      return SIGMAVARIABILITY::SIGMANEG_3;
   if((zScore>Z20SIGMA)&&(zScore<=Z30SIGMA))//&&(data[shift]>data[shift+2]))
      return SIGMAVARIABILITY::SIGMAPOS_3;

   if((zScore>=(-1*Z35SIGMA))&&(zScore<(-1*Z30SIGMA)))//&&(data[shift]<data[shift+2]))
      return SIGMAVARIABILITY::SIGMANEG_35;
   if((zScore>Z30SIGMA)&&(zScore<=Z35SIGMA))//&&(data[shift]>data[shift+2]))
      return SIGMAVARIABILITY::SIGMAPOS_35;

   if((zScore>=(-1*ZRESTSIGMA))&&(zScore<(-1*Z35SIGMA)))//&&(data[shift]<data[shift+2]))
      return SIGMAVARIABILITY::SIGMANEG_4;
   if((zScore>Z35SIGMA)&&(zScore<=ZRESTSIGMA))//&&(data[shift]>data[shift+2]))
      return SIGMAVARIABILITY::SIGMAPOS_4;

   if((zScore<(-1*ZRESTSIGMA)))
      return SIGMAVARIABILITY::SIGMANEG_REST;
   if(zScore>ZRESTSIGMA)
      return SIGMAVARIABILITY::SIGMAPOS_REST;

   return SIGMAVARIABILITY::SIGMA_NULL;
}


//+------------------------------------------------------------------+
//|                    NEW ONE                                              |
//+------------------------------------------------------------------+
TRENDSTRUCT SanSignals::acfStdSIG(const double &sig[],const int period=10,const int shift=1) {
   TRENDSTRUCT ts;
   const double tPoint = Point();
   double acf = 0;
   double stdDev = 0;
   double zScore = 0;
   double mean = 0;

   double const LOWER_SUPERFLAT_ZSCORE = -0.1;
   double const UPPER_SUPERFLAT_ZSCORE = 0.1;
   double const LOWER_HIGHFLAT_ZSCORE = -0.2;
   double const UPPER_HIGHFLAT_ZSCORE = 0.2;
   double const LOWER_NORMALFLAT_ZSCORE = -0.3;
   double const UPPER_NORMALFLAT_ZSCORE = 0.3;


   double const LOWER_CONSERVATIVE_ZSCORE = -1.96;
   double const UPPER_CONSERVATIVE_ZSCORE = 1.96;

   double const LOWER_SPIKE_ZSCORE = -1.96;
   double const UPPER_SPIKE_ZSCORE = 1.96;

   double const LOWER_SSPIKE_ZSCORE = -3.0;
   double const UPPER_SSPIKE_ZSCORE = 3.0;

//double arrDiff[];
//ArrayResize(arrDiff,(period-shift));
//for(int i=shift,j=0;i<(period-shift);j++,i++){
//  arrDiff[j]=sig[i]-sig[i+shift];
//}


   mean = stats.mean(sig);

   acf = stats.acf(sig,period,1);
   stdDev = stats.stdDev(sig,0,period)/tPoint;
   zScore = stats.zScore(sig[shift],mean,stdDev)/tPoint;

//bool flatSuperHighTrend = ((fabs(acf)<=0.1)&&((zScore>=LOWER_SUPERFLAT_ZSCORE)&&(zScore<=UPPER_SUPERFLAT_ZSCORE)));
//bool flatHighTrend = ((fabs(acf)<=0.2)&&((zScore>=LOWER_HIGHFLAT_ZSCORE)&&(zScore<=UPPER_HIGHFLAT_ZSCORE)));
//bool flatNormalTrend = ((fabs(acf)<=0.3)&&((zScore>=LOWER_NORMALFLAT_ZSCORE)&&(zScore<=UPPER_NORMALFLAT_ZSCORE)));


   bool flatSuperHighTrend = (fabs(acf)<=0.1);
   bool flatHighTrend = ((fabs(acf)<=0.2)&&!flatSuperHighTrend);
   bool flatNormalTrend = ((fabs(acf)<=0.3)&&!flatHighTrend);
//Print(" ACF values: "+acf+" acf limit: "+tl.acfLimit + "super flat: "+flatSuperHighTrend+" high flat: "+flatHighTrend+" flat normal: "+ flatNormalTrend +" zScore: "+zScore);

   bool notFlat = (!flatNormalTrend && !flatHighTrend && !flatSuperHighTrend);
   bool aboveAcfLimit = ((fabs(acf)>tl.acfLimit) && notFlat);

//   bool conservativeUpTrend = (notFlat && ((fabs(acf)>tl.acfLimit)&&((zScore>UPPER_NORMALFLAT_ZSCORE) && (zScore<=UPPER_CONSERVATIVE_ZSCORE))));
//   bool conservativeDownTrend = (notFlat && ((fabs(acf)>tl.acfLimit)&&((zScore>=LOWER_CONSERVATIVE_ZSCORE) && (zScore<LOWER_NORMALFLAT_ZSCORE))));
//
//   bool spikeUpTrend = (notFlat && ((fabs(acf)>tl.acfLimit)&&((zScore>UPPER_CONSERVATIVE_ZSCORE) && (zScore<=UPPER_SSPIKE_ZSCORE))));
//   bool spikeDownTrend = (notFlat && ((fabs(acf)>tl.acfLimit)&&((zScore>=LOWER_SSPIKE_ZSCORE) && (zScore<LOWER_CONSERVATIVE_ZSCORE))));
//
//   bool superSpikeUpTrend = (notFlat && ((fabs(acf)>tl.acfLimit)&&(zScore>UPPER_SSPIKE_ZSCORE)));
//   bool superSpikeDownTrend = (notFlat && ((fabs(acf)>tl.acfLimit)&&(zScore<LOWER_SSPIKE_ZSCORE)));

   bool conservativeUpTrend = (aboveAcfLimit &&((zScore>UPPER_HIGHFLAT_ZSCORE) && (zScore<=UPPER_CONSERVATIVE_ZSCORE)));
   bool conservativeDownTrend = (aboveAcfLimit &&((zScore>=LOWER_CONSERVATIVE_ZSCORE) && (zScore<LOWER_HIGHFLAT_ZSCORE)));

   bool spikeUpTrend = (aboveAcfLimit &&((zScore>UPPER_CONSERVATIVE_ZSCORE) && (zScore<=UPPER_SSPIKE_ZSCORE)));
   bool spikeDownTrend = (aboveAcfLimit &&((zScore>=LOWER_SSPIKE_ZSCORE) && (zScore<LOWER_CONSERVATIVE_ZSCORE)));

   bool superSpikeUpTrend = (aboveAcfLimit &&(zScore>UPPER_SSPIKE_ZSCORE));
   bool superSpikeDownTrend = (aboveAcfLimit &&(zScore<LOWER_SSPIKE_ZSCORE));



   if(flatSuperHighTrend) {
      ts.closeTrendSIG = SANTREND::FLAT;
      ts.trendStrengthSIG = SANTRENDSTRENGTH::SUPERHIGH;
      return ts;
   } else if(flatHighTrend) {
      ts.closeTrendSIG = SANTREND::FLAT;
      ts.trendStrengthSIG = SANTRENDSTRENGTH::HIGH;
      return ts;
   } else if(flatNormalTrend) {
      ts.closeTrendSIG = SANTREND::FLAT;
      ts.trendStrengthSIG = SANTRENDSTRENGTH::NORMAL;
      return ts;
   } else if(superSpikeUpTrend) {
      ts.closeTrendSIG = SANTREND::UP;
      ts.trendStrengthSIG = SANTRENDSTRENGTH::SUPERHIGH;
      return ts;
   } else if(superSpikeDownTrend) {
      ts.closeTrendSIG = SANTREND::DOWN;
      ts.trendStrengthSIG = SANTRENDSTRENGTH::SUPERHIGH;
      return ts;
   } else if(spikeUpTrend) {
      ts.closeTrendSIG = SANTREND::UP;
      ts.trendStrengthSIG = SANTRENDSTRENGTH::HIGH;
      return ts;
   } else if(spikeDownTrend) {
      ts.closeTrendSIG = SANTREND::DOWN;
      ts.trendStrengthSIG = SANTRENDSTRENGTH::HIGH;
      return ts;
   } else if(conservativeUpTrend) {
      ts.closeTrendSIG = SANTREND::UP;
      ts.trendStrengthSIG = SANTRENDSTRENGTH::NORMAL;
      return ts;
   } else if(conservativeDownTrend) {
      ts.closeTrendSIG = SANTREND::DOWN;
      ts.trendStrengthSIG = SANTRENDSTRENGTH::NORMAL;
      return ts;
   }
   return ts;

}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL       SanSignals::closeOnLossSIG(const double lossAmt=1.0, const int orderPos=0) {
   double currspread = (int)MarketInfo(_Symbol,MODE_SPREAD);
   const double tPoint = Point();
   double adjustedLossAmt = NormalizeDouble((lossAmt+((tl.spreadLimit*5)*tPoint)),2);
   adjustedLossAmt *=-1;

   if(OrderSelect(orderPos,SELECT_BY_POS)&&(currspread< tl.spreadLimit)&&(OrderProfit()<adjustedLossAmt)) {
      return SAN_SIGNAL::CLOSE;
   }
   return SAN_SIGNAL::NOSIG;
}
//

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL SanSignals::closeOnProfitPercentageSIG(const double currProfit, const double maxProfit, const double closeProfit, const double percentage=0.05) {
//Print("[TAKEPROFIT] Take Profit: "+ closeProfit);
   const double tPoint = Point();
   double currspread = (int)MarketInfo(_Symbol,MODE_SPREAD);

//maxProfit = ((maxProfit!=EMPTY_VALUE)&&(maxProfit!=NULL))? maxProfit:0;
//closeProfit = ((closeProfit!=EMPTY_VALUE)&&(closeProfit!=NULL))? closeProfit:0;

   double adjustedMaxProfit = NormalizeDouble(maxProfit-((tl.spreadLimit*5)*tPoint),2);

   double adjustedMaxProfitPercentage = NormalizeDouble((1-percentage)*adjustedMaxProfit,2);

   bool orderAndSpreadChk = ((OrdersTotal()>0)&&(currspread< tl.spreadLimit)&&(adjustedMaxProfitPercentage>0));
   bool profitLimitChk = ((adjustedMaxProfitPercentage>(1.2*closeProfit)) && (currProfit<adjustedMaxProfitPercentage));
//  bool profitLimitChk = ((adjustedMaxProfitPercentage>closeProfit) && (currProfit<adjustedMaxProfitPercentage));

//Print("Current Profit: "+currProfit+" Max profit: "+maxProfit+" Adjusted profit: "+adjustedMaxProfit+" Percentage : "+ percentage+" of Adjusted profit: "+adjustedMaxProfitPercentage+" 1.2*closeProfit "+(1.2*closeProfit));

   if(orderAndSpreadChk && profitLimitChk) {
      return SAN_SIGNAL::CLOSE;
   }
   return SAN_SIGNAL::NOSIG;

}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL SanSignals::closeOnProfitSIG(const double currProfit, const double closeProfit=0.02, const int pos=0) {
//Print("Close profit value: "+ closeProfit);
   double currspread = (int)MarketInfo(_Symbol,MODE_SPREAD);
   bool orderAndSpreadChk = ((OrdersTotal()>0)&&(currProfit>closeProfit)&&(currspread< tl.spreadLimit));

   if(OrderSelect(pos,SELECT_BY_POS) && (OrderProfit()>closeProfit) && (currspread< tl.spreadLimit))
      return SAN_SIGNAL::CLOSE;
   return SAN_SIGNAL::NOSIG;

}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL SanSignals::candleImaSIG(
   const double &open[],
   const double &close[],
   const double &imaHandle5[],
   const double &imaHandle14[],
   const double &imaHandle30[],
   const int period=5,
   const int shift=1
) {

   int buyCount = 0;
   int sellCount = 0;
   int flatCount = 0;

   int buyDoubleCount = 0;
   int sellDoubleCount = 0;
   int flatDoubleCount = 0;

   int buyTripleCount = 0;
   int sellTripleCount = 0;
   int flatTripleCount = 0;

   for(int i = shift; i<period; i++) {

      if((open[i] == close[i])&&(open[i+2] == close[i+2]))
         flatTripleCount++;

      if((close[i] > open[i])&&(close[i+2] > open[i+2])) {
         if(((imaHandle5[i+2] >= open[i+2])&&(imaHandle5[i] <= close[i]))&&((imaHandle14[i+2] >= open[i+2])&&(imaHandle14[i] <= close[i]))&&((imaHandle30[i+2] >= open[i+2])&&(imaHandle30[i] <= close[i])))
            buyTripleCount++;
      }
      if((close[i] < open[i])&&(close[i+2] < open[i+2])) {
         if(((imaHandle5[i+2] <= open[i+2])&&(imaHandle5[i] >= close[i]))&&((imaHandle14[i+2] <= open[i+2])&&(imaHandle14[i] >= close[i]))&&((imaHandle30[i+2] <= open[i+2])&&(imaHandle30[i] >= close[i])))
            sellTripleCount++;
      }
   }

   for(int i = shift; i<period; i++) {

      if((open[i] == close[i])&&(open[i+1] == close[i+1]))
         flatDoubleCount++;

      if((close[i] > open[i])&&(close[i+1] > open[i+1])) {
         if(((imaHandle5[i+1] >= open[i+1])&&(imaHandle5[i] <= close[i]))&&((imaHandle14[i+1] >= open[i+1])&&(imaHandle14[i] <= close[i]))&&((imaHandle30[i+1] >= open[i+1])&&(imaHandle30[i] <= close[i])))
            buyDoubleCount++;
      }
      if((close[i] < open[i])&&(close[i+1] < open[i+1])) {
         if(((imaHandle5[i+1] <= open[i+1])&&(imaHandle5[i] >= close[i]))&&((imaHandle14[i+1] <= open[i+1])&&(imaHandle14[i] >= close[i]))&&((imaHandle30[i+1] <= open[i+1])&&(imaHandle30[i] >= close[i])))
            sellDoubleCount++;
      }

   }

   for(int i = shift; i<period; i++) {

      if(open[i] == close[i])
         flatCount++;

      if(close[i] > open[i]) {
         if(((imaHandle5[i] >= open[i])&&(imaHandle5[i] <= close[i]))&&((imaHandle14[i] >= open[i])&&(imaHandle14[i] <= close[i]))&&((imaHandle30[i] >= open[i])&&(imaHandle30[i] <= close[i])))
            buyCount++;
      }
      if(close[i] < open[i]) {
         if(((imaHandle5[i] <= open[i])&&(imaHandle5[i] >= close[i]))&&((imaHandle14[i] <= open[i])&&(imaHandle14[i] >= close[i]))&&((imaHandle30[i] <= open[i])&&(imaHandle30[i] >= close[i])))
            sellCount++;
      }
   }

   bool buyTripleBool = ((buyTripleCount==1)&&(sellTripleCount==0)&&(flatTripleCount==0));
   bool buyDoubleBool = ((buyDoubleCount==1)&&(sellDoubleCount==0)&&(flatDoubleCount==0));
   bool buySingleBool = ((buyCount==1)&&(sellCount==0)&&(flatCount==0));

   bool sellTripleBool = ((buyTripleCount==0)&&(sellTripleCount==1)&&(flatTripleCount==0));
   bool sellDoubleBool = ((buyDoubleCount==0)&&(sellDoubleCount==1)&&(flatDoubleCount==0));
   bool sellSingleBool = ((buyCount==0)&&(sellCount==1)&&(flatCount==0));

   bool flatTripleBool = ((flatTripleCount>=1)&&(buyTripleCount==0)&&(sellTripleCount==0));
   bool flatDoubleBool = ((flatDoubleCount>=1)&&(buyDoubleCount==0)&&(sellDoubleCount==0));
   bool flatSingleBool = ((flatCount>=1)&&(buyCount==0)&&(sellCount==0));

   bool buyBool = (buyTripleBool||buyDoubleBool||buySingleBool);
   bool sellBool = (sellTripleBool||sellDoubleBool||sellSingleBool);
   bool flatBool = (flatTripleBool||flatDoubleBool||flatSingleBool);


   if(flatBool)
      return SAN_SIGNAL::NOSIG;
   if(buyBool)
      return SAN_SIGNAL::BUY;
   if(sellBool)
      return SAN_SIGNAL::SELL;


   return SAN_SIGNAL::NOSIG;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL   SanSignals::candleVolSIG(
   const double &open[],
   const double &close[],
   const double &vol[],
   const int period=10,
   const int shift=1
) {
   const double tPoint = Point();
   const double LOWERLIMIT = 0.7;
   const double UPPERLIMIT = 1.3;
   double DOTPRODUCTSIZE = 10;
   double diff[];
   double redDotProduct=0;
   double greenDotProduct=0;
   double dotProduct=0;
   double dotProduct1=0;
   double dotProduct2=0;
   double ratio = EMPTY_VALUE;

   ArrayResize(diff,(period+1));
   int timePeriod = 60;
   if(_Period == PERIOD_M1) {
      timePeriod=60;
      DOTPRODUCTSIZE=20;
   }
   if(_Period == PERIOD_M5) {
      timePeriod=(60*5);
      DOTPRODUCTSIZE=30;
   }
   if(_Period == PERIOD_M15) {
      timePeriod=(60*15);
      DOTPRODUCTSIZE=50;
   }
   if(_Period == PERIOD_M30) {
      timePeriod=(60*30);
      DOTPRODUCTSIZE=100;
   }

   if(_Period == PERIOD_H1) {
      timePeriod=(60*60);
      DOTPRODUCTSIZE=200;
   }

   if(_Period == PERIOD_H4) {
      timePeriod=(60*240);
      DOTPRODUCTSIZE=400;
   }

   if(_Period == PERIOD_D1) {
      timePeriod=(60*1440);
      DOTPRODUCTSIZE=1440;
   }


   for(int i=shift,j=0; i<=period; i++,j++)
      //for(int i=shift,j=0; i<period; i++,j++)
   {
      diff[j] = ((close[i]-open[i])/tPoint);
      // dotProduct += (vol[i]*((diff[j]/10)/timePeriod));
      // dotProduct1 += (vol[i]*((diff[j]/period)/timePeriod));
      dotProduct += (vol[i]*((diff[j]/(period*timePeriod))));
      if(diff[j]<0)
         redDotProduct+=fabs(vol[i]*diff[j]);
      if(diff[j]>0)
         greenDotProduct+=(vol[i]*diff[j]);

      //  Print("Open values: "+(open[i])+" close values: "+ (close[i])+ " diff: "+diff[i]+" Volume: "+vol[i]);

   }

//Print("Combined dot product: "+ (NormalizeDouble(dotProduct,2))+" DOTPRODUCTSIZE: "+DOTPRODUCTSIZE);
   if((greenDotProduct == 0) && (redDotProduct > 0)) {
      ratio = 0;
   } else if((greenDotProduct > 0) && (redDotProduct == 0)) {
      ratio = NormalizeDouble(greenDotProduct,2);
   }

   else if((greenDotProduct > 0) && (redDotProduct > 0)) {
      ratio = NormalizeDouble((greenDotProduct/redDotProduct),2);
   }

// Print(" Red dot: "+redDotProduct+" Green dot: "+greenDotProduct+" ratio: "+ratio);
   if(((ratio >= LOWERLIMIT)&&(ratio <= UPPERLIMIT))||(fabs(dotProduct)<DOTPRODUCTSIZE)) {
      return SAN_SIGNAL::SIDEWAYS;
   } else if((ratio < LOWERLIMIT) && (dotProduct<=(-1*DOTPRODUCTSIZE))) {
      return SAN_SIGNAL::SELL;
   } else if((ratio > UPPERLIMIT)&& (dotProduct>=DOTPRODUCTSIZE)) {
      return SAN_SIGNAL::BUY;
   }


   return SAN_SIGNAL::NOSIG;
}


//+------------------------------------------------------------------+
//  h1 = sigmoid(tick1*price1 + bias)
//  h2 = sigmoid(Wh*h1 + tick2*price2 + bias)
//  sigmoid = 1/(1+e^-x)
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL   SanSignals::candleVolSIG_v1(
   const double &open[],
   const double &close[],
   const double &vol[],
   const int period=10,
   const int shift=1
) {
   const double tPoint = Point();
   const double LOWERLIMIT = 0.8;
   const double UPPERLIMIT = 1.2;
//   const double LOWERLIMIT = 0.7;
//   const double UPPERLIMIT = 1.3;
   double DOTPRODUCTSIZE = 10;
   double diff[];

   double redDotProduct=0;
   double greenDotProduct=0;
   double dotProduct=0;
//double dotProduct1=0;
//double dotProduct2=0;
   double fastDotProduct=0;
   double slowDotProduct=0;
   double ratio = EMPTY_VALUE;

   uint slowPeriod=period;
   uint fastPeriod=(int)MathCeil(0.7*period);
   ArrayResize(diff,(slowPeriod+1));

   int timePeriod = 60;
   if(_Period == PERIOD_M1) {
      timePeriod=60;
      DOTPRODUCTSIZE=20;
   }
   if(_Period == PERIOD_M5) {
      timePeriod=(60*5);
      DOTPRODUCTSIZE=30;
   }
   if(_Period == PERIOD_M15) {
      timePeriod=(60*15);
      DOTPRODUCTSIZE=50;
   }
   if(_Period == PERIOD_M30) {
      timePeriod=(60*30);
      DOTPRODUCTSIZE=100;
   }

   if(_Period == PERIOD_H1) {
      timePeriod=(60*60);
      DOTPRODUCTSIZE=200;
   }

   if(_Period == PERIOD_H4) {
      timePeriod=(60*240);
      DOTPRODUCTSIZE=400;
   }

   if(_Period == PERIOD_D1) {
      timePeriod=(60*1440);
      DOTPRODUCTSIZE=1440;
   }


   for(int i=shift,j=0; i<=slowPeriod; i++,j++)
      //for(int i=shift,j=0; i<period; i++,j++)
   {
      diff[j] = ((close[i]-open[i])/tPoint);
      // dotProduct += (vol[i]*((slowDiff[j]/10)/timePeriod));
      // dotProduct1 += (vol[i]*((slowDiff[j]/period)/timePeriod));
      slowDotProduct += (vol[i]*((diff[j]/(period*timePeriod))));
      if(i<=fastPeriod) {
         fastDotProduct += slowDotProduct;
         if(diff[j]<0)
            redDotProduct+=fabs(vol[i]*diff[j]);
         if(diff[j]>0)
            greenDotProduct+=(vol[i]*diff[j]);
      }
   }


   if((greenDotProduct == 0) && (redDotProduct > 0)) {
      ratio = 0;
   } else if((greenDotProduct > 0) && (redDotProduct == 0)) {
      ratio = NormalizeDouble(greenDotProduct,2);
   }

   else if((greenDotProduct > 0) && (redDotProduct > 0)) {
      ratio = NormalizeDouble((greenDotProduct/redDotProduct),2);
   }


   bool sameSideBool = (((slowDotProduct>0)&&(fastDotProduct>0))||((slowDotProduct<0)&&(fastDotProduct<0)));
   bool oppSideBuyBool=((slowDotProduct<0)&&(fastDotProduct>0));
   bool oppSideSellBool= ((slowDotProduct>0)&&(fastDotProduct<0));
   bool oppSideBool = (oppSideBuyBool||oppSideSellBool);
   bool flatBool = ((ratio >= LOWERLIMIT)&&(ratio <= UPPERLIMIT));
   bool varBool = ((ratio < LOWERLIMIT)||(ratio > UPPERLIMIT));

   double prodRatio = 0;
   prodRatio= (NormalizeDouble((slowDotProduct/fastDotProduct),2));
   bool prodSigBool = ((prodRatio>0)&&(prodRatio<1.5));



// Print(" Red dot: "+redDotProduct+" Green dot: "+greenDotProduct+" ratio: "+ratio);
// Print("Slow dot product: "+ (NormalizeDouble(slowDotProduct,2))+" fast dotproduct: "+ (NormalizeDouble(fastDotProduct,2))+" Ratio: "+ratio+" prodRatio: "+prodRatio+" DPSIZE: "+DOTPRODUCTSIZE);


   if(varBool && (prodRatio<0)&&oppSideBuyBool) {
      //return SAN_SIGNAL::CLOSESELL;
      //return SAN_SIGNAL::BUY;
      return SAN_SIGNAL::CLOSE;
   } else if(varBool && (prodRatio<0) && oppSideSellBool) {
      //return SAN_SIGNAL::CLOSEBUY;
      //return SAN_SIGNAL::SELL;
      return SAN_SIGNAL::CLOSE;
   } else if(flatBool||(fabs(fastDotProduct)<DOTPRODUCTSIZE)) {
      return SAN_SIGNAL::SIDEWAYS;
   } else if((ratio < LOWERLIMIT) && (fastDotProduct<=(-1*DOTPRODUCTSIZE)) && prodSigBool) {
      return SAN_SIGNAL::SELL;
   } else if((ratio > UPPERLIMIT)&& (fastDotProduct>=DOTPRODUCTSIZE) && prodSigBool) {
      return SAN_SIGNAL::BUY;
   }


   return SAN_SIGNAL::NOSIG;
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL   SanSignals::pVElastSIG(
   const double &open[],
   const double &close[],
   const double &vol[],
   const int period=10,
   const int shift=1
) {

   double elast[];
   ArrayResize(elast,(period+1));

   for(int i=shift,j=0; i<=period; i++,j++) {
      if(vol[i+1]>0) {
         if(((vol[i]-vol[i+1])/vol[i+1])==0) {
            elast[j] = ((close[i]-close[i+1])/close[i+1]);
         }
         if(((close[i]-close[i+1])/close[i+1])==0) {
            elast[j] = 0;
         }
         if(((vol[i]-vol[i+1])/vol[i+1])>0) {
            elast[j] = (((close[i]-close[i+1])/close[i+1])/((vol[i]-vol[i+1])/vol[i+1]));
         }
      } else {
         elast[j] = 0;
      }



   }

   Print("Elasticity 0 : "+ NormalizeDouble(elast[0],8)+" 1: "+ (NormalizeDouble(elast[1],8)/Point())+" 2: "+(NormalizeDouble(elast[1],8)/Point())+" 10: "+(NormalizeDouble(elast[9],8)/Point())+" Mean: "+(NormalizeDouble((stats.mean(elast)),8)/Point()));
   return SAN_SIGNAL::NOSIG;

};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL SanSignals::candleStar(
   const double &open[],
   const double &high[],
   const double &low[],
   const double &close[],
   const double candleBodySize=0.1,
   const double slope=0.6,
   const int period=10,
   const int shift=1
) {
   SAN_SIGNAL trendSig = SAN_SIGNAL::NOSIG;
   double cpSlope = EMPTY_VALUE;
   if(shift>=period)
      return SAN_SIGNAL::NOSIG;

   CandleCharacter cc(open,high,low,close,candleBodySize,shift);
   DataTransport dt = stats.scatterPlotSlope(close);

   int lowCount=0;
   int lowPriceCount=0;
   int hiPriceCount=0;
   int hiCount=0;

   for(int i=shift; i<=period; i++) {
      if(low[shift]<low[i])
         ++lowCount;
      if(high[shift]>high[i])
         ++hiCount;
      if(cc.redCandle && (((open[i]>close[i])&&(close[shift]<close[i]))||((open[i]<close[i])&&(close[shift]<open[i])))) {
         ++lowPriceCount;
      }
      if(cc.greenCandle && (((open[i]<close[i])&&(close[shift]>close[i]))||((open[i]>close[i])&&(close[shift]>open[i])))) {
         ++hiPriceCount;
      }
   }


   cpSlope = dt.matrixD[0];
   bool starCandle = (cc.noBodyTailCandle||cc.noBodyCandle);


// Print("star candle: "+starCandle+" CC lower tail: "+cc.noBodyLowerTailCandle+" cc upper tail: "+cc.noBodyUpperTailCandle+" tail dominates "+cc.tailDominates+" Nobody: "+cc.noBodyCandle+" Nobody tail:"+cc.noBodyTailCandle+"Slope CP: "+ dt.matrixD[0]);

// Print("tail: "+cc.tailDominates+" body "+cc.bodyDominates+" body ratio: "+cc.bodyRatio+" range: "+cc.candleRange+" red: "+cc.redCandle+" green: "+cc.greenCandle);
// Print("tail: "+tailDominates+" body "+bodyDominates+" body ratio: "+bodyRatio+" range: "+candleRange+" red: "+redCandle+" green: "+greenCandle);
// Print("lowCount: "+lowCount+" lowPriceCount: "+lowPriceCount+" hiCount: "+hiCount+" hiPriceCount: "+hiPriceCount+" star candle:"+(cc.tailDominates||cc.noBodyTailCandle)+" bodyLowerTailCandle: "+cc.bodyLowerTailCandle+" bodyUpperTailCandle: "+ cc.bodyUpperTailCandle+" noBodyUpperTailCandle:"+cc.noBodyUpperTailCandle+" noBodyLowerTailCandle: "+cc.noBodyLowerTailCandle);


   if(starCandle&&(cpSlope>=slope)&&((hiPriceCount==(period-shift))&&(hiCount == (period-shift))))
      return SAN_SIGNAL::SELL;
//return SAN_SIGNAL::REVERSETRADE;
   if(starCandle&&(cpSlope<=-1*slope)&&((lowPriceCount==(period-shift))&&(lowCount == (period-shift))))
      return SAN_SIGNAL::BUY;
//return SAN_SIGNAL::REVERSETRADE;

   return SAN_SIGNAL::NOSIG;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SANTREND SanSignals::trendScatterPlotSIG(const double &data[],string label="",const double slope=0.3,const int period=10,const int shift=1) {
   DataTransport d = stats.scatterPlotSlope(data,period,1);
//double dataSlope = d.matrixD[0];
   double dataSlope = d.matrixD[2];
// Print("["+label+"]: "+dataSlope);
   if((dataSlope>(-1*slope))&&(dataSlope<(slope))) {
      return SANTREND::FLAT;
   } else if(dataSlope>=slope) {
      return SANTREND::UP;
   } else if(dataSlope<=(-1*slope)) {
      return SANTREND::DOWN;
   }

   return SANTREND::NOTREND;
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SANTREND SanSignals::trendRatioSIG(const double &sig[],string label="",const double slopeRatio=2,const int period=10,const int shift=1) {

   SANTREND trendSig = SANTREND::NOTREND;
//   Print("trendRatioSIG: ima30 current 1: "+sig[1]+" :ima30 5: "+ sig[5]+" :ima30 10: "+ sig[10]+" :21:" + sig[21] );
   double up=0;
   double flat=0;
   double down=0;
   double ratio=0;
   double ratioDown=0;

   for(int i=shift; i<=period; i++) {
      // Print("Sig[i]: "+ sig[i]+" sig[period]: "+ sig[period]+" (i>period): "+(sig[i]>sig[period])+" period>i: "+(sig[i]<sig[period]));
      if(sig[i]>sig[period])
         up++;
      if(sig[i]<sig[period])
         down++;
      if(sig[i]==sig[period])
         flat++;
   }

   if((up>0)&&(down>0)) {
      ratio = (up/down);
      ratioDown = (down/up);
   } else if((up==0)&&(down>0)) {
      ratio = 0;
      ratioDown = period;
   } else if((up>0)&&(down==0)) {
      ratio = period;
      ratioDown=0;
   } else if((up==0)&&(down==0)) {
      ratio = 0;
      ratioDown=0;
   }



   SIGMAVARIABILITY s1 = stdDevSIG(sig,"",period,shift);

//bool variabilityBool1 = ((s1!=SIGMAVARIABILITY::SIGMA_MEAN)&&(s1!=SIGMAVARIABILITY::SIGMA_HALF)&&(s1!=SIGMAVARIABILITY::SIGMA_1));
//bool variabilityBool2 = ((s1>SIGMAVARIABILITY::SIGMA_1)&&(s1<=SIGMAVARIABILITY::SIGMA_REST));
//bool variabilityBool = (variabilityBool1 && variabilityBool2);

//double variabilityVal = util.getSigVariabilityBool(s1,label);
   double variabilityVal = util.getSigVarBool(s1);
//Print("Variablity value:: "+ variabilityVal);
   bool flatBool = (((ratio >= 0.7)&&(ratio <= 1.3))||((ratioDown >= 0.7)&&(ratioDown <= 1.3)));

   const double POSVAR = 1.314;
   const double NEGVAR = -1.314;

   bool variabilityBool = ((variabilityVal!=0) && ((variabilityVal == POSVAR) || (variabilityVal== NEGVAR)));
   bool variabilityPosBool = ((variabilityVal!=0) && (variabilityVal==POSVAR));
   bool variabilityNegBool = ((variabilityVal!=0) && (variabilityVal==NEGVAR));

   bool noVarBool = (variabilityVal==0);

//Print("Up: "+up+" Down: "+down+" ratio: "+ratio+" Ratioup: "+ratioUp+" ratioDown: "+ratioDown + " STD of signal: " + util.getSigString(s1));
//   Print("["+label+"] up: "+up+" down: "+down+" ratio: "+ratio+" ratioDown: "+ratioDown+" sig[shift]"+sig[shift]+" sig[period]"+sig[period]+ " variabilityBool: "+variabilityBool);

   if(flatBool) {
      trendSig = SANTREND::FLAT;
      return trendSig;
   } else if((variabilityBool)&&(((ratio < slopeRatio)&&(ratioDown < slopeRatio))||flatBool)) {
      trendSig = SANTREND::FLAT;
      return trendSig;
   } else if(variabilityPosBool &&(ratio >= slopeRatio)) {
      trendSig = SANTREND::UP;
      return trendSig;
   } else if(variabilityNegBool&&(ratioDown >= slopeRatio)) {
      trendSig = SANTREND::DOWN;
      return trendSig;
   } else if((noVarBool)  && (ratioDown >= slopeRatio)) {
      trendSig = SANTREND::DOWN;
      return trendSig;
   } else if((noVarBool) && (ratio >= slopeRatio)) {
      trendSig = SANTREND::UP;
      return trendSig;
   } else if((noVarBool) && ((ratio >= 0.7)&&(ratio <= 1.3))) {
      trendSig = SANTREND::FLAT;
      return trendSig;
   } else if((noVarBool) && (ratio < slopeRatio) && (ratio > ratioDown) && !flatBool) {
      trendSig = SANTREND::FLATUP;
      return trendSig;
   } else if((noVarBool) && (ratioDown < slopeRatio)&& (ratioDown > ratio) && !flatBool) {
      trendSig = SANTREND::FLATDOWN;
      return trendSig;
   }

   return trendSig;
};


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TRENDSTRUCT SanSignals::trendVolRatioSIG(const double &sig[],const double &vol[],const int period=10,const int shift=1) {
   TRENDSTRUCT ts;

   double up=0;
   double flat=0;
   double down=0;
   double ratio=0;
   double ratioUp=0;
   double ratioDown=0;

   for(int i=shift; i<=period; i++) {
      if((sig[i]*vol[i])>(sig[period]*vol[period]))
         up++;
      if((sig[i]*vol[i])<(sig[period]*vol[period]))
         down++;
      if((sig[i]*vol[i])==(sig[period]*vol[period]))
         flat++;
   }

   if((up>0)&&(down>0)) {
      ratio = (up/down);
      ratioUp = (up/down);
      ratioDown = (down/up);
   } else if((up==0)&&(down>0)) {
      ratio = 0;
      ratioUp = 0;
      ratioDown = period;
   } else if((up>0)&&(down==0)) {
      ratio = period;
      ratioUp=period;
      ratioDown=0;
   } else if((up==0)&&(down==0)) {
      ratio = 0;
      ratioUp=0;
      ratioDown=0;
   }



   SIGMAVARIABILITY s1 = stdDevSIG(sig,"",period,shift);
   bool validSigmaRange = ((s1!=SIGMAVARIABILITY::SIGMA_NULL)&&(s1!=SIGMAVARIABILITY::SIGMA_MEAN)&&(s1!=SIGMAVARIABILITY::SIGMAPOS_MEAN)&&(s1!=SIGMAVARIABILITY::SIGMANEG_MEAN)&&(s1!=SIGMAVARIABILITY::SIGMAPOS_HALF)&&(s1!=SIGMAVARIABILITY::SIGMANEG_HALF));
//Print("Up: "+up+" Down: "+down+" ratio: "+ratio+" Ratioup: "+ratioUp+" ratioDown: "+ratioDown + " STD of signal: " + util.getSigString(s1));

   if(validSigmaRange) {
      if((ratioUp >= 3)) {
         ts.closeTrendSIG = SANTREND::UP;
         ts.trendStrengthSIG = SANTRENDSTRENGTH::SUPERHIGH;
         return ts;
      } else if(ratioDown>=3) {
         ts.closeTrendSIG = SANTREND::DOWN;
         ts.trendStrengthSIG = SANTRENDSTRENGTH::SUPERHIGH;
         return ts;
      } else if(ratioUp >= 2) {
         ts.closeTrendSIG = SANTREND::UP;
         ts.trendStrengthSIG = SANTRENDSTRENGTH::HIGH;
         return ts;
      } else if(ratioDown >= 2) {
         ts.closeTrendSIG = SANTREND::DOWN;
         ts.trendStrengthSIG = SANTRENDSTRENGTH::HIGH;
         return ts;
      }

   } else if((s1==SIGMAVARIABILITY::SIGMAPOS_HALF)||(s1==SIGMAVARIABILITY::SIGMANEG_HALF)||(s1==SIGMAVARIABILITY::SIGMA_MEAN)||(s1==SIGMAVARIABILITY::SIGMAPOS_MEAN)||(s1==SIGMAVARIABILITY::SIGMANEG_MEAN)) {
      if((ratio >= 0.9)&&(ratio <= 1.1)) {
         ts.closeTrendSIG = SANTREND::FLAT;
         ts.trendStrengthSIG = SANTRENDSTRENGTH::SUPERHIGH;
         return ts;
      } else if((ratio >= 0.8)&&(ratio <= 1.2)) {
         ts.closeTrendSIG = SANTREND::FLAT;
         ts.trendStrengthSIG = SANTRENDSTRENGTH::HIGH;
         return ts;
      } else if((ratio >= 0.7)&&(ratio <= 1.3)) {
         ts.closeTrendSIG = SANTREND::FLAT;
         ts.trendStrengthSIG = SANTRENDSTRENGTH::NORMAL;
         return ts;
      }
   }

   return ts;
};



//+------------------------------------------------------------------+
//|                          NEW ONE                                        |
//+------------------------------------------------------------------+
SANTREND SanSignals::trendSlopeSIG(const double &data[],string label="",const int period=10,const int shift=1) {
   double slope[];
   double x[];
   ArrayResize(slope,(period+1));
   ArrayResize(x,(period+1));

//  double ZSCORERANGE_TRADE = 1.7;
//double ZSCORERANGE_TRADE = 2.0;
   double ZSCORERANGE_TRADE = 5.0;

//   double ZSCORERANGE_FLAT = 0.5;
   double ZSCORERANGE_FLAT = 0.1;
   double FLATNESS = 0.001;

   double stdDev=EMPTY_VALUE;
   double mean=EMPTY_VALUE;
   double zScore = EMPTY_VALUE;
   double range = data[ArrayMaximum(data)]-data[ArrayMinimum(data)];
   for(int k=(period+1),i=0; k>=shift; k--,i++) {
      x[i]=k;
   }
   for(int i=shift,j=0; i<=period; i++,j++) {
      slope[j]= ((x[i]-shift)!=0)?((data[i]-data[period])/(x[i]-shift)):0;
   }

   stdDev = stats.stdDev(slope);
   mean = stats.mean(slope);
   zScore = stats.zScore(slope[0],mean,stdDev);
//   DataTransport dt = stats.scatterPlotSlope(data);


   bool zScoreFlatRange = ((zScore>=(-1*ZSCORERANGE_FLAT))&&(zScore<=(1*ZSCORERANGE_FLAT)));
   bool zScoreTradeRange = (!zScoreFlatRange && (zScore>=(-1*ZSCORERANGE_TRADE))&&(zScore<=(1*ZSCORERANGE_TRADE)));


//bool down = ((slope[0]<0) && (mean<0) && zScoreTradeRange);
//bool up = ((slope[0]>0) && (mean>0) && zScoreTradeRange);

   bool down = ((slope[0]<0) && zScoreTradeRange);
   bool up = ((slope[0]>0)&& zScoreTradeRange);


   bool flat1 = (((mean==0)||(slope[0]==0)||((mean>=-0.001)&&(mean<=0.001))||((slope[0]>=-0.001)&&(slope[0]<=0.001))) && zScoreFlatRange);
//   bool flat2 = (((dt.matrixD[0]==0)||((dt.matrixD[0]>=-0.001)&&(dt.matrixD[0]<=0.001))) && zScoreFlatRange);
//   bool flat3 = ((mean==0)||(slope[0]==0)||(dt.matrixD[0]==0)|| zScoreFlatRange);
   bool flat3 = ((mean==0)||(slope[0]==0)|| zScoreFlatRange);

//   Print("["+label+"]: Trend slope: zScore: "+zScore+" stdDev: "+stdDev + " flat: "+ zScoreFlatRange+" trade: "+zScoreTradeRange +" up: "+up+" down: "+down);

//bool flat1 = ((mean==0)||(slope[0]==0)||zScoreFlatRange);
//bool flat2 = ((dt.matrixD[0]==0) || zScoreFlatRange);
//   Print(" Up: "+up+" Down: "+down+" Flat1: "+flat1+" flat2: "+ flat2);

// Print("Slope Trend: "+label+": " +slope[0]+" SLOPE MEAN: "+mean+" stdDev: "+stdDev+" zScore: "+zScore+" up: "+up+" down: "+down+" flat: "+(flat1||flat2));
//Print("Slope Trend: "+label+": " +slope[0]+" SLOPE MEAN: "+mean+" dt: slope1: "+dt.matrixD[0]+" dt: slope2: "+dt.matrixD[2]+" zScore: "+zScore);
//Print("Slope Trend: "+label+": " +slope[0]+" SLOPE MEAN: "+mean+" scatterplot slope: "+dt.matrixD[0]+" zScore: "+zScore+" zFlat: "+zScoreFlatRange+" zTrade: "+zScoreTradeRange+" up: "+up+" down: "+down);

   if(flat3)
      //   if(flat1 || flat2)
   {
      return SANTREND::FLAT;
   } else if(up) {
      return SANTREND::UP;
   } else if(down) {
      return SANTREND::DOWN;
   }



   return SANTREND::NOTREND;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL SanSignals::tradeVolVarSignal(const SAN_SIGNAL volSIG,const SIGMAVARIABILITY varFast,const SIGMAVARIABILITY varMedium,const SIGMAVARIABILITY varSlow,const SIGMAVARIABILITY varVerySlow=SIGMAVARIABILITY::SIGMA_NULL) {

   SAN_SIGNAL trade = SAN_SIGNAL::NOTRADE;

   double varFastVal = util.getSigVarBool(varFast);
   bool varFastBool = ((varFastVal!=0) && ((varFastVal==1.314)||(varFastVal==-1.314)));
   bool varFastPosBool = ((varFastVal!=0) && (varFastVal==1.314));
   bool varFastNegBool = ((varFastVal!=0) && (varFastVal==-1.314));

   double varMediumVal = util.getSigVarBool(varMedium);
   bool varMediumBool = ((varMediumVal!=0) && ((varMediumVal==1.314)||(varMediumVal==-1.314)));
   bool varMediumPosBool = ((varMediumVal!=0) && (varMediumVal==1.314));
   bool varMediumNegBool = ((varMediumVal!=0) && (varMediumVal==-1.314));


   double varSlowVal = util.getSigVarBool(varSlow);
   bool varSlowBool = ((varSlowVal!=0) && ((varSlowVal==1.314)||(varSlowVal==-1.314)));
   bool varSlowPosBool = ((varSlowVal!=0) && (varSlowVal==1.314));
   bool varSlowNegBool = ((varSlowVal!=0) && (varSlowVal==-1.314));


//bool flatBool = ((varFastVal==0)&&(varMediumVal==0)&&(varSlowVal==0));
   bool flatBool = ((varSlowVal==0));
   bool varBool = (varFastBool&&varMediumBool&&varSlowBool);
   bool varPosBool = (varBool && (varFastPosBool&&varMediumPosBool&&varSlowPosBool));
   bool varNegBool = (varBool && (varFastNegBool&&varMediumNegBool&&varSlowNegBool));

   if(varVerySlow!=SIGMAVARIABILITY::SIGMA_NULL) {
      flatBool = (util.getSigVarBool(varVerySlow)==0);
      varBool = (varBool&&((util.getSigVarBool(varVerySlow)!=0)&&((util.getSigVarBool(varVerySlow)==1.314)||(util.getSigVarBool(varVerySlow)==-1.314))));
      varPosBool = (varPosBool && ((util.getSigVarBool(varVerySlow)!=0)&&(util.getSigVarBool(varVerySlow)==1.314)));
      varNegBool = (varNegBool && ((util.getSigVarBool(varVerySlow)!=0)&&(util.getSigVarBool(varVerySlow)==-1.314)));
   }

   if((volSIG==SAN_SIGNAL::NOTRADE)||(volSIG==SAN_SIGNAL::REVERSETRADE)||(volSIG==SAN_SIGNAL::CLOSE))
      return volSIG;
   if(flatBool)
      return SAN_SIGNAL::SIDEWAYS;
   if((volSIG==SAN_SIGNAL::TRADE) && varBool && varPosBool)
      return SAN_SIGNAL::BUY;
   if((volSIG==SAN_SIGNAL::TRADE) && varBool && varNegBool)
      return SAN_SIGNAL::SELL;
   return trade;
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL        trendSIG(SANTREND tr1, SANTREND tr2, SANTREND tr3, SANTREND tr4=EMPTY, SANTREND tr5=EMPTY, SANTREND tr6=EMPTY) {
   //Print("[TRSIGIN] tr1: "+util.getSigString(tr1)+" tr2: "+util.getSigString(tr2)+" tr3: "+util.getSigString(tr3)+" tr4: "+util.getSigString(tr4)+" tr5: "+util.getSigString(tr5)+" tr6: "+util.getSigString(tr6));

   if((tr1==SANTREND::NOTREND)
         ||(tr2==SANTREND::NOTREND)
         ||(tr3==SANTREND::NOTREND)
         ||(tr4==SANTREND::NOTREND)
         ||(tr5==SANTREND::NOTREND)
         ||(tr6==SANTREND::NOTREND)
     ) {
      return SAN_SIGNAL::NOSIG;
   }

   if(
      (
         ((tr1==SANTREND::FLAT)||(tr1==SANTREND::FLATUP)||(tr1==SANTREND::FLATDOWN))
         &&((tr2==SANTREND::FLAT)||(tr2==SANTREND::FLATUP)||(tr2==SANTREND::FLATDOWN))
      )
      ||((tr3==SANTREND::FLAT)||(tr3==SANTREND::FLATUP)||(tr3==SANTREND::FLATDOWN))
      ||((tr4==SANTREND::FLAT)||(tr4==SANTREND::FLATUP)||(tr4==SANTREND::FLATDOWN))
      ||((tr5==SANTREND::FLAT)||(tr5==SANTREND::FLATUP)||(tr5==SANTREND::FLATDOWN))
      ||((tr6==SANTREND::FLAT)||(tr6==SANTREND::FLATUP)||(tr6==SANTREND::FLATDOWN))
   ) {
      return SAN_SIGNAL::SIDEWAYS;
   }

   if(
      ((tr6!=EMPTY)&&(tr6!=SANTREND::NOTREND)&&(tr1!=SANTREND::NOTREND)&&(tr2!=SANTREND::NOTREND))
      &&(
         (util.oppSignal(util.convTrendToSig(tr1),util.convTrendToSig(tr6)))
         ||(util.oppSignal(util.convTrendToSig(tr2),util.convTrendToSig(tr6)))
      )
   ) {
      return SAN_SIGNAL::CLOSE;
   } else if(
      ((tr5!=EMPTY)&&(tr5!=SANTREND::NOTREND)&&(tr1!=SANTREND::NOTREND)&&(tr2!=SANTREND::NOTREND))
      &&(
         (util.oppSignal(util.convTrendToSig(tr1),util.convTrendToSig(tr5)))
         ||(util.oppSignal(util.convTrendToSig(tr2),util.convTrendToSig(tr5)))
      )
   ) {
      return SAN_SIGNAL::CLOSE;
   } else if(
      ((tr4!=EMPTY)&&(tr4!=SANTREND::NOTREND)&&(tr1!=SANTREND::NOTREND)&&(tr2!=SANTREND::NOTREND))
      &&(
         (util.oppSignal(util.convTrendToSig(tr1),util.convTrendToSig(tr4)))
         ||(util.oppSignal(util.convTrendToSig(tr2),util.convTrendToSig(tr4)))
      )
   ) {
      return SAN_SIGNAL::CLOSE;
   } else if(
      ((tr3!=SANTREND::NOTREND)&&(tr1!=SANTREND::NOTREND)&&(tr2!=SANTREND::NOTREND))
      &&(
         (util.oppSignal(util.convTrendToSig(tr1),util.convTrendToSig(tr3)))
         &&(util.oppSignal(util.convTrendToSig(tr2),util.convTrendToSig(tr3)))
      )
   ) {
      return SAN_SIGNAL::CLOSE;
   } else if(
      ((tr1!=SANTREND::NOTREND)&&(tr2!=SANTREND::NOTREND))
      &&(util.oppSignal(util.convTrendToSig(tr1),util.convTrendToSig(tr2)))
   ) {
      return SAN_SIGNAL::CLOSE;
   }

   if((tr1!=SANTREND::NOTREND)
         &&(
            ((tr6!=EMPTY)&&(tr5!=EMPTY)&&(tr4!=EMPTY)&&(tr1==tr2)&&(tr2==tr3)&&(tr3==tr4)&&(tr4==tr5)&&(tr5==tr6))
            ||((tr6==EMPTY)&&(tr5!=EMPTY)&&(tr4!=EMPTY)&&(tr1==tr2)&&(tr2==tr3)&&(tr3==tr4)&&(tr4==tr5))
            ||((tr5==EMPTY)&&(tr4!=EMPTY)&&(tr1==tr2)&&(tr2==tr3)&&(tr3==tr4))
            ||((tr5==EMPTY)&&(tr4==EMPTY)&&(tr1==tr2)&&(tr2==tr3))
         )
     ) {
      return util.convTrendToSig(tr1);
   }
   //else
   //  {
   //   return SAN_SIGNAL::CLOSE;
   //  }

   return SAN_SIGNAL::NOSIG;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL SanSignals::tradeSignal(const double ciStd,const double ciMfi, const double &atr[], const double ciAdxMain,const double ciAdxPlus,const double ciAdxMinus) {
   double currspread = (int)MarketInfo(_Symbol,MODE_SPREAD);
   SAN_SIGNAL trade = SAN_SIGNAL::NOTRADE;
   SAN_SIGNAL adxsig = SAN_SIGNAL::NOSIG;
   SANTRENDSTRENGTH atrsig = SANTRENDSTRENGTH::POOR;

   adxsig = adxSIG(ciAdxMain,ciAdxPlus,ciAdxMinus);
   atrsig = atrSIG(atr,10);

   bool spreadB = (currspread < tl.spreadLimit);
   bool stdDevB = (ciStd > tl.stdDevLimit);
   bool mfiB = (ciMfi > tl.mfiLowerLimit);
   bool adxB = ((adxsig==SAN_SIGNAL::BUY)||(adxsig==SAN_SIGNAL::SELL));
   bool atrB = ((atrsig==SANTRENDSTRENGTH::NORMAL)||(atrsig==SANTRENDSTRENGTH::HIGH));



//   bool indicatorBool = ((currspread < tl.spreadLimit) &&(ciStd > tl.stdDevLimit) && (ciMfi > tl.mfiLimit)&&((adxsig==SAN_SIGNAL::BUY)||(adxsig==SAN_SIGNAL::SELL))&&(atrsig==SAN_SIGNAL::TRADE));
   bool indicatorBool = (spreadB && stdDevB && mfiB && adxB && atrB);

   if(indicatorBool)
      trade = SAN_SIGNAL::TRADE;
   return trade;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL SanSignals::mfiSIG(const double &sig[],SANTREND tradeTrend = SANTREND::NOTREND,const int period=10,const int shift=1) {

   SANTREND mfiTrend = SANTREND::NOTREND;
   SANTREND scatterMfiTrend = SANTREND::NOTREND;

   SAN_SIGNAL mfiTrendSIG = SAN_SIGNAL::NOSIG;
   SAN_SIGNAL mfISIG = SAN_SIGNAL::NOSIG;

//mfiTrend = trendSlopeSIG(sig,"MFI",period);
// mfiTrend = trendSlopeSIG(sig,"MFI",period);
//  scatterMfiTrend = trendScatterPlotSIG(sig,"Scatter-MFI",0.02,5);
   mfiTrend = acfStdSIG(sig,5,shift).closeTrendSIG;
//mfiTrendSIG = util.convTrendToSig(mfiTrend);




//bool sellBool1 = ((((mfiTrend==SANTREND::FLAT)||(mfiTrend==SANTREND::DOWN))&&(sig[shift]<=tl.mfiLowerLimit))||(mfiTrend==SANTREND::DOWN));
//bool buyBool1 = ((((mfiTrend==SANTREND::FLAT)||(mfiTrend==SANTREND::UP))&&(sig[shift]>=tl.mfiUpperLimit))||(mfiTrend==SANTREND::UP));

   bool mfiRegion = ((sig[shift]<=tl.mfiLowerLimit)||(sig[shift]>=tl.mfiUpperLimit));
   bool notMfiRegion = ((sig[shift]>tl.mfiLowerLimit)&&(sig[shift]<tl.mfiUpperLimit));

   bool mfiFlatBool = (mfiTrend==SANTREND::FLAT);
   bool sellBool1 = (mfiTrend==SANTREND::DOWN);
   bool sellBool2 = ((sig[shift]<=tl.mfiLowerLimit)&&(mfiTrend==SANTREND::DOWN));
   bool sellBool3 = ((sig[shift]>=tl.mfiUpperLimit)&&(mfiTrend==SANTREND::DOWN));
   bool sellBool4 = ((sig[shift]<=tl.mfiLowerLimit)&& mfiFlatBool);

   bool buyBool1 = (mfiTrend==SANTREND::UP);
   bool buyBool2 = ((sig[shift]>=tl.mfiUpperLimit)&&(mfiTrend==SANTREND::UP));
   bool buyBool3 = ((sig[shift]<=tl.mfiLowerLimit)&&(mfiTrend==SANTREND::UP));
   bool buyBool4 = ((sig[shift]>=tl.mfiUpperLimit)&& mfiFlatBool);

   bool buyBool5 = (buyBool3 && (tradeTrend==SANTREND::DOWN));
   bool sellBool5 = (sellBool3 && (tradeTrend==SANTREND::UP));

   bool buyBool6 = ((buyBool1||buyBool2||buyBool4) && (tradeTrend==SANTREND::UP));
   bool sellBool6 = ((sellBool1||sellBool2||sellBool4) && (tradeTrend==SANTREND::DOWN));

//bool buyBool7 = (((mfiRegion && buyBool1)||(buyBool4)) || (notMfiRegion && (buyBool1||mfiFlatBool) && (tradeTrend==SANTREND::UP)));
//bool sellBool7 = (((mfiRegion && sellBool1)||(sellBool4)) || (notMfiRegion && (sellBool1||mfiFlatBool) && (tradeTrend==SANTREND::DOWN)));
   bool buyBool7 = (((mfiRegion && buyBool1)||(buyBool4)) || (notMfiRegion && (buyBool1) && (tradeTrend==SANTREND::UP)));
   bool sellBool7 = (((mfiRegion && sellBool1)||(sellBool4)) || (notMfiRegion && (sellBool1) && (tradeTrend==SANTREND::DOWN)));

//bool buyBool = (buyBool5||buyBool6);
//bool sellBool = (sellBool5||sellBool6);
   bool buyBool = (buyBool7);
   bool sellBool = (sellBool7);
   bool flatBool = (notMfiRegion && mfiFlatBool);

   if(flatBool) {
      mfISIG = SAN_SIGNAL::SIDEWAYS;
   } else if(buyBool) {
      mfISIG = SAN_SIGNAL::BUY;
   } else if(sellBool) {
      mfISIG = SAN_SIGNAL::SELL;
   }

//   Print("Mfi Trend : "+util.getSigString(mfiTrend)+" scatter: "+util.getSigString(scatterMfiTrend)+" tradeTrend: "+util.getSigString(util.convTrendToSig(tradeTrend))+" Mfi Sig: "+util.getSigString(mfISIG)+" BUY:"+buyBool+" SELL:"+sellBool);

//Print("BUY: 1: "+buyBool1+" 2: "+ buyBool2+" 3: "+buyBool3+" 4: "+ buyBool4+" 5: "+buyBool5+" 6: "+buyBool6+" 7: "+buyBool7+" buyBool: "+ buyBool);
//Print("SELL: 1: "+sellBool1+" 2: "+ sellBool2+" 3: "+sellBool3+" 4: "+ sellBool4+" 5: "+sellBool5+" 6: "+sellBool6+" 7: "+sellBool7+" sellBool: "+ sellBool);
   return mfISIG;
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL  SanSignals::rsiSIG(const double &sig[],const int period=10,const int shift=1) {
//Print("RSISIG: "+ sig[shift]+" +2: "+sig[shift+10]+" +4: "+sig[shift+15]);

   if(sig[shift]>=70)
      return SAN_SIGNAL::BUY;
   if(sig[shift]<=30)
      return SAN_SIGNAL::SELL;

   if((sig[shift]>sig[shift+2])&&(sig[shift]>sig[shift+4])&&(sig[shift]>=50)) {
      return SAN_SIGNAL::BUY;
   }
   if((sig[shift]<sig[shift+2])&&(sig[shift]<sig[shift+4])&&(sig[shift]<50)) {
      return SAN_SIGNAL::SELL;
   }

   return SAN_SIGNAL::NOSIG;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL  SanSignals::fastSigSlowTrendSIG(
   const SAN_SIGNAL &fastSig,
   const SANTREND &baseTrend
) {
   if((fastSig!=SAN_SIGNAL::NOSIG)&&(fastSig!=SAN_SIGNAL::SIDEWAYS)) {
      if(fastSig==util.convTrendToSig(baseTrend)) {
         return fastSig;
      } else if((util.oppSignal(fastSig,util.convTrendToSig(baseTrend)))||(baseTrend==SANTREND::FLAT)) {
         return SAN_SIGNAL::CLOSE;
      }
   }


   return SAN_SIGNAL::NOSIG;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL  SanSignals::dominantTrendSIG(
   const SANSIGNALS &ss,
   const HSIG &hSIG
) {
   SAN_SIGNAL dominantSIG = SAN_SIGNAL::NOSIG;


   bool domTrendBool = ((hSIG.dominantTrendSIG==SAN_SIGNAL::BUY)||(hSIG.dominantTrendSIG==SAN_SIGNAL::SELL));
   bool domTrendCombinationBool = ((hSIG.dominantTrendSIG==hSIG.slopeFastSIG)
                                   ||(hSIG.dominantTrendSIG==hSIG.mainFastSIG)
                                   ||(hSIG.dominantTrendSIG==hSIG.rsiFastSIG)
                                   ||(hSIG.dominantTrendSIG==ss.candleVol120SIG)
                                   ||(hSIG.dominantTrendSIG==ss.slopeVarSIG)
                                   ||((hSIG.dominantTrendSIG==ss.ima514SIG)&&(hSIG.dominantTrendSIG==ss.ima1430SIG))
                                   ||((hSIG.dominantTrendSIG==ss.rsiSIG)&&(hSIG.dominantTrendSIG==ss.ima1430SIG)));

   bool fastSIGBool = (ss.fastIma1430SIG!=SAN_SIGNAL::NOSIG)
                      &&(ss.fastIma1430SIG==ss.fastIma30120SIG)
                      &&(ss.fastIma1430SIG == util.convTrendToSig(ss.trendRatio14SIG))
                      &&(ss.fastIma1430SIG == util.convTrendToSig(ss.trendRatio30SIG))
                      &&(ss.fastIma30120SIG == util.convTrendToSig(ss.trendRatio30SIG))
                      &&(ss.fastIma30120SIG == util.convTrendToSig(ss.trendRatio120SIG));

   bool cPSIGBool = (ss.cpScatterSIG!=SANTREND::NOTREND)
                    &&(ss.cpScatterSIG!=SANTREND::FLAT)
                    &&(ss.cpScatterSIG==ss.trendRatio30SIG)
                    &&(ss.cpScatterSIG==ss.trendRatio120SIG)
                    &&(util.convTrendToSig(ss.cpScatterSIG)==ss.slopeVarSIG)
                    &&(util.convTrendToSig(ss.cpScatterSIG)==ss.candleVol120SIG)
                    &&(util.convTrendToSig(ss.cpScatterSIG)==ss.fastIma30120SIG);


//   Print("fastSIGBOOL: "+fastSIGBool);
//   bool cpOppTrendBool = (util.oppSignal(slowSIG.dominantTrendSIG,util.convTrendToSig(slowSIG.cp120SIG)));
   bool closeOnReverseBool = ((ss.volSIG==SAN_SIGNAL::REVERSETRADE)||(ss.volSIG==SAN_SIGNAL::NOTRADE)||(ss.volSIG==SAN_SIGNAL::CLOSE));
   bool noReverseBool = ((ss.volSIG!=SAN_SIGNAL::REVERSETRADE)&&(ss.volSIG!=SAN_SIGNAL::NOTRADE)&&(ss.volSIG!=SAN_SIGNAL::CLOSE));
   bool sideWaysBool = (
                          (ss.candleVol120SIG==SAN_SIGNAL::SIDEWAYS)
                          ||(ss.slopeVarSIG==SAN_SIGNAL::SIDEWAYS)
                       );
   bool flatTrendRatioBool = ((ss.trendRatioSIG==SANTREND::FLAT)||(ss.trendRatioSIG==SANTREND::FLATUP)||(ss.trendRatioSIG==SANTREND::FLATDOWN));
   bool flatCPBool = (
                        (ss.cpScatterSIG==SANTREND::FLAT)
                        ||(ss.cpScatterSIG==SANTREND::FLATUP)
                        ||(ss.cpScatterSIG==SANTREND::FLATDOWN)
                     );
   bool flatTrendBool =(hSIG.dominantTrendSIG==SAN_SIGNAL::SIDEWAYS);


   bool flatBool = (
                      //((hSIG.mktType==MKTTYP::MKTFLAT)&&(hSIG.fastSIG!=SAN_SIGNAL::CLOSE))
                      //&&
                      (
                         (hSIG.mktType==MKTTYP::MKTFLAT)
                         ||(hSIG.fastSIG==SAN_SIGNAL::SIDEWAYS)
                         ||(sideWaysBool||flatTrendRatioBool||flatCPBool||flatTrendBool)
                      )
                   )
                   ;

// Print("[MKT TYPE]:"+util.getSigString(hSIG.mktType));
   if(flatBool)
      Print("[FLAT BOOL] Signaled: sideWays:"+sideWaysBool+" TrRatioFlat: "+ flatTrendRatioBool+" cPFlat: "+flatCPBool
            +" TrendSIG: "+flatTrendBool+" SigFlat: "+(hSIG.fastSIG==SAN_SIGNAL::SIDEWAYS)
            +" Tr1430120"+(hSIG.trend_14_30_120_SIG==SAN_SIGNAL::SIDEWAYS)+" Mkt Flat: "+(hSIG.mktType==MKTTYP::MKTFLAT));

//   bool closeBool = ((hSIG.domTrIMA==SAN_SIGNAL::CLOSE)||(hSIG.domTrIMA==SAN_SIGNAL::SIDEWAYS)||(hSIG.domTrIMA==SAN_SIGNAL::NOSIG));
//   bool closeBool = ((hSIG.dominant120SIG==SAN_SIGNAL::CLOSE)||(hSIG.dominant120SIG==SAN_SIGNAL::SIDEWAYS)||(hSIG.dominant120SIG==SAN_SIGNAL::NOSIG));
//   bool closeBool = ((hSIG.dominantTrendSIG==SAN_SIGNAL::CLOSE)||(hSIG.dominantTrendSIG==SAN_SIGNAL::SIDEWAYS));
//   bool openBool = ((hSIG.mktType==MKTTYP::MKTTR)&&((hSIG.fastSIG==SAN_SIGNAL::BUY)||(hSIG.fastSIG==SAN_SIGNAL::SELL)));
   bool openBool = ((hSIG.mktType==MKTTYP::MKTTR)&&((hSIG.openSIG==SAN_SIGNAL::BUY)||(hSIG.openSIG==SAN_SIGNAL::SELL)));
   bool closeBool = (
                       (hSIG.mktType==MKTTYP::MKTCLOSE)
                       ||(hSIG.closeSIG==SAN_SIGNAL::CLOSE)
//     ||(hSIG.fastSIG==SAN_SIGNAL::CLOSE)
                    );


//||(hSIG.cpSlopeVarFastSIG==SAN_SIGNAL::CLOSE)||(hSIG.cpSlopeVarFastSIG==SAN_SIGNAL::SIDEWAYS)||(hSIG.cpSlopeVarFastSIG==SAN_SIGNAL::NOSIG)
//||(hSIG.dominantTrendCPSIG==SAN_SIGNAL::CLOSE)||(hSIG.dominantTrendCPSIG==SAN_SIGNAL::SIDEWAYS)||(hSIG.dominantTrendCPSIG==SAN_SIGNAL::NOSIG)
//;

//if(noReverseBool && (hSIG.domTrIMA!=SAN_SIGNAL::NOSIG)&&(hSIG.domTrIMA!=SAN_SIGNAL::SIDEWAYS)&&(hSIG.domTrIMA!=SAN_SIGNAL::CLOSE))
//  {
//   Print("[domSIG-BLOC]:  domTrIMA: OPEN");
//   dominantSIG = hSIG.domTrIMA;
//  }
//else
//   if(noReverseBool && (hSIG.cpSlopeVarFastSIG!=SAN_SIGNAL::NOSIG)&&(hSIG.cpSlopeVarFastSIG!=SAN_SIGNAL::CLOSE))
//     {
//      Print("[domSIG-BLOC]:  cpSlopeVarFastSIG: OPEN");
//      dominantSIG = hSIG.cpSlopeVarFastSIG;
//     }
//   else
//      if(noReverseBool && (hSIG.dominantTrendCPSIG!=SAN_SIGNAL::NOSIG)&&(hSIG.dominantTrendCPSIG!=SAN_SIGNAL::CLOSE))
//        {
//         Print("[domSIG-BLOC]:  dominantTrendCPSIG: OPEN");
//         dominantSIG = hSIG.dominantTrendCPSIG;
//        } else
//if(noReverseBool && (hSIG.dominant120SIG!=SAN_SIGNAL::NOSIG)&&(hSIG.dominant120SIG!=SAN_SIGNAL::NOSIG)&&(hSIG.dominant120SIG!=SAN_SIGNAL::CLOSE))
//  {
//   Print("[domSIG-BLOC]:  dominant120SIG: OPEN");
//   dominantSIG = hSIG.dominant120SIG;
//  } else

//     if(noReverseBool && (hSIG.dominantTrendSIG!=SAN_SIGNAL::NOSIG)&&(hSIG.dominantTrendSIG!=SAN_SIGNAL::SIDEWAYS)&&(hSIG.dominantTrendSIG!=SAN_SIGNAL::CLOSE))
//if((hSIG.dominantTrendSIG!=SAN_SIGNAL::NOSIG)&&(hSIG.dominantTrendSIG!=SAN_SIGNAL::SIDEWAYS)&&(hSIG.dominantTrendSIG!=SAN_SIGNAL::CLOSE))
//  {
//   // Print("[domSIG-BLOC]:  dominantTrendSIG: OPEN");
//   //dominantSIG = hSIG.dominantTrendSIG;
//   dominantSIG = util.flipSig(hSIG.dominantTrendSIG);
//  }
//   if((hSIG.mktType==MKTTYP::MKTTR)&&(hSIG.fastSIG!=SAN_SIGNAL::NOSIG)&&(hSIG.fastSIG!=SAN_SIGNAL::SIDEWAYS)&&(hSIG.fastSIG!=SAN_SIGNAL::CLOSE))
//   if((hSIG.fastSIG!=SAN_SIGNAL::NOSIG)&&(hSIG.fastSIG!=SAN_SIGNAL::SIDEWAYS)&&(hSIG.fastSIG!=SAN_SIGNAL::CLOSE)) {
   if(openBool) {
      dominantSIG = hSIG.openSIG;
   }  else if(closeBool) {
      dominantSIG = SAN_SIGNAL::CLOSE;
   } else if(flatBool) {
      dominantSIG = SAN_SIGNAL::SIDEWAYS;
   }



//   bool closeBool = (hSIG.domTrIMA==SAN_SIGNAL::CLOSE)
//                    ||(hSIG.dominantTrendSIG==SAN_SIGNAL::CLOSE)
//                    ||(hSIG.dominant240SIG==SAN_SIGNAL::CLOSE)
//                    ||(hSIG.dominantTrendIma240SIG==SAN_SIGNAL::CLOSE)
//                    ||(hSIG.dominant120SIG==SAN_SIGNAL::CLOSE)
//                    ||(hSIG.dominantTrendIma120SIG==SAN_SIGNAL::CLOSE)
//                    ||(hSIG.dominantTrendCPSIG==SAN_SIGNAL::CLOSE)
//                    ||(hSIG.cpSlopeVarFastSIG==SAN_SIGNAL::CLOSE);
////
//
//   if(noReverseBool && (hSIG.domTrIMA!=SAN_SIGNAL::NOSIG)&&(hSIG.domTrIMA!=SAN_SIGNAL::CLOSE))
//      //   if(noReverseBool && (hSIG.domTrIMA!=SAN_SIGNAL::NOSIG))
//     {
//      Print("[domSIG-BLOC]:  domTrIMA: OPEN");
//      dominantSIG = hSIG.domTrIMA;
//     }
//   else
//      if(noReverseBool && (hSIG.cpSlopeVarFastSIG!=SAN_SIGNAL::NOSIG)&&(hSIG.cpSlopeVarFastSIG!=SAN_SIGNAL::CLOSE))
//        {
//         Print("[domSIG-BLOC]:  cpSlopeVarFastSIG: OPEN");
//         dominantSIG = hSIG.cpSlopeVarFastSIG;
//        }
//      else
//         if(noReverseBool && (hSIG.dominantTrendCPSIG!=SAN_SIGNAL::NOSIG))
//           {
//            Print("[domSIG-BLOC]:  dominantTrendCPSIG: OPEN");
//            dominantSIG = hSIG.dominantTrendCPSIG;
//           }
//         else
//            if(noReverseBool && (hSIG.dominantTrendSIG!=SAN_SIGNAL::NOSIG)&&(hSIG.dominantTrendSIG!=SAN_SIGNAL::CLOSE))
//              {
//               Print("[domSIG-BLOC]:  dominantTrendSIG: OPEN");
//               dominantSIG = hSIG.dominantTrendSIG;
//              }
//            else
//               if(noReverseBool && (hSIG.dominant240SIG!=SAN_SIGNAL::NOSIG)&&(hSIG.dominant240SIG!=SAN_SIGNAL::CLOSE))
//                 {
//                  Print("[domSIG-BLOC]:  dominant240SIG: OPEN");
//                  dominantSIG = hSIG.dominant240SIG;
//                 }
//               else
//                  if(noReverseBool && (hSIG.dominantTrendIma240SIG!=SAN_SIGNAL::NOSIG)&&(hSIG.dominantTrendIma240SIG!=SAN_SIGNAL::CLOSE))
//                    {
//                     Print("[domSIG-BLOC]:  dominantTrendIma240SIG: OPEN");
//                     dominantSIG = hSIG.dominantTrendIma240SIG;
//                    }
//                  else
//                     if(noReverseBool && (hSIG.dominant120SIG!=SAN_SIGNAL::NOSIG)&& (hSIG.dominant120SIG!=SAN_SIGNAL::CLOSE))
//                       {
//                        Print("[domSIG-BLOC]:  dominant120SIG: OPEN");
//                        dominantSIG = hSIG.dominant120SIG;
//                       }
//                     else
//                        if(noReverseBool && (hSIG.dominantTrendIma120SIG!=SAN_SIGNAL::NOSIG)
//                           && (hSIG.dominantTrendIma120SIG!=SAN_SIGNAL::CLOSE)
//                           &&((flatCPBool && domTrendBool && domTrendCombinationBool)))
//                          {
//                           Print("[domSIG-BLOC]:  dominantTrendIma120SIG: OPEN");
//                           dominantSIG = hSIG.dominantTrendIma120SIG;
//                          }
//                        else
//                           if(noReverseBool && (((hSIG.dominantTrendCPSIG!=SAN_SIGNAL::NOSIG)&&(hSIG.dominantTrendCPSIG!=SAN_SIGNAL::CLOSE))||(cPSIGBool)))
//                             {
//                              Print("[domSIG-BLOC]:  dominantTrendCPSIG: OPEN");
//                              dominantSIG = util.convTrendToSig(ss.cpScatterSIG);
//                             }
//                           else
//
//                              if(noReverseBool && fastSIGBool)
//                                {
//                                 Print("[domSIG-BLOC]:  fastIma30120SIG: OPEN");
//                                 dominantSIG = ss.fastIma30120SIG;
//                                }
//                              else
//                                 if(noReverseBool && (hSIG.dominant30SIG!=SAN_SIGNAL::NOSIG))
//                                   {
//                                    Print("[domSIG-BLOC]:  dominant30SIG: OPEN");
//                                    dominantSIG = hSIG.dominant30SIG;
//                                   }
//                                 else
//                                    if(util.oppSignal(hSIG.dominantTrendSIG,util.convTrendToSig(ss.cpScatterSIG)))
//                                      {
//                                       Print("[domSIG-BLOC]:  dominantTrendSIG <> cp120SIG : CLOSE");
//                                       dominantSIG = SAN_SIGNAL::CLOSE;
//                                      }
//                                    else
//                                       if(closeOnReverseBool && flatBool)
//                                         {
//                                          Print("[domSIG-BLOC]:  closeOnReverseBool sideWaysBool : CLOSE");
//                                          dominantSIG = SAN_SIGNAL::CLOSE;
//                                         }
//                                       else
//                                          if(flatBool)
//                                            {
//                                             Print("[domSIG-BLOC]:  sideWaysBool flatTrendBool flatCPBool: CLOSE");
//                                             dominantSIG = SAN_SIGNAL::SIDEWAYS;
//                                            }
//                                          else
//                                             if(closeBool)
//                                               {
//                                                dominantSIG = SAN_SIGNAL::CLOSE;
//                                               }


   return dominantSIG;
}

SanSignals sig;
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
