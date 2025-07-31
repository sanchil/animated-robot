//+------------------------------------------------------------------+
//|                                                      SanHsig.mqh |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property strict
#include <Sandeep/SanTypes.mqh>
#include <Sandeep/SanUtils.mqh>


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

struct HSIG {

   SanUtils* ut;
   SANSIGNALS ssSIG;

   MKTTYP            mktType;
   TRADE_STRATEGIES trdStgy;
   SAN_SIGNAL       baseTrendSIG;
   SAN_SIGNAL       baseSlopeSIG;
   DataTransport     imaSlopesData;
   DataTransport     slopeRatioData;

   bool              slopeTrendBool;
   SAN_SIGNAL        openSIG;
   SAN_SIGNAL        closeSIG;
   SAN_SIGNAL        fastSIG;
   SAN_SIGNAL        mainFastSIG;
   SAN_SIGNAL        slopeFastSIG;
   SAN_SIGNAL        rsiFastSIG;
   SAN_SIGNAL        cpFastSIG;
   SAN_SIGNAL        cpSlopeVarFastSIG;
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

   HSIG() {
      mktType= MKTTYP::NOMKT;
      trdStgy = TRADE_STRATEGIES::NOTRDSTGY;
      baseTrendSIG=SAN_SIGNAL::NOSIG;
      baseSlopeSIG=SAN_SIGNAL::NOSIG;
      openSIG =  SAN_SIGNAL::NOSIG;
      closeSIG =  SAN_SIGNAL::NOSIG;
      slopeTrendBool=false;
      fastSIG =  SAN_SIGNAL::NOSIG;
      mainFastSIG = SAN_SIGNAL::NOSIG;
      slopeFastSIG = SAN_SIGNAL::NOSIG;
      rsiFastSIG = SAN_SIGNAL::NOSIG;
      cpFastSIG = SAN_SIGNAL::NOSIG;
      cpSlopeVarFastSIG = SAN_SIGNAL::NOSIG;
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

   }
   ~HSIG() {
      mktType=MKTTYP::NOMKT;
      trdStgy = TRADE_STRATEGIES::NOTRDSTGY;
      baseTrendSIG=SAN_SIGNAL::NOSIG;
      baseSlopeSIG=SAN_SIGNAL::NOSIG;
      openSIG =  SAN_SIGNAL::NOSIG;
      closeSIG =  SAN_SIGNAL::NOSIG;
      slopeTrendBool=false;
      fastSIG =  SAN_SIGNAL::NOSIG;
      mainFastSIG = SAN_SIGNAL::NOSIG;
      slopeFastSIG = SAN_SIGNAL::NOSIG;
      rsiFastSIG = SAN_SIGNAL::NOSIG;
      cpFastSIG = SAN_SIGNAL::NOSIG;
      cpSlopeVarFastSIG = SAN_SIGNAL::NOSIG;
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
      imaSlopesData.freeData();
      slopeRatioData.freeData();
   }

   HSIG(const SANSIGNALS &ss, SanUtils &util) {

      ut = util;
      ssSIG = ss;
      initSIG(ss,util);
   }



