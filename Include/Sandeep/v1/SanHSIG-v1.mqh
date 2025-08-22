//+------------------------------------------------------------------+
//|                                                      SanHsig.mqh |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property strict

#include <Sandeep/v1/SanTypes-v1.mqh>
//#include <Sandeep/v1/SanSignalTypes-v1.mqh>
#include <Sandeep/v1/SanUtils-v1.mqh>


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


//########################################################################################################

class HSIG {

 private:
   SanUtils          ut;
   SANSIGNALS        ssSIG;

   double STDSLOPE;
   double OBVSLOPE;
   double SLOPERATIO;
   double SLOPERATIO_UPPERLIMIT;
   double CLUSTERRANGEPLUS;
   double CLUSTERRANGEMINUS;
   int CLUSTERRANGEFLAT;
   double SLOPE30LIMIT;

 public:
   HSIG();
   ~HSIG();

   HSIG(const SANSIGNALS &ss, SanUtils &util);

   TRADE_STRATEGIES  trdStgy;
   MKTTYP            mktType;
   SAN_SIGNAL        baseTrendSIG;
   SAN_SIGNAL        baseSlopeSIG;
//   DataTransport     imaSlopesData;
//   DataTransport     imaSlope30Data;
   DataTransport     slopeRatioData;
   DataTransport     stdCPSlope;
   DataTransport     obvCPSlope;

   bool              slopeTrendBool;
   SAN_SIGNAL        openSIG;
   SAN_SIGNAL        closeSIG;
   SAN_SIGNAL        c_SIG;
   SAN_SIGNAL        fastSIG;

   SAN_SIGNAL        mainFastSIG;
   SAN_SIGNAL        slopeFastSIG;
   //SAN_SIGNAL        rsiFastSIG;
   SAN_SIGNAL        cpFastSIG;
   SAN_SIGNAL        cpSlopeVarFastSIG;
   SAN_SIGNAL        cpSlopeCandle120SIG;
   SAN_SIGNAL        dominantTrendSIG;
   SAN_SIGNAL        dominantTrendCPSIG;
   SAN_SIGNAL        dominantTrendIma240SIG;
   SAN_SIGNAL        dominantTrendIma120SIG;
   SAN_SIGNAL        dominant240SIG;
   SAN_SIGNAL        dominant120SIG;
   SAN_SIGNAL        dominant30SIG;
   SAN_SIGNAL        domTrIMA;
   SAN_SIGNAL        domTrIMAFast;
   SAN_SIGNAL        domVolVarSIG;
   SAN_SIGNAL        domSIG;
   SAN_SIGNAL        tradeSIG;
   SAN_SIGNAL        simple_14_SIG;
   SAN_SIGNAL        simple_30_SIG;
   SAN_SIGNAL        simple_5_14_SIG;
   SAN_SIGNAL        simple_14_30_SIG;
   SAN_SIGNAL        simple_30_120_SIG;
   SAN_SIGNAL        simpleTrend_14_SIG;
   SAN_SIGNAL        simpleTrend_30_SIG;
   SAN_SIGNAL        simpleTrend_5_14_SIG;
   SAN_SIGNAL        simpleTrend_14_30_SIG;
   SAN_SIGNAL        simpleTrend_30_120_SIG;
   SAN_SIGNAL        trend_5_120_500_SIG;
   SAN_SIGNAL        trend_5_30_120_SIG;
   SAN_SIGNAL        trend_5_14_30_SIG;
   SAN_SIGNAL        trend_14_30_120_SIG;
   SAN_SIGNAL        simpleSlope_14_SIG;
   SAN_SIGNAL        simpleSlope_30_SIG;
   SAN_SIGNAL        simpleSlope_120_SIG;
   SAN_SIGNAL        simpleSlope_240_SIG;

   void              baseInit();
   void              setTradeStrategy(const TRADE_STRATEGIES& st);
   void              setSIGForStrategy(const SAN_SIGNAL& opensig,const TRADE_STRATEGIES& st, SAN_SIGNAL closesig=SAN_SIGNAL::NOSIG);
   void              processSignalsWithNoStrategy();
   void              processSignalsWithStrategy(const TRADE_STRATEGIES& trdStgy);
   void              initSIG(const SANSIGNALS &ss, SanUtils &util);
   SAN_SIGNAL        matchSIG(const SAN_SIGNAL compareSIG, const SAN_SIGNAL baseSIG1, SAN_SIGNAL baseSIG2=EMPTY, bool slowStrategy=false);
//   SAN_SIGNAL        simpleSIG(const SAN_SIGNAL sig1, const SAN_SIGNAL sig2=EMPTY);
   SAN_SIGNAL        simpleSIG(const SAN_SIGNAL sig1, const SAN_SIGNAL sig2=EMPTY, const SAN_SIGNAL sig3=EMPTY, const SAN_SIGNAL sig4=EMPTY, const SAN_SIGNAL sig5=EMPTY);
   SAN_SIGNAL        simpleTrendSIG(SANTREND tr1, SANTREND tr2=EMPTY);
   SAN_SIGNAL        trendSIG(SANTREND tr1, SANTREND tr2, SANTREND tr3, SANTREND tr4=EMPTY, SANTREND tr5=EMPTY, SANTREND tr6=EMPTY);
   SAN_SIGNAL        sigTrSIG(const SAN_SIGNAL sig,const SANTREND tr);
   SAN_SIGNAL        imaTrendSIG(const SAN_SIGNAL baseMASig,const SANTREND fastTrend,const SANTREND slowTrend);
   SAN_SIGNAL        imaTrend(SAN_SIGNAL imaSIG1, SAN_SIGNAL imaSIG2, SANTREND tr1, SANTREND tr2, SANTREND tr3, SAN_SIGNAL imaSIG3=EMPTY, SANTREND tr4=EMPTY, SAN_SIGNAL imaSIG4=EMPTY, SANTREND tr5=EMPTY);
   SAN_SIGNAL        fSigSlowTrendSIG(const SAN_SIGNAL baseSig, const SANTREND baseTrend);

   SAN_SIGNAL        dualFastSigSlowTrendSIG(
      const SAN_SIGNAL baseSig,
      const SANTREND baseTrend,
      const SAN_SIGNAL fastSig,
      const SANTREND fastTrend
   );
//+------------------------------------------------------------------+
   SAN_SIGNAL        fastImaSlowTrendSIG(
      const SAN_SIGNAL imaSig,
      const SANTREND closeTrend,
      const SANTREND fastTrend,
      const SANTREND slowTrend,
      const SANTREND vSlowTrend=SANTREND::NOTREND
   );
   SAN_SIGNAL        trendVolVarSIG(
      const SAN_SIGNAL tradeVolVarSIG,
      const SANTREND fastTrend,
      const SANTREND mediumTrend,
      const SANTREND slowTrend,
      const SANTREND vSlowTrend=SANTREND::NOTREND
   );
   SAN_SIGNAL        slopeSIG(const DataTransport& signalDt, const int signalType=0);

   SAN_SIGNAL        cTradeSIG(
      const SANSIGNALS &ss,
      SanUtils& util,
      const uint SHIFT=1
   );

   SAN_SIGNAL        cSIG(
      const SANSIGNALS &ss,
      SanUtils& util,
      const uint SHIFT=1
   );
   //DataTransport     getSlopeRatioData(
   //   const DataTransport &fast,
   //   const DataTransport &medium,
   //   const DataTransport &slow
   //);
   bool              getMktFlatBoolSignal(
      const SAN_SIGNAL candleVol120SIG,
      const SAN_SIGNAL slopeVarSIG,
      const SANTREND cpScatterSIG,
      const SANTREND trendRatioSIG,
      const SAN_SIGNAL trendSIG
   );
   bool              getMktCloseOnSlopeRatio();
   bool              getMktCloseOnStdCPOBV();
   bool              getMktCloseOnReversal(const SAN_SIGNAL &sig,SanUtils &util);
   bool              getMktCloseOnFlat(const SAN_SIGNAL &sig, const bool mktTypeFlat);
   bool              getMktCloseOnSlopeVariable(const SANSIGNALS &ss, SanUtils &util);
   bool              getMktCloseOnSlopeReversal(const SANSIGNALS &ss, SanUtils &util, const double SLOPE_REDUCTION_LEVEL=0.3);
   bool              getMktClose(
      const SAN_SIGNAL candleVol120SIG,
      const SAN_SIGNAL slopeVarSIG,
      const SAN_SIGNAL trend_5_120_500_SIG,
      const SAN_SIGNAL sig30
   );
   bool              getMktCloseOnFlat(
      const SAN_SIGNAL candleVol120SIG,
      const SAN_SIGNAL slopeVarSIG,
      const SANTREND cpScatterSIG,
      const SANTREND trendRatioSIG,
      const SAN_SIGNAL trendSIG
   );
};

