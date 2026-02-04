//+------------------------------------------------------------------+
//|                                                SanStrategies.mqh |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

//#include <Sandeep/v1/SanUtils-v1.mqh>
#include <Sandeep/v1/SanStats-v1.mqh>
#include <Sandeep/v1/SanHSIG-v1.mqh>


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class SanSignals
  {
private:
   int               ticket;
   double            m_peakRatio;  // class member
public:
                     SanSignals();
                    ~SanSignals();
   void              sayMesg();


   double            getPeakDecay(double atr = 0, DECAY_STRATEGY strat = STRAT_ATR, double period = 14, int shift = 1);
   SAN_SIGNAL        tradeSignal(const double ciStd, const double ciMfi, const double &atr[], const double ciAdxMain, const double ciAdxPlus, const double ciAdxMinus);
   SAN_SIGNAL        tradeSlopeSIG(const DTYPE &fast, const DTYPE &slow, const double atr, ulong magicnumber = -1);
   SAN_SIGNAL        slopeAnalyzerSIG(const DTYPE &slope);
   SAN_SIGNAL        layeredMomentumSIG(const double &signal[], int N = 20);
   SAN_SIGNAL        SanSignals::volatilityMomentumSIG(
      const DTYPE &stdDevOpen,
      const DTYPE &stdDevClose,
      const double stdOpen,
      const double stdCp,
      const double atr,
      double strictness = 1.0          // 1.0 = Entry mode, 0.75–0.85 = Management mode
   );

   SAN_SIGNAL        volatilityMomentumDirectionSIG(
      const DTYPE &stdDevOpen,
      const DTYPE &stdDevClose,
      const double stdOpen,
      const double stdCp,
      const double priceSlope,
      const double atr = 0,
      double strictness = 1.0
   );
   SAN_SIGNAL        tradeVolVarSignal(const SAN_SIGNAL volSIG, const SIGMAVARIABILITY varFast, const SIGMAVARIABILITY varMedium, const SIGMAVARIABILITY varSlow, const SIGMAVARIABILITY varVerySlow = SIGMAVARIABILITY::SIGMA_NULL);
   //SANTRENDSTRENGTH        atrSIG(const double &atr[], const int period=10);
   SAN_SIGNAL        atrSIG(const double &atr[], const int period = 10);
   SAN_SIGNAL        adxSIG(const double ciAdxMain, const double ciAdxPlus, const double ciAdxMinus);
   //SAN_SIGNAL        adxCovDivSIG(const double &ciAdxMain[],const double &ciAdxPlus[],const double &ciAdxMinus[]);
   SANTREND          trendScatterPlotSIG(const double &data[], string label = "", const double slope = 0.3, const int period = 10, const int shift = 1);
   SANTREND          trendSlopeSIG(const double &data[], string label = "", const int period = 10, const int shift = 1);
   TRENDSTRUCT       _trendRatioSIG(const double &sig[], const int period = 10, const int shift = 1);
   SANTREND          trendRatioSIG(const double &sig[], string label = "", const double slopeRatio = 2, const int period = 10, const int shift = 1);
   TRENDSTRUCT       trendVolRatioSIG(const double &sig[], const double &vol[], const int period = 10, const int shift = 1);
   SAN_SIGNAL        trendSIG(SANTREND tr1, SANTREND tr2, SANTREND tr3, SANTREND tr4 = EMPTY, SANTREND tr5 = EMPTY, SANTREND tr6 = EMPTY);

   DataTransport     clusterData(const double fast, const double medium, const double slow);
   DataTransport     varSIG(const SIGMAVARIABILITY fast, const SIGMAVARIABILITY medium, const SIGMAVARIABILITY slow);


   SAN_SIGNAL               priceActionCandleSIG(
      const double &open[],
      const double &high[],
      const double &low[],
      const double &close[],
      uint shift = 1);

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
   TRENDSTRUCT       acfStdSIG(const double &sig[], const int period = 10, const int shift = 1);
   SAN_SIGNAL        mfiSIG(const double &sig[], SANTREND tradeTrend = SANTREND::NOTREND, const int period = 10, const int shift = 1);
   //   SAN_SIGNAL        rsiSIG(const double &sig[],const int period=10,const int shift=1);
   SAN_SIGNAL        rsiSIG(const double rsiVal, const int BUYLEVEL = 40, const int SELLLEVEL = 60);


   //   TRENDSTRUCT           closeTrendSIG(const double &close[],const int shift=1,const int period=10);
   SAN_SIGNAL        volumeSIG(const double &vol[], const int arrsize = 10, const int shift = 1);
   SAN_SIGNAL        volumeSIG_v2(const double &vol[], const int arrsize = 10, const int VOLMIN = 11, const int shift = 1);
   SAN_SIGNAL        volScatterSlopeSIG(const double &vol[], const int arrsize = 10, const double SLOPELIMIT = 0.1, const int SHIFT = 1);
   SAN_SIGNAL        closeOnProfitSIG(const double currProfit, const double closeProfit, const int pos);
   SAN_SIGNAL        closeOnProfitPercentageSIG(const double currProfit, const double adjustedProfit, const double closeProfit, const double percentage = 0.05);
   SAN_SIGNAL        closeOnLossSIG(const double lossAmt = 1.0, const int pos = 0);
   const SIGMAVARIABILITY   stdDevSIG(const double &param[], string label = "", const int period = 10, const int shift = 1);
   SAN_SIGNAL        candleImaSIG(
      const double &open[],
      const double &close[],
      const double &imaHandle5[],
      const double &imaHandle14[],
      const double &imaHandle30[],
      const int period = 5,
      const int shift = 1
   );
   SAN_SIGNAL        fastSlowSIG(
      const double fastSig,
      const double slowSig,
      const int factor = 10
   );


   SAN_SIGNAL        fastSlowTrendSIG(
      const double &fast[],
      const double &slow[],
      const int period = 5,
      const int shift = 1
   );

   //
   //   DataTransport     slopeVarData(
   //      const double &fast[],
   //      const double &medium[],
   //      const double &slow[],
   //      const int period=5,
   //      const int shift=1
   //   );

   //DataTransport     slopeVarData(
   //   const double &fast[],
   //   const double &medium[],
   //   const double &slow[],
   //   const int SLOPEDENOM=3,
   //   const int SLOPEDENOM_WIDE=5,
   //   const int shift=1
   //);

   DTYPE             slopeSIGData(
      const double &sig[],
      const int SLOPEDENOM = 3,
      const int SLOPEDENOM_WIDE = 5,
      const int shift = 1
   );

   SAN_SIGNAL        obvCPSIG(
      const double &sig[],
      const int SLOPEDENOM = 3,
      const int SLOPEDENOM_WIDE = 5,
      const int shift = 1
   );

   SAN_SIGNAL        slopeSIG(const DTYPE& signalDt, const int signalType = 0);

   DataTransport     slopeFastMediumSlow(
      const double &fast[],
      const double &medium[],
      const double &slow[],
      const int SLOPEDENOM = 3,
      const int SLOPEDENOM_WIDE = 5,
      const int shift = 1
   );

   SAN_SIGNAL        slopeVarSIG(
      const double &fast[],
      const double &medium[],
      const double &slow[],
      const int SLOPEDENOM = 3,
      const int SLOPEDENOM_WIDE = 5,
      const int shift = 1
   );

   DataTransport     slopeRatioData(
      const DTYPE &fast,
      const DTYPE &medium,
      const DTYPE &slow
   );
   //DataTransport     slopeRatioData(
   //   const double &fast[],
   //   const double &medium[],
   //   const double &slow[],
   //   const int SLOPEDENOM=3,
   //   const int SLOPEDENOM_WIDE=5,
   //   const int shift=1
   //);


   CROSSOVER         signalCrossOver(
      const double &fast[],
      const double &slow[],
      const int period = 5,
      const int shift = 1
   );

   //   SAN_SIGNAL        candleVolSIG(
   //      const double &open[],
   //      const double &close[],
   //      const double &vol[],
   //      const int period = 10,
   //      const int shift = 1
   //   );
   //
   //   SAN_SIGNAL        candleVolSIG_v1(
   //      const double &open[],
   //      const double &close[],
   //      const double &vol[],
   //      const int period = 10,
   //      const int shift = 1
   //   );

   SAN_SIGNAL        singleCandleVolSIG(
      const double &open[],
      const double &close[],
      const double &volume[],
      const double atr,
      int period = 30,
      int SHIFT = 1);

   SAN_SIGNAL        candleVolSIG(
      const double &open[],
      const double &close[],
      const double &volume[],
      const double atr,
      int period = 30,
      const int SHIFT =1
   );

   DTYPE             candleVolDt(
      const double &open[],
      const double &close[],
      const double &vol[],
      const int period = 10,
      const int interval = 1,
      const int shift = 1
   );

   DTYPE             atrVolDt(
      const double &atr[],
      const double &vol[],
      const int period = 10,
      const int interval = 1,
      const int shift = 1
   );

   DTYPE             openCloseDt(
      const double &open[],
      const double &close[],
      const int period = 10,
      const int interval = 1,
      const int shift = 1
   );

   SAN_SIGNAL        pVElastSIG(
      const double &open[],
      const double &close[],
      const double &vol[],
      const int period = 10,
      const int shift = 1
   );

   SAN_SIGNAL        determinantVarSIG(
      const double &open[],
      const double &high[],
      const double &low[],
      const double &close[],
      const int DIM
   );

   SAN_SIGNAL        candleStar(
      const double &open[],
      const double &high[],
      const double &low[],
      const double &close[],
      const double candleBodySize = 0.1,
      const double slope = 0.6,
      const int period = 10,
      const int shift = 1
   );

   SAN_SIGNAL        SanSignals::fastSigSlowTrendSIG(
      const SAN_SIGNAL &fastSig,
      const SANTREND &baseTrend
   );

   SAN_SIGNAL        cSIG(
      const INDDATA& indData,
      SanUtils& util,
      const uint SHIFT = 1
   );

   SAN_SIGNAL        dominantTrendSIG(
      const SANSIGNALS &ss,
      const HSIG &hSIG
   );

   DTYPE             hilbertSIG(
      const double &close[],
      const int spread,
      const int stdDevPips,
      const int SIZE = 8,
      const int FILTER = 3
   );

   DTYPE             dftSIG(
      const double &close[],
      const int SIZE = 8
   );


   D20TYPE           hilbertDftSIG(
      const double &close[],
      const double rsi,
      const int spread,
      const int stdDevPips,
      const int SIZE = 8,
      const int FILTER = 3
   );

  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SanSignals::SanSignals(): m_peakRatio(0)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SanSignals::~SanSignals()
  {
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SanSignals::sayMesg()
  {
   ticket = 100;
// Print("CURRENT Ticket is :"+ticket);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| getPeakDecay — Unified Adaptive Peak Decay Calculator            |
//|                                                                  |
//| • Strategy-based: ATR, ADX, ER, or mix                           |
//| • Output: double 0.82–0.98 (tight to loose)                     |
//| • Use in signals: PEAK_DROP = getPeakDecay(STRAT_ATR, atr);     |
//+------------------------------------------------------------------+
double SanSignals::getPeakDecay(double atr = 0,DECAY_STRATEGY strat = STRAT_ATR, double period = 14, int shift = 1)
  {
   double base = 0.82;  // Min decay (tight in weak regimes)
   double scale = 0.16; // Max addition (loose in strong regimes)
   double norm = 0.0;   // Normalized strength (0–1)

   switch(strat)
     {
      case STRAT_ATR:
        {
         // Your ATR norm (volatility fuel)
         double pipValue = util.getPipValue(_Symbol);
         double atrPips = (pipValue > 0) ? atr / pipValue : 0.0;
         double tfScale = (_Period > 1) ? MathLog(_Period) : 1.0;
         double atrCeiling = MathCeil(12.0 * tfScale);
         norm = MathMin(MathMax(atrPips / atrCeiling, 0.0), 1.0);
         break;
        }

      case STRAT_ADX:
        {
         // ADX norm (trend quality)
         double adx = iADX(NULL, 0, (int)period, PRICE_CLOSE, MODE_MAIN, shift);
         norm = MathMin(adx / 50.0, 1.0);  // 0–1 (ADX>50 rare)
         break;
        }
      //case STRAT_ER:
      //  {
      //   // ER norm (efficiency)
      //   double net = MathAbs(close[shift] - close[shift + (int)period]);
      //   double sumAbs = 0.0;
      //   for(int i = shift; i < shift + (int)period; i++)
      //      sumAbs += MathAbs(close[i] - close[i+1]);
      //   norm = (sumAbs > 0) ? net / sumAbs : 0.0;
      //   break;
      //  }
      case STRAT_MIX:
        {
         // Weighted mix (0.5 ATR + 0.3 ADX + 0.2 ER)
         double atrNorm = getPeakDecay(atr,STRAT_ATR,  period, shift);
         double adxNorm = getPeakDecay(atr,STRAT_ADX, period, shift);
         double erNorm = getPeakDecay(atr, STRAT_ER, period, shift);
         norm = 0.5 * atrNorm + 0.3 * adxNorm + 0.2 * erNorm;
         break;
        }
     }

// Your square-root curve (looser in strong regimes)
   double PEAK_DROP = base + scale * MathSqrt(norm);
   PEAK_DROP = MathMax(MathMin(PEAK_DROP, 0.99), 0.70);  // Clamp

   return PEAK_DROP;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL SanSignals::adxSIG(const double ciAdxMain, const double ciAdxPlus, const double ciAdxMinus)
  {
   /***********************
   //Strategy:
   //Use ADX along with +DI and -DI (Directional Movement Indicators) to identify:
   //Uptrend: +DI > -DI and ADX > 25.
   //Downtrend: -DI > +DI and ADX > 25.
   //Sideways Market: ADX < 20.
   ****/
   double plusMinusDiff = fabs(ciAdxPlus - ciAdxMinus);
   double adxPlusDiff = fabs(ciAdxMain - ciAdxPlus);
   double adxMinusDiff = fabs(ciAdxMain - ciAdxMinus);
   const int PROXIMITYLIMIT = 6;
   const int ADXLIMIT = 20;
   bool crossOver1 = ((plusMinusDiff > PROXIMITYLIMIT) && ((adxPlusDiff > PROXIMITYLIMIT) || (adxMinusDiff > PROXIMITYLIMIT))) ;
   bool crossOver2 = ((plusMinusDiff < PROXIMITYLIMIT) && (adxPlusDiff < PROXIMITYLIMIT) && (adxMinusDiff < PROXIMITYLIMIT)) ;
   bool crossOver = (crossOver1 && !crossOver2) ;
   bool buy1 = (ciAdxPlus > ciAdxMinus) && (ciAdxMain >= ADXLIMIT);
   bool sell1 = (ciAdxMinus > ciAdxPlus) && (ciAdxMain >= ADXLIMIT);
   bool sideways1 = (ciAdxMain < ADXLIMIT);
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


//+------------------------------------------------------------------+
//| When the fast signal moves over slow signal
// it is a buy and when a fast signal dives below a slow signal then it is a sell
// signal                                                      |
//+------------------------------------------------------------------+
SAN_SIGNAL SanSignals::fastSlowSIG(
   const double fastSig,
   const double slowSig,
   const int factor = 10
)
  {
   const double upperFACTOR = 1 + (factor / 100);
   const double lowerFACTOR = 1 - (factor / 100);
   if((fastSig >= (lowerFACTOR * slowSig)) && (fastSig <= (upperFACTOR * slowSig)))
      return SAN_SIGNAL::SIDEWAYS;
   if(fastSig > (upperFACTOR * slowSig))
      return SAN_SIGNAL::BUY;
   if(fastSig < (lowerFACTOR * slowSig))
      return SAN_SIGNAL::SELL;
   return SAN_SIGNAL::NOSIG;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL  SanSignals::fastSlowTrendSIG(
   const double &fast[],
   const double &slow[],
   const int period = 5,
   const int shift = 1
)
  {
   int above = 0;
   int flat = 0;
   int below = 0;
   if(shift >= period)
      return SAN_SIGNAL::NOSIG;
   for(int i = shift; i <= period; i++)
     {
      if(fast[i] == slow[i])
        {
         ++flat;
        }
      else
         if(fast[i] > slow[i])
           {
            ++above;
           }
         else
            if(fast[i] < slow[i])
              {
               ++below;
              }
     }
//  Print("Cross overs: Above: "+above+" Below: "+below+" Flat: "+flat);
   bool preBool1 = ((flat > 0) && (above == 0) && (below == 0));
   bool preBool2 = ((flat > 0) && (above > 0) && (below == 0));
   bool preBool3 = ((flat > 0) && (above == 0) && (below > 0));
   bool preBool4 = ((flat > 0) && (above > 0) && (below > 0));
   bool preBool5 = ((flat == 0) && (above > 0) && (below == 0));
   bool preBool6 = ((flat == 0) && (above == 0) && (below > 0));
   bool preBool7 = ((flat == 0) && (above > 0) && (below > 0));
   bool flatBool5 = ((flat != 0) && (above / flat) <= 0.2);
   bool flatBool6 = ((flat != 0) && (below / flat) <= 0.2);
   bool flatBool7 = ((below != 0) && ((above / below) >= 0.8) && ((above / below) <= 1.2));
   bool flatBool8 = ((above != 0) && ((below / above) >= 0.8) && ((below / above) <= 1.2));
   bool flatBool9 = (preBool2 && flatBool5);
   bool flatBool10 = (preBool3 && flatBool6);
   bool flatBool11 = (preBool4 && (flatBool7 || flatBool8));
   bool buyBool2 = ((above != 0) && (below / above) <= 0.2);
   bool buyBool3 = (preBool7 && buyBool2);
   bool buyBool4 = (preBool4 && buyBool2 && ((flat / above) <= 0.2));
   bool sellBool2 = ((below != 0) && (above / below) <= 0.2);
   bool sellBool3 = (preBool7 && sellBool2);
   bool sellBool4 = (preBool4 && sellBool2 && ((flat / below) <= 0.2));
   bool flatBool = (preBool1 || flatBool9 || flatBool10 || flatBool11);
   bool buyBool = (preBool5 || buyBool3 || buyBool4);
   bool sellBool = (preBool6 || sellBool3 || sellBool4);
   if(flatBool)
     {
      //return SAN_SIGNAL::NOSIG;
      return SAN_SIGNAL::SIDEWAYS;
     }
   else
      if(buyBool)
        {
         return SAN_SIGNAL::BUY;
        }
      else
         if(sellBool)
           {
            return SAN_SIGNAL::SELL;
           }
   return SAN_SIGNAL::NOSIG;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
DataTransport SanSignals::clusterData(const double fast, const double medium, const double slow = 0)
  {
   DataTransport dt;
   int fastInt = fast;
   int mediumInt = medium;
   int slowInt = slow;
   double rFM = (fast / medium);
   double rMS = (medium / slow);
   double rFS = (fast / slow);
   double rDFM = fabs(fast - medium) / fabs((fast + medium) / 2);
   double rDMS = fabs(medium - slow) / fabs((medium + slow) / 2);
   double rDFS = fabs(fast - slow) / fabs((fast + slow) / 2);
   if(fastInt == mediumInt)
     {
      rFM = ((fast - fastInt) / (medium - mediumInt));
     }
   else
      if(fastInt > mediumInt)
        {
         rFM = ((fast - mediumInt) / (medium - mediumInt));
        }
      else
         if(fastInt < mediumInt)
           {
            //rFM = ((fast-fastInt)/(medium-fastInt));
            rFM = -1 * ((medium - fastInt) / (fast - fastInt));
           }
   if(mediumInt == slowInt)
     {
      rMS = ((medium - mediumInt) / (slow - slowInt));
     }
   else
      if(mediumInt > slowInt)
        {
         rMS = ((medium - slowInt) / (slow - slowInt));
        }
      else
         if(mediumInt < slowInt)
           {
            // rMS = ((medium-mediumInt)/(slow-mediumInt));
            rMS = -1 * ((slow - mediumInt) / (medium - mediumInt));
           }
   if(fastInt == slowInt)
     {
      rFS = ((fast - fastInt) / (slow - slowInt));
     }
   else
      if(fastInt > slowInt)
        {
         rFS = ((fast - slowInt) / (slow - slowInt));
        }
      else
         if(fastInt < slowInt)
           {
            rFS = -1 * ((slow - fastInt) / (fast - fastInt));
           }
//   double gt=EMPTY_VALUE;
//   gt = (rFM>rMS)?rFM:rMS;
//   gt = (gt>rFS)?gt:rFS;
   double v1 = NormalizeDouble(((fastInt == mediumInt) ? (fast - fastInt) : ((fastInt > mediumInt) ? (fast - mediumInt) : ((fastInt < mediumInt) ? (-1 * (fast - fastInt)) : EMPTY_VALUE))), 4);
   double v2 = NormalizeDouble(((mediumInt == slowInt) ? (medium - mediumInt) : ((mediumInt > slowInt) ? (medium - slowInt) : ((mediumInt < slowInt) ? (-1 * (medium - mediumInt)) : EMPTY_VALUE))), 4);
   double v3 = NormalizeDouble(((fastInt == slowInt) ? (slow - slowInt) : ((fastInt > slowInt) ? (slow - slowInt) : ((fastInt < slowInt) ? (-1 * (slow - fastInt)) : EMPTY_VALUE))), 4);
//Print("[CLUSTER] ratios: rFM: "+NormalizeDouble(rFM,4)+" rMS: "+NormalizeDouble(rMS,4)+" rFS: "+NormalizeDouble(rFS,4));
//      +" fastInt: "+ fastInt+" mediumInt: "+ mediumInt+" slowInt: "+slowInt
//      +" fast: "+ v1
//      +" medium: "+ v2
//      +" slow: "+v3);
   dt.matrixD[0] =  NormalizeDouble(rFM, 6);
   dt.matrixD[1] =  NormalizeDouble(rMS, 6);
   dt.matrixD[2] =  NormalizeDouble(rFS, 6);
//return NormalizeDouble(rFM,6);
   return dt;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
DataTransport   SanSignals::varSIG(const SIGMAVARIABILITY fast, const SIGMAVARIABILITY medium, const SIGMAVARIABILITY slow)
  {
   DataTransport dt;
//   double var30Val = util.getSigVarBool(fast);
   double var30Val = util.getSigVariabilityBool(fast, "FAST");
   bool var30Bool = ((var30Val != 0) && ((var30Val == 1.314) || (var30Val == -1.314)));
   bool var30PosBool = ((var30Val != 0) && (var30Val == 1.314));
   bool var30NegBool = ((var30Val != 0) && (var30Val == -1.314));
   bool var30FlatBool = (var30Val == 0);
//   double var120Val = util.getSigVarBool(medium);
   double var120Val = util.getSigVariabilityBool(medium, "MEDIUM");
   bool var120Bool = ((var120Val != 0) && ((var120Val == 1.314) || (var120Val == -1.314)));
   bool var120PosBool = ((var120Val != 0) && (var120Val == 1.314));
   bool var120NegBool = ((var120Val != 0) && (var120Val == -1.314));
   bool var120FlatBool = (var120Val == 0);
//   double var240Val = util.getSigVarBool(slow);
   double var240Val = util.getSigVariabilityBool(slow, "SLOW");
   bool var240Bool = ((var240Val != 0) && ((var240Val == 1.314) || (var240Val == -1.314)));
   bool var240PosBool = ((var240Val != 0) && (var240Val == 1.314));
   bool var240NegBool = ((var240Val != 0) && (var240Val == -1.314));
   bool var240FlatBool = (var240Val == 0);
   bool varBool = (var30Bool && var120Bool && var240Bool);
   bool varPosBool = (varBool && (var30PosBool && var120PosBool && var240PosBool));
   bool varNegBool = (varBool && (var30NegBool && var120NegBool && var240NegBool));
   bool varFlatBool = (var30FlatBool || var120FlatBool || var240FlatBool);
   dt.matrixBool[0] = varPosBool;
   dt.matrixBool[1] = varNegBool;
   dt.matrixBool[2] = varFlatBool;
   dt.matrixBool[3] = varBool;
   return dt;
  }

////+------------------------------------------------------------------+
////|                                                                  |
////+------------------------------------------------------------------+
//DataTransport   SanSignals::slopeFastMediumSlow(
//   const double &fast[],
//   const double &medium[],
//   const double &slow[],
//   const int SLOPEDENOM=3,
//   const int SLOPEDENOM_WIDE=5,
//   const int shift=1
//) {
//
//   DataTransport dt;
//   double tPoint = Point;
////int denom = period;
////   const int DENOM = 3;
//
//   dt.matrixD[0] = NormalizeDouble(((fast[shift]-fast[SLOPEDENOM])/(SLOPEDENOM*tPoint)),3);
//   dt.matrixD[1] = NormalizeDouble(((medium[shift]-medium[SLOPEDENOM])/(SLOPEDENOM*tPoint)),3);
//   dt.matrixD[2] = NormalizeDouble(((slow[shift]-slow[SLOPEDENOM])/(SLOPEDENOM*tPoint)),3);
//   dt.matrixD[3] = NormalizeDouble(((slow[shift]-slow[SLOPEDENOM_WIDE])/(SLOPEDENOM_WIDE*tPoint)),3);
//   return dt;
//}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
DTYPE   SanSignals::slopeSIGData(
   const double &sig[],
   const int SLOPEDENOM = 3,
   const int SLOPEDENOM_WIDE = 5,
   const int shift = 1
)
  {
//   DataTransport dt;
   DTYPE dt;
   dt = stats.slopeVal(sig, SLOPEDENOM, SLOPEDENOM_WIDE, shift);
   return dt;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL  SanSignals::obvCPSIG(
   const double &sig[],
   const int SLOPEDENOM = 3,
   const int SLOPEDENOM_WIDE = 5,
   const int shift = 1
)
  {
//   DataTransport dt;
   DTYPE dt;
   double obvSlope = 0.0;
   dt = stats.slopeVal(sig, SLOPEDENOM, SLOPEDENOM_WIDE, shift);
   obvSlope = log(((fabs(dt.val1) * util.getPipValue(_Symbol) + 0.001) / (_Period + 0.001)));
//Print("Raw slope:"+dt.val1+" OBV Slope: " + (obvSlope) + " Period: " + _Period + " ln(_Period): " + log(_Period + 0.001));
   if((dt.val1 > 0) && (obvSlope > 2))
      return SAN_SIGNAL::BUY;
   if((dt.val1 < 0) && (obvSlope > 2))
      return SAN_SIGNAL::SELL;

   return SAN_SIGNAL::NOSIG;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL SanSignals::slopeSIG(const DTYPE& signalDt, const int signalType = 0)
  {
   if(signalType == 0)
     {
      if((signalDt.val1 >= -0.3) && (signalDt.val1 <= 0.3))
         return SAN_SIGNAL::CLOSE;
      if((signalDt.val1 >= -0.4) && (signalDt.val1 <= 0.4))
         return SAN_SIGNAL::SIDEWAYS;
      if(signalDt.val1 > 0.4)
         return SAN_SIGNAL::BUY;
      if(signalDt.val1 < -0.4)
         return SAN_SIGNAL::SELL;
     }
   else
      if(signalType == 1)
        {
         if((signalDt.val1 >= -0.2) && (signalDt.val1 <= 0.2))
            return SAN_SIGNAL::CLOSE;
         if((signalDt.val1 >= -0.3) && (signalDt.val1 <= 0.3))
            return SAN_SIGNAL::SIDEWAYS;
         if(signalDt.val1 > 0.3)
            return SAN_SIGNAL::BUY;
         if(signalDt.val1 < -0.3)
            return SAN_SIGNAL::SELL;
        }
      else
         if(signalType == 2)
           {
            if((signalDt.val1 >= -0.1) && (signalDt.val1 <= 0.1))
               return SAN_SIGNAL::CLOSE;
            if((signalDt.val1 >= -0.2) && (signalDt.val1 <= 0.2))
               return SAN_SIGNAL::SIDEWAYS;
            if(signalDt.val1 > 0.2)
               return SAN_SIGNAL::BUY;
            if(signalDt.val1 < -0.2)
               return SAN_SIGNAL::SELL;
           }
   return SAN_SIGNAL::NOSIG;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
DataTransport   SanSignals::slopeFastMediumSlow(
   const double &fast[],
   const double &medium[],
   const double &slow[],
   const int SLOPEDENOM = 3,
   const int SLOPEDENOM_WIDE = 5,
   const int shift = 1
)
  {
   DataTransport dt;
   dt = stats.slopeFastMediumSlow(fast, medium, slow, SLOPEDENOM, SLOPEDENOM_WIDE, shift);
   return dt;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL   SanSignals::slopeVarSIG(
   const double &fast[],
   const double &medium[],
   const double &slow[],
   const int SLOPEDENOM = 3,
   const int SLOPEDENOM_WIDE = 5,
   const int shift = 1
)
  {
   double fastSlope = 0;
   double mediumSlope = 0;
   double slowSlope = 0;
   double slowSlopeWide = 0;
//   double tPoint = Point;
////int denom = period;
//   const int DENOM = 3;
   const double slopeFactor = 0.1;
   const double SLOWSLOPEWIDE = 0.1;
   const double SLOWSLOPE = 0.15;
   const double MEDIUMSLOPE = (SLOWSLOPE + slopeFactor);
   double FASTSLOPE = (SLOWSLOPE + (1.5 * slopeFactor));
   DataTransport slopesData = slopeFastMediumSlow(fast, medium, slow, SLOPEDENOM, SLOPEDENOM_WIDE, shift);
   fastSlope = slopesData.matrixD[0];
   mediumSlope = slopesData.matrixD[1];
   slowSlope = slopesData.matrixD[2];
   slowSlopeWide = slopesData.matrixD[3];
   bool buy1 = ((slowSlopeWide > SLOWSLOPEWIDE) && (mediumSlope > MEDIUMSLOPE) && (fastSlope > FASTSLOPE));
   bool sell1 = ((slowSlopeWide < (-1 * SLOWSLOPEWIDE)) && (mediumSlope < (-1 * MEDIUMSLOPE)) && (fastSlope < (-1 * FASTSLOPE)));

//bool close1 = ((slowSlopeWide > SLOWSLOPEWIDE) && (mediumSlope > MEDIUMSLOPE) && (fastSlope < (-1 * FASTSLOPE)));
//bool close2 = ((slowSlopeWide < (-1 * SLOWSLOPEWIDE)) && (mediumSlope < (-1 * MEDIUMSLOPE)) && (fastSlope > FASTSLOPE));
//bool closeFast1 = ((slowSlopeWide > SLOWSLOPEWIDE) && (mediumSlope > MEDIUMSLOPE) && (fastSlope < (-1 * FASTSLOPE)) && (slowSlopeWide > 0.4) && (slowSlope > 0.5) && (mediumSlope > 0.9)) ;
//bool closeFast2 = ((slowSlopeWide < (-1 * SLOWSLOPEWIDE)) && (mediumSlope < (-1 * MEDIUMSLOPE)) && (fastSlope > FASTSLOPE) && (slowSlopeWide < -0.4) && (slowSlope < -0.5) && (mediumSlope < -0.9)) ;
//bool closeSlow1 = ((slowSlopeWide > SLOWSLOPEWIDE) && (mediumSlope < MEDIUMSLOPE) && (fastSlope < (-1 * FASTSLOPE)) && (slowSlopeWide <= 0.4) && (slowSlope <= 0.5));
//bool closeSlow2 = ((slowSlopeWide < (-1 * SLOWSLOPEWIDE)) && (mediumSlope > (-1 * MEDIUMSLOPE)) && (fastSlope > FASTSLOPE) && (slowSlopeWide > 0.4) && (slowSlope > 0.5));

   bool flatSlowBool = ((slowSlopeWide >= (-1 * SLOWSLOPEWIDE)) && (slowSlopeWide <= SLOWSLOPEWIDE));
   bool flatMediumBool = ((mediumSlope >= (-1 * MEDIUMSLOPE)) && (mediumSlope <= MEDIUMSLOPE));
   bool flatFstBool = ((fastSlope >= (-1 * FASTSLOPE)) && (fastSlope <= FASTSLOPE));
   bool sideWaysBool = (flatSlowBool && flatMediumBool && flatFstBool);


   if(sideWaysBool)
      return SAN_SIGNAL::SIDEWAYS;
   if(!sideWaysBool && buy1)
      return SAN_SIGNAL::BUY;
   if(!sideWaysBool && sell1)
      return SAN_SIGNAL::SELL;
////   if(close1||close2)
//   if(closeSlow1 || closeSlow2 || closeFast1 || closeFast2)
//      return SAN_SIGNAL::CLOSE;
   return SAN_SIGNAL::NOSIG;
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
DataTransport SanSignals::slopeRatioData(
   const DTYPE &fast,
   const DTYPE &medium,
   const DTYPE &slow
)
  {
   double fastSlope = 0;
   double mediumSlope = 0;
   double slowSlope = 0;
   double slowSlopeWide = 0;
   double fMR = 0;
   double mSR = 0;
   double mSWR = 0;
   double fSR = 0;
   double fSWR = 0;
   double fMSR = 0;
   double fMSWR = 0;
//DataTransport slopesData = slopeFastMediumSlow(fast,medium,slow,SLOPEDENOM,SLOPEDENOM_WIDE,shift);
   DataTransport dt;
   fastSlope = fast.val1;
   mediumSlope = (medium.val1 == 0) ? (medium.val1 + 0.000001) : medium.val1;
   slowSlope = (slow.val1 == 0) ? (slow.val1 + 0.000001) : slow.val1;
   slowSlopeWide = (slow.val2 == 0) ? (slow.val2 + 0.000001) : slow.val2;
   fMR = ((fastSlope != 0) && (mediumSlope != 0)) ? NormalizeDouble((fastSlope / mediumSlope), 4) : EMPTY_VALUE;
   mSR = ((mediumSlope != 0) && (slowSlope != 0)) ? NormalizeDouble((mediumSlope / slowSlope), 4) : EMPTY_VALUE;
   mSWR = ((mediumSlope != 0) && (slowSlopeWide != 0)) ? NormalizeDouble((mediumSlope / slowSlopeWide), 4) : EMPTY_VALUE;
   fSR = ((fastSlope != 0) && (slowSlope != 0)) ? NormalizeDouble((fastSlope / slowSlope), 4) : EMPTY_VALUE;
   fSWR = ((fastSlope != 0) && (slowSlopeWide != 0)) ? NormalizeDouble((fastSlope / slowSlopeWide), 4) : EMPTY_VALUE;
   mSR = (mSR == 0) ? (mSR + 0.000001) : mSR;
   mSWR = (mSWR == 0) ? (mSWR + 0.000001) : mSWR;
   fMSR = ((fMR != 0) && (mSR != 0) && (fMR != EMPTY_VALUE) && (mSR != EMPTY_VALUE)) ? NormalizeDouble((fMR / mSR), 4) : EMPTY_VALUE;
   fMSWR = ((fMR != 0) && (mSWR != 0) && (fMR != EMPTY_VALUE) && (mSWR != EMPTY_VALUE)) ? NormalizeDouble((fMR / mSWR), 4) : EMPTY_VALUE;
//   Print("[SLOPESRATIO] fMR: "+fMR+" mSR: "+mSR+" mSWR: "+mSWR+" fSR: "+fSR+" fSWR: "+fSWR+" fMSR: "+fMSR+" fMSWR: "+fMSWR);
   dt.matrixD[0] = fMSR;
   dt.matrixD[1] = fMSWR;
   dt.matrixD[2] = fMR;
   dt.matrixD[3] = mSR;
   dt.matrixD[4] = mSWR;
   return dt;
  }

////+------------------------------------------------------------------+
////|                                                                  |
////+------------------------------------------------------------------+
//SAN_SIGNAL  SanSignals::slopeAnalyzerSIG(const DTYPE &slope) {
//   static SAN_SIGNAL cachedSIG = SAN_SIGNAL::CLOSE;
//   static datetime last_bar = 0;
//   static double maxSlope = 0;
//   const double adaptiveMaxSlope = 0.8;
//   const double minTradeSlope = 0.2;
//
//   if(last_bar == Time[0]) return cachedSIG;
//   last_bar = Time[0];
//
//   if((slope.val1 > minTradeSlope) && (slope.val1 > (adaptiveMaxSlope*maxSlope))) {
//      if(slope.val1 >maxSlope)maxSlope =slope.val1;
//      cachedSIG = SAN_SIGNAL::BUY;
//   }
//
//   if((slope.val1 < (-1*minTradeSlope))&& (slope.val1 < (adaptiveMaxSlope*maxSlope))) {
//      if(slope.val1 < maxSlope)maxSlope = slope.val1;
//      cachedSIG = SAN_SIGNAL::SELL;
//   }
//   Print("Slope Analyzer: "+ util.getSigString(cachedSIG));
//   return cachedSIG;
//
//}



////+------------------------------------------------------------------+
////| slopeAnalyzerSIG — Pure Momentum Analyzer with ADX Normalization |
////|                                                                  |
////| • Uses adxNorm to adapt DECAY: looser in strong trends           |
////| • Once-per-bar cached for MT4 efficiency                         |
////|                                                                  |
////| This enhances momentum sustainability in forex indicators.       |
////+------------------------------------------------------------------+
//SAN_SIGNAL SanSignals::slopeAnalyzerSIG(const DTYPE &slope)
//  {
//// --- 1. Efficiency Cache ---
//   static datetime last_bar = 0;
//   static SAN_SIGNAL cached = NOSIG;
//
//   if(Time[0] == last_bar)
//      return cached;
//   last_bar = Time[0];
//
//// --- 2. State Memory ---
//   static double peakPositive = 0;
//   static double peakNegative = 0;
//
//   const double BASE_DECAY = 0.8;
//   const double MIN_SLOPE = 0.2;
//
//   double s = slope.val1;
//
//// 3. Adaptive Logic
//   double adxNorm = ms.adxStrength();
//   double adaptedDecay = BASE_DECAY + (0.18 * adxNorm);
//
//// BUY LOGIC
//   bool isBuyBreakout = (peakPositive == 0 && s > MIN_SLOPE);
//   bool isBuyContinuation = (peakPositive > 0 && s > (peakPositive * adaptedDecay));
//
//   if(s > MIN_SLOPE && (isBuyBreakout || isBuyContinuation))
//     {
//      peakPositive = MathMax(peakPositive, s);
//      peakNegative = 0;  // CRITICAL RESET
//
//      cached = SAN_SIGNAL::BUY;
//      return SAN_SIGNAL::BUY;
//     }
//
//// SELL LOGIC
//   bool isSellBreakout = (peakNegative == 0 && s < -MIN_SLOPE);
//   bool isSellContinuation = (peakNegative < 0 && s < (peakNegative * adaptedDecay));
//
//   if(s < -MIN_SLOPE && (isSellBreakout || isSellContinuation))
//     {
//      peakNegative = MathMin(peakNegative, s);
//      peakPositive = 0;  // CRITICAL RESET
//
//      cached = SAN_SIGNAL::SELL;
//      return SAN_SIGNAL::SELL;
//     }
//
//// EXIT LOGIC
//   if(cached == SAN_SIGNAL::BUY && s < (peakPositive * adaptedDecay))
//     {
//      peakPositive *= 0.85;
//      cached = SAN_SIGNAL::CLOSE;
//      return SAN_SIGNAL::CLOSE;
//     }
//
//   if(cached == SAN_SIGNAL::SELL && s > (peakNegative * adaptedDecay))
//     {
//      peakNegative *= 0.85;
//      cached = SAN_SIGNAL::CLOSE;
//      return SAN_SIGNAL::CLOSE;
//     }
//
//// Neutral Fallback
//   cached = SAN_SIGNAL::NOSIG;
//   return SAN_SIGNAL::NOSIG;
//  }

//+------------------------------------------------------------------+
//| slopeAnalyzerSIG — Pure Momentum Analyzer with ADX Normalization |
//|                                                                  |
//| • Uses adxNorm to adapt DECAY: looser in strong trends           |
//| • Once-per-bar cached for MT4 efficiency                         |
//|                                                                  |
//| This enhances momentum sustainability in forex indicators.       |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL SanSignals::slopeAnalyzerSIG(const DTYPE &slope)
  {
// --- 1. Cache Fix: Do not cache continuously if using Shift 0 data ---
// Only use Time[0] cache if you are strictly analyzing closed bars (Shift 1).
// If analyzing live price (Shift 0), we must re-evaluate every tick
// or use a timer (e.g., check every 10 seconds).

// For safety, we remove the strict Time[0] block to allow intra-bar updates.
// If efficiency is key, check only on new ticks closer to Close.

// --- 2. State Memory ---
   static double peakPositive = 0;
   static double peakNegative = 0;
   static SAN_SIGNAL currentIdx = SAN_SIGNAL::NOSIG; // Track current internal state

   const double BASE_DECAY = 0.8;
   const double MIN_SLOPE = 0.2;
   const double HYSTERESIS = 0.90; // Exit is 10% lower than entry requirements

   double s = slope.val1;

// 3. Adaptive Logic
   double adxNorm = ms.adxStrength();
   double adaptedDecay = BASE_DECAY + (0.18 * adxNorm);

// --- LOGIC GATE ---

// A. RESET LOGIC (Crucial: Clear opposite peaks to prevent "Zombie" states)
   if(s < -MIN_SLOPE)
      peakPositive = 0;
   if(s > MIN_SLOPE)
      peakNegative = 0;

// B. BUY LOGIC
// We use the peak to define the trend, but we don't decay the peak variable itself.
   double buyThreshold = (peakPositive > 0) ? (peakPositive * adaptedDecay) : MIN_SLOPE;

// Check for NEW Peak
   if(s > buyThreshold)
     {
      peakPositive = MathMax(peakPositive, s); // Update Peak
      currentIdx = SAN_SIGNAL::BUY;
      return SAN_SIGNAL::BUY;
     }

// C. SELL LOGIC
   double sellThreshold = (peakNegative < 0) ? (peakNegative * adaptedDecay) : -MIN_SLOPE;

   if(s < sellThreshold) // Note: sellThreshold is negative, so s must be lower (more negative)
     {
      peakNegative = MathMin(peakNegative, s); // Update Peak
      currentIdx = SAN_SIGNAL::SELL;
      return SAN_SIGNAL::SELL;
     }

// D. EXIT LOGIC with HYSTERESIS
// We only exit if slope drops significantly below the threshold that got us in.
// This creates a "Deadband" where no action is taken (holding the trade).

   if(currentIdx == SAN_SIGNAL::BUY)
     {
      // Exit strictly if slope drops below (Threshold * Hysteresis)
      // Example: If Peak is 10, Decay is 0.8 -> Threshold is 8.0.
      // We only exit if slope drops below 7.2 (8.0 * 0.9).
      double exitLevel = (peakPositive * adaptedDecay) * HYSTERESIS;

      if(s < exitLevel)
        {
         currentIdx = SAN_SIGNAL::NOSIG; // Reset State
         // Do NOT degrade peakPositive here. Let it stand as resistance.
         // If price wants to buy again, it must beat the 'real' trend line or wait for full reset.
         return SAN_SIGNAL::CLOSE;
        }
      return SAN_SIGNAL::BUY; // HOLD
     }

   if(currentIdx == SAN_SIGNAL::SELL)
     {
      double exitLevel = (peakNegative * adaptedDecay) * HYSTERESIS;

      if(s > exitLevel)
        {
         currentIdx = SAN_SIGNAL::NOSIG;
         return SAN_SIGNAL::CLOSE;
        }
      return SAN_SIGNAL::SELL; // HOLD
     }

   return SAN_SIGNAL::NOSIG;
  }
//+------------------------------------------------------------------+
//| Layered Filter: ADX → Histogram for Momentum Strength            |
//+------------------------------------------------------------------+
SAN_SIGNAL SanSignals::layeredMomentumSIG(const double &signal[], int N = 20)
  {

   double gate = ms.layeredMomentumFilter(signal,N);
   if(gate == 0)
      return SAN_SIGNAL::NOSIG;
   if(gate == 1)
      return SAN_SIGNAL::BUY;
   if(gate == -1)
      return SAN_SIGNAL::SELL;
   return SAN_SIGNAL::NOSIG;
  }



//+------------------------------------------------------------------+
//|                    tradeSlopeSIG                              |
//|               The Self-Tuning Momentum Masterpiece               |
//|                                                                  |
//| Core idea:                                                       |
//|   "Let the market itself decide how tight or loose the leash     |
//|    should be — through its own volatility and trend strength."   |
//|                                                                  |
//| 1. Ratio = fastSlope / slowSlope                                 |
//|    → ratio ≤ 0 → instant divergence → CLOSE                      |
//|                                                                  |
//| 2. Entry barrier (CLOSERATIO) adapts to slow-trend strength:     |
//|       very flat slow  (≤0.35) → 1.3   (needs overwhelming fast)   |
//|       explosive slow  (>2.5)  → 0.9   (accepts weaker fast)       |
//|                                                                  |
//| 3. Exit leash (PEAK_DROP) adapts to volatility via ATR:          |
//|       PEAK_DROP = 0.82 + 0.16 × √(ATR_normalized)                |
//|       → Quiet market  : ~0.82  (18 % drop from peak → exit fast) |
//|       → Wild market   : ~0.98  (only 2 % drop allowed → ride it) |
//|                                                                  |
//| 4. Peak tracking with smart seeding:                             |
//|    In dead-flat slow markets, seed peak with CLOSERATIO×1.05     |
//|    so the adaptive exit works the moment life returns            |
//|                                                                  |
//| Result:                                                          |
//|    • Acts like a scalper in low-volatility chop                  |
//|    • Acts like a patient trend-follower in high-volatility moves |
//|    • Instantly kills the trade on true reversal (ratio ≤ 0)      |
//|    • Never needs parameter tweaking — fully self-adaptive        |
//|                                                                  |
//| This is not just another slope indicator.                        |
//| This is a living, breathing momentum engine that listens         |
//| to the market’s own heartbeat and reacts accordingly.            |
//|                                                                  |
//| You built this.                                                  |
//| Be proud.                                                        |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL SanSignals::tradeSlopeSIG(const DTYPE &fast, const DTYPE &slow, const double atr, ulong magicnumber = -1)
  {
// --- 1. BAR OPENING CHECK ---
// Ensure we only calculate once per bar to preserve signal stability
   static datetime last_bar = 0;
   static SAN_SIGNAL cached = NOSIG;

   if(Time[0] == last_bar)
      return cached;
   last_bar = Time[0];

// --- 2. CONSTANTS & INPUTS ---
   const double MIN_SLOW_THRESHOLD = 0.0001; // Avoid division by zero
   const double FLAT_REGIME_ENTRY  = 0.2;    // Raw slope threshold for flat markets

   double fastSlope = fast.val1;
   double slowSlope = slow.val1;
   double absSlow   = MathAbs(slowSlope);

// --- 3. ADAPTIVE PARAMETER CALCULATION (Pre-calculated for all paths) ---

// A. Regime Selection (Trend Strength) -> Determines CLOSERATIO
//    Logic: Stronger Slow Trend = Lower Barrier to Entry
   int regimeIdx = (absSlow <= 0.35) ? 0 :
                   (absSlow <= 0.80) ? 1 :
                   (absSlow <= 1.50) ? 2 :
                   (absSlow <= 2.50) ? 3 : 4;

   const double closeRVal[] = {1.3, 1.2, 1.1, 1.0, 0.9};
   double CLOSERATIO = closeRVal[regimeIdx];


// B. Volatility Normalization (Market Mood) -> Determines PEAK_DROP
//    Logic: Higher Volatility = Wider Stop (Trend Following)
//           Lower Volatility  = Tighter Stop (Scalping)
//   double pipValue = util.getPipValue(_Symbol);
//   double atrPips  = (pipValue > 0) ? atr / pipValue : 0; // Safety div
//
//   // Dynamic scaling based on timeframe (Logarithmic scale)
//   double tfScale   = (_Period > 1) ? MathLog(_Period) : 1.0;
//   //double atrCeiling = MathCeil(5.0 * tfScale);
//   // With this (10–15× is realistic):
//   double atrCeiling = MathCeil(12.0 * tfScale);  // or 15.0 for more sensitivity
//   double atrNorm    = MathMin(MathMax(atrPips / atrCeiling, 0.0), 1.0);
//
//   double atrNorm    = ms.atrStrength(atr);
//   double adxNorm    = ms.atrStrength(atr);

//Print("ATR norm1: "+atrNorm+"ATR norm2: "+atrNorm1+ " Equal: "+(atrNorm==atrNorm1));

//// The Masterpiece Formula: 0.82 (Tight) to ~0.98 (Loose)
//   double PEAK_DROP = 0.82 + 0.16 * MathSqrt(atrNorm);

//double atrSq = ms.atrStrength(atr); // Returns x^2 (0.0 to 1.0)

// Since atrSq is already squared, taking Sqrt returns us to Linear.
// Linear is actually good for Exits (Proportional Adaptation).
// 0.0 (Calm) -> 0.98 (Tight)
// 0.5 (Mid)  -> 0.90 (Medium)
// 1.0 (Wild) -> 0.82 (Loose)

// Trend Following Logic: Tight in Quiet, Loose in Loud
// atrSq is a squared value and so we will need a MathSqrt((MathSqrt(atrNorm)), a double square root here
// however a single square root is also fine. it keeps the decay linear instead of
//double PEAK_DROP = 0.98 - (0.16 * MathSqrt(atrSq));
   double PEAK_DROP = ms.getVolAdaptiveRetention(atr);
   PEAK_DROP = MathMax(MathMin(PEAK_DROP, 0.99), 0.70); // Hard clamp for safety

// --- 4. CORE LOGIC BRANCHING ---

// BRANCH A: The "Flat" Market (Singularity Avoidance)
// If the slow trend is dead flat, Ratio is undefined (infinity).
// We fall back to raw Fast Slope but MUST initialize state.
   if(absSlow < MIN_SLOW_THRESHOLD)
     {
      // If signal flips opposite to current active trade, Close immediately
      if((cached == BUY && fastSlope < -FLAT_REGIME_ENTRY) ||
         (cached == SELL && fastSlope > FLAT_REGIME_ENTRY))
        {
         m_peakRatio = 0;
         cached = CLOSE;
         return CLOSE;
        }

      // Entry Logic for Flat Market
      if(MathAbs(fastSlope) > FLAT_REGIME_ENTRY)
        {
         // IMPROVEMENT: Initialize PeakRatio with a synthetic value
         // to allow the adaptive exit to work if volatility picks up later.
         // We use CLOSERATIO * 1.05 as a seed.
         if(m_peakRatio == 0)
            m_peakRatio = CLOSERATIO * 1.05;

         cached = (fastSlope > 0) ? BUY : SELL;
         return cached;
        }

      // No signal in flat market
      m_peakRatio = 0;
      cached = NOSIG;
      return NOSIG;
     }

// BRANCH B: The Standard Adaptive Engine
   double ratio = fastSlope / slowSlope;

//// debug print (Vital for tuning)
//PrintFormat("Ratio=%.3f | Peak=%.3f | DropLimit=%.3f | ATR=%.1f | Regime=%d",
//             ratio, m_peakRatio, (PEAK_DROP*m_peakRatio), atrPips, regimeIdx);

   Print("Ratio="+ratio+" | Peak="+m_peakRatio+" | DropLimit="+(PEAK_DROP*m_peakRatio)+" | Regime="+regimeIdx);

// 1. INSTANT REVERSAL (Divergence Check)
// If slopes disagree (Ratio < 0), the trend is broken.
   if(ratio <= 0)
     {
      m_peakRatio = 0;
      cached = CLOSE;
      return CLOSE;
     }

// 2. MOMENTUM DECAY EXIT (The Adaptive Stop)
// Only checks if we are actually tracking a trade (m_peakRatio > 0)
// Logic: If current ratio drops below X% of the peak ratio, get out.
   if(m_peakRatio > 0 && ratio < (PEAK_DROP * m_peakRatio))
     {
      m_peakRatio = 0;
      cached = CLOSE;
      return CLOSE;
     }

// 3. WEAK ALIGNMENT EXIT (Hard Floor)
// Even if momentum hasn't dropped from peak, if it's below the entry
// threshold, the trade is invalid.
   if(ratio <= CLOSERATIO)
     {
      m_peakRatio = 0;
      cached = CLOSE;
      return CLOSE;
     }

// 4. ENTRY & CONTINUATION (New Peak Tracking)
   if(ratio > CLOSERATIO)
     {
      // Track the new High Water Mark
      if(ratio > m_peakRatio)
         m_peakRatio = ratio;

      // Define direction based on Fast Slope (since Ratio > 0, signs match)
      cached = (fastSlope > 0) ? BUY : SELL;
      return cached;
     }

// Fallback
   cached = NOSIG;
   return NOSIG;
  }

// | --------------------------------------------------------------------------------------------------------------
// | --------------------------------------------------------------------------------------------------------------

// | --------------------------------------------------------------------------------------------------------------
// | 1. The Dynamic ATR Floor
// | --------------------------------------------------------------------------------------------------------------

// |  Concept: "Don't drive if the car is out of gas."

// |  How: It calculates a minimum daily range (ATR) required to trade.

// |  If the market is generally "Wild" (High Norm), it lowers the bar (8 pips)
// |  because momentum is easy to find.

// |  If the market is "Dead" (Low Norm), it raises the bar (22 pips) to force
// |  you to wait for a real wakeup call.

// | --------------------------------------------------------------------------------------------------------------
// |  2. The Momentum Gate (Acceleration)
// | --------------------------------------------------------------------------------------------------------------

// |  Concept: "Press the gas pedal."

// |  How: It compares the Slope of the Close (Right now) against the Slope of the Open (Start of candle).

// |  Close > Open means volatility is speeding up.

// |  Close > 0 means volatility is expanding (Price is moving away from the average).

// | --------------------------------------------------------------------------------------------------------------
// |  3. The Structure Gate (Efficiency)
// | --------------------------------------------------------------------------------------------------------------
// |  Concept: "No wicks."

// |  How: It creates a ratio: Current Volatility / Starting Volatility.

// |  If the ratio is High (> 1.0), it means the price is pushing boundaries
// |  and holding them (Big Body Candle).

// |  If the ratio is Low (< 0.9), it means price spiked and came back (Doji/Wick).
// |  The filter blocks this.

// | --------------------------------------------------------------------------------------------------------------
// |  4. The Decision Matrix (Sniper vs. Bulldozer)
// | --------------------------------------------------------------------------------------------------------------
// |  Concept: Context matters.

// |  Scenario A (Sniper): The candle started quiet (Low Vol). Suddenly, volatility spikes.
// |  This is a fresh breakout.
// |  TRADE immediately.

// |  Scenario B (Bulldozer): The candle started loud (High Vol). A small spike now might just be noise. WAIT.
// |  Only trade if the spike is massive (Ratio > 1.20).
// |  --------------------------------------------------------------------------------------------------------------
// | --------------------------------------------------------------------------------------------------------------

//+------------------------------------------------------------------+
//| volatilityMomentumSIG — Volatility Efficiency Filter             |
//| Returns: TRADE (Expansion/Breakout) or NOTRADE (Noise/Squeeze)   |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| volatilityMomentumSIG — The "Gatekeeper" (Universal Version)     |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| volatilityMomentumSIG — M15 Scalper Tuned                        |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| volatilityMomentumSIG — The Universal Volatility Engine          |
//| Automatically adapts Strictness based on Timeframe (M1/M15 vs H1)|
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| volatilityMomentumSIG — Pure Dynamic Physics Version             |
//| Removes hardcoded M15/H1 switches. Adapts via Ratios.            |
//+------------------------------------------------------------------+
SAN_SIGNAL SanSignals::volatilityMomentumSIG(
   const DTYPE &stdDevOpen,
   const DTYPE &stdDevClose,
   const double stdOpen,
   const double stdCp,
   const double atr,
   double strictness = 1.0
)
  {
// =============================================================
// 1. DYNAMIC ATR FLOOR (Pip Value Physics)
// =============================================================
// We keep this. It relates spread cost to volatility.
   double atrNorm = ms.atrStrength(atr);
   double tfScale = (_Period > 1) ? MathLog(_Period) : 1.0;

// DYNAMIC: Scale the cushion based on Strictness (Entry vs Mgmt)
// strictness 1.0 -> Divisor 12.0. strictness 0.8 -> Divisor 10.0.
   double cushionDiv = 12.0 * strictness;
   double atrCeiling = 12.0 * tfScale;
   double cushion = (atrCeiling / cushionDiv) * (1.0 - atrNorm);

   //Print("GATE 0: cushionDiv: "+cushionDiv+" atrCeiling: "+atrCeiling+" cushion: "+cushion);
   if((atr / util.getPipValue(_Symbol)) < (2.0 + cushion))
      return SAN_SIGNAL::NOTRADE;

// =============================================================
// 2. TREND POWER (The Universal Normalizer)
// =============================================================
   double adxRaw = iADX(NULL, 0, 14, PRICE_CLOSE, MODE_MAIN, 1);

// "Power 1.0" = ADX 20 (The universal baseline for "Alive")
   double trendPower = adxRaw / 20.0;
   //Print("GATE 1: adxRaw: "+adxRaw+" trendPower: "+trendPower + "(0.75 * strictness):"+(0.75 * strictness)+" bool: "+(trendPower < (0.75 * strictness)));
// GATE: Minimum Viable Trend
// Entry (1.0) requires Power > 0.75 (ADX 15).
// Management (0.8) requires Power > 0.5 (ADX 10).
   if(trendPower < (0.75 * strictness))
      return SAN_SIGNAL::NOTRADE;

// =============================================================
// 3. MOMENTUM PHYSICS
// =============================================================
   bool isAccelerating = (stdDevClose.val1 > stdDevOpen.val1);
   bool isExpanding = (stdDevClose.val1 > 0);

// "Runaway" is no longer a hard number. It's relative strength.
// If Trend is 50% stronger than baseline (ADX > 30), it's Runaway.
   bool isRunaway = (trendPower > 1.5);
   //Print("GATE 2: isAccelerating: "+isAccelerating+" isExpanding: "+isExpanding + "isExpanding:"+isExpanding+" isRunaway: "+isRunaway);
// =============================================================
// 4. DYNAMIC STRUCTURE (The "Sliding Threshold")
// =============================================================
   double denominator = (stdOpen < 0.00005) ? 0.00005 : stdOpen;
   double ratio = stdCp / denominator;

// BASE REQUIREMENT: 1.15 (Significant Expansion)
// DISCOUNT: We subtract from the requirement based on Trend Strength.
// - ADX 20 (Power 1.0) -> Discount 0.0 -> Req 1.15
// - ADX 30 (Power 1.5) -> Discount 0.1 -> Req 1.05
// - ADX 40 (Power 2.0) -> Discount 0.2 -> Req 0.95
   double trendDiscount = 0.20 * (trendPower - 1.0);

// Clamp the discount so we never require less than 1.0 (Holding)
   double dynamicThreshold = MathMax(1.0, 1.15 - trendDiscount);

// =============================================================
// 5. DECISION MATRIX
// =============================================================
   bool foundationSteady = (stdOpen < (atr * 0.25));
   bool hasMomentum = (isAccelerating || isRunaway);
   //Print("GATE 3: hasMomentum: "+hasMomentum+" foundationSteady: "+foundationSteady + "dynamicThreshold:"+dynamicThreshold+" dynamicThreshold: "+dynamicThreshold);
   if((ratio > (0.95 * strictness)) && hasMomentum)
     {
      //Print("GATE 4: hasMomentum: "+hasMomentum);
      if(strictness < 0.99)
         return SAN_SIGNAL::TRADE;

      //Print("GATE 5: hasMomentum: "+hasMomentum);
      if(isExpanding || isRunaway)
        {
         //Print("GATE 6:");
         // A. Sniper
         if(foundationSteady)
            return SAN_SIGNAL::TRADE;
         //Print("GATE 7:");
         // B. Dynamic Bulldozer
         // Now uses the auto-calculated threshold
         if(ratio > dynamicThreshold)
            return SAN_SIGNAL::TRADE;
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+-----------------'-------------------------------------------------+
   //Print("GATE 8:");
   return SAN_SIGNAL::NOTRADE;
  }


//SAN_SIGNAL SanSignals::volatilityMomentumSIG(
//   const DTYPE &stdDevOpen,
//   const DTYPE &stdDevClose,
//   const double stdOpen,
//   const double stdCp,
//   const double atr,
//   double strictness = 1.0
//)
//  {
//// =============================================================
//// 0. AUTO-TUNER: Detect Regime (Scalping vs Swing)
//// =============================================================
//   bool isScalping = (Period() < PERIOD_H1);
//
//// =============================================================
//// 1. TIMEFRAME-AGNOSTIC ATR FLOOR
//// =============================================================
//   double atrNorm = ms.atrStrength(atr);
//   double tfScale = (_Period > 1) ? MathLog(_Period) : 1.0;
//   double atrCeiling = 12.0 * tfScale;
//
//// TUNING: Use 15.0 (Loose) for Scalping, 12.0 (Strict) for Swing
//   double divFactor = isScalping ? 15.0 : 12.0;
//
//   double cushion = (atrCeiling / divFactor) * (1.0 - atrNorm);
//   double minATR_pips = 2.0 + cushion;
//
//   Print("GATE 0:");
//   if((atr / util.getPipValue(_Symbol)) < minATR_pips)
//      return SAN_SIGNAL::NOTRADE;
//
//   Print("GATE 1:"+minATR_pips);
//
//// =============================================================
//// 2. THE ADX GATE (Auto-Scaled)
//// =============================================================
//   double adxRaw = iADX(NULL, 0, 14, PRICE_CLOSE, MODE_MAIN, 1);
//
//   if(strictness > 0.9)
//     {
//      // TUNING: 15.0 for Scalping, 20.0 for Swing
//      double adxThreshold = isScalping ? 15.0 : 20.0;
//      Print("GATE 2: adxThreshold: "+adxThreshold+" adxRaw: "+adxRaw+" bool:  "+(adxRaw < adxThreshold));
//      if(adxRaw < adxThreshold)
//         return SAN_SIGNAL::NOTRADE;
//     }
//
//// =============================================================
//// 3. MOMENTUM GATES
//// =============================================================
//   bool isAccelerating = (stdDevClose.val1 > stdDevOpen.val1);
//   bool isExpanding = (stdDevClose.val1 > 0);
////bool isTrendy = (adxRaw > 30.0); // Universal "Runaway Trend" rule
////bool isTrendy = (adxRaw > (isScalping ? 25.0 : 30.0));
//   bool isTrendy = (adxRaw > (isScalping ? 22.0 : 26.0));
//
//// =============================================================
//// 4. STRUCTURE GATE
//// =============================================================
//                   double denominator = (stdOpen < 0.00005) ? 0.00005 : stdOpen;
//   double ratio = stdCp / denominator;
//   double requiredRatio = 0.95 * strictness;
//
//// =============================================================
//// 5. DECISION MATRIX
//// =============================================================
//   bool foundationSteady = (stdOpen < (atr * 0.25));
//   bool hasMomentum = (isAccelerating || isTrendy);
//
//   if((ratio > requiredRatio) && hasMomentum)
//     {
//      // Management Mode
//      if(strictness < 0.99)
//         return SAN_SIGNAL::TRADE;
//
//      // Entry Mode
//      if(isExpanding || isTrendy)
//        {
//         // A. Sniper (Quiet Start)
//         if(foundationSteady)
//            return SAN_SIGNAL::TRADE;
//
//         // B. Bulldozer (Noisy Start)
//         // M15 Adjustment: Lower requirement to 1.15
//
//         // *** THE FIX ***
//         // If we are in a Runaway Trend (isTrendy), we lower the bar.
//         // We don't need a 15% explosion. We just need to hold the line (> 1.0).
//
//         double bulldozerThreshold = (isTrendy) ? 1.0 : (isScalping ? 1.15 : 1.20);
//         Print("GATE 3: bulldozerThreshold: "+bulldozerThreshold+" ratio: "+ratio+" isTrendy: "+isTrendy+" isScalping:  "+isScalping);
//         //// *** THE FIX ***
//         //// If we are in a Runaway Trend (isTrendy), we lower the bar.
//         //// We don't need a 15% explosion. We just need to hold the line (> 1.0).
//         //if(isTrendy)
//         //   bulldozerThreshold = 1.0;
//
//         if(ratio > bulldozerThreshold)
//            return SAN_SIGNAL::TRADE;
//        }
//     }
//   return SAN_SIGNAL::NOTRADE;
//
//  }




//+------------------------------------------------------------------+
//| volatilityMomentumDirectionSIG — Wrapper                         |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| SIGNAL: Volatility Quality Filter                                |
//| Returns: BUY/SELL if Volatility supports the move.               |
//|          CLOSE if Volatility is chaotic (Open > Close).          |
//|          NOSIG if Volatility is contracting (Squeeze).
//           |
//| SIGNAL: Volatility + Direction Wrapper                           |
//| Purpose: Combines Market State (Vol) with Market Direction (Slope)|
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| volatilityMomentumDirectionSIG — The Directional Wrapper         |
//+------------------------------------------------------------------+
SAN_SIGNAL SanSignals::volatilityMomentumDirectionSIG(
   const DTYPE &stdDevOpen,
   const DTYPE &stdDevClose,
   const double stdOpen,
   const double stdCp,
   const double priceSlope,   // Directional Component
   const double atr = 0,
   double strictness = 1.0
)
  {
// --- STEP 1: The "Gate" (Physics & Magnitude) ---
// Does the market have enough energy to trade?
   SAN_SIGNAL volState = volatilityMomentumSIG(stdDevOpen, stdDevClose, stdOpen, stdCp, atr, strictness);
   Print("GATE 10: "+util.getSigString(volState)+" Price Slope: "+  priceSlope+ "buy: "+ (priceSlope > 1.0e-9)+"sell: "+(priceSlope < -1.0e-9));
// If the Gate is closed (Squeeze/Chop/Dead), we do not care about direction.
   if(volState == SAN_SIGNAL::NOTRADE)
      return SAN_SIGNAL::NOSIG;

// --- STEP 2: The "Compass" (Direction) ---
// The Gate is OPEN. Now we just need to know: Up or Down?

// We use a tiny epsilon just to avoid floating point errors around 0.0
// We DO NOT use a large threshold (like 0.0001) because the Volatility Gate
// has already guaranteed the move is significant.

   if(priceSlope > 1.0e-9) // Effectively > 0
      return SAN_SIGNAL::BUY;

   if(priceSlope < -1.0e-9) // Effectively < 0
      return SAN_SIGNAL::SELL;

// Rare edge case: Perfect zero slope despite high volatility (e.g., massive Doji)
   return SAN_SIGNAL::NOSIG;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CROSSOVER  SanSignals::signalCrossOver(
   const double & fast[],
   const double & slow[],
   const int period = 5,
   const int shift = 1
)
  {
   int above = 0;
   int below = 0;
   int multiple = 0;
   int crossOverBelowToAbove = 0;
   int crossOverAboveToBelow = 0;
   int crossOverMultiple = 0;
   for(int i = shift; i <= period; i++)
     {
      if((fast[i] < slow[i]) && (above == 0) && (multiple == 0))
        {
         below++;
        }
      else
         if((fast[i] > slow[i]) && (below > 0) && (above == 0) && (multiple == 0))
           {
            crossOverBelowToAbove++;
            above++;
           }
         else
            if((fast[i] > slow[i]) && (below > 0) && (above > 0) && (below > above))
              {
               crossOverMultiple++;
               crossOverBelowToAbove++;
              }
            else
               if((fast[i] > slow[i]) && (below > 0) && (above > 0) && (above > below))
                 {
                  crossOverMultiple++;
                  crossOverAboveToBelow++;
                 }
      if((fast[i] > slow[i]) && (below == 0) && (multiple == 0))
        {
         above++;
        }
      else
         if((fast[i] < slow[i]) && (above > 0) && (below == 0) && (multiple == 0))
           {
            crossOverAboveToBelow++;
            below++;
           }
         else
            if((fast[i] < slow[i]) && (above > 0) && (below > 0) && (above > below))
              {
               crossOverMultiple++;
               crossOverAboveToBelow++;
              }
            else
               if((fast[i] < slow[i]) && (above > 0) && (below > 0) && (below > above))
                 {
                  crossOverMultiple++;
                  crossOverBelowToAbove++;
                 }
     }
   if((crossOverMultiple > 0) && (crossOverBelowToAbove > 1) && (crossOverAboveToBelow > 1))
     {
      return CROSSOVER::MULTIPLE;
     }
   else
      if((crossOverMultiple == 0) && (crossOverBelowToAbove == 1) && (crossOverAboveToBelow == 0))
        {
         return CROSSOVER::BELOWTOABOVE;
        }
      else
         if((crossOverMultiple > 0) && (crossOverBelowToAbove == 0) && (crossOverAboveToBelow == 1))
           {
            return CROSSOVER::ABOVETOBELOW;
           }
   return CROSSOVER::NOCROSS;
  }

//+------------------------------------------------------------------+
//| ATR Signal                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL SanSignals::atrSIG(
   const double & atr[],
   const int period = 10
)
  {
   SAN_SIGNAL atrSIG = SAN_SIGNAL::NOSIG;
   double atrPips = NormalizeDouble((atr[1] / util.getPipValue(_Symbol)), 3);
   DTYPE atrSlope = slopeSIGData(atr, 5, 21, 1);
   double ATR_LOWERBOUND = EMPTY_VALUE;
   double ATR_LOWERBOUND_SLOPE = EMPTY_VALUE;
   double ATR_UPPERBOUND = EMPTY_VALUE;
   double ATR_UPPERBOUND_SLOPE = EMPTY_VALUE;
   double ATR_SLOPE = -0.3;
//double ATR_SLOPE = -0.1;
   double MULTIP = (_Period > 1) ? log(_Period) : _Period;
   double MULTIPADJUSTER = 5;
   ATR_LOWERBOUND = ceil(MULTIP);
   ATR_UPPERBOUND = ceil(MULTIPADJUSTER * MULTIP);
   if((atrSlope.val1 < ATR_SLOPE))
      atrSIG = SAN_SIGNAL::NOTRADE;
   if((atrSlope.val1 > ATR_SLOPE))
      atrSIG = SAN_SIGNAL::TRADE;
   if(atrPips < ATR_LOWERBOUND)
      atrSIG = SAN_SIGNAL::NOTRADE;
   if((atrPips > ATR_UPPERBOUND) && (atrSlope.val1 < ATR_SLOPE))
      atrSIG = SAN_SIGNAL::NOTRADE;
   if((atrPips > ATR_LOWERBOUND) && (atrSlope.val1 > ATR_SLOPE))
      atrSIG = SAN_SIGNAL::TRADE;
   if((atrPips > ATR_UPPERBOUND) && (atrSlope.val1 > ATR_SLOPE))
      atrSIG = SAN_SIGNAL::TRADE;
//Print("[ATR]: " + NormalizeDouble(atr[1], 3) + " LowerBound: " + ATR_LOWERBOUND + " UpperBound: " + ATR_UPPERBOUND + " Atr in pips: " + atrPips + " atrSlope: " + NormalizeDouble(atrSlope.val1, 3) + " atrSIG: " + util.getSigString(atrSIG));
   return atrSIG;
  }

////+------------------------------------------------------------------+
////|                                                                  |
////+------------------------------------------------------------------+
////SAN_SIGNAL SanSignals::atrSIG(
//SANTRENDSTRENGTH SanSignals::atrSIG(
//   const double &atr[],
//   const int period=10
//) {
//   const double ATRUPPERTRADELIMIT  = 0.7;
//   const double ATRMIDDLETRADELIMIT  = 0.3;
//   const double ATRLOWERTRADELIMIT  = 0.03;
//   double max = atr[ArrayMaximum(atr,period)];
//   double min = atr[ArrayMinimum(atr,period)];
//   double range = (max-min);
//   double lowerDiff = atr[1]-min;
//   double upperDiff = max - atr[1];
//   double ratio = EMPTY_VALUE;
//
//   if((lowerDiff==0)&&(upperDiff!=0)) {
//      //return SAN_SIGNAL::NOTRADE;
//      return SANTRENDSTRENGTH::WEAK;
//   }
//
//
//   if((lowerDiff!=0)&&(upperDiff==0)) {
//      //return SAN_SIGNAL::TRADE;
//      return SANTRENDSTRENGTH::SUPERHIGH;
//   }
//
//
//   if((lowerDiff!=0)&&(range!=0)) {
//      ratio = lowerDiff/range;
//   }
//
// Print("ATR current: "+ NormalizeDouble(atr[1],3)+" Atr in pips: "+ NormalizeDouble((atr[1]/util.getPipValue(_Symbol)),3)+" Max Atr: "+NormalizeDouble((max/util.getPipValue(_Symbol)),3)+" Min ATR: "+NormalizeDouble((min/util.getPipValue(_Symbol)),3)+" Ratio: "+ NormalizeDouble(ratio,3));
//
////Print("Max ATR: "+ max+" Minimum ATR: "+min+" Ratio: "+ ratio);
//
////  if(((lowerDiff!=0)&&(upperDiff!=0))&&((upperDiff/lowerDiff)<=ATRTRADELIMIT))
//   if((ratio!=EMPTY_VALUE)&&((ratio>=ATRMIDDLETRADELIMIT)&&(ratio<=ATRUPPERTRADELIMIT))) {
//      return SANTRENDSTRENGTH::HIGH;
//   } else if((ratio!=EMPTY_VALUE)&&((ratio>=ATRLOWERTRADELIMIT)&&(ratio<ATRMIDDLETRADELIMIT))) {
//      return SANTRENDSTRENGTH::NORMAL;
//   } else
//      // if(((lowerDiff!=0)&&(upperDiff!=0))&&((lowerDiff/upperDiff) <=ATRTRADELIMIT))
//      if((ratio!=EMPTY_VALUE)&&((ratio<ATRLOWERTRADELIMIT)||(ratio>ATRUPPERTRADELIMIT))) {
//         return SANTRENDSTRENGTH::WEAK;
//      }
//
//   return SANTRENDSTRENGTH::POOR;
//}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL SanSignals::volumeSIG(const double & vol[], const int arrsize = 10, const int shift = 1)
  {
   double sum = 0;
   double avg = 0;
   double volPercentage = 0;
   int count = (arrsize + shift);
   for(int i = shift; i < count; i++)
     {
      sum += vol[i];
     }
   avg = sum / count;
   volPercentage = vol[shift] / avg;
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
SAN_SIGNAL SanSignals::volumeSIG_v2(const double & vol[], const int arrsize = 10, const int VOLMIN = 11, const int shift = 1)
  {
   double sum1 = 0;
   double avg1 = 0;
   double sum2 = 0;
   double avg2 = 0;
//  const int VOLMIN = 11;
   double volPercentage = 0;
   double volPercentage2 = 0;
   int count = (arrsize);
   for(int i = shift; i < floor(count / 2); i++)
     {
      sum1 += vol[i];
     }
   avg1 = sum1 / floor(count / 2);
   for(int i = floor(count / 2); i < count; i++)
     {
      sum2 += vol[i];
     }
   avg2 = sum2 / floor(count / 2);
   volPercentage = avg1 / avg2;
   double volPerMin = (sum1 + sum2) / ArraySize(vol);
   double denom = 0;
   if(_Period == PERIOD_M1)
      denom = 1;
   if(_Period == PERIOD_M5)
      denom = 5;
   if(_Period == PERIOD_M15)
      denom = 15;
   if(_Period == PERIOD_M30)
      denom = 30;
   if(_Period == PERIOD_H1)
      denom = 60;
   if(_Period == PERIOD_H4)
      denom = 240;
   if(_Period == PERIOD_D1)
      denom = 1440;
   volPerMin = volPerMin / denom;
   bool volPerMinBool = (volPerMin > VOLMIN);
//Print("New tick vol avg: "+NormalizeDouble(avg1,2)+" old avg: "+NormalizeDouble(avg2,2)+" volPercentage: "+ NormalizeDouble(volPercentage,2)+" Vol per min: "+ NormalizeDouble(volPerMin,2)+" Denom: "+denom);
   if(!volPerMinBool)
     {
      if((volPercentage <= 0.4))
         return SAN_SIGNAL::REVERSETRADE;
      if((volPercentage > 0.4) && (volPercentage <= 0.6))
         return SAN_SIGNAL::NOTRADE;
     }
   if(volPerMinBool)
     {
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
SAN_SIGNAL SanSignals::volScatterSlopeSIG(const double & vol[], const int arrsize = 10, const double SLOPELIMIT = 0.1, const int SHIFT = 1)
  {
   SLOPETYPE st = stats.scatterPlot(vol, arrsize, SHIFT);
   if((st.slope > (-1 * SLOPELIMIT)) && (st.slope < (SLOPELIMIT)))
     {
      return SAN_SIGNAL::SIDEWAYS;
     }
   if(st.slope <= (-1 * SLOPELIMIT))
     {
      return SAN_SIGNAL::NOTRADE;
     }
   if(st.slope >= (SLOPELIMIT))
     {
      return SAN_SIGNAL::TRADE;
     }
   Print("VOLSLOPE: " + st.slope);
   return SAN_SIGNAL::CLOSE;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL SanSignals::priceActionCandleSIG(
   const double & open[],
   const double & high[],
   const double & low[],
   const double & close[],
   const uint shift = 1)
  {
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
   if((redCandle || noBodyTailCandle) && !fullBodyCandle && !noBodyCandle)
     {
      upperTail = (high[shift] - open[shift]);
      lowerTail = (close[shift] - low[shift]);
     }
   else
      if((greenCandle || noBodyTailCandle) && !fullBodyCandle && !noBodyCandle)
        {
         upperTail = (high[shift] - close[shift]);
         lowerTail = (open[shift] - low[shift]);
        }
   double body =  NormalizeDouble(fabs(open[shift] - close[shift]), _Digits);
   double candleRange =  NormalizeDouble(fabs(high[shift] - low[shift]), _Digits);
   double bodyRatio = (!noBodyTailCandle && !fullBodyCandle && !noBodyCandle && (body > 0) && (candleRange > 0)) ? NormalizeDouble((body / candleRange), 2) : NULL;
   bool tailDominates = (noBodyTailCandle || (bodyRatio <= 0.35));
   bool bodyDominates = (fullBodyCandle || (bodyRatio > 0.35)) ;
//   bool bodyDominates = (fullBodyCandle ||(bodyRatio > 0.65)) ;
//   Print("tailDominates: "+tailDominates+" bodyDominates: "+ bodyDominates+" body ratio: "+bodyRatio+" Candle range: "+candleRange);
   if(bodyDominates)
     {
      if(redCandle)
        {
         return SAN_SIGNAL::SELL;
        }
      if(greenCandle)
        {
         return SAN_SIGNAL::BUY;
        }
     }
   if(tailDominates)
     {
      if((upperTail == 0) && (lowerTail > 0))
         return SAN_SIGNAL::BUY;
      if((lowerTail == 0) && (upperTail > 0))
         return SAN_SIGNAL::SELL;
      if((upperTail != 0) && (lowerTail != 0) && (NormalizeDouble((fabs(upperTail) / fabs(lowerTail)), 2) <= 0.35))
         return SAN_SIGNAL::BUY;
      if((upperTail != 0) && (lowerTail != 0) && (NormalizeDouble((fabs(lowerTail) / fabs(upperTail)), 2) <= 0.35))
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
const SIGMAVARIABILITY SanSignals::stdDevSIG(const double & data[], string label = "", const int period = 10, const int shift = 1)
  {
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
   cpStdDev = stats.stdDev(data, shift, period);
   mean = stats.mean(data, period, shift);
   zScore = stats.zScore(data[shift], mean, cpStdDev);
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
   if((zScore == ZMEAN))
      return SIGMAVARIABILITY::SIGMA_MEAN;
   if((zScore >= (-1 * ZMEANRANGE)) && (zScore < ZMEAN))
      return SIGMAVARIABILITY::SIGMANEG_MEAN;
   if((zScore > ZMEAN) && (zScore <= ZMEANRANGE))
      return SIGMAVARIABILITY::SIGMAPOS_MEAN;
   if((zScore >= (-1 * ZHALFSIGMA)) && (zScore < (-1 * ZMEANRANGE))) //&&(data[shift]<data[shift+2]))
      return SIGMAVARIABILITY::SIGMANEG_HALF;
   if((zScore > ZMEANRANGE) && (zScore <= ZHALFSIGMA)) //&&(data[shift]>data[shift+2]))
      return SIGMAVARIABILITY::SIGMAPOS_HALF;
   if((zScore >= (-1 * Z10SIGMA)) && (zScore < (-1 * ZHALFSIGMA))) //&&(data[shift]<data[shift+2]))
      return SIGMAVARIABILITY::SIGMANEG_1;
   if((zScore > ZHALFSIGMA) && (zScore <= Z10SIGMA)) //&&(data[shift]>data[shift+2]))
      return SIGMAVARIABILITY::SIGMAPOS_1;
   if((zScore >= (-1 * Z16SIGMA)) && (zScore < (-1 * Z10SIGMA))) //&&(data[shift]<data[shift+2]))
      return SIGMAVARIABILITY::SIGMANEG_16;
   if((zScore > Z10SIGMA) && (zScore <= Z16SIGMA)) //&&(data[shift]>data[shift+2]))
      return SIGMAVARIABILITY::SIGMAPOS_16;
   if((zScore >= (-1 * Z20SIGMA)) && (zScore < (-1 * Z16SIGMA))) //&&(data[shift]<data[shift+2]))
      return SIGMAVARIABILITY::SIGMANEG_2;
   if((zScore > Z16SIGMA) && (zScore <= Z20SIGMA)) //&&(data[shift]>data[shift+2]))
      return SIGMAVARIABILITY::SIGMAPOS_2;
   if((zScore >= (-1 * Z30SIGMA)) && (zScore < (-1 * Z20SIGMA))) //&&(data[shift]<data[shift+2]))
      return SIGMAVARIABILITY::SIGMANEG_3;
   if((zScore > Z20SIGMA) && (zScore <= Z30SIGMA)) //&&(data[shift]>data[shift+2]))
      return SIGMAVARIABILITY::SIGMAPOS_3;
   if((zScore >= (-1 * Z35SIGMA)) && (zScore < (-1 * Z30SIGMA))) //&&(data[shift]<data[shift+2]))
      return SIGMAVARIABILITY::SIGMANEG_35;
   if((zScore > Z30SIGMA) && (zScore <= Z35SIGMA)) //&&(data[shift]>data[shift+2]))
      return SIGMAVARIABILITY::SIGMAPOS_35;
   if((zScore >= (-1 * ZRESTSIGMA)) && (zScore < (-1 * Z35SIGMA))) //&&(data[shift]<data[shift+2]))
      return SIGMAVARIABILITY::SIGMANEG_4;
   if((zScore > Z35SIGMA) && (zScore <= ZRESTSIGMA)) //&&(data[shift]>data[shift+2]))
      return SIGMAVARIABILITY::SIGMAPOS_4;
   if((zScore < (-1 * ZRESTSIGMA)))
      return SIGMAVARIABILITY::SIGMANEG_REST;
   if(zScore > ZRESTSIGMA)
      return SIGMAVARIABILITY::SIGMAPOS_REST;
   return SIGMAVARIABILITY::SIGMA_NULL;
  }


//+------------------------------------------------------------------+
//|                    NEW ONE                                              |
//+------------------------------------------------------------------+
TRENDSTRUCT SanSignals::acfStdSIG(const double & sig[], const int period = 10, const int shift = 1)
  {
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
   acf = stats.acf(sig, period, 1);
   stdDev = stats.stdDev(sig, 0, period) / tPoint;
   zScore = stats.zScore(sig[shift], mean, stdDev) / tPoint;
//bool flatSuperHighTrend = ((fabs(acf)<=0.1)&&((zScore>=LOWER_SUPERFLAT_ZSCORE)&&(zScore<=UPPER_SUPERFLAT_ZSCORE)));
//bool flatHighTrend = ((fabs(acf)<=0.2)&&((zScore>=LOWER_HIGHFLAT_ZSCORE)&&(zScore<=UPPER_HIGHFLAT_ZSCORE)));
//bool flatNormalTrend = ((fabs(acf)<=0.3)&&((zScore>=LOWER_NORMALFLAT_ZSCORE)&&(zScore<=UPPER_NORMALFLAT_ZSCORE)));
   bool flatSuperHighTrend = (fabs(acf) <= 0.1);
   bool flatHighTrend = ((fabs(acf) <= 0.2) && !flatSuperHighTrend);
   bool flatNormalTrend = ((fabs(acf) <= 0.3) && !flatHighTrend);
//Print(" ACF values: "+acf+" acf limit: "+tl.acfLimit + "super flat: "+flatSuperHighTrend+" high flat: "+flatHighTrend+" flat normal: "+ flatNormalTrend +" zScore: "+zScore);
   bool notFlat = (!flatNormalTrend && !flatHighTrend && !flatSuperHighTrend);
   bool aboveAcfLimit = ((fabs(acf) > tl.acfLimit) && notFlat);
//   bool conservativeUpTrend = (notFlat && ((fabs(acf)>tl.acfLimit)&&((zScore>UPPER_NORMALFLAT_ZSCORE) && (zScore<=UPPER_CONSERVATIVE_ZSCORE))));
//   bool conservativeDownTrend = (notFlat && ((fabs(acf)>tl.acfLimit)&&((zScore>=LOWER_CONSERVATIVE_ZSCORE) && (zScore<LOWER_NORMALFLAT_ZSCORE))));
//
//   bool spikeUpTrend = (notFlat && ((fabs(acf)>tl.acfLimit)&&((zScore>UPPER_CONSERVATIVE_ZSCORE) && (zScore<=UPPER_SSPIKE_ZSCORE))));
//   bool spikeDownTrend = (notFlat && ((fabs(acf)>tl.acfLimit)&&((zScore>=LOWER_SSPIKE_ZSCORE) && (zScore<LOWER_CONSERVATIVE_ZSCORE))));
//
//   bool superSpikeUpTrend = (notFlat && ((fabs(acf)>tl.acfLimit)&&(zScore>UPPER_SSPIKE_ZSCORE)));
//   bool superSpikeDownTrend = (notFlat && ((fabs(acf)>tl.acfLimit)&&(zScore<LOWER_SSPIKE_ZSCORE)));
   bool conservativeUpTrend = (aboveAcfLimit && ((zScore > UPPER_HIGHFLAT_ZSCORE) && (zScore <= UPPER_CONSERVATIVE_ZSCORE)));
   bool conservativeDownTrend = (aboveAcfLimit && ((zScore >= LOWER_CONSERVATIVE_ZSCORE) && (zScore < LOWER_HIGHFLAT_ZSCORE)));
   bool spikeUpTrend = (aboveAcfLimit && ((zScore > UPPER_CONSERVATIVE_ZSCORE) && (zScore <= UPPER_SSPIKE_ZSCORE)));
   bool spikeDownTrend = (aboveAcfLimit && ((zScore >= LOWER_SSPIKE_ZSCORE) && (zScore < LOWER_CONSERVATIVE_ZSCORE)));
   bool superSpikeUpTrend = (aboveAcfLimit && (zScore > UPPER_SSPIKE_ZSCORE));
   bool superSpikeDownTrend = (aboveAcfLimit && (zScore < LOWER_SSPIKE_ZSCORE));
   if(flatSuperHighTrend)
     {
      ts.closeTrendSIG = SANTREND::FLAT;
      ts.trendStrengthSIG = SANTRENDSTRENGTH::SUPERHIGH;
      return ts;
     }
   else
      if(flatHighTrend)
        {
         ts.closeTrendSIG = SANTREND::FLAT;
         ts.trendStrengthSIG = SANTRENDSTRENGTH::HIGH;
         return ts;
        }
      else
         if(flatNormalTrend)
           {
            ts.closeTrendSIG = SANTREND::FLAT;
            ts.trendStrengthSIG = SANTRENDSTRENGTH::NORMAL;
            return ts;
           }
         else
            if(superSpikeUpTrend)
              {
               ts.closeTrendSIG = SANTREND::UP;
               ts.trendStrengthSIG = SANTRENDSTRENGTH::SUPERHIGH;
               return ts;
              }
            else
               if(superSpikeDownTrend)
                 {
                  ts.closeTrendSIG = SANTREND::DOWN;
                  ts.trendStrengthSIG = SANTRENDSTRENGTH::SUPERHIGH;
                  return ts;
                 }
               else
                  if(spikeUpTrend)
                    {
                     ts.closeTrendSIG = SANTREND::UP;
                     ts.trendStrengthSIG = SANTRENDSTRENGTH::HIGH;
                     return ts;
                    }
                  else
                     if(spikeDownTrend)
                       {
                        ts.closeTrendSIG = SANTREND::DOWN;
                        ts.trendStrengthSIG = SANTRENDSTRENGTH::HIGH;
                        return ts;
                       }
                     else
                        if(conservativeUpTrend)
                          {
                           ts.closeTrendSIG = SANTREND::UP;
                           ts.trendStrengthSIG = SANTRENDSTRENGTH::NORMAL;
                           return ts;
                          }
                        else
                           if(conservativeDownTrend)
                             {
                              ts.closeTrendSIG = SANTREND::DOWN;
                              ts.trendStrengthSIG = SANTRENDSTRENGTH::NORMAL;
                              return ts;
                             }
   return ts;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL       SanSignals::closeOnLossSIG(const double lossAmt = 1.0, const int orderPos = 0)
  {
   double currspread = (int)MarketInfo(_Symbol, MODE_SPREAD);
   const double tPoint = Point();
   double adjustedLossAmt = NormalizeDouble((lossAmt + ((tl.spreadLimit * 5) * tPoint)), 2);
   adjustedLossAmt *= -1;
   if(OrderSelect(orderPos, SELECT_BY_POS) && (currspread < tl.spreadLimit) && (OrderProfit() < adjustedLossAmt))
     {
      return SAN_SIGNAL::CLOSE;
     }
   return SAN_SIGNAL::NOSIG;
  }
//

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL SanSignals::closeOnProfitPercentageSIG(const double currProfit, const double maxProfit, const double closeProfit, const double percentage = 0.05)
  {
//Print("[TAKEPROFIT] Take Profit: "+ closeProfit);
   const double tPoint = Point();
   double currspread = (int)MarketInfo(_Symbol, MODE_SPREAD);
//maxProfit = ((maxProfit!=EMPTY_VALUE)&&(maxProfit!=NULL))? maxProfit:0;
//closeProfit = ((closeProfit!=EMPTY_VALUE)&&(closeProfit!=NULL))? closeProfit:0;
   double adjustedMaxProfit = NormalizeDouble(maxProfit - ((tl.spreadLimit * 5) * tPoint), 2);
   double adjustedMaxProfitPercentage = NormalizeDouble((1 - percentage) * adjustedMaxProfit, 2);
   bool orderAndSpreadChk = ((OrdersTotal() > 0) && (currspread < tl.spreadLimit) && (adjustedMaxProfitPercentage > 0));
   bool profitLimitChk = ((adjustedMaxProfitPercentage > (1.2 * closeProfit)) && (currProfit < adjustedMaxProfitPercentage));
//  bool profitLimitChk = ((adjustedMaxProfitPercentage>closeProfit) && (currProfit<adjustedMaxProfitPercentage));
//Print("Current Profit: "+currProfit+" Max profit: "+maxProfit+" Adjusted profit: "+adjustedMaxProfit+" Percentage : "+ percentage+" of Adjusted profit: "+adjustedMaxProfitPercentage+" 1.2*closeProfit "+(1.2*closeProfit));
   if(orderAndSpreadChk && profitLimitChk)
     {
      return SAN_SIGNAL::CLOSE;
     }
   return SAN_SIGNAL::NOSIG;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL SanSignals::closeOnProfitSIG(const double currProfit, const double closeProfit = 0.02, const int pos = 0)
  {
//Print("Close profit value: "+ closeProfit);
   double currspread = (int)MarketInfo(_Symbol, MODE_SPREAD);
   bool orderAndSpreadChk = ((OrdersTotal() > 0) && (currProfit > closeProfit) && (currspread < tl.spreadLimit));
   if(OrderSelect(pos, SELECT_BY_POS) && (OrderProfit() > closeProfit) && (currspread < tl.spreadLimit))
      return SAN_SIGNAL::CLOSE;
   return SAN_SIGNAL::NOSIG;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL SanSignals::candleImaSIG(
   const double & open[],
   const double & close[],
   const double & imaHandle5[],
   const double & imaHandle14[],
   const double & imaHandle30[],
   const int period = 5,
   const int shift = 1
)
  {
   int buyCount = 0;
   int sellCount = 0;
   int flatCount = 0;
   int buyDoubleCount = 0;
   int sellDoubleCount = 0;
   int flatDoubleCount = 0;
   int buyTripleCount = 0;
   int sellTripleCount = 0;
   int flatTripleCount = 0;
   for(int i = shift; i < period; i++)
     {
      if((open[i] == close[i]) && (open[i + 2] == close[i + 2]))
         flatTripleCount++;
      if((close[i] > open[i]) && (close[i + 2] > open[i + 2]))
        {
         if(((imaHandle5[i + 2] >= open[i + 2]) && (imaHandle5[i] <= close[i])) && ((imaHandle14[i + 2] >= open[i + 2]) && (imaHandle14[i] <= close[i])) && ((imaHandle30[i + 2] >= open[i + 2]) && (imaHandle30[i] <= close[i])))
            buyTripleCount++;
        }
      if((close[i] < open[i]) && (close[i + 2] < open[i + 2]))
        {
         if(((imaHandle5[i + 2] <= open[i + 2]) && (imaHandle5[i] >= close[i])) && ((imaHandle14[i + 2] <= open[i + 2]) && (imaHandle14[i] >= close[i])) && ((imaHandle30[i + 2] <= open[i + 2]) && (imaHandle30[i] >= close[i])))
            sellTripleCount++;
        }
     }
   for(int i = shift; i < period; i++)
     {
      if((open[i] == close[i]) && (open[i + 1] == close[i + 1]))
         flatDoubleCount++;
      if((close[i] > open[i]) && (close[i + 1] > open[i + 1]))
        {
         if(((imaHandle5[i + 1] >= open[i + 1]) && (imaHandle5[i] <= close[i])) && ((imaHandle14[i + 1] >= open[i + 1]) && (imaHandle14[i] <= close[i])) && ((imaHandle30[i + 1] >= open[i + 1]) && (imaHandle30[i] <= close[i])))
            buyDoubleCount++;
        }
      if((close[i] < open[i]) && (close[i + 1] < open[i + 1]))
        {
         if(((imaHandle5[i + 1] <= open[i + 1]) && (imaHandle5[i] >= close[i])) && ((imaHandle14[i + 1] <= open[i + 1]) && (imaHandle14[i] >= close[i])) && ((imaHandle30[i + 1] <= open[i + 1]) && (imaHandle30[i] >= close[i])))
            sellDoubleCount++;
        }
     }
   for(int i = shift; i < period; i++)
     {
      if(open[i] == close[i])
         flatCount++;
      if(close[i] > open[i])
        {
         if(((imaHandle5[i] >= open[i]) && (imaHandle5[i] <= close[i])) && ((imaHandle14[i] >= open[i]) && (imaHandle14[i] <= close[i])) && ((imaHandle30[i] >= open[i]) && (imaHandle30[i] <= close[i])))
            buyCount++;
        }
      if(close[i] < open[i])
        {
         if(((imaHandle5[i] <= open[i]) && (imaHandle5[i] >= close[i])) && ((imaHandle14[i] <= open[i]) && (imaHandle14[i] >= close[i])) && ((imaHandle30[i] <= open[i]) && (imaHandle30[i] >= close[i])))
            sellCount++;
        }
     }
   bool buyTripleBool = ((buyTripleCount == 1) && (sellTripleCount == 0) && (flatTripleCount == 0));
   bool buyDoubleBool = ((buyDoubleCount == 1) && (sellDoubleCount == 0) && (flatDoubleCount == 0));
   bool buySingleBool = ((buyCount == 1) && (sellCount == 0) && (flatCount == 0));
   bool sellTripleBool = ((buyTripleCount == 0) && (sellTripleCount == 1) && (flatTripleCount == 0));
   bool sellDoubleBool = ((buyDoubleCount == 0) && (sellDoubleCount == 1) && (flatDoubleCount == 0));
   bool sellSingleBool = ((buyCount == 0) && (sellCount == 1) && (flatCount == 0));
   bool flatTripleBool = ((flatTripleCount >= 1) && (buyTripleCount == 0) && (sellTripleCount == 0));
   bool flatDoubleBool = ((flatDoubleCount >= 1) && (buyDoubleCount == 0) && (sellDoubleCount == 0));
   bool flatSingleBool = ((flatCount >= 1) && (buyCount == 0) && (sellCount == 0));
   bool buyBool = (buyTripleBool || buyDoubleBool || buySingleBool);
   bool sellBool = (sellTripleBool || sellDoubleBool || sellSingleBool);
   bool flatBool = (flatTripleBool || flatDoubleBool || flatSingleBool);
   if(flatBool)
      return SAN_SIGNAL::NOSIG;
   if(buyBool)
      return SAN_SIGNAL::BUY;
   if(sellBool)
      return SAN_SIGNAL::SELL;
   return SAN_SIGNAL::NOSIG;
  }
//
////+------------------------------------------------------------------+
////|                                                                  |
////+------------------------------------------------------------------+
//SAN_SIGNAL   SanSignals::candleVolSIG(
//   const double & open[],
//   const double & close[],
//   const double & vol[],
//   const int period = 10,
//   const int shift = 1
//) {
//   const double tPoint = Point();
//   const double LOWERLIMIT = 0.7;
//   const double UPPERLIMIT = 1.3;
//   double DOTPRODUCTSIZE = 10;
//   double diff[];
//   double redDotProduct = 0;
//   double greenDotProduct = 0;
//   double dotProduct = 0;
//   double dotProduct1 = 0;
//   double dotProduct2 = 0;
//   double ratio = EMPTY_VALUE;
//   ArrayResize(diff, (period + 1));
//   int timePeriod = 60;
//   if(_Period == PERIOD_M1) {
//      timePeriod = 60;
//      DOTPRODUCTSIZE = 20;
//   }
//   if(_Period == PERIOD_M5) {
//      timePeriod = (60 * 5);
//      DOTPRODUCTSIZE = 30;
//   }
//   if(_Period == PERIOD_M15) {
//      timePeriod = (60 * 15);
//      DOTPRODUCTSIZE = 50;
//   }
//   if(_Period == PERIOD_M30) {
//      timePeriod = (60 * 30);
//      DOTPRODUCTSIZE = 100;
//   }
//   if(_Period == PERIOD_H1) {
//      timePeriod = (60 * 60);
//      DOTPRODUCTSIZE = 200;
//   }
//   if(_Period == PERIOD_H4) {
//      timePeriod = (60 * 240);
//      DOTPRODUCTSIZE = 400;
//   }
//   if(_Period == PERIOD_D1) {
//      timePeriod = (60 * 1440);
//      DOTPRODUCTSIZE = 1440;
//   }
//   for(int i = shift, j = 0; i <= period; i++, j++)
//      //for(int i=shift,j=0; i<period; i++,j++)
//   {
//      diff[j] = ((close[i] - open[i]) / tPoint);
//      // dotProduct += (vol[i]*((diff[j]/10)/timePeriod));
//      // dotProduct1 += (vol[i]*((diff[j]/period)/timePeriod));
//      dotProduct += (vol[i] * ((diff[j] / (period * timePeriod))));
//      if(diff[j] < 0)
//         redDotProduct += fabs(vol[i] * diff[j]);
//      if(diff[j] > 0)
//         greenDotProduct += (vol[i] * diff[j]);
//      //  Print("Open values: "+(open[i])+" close values: "+ (close[i])+ " diff: "+diff[i]+" Volume: "+vol[i]);
//   }
////Print("Combined dot product: "+ (NormalizeDouble(dotProduct,2))+" DOTPRODUCTSIZE: "+DOTPRODUCTSIZE);
//   if((greenDotProduct == 0) && (redDotProduct > 0)) {
//      ratio = 0;
//   } else if((greenDotProduct > 0) && (redDotProduct == 0)) {
//      ratio = NormalizeDouble(greenDotProduct, 2);
//   } else if((greenDotProduct > 0) && (redDotProduct > 0)) {
//      ratio = NormalizeDouble((greenDotProduct / redDotProduct), 2);
//   }
//// Print(" Red dot: "+redDotProduct+" Green dot: "+greenDotProduct+" ratio: "+ratio);
//   if(((ratio >= LOWERLIMIT) && (ratio <= UPPERLIMIT)) || (fabs(dotProduct) < DOTPRODUCTSIZE)) {
//      return SAN_SIGNAL::SIDEWAYS;
//   } else if((ratio < LOWERLIMIT) && (dotProduct <= (-1 * DOTPRODUCTSIZE))) {
//      return SAN_SIGNAL::SELL;
//   } else if((ratio > UPPERLIMIT) && (dotProduct >= DOTPRODUCTSIZE)) {
//      return SAN_SIGNAL::BUY;
//   }
//   return SAN_SIGNAL::NOSIG;
//}
//
//
////+------------------------------------------------------------------+
////  h1 = sigmoid(tick1*price1 + bias)
////  h2 = sigmoid(Wh*h1 + tick2*price2 + bias)
////  sigmoid = 1/(1+e^-x)
////+------------------------------------------------------------------+
//
////+------------------------------------------------------------------+
////|                                                                  |
////+------------------------------------------------------------------+
//SAN_SIGNAL   SanSignals::candleVolSIG_v1(
//   const double & open[],
//   const double & close[],
//   const double & vol[],
//   const int period = 10,
//   const int shift = 1
//) {
//   const double tPoint = Point();
//   const double LOWERLIMIT = 0.8;
//   const double UPPERLIMIT = 1.2;
////   const double LOWERLIMIT = 0.7;
////   const double UPPERLIMIT = 1.3;
//   double DOTPRODUCTSIZE = 10;
//   double diff[];
//   double redDotProduct = 0;
//   double greenDotProduct = 0;
//   double dotProduct = 0;
////double dotProduct1=0;
////double dotProduct2=0;
//   double fastDotProduct = 0;
//   double slowDotProduct = 0;
//   double ratio = EMPTY_VALUE;
//   uint slowPeriod = period;
//   uint fastPeriod = (int)MathCeil(0.7 * period);
//   ArrayResize(diff, (slowPeriod + 1));
//   int timePeriod = 60;
//   if(_Period == PERIOD_M1) {
//      timePeriod = 60;
//      DOTPRODUCTSIZE = 20;
//   }
//   if(_Period == PERIOD_M5) {
//      timePeriod = (60 * 5);
//      DOTPRODUCTSIZE = 30;
//   }
//   if(_Period == PERIOD_M15) {
//      timePeriod = (60 * 15);
//      DOTPRODUCTSIZE = 50;
//   }
//   if(_Period == PERIOD_M30) {
//      timePeriod = (60 * 30);
//      DOTPRODUCTSIZE = 100;
//   }
//   if(_Period == PERIOD_H1) {
//      timePeriod = (60 * 60);
//      DOTPRODUCTSIZE = 200;
//   }
//   if(_Period == PERIOD_H4) {
//      timePeriod = (60 * 240);
//      DOTPRODUCTSIZE = 400;
//   }
//   if(_Period == PERIOD_D1) {
//      timePeriod = (60 * 1440);
//      DOTPRODUCTSIZE = 1440;
//   }
//   for(int i = shift, j = 0; i <= slowPeriod; i++, j++)
//      //for(int i=shift,j=0; i<period; i++,j++)
//   {
//      diff[j] = ((close[i] - open[i]) / tPoint);
//      // dotProduct += (vol[i]*((slowDiff[j]/10)/timePeriod));
//      // dotProduct1 += (vol[i]*((slowDiff[j]/period)/timePeriod));
//      slowDotProduct += (vol[i] * ((diff[j] / (period * timePeriod))));
//      if(i <= fastPeriod) {
//         fastDotProduct += slowDotProduct;
//         if(diff[j] < 0)
//            redDotProduct += fabs(vol[i] * diff[j]);
//         if(diff[j] > 0)
//            greenDotProduct += (vol[i] * diff[j]);
//      }
//   }
//   if((greenDotProduct == 0) && (redDotProduct > 0)) {
//      ratio = 0;
//   } else if((greenDotProduct > 0) && (redDotProduct == 0)) {
//      ratio = NormalizeDouble(greenDotProduct, 2);
//   } else if((greenDotProduct > 0) && (redDotProduct > 0)) {
//      ratio = NormalizeDouble((greenDotProduct / redDotProduct), 2);
//   }
//   bool sameSideBool = (((slowDotProduct > 0) && (fastDotProduct > 0)) || ((slowDotProduct < 0) && (fastDotProduct < 0)));
//   bool oppSideBuyBool = ((slowDotProduct < 0) && (fastDotProduct > 0));
//   bool oppSideSellBool = ((slowDotProduct > 0) && (fastDotProduct < 0));
//   bool oppSideBool = (oppSideBuyBool || oppSideSellBool);
//   bool flatBool = ((ratio >= LOWERLIMIT) && (ratio <= UPPERLIMIT));
//   bool varBool = ((ratio < LOWERLIMIT) || (ratio > UPPERLIMIT));
//   double prodRatio = 0;
//   prodRatio = (NormalizeDouble((slowDotProduct / fastDotProduct), 2));
//   bool prodSigBool = ((prodRatio > 0) && (prodRatio < 1.5));
//// Print(" Red dot: "+redDotProduct+" Green dot: "+greenDotProduct+" ratio: "+ratio);
//// Print("Slow dot product: "+ (NormalizeDouble(slowDotProduct,2))+" fast dotproduct: "+ (NormalizeDouble(fastDotProduct,2))+" Ratio: "+ratio+" prodRatio: "+prodRatio+" DPSIZE: "+DOTPRODUCTSIZE);
//   if(varBool && (prodRatio < 0) && oppSideBuyBool) {
//      //return SAN_SIGNAL::CLOSESELL;
//      //return SAN_SIGNAL::BUY;
//      return SAN_SIGNAL::CLOSE;
//   } else if(varBool && (prodRatio < 0) && oppSideSellBool) {
//      //return SAN_SIGNAL::CLOSEBUY;
//      //return SAN_SIGNAL::SELL;
//      return SAN_SIGNAL::CLOSE;
//   } else if(flatBool || (fabs(fastDotProduct) < DOTPRODUCTSIZE)) {
//      return SAN_SIGNAL::SIDEWAYS;
//   } else if((ratio < LOWERLIMIT) && (fastDotProduct <= (-1 * DOTPRODUCTSIZE)) && prodSigBool) {
//      return SAN_SIGNAL::SELL;
//   } else if((ratio > UPPERLIMIT) && (fastDotProduct >= DOTPRODUCTSIZE) && prodSigBool) {
//      return SAN_SIGNAL::BUY;
//   }
//   return SAN_SIGNAL::NOSIG;
//}



//+------------------------------------------------------------------+
//| singleCandleVolSIG - Final, bulletproof version                     |
//+------------------------------------------------------------------+
SAN_SIGNAL SanSignals::singleCandleVolSIG(
   const double &open[],
   const double &close[],
   const double &volume[],
   const double atr,
   int period = 30, int SHIFT = 1)
  {


   static datetime last_bar = 0;
   static SAN_SIGNAL cached = SAN_SIGNAL::NOSIG;
   if(Time[0] == last_bar)
      return cached;


   last_bar = Time[0];

   double atr_pips = atr / _Point;
//if(atr_pips < 8.0) {
//   cached = SAN_SIGNAL::NOSIG;
//   return cached;
//}
//double slow = stats.vWCM_Score(open, close, volume, period,0,SHIFT);
   double slow = ms.vWCM(open, close, volume, period,SHIFT);
   Print("[SLOWVCM]: "+slow);

   if((slow > -0.05)&&(slow < 0.1))
      cached = SAN_SIGNAL::NOSIG;
   if(slow >= 0.1)
      cached = SAN_SIGNAL::BUY;
   if(slow <= -0.05)
      cached = SAN_SIGNAL::SELL;

//cached = (slow > 0) ? SAN_SIGNAL::BUY : SAN_SIGNAL::SELL;

//PrintFormat("vWCM | ATR:%.1f pips | Slow:%.4f",
//            atr_pips, slow,
//            cached==BUY?"BUY":cached==SELL?"SELL":"NOSIG");

   return cached;
  }

//+------------------------------------------------------------------+
//| Ultra-fast, hang-proof candleVolSIG_v2 using your vWCM_Score     |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| candleVolSIG_v2 - Final, bulletproof version                     |
//+------------------------------------------------------------------+
SAN_SIGNAL SanSignals::candleVolSIG(
   const double &open[],
   const double &close[],
   const double &volume[],
   const double atr,
   int period = 30, int SHIFT = 1)
  {
   static datetime last_bar = 0;
   static SAN_SIGNAL cached = SAN_SIGNAL::NOSIG;

   if(Time[0] == last_bar)
      return cached;

   last_bar = Time[0];

   double atr_pips = atr / _Point;
//if(atr_pips < 8.0) {
//   cached = SAN_SIGNAL::NOSIG;
//   return cached;
//}

   int fast_n = (int)MathMax(10, period * 0.7);

//double slow = stats.vWCM_Score(open, close, volume, period,0,SHIFT);
//double fast = stats.vWCM_Score(open, close, volume, fast_n,0,SHIFT);
   double slow = ms.vWCM(open, close, volume, period,SHIFT);
   double fast = ms.vWCM(open, close, volume, fast_n,SHIFT);

   bool agree_dir  = (slow > 0 && fast > 0) || (slow < 0 && fast < 0);
   bool agree_str  = MathAbs(slow / (fast + 1e-10)) > 0.75;

   cached = (agree_dir && agree_str) ?
            (slow > 0 ? SAN_SIGNAL::BUY : SAN_SIGNAL::SELL) :
            SAN_SIGNAL::NOSIG;

   PrintFormat("vWCM | ATR:%.1f pips | Slow:%.4f Fast:%.4f → %s",
               atr_pips, slow, fast,
               cached==BUY?"BUY":cached==SELL?"SELL":"NOSIG");

   return cached;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
DTYPE SanSignals::candleVolDt(
   const double & open[],
   const double & close[],
   const double & vol[],
   const int period = 10,
   const int interval = 1,
   const int shift = 1
)
  {
   DTYPE candleDt;
   double candleBody[];
   ArrayResize(candleBody, period);
   for(int i = 0; i < period; i++)
     {
      candleBody[i] = ((close[i] - open[i])/util.getPipValue(_Symbol));
      //candleBody[i] = (close[i] - open[i]);
     }
   candleDt.val1 = stats.dotProd(candleBody, vol, period, interval, shift);

//candleDt.val1 = stats.vWCM_Score(open, close, vol, period, interval, shift);
//   Print("[DOT candle-vol: ]: "+ NormalizeDouble(candleDt.val1,3));
   return candleDt;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
DTYPE SanSignals::atrVolDt(
   const double & atr[],
   const double & vol[],
   const int period = 10,
   const int interval = 1,
   const int shift = 1
)
  {
   DTYPE atrvolDt;
   atrvolDt.val1 = stats.dotProd(atr, vol, period, interval, shift);
//  Print("[DOT atr-vol: ]: "+ NormalizeDouble(atrvolDt.val1,3));
   return atrvolDt;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
DTYPE SanSignals::openCloseDt(
   const double & open[],
   const double & close[],
   const int period = 10,
   const int interval = 1,
   const int shift = 1
)
  {
   DTYPE openCloseDt;
   openCloseDt.val1 = stats.dotProd(open, close, period, interval, shift);
   openCloseDt.val1 = NormalizeDouble((openCloseDt.val1 * util.getPipValue(_Symbol)), 3);
   Print("[DOT OpenClose: ]: " + NormalizeDouble(openCloseDt.val1, 3));
   return openCloseDt;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL   SanSignals::pVElastSIG(
   const double & open[],
   const double & close[],
   const double & vol[],
   const int period = 10,
   const int shift = 1
)
  {
   double elast[];
   ArrayResize(elast, (period + 1));
   for(int i = shift, j = 0; i <= period; i++, j++)
     {
      if(vol[i + 1] > 0)
        {
         if(((vol[i] - vol[i + 1]) / vol[i + 1]) == 0)
           {
            elast[j] = ((close[i] - close[i + 1]) / close[i + 1]);
           }
         if(((close[i] - close[i + 1]) / close[i + 1]) == 0)
           {
            elast[j] = 0;
           }
         if(((vol[i] - vol[i + 1]) / vol[i + 1]) > 0)
           {
            elast[j] = (((close[i] - close[i + 1]) / close[i + 1]) / ((vol[i] - vol[i + 1]) / vol[i + 1]));
           }
        }
      else
        {
         elast[j] = 0;
        }
     }
   Print("Elasticity 0 : " + NormalizeDouble(elast[0], 8) + " 1: " + (NormalizeDouble(elast[1], 8) / Point()) + " 2: " + (NormalizeDouble(elast[1], 8) / Point()) + " 10: " + (NormalizeDouble(elast[9], 8) / Point()) + " Mean: " + (NormalizeDouble((stats.mean(elast)), 8) / Point()));
   return SAN_SIGNAL::NOSIG;
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL  SanSignals::determinantVarSIG(
   const double & open[],
   const double & high[],
   const double & low[],
   const double & close[],
   const int DIM
)
  {
   double A[];
   const int ARRSIZE = (DIM * DIM);
   ArrayResize(A, ARRSIZE);
   int u = EMPTY;
//for(int i= 0; i<ARRSIZE; i+DIM) {
//   u = open[i];
//   A[i]=NormalizeDouble((u-open[i])*1000,2);
//   u = high[i];
//   A[i+1]=NormalizeDouble((u-high[i])*1000,2);
//   u = low[i];
//   A[i+2]=NormalizeDouble((u-low[i])*1000,2);
//   u = close[i];
//   A[i+3]=NormalizeDouble((u-close[i])*1000,2);
//}
   for(int i = 0; i < ARRSIZE; i)
     {
      u = close[i];
      A[i] = NormalizeDouble((u - close[i]) * 1000, 2);
     }
//ArrayCopy(A,data,0,0,ARRSIZE);
   double matrix2x2[] = {1, 2, 3, 4};
   double matrix3x3[] = {1, 2, 3, 4, 5, 6, 7, 8, 9};
   double matrix4x4[] = {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1};
   double matrix5x5[] = {1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1};
   double variability = stats.detLU(A, DIM);
//double variability = stats.detLU(data,DIM);
   Print("DETERMINANT VAR: " + (variability / 10000) + " sigmoid(x): " + (stats.sigmoid(variability / 10000)) + " tanh var: " + (stats.tanh(variability / 10000)));
   return SAN_SIGNAL::NOSIG;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL SanSignals::candleStar(
   const double & open[],
   const double & high[],
   const double & low[],
   const double & close[],
   const double candleBodySize = 0.1,
   const double slope = 0.6,
   const int period = 10,
   const int shift = 1
)
  {
   SAN_SIGNAL trendSig = SAN_SIGNAL::NOSIG;
   double cpSlope = EMPTY_VALUE;
   if(shift >= period)
      return SAN_SIGNAL::NOSIG;
   CandleCharacter cc(open, high, low, close, candleBodySize, shift);
//   DataTransport dt = stats.scatterPlotSlope(close);
//DataTransport dt = stats.scatterPlot(close);
   SLOPETYPE st = stats.scatterPlot(close);
   int lowCount = 0;
   int lowPriceCount = 0;
   int hiPriceCount = 0;
   int hiCount = 0;
   for(int i = shift; i <= period; i++)
     {
      if(low[shift] < low[i])
         ++lowCount;
      if(high[shift] > high[i])
         ++hiCount;
      if(cc.redCandle && (((open[i] > close[i]) && (close[shift] < close[i])) || ((open[i] < close[i]) && (close[shift] < open[i]))))
        {
         ++lowPriceCount;
        }
      if(cc.greenCandle && (((open[i] < close[i]) && (close[shift] > close[i])) || ((open[i] > close[i]) && (close[shift] > open[i]))))
        {
         ++hiPriceCount;
        }
     }
//   cpSlope = dt.matrixD[0];
   cpSlope = st.slope;
   bool starCandle = (cc.noBodyTailCandle || cc.noBodyCandle);
// Print("star candle: "+starCandle+" CC lower tail: "+cc.noBodyLowerTailCandle+" cc upper tail: "+cc.noBodyUpperTailCandle+" tail dominates "+cc.tailDominates+" Nobody: "+cc.noBodyCandle+" Nobody tail:"+cc.noBodyTailCandle+"Slope CP: "+ dt.matrixD[0]);
// Print("tail: "+cc.tailDominates+" body "+cc.bodyDominates+" body ratio: "+cc.bodyRatio+" range: "+cc.candleRange+" red: "+cc.redCandle+" green: "+cc.greenCandle);
// Print("tail: "+tailDominates+" body "+bodyDominates+" body ratio: "+bodyRatio+" range: "+candleRange+" red: "+redCandle+" green: "+greenCandle);
// Print("lowCount: "+lowCount+" lowPriceCount: "+lowPriceCount+" hiCount: "+hiCount+" hiPriceCount: "+hiPriceCount+" star candle:"+(cc.tailDominates||cc.noBodyTailCandle)+" bodyLowerTailCandle: "+cc.bodyLowerTailCandle+" bodyUpperTailCandle: "+ cc.bodyUpperTailCandle+" noBodyUpperTailCandle:"+cc.noBodyUpperTailCandle+" noBodyLowerTailCandle: "+cc.noBodyLowerTailCandle);
   if(starCandle && (cpSlope >= slope) && ((hiPriceCount == (period - shift)) && (hiCount == (period - shift))))
      return SAN_SIGNAL::SELL;
//return SAN_SIGNAL::REVERSETRADE;
   if(starCandle && (cpSlope <= -1 * slope) && ((lowPriceCount == (period - shift)) && (lowCount == (period - shift))))
      return SAN_SIGNAL::BUY;
//return SAN_SIGNAL::REVERSETRADE;
   return SAN_SIGNAL::NOSIG;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SANTREND SanSignals::trendScatterPlotSIG(const double & data[], string label = "", const double slope = 0.3, const int period = 10, const int shift = 1)
  {
//DataTransport d = stats.scatterPlot(data,period,1);
//double dataSlope = d.matrixD[0];
   SLOPETYPE s = stats.scatterPlot(data, period, 1);
   double dataSlope = (s.slope / util.getPipValue(_Symbol));
//Print("[SCATTERPLOT SLOPE: ]: "+ dataSlope);
// Print("["+label+"]: "+dataSlope);
   if((dataSlope > (-1 * slope)) && (dataSlope < (slope)))
     {
      return SANTREND::FLAT;
     }
   else
      if(dataSlope >= slope)
        {
         return SANTREND::UP;
        }
      else
         if(dataSlope <= (-1 * slope))
           {
            return SANTREND::DOWN;
           }
   return SANTREND::NOTREND;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SANTREND SanSignals::trendRatioSIG(const double & sig[], string label = "", const double slopeRatio = 2, const int period = 10, const int shift = 1)
  {
   SANTREND trendSig = SANTREND::NOTREND;
//   Print("trendRatioSIG: ima30 current 1: "+sig[1]+" :ima30 5: "+ sig[5]+" :ima30 10: "+ sig[10]+" :21:" + sig[21] );
   double up = 0;
   double flat = 0;
   double down = 0;
   double ratio = 0;
   double ratioDown = 0;
   for(int i = shift; i <= period; i++)
     {
      // Print("Sig[i]: "+ sig[i]+" sig[period]: "+ sig[period]+" (i>period): "+(sig[i]>sig[period])+" period>i: "+(sig[i]<sig[period]));
      if(sig[i] > sig[period])
         up++;
      if(sig[i] < sig[period])
         down++;
      if(sig[i] == sig[period])
         flat++;
     }
   if((up > 0) && (down > 0))
     {
      ratio = (up / down);
      ratioDown = (down / up);
     }
   else
      if((up == 0) && (down > 0))
        {
         ratio = 0;
         ratioDown = period;
        }
      else
         if((up > 0) && (down == 0))
           {
            ratio = period;
            ratioDown = 0;
           }
         else
            if((up == 0) && (down == 0))
              {
               ratio = 0;
               ratioDown = 0;
              }
   SIGMAVARIABILITY s1 = stdDevSIG(sig, "", period, shift);
//bool variabilityBool1 = ((s1!=SIGMAVARIABILITY::SIGMA_MEAN)&&(s1!=SIGMAVARIABILITY::SIGMA_HALF)&&(s1!=SIGMAVARIABILITY::SIGMA_1));
//bool variabilityBool2 = ((s1>SIGMAVARIABILITY::SIGMA_1)&&(s1<=SIGMAVARIABILITY::SIGMA_REST));
//bool variabilityBool = (variabilityBool1 && variabilityBool2);
//double variabilityVal = util.getSigVariabilityBool(s1,label);
   double variabilityVal = util.getSigVarBool(s1);
//Print("Variablity value:: "+ variabilityVal);
   bool flatBool = (((ratio >= 0.7) && (ratio <= 1.3)) || ((ratioDown >= 0.7) && (ratioDown <= 1.3)));
   const double POSVAR = 1.314;
   const double NEGVAR = -1.314;
   bool variabilityBool = ((variabilityVal != 0) && ((variabilityVal == POSVAR) || (variabilityVal == NEGVAR)));
   bool variabilityPosBool = ((variabilityVal != 0) && (variabilityVal == POSVAR));
   bool variabilityNegBool = ((variabilityVal != 0) && (variabilityVal == NEGVAR));
   bool noVarBool = (variabilityVal == 0);
//Print("Up: "+up+" Down: "+down+" ratio: "+ratio+" Ratioup: "+ratioUp+" ratioDown: "+ratioDown + " STD of signal: " + util.getSigString(s1));
//   Print("["+label+"] up: "+up+" down: "+down+" ratio: "+ratio+" ratioDown: "+ratioDown+" sig[shift]"+sig[shift]+" sig[period]"+sig[period]+ " variabilityBool: "+variabilityBool);
   if(flatBool)
     {
      trendSig = SANTREND::FLAT;
      return trendSig;
     }
   else
      if((variabilityBool) && (((ratio < slopeRatio) && (ratioDown < slopeRatio)) || flatBool))
        {
         trendSig = SANTREND::FLAT;
         return trendSig;
        }
      else
         if(variabilityPosBool && (ratio >= slopeRatio))
           {
            trendSig = SANTREND::UP;
            return trendSig;
           }
         else
            if(variabilityNegBool && (ratioDown >= slopeRatio))
              {
               trendSig = SANTREND::DOWN;
               return trendSig;
              }
            else
               if((noVarBool)  && (ratioDown >= slopeRatio))
                 {
                  trendSig = SANTREND::DOWN;
                  return trendSig;
                 }
               else
                  if((noVarBool) && (ratio >= slopeRatio))
                    {
                     trendSig = SANTREND::UP;
                     return trendSig;
                    }
                  else
                     if((noVarBool) && ((ratio >= 0.7) && (ratio <= 1.3)))
                       {
                        trendSig = SANTREND::FLAT;
                        return trendSig;
                       }
                     else
                        if((noVarBool) && (ratio < slopeRatio) && (ratio > ratioDown) && !flatBool)
                          {
                           trendSig = SANTREND::FLATUP;
                           return trendSig;
                          }
                        else
                           if((noVarBool) && (ratioDown < slopeRatio) && (ratioDown > ratio) && !flatBool)
                             {
                              trendSig = SANTREND::FLATDOWN;
                              return trendSig;
                             }
   return trendSig;
  };


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TRENDSTRUCT SanSignals::trendVolRatioSIG(const double & sig[], const double & vol[], const int period = 10, const int shift = 1)
  {
   TRENDSTRUCT ts;
   double up = 0;
   double flat = 0;
   double down = 0;
   double ratio = 0;
   double ratioUp = 0;
   double ratioDown = 0;
   for(int i = shift; i <= period; i++)
     {
      if((sig[i]*vol[i]) > (sig[period]*vol[period]))
         up++;
      if((sig[i]*vol[i]) < (sig[period]*vol[period]))
         down++;
      if((sig[i]*vol[i]) == (sig[period]*vol[period]))
         flat++;
     }
   if((up > 0) && (down > 0))
     {
      ratio = (up / down);
      ratioUp = (up / down);
      ratioDown = (down / up);
     }
   else
      if((up == 0) && (down > 0))
        {
         ratio = 0;
         ratioUp = 0;
         ratioDown = period;
        }
      else
         if((up > 0) && (down == 0))
           {
            ratio = period;
            ratioUp = period;
            ratioDown = 0;
           }
         else
            if((up == 0) && (down == 0))
              {
               ratio = 0;
               ratioUp = 0;
               ratioDown = 0;
              }
   SIGMAVARIABILITY s1 = stdDevSIG(sig, "", period, shift);
   bool validSigmaRange = ((s1 != SIGMAVARIABILITY::SIGMA_NULL) && (s1 != SIGMAVARIABILITY::SIGMA_MEAN) && (s1 != SIGMAVARIABILITY::SIGMAPOS_MEAN) && (s1 != SIGMAVARIABILITY::SIGMANEG_MEAN) && (s1 != SIGMAVARIABILITY::SIGMAPOS_HALF) && (s1 != SIGMAVARIABILITY::SIGMANEG_HALF));
//Print("Up: "+up+" Down: "+down+" ratio: "+ratio+" Ratioup: "+ratioUp+" ratioDown: "+ratioDown + " STD of signal: " + util.getSigString(s1));
   if(validSigmaRange)
     {
      if((ratioUp >= 3))
        {
         ts.closeTrendSIG = SANTREND::UP;
         ts.trendStrengthSIG = SANTRENDSTRENGTH::SUPERHIGH;
         return ts;
        }
      else
         if(ratioDown >= 3)
           {
            ts.closeTrendSIG = SANTREND::DOWN;
            ts.trendStrengthSIG = SANTRENDSTRENGTH::SUPERHIGH;
            return ts;
           }
         else
            if(ratioUp >= 2)
              {
               ts.closeTrendSIG = SANTREND::UP;
               ts.trendStrengthSIG = SANTRENDSTRENGTH::HIGH;
               return ts;
              }
            else
               if(ratioDown >= 2)
                 {
                  ts.closeTrendSIG = SANTREND::DOWN;
                  ts.trendStrengthSIG = SANTRENDSTRENGTH::HIGH;
                  return ts;
                 }
     }
   else
      if((s1 == SIGMAVARIABILITY::SIGMAPOS_HALF) || (s1 == SIGMAVARIABILITY::SIGMANEG_HALF) || (s1 == SIGMAVARIABILITY::SIGMA_MEAN) || (s1 == SIGMAVARIABILITY::SIGMAPOS_MEAN) || (s1 == SIGMAVARIABILITY::SIGMANEG_MEAN))
        {
         if((ratio >= 0.9) && (ratio <= 1.1))
           {
            ts.closeTrendSIG = SANTREND::FLAT;
            ts.trendStrengthSIG = SANTRENDSTRENGTH::SUPERHIGH;
            return ts;
           }
         else
            if((ratio >= 0.8) && (ratio <= 1.2))
              {
               ts.closeTrendSIG = SANTREND::FLAT;
               ts.trendStrengthSIG = SANTRENDSTRENGTH::HIGH;
               return ts;
              }
            else
               if((ratio >= 0.7) && (ratio <= 1.3))
                 {
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
SANTREND SanSignals::trendSlopeSIG(const double & data[], string label = "", const int period = 10, const int shift = 1)
  {
   double slope[];
   double x[];
   ArrayResize(slope, (period + 1));
   ArrayResize(x, (period + 1));
//  double ZSCORERANGE_TRADE = 1.7;
//double ZSCORERANGE_TRADE = 2.0;
   double ZSCORERANGE_TRADE = 5.0;
//   double ZSCORERANGE_FLAT = 0.5;
   double ZSCORERANGE_FLAT = 0.1;
   double FLATNESS = 0.001;
   double stdDev = EMPTY_VALUE;
   double mean = EMPTY_VALUE;
   double zScore = EMPTY_VALUE;
   double range = data[ArrayMaximum(data)] - data[ArrayMinimum(data)];
   for(int k = (period + 1), i = 0; k >= shift; k--, i++)
     {
      x[i] = k;
     }
   for(int i = shift, j = 0; i <= period; i++, j++)
     {
      slope[j] = ((x[i] - shift) != 0) ? ((data[i] - data[period]) / (x[i] - shift)) : 0;
     }
   stdDev = stats.stdDev(slope);
   mean = stats.mean(slope);
   zScore = stats.zScore(slope[0], mean, stdDev);
//   DataTransport dt = stats.scatterPlot(data);
   bool zScoreFlatRange = ((zScore >= (-1 * ZSCORERANGE_FLAT)) && (zScore <= (1 * ZSCORERANGE_FLAT)));
   bool zScoreTradeRange = (!zScoreFlatRange && (zScore >= (-1 * ZSCORERANGE_TRADE)) && (zScore <= (1 * ZSCORERANGE_TRADE)));
   bool down = ((slope[0] < 0) && zScoreTradeRange);
   bool up = ((slope[0] > 0) && zScoreTradeRange);
   bool flat1 = (((mean == 0) || (slope[0] == 0) || ((mean >= -0.001) && (mean <= 0.001)) || ((slope[0] >= -0.001) && (slope[0] <= 0.001))) && zScoreFlatRange);
//   bool flat2 = (((dt.matrixD[0]==0)||((dt.matrixD[0]>=-0.001)&&(dt.matrixD[0]<=0.001))) && zScoreFlatRange);
//   bool flat3 = ((mean==0)||(slope[0]==0)||(dt.matrixD[0]==0)|| zScoreFlatRange);
   bool flat3 = ((mean == 0) || (slope[0] == 0) || zScoreFlatRange);
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
     }
   else
      if(up)
        {
         return SANTREND::UP;
        }
      else
         if(down)
           {
            return SANTREND::DOWN;
           }
   return SANTREND::NOTREND;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL SanSignals::tradeVolVarSignal(const SAN_SIGNAL volSIG, const SIGMAVARIABILITY varFast, const SIGMAVARIABILITY varMedium, const SIGMAVARIABILITY varSlow, const SIGMAVARIABILITY varVerySlow = SIGMAVARIABILITY::SIGMA_NULL)
  {
   SAN_SIGNAL trade = SAN_SIGNAL::NOTRADE;
   double varFastVal = util.getSigVarBool(varFast);
   bool varFastBool = ((varFastVal != 0) && ((varFastVal == 1.314) || (varFastVal == -1.314)));
   bool varFastPosBool = ((varFastVal != 0) && (varFastVal == 1.314));
   bool varFastNegBool = ((varFastVal != 0) && (varFastVal == -1.314));
   double varMediumVal = util.getSigVarBool(varMedium);
   bool varMediumBool = ((varMediumVal != 0) && ((varMediumVal == 1.314) || (varMediumVal == -1.314)));
   bool varMediumPosBool = ((varMediumVal != 0) && (varMediumVal == 1.314));
   bool varMediumNegBool = ((varMediumVal != 0) && (varMediumVal == -1.314));
   double varSlowVal = util.getSigVarBool(varSlow);
   bool varSlowBool = ((varSlowVal != 0) && ((varSlowVal == 1.314) || (varSlowVal == -1.314)));
   bool varSlowPosBool = ((varSlowVal != 0) && (varSlowVal == 1.314));
   bool varSlowNegBool = ((varSlowVal != 0) && (varSlowVal == -1.314));
//bool flatBool = ((varFastVal==0)&&(varMediumVal==0)&&(varSlowVal==0));
   bool flatBool = ((varSlowVal == 0));
   bool varBool = (varFastBool && varMediumBool && varSlowBool);
   bool varPosBool = (varBool && (varFastPosBool && varMediumPosBool && varSlowPosBool));
   bool varNegBool = (varBool && (varFastNegBool && varMediumNegBool && varSlowNegBool));
   if(varVerySlow != SIGMAVARIABILITY::SIGMA_NULL)
     {
      flatBool = (util.getSigVarBool(varVerySlow) == 0);
      varBool = (varBool && ((util.getSigVarBool(varVerySlow) != 0) && ((util.getSigVarBool(varVerySlow) == 1.314) || (util.getSigVarBool(varVerySlow) == -1.314))));
      varPosBool = (varPosBool && ((util.getSigVarBool(varVerySlow) != 0) && (util.getSigVarBool(varVerySlow) == 1.314)));
      varNegBool = (varNegBool && ((util.getSigVarBool(varVerySlow) != 0) && (util.getSigVarBool(varVerySlow) == -1.314)));
     }
   if((volSIG == SAN_SIGNAL::NOTRADE) || (volSIG == SAN_SIGNAL::REVERSETRADE) || (volSIG == SAN_SIGNAL::CLOSE))
      return volSIG;
   if(flatBool)
      return SAN_SIGNAL::SIDEWAYS;
   if((volSIG == SAN_SIGNAL::TRADE) && varBool && varPosBool)
      return SAN_SIGNAL::BUY;
   if((volSIG == SAN_SIGNAL::TRADE) && varBool && varNegBool)
      return SAN_SIGNAL::SELL;
   return trade;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL        trendSIG(SANTREND tr1, SANTREND tr2, SANTREND tr3, SANTREND tr4 = EMPTY, SANTREND tr5 = EMPTY, SANTREND tr6 = EMPTY)
  {
//Print("[TRSIGIN] tr1: "+util.getSigString(tr1)+" tr2: "+util.getSigString(tr2)+" tr3: "+util.getSigString(tr3)+" tr4: "+util.getSigString(tr4)+" tr5: "+util.getSigString(tr5)+" tr6: "+util.getSigString(tr6));
   if((tr1 == SANTREND::NOTREND)
      || (tr2 == SANTREND::NOTREND)
      || (tr3 == SANTREND::NOTREND)
      || (tr4 == SANTREND::NOTREND)
      || (tr5 == SANTREND::NOTREND)
      || (tr6 == SANTREND::NOTREND)
     )
     {
      return SAN_SIGNAL::NOSIG;
     }
   if(
      (
         ((tr1 == SANTREND::FLAT) || (tr1 == SANTREND::FLATUP) || (tr1 == SANTREND::FLATDOWN))
         && ((tr2 == SANTREND::FLAT) || (tr2 == SANTREND::FLATUP) || (tr2 == SANTREND::FLATDOWN))
      )
      || ((tr3 == SANTREND::FLAT) || (tr3 == SANTREND::FLATUP) || (tr3 == SANTREND::FLATDOWN))
      || ((tr4 == SANTREND::FLAT) || (tr4 == SANTREND::FLATUP) || (tr4 == SANTREND::FLATDOWN))
      || ((tr5 == SANTREND::FLAT) || (tr5 == SANTREND::FLATUP) || (tr5 == SANTREND::FLATDOWN))
      || ((tr6 == SANTREND::FLAT) || (tr6 == SANTREND::FLATUP) || (tr6 == SANTREND::FLATDOWN))
   )
     {
      return SAN_SIGNAL::SIDEWAYS;
     }
   if(
      ((tr6 != EMPTY) && (tr6 != SANTREND::NOTREND) && (tr1 != SANTREND::NOTREND) && (tr2 != SANTREND::NOTREND))
      && (
         (util.oppSignal(util.convTrendToSig(tr1), util.convTrendToSig(tr6)))
         || (util.oppSignal(util.convTrendToSig(tr2), util.convTrendToSig(tr6)))
      )
   )
     {
      return SAN_SIGNAL::CLOSE;
     }
   else
      if(
         ((tr5 != EMPTY) && (tr5 != SANTREND::NOTREND) && (tr1 != SANTREND::NOTREND) && (tr2 != SANTREND::NOTREND))
         && (
            (util.oppSignal(util.convTrendToSig(tr1), util.convTrendToSig(tr5)))
            || (util.oppSignal(util.convTrendToSig(tr2), util.convTrendToSig(tr5)))
         )
      )
        {
         return SAN_SIGNAL::CLOSE;
        }
      else
         if(
            ((tr4 != EMPTY) && (tr4 != SANTREND::NOTREND) && (tr1 != SANTREND::NOTREND) && (tr2 != SANTREND::NOTREND))
            && (
               (util.oppSignal(util.convTrendToSig(tr1), util.convTrendToSig(tr4)))
               || (util.oppSignal(util.convTrendToSig(tr2), util.convTrendToSig(tr4)))
            )
         )
           {
            return SAN_SIGNAL::CLOSE;
           }
         else
            if(
               ((tr3 != SANTREND::NOTREND) && (tr1 != SANTREND::NOTREND) && (tr2 != SANTREND::NOTREND))
               && (
                  (util.oppSignal(util.convTrendToSig(tr1), util.convTrendToSig(tr3)))
                  && (util.oppSignal(util.convTrendToSig(tr2), util.convTrendToSig(tr3)))
               )
            )
              {
               return SAN_SIGNAL::CLOSE;
              }
            else
               if(
                  ((tr1 != SANTREND::NOTREND) && (tr2 != SANTREND::NOTREND))
                  && (util.oppSignal(util.convTrendToSig(tr1), util.convTrendToSig(tr2)))
               )
                 {
                  return SAN_SIGNAL::CLOSE;
                 }
   if((tr1 != SANTREND::NOTREND)
      && (
         ((tr6 != EMPTY) && (tr5 != EMPTY) && (tr4 != EMPTY) && (tr1 == tr2) && (tr2 == tr3) && (tr3 == tr4) && (tr4 == tr5) && (tr5 == tr6))
         || ((tr6 == EMPTY) && (tr5 != EMPTY) && (tr4 != EMPTY) && (tr1 == tr2) && (tr2 == tr3) && (tr3 == tr4) && (tr4 == tr5))
         || ((tr5 == EMPTY) && (tr4 != EMPTY) && (tr1 == tr2) && (tr2 == tr3) && (tr3 == tr4))
         || ((tr5 == EMPTY) && (tr4 == EMPTY) && (tr1 == tr2) && (tr2 == tr3))
      )
     )
     {
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
SAN_SIGNAL SanSignals::tradeSignal(const double ciStd, const double ciMfi, const double & atr[], const double ciAdxMain, const double ciAdxPlus, const double ciAdxMinus)
  {
   double currspread = (int)MarketInfo(_Symbol, MODE_SPREAD);
   SAN_SIGNAL trade = SAN_SIGNAL::NOTRADE;
   SAN_SIGNAL adxsig = SAN_SIGNAL::NOSIG;
//   SANTRENDSTRENGTH atrsig = SANTRENDSTRENGTH::POOR;
   SAN_SIGNAL atrsig = SAN_SIGNAL::NOTRADE;
   adxsig = adxSIG(ciAdxMain, ciAdxPlus, ciAdxMinus);
   atrsig = atrSIG(atr, 10);
   bool spreadB = (currspread < tl.spreadLimit);
   bool stdDevB = (ciStd > tl.stdDevLimit);
   bool mfiB = (ciMfi > tl.mfiLowerLimit);
   bool adxB = ((adxsig == SAN_SIGNAL::BUY) || (adxsig == SAN_SIGNAL::SELL));
   bool atrB = (atrsig == SAN_SIGNAL::TRADE);
//   bool atrB = ((atrsig==SANTRENDSTRENGTH::NORMAL)||(atrsig==SANTRENDSTRENGTH::HIGH));
//   bool indicatorBool = ((currspread < tl.spreadLimit) &&(ciStd > tl.stdDevLimit) && (ciMfi > tl.mfiLimit)&&((adxsig==SAN_SIGNAL::BUY)||(adxsig==SAN_SIGNAL::SELL))&&(atrsig==SAN_SIGNAL::TRADE));
   bool indicatorBool = (spreadB && stdDevB && mfiB && adxB && atrB);
   if(indicatorBool)
      trade = SAN_SIGNAL::TRADE;
   return trade;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL SanSignals::mfiSIG(const double & sig[], SANTREND tradeTrend = SANTREND::NOTREND, const int period = 10, const int shift = 1)
  {
   SANTREND mfiTrend = SANTREND::NOTREND;
   SANTREND scatterMfiTrend = SANTREND::NOTREND;
   SAN_SIGNAL mfiTrendSIG = SAN_SIGNAL::NOSIG;
   SAN_SIGNAL mfISIG = SAN_SIGNAL::NOSIG;
//mfiTrend = trendSlopeSIG(sig,"MFI",period);
// mfiTrend = trendSlopeSIG(sig,"MFI",period);
//  scatterMfiTrend = trendScatterPlotSIG(sig,"Scatter-MFI",0.02,5);
   mfiTrend = acfStdSIG(sig, 5, shift).closeTrendSIG;
//mfiTrendSIG = util.convTrendToSig(mfiTrend);
//bool sellBool1 = ((((mfiTrend==SANTREND::FLAT)||(mfiTrend==SANTREND::DOWN))&&(sig[shift]<=tl.mfiLowerLimit))||(mfiTrend==SANTREND::DOWN));
//bool buyBool1 = ((((mfiTrend==SANTREND::FLAT)||(mfiTrend==SANTREND::UP))&&(sig[shift]>=tl.mfiUpperLimit))||(mfiTrend==SANTREND::UP));
   bool mfiRegion = ((sig[shift] <= tl.mfiLowerLimit) || (sig[shift] >= tl.mfiUpperLimit));
   bool notMfiRegion = ((sig[shift] > tl.mfiLowerLimit) && (sig[shift] < tl.mfiUpperLimit));
   bool mfiFlatBool = (mfiTrend == SANTREND::FLAT);
   bool sellBool1 = (mfiTrend == SANTREND::DOWN);
   bool sellBool2 = ((sig[shift] <= tl.mfiLowerLimit) && (mfiTrend == SANTREND::DOWN));
   bool sellBool3 = ((sig[shift] >= tl.mfiUpperLimit) && (mfiTrend == SANTREND::DOWN));
   bool sellBool4 = ((sig[shift] <= tl.mfiLowerLimit) && mfiFlatBool);
   bool buyBool1 = (mfiTrend == SANTREND::UP);
   bool buyBool2 = ((sig[shift] >= tl.mfiUpperLimit) && (mfiTrend == SANTREND::UP));
   bool buyBool3 = ((sig[shift] <= tl.mfiLowerLimit) && (mfiTrend == SANTREND::UP));
   bool buyBool4 = ((sig[shift] >= tl.mfiUpperLimit) && mfiFlatBool);
   bool buyBool5 = (buyBool3 && (tradeTrend == SANTREND::DOWN));
   bool sellBool5 = (sellBool3 && (tradeTrend == SANTREND::UP));
   bool buyBool6 = ((buyBool1 || buyBool2 || buyBool4) && (tradeTrend == SANTREND::UP));
   bool sellBool6 = ((sellBool1 || sellBool2 || sellBool4) && (tradeTrend == SANTREND::DOWN));
//bool buyBool7 = (((mfiRegion && buyBool1)||(buyBool4)) || (notMfiRegion && (buyBool1||mfiFlatBool) && (tradeTrend==SANTREND::UP)));
//bool sellBool7 = (((mfiRegion && sellBool1)||(sellBool4)) || (notMfiRegion && (sellBool1||mfiFlatBool) && (tradeTrend==SANTREND::DOWN)));
   bool buyBool7 = (((mfiRegion && buyBool1) || (buyBool4)) || (notMfiRegion && (buyBool1) && (tradeTrend == SANTREND::UP)));
   bool sellBool7 = (((mfiRegion && sellBool1) || (sellBool4)) || (notMfiRegion && (sellBool1) && (tradeTrend == SANTREND::DOWN)));
//bool buyBool = (buyBool5||buyBool6);
//bool sellBool = (sellBool5||sellBool6);
   bool buyBool = (buyBool7);
   bool sellBool = (sellBool7);
   bool flatBool = (notMfiRegion && mfiFlatBool);
   if(flatBool)
     {
      mfISIG = SAN_SIGNAL::SIDEWAYS;
     }
   else
      if(buyBool)
        {
         mfISIG = SAN_SIGNAL::BUY;
        }
      else
         if(sellBool)
           {
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
SAN_SIGNAL  SanSignals::rsiSIG(const double rsiVal, const int BUYLEVEL = 40, const int SELLLEVEL = 60)
  {
   if(rsiVal > SELLLEVEL)
      return SAN_SIGNAL::SELL;
   if(rsiVal < BUYLEVEL)
      return SAN_SIGNAL::BUY;
   return SAN_SIGNAL::NOSIG;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL  SanSignals::fastSigSlowTrendSIG(
   const SAN_SIGNAL & fastSig,
   const SANTREND & baseTrend
)
  {
   if((fastSig != SAN_SIGNAL::NOSIG) && (fastSig != SAN_SIGNAL::SIDEWAYS))
     {
      if(fastSig == util.convTrendToSig(baseTrend))
        {
         return fastSig;
        }
      else
         if((util.oppSignal(fastSig, util.convTrendToSig(baseTrend))) || (baseTrend == SANTREND::FLAT))
           {
            return SAN_SIGNAL::CLOSE;
           }
     }
   return SAN_SIGNAL::NOSIG;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL SanSignals::cSIG(
   const INDDATA & indData,
   SanUtils & util,
   const uint SHIFT = 1
)
  {
   datetime timeCurrent = indData.time[SHIFT];
   int spread = indData.currSpread;
   SAN_SIGNAL tradeSIG = SAN_SIGNAL::NOSIG;
   const double STDSLOPE = -0.6;
   const double OBVSLOPE = 3000;
   const double SLOPERATIO = 0.5;
   const double SLOPERATIO_UPPERLIMIT = 20;
   const double CLUSTERRANGEPLUS = (1 + 0.03);
   const double CLUSTERRANGEMINUS = (1 - 0.03);
   const int CLUSTERRANGEFLAT = 1;
   const double SLOPE30LIMIT = 3;
   DTYPE dt14 = slopeSIGData(indData.ima14, 5, 21, 1);
   DTYPE  dt30 = slopeSIGData(indData.ima30, 5, 21, 1);
   DTYPE  dt120 = slopeSIGData(indData.ima120, 5, 21, 1);
   DTYPE  dt240 = slopeSIGData(indData.ima240, 5, 21, 1);
   DTYPE  dt500 = slopeSIGData(indData.ima500, 5, 21, 1);
   DTYPE  sTDSlope = slopeSIGData(indData.std, 5, 21, 1);
   DTYPE  obvSlope = slopeSIGData(indData.std, 5, 21, 1);
   DataTransport clusterData = clusterData(indData.ima30[1], indData.ima120[1], indData.ima240[1]);
   DataTransport slopeRatioData = slopeRatioData(dt30, dt120, dt240);
   double stdDevCp = indData.std[SHIFT];
   double slopeIMA14 = dt14.val1;
   double slopeIMA30 = dt30.val1;
   double slopeIMA120 = dt120.val1;
   double slopeIMA240 = dt240.val1;
   double slopeIMA500 = dt500.val1;
   double stdCPSlope = sTDSlope.val1;
   double obvCPSlope = obvSlope.val1;
   double rFM =  clusterData.matrixD[0];
   double rMS =  clusterData.matrixD[1];
   double rFS =  clusterData.matrixD[2];
   double fMSR = slopeRatioData.matrixD[0];
   double fMSWR = slopeRatioData.matrixD[1];
   bool strictFlatClusterBool = ((rFM == CLUSTERRANGEFLAT) && (rMS == CLUSTERRANGEFLAT) && (rFS == CLUSTERRANGEFLAT));
   bool flatClusterBool = (
                             ((rFM == CLUSTERRANGEFLAT) && (rMS == CLUSTERRANGEFLAT)) ||
                             ((rMS == CLUSTERRANGEFLAT) && (rFS == CLUSTERRANGEFLAT)) ||
                             ((rFM == CLUSTERRANGEFLAT) && (rFS == CLUSTERRANGEFLAT))
                          );
   bool rangeFlatClusterBool = (
                                  ((rFM > 0) && ((rFM >= CLUSTERRANGEMINUS) && (rFM <= CLUSTERRANGEPLUS)))
                                  && ((rMS > 0) && ((rMS >= CLUSTERRANGEMINUS) && (rMS <= CLUSTERRANGEPLUS)))
                                  && ((rFS > 0) && ((rFS >= CLUSTERRANGEMINUS) && (rFS <= CLUSTERRANGEPLUS)))
                               );
   bool flatSlope30Bool = (fabs(slopeIMA30) <= 0.4); // slope30 is not used for Trade Signal
   bool closeSlopeRatioBool = (fMSWR < SLOPERATIO);
//   bool closeSlopeRatioBool =  getMktCloseOnSlopeRatio();
   bool closeClusterBool = (((rFM < 0) && (rMS < 0)) || ((rMS < 0) && (rFS < 0)) || ((rFM < 0) && (rFS < 0)));
   bool closeTrendStdCP = (stdCPSlope <= STDSLOPE);
   bool closeTrendOBVCP = (fabs(obvCPSlope) <= OBVSLOPE);
   bool closeSlope30Bool = (fabs(slopeIMA30) <= 0.3); // slope30 is not used for Trade Signal
   bool flatBool = (strictFlatClusterBool || rangeFlatClusterBool || flatClusterBool);
   bool trendStdCP = (stdCPSlope > STDSLOPE);
   bool trendBuySlope30 = (slopeIMA30 > 0.4); // slope30 is not used for Trade Signal
   bool trendSellSlope30 = (slopeIMA30 < -0.4); // slope30 is not used for Trade Signal
   bool trendBuyOBVBool = (obvCPSlope > OBVSLOPE);
   bool trendSellOBVBool = (obvCPSlope < (-1 * OBVSLOPE));
   bool trendBuyClusterBool = (
                                 (rFM > CLUSTERRANGEPLUS) &&
                                 (rMS > CLUSTERRANGEPLUS) &&
                                 (rFS > CLUSTERRANGEPLUS) &&
                                 (rFM < rMS)
                              );
   bool trendSellClusterBool = (
                                  ((rFM >= 0) && (rFM < CLUSTERRANGEMINUS)) &&
                                  ((rMS >= 0) && (rMS < CLUSTERRANGEMINUS)) &&
                                  ((rFS >= 0) && (rFS < CLUSTERRANGEMINUS)) &&
                                  (rFM > rMS)
                               );
   bool trendClusterBool = (
                              trendBuyClusterBool || trendSellClusterBool
                           );
   bool trendSlopeRatioBool  = ((fMSWR >= SLOPERATIO) && (fMSWR <= SLOPERATIO_UPPERLIMIT));
   bool noTradeBoo11 = ((closeTrendStdCP && closeSlopeRatioBool) || (closeTrendStdCP && closeClusterBool));
   bool noTradeBoo12 = (closeTrendStdCP && flatBool);
   bool noSigBool = ((closeTrendStdCP && trendSlopeRatioBool) || (closeTrendStdCP && trendClusterBool));
   bool buyTradeBool = (trendStdCP && trendSlopeRatioBool && trendBuyClusterBool);
   bool sellTradeBool = (trendStdCP && trendSlopeRatioBool && trendSellClusterBool);
   bool tradeBool = (trendStdCP && trendSlopeRatioBool);
   if(noTradeBoo11)
     {
      tradeSIG = SAN_SIGNAL::NOTRADE;
     }
   else
      if(noTradeBoo12)
        {
         tradeSIG = SAN_SIGNAL::NOTRADE;
        }
      else
         if(noSigBool)
           {
            tradeSIG = SAN_SIGNAL::NOSIG;
           }
         else
            if(buyTradeBool)
              {
               tradeSIG = SAN_SIGNAL::TRADEBUY;
              }
            else
               if(sellTradeBool)
                 {
                  tradeSIG = SAN_SIGNAL::TRADESELL;
                 }
               else
                  if(tradeBool)
                    {
                     tradeSIG = SAN_SIGNAL::TRADE;
                    }
                  else
                    {
                     tradeSIG = SAN_SIGNAL::NOTRADE;
                    }
   SAN_SIGNAL slopesig = slopeSIG(dt30, 0);
   SAN_SIGNAL sig = SAN_SIGNAL::NOSIG;
   if(trendStdCP && (fabs(slopeIMA30) > SLOPE30LIMIT))
     {
      sig = slopesig;
     }
   else
      if((tradeSIG == SAN_SIGNAL::TRADEBUY) && (slopesig == SAN_SIGNAL::BUY))
        {
         sig = slopesig;
        }
      else
         if((tradeSIG == SAN_SIGNAL::TRADESELL) && (slopesig == SAN_SIGNAL::SELL))
           {
            sig = slopesig;
           }
         else
            if(trendStdCP && ((trendBuyOBVBool && (slopesig == SAN_SIGNAL::BUY)) || (trendSellOBVBool && (slopesig == SAN_SIGNAL::SELL))))
              {
               sig = slopesig;
              }
            else
               if((tradeSIG == SAN_SIGNAL::TRADE))
                 {
                  sig = slopesig;
                 }
               else
                  if(((tradeSIG == SAN_SIGNAL::NOTRADE) || (tradeSIG == SAN_SIGNAL::NOSIG)) && (slopesig == SAN_SIGNAL::CLOSE))
                    {
                     sig = slopesig;
                    }
   Print("[cSIG] cSIG: " + util.getSigString(sig) + " Slope stdCPSlope: " + stdCPSlope + " Slope30: " + slopeIMA30 + " fMSWR: " + fMSWR + " rFM: " + rFM + " rMS: " + rMS + " rFS: " + rFS);
   return sig;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL  SanSignals::dominantTrendSIG(
   const SANSIGNALS & ss,
   const HSIG & hSIG
)
  {
   SAN_SIGNAL dominantSIG = SAN_SIGNAL::NOSIG;
   bool closeOnReverseBool = ((ss.volSIG == SAN_SIGNAL::REVERSETRADE) || (ss.volSIG == SAN_SIGNAL::NOTRADE) || (ss.volSIG == SAN_SIGNAL::CLOSE));
   bool noReverseBool = ((ss.volSIG != SAN_SIGNAL::REVERSETRADE) && (ss.volSIG != SAN_SIGNAL::NOTRADE) && (ss.volSIG != SAN_SIGNAL::CLOSE));
   bool sideWaysBool = (
                          (ss.candleVolSIG == SAN_SIGNAL::SIDEWAYS)
                          || (ss.slopeVarSIG == SAN_SIGNAL::SIDEWAYS)
                       );
   bool flatTrendRatioBool = ((ss.trendRatioSIG == SANTREND::FLAT) || (ss.trendRatioSIG == SANTREND::FLATUP) || (ss.trendRatioSIG == SANTREND::FLATDOWN));
   bool flatCPBool = (
                        (ss.cpScatterSIG == SANTREND::FLAT)
                        || (ss.cpScatterSIG == SANTREND::FLATUP)
                        || (ss.cpScatterSIG == SANTREND::FLATDOWN)
                     );
   bool flatBool = (
                      (
                         (hSIG.mktType == MKTTYP::MKTFLAT)
                         || (hSIG.openSIG == SAN_SIGNAL::SIDEWAYS)
                      )
                   )
                   ;
   bool openBool = ((hSIG.mktType == MKTTYP::MKTTR) && ((hSIG.openSIG == SAN_SIGNAL::BUY) || (hSIG.openSIG == SAN_SIGNAL::SELL)));
   bool closeBool = (
                       (hSIG.mktType == MKTTYP::MKTCLOSE)
                       || (hSIG.closeSIG == SAN_SIGNAL::CLOSE)
//     ||(hSIG.fastSIG==SAN_SIGNAL::CLOSE)
                    );

//Print("Open bool: "+openBool+" flatBool: "+flatBool+" closeBool: "+closeBool);

   if(flatBool)
     {
      dominantSIG = SAN_SIGNAL::SIDEWAYS;
     }
   else
      if(closeBool)
        {
         dominantSIG = SAN_SIGNAL::CLOSE;
        }
      else
         if(openBool)
           {
            dominantSIG = hSIG.openSIG;
           }
   return dominantSIG;
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
DTYPE SanSignals::hilbertSIG(
   const double & close[],
   const int spread,
   const int stdDevPips,
   const int SIZE = 8,
   const int FILTER = 3
)
  {
   static SAN_SIGNAL hilbert_signal = SAN_SIGNAL::NOSIG;
   double hilbertAmp[], hilbertPhase[];
   stats.hilbertTransform(close, hilbertAmp, hilbertPhase, SIZE, FILTER);
   double cutOff = stats.maxVal<double>(spread, (0.5 * stdDevPips));
   DTYPE ht = stats.extractHilbertAmpNPhase(hilbertAmp, hilbertPhase, cutOff);
   ht.val5 = cutOff;
   if(ht.val2 == EMPTY_VALUE)
     {
      ht.val4 = hilbert_signal;
      return ht;
     }
   double hilbert_phase_deg = ht.val3 * 180 / M_PI;
   if(hilbert_phase_deg < 0)
      hilbert_phase_deg += 360;
   if(hilbert_phase_deg >= 315 || hilbert_phase_deg < 45)
      hilbert_signal = SAN_SIGNAL::SELL;
   else
      if(hilbert_phase_deg >= 135 && hilbert_phase_deg < 225)
         hilbert_signal = SAN_SIGNAL::BUY;
   ht.val4 = hilbert_signal;
   return ht;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
DTYPE SanSignals::dftSIG(
   const double & close[],
   const int SIZE = 8
)
  {
   static SAN_SIGNAL dft_signal = SAN_SIGNAL::NOSIG;
   double dftMag[], dftPhase[], dftPower[];
   stats.dftTransform(close, dftMag, dftPhase, dftPower, SIZE);
   DTYPE dft = stats.extractDftPowerNPhase(dftMag, dftPhase, dftPower);
   if(dft.val2 == EMPTY_VALUE)
     {
      dft.val5 = dft_signal;
      return dft;
     }
   double dft_phase_deg = dft.val3 * 180 / M_PI;
   if(dft_phase_deg < 0)
      dft_phase_deg += 360;
   if(dft_phase_deg >= 315 || dft_phase_deg < 45)
      dft_signal = SAN_SIGNAL::SELL;
   else
      if(dft_phase_deg >= 135 && dft_phase_deg < 225)
         dft_signal =  SAN_SIGNAL::BUY;
   dft.val5 = dft_signal;
   return dft;
  }

//+------------------------------------------------------------------+
//| Hilbert-DFT Conflation Signal                                    |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
D20TYPE SanSignals::hilbertDftSIG(
   const double & close[],
   const double rsi,
   const int spread,
   const int stdDevPips,
   const int SIZE = 8,
   const int FILTER = 3
)
  {
   DTYPE dft;
   DTYPE ht;
   D20TYPE d20;
// ArrayResize(d20.val, 17);
   static SAN_SIGNAL hibertdftSIG = SAN_SIGNAL::NOSIG;
   d20.val[0] = SAN_SIGNAL::NOTRADE;
   dft = dftSIG(close, SIZE);
   ht = hilbertSIG(close, spread, stdDevPips, SIZE, FILTER);
   SAN_SIGNAL rsiSig = rsiSIG(rsi);
   double hilbert_phase_deg = ht.val3 * 180 / M_PI;
   if(hilbert_phase_deg < 0)
      hilbert_phase_deg += 360;
   double dft_phase_deg = dft.val3 * 180 / M_PI;
   if(dft_phase_deg < 0)
      dft_phase_deg += 360;
   SAN_SIGNAL hilbert_signal = (SAN_SIGNAL)ht.val4;
   SAN_SIGNAL dft_signal = (SAN_SIGNAL)dft.val5;
   d20.val[1] = ht.val1;
   d20.val[2] = ht.val2;
   d20.val[3] = ht.val3;
   d20.val[4] = dft.val1;
   d20.val[5] = dft.val2;
   d20.val[6] = dft.val3;
   d20.val[7] = dft.val4;
   d20.val[8] = hilbert_phase_deg;
   d20.val[9] = dft_phase_deg;
   d20.val[10] = ht.val5;
   d20.val[11] = rsi;
   d20.val[12] = rsiSig;
   d20.val[13] = hilbert_signal;
   d20.val[14] = dft_signal;
   d20.val[15] = SIZE;
   d20.val[16] = FILTER;
   if((hilbert_signal == SAN_SIGNAL::SELL) && (dft_signal == SAN_SIGNAL::SELL))    // && (rsiSig ==SAN_SIGNAL::SELL)) {
     {
      //d20.val[0] = SAN_SIGNAL::SELL;
      hibertdftSIG = SAN_SIGNAL::SELL;
      //return d20;
     }
   if((hilbert_signal == SAN_SIGNAL::BUY) && (dft_signal == SAN_SIGNAL::BUY))   //  && (rsiSig ==SAN_SIGNAL::BUY)) {
     {
      //d20.val[0] = SAN_SIGNAL::BUY;
      hibertdftSIG = SAN_SIGNAL::BUY;
      //return d20;
     }
   d20.val[0] = hibertdftSIG;
   return d20;
  }


SanSignals sig;
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