   void initSIG(const SANSIGNALS &ss, SanUtils &util) {

      baseTrendSIG = imaTrendSIG(ss.ima120240SIG,ss.trendRatio120SIG,ss.trendRatio240SIG);
      baseSlopeSIG = getBaseSlopeSIG(ss.baseSlopeData);
      mainFastSIG = matchSIG(ss.candleVol120SIG, ss.ima1430SIG);
      slopeFastSIG = matchSIG(ss.slopeVarSIG, ss.ima1430SIG);
      rsiFastSIG = matchSIG(ss.rsiSIG, ss.ima1430SIG);
      cpFastSIG = matchSIG(util.convTrendToSig(ss.cpScatterSIG), ss.ima1430SIG);
      cpSlopeVarFastSIG= matchSIG(util.convTrendToSig(ss.cpScatterSIG),ss.slopeVarSIG);
      dominantTrendIma240SIG = fastImaSlowTrendSIG(ss.ima120240SIG,ss.trendRatio30SIG,ss.trendRatio120SIG,ss.trendRatio240SIG);
      dominantTrendIma120SIG = fastImaSlowTrendSIG(ss.ima30120SIG,ss.trendRatio30SIG,ss.trendRatio30SIG,ss.trendRatio120SIG,ss.trendRatio240SIG);
      dominant240SIG = imaTrendSIG(ss.sig120,ss.cpScatterSIG,ss.trendRatio240SIG);
      dominant120SIG = imaTrendSIG(ss.sig30,ss.trendRatio30SIG,ss.trendRatio120SIG);
      dominant30SIG = imaTrendSIG(ss.ima1430SIG,ss.trendRatio14SIG,ss.trendRatio30SIG);
      simple_14_SIG = simpleSIG(ss.fsig14);
      simple_30_SIG = simpleSIG(ss.fsig30);
      simple_5_14_SIG = simpleSIG(ss.fsig5, ss.fsig14);
      simple_14_30_SIG = simpleSIG(ss.fsig14, ss.fsig30);
      simple_30_120_SIG = simpleSIG(ss.fsig30, ss.fsig120);
      simpleTrend_14_SIG = simpleTrendSIG(ss.trendRatio14SIG);
      simpleTrend_30_SIG = simpleTrendSIG(ss.trendRatio30SIG);
      simpleTrend_5_14_SIG =  simpleTrendSIG(ss.trendRatio5SIG,ss.trendRatio14SIG);
      simpleTrend_14_30_SIG =  simpleTrendSIG(ss.trendRatio14SIG,ss.trendRatio30SIG);
      simpleTrend_30_120_SIG =  simpleTrendSIG(ss.trendRatio30SIG,ss.trendRatio120SIG);
      trend_5_120_500_SIG = trendSIG(ss.trendRatio5SIG,ss.trendRatio120SIG,ss.trendRatio500SIG);
      trend_5_30_120_SIG = trendSIG(ss.trendRatio5SIG,ss.trendRatio30SIG,ss.trendRatio120SIG);
      trend_5_14_30_SIG = trendSIG(ss.trendRatio5SIG,ss.trendRatio14SIG,ss.trendRatio30SIG);
      trend_14_30_120_SIG = trendSIG(ss.trendRatio14SIG,ss.trendRatio30SIG,ss.trendRatio120SIG);
      imaSlopesData =    ss.imaSlopesData;
      slopeRatioData = ss.slopeRatioData;
      //dominantTrendSIG = trendVolVarSIG(ss.tradeVolVarSIG,ss.trendRatio30SIG,ss.trendRatio120SIG,ss.trendRatio240SIG);
      //dominantTrendSIG = trendSIG(ss.trendRatio30SIG,ss.trendRatio120SIG,ss.trendRatio240SIG,ss.trendRatio500SIG);
      //dominantTrendSIG = trendSIG(ss.trendRatio14SIG,ss.trendRatio30SIG,ss.trendRatio120SIG,ss.trendRatio240SIG,ss.trendRatio500SIG);

      dominantTrendSIG = matchSIG(
                            // trendSIG(ss.trendRatio5SIG,ss.trendRatio14SIG,ss.trendRatio30SIG,ss.trendRatio120SIG,ss.trendRatio240SIG,ss.trendRatio500SIG),
                            ss.fsig5,
                            trend_5_120_500_SIG,
                            ss.slopeVarSIG);

      //fastSIG = matchSIG(ss.fsig5,ss.fsig14,ss.fsig30);
      //fastSIG = matchSIG(ss.fsig5,ss.fsig30,ss.fsig120);
      fastSIG = matchSIG(ss.fsig14,ss.fsig30,ss.fsig120);
      //fastSIG = matchSIG(ss.fsig5,ss.fsig120,ss.fsig500);
      //fastSIG = matchSIG(ss.fsig30,ss.fsig120,ss.fsig240);

      domVolVarSIG = ss.tradeVolVarSIG;
      // dominantTrendCPSIG = ((ss.cpScatterSIG!=SANTREND::NOTREND)&&(ss.cpScatterSIG!=SANTREND::FLAT)&&(dominantTrendSIG==util.convTrendToSig(ss.cpScatterSIG)))? util.convTrendToSig(ss.cpScatterSIG) : SAN_SIGNAL::NOSIG;

      //dominantTrendCPSIG = matchSIG(
      //                        trendSIG(ss.trendRatio14SIG,ss.trendRatio30SIG,ss.trendRatio120SIG,ss.trendRatio240SIG,ss.trendRatio500SIG),
      //                        ss.slopeVarSIG,
      //                        util.convTrendToSig(ss.cpScatterSIG)
      //                     );

      dominantTrendCPSIG = matchSIG(
                              util.convTrendToSig(ss.cpScatterSIG),
                              util.convTrendToSig(ss.trendRatio120SIG),
                              imaTrendSIG(ss.ima30120SIG,ss.trendRatio30SIG,ss.trendRatio120SIG));

      //domTrIMA = imaTrend(ss.ima1430SIG,ss.ima30120SIG,ss.trendRatio14SIG,ss.trendRatio30SIG,ss.trendRatio120SIG,ss.ima120240SIG,ss.trendRatio240SIG,ss.ima240500SIG,ss.trendRatio500SIG);
      //domTrIMA = imaTrend(ss.ima30120SIG,ss.ima120240SIG,ss.trendRatio30SIG,ss.trendRatio120SIG,ss.trendRatio240SIG,ss.ima240500SIG,ss.trendRatio500SIG);

      //domTrIMAFast = imaTrend(ss.ima514SIG,ss.ima1430SIG,ss.trendRatio5SIG,ss.trendRatio14SIG,ss.trendRatio30SIG);
      domTrIMAFast = imaTrend(ss.ima1430SIG,ss.ima30120SIG,ss.trendRatio14SIG,ss.trendRatio30SIG,ss.trendRatio120SIG);
      //domTrIMA = imaTrend(ss.ima30120SIG,ss.ima120240SIG,ss.trendRatio30SIG,ss.trendRatio120SIG,ss.trendRatio240SIG,ss.ima240500SIG,ss.trendRatio500SIG);
      domTrIMA = domTrIMAFast;
      //domTrIMA = matchSIG(domTrIMAFast,domTrIMA);
      //domTrIMA = ((domTrIMAFast==domTrIMA)
      //            &&(domTrIMAFast!=SAN_SIGNAL::CLOSE)
      //            &&(domTrIMAFast!=SAN_SIGNAL::NOSIG)
      //            &&(domTrIMAFast!=SAN_SIGNAL::SIDEWAYS)
      //           )
      //           ?
      //           domTrIMAFast:((util.oppSignal(domTrIMAFast,domTrIMA)||(domTrIMAFast==SAN_SIGNAL::CLOSE))?SAN_SIGNAL::CLOSE:SAN_SIGNAL::NOSIG);

// ##############################################################################################################
// ################### Open strategies for fastSIG #############################################################
// ##############################################################################################################


      // const TRADE_STRATEGIES tr = TRADE_STRATEGIES::FASTSIG;
      // const TRADE_STRATEGIES tr = TRADE_STRATEGIES::SIMPLESIG;
      //trdStgy = TRADE_STRATEGIES::FASTSIG;
      trdStgy = TRADE_STRATEGIES::SIMPLESIG;


// ##############################################################################################################
// ################### Open strategies for fastSIG #############################################################
// ##############################################################################################################


      bool flatMktBool =  getMktFlatBoolSignal(
                             ss.candleVol120SIG,
                             ss.slopeVarSIG,
                             ss.cpScatterSIG,
                             ss.trendRatioSIG,
                             trend_14_30_120_SIG
                          );

      // getMktCloseOnVariableSlope(ss,util): This is great for close signals when the signals are steep
      bool closeTradeBool = getMktCloseOnVariableSlope(ss,util);

      // getMktCloseOnFlat(fastSIG,flatMktBool): This is great for handling close when market is flat.
      bool closeFlatTradeBool = getMktCloseOnFlat(fastSIG,flatMktBool);

      // This is a simple basic close signal on reversal of trade signal with current position.
      bool closeSigTrReversalBool =  getMktCloseOnReversal(fastSIG, util);

      //bool closeSimpleTrReversalBool =  getMktCloseOnReversal(simpleTrend_14_SIG, util);
      bool closeSimpleTrReversalBool =  getMktCloseOnReversal(simpleTrend_14_30_SIG, util);


      // Close in flat market strategies are different from close when market is steep and trending

      if(trdStgy == TRADE_STRATEGIES::FASTSIG) {
         openSIG = fastSIG;
         if(closeTradeBool) {
            mktType=MKTTYP::MKTCLOSE;
            closeSIG = SAN_SIGNAL::CLOSE;
         }
         //else if(closeFlatTradeBool) {
         //   mktType=MKTTYP::MKTCLOSE;
         //   closeSIG = SAN_SIGNAL::CLOSE;
         //}
         else if(closeSigTrReversalBool) {
            mktType=MKTTYP::MKTCLOSE;
            closeSIG = SAN_SIGNAL::CLOSE;
         } else if(flatMktBool) {
            mktType=MKTTYP::MKTFLAT;
            closeSIG = SAN_SIGNAL::NOSIG;
         } else {
            mktType=MKTTYP::MKTTR;
            closeSIG = SAN_SIGNAL::NOSIG;
         }

         Print("[NEWCLOSEONFLAT]: Close on fsig flat: "+closeFlatTradeBool+" Close slopesrev: "+getMktCloseOnSlopeReversal(ss,util)+" Mkt Rev fsig 5_14: "+getMktCloseOnReversal(simple_5_14_SIG, util));
      }
// #########################################################################################################################

// ##############################################################################################################
// ################### Open strategies for simpleTrend_14_SIG #############################################################
// ##############################################################################################################

      if(trdStgy == TRADE_STRATEGIES::SIMPLESIG) {

         openSIG = simple_5_14_SIG;

         if(closeSimpleTrReversalBool) {
            mktType=MKTTYP::MKTCLOSE;
            closeSIG = SAN_SIGNAL::CLOSE;
         } else if(flatMktBool) {
            mktType=MKTTYP::MKTFLAT;
            closeSIG = SAN_SIGNAL::NOSIG;
         } else {
            mktType=MKTTYP::MKTTR;
            closeSIG = SAN_SIGNAL::NOSIG;
         }


      }

// #########################################################################################################################



   }