//###########################################################################################################
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void HSIG::baseInit() {
   mktType= MKTTYP::NOMKT;
   trdStgy = TRADE_STRATEGIES::NOTRDSTGY;
   baseTrendSIG=SAN_SIGNAL::NOSIG;
   baseSlopeSIG=SAN_SIGNAL::NOSIG;
   openSIG =  SAN_SIGNAL::NOSIG;
   closeSIG =  SAN_SIGNAL::NOSIG;
   c_SIG =  SAN_SIGNAL::NOSIG;
   slopeTrendBool=false;
   fastSIG =  SAN_SIGNAL::NOSIG;
   mainFastSIG = SAN_SIGNAL::NOSIG;
   slopeFastSIG = SAN_SIGNAL::NOSIG;
//rsiFastSIG = SAN_SIGNAL::NOSIG;
   cpFastSIG = SAN_SIGNAL::NOSIG;
   cpSlopeVarFastSIG = SAN_SIGNAL::NOSIG;
   cpSlopeCandle120SIG = SAN_SIGNAL::NOSIG;
   dominantTrendSIG = SAN_SIGNAL::NOSIG;
   dominantTrendCPSIG = SAN_SIGNAL::NOSIG;
   domVolVarSIG = SAN_SIGNAL::NOSIG;
   dominantTrendIma120SIG = SAN_SIGNAL::NOSIG;
   dominantTrendIma240SIG = SAN_SIGNAL::NOSIG;
   dominant240SIG = SAN_SIGNAL::NOSIG;
   dominant120SIG = SAN_SIGNAL::NOSIG;
   dominant30SIG = SAN_SIGNAL::NOSIG;
   domTrIMA = SAN_SIGNAL::NOSIG;
   domTrIMAFast = SAN_SIGNAL::NOSIG;
   domSIG = SAN_SIGNAL::NOSIG;
   tradeSIG = SAN_SIGNAL::NOSIG;
   simple_14_SIG = SAN_SIGNAL::NOSIG;
   simple_30_SIG = SAN_SIGNAL::NOSIG;
   simple_5_14_SIG = SAN_SIGNAL::NOSIG;
   simple_14_30_SIG = SAN_SIGNAL::NOSIG;
   simple_30_120_SIG = SAN_SIGNAL::NOSIG;
   simpleTrend_14_SIG = SAN_SIGNAL::NOSIG;
   simpleTrend_30_SIG = SAN_SIGNAL::NOSIG;
   simpleTrend_5_14_SIG = SAN_SIGNAL::NOSIG;
   simpleTrend_14_30_SIG = SAN_SIGNAL::NOSIG;
   simpleTrend_30_120_SIG = SAN_SIGNAL::NOSIG;
   trend_5_120_500_SIG = SAN_SIGNAL::NOSIG;
   trend_5_30_120_SIG = SAN_SIGNAL::NOSIG;
   trend_14_30_120_SIG = SAN_SIGNAL::NOSIG;
   trend_5_14_30_SIG = SAN_SIGNAL::NOSIG;
   simpleSlope_14_SIG = SAN_SIGNAL::NOSIG;
   simpleSlope_30_SIG = SAN_SIGNAL::NOSIG;
   simpleSlope_120_SIG = SAN_SIGNAL::NOSIG;
   simpleSlope_240_SIG = SAN_SIGNAL::NOSIG;
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
HSIG::HSIG()
   :
   STDSLOPE(-0.6),
   OBVSLOPE(300),
   SLOPERATIO(0.5),
   SLOPERATIO_UPPERLIMIT(20),
   CLUSTERRANGEPLUS(1+0.03),
   CLUSTERRANGEMINUS(1-0.03),
   CLUSTERRANGEFLAT(1),
   SLOPE30LIMIT(3) {
   baseInit();
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
HSIG::~HSIG() {
   mktType=MKTTYP::NOMKT;
   trdStgy = TRADE_STRATEGIES::NOTRDSTGY;
   baseTrendSIG=SAN_SIGNAL::NOSIG;
   baseSlopeSIG=SAN_SIGNAL::NOSIG;
   openSIG =  SAN_SIGNAL::NOSIG;
   closeSIG =  SAN_SIGNAL::NOSIG;
   c_SIG =  SAN_SIGNAL::NOSIG;
   slopeTrendBool=false;
   fastSIG =  SAN_SIGNAL::NOSIG;
   mainFastSIG = SAN_SIGNAL::NOSIG;
   slopeFastSIG = SAN_SIGNAL::NOSIG;
//rsiFastSIG = SAN_SIGNAL::NOSIG;
   cpFastSIG = SAN_SIGNAL::NOSIG;
   cpSlopeVarFastSIG = SAN_SIGNAL::NOSIG;
   cpSlopeCandle120SIG = SAN_SIGNAL::NOSIG;
   dominantTrendSIG = SAN_SIGNAL::NOSIG;
   dominantTrendCPSIG = SAN_SIGNAL::NOSIG;
   dominantTrendIma120SIG = SAN_SIGNAL::NOSIG;
   dominantTrendIma240SIG = SAN_SIGNAL::NOSIG;
   dominant240SIG = SAN_SIGNAL::NOSIG;
   dominant120SIG = SAN_SIGNAL::NOSIG;
   dominant30SIG = SAN_SIGNAL::NOSIG;
   domTrIMA = SAN_SIGNAL::NOSIG;
   domTrIMAFast = SAN_SIGNAL::NOSIG;
   domVolVarSIG = SAN_SIGNAL::NOSIG;
   tradeSIG = SAN_SIGNAL::NOSIG;
   simple_14_SIG = SAN_SIGNAL::NOSIG;
   simple_30_SIG = SAN_SIGNAL::NOSIG;
   simple_5_14_SIG = SAN_SIGNAL::NOSIG;
   simple_14_30_SIG = SAN_SIGNAL::NOSIG;
   simple_30_120_SIG = SAN_SIGNAL::NOSIG;
   simpleTrend_14_SIG = SAN_SIGNAL::NOSIG;
   simpleTrend_30_SIG = SAN_SIGNAL::NOSIG;
   simpleTrend_5_14_SIG = SAN_SIGNAL::NOSIG;
   simpleTrend_14_30_SIG = SAN_SIGNAL::NOSIG;
   simpleTrend_30_120_SIG = SAN_SIGNAL::NOSIG;
   trend_5_120_500_SIG = SAN_SIGNAL::NOSIG;
   trend_5_30_120_SIG = SAN_SIGNAL::NOSIG;
   trend_5_14_30_SIG = SAN_SIGNAL::NOSIG;
   trend_14_30_120_SIG = SAN_SIGNAL::NOSIG;
//   imaSlopesData.freeData();
//imaSlope30Data.freeData();
   slopeRatioData.freeData();
   stdCPSlope.freeData();
   obvCPSlope.freeData();
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
HSIG::HSIG(const SANSIGNALS &ss, SanUtils &util)
   :
   STDSLOPE(-0.6),
   OBVSLOPE(300),
   SLOPERATIO(0.5),
   SLOPERATIO_UPPERLIMIT(20),
   CLUSTERRANGEPLUS(1+0.03),
   CLUSTERRANGEMINUS(1-0.03),
   CLUSTERRANGEFLAT(1),
   SLOPE30LIMIT(3) {
   baseInit();
   ut = util;
   ssSIG = ss;
   initSIG(ss,util);
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void HSIG::setTradeStrategy(const TRADE_STRATEGIES& st) {
   trdStgy = st;
};



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void HSIG::setSIGForStrategy(const SAN_SIGNAL& opensig,const TRADE_STRATEGIES& st, SAN_SIGNAL closesig=SAN_SIGNAL::NOSIG) {


   bool noTradeBool = ((tradeSIG==SAN_SIGNAL::NOTRADE)||(tradeSIG==SAN_SIGNAL::NOSIG));
   bool tradeBool = (
                       ((tradeSIG==SAN_SIGNAL::TRADEBUY)&&(opensig==SAN_SIGNAL::BUY))||
                       ((tradeSIG==SAN_SIGNAL::TRADESELL)&&(opensig==SAN_SIGNAL::SELL))||
                       (tradeSIG==SAN_SIGNAL::TRADE)
                    );

   bool flatMktBool =  getMktFlatBoolSignal(
                          ssSIG.candleVol120SIG,
                          ssSIG.slopeVarSIG,
                          ssSIG.cpScatterSIG,
                          ssSIG.trendRatioSIG,
                          trend_14_30_120_SIG
                       );



//bool openTradeBool = ((opensig==baseSlopeSIG)&&(stdCPSlope.matrixD[0]>-0.6));
//bool openTradeBool = ((opensig==baseSlopeSIG)&&tradeBool);
   bool openTradeBool1 = (tradeBool);
   bool openTradeBool2 = (opensig==baseSlopeSIG);
   bool openTradeBool3 = (openTradeBool1&&openTradeBool2);

   bool openTradeBool = (tradeBool);


// getMktCloseOnVariableSlope(ss,util): This is great for close signals when the signals are steep
   bool closeTradeBool1 = getMktCloseOnSlopeVariable(ssSIG,ut);

// getMktCloseOnFlat(fastSIG,flatMktBool): This is great for handling close when market is flat.
   bool closeFlatTradeBool = getMktCloseOnFlat(opensig,flatMktBool);

// This is a simple basic close signal on reversal of trade signal with current position.
   bool closeSigTrReversalBool =  getMktCloseOnReversal(opensig, ut);
   bool closeSigTrCloseSigReversalBool =  getMktCloseOnReversal(closesig, ut);
   bool closeSlopeRatios = getMktCloseOnSlopeRatio();

//  bool closeTradeBool2 = ((!closeFlatTradeBool&&!closeSigTrReversalBool) && noTradeBool);
   //bool closeOBVStdBool = getMktCloseOnStdCPOBV();
   bool closeOBVStdBool = (noTradeBool&&getMktCloseOnStdCPOBV());
   bool closeTradeBool3 = ((opensig==SAN_SIGNAL::CLOSE) || noTradeBool);

   bool closeTradeBool = (closeOBVStdBool);



// fastSIG
   if(trdStgy == TRADE_STRATEGIES::FASTSIG) {
      if(closeTradeBool1) {
         mktType=MKTTYP::MKTCLOSE;
         closeSIG = SAN_SIGNAL::CLOSE;
      } else if(closeTradeBool3) {
         mktType=MKTTYP::MKTCLOSE;
         closeSIG = SAN_SIGNAL::CLOSE;
      } else if(closeFlatTradeBool) {
         mktType=MKTTYP::MKTCLOSE;
         closeSIG = SAN_SIGNAL::CLOSE;
      } else if(closeSigTrReversalBool) {
         mktType=MKTTYP::MKTCLOSE;
         closeSIG = SAN_SIGNAL::CLOSE;
      } else if(closeSlopeRatios) {
         mktType=MKTTYP::MKTCLOSE;
         closeSIG = SAN_SIGNAL::CLOSE;
      }
      //else if(flatMktBool) {
      //   mktType=MKTTYP::MKTFLAT;
      //   closeSIG = SAN_SIGNAL::NOSIG;
      //}
      else if(openTradeBool) {
         mktType=MKTTYP::MKTTR;
         openSIG = opensig;
         closeSIG = SAN_SIGNAL::NOSIG;
      }
      //  Print("[TRADESTRATEGY]: FASTSIG "+ut.getSigString(openSIG));
   }

// open: simpleTrend_5_14_SIG
// close: simpleTrend_14_30_SIG
   if(trdStgy == TRADE_STRATEGIES::SIMPLESIG) {

      if(closeTradeBool3) {
         mktType=MKTTYP::MKTCLOSE;
         closeSIG = SAN_SIGNAL::CLOSE;
      } else if(closeFlatTradeBool) {
         mktType=MKTTYP::MKTCLOSE;
         closeSIG = SAN_SIGNAL::CLOSE;
      } else if(closeSigTrCloseSigReversalBool) {
         mktType=MKTTYP::MKTCLOSE;
         closeSIG = SAN_SIGNAL::CLOSE;
      }
      //else if(flatMktBool) {
      //   mktType=MKTTYP::MKTFLAT;
      //   closeSIG = SAN_SIGNAL::NOSIG;
      //}
      else if(openTradeBool) {
         mktType=MKTTYP::MKTTR;
         openSIG = opensig;
         closeSIG = SAN_SIGNAL::NOSIG;
      }
      //Print("[TRADESTRATEGY]: SIMPLESIG "+ut.getSigString(openSIG));
   }

//simpleSlope_30_SIG
   if(trdStgy == TRADE_STRATEGIES::SLOPESIG) {

      if(closeTradeBool3) {
         mktType=MKTTYP::MKTCLOSE;
         closeSIG = SAN_SIGNAL::CLOSE;
      } else if(closeFlatTradeBool) {
         mktType=MKTTYP::MKTCLOSE;
         closeSIG = SAN_SIGNAL::CLOSE;
      } else if(closeSigTrReversalBool) {
         mktType=MKTTYP::MKTCLOSE;
         closeSIG = SAN_SIGNAL::CLOSE;
      } else if(opensig==SAN_SIGNAL::SIDEWAYS) {
         mktType=MKTTYP::MKTCLOSE;
         closeSIG = SAN_SIGNAL::CLOSE;
      }
      //else if(flatMktBool) {
      //   mktType=MKTTYP::MKTFLAT;
      //   closeSIG = SAN_SIGNAL::NOSIG;
      //}
      else if(openTradeBool) {
         mktType=MKTTYP::MKTTR;
         openSIG = opensig;
         closeSIG = SAN_SIGNAL::NOSIG;
      }
      //Print("[TRADESTRATEGY]: SLOPESIG "+ut.getSigString(openSIG));
   }

//cpSlopeCandle120SIG
   if(trdStgy == TRADE_STRATEGIES::CPSLOPECANDLE120) {

      if(closeTradeBool3) {
         mktType=MKTTYP::MKTCLOSE;
         closeSIG = SAN_SIGNAL::CLOSE;
      } else if(closeFlatTradeBool) {
         mktType=MKTTYP::MKTCLOSE;
         closeSIG = SAN_SIGNAL::CLOSE;
      } else if(closeSigTrReversalBool) {
         mktType=MKTTYP::MKTCLOSE;
         closeSIG = SAN_SIGNAL::CLOSE;
      } else if(opensig==SAN_SIGNAL::SIDEWAYS) {
         mktType=MKTTYP::MKTCLOSE;
         closeSIG = SAN_SIGNAL::CLOSE;
      }
      //else if(flatMktBool) {
      //   mktType=MKTTYP::MKTCLOSE;
      //   closeSIG = SAN_SIGNAL::CLOSE;
      //}
      else if(openTradeBool) {
         mktType=MKTTYP::MKTTR;
         openSIG = opensig;
         closeSIG = SAN_SIGNAL::NOSIG;
      }
      //Print("[TRADESTRATEGY]: SLOPESIG "+ut.getSigString(openSIG));
   }

// sig: c_SIG
   if((trdStgy == TRADE_STRATEGIES::SLOPESTD_CSIG)||(trdStgy == TRADE_STRATEGIES::NOTRDSTGY)) {

      if(closeTradeBool) {
         mktType=MKTTYP::MKTCLOSE;
         openSIG = SAN_SIGNAL::NOSIG;
         closeSIG = SAN_SIGNAL::CLOSE;
      } else if(closeFlatTradeBool) {
         mktType=MKTTYP::MKTCLOSE;
         openSIG = SAN_SIGNAL::NOSIG;
         closeSIG = SAN_SIGNAL::CLOSE;
      } else if(closeSigTrReversalBool) {
         mktType=MKTTYP::MKTCLOSE;
         openSIG = SAN_SIGNAL::NOSIG;
         closeSIG = SAN_SIGNAL::CLOSE;
      } else if(
         (opensig==SAN_SIGNAL::SIDEWAYS)
         //||flatMktBool
      ) {
         mktType=MKTTYP::MKTFLAT;
         openSIG = SAN_SIGNAL::NOSIG;
         closeSIG = SAN_SIGNAL::NOSIG;
      } else if((opensig==SAN_SIGNAL::BUY)||(opensig==SAN_SIGNAL::SELL)) {
         mktType=MKTTYP::MKTTR;
         openSIG = opensig;
         closeSIG = SAN_SIGNAL::NOSIG;
      }
      //Print("[TRADESTRATEGY]: SLOPESTD_CSIG "+ut.getSigString(openSIG));
   }
//   Print("[SETSIGBOOLS]: openTradeBool1: "+openTradeBool1+" closeTradeBool3: "+closeTradeBool3+" tradeBool: "+tradeBool); //+" Slope Var: "+closeTradeBool+" Slope Rev: "+getMktCloseOnSlopeReversal(ssSIG,ut)+" fsig flat: "+closeFlatTradeBool+" MkRev: "+getMktCloseOnReversal(simple_5_14_SIG, util)+" Slope Ratios: " +closeSlopeRatios+" c_SIG : "+(c_SIG==SAN_SIGNAL::CLOSE)+" tradeSIG: ]"+ut.getSigString(tradeSIG));
   Print("[SETSIGBOOLS]: openTradeBool1: "+openTradeBool1+" closeTradeBool3: "+closeTradeBool3+" closeOBVStdBool: "+closeOBVStdBool);

}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void   HSIG::processSignalsWithNoStrategy() {

   if(c_SIG!=SAN_SIGNAL::NOSIG) {
      trdStgy = TRADE_STRATEGIES::SLOPESTD_CSIG;
      setSIGForStrategy(c_SIG, trdStgy);
   } else if(fastSIG!=SAN_SIGNAL::NOSIG) {
      trdStgy = TRADE_STRATEGIES::FASTSIG;
      setSIGForStrategy(fastSIG, trdStgy);
   } else if(simpleSlope_30_SIG!=SAN_SIGNAL::NOSIG) {
      trdStgy = TRADE_STRATEGIES::SLOPESIG;
      setSIGForStrategy(simpleSlope_30_SIG, trdStgy);
   } else if(simpleTrend_5_14_SIG!=SAN_SIGNAL::NOSIG) {
      trdStgy = TRADE_STRATEGIES::SIMPLESIG;
      setSIGForStrategy(simpleTrend_5_14_SIG, trdStgy, simpleTrend_14_30_SIG);
   } else if(cpSlopeCandle120SIG!=SAN_SIGNAL::NOSIG) {
      trdStgy = TRADE_STRATEGIES::CPSLOPECANDLE120;
      setSIGForStrategy(cpSlopeCandle120SIG, trdStgy);
   }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void   HSIG::processSignalsWithStrategy(const TRADE_STRATEGIES& trdStgy) {

//   Print("[SIG]: cpSlopeCandle120SIG: "+ut.getSigString(cpSlopeCandle120SIG));

//trdStgy = TRADE_STRATEGIES::FASTSIG;
   if(trdStgy==TRADE_STRATEGIES::FASTSIG)
      setSIGForStrategy(fastSIG, trdStgy);

//trdStgy = TRADE_STRATEGIES::SIMPLESIG;
   if(trdStgy==TRADE_STRATEGIES::SIMPLESIG)
      setSIGForStrategy(simpleTrend_5_14_SIG, trdStgy, simpleTrend_14_30_SIG);

//trdStgy = TRADE_STRATEGIES::SLOPESIG;
   if(trdStgy==TRADE_STRATEGIES::SLOPESIG)
      setSIGForStrategy(simpleSlope_30_SIG, trdStgy);

//trdStgy = TRADE_STRATEGIES::SLOPESTD_CSIG;
   if(trdStgy==TRADE_STRATEGIES::SLOPESTD_CSIG)
      setSIGForStrategy(c_SIG, trdStgy);

//trdStgy = TRADE_STRATEGIES::CPSLOPECANDLE120;
   if(trdStgy==TRADE_STRATEGIES::CPSLOPECANDLE120)
      setSIGForStrategy(cpSlopeCandle120SIG, trdStgy);
}


void   HSIG::initSIG(const SANSIGNALS &ss, SanUtils &util) {

   baseTrendSIG = imaTrendSIG(ss.ima120240SIG,ss.trendRatio120SIG,ss.trendRatio240SIG);
   baseSlopeSIG = slopeSIG(ss.baseSlopeData,2);
   tradeSIG = cTradeSIG(ss,util,1);
   c_SIG = cSIG(ss,util,1);
   cpSlopeCandle120SIG = simpleSIG(ss.slopeVarSIG,ss.candleVol120SIG,util.convTrendToSig(ss.cpScatterSIG));


//   mainFastSIG = matchSIG(ss.candleVol120SIG, ss.ima1430SIG);
//   slopeFastSIG = matchSIG(ss.slopeVarSIG, ss.ima1430SIG);
////rsiFastSIG = matchSIG(ss.rsiSIG, ss.ima1430SIG);
//   cpFastSIG = matchSIG(util.convTrendToSig(ss.cpScatterSIG), ss.ima1430SIG);
//   cpSlopeVarFastSIG= matchSIG(util.convTrendToSig(ss.cpScatterSIG),ss.slopeVarSIG);
//   dominantTrendIma240SIG = fastImaSlowTrendSIG(ss.ima120240SIG,ss.trendRatio30SIG,ss.trendRatio120SIG,ss.trendRatio240SIG);
//   dominantTrendIma120SIG = fastImaSlowTrendSIG(ss.ima30120SIG,ss.trendRatio30SIG,ss.trendRatio30SIG,ss.trendRatio120SIG,ss.trendRatio240SIG);
//   dominant240SIG = imaTrendSIG(ss.sig120,ss.cpScatterSIG,ss.trendRatio240SIG);
//   dominant120SIG = imaTrendSIG(ss.sig30,ss.trendRatio30SIG,ss.trendRatio120SIG);
//   dominant30SIG = imaTrendSIG(ss.ima1430SIG,ss.trendRatio14SIG,ss.trendRatio30SIG);



//   simple_14_SIG = simpleSIG(ss.fsig14);
//   simple_30_SIG = simpleSIG(ss.fsig30);
//   simple_5_14_SIG = simpleSIG(ss.fsig5, ss.fsig14);
//   simple_14_30_SIG = simpleSIG(ss.fsig14, ss.fsig30);
//   simple_30_120_SIG = simpleSIG(ss.fsig30, ss.fsig120);
//   simpleTrend_14_SIG = simpleTrendSIG(ss.trendRatio14SIG);
//   simpleTrend_30_SIG = simpleTrendSIG(ss.trendRatio30SIG);
   simpleTrend_5_14_SIG =  simpleTrendSIG(ss.trendRatio5SIG,ss.trendRatio14SIG);
   simpleTrend_14_30_SIG =  simpleTrendSIG(ss.trendRatio14SIG,ss.trendRatio30SIG);
   simpleTrend_30_120_SIG =  simpleTrendSIG(ss.trendRatio30SIG,ss.trendRatio120SIG);

   trend_5_120_500_SIG = trendSIG(ss.trendRatio5SIG,ss.trendRatio120SIG,ss.trendRatio500SIG);
   trend_5_30_120_SIG = trendSIG(ss.trendRatio5SIG,ss.trendRatio30SIG,ss.trendRatio120SIG);
   trend_5_14_30_SIG = trendSIG(ss.trendRatio5SIG,ss.trendRatio14SIG,ss.trendRatio30SIG);
   trend_14_30_120_SIG = trendSIG(ss.trendRatio14SIG,ss.trendRatio30SIG,ss.trendRatio120SIG);

   slopeRatioData = ss.slopeRatioData;

   stdCPSlope = ss.stdCPSlope;
   obvCPSlope = ss.obvCPSlope;

   simpleSlope_14_SIG = slopeSIG(ss.imaSlope14Data,0);
   simpleSlope_30_SIG = slopeSIG(ss.imaSlope30Data,0);
   simpleSlope_120_SIG = slopeSIG(ss.imaSlope120Data,1);
   simpleSlope_240_SIG = baseSlopeSIG;

//  Print("[SIMSLOPES]: simple14: "+ut.getSigString(simpleSlope_14_SIG)+" simple30:"+ ut.getSigString(simpleSlope_30_SIG)+" simple120:"+ut.getSigString(simpleSlope_120_SIG)+" simple240:"+ut.getSigString(simpleSlope_240_SIG));

   fastSIG = matchSIG(ss.fsig5,ss.fsig14,ss.fsig30);
   dominantTrendSIG = matchSIG(ss.fsig5,trend_5_120_500_SIG,ss.slopeVarSIG);
   domVolVarSIG = ss.tradeVolVarSIG;
   dominantTrendCPSIG = matchSIG(
                           util.convTrendToSig(ss.cpScatterSIG),
                           util.convTrendToSig(ss.trendRatio120SIG),
                           imaTrendSIG(ss.ima30120SIG,ss.trendRatio30SIG,ss.trendRatio120SIG));

   domTrIMAFast = imaTrend(ss.ima1430SIG,ss.ima30120SIG,ss.trendRatio14SIG,ss.trendRatio30SIG,ss.trendRatio120SIG);
//domTrIMA = imaTrend(ss.ima30120SIG,ss.ima120240SIG,ss.trendRatio30SIG,ss.trendRatio120SIG,ss.trendRatio240SIG,ss.ima240500SIG,ss.trendRatio500SIG);
   domTrIMA = domTrIMAFast;

////######################################################################################
//   // SET Trade Strategies
//   //trdStgy = TRADE_STRATEGIES::FASTSIG;
//   //trdStgy = TRADE_STRATEGIES::SIMPLESIG;
//   //trdStgy = TRADE_STRATEGIES::SLOPESIG;
//   //trdStgy = TRADE_STRATEGIES::SLOPERATIOSIG;
   trdStgy = TRADE_STRATEGIES::SLOPESTD_CSIG;
//   //trdStgy = TRADE_STRATEGIES::NOTRDSTGY;
////######################################################################################
//

   if(trdStgy==TRADE_STRATEGIES::NOTRDSTGY) {
      processSignalsWithNoStrategy();
   } else {
      processSignalsWithStrategy(trdStgy);
   }

} //initSIG



SAN_SIGNAL  HSIG::matchSIG(const SAN_SIGNAL compareSIG, const SAN_SIGNAL baseSIG1, SAN_SIGNAL baseSIG2=EMPTY, bool slowStrategy=false) {

// ###################################################################

   if(baseSIG2==EMPTY) {
      if(util.oppSignal(compareSIG,baseSIG1)) {
         return SAN_SIGNAL::CLOSE;
      }

      if(!slowStrategy) {
         if(
            //(compareSIG==SAN_SIGNAL::SIDEWAYS)||
            (baseSIG1==SAN_SIGNAL::SIDEWAYS)) {
            return SAN_SIGNAL::SIDEWAYS;
         }

         if(
            //(compareSIG==SAN_SIGNAL::CLOSE)||
            (baseSIG1==SAN_SIGNAL::CLOSE)) {
            return SAN_SIGNAL::CLOSE;
         }
      }

      if(slowStrategy) {
         if((compareSIG==SAN_SIGNAL::SIDEWAYS)&&(baseSIG1==SAN_SIGNAL::SIDEWAYS)) {
            return SAN_SIGNAL::SIDEWAYS;
         }

         if((compareSIG==SAN_SIGNAL::CLOSE)&&(baseSIG1==SAN_SIGNAL::CLOSE)) {
            return SAN_SIGNAL::CLOSE;
         }
      }

      if(((compareSIG!=SAN_SIGNAL::NOSIG)&&(compareSIG!=SAN_SIGNAL::SIDEWAYS))
            &&((baseSIG1!=SAN_SIGNAL::NOSIG)&&(baseSIG1!=SAN_SIGNAL::SIDEWAYS))
        )
         return (
                   ((compareSIG==baseSIG1))?
                   compareSIG
                   :
                   SAN_SIGNAL::CLOSE
                );
   }

// ###################################################################
// ###################################################################
   if(baseSIG2!=EMPTY) {

      if(!slowStrategy) {
         if(
            //(compareSIG==SAN_SIGNAL::SIDEWAYS)||
            (baseSIG1==SAN_SIGNAL::SIDEWAYS)||(baseSIG2==SAN_SIGNAL::SIDEWAYS)) {
            return SAN_SIGNAL::SIDEWAYS;
         }

         if(
            //(util.oppSignal(compareSIG,baseSIG1))||(util.oppSignal(compareSIG,baseSIG2))||
            (util.oppSignal(baseSIG1,baseSIG2))
         ) {
            return SAN_SIGNAL::CLOSE;
         }

         if(
            //(compareSIG==SAN_SIGNAL::CLOSE)||
            (baseSIG1==SAN_SIGNAL::CLOSE)||(baseSIG2==SAN_SIGNAL::CLOSE)) {
            return SAN_SIGNAL::CLOSE;
         }
      }

      if(slowStrategy) {
         if(
            ((compareSIG==SAN_SIGNAL::SIDEWAYS)&&(baseSIG1==SAN_SIGNAL::SIDEWAYS))
            ||((compareSIG==SAN_SIGNAL::SIDEWAYS)&&(baseSIG2==SAN_SIGNAL::SIDEWAYS))
            ||((baseSIG1==SAN_SIGNAL::SIDEWAYS)&&(baseSIG2==SAN_SIGNAL::SIDEWAYS))
         ) {
            return SAN_SIGNAL::SIDEWAYS;
         }

         if(
            (util.oppSignal(compareSIG,baseSIG2))
            &&(util.oppSignal(baseSIG1,baseSIG2))
         ) {
            return SAN_SIGNAL::CLOSE;
         }

         if(
            ((compareSIG==SAN_SIGNAL::CLOSE)&&(baseSIG1==SAN_SIGNAL::CLOSE))
            ||((compareSIG==SAN_SIGNAL::CLOSE)&&(baseSIG2==SAN_SIGNAL::CLOSE))
            ||((baseSIG1==SAN_SIGNAL::CLOSE)&&(baseSIG2==SAN_SIGNAL::CLOSE))
         )

         {
            return SAN_SIGNAL::CLOSE;
         }
      }

      //Print("[XXCV]: compareSIG: "+ util.getSigString(compareSIG)+" baseSIG1: "+util.getSigString(baseSIG1)+" baseSIG2: "+util.getSigString(baseSIG2));
      if(((compareSIG!=SAN_SIGNAL::NOSIG)&&(compareSIG!=SAN_SIGNAL::SIDEWAYS))
            &&((baseSIG1!=SAN_SIGNAL::NOSIG)&&(baseSIG1!=SAN_SIGNAL::SIDEWAYS))
            &&((baseSIG2!=SAN_SIGNAL::NOSIG)&&(baseSIG2!=SAN_SIGNAL::SIDEWAYS))
        ) {
         return (
                   ((compareSIG==baseSIG1)
                    &&(compareSIG==baseSIG2)
                    &&(baseSIG1==baseSIG2))
                   ?
                   compareSIG
                   :
                   SAN_SIGNAL::CLOSE
                );
      }
   }
// ###################################################################
   return SAN_SIGNAL::NOSIG;
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL        HSIG::simpleSIG(
   const SAN_SIGNAL sig1,
   const SAN_SIGNAL sig2=EMPTY,
   const SAN_SIGNAL sig3=EMPTY,
   const SAN_SIGNAL sig4=EMPTY,
   const SAN_SIGNAL sig5=EMPTY
) {

   if((sig2!=EMPTY)&&(sig3!=EMPTY)&&(sig4!=EMPTY)&&(sig5!=EMPTY)) {
      if(
         (sig1==SAN_SIGNAL::NOSIG)||
         (sig2==SAN_SIGNAL::NOSIG)||
         (sig3==SAN_SIGNAL::NOSIG)||
         (sig4==SAN_SIGNAL::NOSIG)||
         (sig5==SAN_SIGNAL::NOSIG)
      )
         return SAN_SIGNAL::NOSIG;

      if((sig1!=sig2)||(sig2!=sig3)||(sig3!=sig4)||(sig4!=sig5))
         return SAN_SIGNAL::NOSIG;

      if((sig1==sig2)&&(sig2==sig3)&&(sig3==sig4)&&(sig4==sig5))
         return sig1;
   }

   if((sig2!=EMPTY)&&(sig3!=EMPTY)&&(sig4!=EMPTY)) {
      if(
         (sig1==SAN_SIGNAL::NOSIG)||
         (sig2==SAN_SIGNAL::NOSIG)||
         (sig3==SAN_SIGNAL::NOSIG)||
         (sig4==SAN_SIGNAL::NOSIG)
      )
         return SAN_SIGNAL::NOSIG;

      if((sig1!=sig2)||(sig2!=sig3)||(sig3!=sig4))
         return SAN_SIGNAL::NOSIG;

      if((sig1==sig2)&&(sig2==sig3)&&(sig3==sig4))
         return sig1;
   }

   if((sig2!=EMPTY)&&(sig3!=EMPTY)) {
      if(
         (sig1==SAN_SIGNAL::NOSIG)||
         (sig2==SAN_SIGNAL::NOSIG)||
         (sig3==SAN_SIGNAL::NOSIG)
      )
         return SAN_SIGNAL::NOSIG;

      if((sig1!=sig2)||(sig2!=sig3))
         return SAN_SIGNAL::NOSIG;

      if((sig1==sig2)&&(sig2==sig3))
         return sig1;

   }

   if(sig2!=EMPTY) {
      if(
         (sig1==SAN_SIGNAL::NOSIG)||
         (sig2==SAN_SIGNAL::NOSIG)
      )
         return SAN_SIGNAL::NOSIG;

      if(sig1!=sig2)
         return SAN_SIGNAL::NOSIG;

      if(sig1==sig2)
         return sig1;
   }

   if(sig1==SAN_SIGNAL::NOSIG)
      return SAN_SIGNAL::NOSIG;
   return sig1;
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL        HSIG::simpleTrendSIG(SANTREND tr1, SANTREND tr2=EMPTY) {

   if(tr2!=EMPTY) {
      if((tr1==SANTREND::NOTREND)
            ||(tr2==SANTREND::NOTREND)
        )
         return SAN_SIGNAL::NOSIG;

      if(tr1==tr2)
         return util.convTrendToSig(tr1);
      if(tr1!=tr2)
         return SAN_SIGNAL::NOSIG;
   }

   if(tr1==SANTREND::NOTREND)
      return SAN_SIGNAL::NOSIG;
   return util.convTrendToSig(tr1);

}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL        HSIG::trendSIG(SANTREND tr1, SANTREND tr2, SANTREND tr3, SANTREND tr4=EMPTY, SANTREND tr5=EMPTY, SANTREND tr6=EMPTY) {
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
//| When the signal  and its trend match.
// if sig says buy and trend is up
// if sig says sell and trend is down                                           |
//+------------------------------------------------------------------+
SAN_SIGNAL        HSIG::sigTrSIG(
   const SAN_SIGNAL sig,
   const SANTREND tr
) {
   bool notSidewaySigBool = ((sig!=SAN_SIGNAL::NOSIG)&&(sig!=SAN_SIGNAL::SIDEWAYS));

   bool notFlatTrendBool = ((tr!=SANTREND::NOTREND)
                            &&(tr!=SANTREND::FLAT)
                            &&(tr!=SANTREND::FLATUP)
                            &&(tr!=SANTREND::FLATDOWN)
                            &&(util.convTrendToSig(tr)!=SAN_SIGNAL::SIDEWAYS)
                           );
   bool notCloseTrendBool = (!util.oppSigTrend(sig,tr));

   if((tr==SANTREND::FLAT)||(tr==SANTREND::FLATUP)||(tr==SANTREND::FLATDOWN)||(sig==SAN_SIGNAL::SIDEWAYS)) {
      return SAN_SIGNAL::SIDEWAYS;
   }

   if(util.oppSigTrend(sig,tr)) {
      return SAN_SIGNAL::CLOSE;
   }

   if(notSidewaySigBool && notFlatTrendBool && notCloseTrendBool && (sig==util.convTrendToSig(tr))) {
      return sig;
   }

   return SAN_SIGNAL::NOSIG;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL        HSIG::imaTrendSIG(
   const SAN_SIGNAL baseMASig,
   const SANTREND fastTrend,
   const SANTREND slowTrend
) {

   bool baseSigBool = ((baseMASig!=SAN_SIGNAL::NOSIG)&&(baseMASig!=SAN_SIGNAL::SIDEWAYS));

   bool baseTrendBool = ((fastTrend!=SANTREND::NOTREND)
                         &&(fastTrend!=SANTREND::FLAT)
                         &&(fastTrend!=SANTREND::FLATUP)
                         &&(fastTrend!=SANTREND::FLATDOWN)
                         &&(util.convTrendToSig(fastTrend)!=SAN_SIGNAL::SIDEWAYS)
                        );
   bool notCloseTrendBool = ((slowTrend!=SANTREND::NOTREND)
                             &&(slowTrend!=SANTREND::FLAT)
                             &&(slowTrend!=SANTREND::FLATUP)
                             &&(slowTrend!=SANTREND::FLATDOWN)
                             &&(util.convTrendToSig(slowTrend)!=SAN_SIGNAL::SIDEWAYS)
                            );


   if((fastTrend==SANTREND::FLAT)||(fastTrend==SANTREND::FLATUP)||(fastTrend==SANTREND::FLATDOWN)||(baseMASig==SAN_SIGNAL::SIDEWAYS)) {
      return SAN_SIGNAL::SIDEWAYS;
   }

   if(util.oppSignal(baseMASig,util.convTrendToSig(fastTrend))) {
      return SAN_SIGNAL::CLOSE;
   }

   if(baseSigBool
         &&  baseTrendBool
         &&  notCloseTrendBool
         && (baseMASig==util.convTrendToSig(fastTrend))
         && (baseMASig==util.convTrendToSig(slowTrend))
     ) {
      return baseMASig;
   }

   if(!baseSigBool
         ||!baseTrendBool
         ||!notCloseTrendBool
     ) {
      return SAN_SIGNAL::NOSIG;
   }

   return SAN_SIGNAL::NOSIG;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL        HSIG::imaTrend(SAN_SIGNAL imaSIG1, SAN_SIGNAL imaSIG2,
                                 SANTREND tr1, SANTREND tr2, SANTREND tr3,
                                 SAN_SIGNAL imaSIG3=EMPTY, SANTREND tr4=EMPTY,
                                 SAN_SIGNAL imaSIG4=EMPTY, SANTREND tr5=EMPTY) {
   SAN_SIGNAL sig1 = imaTrendSIG(imaSIG1,tr1,tr2);
   SAN_SIGNAL sig2 = imaTrendSIG(imaSIG2,tr2,tr3);
   SAN_SIGNAL sig3 = ((imaSIG3!=EMPTY)&&(tr4!=EMPTY))?imaTrendSIG(imaSIG3,tr3,tr4):SAN_SIGNAL::NOSIG;
   SAN_SIGNAL sig4 = ((imaSIG4!=EMPTY)&&(tr5!=EMPTY))?imaTrendSIG(imaSIG4,tr4,tr5):SAN_SIGNAL::NOSIG;

   SAN_SIGNAL sigTrend = ((tr4!=EMPTY)&&(tr5!=EMPTY))?trendSIG(tr1,tr2,tr3,tr4,tr5)
                         :(((tr4!=EMPTY)&&(tr5==EMPTY))?trendSIG(tr1,tr2,tr3,tr4):(((tr4==EMPTY)&&(tr5==EMPTY))?trendSIG(tr1,tr2,tr3):SAN_SIGNAL::NOSIG));

//      Print("[SIGIN] sig1: "+util.getSigString(sig1)+" sig2: "+util.getSigString(sig2)+" sig3: "+util.getSigString(sig3)+" sig4: "+util.getSigString(sig4)+" sigTrend: "+util.getSigString(sigTrend));

   if(util.oppSignal(sig1,sig2)
         ||util.oppSignal(sig1,sigTrend)
         ||util.oppSignal(sig2,sigTrend)
         ||(sig2==SAN_SIGNAL::CLOSE)
     ) {
      return SAN_SIGNAL::CLOSE;
   }

   if((sigTrend==SAN_SIGNAL::SIDEWAYS)
         ||(sig1==SAN_SIGNAL::SIDEWAYS)
     ) {
      return SAN_SIGNAL::SIDEWAYS;
   }
   if(
      ((imaSIG3!=EMPTY)&&(imaSIG4!=EMPTY)&&(sig1!=SAN_SIGNAL::NOSIG)&&(sig1==sigTrend)&&(sig1==sig2)&&(sig2==sig3)&&(sig3==sig4))
      ||((imaSIG4==EMPTY)&&(imaSIG3!=EMPTY)&&(sig1!=SAN_SIGNAL::NOSIG)&&(sig1==sigTrend)&&(sig1==sig2)&&(sig2==sig3))
      ||((imaSIG4==EMPTY)&&(imaSIG3==EMPTY)&&(sig1!=SAN_SIGNAL::NOSIG)&&(sig1==sigTrend)&&(sig1==sig2))
   ) {
      return sig1;
   }

   return SAN_SIGNAL::NOSIG;
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL        HSIG::fSigSlowTrendSIG(
   const SAN_SIGNAL baseSig,
   const SANTREND baseTrend
) {
   bool baseSigBool = ((baseSig!=SAN_SIGNAL::NOSIG)&&(baseSig!=SAN_SIGNAL::SIDEWAYS));
   bool baseTrendBool = ((baseTrend!=SANTREND::NOTREND)
                         &&(baseTrend!=SANTREND::FLAT)
                         &&(baseTrend!=SANTREND::FLATUP)
                         &&(baseTrend!=SANTREND::FLATDOWN)
                         &&(util.convTrendToSig(baseTrend)!=SAN_SIGNAL::SIDEWAYS)
                        );
   if(baseSigBool && baseTrendBool) {
      if(baseSig==util.convTrendToSig(baseTrend)) {
         return baseSig;
      } else if(
         ((baseTrend==SANTREND::FLAT)||(baseTrend==SANTREND::FLATUP)||(baseTrend==SANTREND::FLATDOWN))
         ||(util.oppSigTrend(baseSig,baseTrend))
      ) {
         return SAN_SIGNAL::CLOSE;
      }

   }
   return SAN_SIGNAL::NOSIG;
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL        HSIG::dualFastSigSlowTrendSIG(
   const SAN_SIGNAL baseSig,
   const SANTREND baseTrend,
   const SAN_SIGNAL fastSig,
   const SANTREND fastTrend
) {
   SAN_SIGNAL mainSIG = fSigSlowTrendSIG(baseSig,baseTrend);
   SAN_SIGNAL closeSIG = fSigSlowTrendSIG(fastSig,fastTrend);

   if(
      (mainSIG!=SAN_SIGNAL::NOSIG)
      &&(mainSIG!=SAN_SIGNAL::SIDEWAYS)
      &&(mainSIG==closeSIG)
   ) {
      return mainSIG;
   } else if(
      (mainSIG!=SAN_SIGNAL::NOSIG)
      &&(mainSIG!=SAN_SIGNAL::SIDEWAYS)
      &&util.oppSignal(mainSIG,closeSIG)
   ) {
      return SAN_SIGNAL::CLOSE;
   }

   return SAN_SIGNAL::NOSIG;
}


//+------------------------------------------------------------------+
SAN_SIGNAL           HSIG::fastImaSlowTrendSIG(
   const SAN_SIGNAL imaSig,
   const SANTREND closeTrend,
   const SANTREND fastTrend,
   const SANTREND slowTrend,
   const SANTREND vSlowTrend=SANTREND::NOTREND
) {
   if((imaSig!=SAN_SIGNAL::NOSIG)&&(imaSig!=SAN_SIGNAL::SIDEWAYS)) {
      if((util.oppSignal(imaSig,util.convTrendToSig(closeTrend)))||(util.oppSignal(imaSig,util.convTrendToSig(fastTrend)))) {
         return SAN_SIGNAL::CLOSE;
      } else if((vSlowTrend!=SANTREND::NOTREND)&&(imaSig==util.convTrendToSig(fastTrend))&&(imaSig==util.convTrendToSig(slowTrend))&&(imaSig==util.convTrendToSig(vSlowTrend))) {
         return imaSig;
      } else if((vSlowTrend==SANTREND::NOTREND)&&(imaSig==util.convTrendToSig(fastTrend))&&(imaSig==util.convTrendToSig(slowTrend))) {
         return imaSig;
      }
   }
   return SAN_SIGNAL::NOSIG;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL          HSIG::trendVolVarSIG(
   const SAN_SIGNAL tradeVolVarSIG,
   const SANTREND fastTrend,
   const SANTREND mediumTrend,
   const SANTREND slowTrend,
   const SANTREND vSlowTrend=SANTREND::NOTREND
) {
   const SAN_SIGNAL  BUY = SAN_SIGNAL::BUY;
   const SAN_SIGNAL SELL = SAN_SIGNAL::SELL;
   const SANTREND UP = SANTREND::UP;
   const SANTREND DOWN = SANTREND::DOWN;
   const SANTREND FLAT = SANTREND::FLAT;
   const SANTREND FLATUP = SANTREND::FLATUP;
   const SANTREND FLATDOWN = SANTREND::FLATDOWN;

   bool validSlowTrendBool = (tradeVolVarSIG!=SAN_SIGNAL::NOSIG)&&(fastTrend!=SANTREND::NOTREND)&&(mediumTrend!=SANTREND::NOTREND)&&(slowTrend!=SANTREND::NOTREND)&&(vSlowTrend!=SANTREND::NOTREND);
   bool validTrendBool = (tradeVolVarSIG!=SAN_SIGNAL::NOSIG)&&(fastTrend!=SANTREND::NOTREND)&&(mediumTrend!=SANTREND::NOTREND)&&(slowTrend!=SANTREND::NOTREND);


   if((tradeVolVarSIG==SAN_SIGNAL::NOTRADE)||(tradeVolVarSIG==SAN_SIGNAL::SIDEWAYS)) {
      return SAN_SIGNAL::CLOSE;
   } else if(validSlowTrendBool) {
      if((tradeVolVarSIG==BUY)&&(fastTrend==UP)&&(mediumTrend==UP)&&(slowTrend==UP)&&(vSlowTrend==UP)) {
         return tradeVolVarSIG;
      }
      if((tradeVolVarSIG==SELL)&&(fastTrend==DOWN)&&(mediumTrend==DOWN)&&(slowTrend==DOWN)&&(vSlowTrend==DOWN)) {
         return tradeVolVarSIG;
      }
      if(
         ((slowTrend==FLAT)||(slowTrend==FLATUP)||(slowTrend==FLATDOWN))
         ||((vSlowTrend==FLAT)||(vSlowTrend==FLATUP)||(vSlowTrend==FLATDOWN))
      ) {
         return SAN_SIGNAL::CLOSE;
      }
   } else if(validTrendBool) {
      if((tradeVolVarSIG==BUY)&&(fastTrend==UP)&&(mediumTrend==UP)&&(slowTrend==UP)) {
         return tradeVolVarSIG;
      }
      if((tradeVolVarSIG==SELL)&&(fastTrend==DOWN)&&(mediumTrend==DOWN)&&(slowTrend==DOWN)) {
         return tradeVolVarSIG;
      }
      if((slowTrend==FLAT)||(slowTrend==FLATUP)||(slowTrend==FLATDOWN)) {
         return SAN_SIGNAL::CLOSE;
      }
   }
   return SAN_SIGNAL::NOSIG;
}


SAN_SIGNAL HSIG::slopeSIG(const DataTransport& signalDt, const int signalType=0) {

   if(signalType==0) {
      if((signalDt.matrixD[0]>=-0.2)&&(signalDt.matrixD[0]<=0.2)) return SAN_SIGNAL::CLOSE;
      if((signalDt.matrixD[0]>=-0.3)&&(signalDt.matrixD[0]<=0.3)) return SAN_SIGNAL::SIDEWAYS;
      if(signalDt.matrixD[0]>0.3)return SAN_SIGNAL::BUY;
      if(signalDt.matrixD[0]<-0.3)return SAN_SIGNAL::SELL;
   } else if(signalType==1) {
      if((signalDt.matrixD[0]>=-0.1)&&(signalDt.matrixD[0]<=0.1)) return SAN_SIGNAL::CLOSE;
      if((signalDt.matrixD[0]>=-0.2)&&(signalDt.matrixD[0]<=0.2)) return SAN_SIGNAL::SIDEWAYS;
      if(signalDt.matrixD[0]>0.2)return SAN_SIGNAL::BUY;
      if(signalDt.matrixD[0]<-0.2)return SAN_SIGNAL::SELL;
   } else if(signalType==2) {
      if((signalDt.matrixD[0]>=-0.05)&&(signalDt.matrixD[0]<=0.05)) return SAN_SIGNAL::CLOSE;
      if((signalDt.matrixD[0]>=-0.1)&&(signalDt.matrixD[0]<=0.1)) return SAN_SIGNAL::SIDEWAYS;
      if(signalDt.matrixD[0]>0.1)return SAN_SIGNAL::BUY;
      if(signalDt.matrixD[0]<-0.1)return SAN_SIGNAL::SELL;
   }
   return SAN_SIGNAL::NOSIG;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL HSIG::cTradeSIG(
   const SANSIGNALS &ss,
   SanUtils& util,
   const uint SHIFT=1
) {

// Use three parameters for evaluating the trade signal.
// CP StdDev slope.
// obvCP slope. Currently not used and under observation and consideration
// Cluster
// SlopeRatio
// Note: Slope30 is calculated but not used. Ideally it is best left to
// to be paired separately with another base signal and then compared to trade signal
// cSIG makes use of slope30 signal

   //const double STDSLOPE = -0.6;
   //const double OBVSLOPE = 3000;
   //const double SLOPERATIO = 0.5;
   //const double SLOPERATIO_UPPERLIMIT = 20;
   //const double CLUSTERRANGEPLUS = (1+0.03);
   //const double CLUSTERRANGEMINUS = (1-0.03);
   //const int CLUSTERRANGEFLAT = 1;

   double pipValue = ut.getPipValue(_Symbol);
   SAN_SIGNAL sig = SAN_SIGNAL::NOSIG;
//   SAN_SIGNAL tradePosition = util.getCurrTradePosition();

   double slopeIMA30 = ss.imaSlope30Data.matrixD[0];
   double stdCPSlope = ss.stdCPSlope.matrixD[0];
   double obvCPSlope = ss.obvCPSlope.matrixD[0]*pipValue; // Normalize obvCPSlope

   double rFM =  ss.clusterData.matrixD[0];
   double rMS =  ss.clusterData.matrixD[1];
   double rFS =  ss.clusterData.matrixD[2];
   double fMSR = ss.slopeRatioData.matrixD[0];
   double fMSWR= ss.slopeRatioData.matrixD[1];
   double fMR = ss.slopeRatioData.matrixD[2];
   double mSR = ss.slopeRatioData.matrixD[3];
   double mSWR = ss.slopeRatioData.matrixD[4];



   bool strictFlatClusterBool = ((rFM==CLUSTERRANGEFLAT)&&(rMS==CLUSTERRANGEFLAT)&&(rFS==CLUSTERRANGEFLAT));

   bool flatClusterBool = (
                             ((rFM==CLUSTERRANGEFLAT)&&(rMS==CLUSTERRANGEFLAT))||
                             ((rMS==CLUSTERRANGEFLAT)&&(rFS==CLUSTERRANGEFLAT))||
                             ((rFM==CLUSTERRANGEFLAT)&&(rFS==CLUSTERRANGEFLAT))
                          );

   bool rangeFlatClusterBool = (
                                  ((rFM>0)&&((rFM>=CLUSTERRANGEMINUS)&&(rFM<=CLUSTERRANGEPLUS)))
                                  &&((rMS>0)&&((rMS>=CLUSTERRANGEMINUS)&&(rMS<=CLUSTERRANGEPLUS)))
                                  &&((rFS>0)&&((rFS>=CLUSTERRANGEMINUS)&&(rFS<=CLUSTERRANGEPLUS)))
                               );

   bool flatSlope30Bool = (slopeSIG(ss.imaSlope30Data,0)==SAN_SIGNAL::SIDEWAYS); //(fabs(slopeIMA30)<=0.4);



   bool closeSlopeRatioBool =  (fMSWR<SLOPERATIO);
//   bool closeSlopeRatioBool =  getMktCloseOnSlopeRatio();
   bool closeClusterBool =  (((rFM<0)&&(rMS<0))||((rMS<0)&&(rFS<0))||((rFM<0)&&(rFS<0)));
   bool closeTrendStdCP = (stdCPSlope<=STDSLOPE);
   bool closeSlope30Bool = (slopeSIG(ss.imaSlope30Data,0)==SAN_SIGNAL::CLOSE); //(fabs(slopeIMA30)<=0.3);
   bool closeOBVCPBool = (fabs(obvCPSlope)<=OBVSLOPE);


   bool flatBool = (strictFlatClusterBool||rangeFlatClusterBool||flatClusterBool||flatSlope30Bool);

   bool trendStdCP = (stdCPSlope>STDSLOPE);

   bool trendBuySlope30 = (slopeSIG(ss.imaSlope30Data,0)==SAN_SIGNAL::BUY); //(slopeIMA30>0.4); // slope30 is not used for Trade Signal
   bool trendSellSlope30 = (slopeSIG(ss.imaSlope30Data,0)==SAN_SIGNAL::SELL);//(slopeIMA30<-0.4);

   bool trendBuyOBVBool = (obvCPSlope > OBVSLOPE);
   bool trendSellOBVBool = (obvCPSlope < (-1*OBVSLOPE));

   bool trendBuyClusterBool = (
                                 (rFM>CLUSTERRANGEPLUS)&&
                                 (rMS>CLUSTERRANGEPLUS)&&
                                 (rFS>CLUSTERRANGEPLUS)&&
                                 (rFM<rMS)
                              );

   bool trendSellClusterBool = (
                                  ((rFM>=0)&&(rFM<CLUSTERRANGEMINUS))&&
                                  ((rMS>=0)&&(rMS<CLUSTERRANGEMINUS))&&
                                  ((rFS>=0)&&(rFS<CLUSTERRANGEMINUS))&&
                                  (rFM>rMS)
                               );

   bool trendClusterBool = (
                              trendBuyClusterBool||trendSellClusterBool
                           );

   bool trendSlopeRatioBool  = ((fMSWR>=SLOPERATIO)&&(fMSWR<=SLOPERATIO_UPPERLIMIT));


   bool openTradeBool = (trendStdCP&&trendSlopeRatioBool);

   bool closeSTDCPTradeBool = (
                                 closeTrendStdCP&&
                                 (
                                    closeSlopeRatioBool||
                                    closeOBVCPBool||
                                    closeClusterBool||
                                    closeSlope30Bool
                                 )
                              );


   bool closeSlopeRatioTradeBool = (
                                      closeSlopeRatioBool&&
                                      (
                                         closeTrendStdCP||
                                         closeOBVCPBool||
                                         closeClusterBool||
                                         closeSlope30Bool
                                      )
                                   );

   bool closeTradeBool = (closeSTDCPTradeBool||closeSlopeRatioTradeBool);

   bool noTradeBoo11 = (closeTradeBool);
   bool noTradeBoo12 = (closeTradeBool&&flatBool);


   bool noSigBool = (
                       (openTradeBool&&closeTradeBool)||
//(closeTrendStdCP&&trendSlopeRatioBool)||
//(closeTrendStdCP&&trendClusterBool)||
                       (closeTradeBool&&trendClusterBool)||
                       (closeTradeBool&&(trendBuyOBVBool|trendSellOBVBool))||
                       (closeTradeBool&&(trendBuySlope30|trendSellSlope30))
                    );

   bool buyTradeBool = (openTradeBool&&trendBuyOBVBool&&(trendBuyClusterBool||trendBuySlope30));
   bool sellTradeBool = (openTradeBool&&trendSellOBVBool&&(trendSellClusterBool||trendSellSlope30));

   if(noTradeBoo11||noTradeBoo12) {
      sig = SAN_SIGNAL::NOTRADE;
   } else   if(noSigBool) {
      sig = sig = SAN_SIGNAL::NOSIG;
   } else if(buyTradeBool) {
      sig = SAN_SIGNAL::TRADEBUY;
   } else if(sellTradeBool) {
      sig = SAN_SIGNAL::TRADESELL;
   } else if(openTradeBool) {
      sig = SAN_SIGNAL::TRADE;
   } else {
      sig = SAN_SIGNAL::NOTRADE;
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   Print("[CTRADE] tradeSIG: "+ util.getSigString(sig)+" stdCPSlope: "+stdCPSlope+" obvCPSlope: "+obvCPSlope+" Slope30: "+slopeIMA30+" fMSWR: "+fMSWR+" rFM: "+rFM+" rMS: "+rMS);//+" rFS: "+rFS);
   Print("[CTRADE-CLOSE] closeTrendStdCP: "+closeTrendStdCP+" closeSlopeRatioBool:"+closeSlopeRatioBool+" closeClusterBool: "+closeClusterBool+" flatBool "+flatBool+" strictFlatClusterBool "+strictFlatClusterBool+" flatClusterBool "+flatClusterBool+" rangeFlatClusterBool "+rangeFlatClusterBool);
   Print("[CTRADE-OPEN] trendStdCP:"+trendStdCP+" trendSlopeRatioBool: "+trendSlopeRatioBool + " trendBuyClusterBool: "+trendBuyClusterBool+" trendSellClusterBool: "+trendSellClusterBool +" OBV BUY: "+trendBuyOBVBool+" OBV Sell: "+trendSellOBVBool);
//   Print("[CTRADE_1] noTradeBoo11: "+noTradeBoo11+" noTradeBoo12: "+noTradeBoo12+" noSigBool: "+noSigBool+" buyTradeBool: "+buyTradeBool+" sellTradeBool: "+sellTradeBool+" tradeBool: "+tradeBool );

   return sig;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL HSIG::cSIG(
   const SANSIGNALS &ss,
   SanUtils& util,
   const uint SHIFT=1
) {

   SAN_SIGNAL sig = SAN_SIGNAL::NOSIG;
   double pipValue = ut.getPipValue(_Symbol);
   //const double STDSLOPE = -0.6;
   //const double SLOPE30LIMIT = 3;
   //const double OBVSLOPE = 3000;

   double stdCPSlope = ss.stdCPSlope.matrixD[0];
   double obvCPSlope = ss.obvCPSlope.matrixD[0]*pipValue; // Normalize obvCPSlope

   bool trendStdCP = (stdCPSlope>STDSLOPE);
   bool trendBuyOBVBool = (obvCPSlope > OBVSLOPE);
   bool trendSellOBVBool = (obvCPSlope < (-1*OBVSLOPE));

   SAN_SIGNAL slopesig = slopeSIG(ss.imaSlope30Data,0);

   if(trendStdCP && (fabs(ss.imaSlope30Data.matrixD[0])>SLOPE30LIMIT)) {
      sig = slopesig;
   } else if((tradeSIG==SAN_SIGNAL::TRADEBUY)&&(slopesig==SAN_SIGNAL::BUY)) {
      sig = slopesig;
   } else if((tradeSIG==SAN_SIGNAL::TRADESELL)&&(slopesig==SAN_SIGNAL::SELL)) {
      sig = slopesig;
   }  else if (trendStdCP && ((trendBuyOBVBool&&(slopesig==SAN_SIGNAL::BUY))||(trendSellOBVBool&&(slopesig==SAN_SIGNAL::SELL)))) {
      sig = slopesig;
   } else if((tradeSIG==SAN_SIGNAL::TRADE)) {
      sig = slopesig;
   } else if(((tradeSIG==SAN_SIGNAL::NOTRADE)||(tradeSIG==SAN_SIGNAL::NOSIG))&&(slopesig==SAN_SIGNAL::CLOSE)) {
      sig = slopesig;
   }
   return sig;
}

////+------------------------------------------------------------------+
////|                                                                  |
////+------------------------------------------------------------------+
//DataTransport     HSIG::getSlopeRatioData(
//   const DataTransport &fast,
//   const DataTransport &medium,
//   const DataTransport &slow
//) {
//
//   double fastSlope=0;
//   double mediumSlope=0;
//   double slowSlope=0;
//   double slowSlopeWide=0;
//
//   double fMR=0;
//   double mSR=0;
//   double mSWR=0;
//   double fSR=0;
//   double fSWR=0;
//   double fMSR = 0;
//   double fMSWR = 0;
//
////DataTransport slopesData = slopeFastMediumSlow(fast,medium,slow,SLOPEDENOM,SLOPEDENOM_WIDE,shift);
//
//   DataTransport dt;
//   fastSlope = fast.matrixD[0];
//   mediumSlope = medium.matrixD[0];
//   slowSlope = slow.matrixD[0];
//   slowSlopeWide = slow.matrixD[1];
//
//   fMR = ((fastSlope!=0)&&(mediumSlope!=0))?NormalizeDouble((fastSlope/mediumSlope),4):EMPTY_VALUE;
//   mSR = ((mediumSlope!=0)&&(slowSlope!=0))?NormalizeDouble((mediumSlope/slowSlope),4):EMPTY_VALUE;
//   mSWR = ((mediumSlope!=0)&&(slowSlopeWide!=0))?NormalizeDouble((mediumSlope/slowSlopeWide),4):EMPTY_VALUE;
//   fSR = ((fastSlope!=0)&&(slowSlope!=0))?NormalizeDouble((fastSlope/slowSlope),4):EMPTY_VALUE;
//   fSWR = ((fastSlope!=0)&&(slowSlopeWide!=0))?NormalizeDouble((fastSlope/slowSlopeWide),4):EMPTY_VALUE;
//   fMSR = ((fMR!=0)&&(mSR!=0)&&(fMR!=EMPTY_VALUE)&&(mSR!=EMPTY_VALUE))?NormalizeDouble((fMR/mSR),4):EMPTY_VALUE;
//   fMSWR = ((fMR!=0)&&(mSWR!=0)&&(fMR!=EMPTY_VALUE)&&(mSWR!=EMPTY_VALUE))?NormalizeDouble((fMR/mSWR),4):EMPTY_VALUE;
//
////   Print("[SLOPESRATIO] fMR: "+fMR+" mSR: "+mSR+" mSWR: "+mSWR+" fSR: "+fSR+" fSWR: "+fSWR+" fMSR: "+fMSR+" fMSWR: "+fMSWR);
//   dt.matrixD[0]=fMSR;
//   dt.matrixD[1]=fMSWR;
//   dt.matrixD[2]=fMR;
//   dt.matrixD[3]=mSR;
//   dt.matrixD[4]=mSWR;
//
//   return dt;
//}



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool HSIG::getMktFlatBoolSignal(
   const SAN_SIGNAL candleVol120SIG,
   const SAN_SIGNAL slopeVarSIG,
   const SANTREND cpScatterSIG,
   const SANTREND trendRatioSIG,
   const SAN_SIGNAL trendSIG
) {

//   Print("[FLATS]: candleVol120SIG: "+ ut.getSigString(candleVol120SIG)+" slopeVarSIG: "+ ut.getSigString(slopeVarSIG)+" cpScatterSIG: "+ut.getSigString(cpScatterSIG)+" trendRatioSIG: "+ut.getSigString(trendRatioSIG));

   return (
             (
                (candleVol120SIG==SAN_SIGNAL::SIDEWAYS)
                ||(slopeVarSIG==SAN_SIGNAL::SIDEWAYS)
                ||(cpScatterSIG==SANTREND::FLAT)
                ||(cpScatterSIG==SANTREND::FLATUP)
                ||(cpScatterSIG==SANTREND::FLATDOWN)
                ||(trendRatioSIG==SANTREND::FLAT)
                ||(trendRatioSIG==SANTREND::FLATUP)
                ||(trendRatioSIG==SANTREND::FLATDOWN)
                ||(trendSIG==SAN_SIGNAL::SIDEWAYS)
//||(sig30==SAN_SIGNAL::SIDEWAYS)
             )
          );
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool  HSIG::getMktCloseOnStdCPOBV() {

   double pipValue = ut.getPipValue(_Symbol);
   double stdCPSlope = stdCPSlope.matrixD[0];
   double obvCPSlope = obvCPSlope.matrixD[0]*pipValue; // Normalize obvCPSlope

   bool closeTrendStdCP = (stdCPSlope<=STDSLOPE);
   bool trendBuyOBVBool = (obvCPSlope > OBVSLOPE);
   bool trendSellOBVBool = (obvCPSlope < (-1*OBVSLOPE));

   SAN_SIGNAL obvSIG = (trendBuyOBVBool)?SAN_SIGNAL::BUY:((trendSellOBVBool)?SAN_SIGNAL::SELL:SAN_SIGNAL::NOSIG);
   SAN_SIGNAL tradePosition = util.getCurrTradePosition();

   return (
             closeTrendStdCP&&
             util.oppSignal(obvSIG,tradePosition)
          )?true:false;
}
//+------------------------------------------------------------------+
//|  Close Signal: 1: Close on Slope ratios                                                                 |
//+------------------------------------------------------------------+

bool  HSIG::getMktCloseOnSlopeRatio() {

//double slopeR = ss.slopeRatioData.matrixD[0];
//double slopeWideR = ss.slopeRatioData.matrixD[1];

   double slopeR = slopeRatioData.matrixD[0];
   double slopeWideR = slopeRatioData.matrixD[1];
//Print("Slopes Ratio: slopeR: "+slopeR+" slopeWideR: "+slopeWideR);
   bool closeOnSlopeRatioBool = false;

   if((slopeWideR<SLOPERATIO)&&(slopeWideR!=EMPTY_VALUE))
      closeOnSlopeRatioBool=true;
   return closeOnSlopeRatioBool;

}


//bool  getMktCloseOnSimpleTrendReversal(const SAN_SIGNAL &sig,SanUtils &util) {
//   SAN_SIGNAL tradePosition = util.getCurrTradePosition();
//   return (util.oppSignal(sig,tradePosition))?true:false;
//}


//+------------------------------------------------------------------+
//| Close Signal: 2: IF Mkt is flat and fast fsig, medium fsig and slow fsig is close signal.
// if fast fsig and medium fsig are opposed to slow fsig then issue a close signal.
// if fsig combination is close and market is flat then close.
// Overloaded function. There is another function with a different param signature
//  below.                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool              HSIG::getMktCloseOnReversal(const SAN_SIGNAL &sig,SanUtils &util) {
   SAN_SIGNAL tradePosition = util.getCurrTradePosition();
   return (util.oppSignal(sig,tradePosition))?true:false;
}


//+------------------------------------------------------------------+
//| Close Signal: 3: IF Mkt is flat and fast fsig, medium fsig and slow fsig is close signal.
// if fast fsig and medium fsig are opposed to slow fsig then issue a close signal.
// if fsig combination is close and market is flat then close.
// Overloaded function. There is another function with a different param signature
//  below.                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool  HSIG::getMktCloseOnFlat(const SAN_SIGNAL &sig, const bool mktTypeFlat) {
   return ((sig==SAN_SIGNAL::CLOSE)&&(mktTypeFlat))?true:false;
}




//+------------------------------------------------------------------+
// Close signal 4: If slopes of fast ema medium ema and slow ema show healthy
// buy sell signals the issue a a buy or sell. However if one of the fastest ema signal slope reverses
// or falls from a previous high below a set threshold issues a signal in opposition to current
// traded position then issue a close. If the slope of the ema that is checked for a slope reversal is the one that
// is steepest and fastest. If the fastest is not steep enough then the next fastest ema is checked for relatively lower steepness
// and so on and so forth. This signal is very close to signal 4 and differs primarily in teh fact that the slopes are checked against a
// current traded position and not against a set threshold like signal 4.                                                                |
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool              HSIG::getMktCloseOnSlopeVariable(const SANSIGNALS &ss, SanUtils &util) {
// slopes of 30,120,240 ma curves
   SAN_SIGNAL tradePosition = util.getCurrTradePosition();

// Ver-1: [5->5.0, 14->4.0,30->1.8,120->1.2,240=0.6]
// Ver-2: [5->2.0, 14->1.0,30->0.5,120->0.2,240=0.08]
// Ver-3: [5->4.0, 14->3.0,30->1.8,120->1.6,240=1.0]
// Ver-4: [5->3.0, 14->2.5,30->1.0,120->0.8,240=0.4]
// Ver-5: [5->3.0, 14->2.2,30->1.8,120->1.2,240=0.6]
// Ver-6: [5->2.5, 14->1.5,30->0.8,120->0.6,240=0.2]
// Ver-7: [5->2.5, 14->1.5,30->0.8,120->0.2,240=0.08]
// Ver-8: [5->4.0, 14->1.5,30->0.8,120->0.2,240=0.08]
// Ver-9: [fsig5->4.0, fsig14->2.0,fsig30->0.8,fsig120->0.2,fsig240=0.08]


// Slopes for signals fsig5 and fsig14 are effectively outliers and not being captured.
// The main signal is based only on fsig30, fsig120 and fsig240. ideally the close on fsig5 and fsgi14 should not be activated.
// However they may be activated for very high slopes effectively disabling in that sense.
// Caution: a low slope values for fsig5 and fsig14 creates runaway trades leading to signnificant losses within a very short amount of time
// on account of false trade open and close signals.
   const double SLOPEGRADS[5] = {4.0,2.0,0.8,0.2,0.08}; // eventually an external param from function

   const double SLOPE_5=SLOPEGRADS[0];  //4.0;
   const double SLOPE_14= SLOPEGRADS[1]; //2.0;
   const double SLOPE_30=SLOPEGRADS[2]; //0.8;
   const double SLOPE_120=SLOPEGRADS[3]; //0.2;
   const double SLOPE_240=SLOPEGRADS[4]; //0.08;

   bool closeBool = false;
   static SAN_SIGNAL CLOSESIGNAL = SAN_SIGNAL::NOSIG;
//   Print("[SLOPES COMPARE] imaSlopesData: "+ ss.imaSlopesData.matrixD[0] + " slopes30: "+ss.imaSlope30Data.matrixD[0]+" Equal? "+(ss.imaSlope30Data.matrixD[0]==ss.imaSlopesData.matrixD[0]));
   if(fabs(ss.imaSlope30Data.matrixD[0])> SLOPE_5) {
      CLOSESIGNAL=ss.fsig5;
//      Print("[SIGCLOSE]: Close on (util.oppSignal(ss.fsig5,tradePosition))");
   } else if(fabs(ss.imaSlope30Data.matrixD[0])>=SLOPE_14) {
      CLOSESIGNAL=ss.fsig14;
//      Print("[SIGCLOSE]: Close on (util.oppSignal(ss.fsig14,tradePosition))");
   } else if(fabs(ss.imaSlope30Data.matrixD[0])>=SLOPE_30) {
      CLOSESIGNAL=ss.fsig30;
//      Print("[SIGCLOSE]: Close on (util.oppSignal(ss.fsig30,tradePosition))");
   } else if(fabs(ss.imaSlope30Data.matrixD[0])>=SLOPE_120) {
      CLOSESIGNAL=ss.fsig120;
//      Print("[SIGCLOSE]: Close on (util.oppSignal(ss.fsig120,tradePosition))");
   } else if(fabs(ss.imaSlope30Data.matrixD[0])>=SLOPE_240) {
      CLOSESIGNAL=ss.fsig240;
//      Print("[SIGCLOSE]: Close on (util.oppSignal(ss.fsig240,tradePosition))");
   }

   closeBool= (CLOSESIGNAL!=SAN_SIGNAL::NOSIG)?(util.oppSignal(CLOSESIGNAL,tradePosition)):false;
   if(closeBool)CLOSESIGNAL=SAN_SIGNAL::NOSIG;

   return closeBool;
}


//+------------------------------------------------------------------+
// Close signal 5: If slopes of fast ema medium ema and slow ema show healthy
// buy sell signals the issue a a buy or sell. However if one of the fastest ema signal slope reverses
// or falls from a previous high below then issue a close. If the slope of the ema that is checked for a slope reversal is the one that
// is steepest and fastest. If the fastest is not steep enough then the next fastest ema is checked for relatively lower steepness
// and so on and so forth. This signal differs from previous signal in that it checks and compares against a set threshold
// and not the current traded position.                                                                |
//+------------------------------------------------------------------+

bool              HSIG::getMktCloseOnSlopeReversal(const SANSIGNALS &ss, SanUtils &util, const double SLOPE_REDUCTION_LEVEL=0.3) {

// slopes of 30,120,240 ma curves

//const double SLOPE_REDUCTION_LEVEL=0.3;
   double SLOPE_LEVEL=(1-SLOPE_REDUCTION_LEVEL);

// Ver-1: [5->5.0, 14->4.0,30->1.8,120->1.2,240=0.6]
// Ver-2: [5->2.0, 14->1.0,30->0.5,120->0.2,240=0.08]
// Ver-3: [5->4.0, 14->3.0,30->1.8,120->1.6,240=1.0]
// Ver-4: [5->3.0, 14->2.5,30->1.0,120->0.8,240=0.4]
// Ver-5: [5->3.0, 14->2.2,30->1.8,120->1.2,240=0.6]
// Ver-6: [5->2.5, 14->1.5,30->0.8,120->0.6,240=0.2]
// Ver-7: [5->2.5, 14->1.5,30->0.8,120->0.2,240=0.08]
// Ver-8: [5->4.0, 14->1.5,30->0.8,120->0.2,240=0.08]
// Ver-9: [fsig5->4.0, fsig14->2.0,fsig30->0.8,fsig120->0.2,fsig240=0.08]


// Slopes for signals fsig5 and fsig14 are effectively outliers and not being captured.
// The main signal is based only on fsig30, fsig120 and fsig240. ideally the close on fsig5 and fsgi14 should not be activated.
// However they may be activated for very high slopes effectively disabling in that sense.
// Caution: a low slope values for fsig5 and fsig14 creates runaway trades leading to signnificant losses within a very short amount of time
// on account of false trade open and close signals.
   const double SLOPEGRADS[5] = {4.0,2.0,0.8,0.2,0.08}; // eventually an external param from function

   const double SLOPE_5=SLOPEGRADS[0];  //4.0;
   const double SLOPE_14= SLOPEGRADS[1]; //2.0;
   const double SLOPE_30=SLOPEGRADS[2]; //0.8;
   const double SLOPE_120=SLOPEGRADS[3]; //0.2;
   const double SLOPE_240=SLOPEGRADS[4]; //0.08;


   static bool slope2_0=false;
   static bool slope1_0=false;
   static bool slope0_5=false;
   static bool slope0_2=false;
   static bool slope0_08=false;


//bool slopeRBool = getMktCloseOnSlopeRatio();

   bool closeOnSlopeReverseBool = false;

   if(fabs(ss.imaSlope30Data.matrixD[0])> SLOPE_5) {
      slope2_0=true;
   }  else if(fabs(ss.imaSlope30Data.matrixD[0])>=SLOPE_14) {
      slope1_0=true;
   } else if(fabs(ss.imaSlope30Data.matrixD[0])>=SLOPE_30) {
      slope0_5=true;
   } else if(fabs(ss.imaSlope30Data.matrixD[0])>=SLOPE_120) {
      slope0_2=true;
   } else if(fabs(ss.imaSlope30Data.matrixD[0])>=SLOPE_240) {
      slope0_08=true;
   }

   if(slope2_0 &&(fabs(ss.imaSlope30Data.matrixD[0])<(SLOPE_5*SLOPE_LEVEL))) {
      closeOnSlopeReverseBool = true;
      slope2_0=false;
      Print("[SIGCLOSE]: Close on slope2_8 reverse");
   } else if (slope1_0&&(fabs(ss.imaSlope30Data.matrixD[0])<(SLOPE_14*SLOPE_LEVEL))) {
      closeOnSlopeReverseBool = true;
      slope1_0=false;
      Print("[SIGCLOSE]: Close on slope2_2 reverse");
   } else if (slope0_5&&(fabs(ss.imaSlope30Data.matrixD[0])<(SLOPE_30*SLOPE_LEVEL))) {
      closeOnSlopeReverseBool = true;
      slope0_5=false;
      Print("[SIGCLOSE]: Close on slope1_8 reverse");
   } else if (slope0_2&&(fabs(ss.imaSlope30Data.matrixD[0])<(SLOPE_120*SLOPE_LEVEL))) {
      closeOnSlopeReverseBool = true;
      slope0_2=false;
      Print("[SIGCLOSE]: Close on slope1_2 reverse");
   } else if (slope0_08&&(fabs(ss.imaSlope30Data.matrixD[0])<(SLOPE_240*SLOPE_LEVEL))) {
      closeOnSlopeReverseBool = true;
      slope0_08=false;
      Print("[SIGCLOSE]: Close on slope0_6 reverse");
   }
   return (closeOnSlopeReverseBool);
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool              HSIG::getMktClose(
   const SAN_SIGNAL candleVol120SIG,
   const SAN_SIGNAL slopeVarSIG,
   const SAN_SIGNAL trend_5_120_500_SIG,
   const SAN_SIGNAL sig30
) {

   return    (
                ((candleVol120SIG==SAN_SIGNAL::NOSIG)||(candleVol120SIG==SAN_SIGNAL::CLOSE))
                ||(slopeVarSIG==SAN_SIGNAL::CLOSE)
                ||(trend_5_120_500_SIG==SAN_SIGNAL::CLOSE)
                ||(sig30==SAN_SIGNAL::NOSIG)
             );

}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool              HSIG::getMktCloseOnFlat(
   const SAN_SIGNAL candleVol120SIG,
   const SAN_SIGNAL slopeVarSIG,
   const SANTREND cpScatterSIG,
   const SANTREND trendRatioSIG,
   const SAN_SIGNAL trendSIG
) {

   return (
             (
                (
                   (candleVol120SIG==SAN_SIGNAL::SIDEWAYS)
                )
                &&
                (
                   (slopeVarSIG==SAN_SIGNAL::SIDEWAYS)
                   ||(cpScatterSIG==SANTREND::FLAT)
                   ||(cpScatterSIG==SANTREND::FLATUP)
                   ||(cpScatterSIG==SANTREND::FLATDOWN)
                   ||(trendRatioSIG==SANTREND::FLAT)
                   ||(trendRatioSIG==SANTREND::FLATUP)
                   ||(trendRatioSIG==SANTREND::FLATDOWN)
                   ||(trendSIG==SAN_SIGNAL::SIDEWAYS)
                )
             )
             ||
             (
                (
                   (slopeVarSIG==SAN_SIGNAL::SIDEWAYS)
                )
                &&
                (
                   (candleVol120SIG==SAN_SIGNAL::SIDEWAYS)
                   ||(cpScatterSIG==SANTREND::FLAT)
                   ||(cpScatterSIG==SANTREND::FLATUP)
                   ||(cpScatterSIG==SANTREND::FLATDOWN)
                   ||(trendRatioSIG==SANTREND::FLAT)
                   ||(trendRatioSIG==SANTREND::FLATUP)
                   ||(trendRatioSIG==SANTREND::FLATDOWN)
                   ||(trendSIG==SAN_SIGNAL::SIDEWAYS)
                )
             )
             ||
             (
                (
                   (cpScatterSIG==SANTREND::FLAT)
                   ||(cpScatterSIG==SANTREND::FLATUP)
                   ||(cpScatterSIG==SANTREND::FLATDOWN)
                )
                &&
                ((candleVol120SIG==SAN_SIGNAL::SIDEWAYS)
                 ||(slopeVarSIG==SAN_SIGNAL::SIDEWAYS)
                 ||(trendRatioSIG==SANTREND::FLAT)
                 ||(trendRatioSIG==SANTREND::FLATUP)
                 ||(trendRatioSIG==SANTREND::FLATDOWN)
                 ||(trendSIG==SAN_SIGNAL::SIDEWAYS)
                )
             )
             ||
             (
                (
                   (trendRatioSIG==SANTREND::FLAT)
                   ||(trendRatioSIG==SANTREND::FLATUP)
                   ||(trendRatioSIG==SANTREND::FLATDOWN)
                )
                &&
                ((candleVol120SIG==SAN_SIGNAL::SIDEWAYS)
                 ||(slopeVarSIG==SAN_SIGNAL::SIDEWAYS)
                 ||(cpScatterSIG==SANTREND::FLAT)
                 ||(cpScatterSIG==SANTREND::FLATUP)
                 ||(cpScatterSIG==SANTREND::FLATDOWN)
                 ||(trendSIG==SAN_SIGNAL::SIDEWAYS)
                )
             )
             ||
             (
                (
                   (trendSIG==SAN_SIGNAL::SIDEWAYS)
                )
                &&
                ((candleVol120SIG==SAN_SIGNAL::SIDEWAYS)
                 ||(slopeVarSIG==SAN_SIGNAL::SIDEWAYS)
                 ||(cpScatterSIG==SANTREND::FLAT)
                 ||(cpScatterSIG==SANTREND::FLATUP)
                 ||(cpScatterSIG==SANTREND::FLATDOWN)
                 ||(trendRatioSIG==SANTREND::FLAT)
                 ||(trendRatioSIG==SANTREND::FLATUP)
                 ||(trendRatioSIG==SANTREND::FLATDOWN)
                )
             )
          );

}
//+------------------------------------------------------------------+