   SAN_SIGNAL getBaseSlopeSIG(const DataTransport& slopeDt) {

      Print("[BASE SLOPE]:: narrow: "+ slopeDt.matrixD[0]+" Wide Slope: "+ slopeDt.matrixD[1]);
      
      if((slopeDt.matrixD[0]>=-0.2)&&(slopeDt.matrixD[0]<=0.2)) return SAN_SIGNAL::SIDEWAYS;
      if((slopeDt.matrixD[0]>=-0.3)&&(slopeDt.matrixD[0]<=0.3)) return SAN_SIGNAL::NOTRADE;
      if(slopeDt.matrixD[0]>0.3)return SAN_SIGNAL::BUY;
      if(slopeDt.matrixD[0]<-0.3)return SAN_SIGNAL::SELL;
      return SAN_SIGNAL::NOSIG;
   }

   SAN_SIGNAL  matchSIG(const SAN_SIGNAL compareSIG, const SAN_SIGNAL baseSIG1, SAN_SIGNAL baseSIG2=EMPTY, bool slowStrategy=false) {

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
   SAN_SIGNAL  simpleSIG(const SAN_SIGNAL sig1, const SAN_SIGNAL sig2=EMPTY) {

      if(sig2!=EMPTY) {
         if((sig1==SAN_SIGNAL::NOSIG)
               ||(sig2==SAN_SIGNAL::NOSIG)
           )
            return SAN_SIGNAL::NOSIG;

         if(sig1==sig2)
            return sig1;
         if(sig1!=sig2)
            return SAN_SIGNAL::NOSIG;
      }

      if(sig1==SAN_SIGNAL::NOSIG)
         return SAN_SIGNAL::NOSIG;
      return sig1;
   }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   SAN_SIGNAL  simpleTrendSIG(SANTREND tr1, SANTREND tr2=EMPTY) {

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
   //| When the signal  and its trend match.
   // if sig says buy and trend is up
   // if sig says sell and trend is down                                           |
   //+------------------------------------------------------------------+
   SAN_SIGNAL        sigTrSIG(
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
   SAN_SIGNAL        imaTrendSIG(
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

   SAN_SIGNAL        imaTrend(SAN_SIGNAL imaSIG1, SAN_SIGNAL imaSIG2,
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


   SAN_SIGNAL   fSigSlowTrendSIG(
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


   SAN_SIGNAL        dualFastSigSlowTrendSIG(
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
   SAN_SIGNAL           fastImaSlowTrendSIG(
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

   SAN_SIGNAL          trendVolVarSIG(
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

   bool getMktFlatBoolSignal(
      const SAN_SIGNAL candleVol120SIG,
      const SAN_SIGNAL slopeVarSIG,
      const SANTREND cpScatterSIG,
      const SANTREND trendRatioSIG,
      const SAN_SIGNAL trendSIG
   ) {



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
//|  Close Signal: 1: Close on Slope ratios                                                                 |
//+------------------------------------------------------------------+

   bool  getMktCloseOnSlopeRatio(const SANSIGNALS &ss, SanUtils &util) {
      double slopeR = ss.slopeRatioData.matrixD[0];
      double slopeWideR = ss.slopeRatioData.matrixD[1];
      //Print("Slopes Ratio: slopeR: "+slopeR+" slopeWideR: "+slopeWideR);
      bool closeOnSlopeRatioBool = false;

      if((slopeWideR<0.8)&&(slopeWideR!=EMPTY_VALUE))
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

   bool getMktCloseOnReversal(const SAN_SIGNAL &sig,SanUtils &util) {
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

   bool  getMktCloseOnFlat(const SAN_SIGNAL &sig, const bool mktTypeFlat) {
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


   bool  getMktCloseOnVariableSlope(const SANSIGNALS &ss, SanUtils &util) {
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

      if(fabs(ss.imaSlopesData.matrixD[0])> SLOPE_5) {
         CLOSESIGNAL=ss.fsig5;
         Print("[SIGCLOSE]: Close on (util.oppSignal(ss.fsig5,tradePosition))");
      } else if(fabs(ss.imaSlopesData.matrixD[0])>=SLOPE_14) {
         CLOSESIGNAL=ss.fsig14;
         Print("[SIGCLOSE]: Close on (util.oppSignal(ss.fsig14,tradePosition))");
      } else if(fabs(ss.imaSlopesData.matrixD[0])>=SLOPE_30) {
         CLOSESIGNAL=ss.fsig30;
         Print("[SIGCLOSE]: Close on (util.oppSignal(ss.fsig30,tradePosition))");
      } else if(fabs(ss.imaSlopesData.matrixD[0])>=SLOPE_120) {
         CLOSESIGNAL=ss.fsig120;
         Print("[SIGCLOSE]: Close on (util.oppSignal(ss.fsig120,tradePosition))");
      } else if(fabs(ss.imaSlopesData.matrixD[0])>=SLOPE_240) {
         CLOSESIGNAL=ss.fsig240;
         Print("[SIGCLOSE]: Close on (util.oppSignal(ss.fsig240,tradePosition))");
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

   bool  getMktCloseOnSlopeReversal(const SANSIGNALS &ss, SanUtils &util, const double SLOPE_REDUCTION_LEVEL=0.3) {

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


      //bool slopeRBool = getMktCloseOnSlopeRatio(ss,util);

      bool closeOnSlopeReverseBool = false;

      if(fabs(ss.imaSlopesData.matrixD[0])> SLOPE_5) {
         slope2_0=true;
      }  else if(fabs(ss.imaSlopesData.matrixD[0])>=SLOPE_14) {
         slope1_0=true;
      } else if(fabs(ss.imaSlopesData.matrixD[0])>=SLOPE_30) {
         slope0_5=true;
      } else if(fabs(ss.imaSlopesData.matrixD[0])>=SLOPE_120) {
         slope0_2=true;
      } else if(fabs(ss.imaSlopesData.matrixD[0])>=SLOPE_240) {
         slope0_08=true;
      }

      if(slope2_0 &&(fabs(ss.imaSlopesData.matrixD[0])<(SLOPE_5*SLOPE_LEVEL))) {
         closeOnSlopeReverseBool = true;
         slope2_0=false;
         Print("[SIGCLOSE]: Close on slope2_8 reverse");
      } else if (slope1_0&&(fabs(ss.imaSlopesData.matrixD[0])<(SLOPE_14*SLOPE_LEVEL))) {
         closeOnSlopeReverseBool = true;
         slope1_0=false;
         Print("[SIGCLOSE]: Close on slope2_2 reverse");
      } else if (slope0_5&&(fabs(ss.imaSlopesData.matrixD[0])<(SLOPE_30*SLOPE_LEVEL))) {
         closeOnSlopeReverseBool = true;
         slope0_5=false;
         Print("[SIGCLOSE]: Close on slope1_8 reverse");
      } else if (slope0_2&&(fabs(ss.imaSlopesData.matrixD[0])<(SLOPE_120*SLOPE_LEVEL))) {
         closeOnSlopeReverseBool = true;
         slope0_2=false;
         Print("[SIGCLOSE]: Close on slope1_2 reverse");
      } else if (slope0_08&&(fabs(ss.imaSlopesData.matrixD[0])<(SLOPE_240*SLOPE_LEVEL))) {
         closeOnSlopeReverseBool = true;
         slope0_08=false;
         Print("[SIGCLOSE]: Close on slope0_6 reverse");
      }
      return (closeOnSlopeReverseBool);
   }


   bool   getMktClose(
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

   bool  getMktCloseOnFlat(
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



};

//###########################################################################################################
//+------------------------------------------------------------------+
