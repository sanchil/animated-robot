//+------------------------------------------------------------------+
//|                                                     SanUtils.mqh |
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

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//const double SAN_TRADE_VOL =  0.01;
//const int MICROLOTS = 5;
//const double SAN_TRADE_VOL =  (0.01*MICROLOTS);
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//const double tPoint = Point();
//double currspread1 = ((Ask-Bid)/tPoint); // This is not a reliable indicator of spread.
//double currspread2 = NormalizeDouble(((MarketInfo(_Symbol,MODE_ASK)-MarketInfo(_Symbol,MODE_BID))/tPoint),2);
//double currspread = (int)MarketInfo(_Symbol,MODE_SPREAD);

//const int SPREADFACTOR = 1;
//const double SLTPFACTOR = 0.75; // (stoploss/takeprofit)

//int TOTALORDERS=NULL;
//double TRADEPROFIT = NULL;
//double MAXTRADEPROFIT = NULL;
////double ADJUSTED_MAXTRADEPROFIT = MAXTRADEPROFIT-((currspread+SPREADFACTOR)*tPoint);
//double SAN_STOPLOSS = 0.3;
//double SAN_TAKEPROFIT = 0.8;
const double LARGE_VAL=123456.654321;

struct TRADELIMITS {
   int               spreadLimit;
   double            stdDevLimit;
   int               mfiLowerLimit;
   int               mfiUpperLimit;
   int               adxMainLimit;
   double            acfLimit;
   double            acfSpikeLimit;
   double            cpStdDevLowerLimit;
   double            cpStdDevUpperLimit;
   double            zScoreUpLimit;
   double            zScoreDownLimit;
   double            candlePipSpeedLimit;
   TRADELIMITS() {
      if(_Period <PERIOD_M15) {
         spreadLimit = 20;
         candlePipSpeedLimit=30;
      } else if(_Period <=PERIOD_M30) {
         spreadLimit = 40;
         candlePipSpeedLimit=30;
      } else if(_Period <=PERIOD_H1) {
         spreadLimit = 60;
         candlePipSpeedLimit=30;
      } else if(_Period <=PERIOD_D1) {
         spreadLimit = 80;
         candlePipSpeedLimit=30;
      }

      //     spreadLimit = 20;
      //      stdDevLimit = 0.3;
      stdDevLimit = 0.09;
      mfiLowerLimit = 20;
      mfiUpperLimit = 80;
      adxMainLimit = 20;
      // acfLimit = 0.5;
      acfLimit = 0.3;
      acfSpikeLimit = 0.4; // acf is low when the std for closing price spikes.
      //This limit ensures that acf does not go very low and trades are picked up at sufficiently high acf values which is safer.
      cpStdDevLowerLimit = 6.0;
      cpStdDevUpperLimit = 10.0;
      zScoreUpLimit = 1;
      zScoreDownLimit = -1;

   };
   ~TRADELIMITS() {};
};

const TRADELIMITS tl;


struct DataTransport {
   double            matrixD[20];
   double            matrixD1[20];
   double            matrixD2[20];
   int               matrixI[20];
   int               matrixI1[20];
   int               matrixI2[20];
   bool              matrixBool[20];
   DataTransport() {
      ArrayInitialize(matrixD,0);
      ArrayInitialize(matrixD1,0);
      ArrayInitialize(matrixD2,0);
      ArrayInitialize(matrixI,0);
      ArrayInitialize(matrixI1,0);
      ArrayInitialize(matrixI2,0);
      ArrayInitialize(matrixBool,false);
   }
   void freeData() {
      ArrayFree(matrixD);
      ArrayFree(matrixI);
      ArrayFree(matrixD1);
      ArrayFree(matrixI1);
      ArrayFree(matrixD2);
      ArrayFree(matrixI2);
      ArrayFree(matrixBool);
   }
   ~DataTransport() {
      freeData();
      //ArrayFree(matrixD);
      //ArrayFree(matrixI);
      //ArrayFree(matrixD1);
      //ArrayFree(matrixI1);
      //ArrayFree(matrixD2);
      //ArrayFree(matrixI2);
      //ArrayFree(matrixBool);
   }
};

enum SAN_SIGNAL {
   BUY=1000,
   SELL=2000,
   HOLD=3000,
   OPEN=4000,
   CLOSE=5000,
   CLOSEBUY=5001,
   CLOSESELL=5002,
   TRADE=6000,
   TRADEBUY=6001,
   TRADESELL=6002,
   NOTRADE=7000,
   REVERSETRADE=8000,
   SIDEWAYS=9000,
   NOSIG=-1000314,
//NOSIG=EMPTY,
};

//enum SAN_SIGNAL
//  {
//   BUY=0,
//   SELL=1,
//   HOLD=2,
//   OPEN=3,
//   CLOSE=4,
//   TRADE=5,
//   NOTRADE=6,
//   REVERSETRADE=7,
//   SIDEWAYS=8,
//   NOSIG=-1000314,
//   //NOSIG=EMPTY,
//  };

//SAN_SIGNAL TRADEPOSITION = SAN_SIGNAL::NOSIG;

struct ORDERPARAMS {
   bool              NEWCANDLE;
   bool              TRADED;
   bool              OPENTRADE;
   bool              CLOSETRADE;
   int               TOTALORDERS;
   SAN_SIGNAL        TRADEPOSITION;
   double            TRADEPROFIT;
   double            MAXTRADEPROFIT;
   double            STOPLOSS;
   double            TAKEPROFIT;
   int               MICROLOTS;
   double            SAN_TRADE_VOL;
   int               SPREADFACTOR;
   double            SLTPFACTOR; // (stoploss/takeprofit)
   //  uint              TICKSTART;
   long              TICKCOUNT;
   double            CPINPIPS;
   double            MAXPIPS;


   bool              isNewBar() {
      static long opBars = Bars(_Symbol,PERIOD_CURRENT);
      if(opBars == Bars(_Symbol,PERIOD_CURRENT)) {
         return false;
      }
      opBars = Bars(_Symbol,PERIOD_CURRENT);
      return true;
   }

   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   double              pipsPerTick(const double candleSizePips) {

      double tPoint = Point();
      double pipsPerTick = 0;
      static long TICKSTART = 0;
      //    Print(" Candle size in Pips: "+candleSizePips);
      //if((NEWCANDLE!=EMPTY) && NEWCANDLE)
      //  Print("Candle pip size: "+candleSizePips+" TICKSTART: "+TICKSTART);
      if(isNewBar()) {
         TICKSTART = GetTickCount();
         TICKCOUNT=1;
         return 0;
      } else if((TICKSTART>0)) {
         TICKCOUNT=(GetTickCount()-TICKSTART);
         // Print("OLD Candle: TICKSTART: "+TICKSTART+" tickCount: "+TICKCOUNT+" candleSizePips: "+candleSizePips);
         // if((candleSizePips!=0)&&((TICKCOUNT/TICKSTART)<0.5))
         if((TICKCOUNT>0)&&((TICKCOUNT/TICKSTART)<0.5)) {
            pipsPerTick = (candleSizePips/(TICKCOUNT*tPoint));
            return pipsPerTick;
         }

      }
      return pipsPerTick;
   };




   ORDERPARAMS() {
      NEWCANDLE = false;
      //TICKSTART =  GetTickCount();
      TICKCOUNT = 0;
      CPINPIPS = 0;
      MAXPIPS = 0;
      SPREADFACTOR = 1;
      //      SLTPFACTOR = 0.75; // (stoploss/takeprofit)
      SLTPFACTOR = 0.525; // (stoploss/takeprofit)
      MICROLOTS = 1;
      SAN_TRADE_VOL = (MICROLOTS*0.01);
      TOTALORDERS = OrdersTotal();
      TRADEPOSITION = SAN_SIGNAL::NOSIG;
      TRADEPROFIT = EMPTY_VALUE;
      MAXTRADEPROFIT = EMPTY_VALUE;
      //      ADJUSTED_MAXTRADEPROFIT = MAXTRADEPROFIT-((currspread+1)*tPoint);
   };
   ~ORDERPARAMS() {
      NEWCANDLE = EMPTY;
      //TICKSTART = EMPTY;
      TICKCOUNT = EMPTY;
      CPINPIPS = EMPTY_VALUE;
      MAXPIPS = EMPTY_VALUE;
      MICROLOTS = EMPTY;
      SAN_TRADE_VOL = EMPTY_VALUE;
      SPREADFACTOR = EMPTY;
      SLTPFACTOR = EMPTY_VALUE;
      TRADED = EMPTY;
      OPENTRADE = EMPTY;
      CLOSETRADE = EMPTY;
      TOTALORDERS = -1;
      TRADEPOSITION = SAN_SIGNAL::NOSIG;
      TRADEPROFIT = 0;
      MAXTRADEPROFIT = 0;
      STOPLOSS=0;
      TAKEPROFIT=0;
      //      ADJUSTED_MAXTRADEPROFIT = NULL;
   };

   double            getProfit(double defaultTP, int minLot=EMPTY, double tP=EMPTY_VALUE) {
      return ((tP!=EMPTY_VALUE)&&(minLot!=EMPTY))?(tP*minLot):(((tP!=EMPTY_VALUE)&&(minLot==EMPTY))?(tP*MICROLOTS):(defaultTP*MICROLOTS));
   }

   double            getStopLoss(double tP=EMPTY_VALUE, double sL=EMPTY_VALUE, double slFactor=0.6) {
      return ((sL!=EMPTY_VALUE)?sL:((tP!=EMPTY_VALUE)?(tP*slFactor):(TAKEPROFIT*slFactor)));
   }

   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   void              initTrade(int minLot=1, double tP=EMPTY_VALUE,double sL=EMPTY_VALUE) {

      TOTALORDERS = OrdersTotal();

      //      TAKEPROFIT= ((tP!=EMPTY_VALUE)&&(mL!=EMPTY))?(tP*mL):(((tP!=EMPTY_VALUE)&&(mL==EMPTY))?(tP*MICROLOTS):(0.1*MICROLOTS));
      TAKEPROFIT= getProfit(0.1,minLot,tP);

      if(_Period == PERIOD_M1) {
         //TAKEPROFIT= 7*MICROLOTS;
         // TAKEPROFIT= 3*MICROLOTS;
         // TAKEPROFIT= 2.5*MICROLOTS;
         // TAKEPROFIT= 2*MICROLOTS;
         // TAKEPROFIT= 1.2*MICROLOTS;
         TAKEPROFIT= getProfit(0.6,minLot,(tP*1));
         // TAKEPROFIT= 0.30*MICROLOTS;

      }
      if(_Period == PERIOD_M5) {
         TAKEPROFIT= getProfit(1,minLot,(tP*5));
      } else if(_Period == PERIOD_M15) {
         TAKEPROFIT= getProfit(2,minLot,(tP*10));
      } else if(_Period == PERIOD_M30) {
         TAKEPROFIT= getProfit(3,minLot,(tP*20));
      } else if(_Period == PERIOD_H1) {
         TAKEPROFIT= getProfit(4,minLot,(tP*30));
      } else if(_Period == PERIOD_H4) {
         TAKEPROFIT= getProfit(5,minLot,(tP*60));
      } else if(_Period == PERIOD_D1) {
         TAKEPROFIT= getProfit(6,minLot,(tP*250));
      }
      STOPLOSS = getStopLoss(tP,sL,2);


      if(TOTALORDERS==0) {
         TOTALORDERS=0;
         TRADEPOSITION = SAN_SIGNAL::NOSIG;
         TRADEPROFIT = 0;
         MAXTRADEPROFIT = 0;
      }

      if(TOTALORDERS>0) {
         for(int i=0; i<TOTALORDERS; i++) {
            if(OrderSelect(i,SELECT_BY_POS)) {
               TRADEPROFIT = OrderProfit();

               if((!MAXTRADEPROFIT)||(MAXTRADEPROFIT==NULL)||(MAXTRADEPROFIT==0)||(MAXTRADEPROFIT==EMPTY_VALUE)||(MAXTRADEPROFIT==EMPTY)) {
                  MAXTRADEPROFIT = TRADEPROFIT;
               }
               if(((MAXTRADEPROFIT!=NULL)&&(MAXTRADEPROFIT!=0)&&(MAXTRADEPROFIT!=EMPTY_VALUE)&&(MAXTRADEPROFIT!=EMPTY))&&(TRADEPROFIT>MAXTRADEPROFIT)) {
                  MAXTRADEPROFIT = TRADEPROFIT;
               }

               if(OrderType()==OP_BUY) {
                  TRADEPOSITION=SAN_SIGNAL::BUY;
               }
               if(OrderType()==OP_SELL) {
                  TRADEPOSITION=SAN_SIGNAL::SELL;
               }
               if((OrderType()!=OP_SELL)&&(OrderType()!=OP_BUY)&&(OrderType()!=OP_SELLLIMIT)&&(OrderType()!=OP_BUYLIMIT)&&(OrderType()!=OP_SELLSTOP)&&(OrderType()!=OP_BUYSTOP)) {
                  TRADEPOSITION=SAN_SIGNAL::NOSIG;
               }
            }

         }
      }
   };
};


enum SANTREND {
   UP=90,
   DOWN=100,
   FLAT=110,
   TREND=120,
   CONVUP=130,
   CONVDOWN=140,
   CONVFLAT=150,
   DIVUP=160,
   DIVDOWN=170,
   DIVFLAT=180,
   FLATUP=190,
   FLATDOWN=200,
   FLATFLAT=210,
   NOTREND=-1000315
};

enum SANTRENDSTRENGTH {
   WEAK=220,
   NORMAL=230,
   HIGH=240,
   SUPERHIGH=250,
   POOR=-1000316
};


enum STRATEGYTYPE {
   STDMFIADX=260,
   PA=270,
   IMACLOSE=280,
   FARMPROFITS=290,
   CLOSEPOSITIONS=300,
   NOSTRATEGY=-1000317
};

enum CROSSOVER {
   ABOVE=400,
   BELOW=410,
   BELOWTOABOVE = 420,
   ABOVETOBELOW = 430,
   MULTIPLE = 440,
   NOCROSS = -1000319
};


enum SIGMAVARIABILITY {
//   SIGMA_MEAN=310,
//
   SIGMA_HALF=320,
   SIGMA_1=330,
   SIGMA_16=340,
   SIGMA_2=350,
   SIGMA_3=360,
   SIGMA_35=365,
   SIGMA_4=370,
   SIGMA_REST=380,

   SIGMANEG_REST=500,
   SIGMANEG_4=520,
   SIGMANEG_35=540,
   SIGMANEG_3=560,
   SIGMANEG_2=580,
   SIGMANEG_16=600,
   SIGMANEG_1=620,
   SIGMANEG_HALF=640,
   SIGMANEG_MEAN=660,
   SIGMA_MEAN=700,
   SIGMAPOS_MEAN=720,
   SIGMAPOS_HALF=740,
   SIGMAPOS_1=760,
   SIGMAPOS_16=780,
   SIGMAPOS_2=800,
   SIGMAPOS_3=820,
   SIGMAPOS_35=840,
   SIGMAPOS_4=860,
   SIGMAPOS_REST=880,

   SIGMA_NULL=-1000318
};


enum MKTTYP {
   MKTFLAT=900,
   MKTTR=920,
   MKTUP=930,
   MKTDOWN=940,
   MKTCLOSE=950,
   NOMKT=960
};

struct TRENDSTRUCT {
   SANTREND          closeTrendSIG;
   SANTRENDSTRENGTH  trendStrengthSIG;
   TRENDSTRUCT() {
      closeTrendSIG = SANTREND::NOTREND;
      trendStrengthSIG=SANTRENDSTRENGTH::POOR;
   }
   ~TRENDSTRUCT() {}
};

struct TRADESSWITCH {
   SAN_SIGNAL        trade;
   SAN_SIGNAL        tradeSIG;
   TRADESSWITCH() {
      trade = SAN_SIGNAL::NOSIG;
      tradeSIG=SAN_SIGNAL::NOSIG;
   }
   ~TRADESSWITCH() {}
};

TRADESSWITCH tsw;

struct INDDATA {
   double            open[500];
   double            high[70];
   double            low[70];
   double            close[500];
   datetime          time[70];
   double            tick_volume[500];
   double            volume[70];
   double            std[70];
   double            mfi[70];
   double            rsi[70];
   double            atr[70];
   double            adx[70];
   double            adxPlus[70];
   double            adxMinus[70];
   double            ima5[70];
   double            ima14[70];
   double            ima30[70];
   double            ima60[70];
   double            ima120[500];
   double            ima240[500];
   double            ima500[500];
   ulong             magicnumber;
   double            closeProfit; // Profit at which a trade is condsidered for closing. Also the same as take profit
   double            stopLoss; // Stop Loss
   double            currProfit; // The profit of the currently held trade
   double            maxProfit; // The current profit is adjusted by subtracting the spread and a margin added.
   int               tradePosition;
   int               currSpread;
   int               shift;


   void              freeData() {
      ArrayFree(open);
      ArrayFree(high);
      ArrayFree(low);
      ArrayFree(close);
      ArrayFree(time);
      ArrayFree(tick_volume);
      ArrayFree(volume);
      ArrayFree(std);
      ArrayFree(mfi);
      ArrayFree(atr);
      ArrayFree(adx);
      ArrayFree(adxPlus);
      ArrayFree(adxMinus);
      ArrayFree(ima5);
      ArrayFree(ima14);
      ArrayFree(ima30);
      ArrayFree(ima60);
      ArrayFree(ima120);
      ArrayFree(ima240);
      ArrayFree(ima500);
      magicnumber=NULL;
      closeProfit=NULL;
      stopLoss=NULL;
      currProfit=NULL;
      maxProfit=NULL;
      shift=NULL;
      currSpread = EMPTY;
      tradePosition=EMPTY;
   }
   INDDATA() {}
   ~INDDATA() {
      freeData();
   }
};

struct SIGBUFF {
   double            buff1[5];
   double            buff2[5];
   double            buff3[5];
   double            buff4[5];
   double            buff5[5];
   double            buff6[5];
   SIGBUFF() {
      ArrayInitialize(buff1,EMPTY_VALUE);
      ArrayInitialize(buff2,EMPTY_VALUE);
      ArrayInitialize(buff3,EMPTY_VALUE);
      ArrayInitialize(buff4,EMPTY_VALUE);
      ArrayInitialize(buff5,EMPTY_VALUE);
      ArrayInitialize(buff6,EMPTY_VALUE);
   }
   ~SIGBUFF() {
      ArrayFree(buff1);
      ArrayFree(buff2);
      ArrayFree(buff3);
      ArrayFree(buff4);
      ArrayFree(buff5);
      ArrayFree(buff6);
   }
};

struct SANSIGNALS {
   SAN_SIGNAL        openSIG;
   SAN_SIGNAL        closeSIG;
   SAN_SIGNAL        priceActionSIG;
   SAN_SIGNAL        adxSIG;
   SAN_SIGNAL        mfiSIG;
   SAN_SIGNAL        rsiSIG;
   SAN_SIGNAL        adxCovDivSIG;
   SAN_SIGNAL        fastIma514SIG;
   SAN_SIGNAL        fastIma1430SIG;
   SAN_SIGNAL        fastIma30120SIG;
   SAN_SIGNAL        fastIma120240SIG;
   SAN_SIGNAL        fastIma240500SIG;
   SAN_SIGNAL        fastIma530SIG;
   SAN_SIGNAL        ima514SIG;
   SAN_SIGNAL        ima1430SIG;
   SAN_SIGNAL        ima30120SIG;
   SAN_SIGNAL        ima30240SIG;
   SAN_SIGNAL        ima120240SIG;
   SAN_SIGNAL        ima120500SIG;
   SAN_SIGNAL        ima240500SIG;
   SAN_SIGNAL        ima530SIG;
   SAN_SIGNAL        ima530_21SIG;
   SANTRENDSTRENGTH  atrSIG;
   SAN_SIGNAL        volSIG;
   SAN_SIGNAL        profitSIG;
   SAN_SIGNAL        profitPercentageSIG;
   SAN_SIGNAL        tradeSIG;
   SAN_SIGNAL        tradeVolVarSIG;
   SAN_SIGNAL        lossSIG;
   SANTREND          acfTrendSIG;
   SANTRENDSTRENGTH  acfStrengthSIG;
   SANTREND          trendRatioSIG;
   SANTREND          trendRatio5SIG;
   SANTREND          trendRatio14SIG;
   SANTREND          trendRatio30SIG;
   SANTREND          trendRatio120SIG;
   SANTREND          trendRatio240SIG;
   SANTREND          trendRatio500SIG;
   SANTREND          trendVolRatioSIG;
   SAN_SIGNAL        trendSumSig;
   SANTRENDSTRENGTH  trendVolRatioStrengthSIG;
   SAN_SIGNAL        slopeVarSIG;
   SANTREND          trendSlopeSIG;
   SANTREND          trendSlope5SIG;
   SANTREND          trendSlope14SIG;
   SANTREND          trendSlope30SIG;
   SANTREND          cpScatterSIG;
   SANTREND          cpScatter21SIG;
   SANTREND          trendScatterSIG;
   SANTREND          trendScatter5SIG;
   SANTREND          trendScatter14SIG;
   SANTREND          trendScatter30SIG;
   SAN_SIGNAL        fsig5;
   SAN_SIGNAL        fsig14;
   SAN_SIGNAL        fsig30;
   SAN_SIGNAL        fsig120;
   SAN_SIGNAL        fsig240;
   SAN_SIGNAL        fsig500;
   SAN_SIGNAL        sig5;
   SAN_SIGNAL        sig14;
   SAN_SIGNAL        sig30;
   SAN_SIGNAL        sig120;
   SAN_SIGNAL        sig240;
   SAN_SIGNAL        sig500;
   SAN_SIGNAL        candleImaSIG;
   SAN_SIGNAL        candleVolSIG;
   SAN_SIGNAL        candleVol120SIG;
   SIGMAVARIABILITY        cpSDSIG;
   SIGMAVARIABILITY        ima5SDSIG;
   SIGMAVARIABILITY        ima14SDSIG;
   SIGMAVARIABILITY        ima30SDSIG;
   SIGMAVARIABILITY        ima120SDSIG;
   SIGMAVARIABILITY        ima240SDSIG;
   SIGMAVARIABILITY        ima500SDSIG;
   SAN_SIGNAL        candlePattStarSIG;
   DataTransport     clusterSIG;
   DataTransport     imaSlopesData;
   DataTransport     varDt;
   DataTransport     slopeRatioData;


   SANSIGNALS() {
      openSIG = SAN_SIGNAL::NOSIG;
      closeSIG = SAN_SIGNAL::NOSIG;
      priceActionSIG = SAN_SIGNAL::NOSIG;
      candlePattStarSIG = SAN_SIGNAL::NOSIG;
      adxSIG = SAN_SIGNAL::NOSIG;
      mfiSIG = SAN_SIGNAL::NOSIG;
      rsiSIG = SAN_SIGNAL::NOSIG;
      adxCovDivSIG = SAN_SIGNAL::NOSIG;
      fastIma514SIG = SAN_SIGNAL::NOSIG;
      fastIma1430SIG = SAN_SIGNAL::NOSIG;
      fastIma530SIG = SAN_SIGNAL::NOSIG;
      fastIma30120SIG = SAN_SIGNAL::NOSIG;
      fastIma120240SIG = SAN_SIGNAL::NOSIG;
      fastIma240500SIG = SAN_SIGNAL::NOSIG;
      ima514SIG = SAN_SIGNAL::NOSIG;
      ima1430SIG = SAN_SIGNAL::NOSIG;
      ima530SIG = SAN_SIGNAL::NOSIG;
      ima530_21SIG = SAN_SIGNAL::NOSIG;
      ima30120SIG = SAN_SIGNAL::NOSIG;
      ima30240SIG = SAN_SIGNAL::NOSIG;
      ima120240SIG = SAN_SIGNAL::NOSIG;
      ima120500SIG = SAN_SIGNAL::NOSIG;
      ima240500SIG = SAN_SIGNAL::NOSIG;
      atrSIG = SANTRENDSTRENGTH::POOR;
      volSIG = SAN_SIGNAL::NOSIG;
      profitSIG = SAN_SIGNAL::NOSIG;
      profitPercentageSIG = SAN_SIGNAL::NOSIG;
      tradeSIG = SAN_SIGNAL::NOSIG;
      tradeVolVarSIG = SAN_SIGNAL::NOSIG;
      lossSIG = SAN_SIGNAL::NOSIG;
      acfTrendSIG = SANTREND::NOTREND;
      acfStrengthSIG = SANTRENDSTRENGTH::POOR;
      trendRatio5SIG = SANTREND::NOTREND;
      trendRatio14SIG = SANTREND::NOTREND;
      trendRatio30SIG = SANTREND::NOTREND;
      trendRatio120SIG = SANTREND::NOTREND;
      trendRatio240SIG = SANTREND::NOTREND;
      trendRatio500SIG = SANTREND::NOTREND;
      trendRatioSIG = SANTREND::NOTREND;
      trendVolRatioSIG =  SANTREND::NOTREND;
      trendSumSig = SAN_SIGNAL::NOSIG;
      trendVolRatioStrengthSIG = SANTRENDSTRENGTH::POOR;
      slopeVarSIG = SAN_SIGNAL::NOSIG;
      trendSlopeSIG = SANTREND::NOTREND;
      trendSlope5SIG = SANTREND::NOTREND;
      trendSlope14SIG = SANTREND::NOTREND;
      trendSlope30SIG = SANTREND::NOTREND;
      cpScatterSIG = SANTREND::NOTREND;
      cpScatter21SIG = SANTREND::NOTREND;
      trendScatterSIG = SANTREND::NOTREND;
      trendScatter5SIG = SANTREND::NOTREND;
      trendScatter14SIG = SANTREND::NOTREND;
      trendScatter30SIG = SANTREND::NOTREND;
      fsig5 = SAN_SIGNAL::NOSIG;
      fsig14 = SAN_SIGNAL::NOSIG;
      fsig30 = SAN_SIGNAL::NOSIG;
      fsig120 = SAN_SIGNAL::NOSIG;
      fsig240 = SAN_SIGNAL::NOSIG;
      fsig500 = SAN_SIGNAL::NOSIG;
      sig5 = SAN_SIGNAL::NOSIG;
      sig14 = SAN_SIGNAL::NOSIG;
      sig30 = SAN_SIGNAL::NOSIG;
      sig120 = SAN_SIGNAL::NOSIG;
      sig240 = SAN_SIGNAL::NOSIG;
      sig500 = SAN_SIGNAL::NOSIG;
      candleImaSIG = SAN_SIGNAL::NOSIG;
      candleVolSIG = SAN_SIGNAL::NOSIG;
      candleVol120SIG = SAN_SIGNAL::NOSIG;
      cpSDSIG = SIGMAVARIABILITY::SIGMA_NULL;
      ima5SDSIG = SIGMAVARIABILITY::SIGMA_NULL;
      ima14SDSIG = SIGMAVARIABILITY::SIGMA_NULL;
      ima30SDSIG = SIGMAVARIABILITY::SIGMA_NULL;
      ima120SDSIG = SIGMAVARIABILITY::SIGMA_NULL;
      ima240SDSIG = SIGMAVARIABILITY::SIGMA_NULL;
      ima500SDSIG = SIGMAVARIABILITY::SIGMA_NULL;
      //clusterSIG = EMPTY_VALUE;


   }

   ~SANSIGNALS() {
      clusterSIG.freeData();
      imaSlopesData.freeData();
      varDt.freeData();
      slopeRatioData.freeData();
   }

};


struct SANSIGBOOL {
   bool              spreadBool;
   bool              fimaWaveBool;
   bool              imaWaveBool;
   bool              imaWaveBool1;
   bool              sigBool;
   bool              sigBool1;
   bool              fsigBool;
   bool              signal514Bool;
   bool              signal1430Bool;
   bool              signal5Wave530Bool;
   bool              signal5Wave1430Bool;
   bool              signal5Wave14Bool;
   bool              signal14Wave1430Bool;
   bool              safeSig1Bool;
   bool              safeSig2Bool;
   bool              safeSig3Bool;
   bool              safeSig4Bool;
   bool              safeSig5Bool;
   bool              adxBool;
   bool              adxIma1430Bool;
   bool              atrAdxBool;
   bool              atrAdxVolOpenBool;
   bool              openTradeBool;
   bool              healthyTrendBool;
   bool              healthyTrendStrengthBool;
   bool              flatTrendBool;
   bool              openVolTrendBool;
   bool              closeVolTrendBool;
   bool              imaSig1Bool;
   //bool              cpSDBool;
   //bool              ima5SDBool;
   //bool              ima14SDBool;
   //bool              ima30SDBool;
   //bool              ima120SDBool;
   //bool              imaSDTradeBool;
   //bool              imaSDNoTradeBool;
   //bool              imaSDTradeTradeBool;
   //bool              imaSDNoNoTradeBool;
   bool              starBool;
   bool              candlePipAlarm;


   SANSIGBOOL() {
      spreadBool = false;
      imaWaveBool = false;
      imaWaveBool1 = false;
      fimaWaveBool = false;
      sigBool = false;
      sigBool1 = false;

      fsigBool = false;
      signal514Bool = false;
      signal1430Bool = false;
      signal5Wave530Bool = false;
      signal5Wave1430Bool = false;

      signal5Wave14Bool = false;
      signal14Wave1430Bool = false;
      safeSig1Bool = false;
      safeSig2Bool = false;
      safeSig3Bool = false;
      safeSig4Bool = false;
      safeSig5Bool = false;
      adxBool= false;
      adxIma1430Bool = false;
      atrAdxBool= false;
      atrAdxVolOpenBool= false;
      imaSig1Bool= false;
      openTradeBool= false;

      healthyTrendBool= false;
      healthyTrendStrengthBool= false;
      flatTrendBool= false;

      openVolTrendBool = false;
      closeVolTrendBool= false;
      //cpSDBool = false;
      //ima5SDBool = false;
      //ima14SDBool = false;
      //ima30SDBool = false;
      //ima120SDBool = false;
      //imaSDTradeBool = false;
      //imaSDTradeTradeBool = false;
      //imaSDNoTradeBool = false;
      //imaSDNoNoTradeBool = false;
      //starBool = false;
      candlePipAlarm = false;
   }
   SANSIGBOOL(const SANSIGNALS &ss) {
      //spreadBool = (currspread < tl.spreadLimit);
      //      imaWaveBool = ((ss.ima514SIG==ss.ima1430SIG)||(ss.ima530SIG==ss.ima1430SIG)||(ss.ima530SIG==ss.ima514SIG));
      imaWaveBool = ((ss.ima514SIG==ss.ima1430SIG)&&(ss.ima1430SIG==ss.ima530_21SIG));

      fimaWaveBool = ((ss.fastIma514SIG==ss.fastIma1430SIG)||(ss.fastIma530SIG==ss.fastIma1430SIG));
      imaWaveBool1 = ((ss.fastIma514SIG==ss.ima514SIG)&&((ss.fastIma1430SIG==ss.ima1430SIG)||(ss.fastIma530SIG==ss.ima530SIG)));
      signal514Bool = (ss.sig5==ss.sig14);
      signal1430Bool = (ss.sig14==ss.sig30);
      signal5Wave1430Bool = (ss.sig5==ss.ima1430SIG);
      signal5Wave530Bool = (ss.sig5==ss.ima530SIG);
      signal5Wave14Bool = (ss.sig5==ss.ima514SIG);

      //sigBool = ((signal514Bool && signal1430Bool)||(signal514Bool && (ss.sig5==ss.sig30))) ;
      //fsigBool = ((ss.fsig5==ss.fsig14)&&(ss.fsig14==ss.fsig30));
      sigBool = (signal514Bool && signal1430Bool);
      fsigBool = ((ss.fsig5==ss.fsig14)&&(ss.fsig14==ss.fsig30));

      sigBool1 = ((ss.fsig5 == ss.sig5) && (ss.fsig14 == ss.sig14) && (ss.fsig30==ss.sig30));

      signal14Wave1430Bool = (ss.sig14==ss.ima1430SIG);
      safeSig1Bool = (imaWaveBool && signal5Wave14Bool && (ss.sig5==ss.ima514SIG));
      safeSig2Bool = (signal14Wave1430Bool);
      safeSig3Bool = (signal5Wave530Bool);
      safeSig4Bool = (sigBool && fsigBool && imaWaveBool && fimaWaveBool && (ss.fsig5==ss.fastIma514SIG) && (ss.sig5==ss.ima514SIG)&&(ss.fsig5==ss.sig5)&&(ss.fastIma514SIG==ss.ima514SIG));
      adxBool= ((ss.adxSIG==SAN_SIGNAL::BUY)||(ss.adxSIG==SAN_SIGNAL::SELL));
      adxIma1430Bool = (ss.adxSIG==ss.ima1430SIG);
      atrAdxBool = (((ss.atrSIG==SANTRENDSTRENGTH::NORMAL)||(ss.atrSIG==SANTRENDSTRENGTH::HIGH)) && adxBool);
      atrAdxVolOpenBool = ((ss.volSIG==SAN_SIGNAL::TRADE) && atrAdxBool);
      imaSig1Bool = (spreadBool && safeSig1Bool);
      openTradeBool = (ss.tradeSIG == SAN_SIGNAL::TRADE);
      healthyTrendBool = (((ss.acfTrendSIG!=SANTREND::NOTREND)&&(ss.acfTrendSIG!=SANTREND::FLAT))||((ss.trendSlopeSIG!=SANTREND::NOTREND)&&(ss.trendSlopeSIG!=SANTREND::FLAT)));
      healthyTrendStrengthBool = ((ss.acfStrengthSIG!=SANTRENDSTRENGTH::WEAK)&&(ss.acfStrengthSIG!=SANTRENDSTRENGTH::POOR));
      flatTrendBool = ((ss.trendSlopeSIG==SANTREND::FLAT) || ((ss.acfTrendSIG==SANTREND::FLAT) && ((ss.acfStrengthSIG==SANTRENDSTRENGTH::NORMAL)||(ss.acfStrengthSIG==SANTRENDSTRENGTH::HIGH)||(ss.acfStrengthSIG==SANTRENDSTRENGTH::SUPERHIGH))));
      openVolTrendBool = ((ss.volSIG==SAN_SIGNAL::TRADE) && healthyTrendBool && healthyTrendStrengthBool && !flatTrendBool);
      closeVolTrendBool = ((ss.volSIG==SAN_SIGNAL::REVERSETRADE) && !healthyTrendBool && !healthyTrendStrengthBool && flatTrendBool);

      //      cpSDBool = ((ss.cpSDSIG!=SIGMAVARIABILITY::SIGMA_NULL)&&(ss.cpSDSIG!=SIGMAVARIABILITY::SIGMA_MEAN)&&(ss.cpSDSIG!=SIGMAVARIABILITY::SIGMANEG_MEAN)&&(ss.cpSDSIG!=SIGMAVARIABILITY::SIGMAPOS_MEAN)&&(ss.cpSDSIG!=SIGMAVARIABILITY::SIGMANEG_HALF)&&(ss.cpSDSIG!=SIGMAVARIABILITY::SIGMAPOS_HALF));
      //      ima5SDBool = ((ss.ima5SDSIG!=SIGMAVARIABILITY::SIGMA_NULL)&&(ss.ima5SDSIG!=SIGMAVARIABILITY::SIGMA_MEAN)&&(ss.ima5SDSIG!=SIGMAVARIABILITY::SIGMANEG_MEAN)&&(ss.ima5SDSIG!=SIGMAVARIABILITY::SIGMAPOS_MEAN)&&(ss.ima5SDSIG!=SIGMAVARIABILITY::SIGMANEG_HALF)&&(ss.ima5SDSIG!=SIGMAVARIABILITY::SIGMAPOS_HALF));
      //      ima14SDBool = ((ss.ima14SDSIG!=SIGMAVARIABILITY::SIGMA_NULL)&&(ss.ima14SDSIG!=SIGMAVARIABILITY::SIGMA_MEAN)&&(ss.ima14SDSIG!=SIGMAVARIABILITY::SIGMANEG_MEAN)&&(ss.ima14SDSIG!=SIGMAVARIABILITY::SIGMAPOS_MEAN)&&(ss.ima14SDSIG!=SIGMAVARIABILITY::SIGMANEG_HALF)&&(ss.ima14SDSIG!=SIGMAVARIABILITY::SIGMAPOS_HALF));
      //      ima30SDBool = ((ss.ima30SDSIG!=SIGMAVARIABILITY::SIGMA_NULL)&&(ss.ima30SDSIG!=SIGMAVARIABILITY::SIGMA_MEAN)&&(ss.ima30SDSIG!=SIGMAVARIABILITY::SIGMANEG_MEAN)&&(ss.ima30SDSIG!=SIGMAVARIABILITY::SIGMAPOS_MEAN)&&(ss.ima30SDSIG!=SIGMAVARIABILITY::SIGMANEG_HALF)&&(ss.ima30SDSIG!=SIGMAVARIABILITY::SIGMAPOS_HALF));
      //      ima120SDBool = ((ss.ima120SDSIG!=SIGMAVARIABILITY::SIGMA_NULL)&&(ss.ima120SDSIG!=SIGMAVARIABILITY::SIGMA_MEAN)&&(ss.ima120SDSIG!=SIGMAVARIABILITY::SIGMANEG_MEAN)&&(ss.ima120SDSIG!=SIGMAVARIABILITY::SIGMAPOS_MEAN)&&(ss.ima120SDSIG!=SIGMAVARIABILITY::SIGMANEG_HALF)&&(ss.ima120SDSIG!=SIGMAVARIABILITY::SIGMAPOS_HALF));
      //      //ima5SDBool = (ss.ima5SDSIG==SIGMAVARIABILITY::TRADE);
      //      //ima14SDBool = (ss.ima14SDSIG==SIGMAVARIABILITY::TRADE);
      //      //ima30SDBool = (ss.ima30SDSIG==SIGMAVARIABILITY::TRADE);
      //
      //      imaSDTradeBool = (ima14SDBool && ima30SDBool);
      //      imaSDNoTradeBool = (!ima14SDBool && !ima30SDBool);
      //      imaSDTradeTradeBool = (ima5SDBool && ima14SDBool && ima30SDBool);
      //      imaSDNoNoTradeBool = (!ima5SDBool && !ima14SDBool && !ima30SDBool);
      starBool = ((ss.candlePattStarSIG==SAN_SIGNAL::BUY)||(ss.candlePattStarSIG==SAN_SIGNAL::SELL));
   }
   ~SANSIGBOOL() {}
   void              printStruct() {
      //      Print("cpSDBool: "+cpSDBool+" ima5SDBool: "+ ima5SDBool+" ima14SDBool: "+ ima14SDBool+" ima30DBool: "+ ima30SDBool +" imaSDNoTradeBool: "+imaSDNoTradeBool+" closeVolTrendBool: "+closeVolTrendBool+" openVolTrendBool:"+openVolTrendBool);
      Print("closeVolTrendBool: "+closeVolTrendBool+" openVolTrendBool:"+openVolTrendBool);
      Print("adxBool: "+adxBool+" adxIma1430Bool: "+adxIma1430Bool+" atrAdxBool: "+atrAdxBool+" openTradeBool: "+openTradeBool+" healthyTrendBool:"+healthyTrendBool+" healthyTrendStrengthBool: "+healthyTrendStrengthBool+" atrAdxVolOpenBool: "+atrAdxVolOpenBool+" starBool: "+starBool);
      Print("SpreadBool: "+spreadBool+" imaWaveBool: "+imaWaveBool+" signal514Bool: "+signal514Bool+" signal1430Bool: "+signal1430Bool+" signal5Wave14Bool: "+signal5Wave14Bool+" signal14Wave1430Bool: "+signal14Wave1430Bool+" signal5Wave1430Bool: "+signal5Wave1430Bool+" safeSig1Bool:"+safeSig1Bool+" safeSig2Bool: "+safeSig2Bool+" imaSig1Bool: "+imaSig1Bool);
   }
};



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class SanUtils {
 private:

 public:
   SanUtils();
   ~SanUtils();


   //   void              initTrade();

   ulong             placeOrder(ulong mnumber, double vol, ENUM_ORDER_TYPE orderType, int slippage=3, double stopLoss=0, double takeProfit=0);
   bool              closeOrders();
   void              sayMesg();
   double            getPipValue(string symbol);
   bool              isNewBar();
   bool              isNewBarTime();
   string            printStr(string data,bool newLine=true);
   string            getUninitReasonText(int reasonCode);
   string            getSigString(double sig);
   string            getSymbolString(double symbol=0, string currency="");
   bool              closeOrderPos(int pos);
   bool              closeOrderTicket(ulong ticket);
   bool              closeOrdersOnRevSignal(SAN_SIGNAL signal,int orderPos=0);
   bool              oppSignal(SAN_SIGNAL sig1, SAN_SIGNAL sig2);
   bool              equivalentSigTrend(SAN_SIGNAL sig, SANTREND trnd);
   uint              pipsPerTick(const bool newCandle, const double close);
   bool              oppSigTrend(SAN_SIGNAL sig, SANTREND trnd);
   SAN_SIGNAL        convTrendToSig(SANTREND trnd);
   SAN_SIGNAL        flipSig(SAN_SIGNAL sig);
   SAN_SIGNAL        getCurrTradePosition();
   double            getSigVariabilityBool(const SIGMAVARIABILITY &varSIG, string sigType="IMA30");
   double            getSigVarBool(const SIGMAVARIABILITY &varSIG);
   bool              farmProfits(double captureProfit);
   void              printSignalStruct(const SANSIGNALS &ss);
   string            arrayToCSVString(const string &values[]);
   bool              isMidnight(int bufferSecs=60);
   bool              renameFile(string oldFileName, string newFileName);
   bool              fileSizeCheck(string fileName, uint fileMiBSize=20);
   void              writeData(string name, string data);
   bool              writeArrData(string name, const double &values[], string order);
   bool              writeHeaderData(string filename, const string &headerArr[]);
   bool              writeStructData(string filename, const INDDATA &indData, SAN_SIGNAL order,int shift=1);
   double            SafeDiv(const double val1, const double val2, const int normalizeDigits=4, const double zeroDivValue=DBL_MAX);

};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SanUtils::SanUtils(void) {};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SanUtils::~SanUtils() {};


//+------------------------------------------------------------------+
//| get text description                                             |
//+------------------------------------------------------------------+
string SanUtils::getUninitReasonText(int reasonCode) {
   string text="";
//---
   switch(reasonCode) {
   case REASON_ACCOUNT:
      text="Account was changed";
      break;
   case REASON_CHARTCHANGE:
      text="Symbol or timeframe was changed";
      break;
   case REASON_CHARTCLOSE:
      text="Chart was closed";
      break;
   case REASON_PARAMETERS:
      text="Input-parameter was changed";
      break;
   case REASON_RECOMPILE:
      text="Program "+__FILE__+" was recompiled";
      break;
   case REASON_REMOVE:
      text="Program "+__FILE__+" was removed from chart";
      break;
   case REASON_TEMPLATE:
      text="New template was applied to chart";
      break;
   default:
      text="Another reason";
   }
//---
   return text;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SanUtils::sayMesg() {
   double ticksize     = MarketInfo(_Symbol, MODE_TICKSIZE);
   double tickvalue    = MarketInfo(_Symbol, MODE_TICKVALUE);
   double ask = MarketInfo(_Symbol, MODE_ASK);
   double bid = MarketInfo(_Symbol, MODE_BID);
   const double tPoint = Point();
   Print(" Point value: ",tPoint, " Tick Size: ", ticksize, " Tick Value: ",tickvalue, " Ask: ", ask," Bid: ",bid);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double SanUtils::getPipValue(string symbol) {
   double point = MarketInfo(symbol, MODE_POINT); // e.g., 0.001 for USDJPY, 0.00001 for EURUSD
   int digits = MarketInfo(symbol, MODE_DIGITS);  // e.g., 3 for USDJPY, 5 for EURUSD
   bool isJPY = StringFind(symbol, "JPY") >= 0;   // True if JPY pair

// JPY pairs: 1 Pip = 0.01 (2nd decimal)
   if(isJPY) {
      if(digits == 3) {
         return point * 10;   // 3-digit JPY: 1 pip = 10 points (e.g., 0.01)
      }
      if(digits == 2) {
         return point;   // 2-digit JPY: 1 pip = 1 point (e.g., 0.01)
      }
   }
// Non-JPY pairs: 1 Pip = 0.0001 (4th decimal)
   else {
      if(digits == 5) {
         return point * 10;   // 5-digit non-JPY: 1 pip = 10 points (e.g., 0.0001)
      }
      if(digits == 4) {
         return point;   // 4-digit non-JPY: 1 pip = 1 point (e.g., 0.0001)
      }
   }

// Default for non-standard digits (e.g., 5-digit JPY or 6-digit non-JPY)
// Assume 1 pip = 10 points for high precision, 1 point for low precision
   return (digits > 4 || (isJPY && digits > 2)) ? point * 10 : point;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SanUtils::isMidnight(int bufferSecs=60) {
   datetime currentTime = TimeCurrent();
   datetime midnight = TimeCurrent() - (TimeCurrent() % 86400);
   return (currentTime >= midnight && currentTime < midnight + bufferSecs); // 60-second window
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SanUtils::renameFile(string oldFileName, string newFileName) {

   string src_path="./"+oldFileName;
   string dst_path="./"+newFileName;
   if(!FileMove(src_path,0,dst_path,FILE_COMMON|FILE_REWRITE)) {
      Print("Error moving file: ", GetLastError());
      return false;
   }
//
//// Copy the file to the new name
//   if(!FileCopy(oldFileName, 0, newFileName, 0))
//     {
//      Print("Error copying file: ", GetLastError());
//      return false;
//     }
//
//// Delete the original file
//   if(!FileDelete(oldFileName))
//     {
//      Print("Error deleting original file: ", GetLastError());
//      return false;
//     }

   Print("File successfully renamed from ", oldFileName, " to ", newFileName);
   return true;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SanUtils::closeOrders() {
   int total=OrdersTotal();
   Print("Closing all buy and sell orders");
   for(int pos=0; pos<total; pos++) {
      if(OrderSelect(pos,SELECT_BY_POS)) {
         if(OrderType()==OP_BUY) {
            return OrderClose(OrderTicket(),OrderLots(),Bid,5,clrNONE);
         }
         if(OrderType()==OP_SELL) {
            return OrderClose(OrderTicket(),OrderLots(),Ask,5,clrNONE);
         }
         // FileWrite(handle,OrderTicket(),OrderOpenPrice(),OrderOpenTime(),OrderSymbol(),OrderLots());
      }
   }
   return false;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SanUtils::closeOrdersOnRevSignal(SAN_SIGNAL signal,int orderPos=0) {

   int totalOrders=OrdersTotal();
   if((totalOrders > 0) && (OrderSelect(orderPos,SELECT_BY_POS)==true)) {
      if((OrderType()==OP_BUY) && (signal == SAN_SIGNAL::SELL)) {
         Print(" Closing Buy Order on reverse signal: ");
         return OrderClose(OrderTicket(),OrderLots(),Bid,3,clrNONE);
      }
      if((OrderType()==OP_SELL) && (signal == SAN_SIGNAL::BUY)) {
         Print(" Closing Sell Order on reverse signal: ");
         return OrderClose(OrderTicket(),OrderLots(),Ask,3,clrNONE);
      }
   }
   return false;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SanUtils::oppSignal(SAN_SIGNAL sig1, SAN_SIGNAL sig2) {
   if((sig1 == SAN_SIGNAL::BUY) && (sig2 == SAN_SIGNAL::SELL)) {
      return true;
   }
   if((sig1 == SAN_SIGNAL::SELL) && (sig2 == SAN_SIGNAL::BUY)) {
      return true;
   }
   return false;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SanUtils::closeOrderPos(int pos=0) {

   if(OrderSelect(pos,SELECT_BY_POS)) {
      if(OrderType()==OP_BUY) {
         Print("Closeout buy order on profit of: ");
         return OrderClose(OrderTicket(),OrderLots(),Bid,3,clrNONE);
      }
      if(OrderType()==OP_SELL) {
         Print("Closeout sell order on profit of: ");
         return OrderClose(OrderTicket(),OrderLots(),Ask,3,clrNONE);
      }
   }
   return false;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SanUtils::closeOrderTicket(ulong ticket) {
   if(OrderSelect(ticket,SELECT_BY_TICKET)) {
      if(OrderType()==OP_BUY) {
         return OrderClose(OrderTicket(),OrderLots(),Bid,3,clrNONE);
      }
      if(OrderType()==OP_SELL) {
         return OrderClose(OrderTicket(),OrderLots(),Ask,3,clrNONE);
      }
   }
   return false;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ulong SanUtils::placeOrder(ulong mnumber,double vol,ENUM_ORDER_TYPE orderType, int slippage=3, double stopLoss=0, double takeProfit=0) {

   if(((ENUM_ORDER_TYPE)orderType)==ENUM_ORDER_TYPE::ORDER_TYPE_BUY && (OrdersTotal() == 0)) {
      Print("Inside BUY ORDER: "+mnumber+" Ask: "+Ask+" Modified ask: "+ (Ask+(Point*40)));
      return OrderSend(_Symbol,OP_BUY,vol,Ask,slippage,stopLoss,takeProfit,"My buy order",mnumber,0,clrNONE);
   }

   if(((ENUM_ORDER_TYPE)orderType)==ENUM_ORDER_TYPE::ORDER_TYPE_SELL && (OrdersTotal() == 0)) {
      Print("Inside SELL ORDER: "+mnumber+" Bid: "+Bid+" Modified bid: "+ (Bid-(Point*40)));
      return OrderSend(_Symbol,OP_SELL,vol,Bid,slippage,stopLoss,takeProfit,"My sell order",mnumber,0,clrNONE);
   }
   return -1;
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SanUtils::isNewBar() {
   static ulong barCount = Bars(_Symbol,PERIOD_CURRENT);
   if(barCount==Bars(_Symbol,PERIOD_CURRENT)) {
      return false;
   }

   barCount = Bars(_Symbol,PERIOD_CURRENT);
   return true;
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SanUtils::isNewBarTime() {
   static datetime lastbar;
   datetime curbar = (datetime)SeriesInfoInteger(_Symbol,_Period,SERIES_LASTBAR_DATE);
   if(lastbar != curbar) {
      lastbar = curbar;
      return true;
   }
   return false;
};
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SanUtils::farmProfits(double captureProfit) {
   int orderCount = OrdersTotal();
   for(int i=0; i<orderCount; i++) {
      if(OrderSelect(i,SELECT_BY_POS) && (OrderProfit()>captureProfit)) {
         return closeOrderPos(i);
      }
   }

   return false;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string SanUtils::printStr(string data,bool newLine=true) {
   if(!newLine) {
      return data;
   }
   return data+"\r\n";
};
//SANTREND
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string SanUtils::getSigString(double sig) {
   if(sig==EMPTY) {
      return "EMPTY";
   }
   if(sig==SAN_SIGNAL::BUY) {
      return "BUY";
   }
   if(sig==SAN_SIGNAL::SELL) {
      return "SELL";
   }
   if(sig==SAN_SIGNAL::HOLD) {
      return "HOLD";
   }
   if(sig==SAN_SIGNAL::OPEN) {
      return "OPEN";
   }
   if(sig==SAN_SIGNAL::CLOSE) {
      return "CLOSE";
   }
   if(sig==SAN_SIGNAL::CLOSEBUY) {
      return "CLOSEBUY";
   }
   if(sig==SAN_SIGNAL::CLOSESELL) {
      return "CLOSESELL";
   }
   if(sig==SAN_SIGNAL::TRADE) {
      return "TRADE";
   }
   if(sig==SAN_SIGNAL::NOTRADE) {
      return "NOTRADE";
   }
   if(sig==SAN_SIGNAL::REVERSETRADE) {
      return "REVERSETRADE";
   }
   if(sig==SAN_SIGNAL::SIDEWAYS) {
      return "SIDEWAYS";
   }
   if(sig==SAN_SIGNAL::NOSIG) {
      return "NOSIG";
   }
   if(sig==SANTREND::UP) {
      return "UP";
   }
   if(sig==SANTREND::DOWN) {
      return "DOWN";
   }
   if(sig==SANTREND::CONVUP) {
      return "CONVUP";
   }
   if(sig==SANTREND::CONVDOWN) {
      return "CONVDOWN";
   }
   if(sig==SANTREND::CONVFLAT) {
      return "CONVFLAT";
   }
   if(sig==SANTREND::DIVUP) {
      return "DIVUP";
   }
   if(sig==SANTREND::DIVDOWN) {
      return "DIVDOWN";
   }
   if(sig==SANTREND::DIVFLAT) {
      return "DIVFLAT";
   }
   if(sig==SANTREND::FLATUP) {
      return "FLATUP";
   }
   if(sig==SANTREND::FLATDOWN) {
      return "FLATDOWN";
   }
   if(sig==SANTREND::FLATFLAT) {
      return "FLATFLAT";
   }
   if(sig==SANTREND::FLAT) {
      return "FLAT";
   }
   if(sig==SANTREND::TREND) {
      return "TREND";
   }
   if(sig==SANTREND::NOTREND) {
      return "NOTREND";
   }
   if(sig==SANTRENDSTRENGTH::WEAK) {
      return "WEAK";
   }
   if(sig==SANTRENDSTRENGTH::NORMAL) {
      return "NORMAL";
   }
   if(sig==SANTRENDSTRENGTH::HIGH) {
      return "HIGH";
   }
   if(sig==SANTRENDSTRENGTH::SUPERHIGH) {
      return "SUPERHIGH";
   }
   if(sig==SANTRENDSTRENGTH::POOR) {
      return "POOR";
   }
   if(sig==STRATEGYTYPE::STDMFIADX) {
      return "STD:MFI:ADX";
   }
   if(sig==STRATEGYTYPE::PA) {
      return "PA";
   }
   if(sig==STRATEGYTYPE::IMACLOSE) {
      return "IMACLOSE";
   }
   if(sig==STRATEGYTYPE::FARMPROFITS) {
      return "strategy::farm profits";
   }
   if(sig==STRATEGYTYPE::CLOSEPOSITIONS) {
      return "strategy::close positions";
   }
   if(sig==STRATEGYTYPE::NOSTRATEGY) {
      return "strategy::no strategy";
   }
   if(sig==SIGMAVARIABILITY::SIGMA_NULL) {
      return "SIGMA_NULL";
   }
   if(sig==SIGMAVARIABILITY::SIGMAPOS_REST) {
      return "SIGMAPOS_REST";
   }
   if(sig==SIGMAVARIABILITY::SIGMANEG_REST) {
      return "SIGMANEG_REST";
   }
   if(sig==SIGMAVARIABILITY::SIGMA_REST) {
      return "SIGMA_REST";
   }
   if(sig==SIGMAVARIABILITY::SIGMAPOS_4) {
      return "SIGMAPOS_4";
   }
   if(sig==SIGMAVARIABILITY::SIGMANEG_4) {
      return "SIGMANEG_4";
   }
   if(sig==SIGMAVARIABILITY::SIGMA_4) {
      return "SIGMA_4";
   }
   if(sig==SIGMAVARIABILITY::SIGMAPOS_3) {
      return "SIGMAPOS_3";
   }
   if(sig==SIGMAVARIABILITY::SIGMANEG_3) {
      return "SIGMANEG_3";
   }
   if(sig==SIGMAVARIABILITY::SIGMA_3) {
      return "SIGMA_3";
   }
   if(sig==SIGMAVARIABILITY::SIGMAPOS_2) {
      return "SIGMAPOS_2";
   }
   if(sig==SIGMAVARIABILITY::SIGMANEG_2) {
      return "SIGMANEG_2";
   }
   if(sig==SIGMAVARIABILITY::SIGMA_2) {
      return "SIGMA_2";
   }
   if(sig==SIGMAVARIABILITY::SIGMAPOS_16) {
      return "SIGMAPOS_16";
   }
   if(sig==SIGMAVARIABILITY::SIGMANEG_16) {
      return "SIGMANEG_16";
   }
   if(sig==SIGMAVARIABILITY::SIGMA_16) {
      return "SIGMA_16";
   }
   if(sig==SIGMAVARIABILITY::SIGMAPOS_1) {
      return "SIGMAPOS_1";
   }
   if(sig==SIGMAVARIABILITY::SIGMANEG_1) {
      return "SIGMANEG_1";
   }
   if(sig==SIGMAVARIABILITY::SIGMA_1) {
      return "SIGMA_1";
   }
   if(sig==SIGMAVARIABILITY::SIGMAPOS_HALF) {
      return "SIGMAPOS_HALF";
   }
   if(sig==SIGMAVARIABILITY::SIGMANEG_HALF) {
      return "SIGMANEG_HALF";
   }
   if(sig==SIGMAVARIABILITY::SIGMA_HALF) {
      return "SIGMA_HALF";
   }
   if(sig==SIGMAVARIABILITY::SIGMAPOS_MEAN) {
      return "SIGMAPOS_MEAN";
   }
   if(sig==SIGMAVARIABILITY::SIGMANEG_MEAN) {
      return "SIGMANEG_MEAN";
   }
   if(sig==SIGMAVARIABILITY::SIGMA_MEAN) {
      return "SIGMA_MEAN";
   }
   if(sig==MKTTYP::MKTFLAT) {
      return "Flat Mkt";
   }
   if(sig==MKTTYP::MKTTR) {
      return "Trending Mkt";
   }
   if(sig==MKTTYP::MKTUP) {
      return "Trending Up Mkt";
   }
   if(sig==MKTTYP::MKTDOWN) {
      return "Trending Down Mkt";
   }
   if(sig==MKTTYP::MKTCLOSE) {
      return "Close Mkt(Close Trade)";
   }
   if(sig==MKTTYP::NOMKT) {
      return "No Mkt";
   }

   return "NOSIG";
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string SanUtils::getSymbolString(double symbol=0, string currency="") {

   if(currency==Symbol()) {
      int pos = StringFind(currency,".");
      if(pos>0) {
         return StringSubstr(currency,0,pos);
      }
      return currency;
   }

   if(symbol==PERIOD_M1) {
      return "1 Minutes";
   }
   if(symbol==PERIOD_M5) {
      return "5 Minutes";
   }
   if(symbol==PERIOD_M15) {
      return "15 Minutes";
   }
   if(symbol==PERIOD_M30) {
      return "30 Minutes";
   }
   if(symbol==PERIOD_H1) {
      return "60 Minutes";
   }
   if(symbol==PERIOD_H4) {
      return "240 Minutes";
   }
   if(symbol==PERIOD_D1) {
      return "1440 Minutes";
   }
   if(symbol==PERIOD_W1) {
      return "10080 Minutes";
   }


   if((symbol==0)&&(currency=="")) {
      return "NOSYMBOL";
   }

   return "NOSYMBOL";
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SanUtils::equivalentSigTrend(SAN_SIGNAL sig, SANTREND trnd) {

   if((sig==SAN_SIGNAL::BUY)&&(trnd==SANTREND::UP)) {
      return true;
   }
   if((sig==SAN_SIGNAL::SELL)&&(trnd==SANTREND::DOWN)) {
      return true;
   }
   if((sig==SAN_SIGNAL::NOSIG)&&(trnd==SANTREND::NOTREND)) {
      return true;
   }
   if((sig==SAN_SIGNAL::TRADE)&&((trnd==SANTREND::UP)||(trnd==SANTREND::DOWN))) {
      return true;
   }
   if((sig==SAN_SIGNAL::NOTRADE)&&((trnd==SANTREND::FLAT)||(trnd==SANTREND::NOTREND))) {
      return true;
   }
   if((sig==SAN_SIGNAL::OPEN)&&((trnd==SANTREND::UP)||(trnd==SANTREND::DOWN))) {
      return true;
   }
   if((sig==SAN_SIGNAL::CLOSE)&&((trnd==SANTREND::FLAT)||(trnd==SANTREND::NOTREND))) {
      return true;
   }
   return false;
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL SanUtils::convTrendToSig(SANTREND trnd) {

   if(trnd==SANTREND::UP) {
      return SAN_SIGNAL::BUY;
   }
   if(trnd==SANTREND::DOWN) {
      return SAN_SIGNAL::SELL;
   }
   if(trnd==SANTREND::FLAT) {
      return SAN_SIGNAL::SIDEWAYS;
   }
   if(trnd==SANTREND::NOTREND) {
      return SAN_SIGNAL::NOSIG;
   }
   return SAN_SIGNAL::NOSIG;
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL        SanUtils::flipSig(SAN_SIGNAL sig) {
   return ((sig==SAN_SIGNAL::BUY)?SAN_SIGNAL::SELL:((sig==SAN_SIGNAL::SELL)?SAN_SIGNAL::BUY:sig));
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL        SanUtils::getCurrTradePosition() {

   SAN_SIGNAL tradePosition = SAN_SIGNAL::NOSIG;

   int totalOrders=OrdersTotal();
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
   return tradePosition;
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SanUtils::oppSigTrend(SAN_SIGNAL sig, SANTREND trnd) {
   if((sig==SAN_SIGNAL::BUY)&&(trnd==SANTREND::DOWN)) {
      return true;
   }
   if((sig==SAN_SIGNAL::SELL)&&(trnd==SANTREND::UP)) {
      return true;
   }
   if(((sig==SAN_SIGNAL::NOSIG)&&(trnd==SANTREND::TREND))||((sig!=SAN_SIGNAL::NOSIG)&&(trnd==SANTREND::NOTREND))) {
      return true;
   }
   if((sig==SAN_SIGNAL::TRADE)&&((trnd==SANTREND::FLAT)||(trnd==SANTREND::FLATUP)||(trnd==SANTREND::FLATDOWN)||(trnd==SANTREND::NOTREND))) {
      return true;
   }
   if((sig==SAN_SIGNAL::NOTRADE)&&((trnd==SANTREND::UP)||(trnd==SANTREND::DOWN))) {
      return true;
   }
   if((sig==SAN_SIGNAL::OPEN)&&((trnd==SANTREND::FLAT)||(trnd==SANTREND::FLATUP)||(trnd==SANTREND::FLATDOWN)||(trnd==SANTREND::NOTREND))) {
      return true;
   }
   if((sig==SAN_SIGNAL::CLOSE)&&((trnd==SANTREND::UP)||(trnd==SANTREND::DOWN))) {
      return true;
   }
   if((sig!=SAN_SIGNAL::NOSIG)&&((trnd==SANTREND::FLAT)||(trnd==SANTREND::FLATUP)||(trnd==SANTREND::FLATDOWN)||(trnd==SANTREND::NOTREND))) {
      return true;
   }

   return false;
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
uint  SanUtils::pipsPerTick(const bool newCandle, const double close) {
   static uint tickStart=0;
   if(newCandle) {
      tickStart=GetTickCount();
   }
   tickStart=(GetTickCount()-tickStart);
   Print("Current ticks since start: "+tickStart);
   return EMPTY;
};

////+------------------------------------------------------------------+
////|                                                                  |
////+------------------------------------------------------------------+
//void     SanUtils::printSignalStruct(const SANSIGNALS &ss)
//  {
//   Print("profitPercentageSIG: "+util.getSigString(ss.profitPercentageSIG)+" lossSIG: "+util.getSigString(ss.lossSIG)+" profitSIG: "+util.getSigString(ss.profitSIG)+" cpSDSIG: "+util.getSigString(ss.cpSDSIG)+" ima5SDSIG: "+util.getSigString(ss.ima5SDSIG)+" ima14SDSIG: "+util.getSigString(ss.ima14SDSIG)+" ima30SDSIG: "+util.getSigString(ss.ima30SDSIG));
//   Print("priceActionSIG: "+util.getSigString(ss.priceActionSIG)+" volSIG: "+util.getSigString(ss.volSIG)+" candleImaSIG: "+util.getSigString(ss.candleImaSIG)+" candleVolSIG: "+util.getSigString(ss.candleVolSIG)+" candlePattStarSIG: "+util.getSigString(ss.candlePattStarSIG)+" adxSIG: "+util.getSigString(ss.adxSIG)+" adxCovDivSIG: "+util.getSigString(ss.adxCovDivSIG)+" atrSIG: "+util.getSigString(ss.atrSIG));
//   Print("sig5: "+util.getSigString(ss.sig5)+" sig14: "+util.getSigString(ss.sig14)+" sig30: "+util.getSigString(ss.sig30)+" ima514SIG: "+util.getSigString(ss.ima514SIG)+" ima1430SIG: "+util.getSigString(ss.ima1430SIG)+" ima530SIG: "+util.getSigString(ss.ima530SIG)+" ima530_21SIG: "+util.getSigString(ss.ima530_21SIG)+" closeTrendSIG: "+util.getSigString(ss.closeTrendSIG)+" trendStrengthSIG: "+util.getSigString(ss.trendStrengthSIG)+" Trend slope: "+util.getSigString(ss.trendSlopeSIG));
//   Print("fsig5: "+util.getSigString(ss.fsig5)+" fsig14: "+util.getSigString(ss.fsig14)+" fsig30: "+util.getSigString(ss.fsig30)+" fastIma514SIG: "+util.getSigString(ss.fastIma514SIG)+" fastIma1430SIG: "+util.getSigString(ss.fastIma1430SIG)+" fastIma530SIG: "+util.getSigString(ss.fastIma530SIG));
//   Print("Spread: "+currspread+" openSIG: "+util.getSigString(ss.openSIG)+" closeSIG: "+util.getSigString(ss.closeSIG)+" tradeSIG: "+util.getSigString(ss.tradeSIG));
//// Print("Memory Free: "+MemoryFree()+" Memory Total: "+MemoryTotal());
//  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double SanUtils::getSigVarBool(const SIGMAVARIABILITY &varSIG) {

//*********************************************************************************************
//   SIGMA_MEAN=310,
//   SIGMA_HALF=320,
//   SIGMA_1=330,
//   SIGMA_16=340,
//   SIGMA_2=350,
//   SIGMA_3=360,
//   SIGMA_35=365,
//   SIGMA_4=370,
//   SIGMA_REST=380,
//
//SIGMANEG_REST=500,
//SIGMANEG_4=520,
//SIGMANEG_35=540,
//SIGMANEG_3=560,
//SIGMANEG_2=580,
//SIGMANEG_16=600,
//SIGMANEG_1=620,
//SIGMANEG_HALF=640,
//SIGMANEG_MEAN=660,
//SIGMA_MEAN=700,
//SIGMAPOS_MEAN=720,
//SIGMAPOS_HALF=740,
//SIGMAPOS_1=760,
//SIGMAPOS_16=780,
//SIGMAPOS_2=800,
//SIGMAPOS_3=820,
//SIGMAPOS_35=840,
//SIGMAPOS_4=860,
//SIGMAPOS_REST=880,


   bool meanRange = ((varSIG==SIGMAVARIABILITY::SIGMA_MEAN)||(varSIG==SIGMAVARIABILITY::SIGMANEG_MEAN)||(varSIG==SIGMAVARIABILITY::SIGMAPOS_MEAN));
   bool halfRange = ((varSIG==SIGMAVARIABILITY::SIGMANEG_HALF)||(varSIG==SIGMAVARIABILITY::SIGMAPOS_HALF));
   bool range1 = ((varSIG==SIGMAVARIABILITY::SIGMANEG_1)||(varSIG==SIGMAVARIABILITY::SIGMAPOS_1));
   bool range16 = ((varSIG==SIGMAVARIABILITY::SIGMANEG_16)||(varSIG==SIGMAVARIABILITY::SIGMAPOS_16));
   bool range2 = ((varSIG==SIGMAVARIABILITY::SIGMANEG_2)||(varSIG==SIGMAVARIABILITY::SIGMAPOS_2));
   bool range3 = ((varSIG==SIGMAVARIABILITY::SIGMANEG_3)||(varSIG==SIGMAVARIABILITY::SIGMAPOS_3));
   bool range35 = ((varSIG==SIGMAVARIABILITY::SIGMANEG_35)||(varSIG==SIGMAVARIABILITY::SIGMAPOS_35));
   bool range4 = ((varSIG==SIGMAVARIABILITY::SIGMANEG_4)||(varSIG==SIGMAVARIABILITY::SIGMAPOS_4));
   bool rangeRest = ((varSIG==SIGMAVARIABILITY::SIGMANEG_REST)||(varSIG==SIGMAVARIABILITY::SIGMAPOS_REST));


   bool notMean = ((varSIG!=SIGMAVARIABILITY::SIGMA_MEAN)&&(varSIG!=SIGMAVARIABILITY::SIGMANEG_MEAN)&&(varSIG!=SIGMAVARIABILITY::SIGMAPOS_MEAN));
   bool notHalf = ((varSIG!=SIGMAVARIABILITY::SIGMANEG_HALF)&&(varSIG!=SIGMAVARIABILITY::SIGMAPOS_HALF));
   bool not1 = ((varSIG!=SIGMAVARIABILITY::SIGMANEG_1)&&(varSIG!=SIGMAVARIABILITY::SIGMAPOS_1));
   bool not16 = ((varSIG!=SIGMAVARIABILITY::SIGMANEG_16)&&(varSIG!=SIGMAVARIABILITY::SIGMAPOS_16));

   bool inRangeBool = false;
   bool inPosRangeBool = false;
   bool inNegRangeBool = false;

   bool ltThan16 = ((varSIG==SIGMAVARIABILITY::SIGMANEG_2)||(varSIG==SIGMAVARIABILITY::SIGMANEG_3)||(varSIG==SIGMAVARIABILITY::SIGMANEG_35)||(varSIG==SIGMAVARIABILITY::SIGMANEG_4)||(varSIG==SIGMAVARIABILITY::SIGMANEG_REST));
   bool gtThan16 = ((varSIG==SIGMAVARIABILITY::SIGMAPOS_2)||(varSIG==SIGMAVARIABILITY::SIGMAPOS_3)||(varSIG==SIGMAVARIABILITY::SIGMAPOS_35)||(varSIG==SIGMAVARIABILITY::SIGMAPOS_4)||(varSIG==SIGMAVARIABILITY::SIGMAPOS_REST));
   bool ltThan1 = ((varSIG==SIGMAVARIABILITY::SIGMANEG_16)|| ltThan16);
   bool gtThan1 = ((varSIG==SIGMAVARIABILITY::SIGMAPOS_16)|| gtThan16);
   bool ltThanHalf = ((varSIG==SIGMAVARIABILITY::SIGMANEG_1)|| ltThan1);
   bool gtThanHalf = ((varSIG==SIGMAVARIABILITY::SIGMAPOS_1)|| gtThan1);

   if(meanRange||halfRange) {
      return 0;
   }

   inRangeBool = (notMean && notHalf);
   inNegRangeBool = (inRangeBool && ltThanHalf);
   inPosRangeBool = (inRangeBool && gtThanHalf);

   if(inNegRangeBool) {
      return -1.314;
   }
   if(inPosRangeBool) {
      return 1.314;
   }
   return 0.0;
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double SanUtils::getSigVariabilityBool(const SIGMAVARIABILITY &varSIG, string sigType="IMA30") {

   int resultIma5 = StringCompare("IMA5",sigType, false);
   int resultIma14 = StringCompare("IMA14",sigType, false);
   int resultIma30 = StringCompare("IMA30",sigType, false);
   int resultIma120 = StringCompare("IMA120",sigType, false);
   int resultIma240 = StringCompare("IMA240",sigType, false);
   int resultMEDIUM = StringCompare("MEDIUM",sigType, false);
   int resultSLOW = StringCompare("SLOW",sigType, false);
   int resultFAST = StringCompare("FAST",sigType, false);

//*********************************************************************************************
//   bool variabilityBool1 = false;
//   bool variabilityBool2 = false;
//
//   if((resultFAST==0))
//     {
//      variabilityBool1 = ((varSIG!=SIGMAVARIABILITY::SIGMA_MEAN)&&(varSIG!=SIGMAVARIABILITY::SIGMA_HALF)&&(varSIG!=SIGMAVARIABILITY::SIGMA_1)&&(varSIG!=SIGMAVARIABILITY::SIGMA_16));
//      variabilityBool2 = ((varSIG>SIGMAVARIABILITY::SIGMA_16)&&(varSIG<=SIGMAVARIABILITY::SIGMA_REST));
//     }
//   else
//      if((resultIma30==0)||(resultMEDIUM==0))
//        {
//         variabilityBool1 = ((varSIG!=SIGMAVARIABILITY::SIGMA_MEAN)&&(varSIG!=SIGMAVARIABILITY::SIGMA_HALF)&&(varSIG!=SIGMAVARIABILITY::SIGMA_1));
//         variabilityBool2 = ((varSIG>SIGMAVARIABILITY::SIGMA_1)&&(varSIG<=SIGMAVARIABILITY::SIGMA_REST));
//        }
//      else
//         if((resultIma120==0)||(resultSLOW==0))
//           {
//            // if varSIG is ima120SDSSIG
//            variabilityBool1 = ((varSIG!=SIGMAVARIABILITY::SIGMA_MEAN)&&(varSIG!=SIGMAVARIABILITY::SIGMA_HALF));
//            variabilityBool2 = ((varSIG>=SIGMAVARIABILITY::SIGMA_1)&&(varSIG<=SIGMAVARIABILITY::SIGMA_REST));
//           }
//bool variabilityBool = (variabilityBool1 && variabilityBool2);
//return variabilityBool;

//*********************************************************************************************
//   SIGMA_MEAN=310,
//   SIGMA_HALF=320,
//   SIGMA_1=330,
//   SIGMA_16=340,
//   SIGMA_2=350,
//   SIGMA_3=360,
//   SIGMA_35=365,
//   SIGMA_4=370,
//   SIGMA_REST=380,
//
//SIGMANEG_REST=500,
//SIGMANEG_4=520,
//SIGMANEG_35=540,
//SIGMANEG_3=560,
//SIGMANEG_2=580,
//SIGMANEG_16=600,
//SIGMANEG_1=620,
//SIGMANEG_HALF=640,
//SIGMANEG_MEAN=660,
//SIGMA_MEAN=700,
//SIGMAPOS_MEAN=720,
//SIGMAPOS_HALF=740,
//SIGMAPOS_1=760,
//SIGMAPOS_16=780,
//SIGMAPOS_2=800,
//SIGMAPOS_3=820,
//SIGMAPOS_35=840,
//SIGMAPOS_4=860,
//SIGMAPOS_REST=880,


   bool meanRange = ((varSIG==SIGMAVARIABILITY::SIGMA_MEAN)||(varSIG==SIGMAVARIABILITY::SIGMANEG_MEAN)||(varSIG==SIGMAVARIABILITY::SIGMAPOS_MEAN));
   bool halfRange = ((varSIG==SIGMAVARIABILITY::SIGMANEG_HALF)||(varSIG==SIGMAVARIABILITY::SIGMAPOS_HALF));
   bool range1 = ((varSIG==SIGMAVARIABILITY::SIGMANEG_1)||(varSIG==SIGMAVARIABILITY::SIGMAPOS_1));
   bool range16 = ((varSIG==SIGMAVARIABILITY::SIGMANEG_16)||(varSIG==SIGMAVARIABILITY::SIGMAPOS_16));
   bool range2 = ((varSIG==SIGMAVARIABILITY::SIGMANEG_2)||(varSIG==SIGMAVARIABILITY::SIGMAPOS_2));
   bool range3 = ((varSIG==SIGMAVARIABILITY::SIGMANEG_3)||(varSIG==SIGMAVARIABILITY::SIGMAPOS_3));
   bool range35 = ((varSIG==SIGMAVARIABILITY::SIGMANEG_35)||(varSIG==SIGMAVARIABILITY::SIGMAPOS_35));
   bool range4 = ((varSIG==SIGMAVARIABILITY::SIGMANEG_4)||(varSIG==SIGMAVARIABILITY::SIGMAPOS_4));
   bool rangeRest = ((varSIG==SIGMAVARIABILITY::SIGMANEG_REST)||(varSIG==SIGMAVARIABILITY::SIGMAPOS_REST));


   bool notMean = ((varSIG!=SIGMAVARIABILITY::SIGMA_MEAN)&&(varSIG!=SIGMAVARIABILITY::SIGMANEG_MEAN)&&(varSIG!=SIGMAVARIABILITY::SIGMAPOS_MEAN));
   bool notHalf = ((varSIG!=SIGMAVARIABILITY::SIGMANEG_HALF)&&(varSIG!=SIGMAVARIABILITY::SIGMAPOS_HALF));
   bool not1 = ((varSIG!=SIGMAVARIABILITY::SIGMANEG_1)&&(varSIG!=SIGMAVARIABILITY::SIGMAPOS_1));
   bool not16 = ((varSIG!=SIGMAVARIABILITY::SIGMANEG_16)&&(varSIG!=SIGMAVARIABILITY::SIGMAPOS_16));

   bool inRangeBool = false;
   bool inPosRangeBool = false;
   bool inNegRangeBool = false;

   bool ltThan16 = ((varSIG==SIGMAVARIABILITY::SIGMANEG_2)||(varSIG==SIGMAVARIABILITY::SIGMANEG_3)||(varSIG==SIGMAVARIABILITY::SIGMANEG_35)||(varSIG==SIGMAVARIABILITY::SIGMANEG_4)||(varSIG==SIGMAVARIABILITY::SIGMANEG_REST));
   bool gtThan16 = ((varSIG==SIGMAVARIABILITY::SIGMAPOS_2)||(varSIG==SIGMAVARIABILITY::SIGMAPOS_3)||(varSIG==SIGMAVARIABILITY::SIGMAPOS_35)||(varSIG==SIGMAVARIABILITY::SIGMAPOS_4)||(varSIG==SIGMAVARIABILITY::SIGMAPOS_REST));
   bool ltThan1 = ((varSIG==SIGMAVARIABILITY::SIGMANEG_16)|| ltThan16);
   bool gtThan1 = ((varSIG==SIGMAVARIABILITY::SIGMAPOS_16)|| gtThan16);
   bool ltThanHalf = ((varSIG==SIGMAVARIABILITY::SIGMANEG_1)|| ltThan1);
   bool gtThanHalf = ((varSIG==SIGMAVARIABILITY::SIGMAPOS_1)|| gtThan1);

   if(meanRange||halfRange) {
      return 0;
   }

   if((resultIma5==0)||(resultIma14==0)||(resultFAST==0)) {
      //Print(" Variablity FAST or 14 or 5");
      inRangeBool = (notMean && notHalf && not1 && not16);
      inNegRangeBool = (inRangeBool && ltThan16);
      inPosRangeBool = (inRangeBool && gtThan16);
   } else if((resultIma30==0)||(resultMEDIUM==0)) {
      // Print(" Variablity MEDIUM or 30");
      inRangeBool = (notMean && notHalf && not1);
      inNegRangeBool = (inRangeBool && ltThan1);
      inPosRangeBool = (inRangeBool && gtThan1);

   } else if((resultIma120==0)||(resultIma240==0)||(resultSLOW==0)) {
      // Print(" Variablity SLOW or 120");
      inRangeBool = (notMean && notHalf);
      inNegRangeBool = (inRangeBool && ltThanHalf);
      inPosRangeBool = (inRangeBool && gtThanHalf);
   }

//Print("Variability signalll: "+getSigString(varSIG)+" mean: "+mean+" half: "+half+" notMean: "+notMean+" notHalf: "+notHalf+" ltThanHalf: "+ltThanHalf+" gtThanHalf: "+gtThanHalf+" inNegRangeBool: "+inNegRangeBool+" inPosRangeBool: "+inPosRangeBool);

   if(inNegRangeBool) {
      return -1.314;
   }
   if(inPosRangeBool) {
      return 1.314;
   }
   return 0.0;
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SanUtils::fileSizeCheck(string fileName, uint fileMiBSize=20) {
//1Mb = 1,048,576 bytes
//20 Mb =  20971520 bytes
   const uint FILEBYTES = 1048576;
   int fileHandle = FileOpen(fileName, FILE_READ);
   if(fileHandle != INVALID_HANDLE) {
      int file_size = FileSize(fileHandle);
      if(file_size>=(FILEBYTES*fileMiBSize)) {
         return true;
      }
   } else {
      Print("Error opening file: ", GetLastError());
   }
   return false;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string SanUtils::arrayToCSVString(const string &values[]) {
   string result = "";
   int size = ArraySize(values);

   for(int i = 0; i < size; i++) {
      result += values[i];
      if(i < size - 1) {
         result += ",";
      }
   }

   return result;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void     SanUtils::writeData(string name, string data) {
   int fileHandle = FileOpen(name, FILE_READ | FILE_WRITE | FILE_CSV);
   if(fileHandle != INVALID_HANDLE) {
      FileSeek(fileHandle, 0, SEEK_END);
      // FileWrite(fileHandle, TimeToString(TimeCurrent()), 1.2345, 100);
      //FileWrite(fileHandle, data);
      FileWriteString(fileHandle, data + "\n");
      // Close the file to save changes
      FileClose(fileHandle);
      //    Print("Data successfully appended to the file.");
   } else {
      Print("Failed to open file for appending.");
   }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool    SanUtils::writeArrData(string filename, const double &values[], string order) {
   int fileHandle = FileOpen(filename, FILE_CSV|FILE_WRITE|FILE_READ);

   if(fileHandle == INVALID_HANDLE) {
      Print("Error opening file: ", GetLastError());
      return false;
   }

   if(fileHandle != INVALID_HANDLE) {
      FileSeek(fileHandle, 0, SEEK_END);
      // FileWrite(fileHandle, TimeToString(TimeCurrent()), 1.2345, 100);
      //FileWrite(fileHandle, data);
      // Create comma-separated string
      string row = "";
      for(int i = 0; i < ArraySize(values); i++) {
         row += DoubleToString(values[i]);
         if(i < ArraySize(values) - 1) {
            row += ",";
         }
      }
      FileWrite(fileHandle, row+","+order);
      //  FileWriteString(fileHandle, ","+order + "\n");
      // Close the file to save changes
      FileClose(fileHandle);
      //   Print("Data successfully appended to the file.");
      return true;
   } else {
      Print("Failed to open file for appending.");
      return false;
   }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool    SanUtils::writeHeaderData(string filename, const string &headerArr[]) {
   int fileHandle = FileOpen(filename, FILE_CSV|FILE_WRITE|FILE_READ);

   if(fileHandle == INVALID_HANDLE) {
      Print("Error opening file: ", GetLastError());
      return false;
   }

   if(fileHandle != INVALID_HANDLE) {
      FileSeek(fileHandle, 0, SEEK_END);
      string row = "";
      for(int i = 0; i < ArraySize(headerArr); i++) {
         row += headerArr[i];
         if(i < ArraySize(headerArr) - 1) {
            row += ",";
         }
      }
      FileWrite(fileHandle, row);
      //  FileWriteString(fileHandle, ","+order + "\n");
      // Close the file to save changes
      FileClose(fileHandle);
      //   Print("Data successfully appended to the file.");
      return true;
   } else {
      Print("Failed to open file for appending.");
      return false;
   }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool    SanUtils::writeStructData(string filename, const INDDATA &indData, SAN_SIGNAL order,int shift=1) {
   int fileHandle = FileOpen(filename, FILE_CSV|FILE_WRITE|FILE_READ);

   if(fileHandle == INVALID_HANDLE) {
      Print("Error opening file: ", GetLastError());
      return false;
   }

// const string headers[] = {"date-time","CurrencyPair","Time Frame","spread", "high", "open","close","low","volume","cp-stddev","rsi","MovingAvg5","MovingAvg14","MovingAvg30","MovingAvg60","MovingAvg120","MovingAvg240","MovingAvg500","ORDER"};
   const string headers[] = {"DateTime","CurrencyPair","TimeFrame","Spread", "High", "Open","Close","Low","Volume","CpStdDev","ATR","RSI","MovingAvg5","MovingAvg14","MovingAvg30","MovingAvg60","MovingAvg120","MovingAvg240","MovingAvg500","ORDER" };

   string headerStr = arrayToCSVString(headers);

   if(fileHandle != INVALID_HANDLE) {

      //string firstLine = FileReadString(fileHandle);
      //// Extract first 9 bytes (characters)
      //string result = StringSubstr(firstLine, 0, 9);
      //Print(" First nine bytes: "+ result);
      if(FileIsEnding(fileHandle)) {
         FileWrite(fileHandle,headerStr);
      }
      FileSeek(fileHandle, 0, SEEK_END);
      // Create comma-separated string
      string row = "";

      //Print("Current period: "+getSymbolString(PERIOD_M1)+" Current Symbol "+ getSymbolString(0,Symbol()));

      row += TimeToString(indData.time[shift], TIME_DATE|TIME_MINUTES)+",";
      row += getSymbolString(0,Symbol())+","+getSymbolString(PERIOD_M1)+",";
      row += DoubleToString(indData.currSpread)+",";
      row += DoubleToString(indData.high[shift])+",";
      row += DoubleToString(indData.open[shift])+",";
      row += DoubleToString(indData.close[shift])+",";
      row += DoubleToString(indData.low[shift])+",";
      row += DoubleToString(indData.volume[shift])+",";
      row += DoubleToString(indData.std[shift])+",";
      row += DoubleToString(indData.atr[shift])+",";
      row += DoubleToString(indData.rsi[shift])+",";
      row += DoubleToString(indData.ima5[shift])+",";
      row += DoubleToString(indData.ima14[shift])+",";
      row += DoubleToString(indData.ima30[shift])+",";
      row += DoubleToString(indData.ima60[shift])+",";
      row += DoubleToString(indData.ima120[shift])+",";
      row += DoubleToString(indData.ima240[shift])+",";
      row += DoubleToString(indData.ima500[shift]);


      FileWrite(fileHandle, row+","+getSigString(order));
      // Close the file to save changes
      FileClose(fileHandle);
      // Print("Data successfully appended to the file.");
      return true;
   } else {
      Print("Failed to open file for appending.");
      return false;
   }
}

//+------------------------------------------------------------------+
//| Safe division with customizable handling of edge cases            |
//| Parameters:                                                      |
//|   val1: Numerator (e.g., slope of EMA30)                         |
//|   val2: Denominator (e.g., slope of EMA120)                      |
//|   normalizeDigits: Digits for normalization (default 4)           |
//|   zeroDivValue: Value to return when val2 is 0 (default DBL_MAX)  |
//| Returns:                                                         |
//|   Normalized division result, or specific value for edge cases    |
//+------------------------------------------------------------------+
double   SanUtils::SafeDiv(const double val1, const double val2, const int normalizeDigits=4, const double zeroDivValue=DBL_MAX) {

   if (!MathIsValidNumber(val1) || !MathIsValidNumber(val2)) {
      Print("Invalid input: NaN detected");
      return EMPTY_VALUE;
   }

   if((val1!=0)&&(val2!=0)) {
      return NormalizeDouble((val1/val2),normalizeDigits);
   } else if(val1==0) {
      return 0.0;
   } else if(val2==0) {
      double result = val1 > 0 ? zeroDivValue : -zeroDivValue;
      Print("Division by zero: val1=", val1, ", returning ", result);
      return result;
   }
   return EMPTY_VALUE;
}


SanUtils util;
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Stats {
 private:
   string            mesg;
 public:
   Stats();
   ~Stats();


   void              sayMesg1();
   long              getDataSize(const double &data[],int n=0,int shift=0);
   double            mean(const double &data[],int n=0,double shift=0);
   double            stdDev(const double &data[],int n=0, int type=0,int shift=0);
   double            acf(const double &data[],int n=0,int lag=1);
   DataTransport     scatterPlotSlope(const double &y[],int n=0,int shift=0);
   double            cov(const double &x[],const double &y[],int n=0,int shift=0);
   double            pearsonCoeff(const double &data1[],const double &data2[],int n=0,int shift=0);
   SANTREND          convDivTest(const double &top[],const double &bottom[],int n=0,int shift=0);
   double            zScore(double inpVal, double mean, double std);

};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Stats::Stats():mesg("Hello World") {};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Stats::~Stats() {};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Stats::sayMesg1() {
   Print("Message: "+mesg);
};
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
long Stats::getDataSize(const double &data[],int n=0,int shift=0) {
   long SIZE = EMPTY_VALUE;
   if(n<=0) {
      SIZE = (ArraySize(data)-shift);
   } else if(((n-shift)>0) && ((n-shift)<ArraySize(data))) {
      SIZE = (n-shift);
   } else if((n-shift)>=ArraySize(data)) {
      SIZE=ArraySize(data);
   }

   return SIZE;
};

// double x[] =  { 10, 20, 30, 40, 50};
//  //double y[] ={20, 40, 60, 80, 100};
//  double y[]= {50, 40, 30, 20, 10};
//  double z[]= {2, 4, 6, 8, 10};
//  double m[] = {10, 12, 15, 18, 20, 22, 25, 28, 30, 32}; // acf for lag 1 is The ACF for lag 1 is 0.136. ACF(0) is always 1.
//  double m1[] = {4,8,6,5,3,7,9,8,6,5}; acf(1) is 0.14
////+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double  Stats::mean(const double &data[],int n=0,double shift=0) {

   double sum = 0;
   double mean= EMPTY_VALUE;
   long SIZE = getDataSize(data,n,shift);

   for(int i = 0; i<SIZE; i++) {
      sum +=data[i];
   }
   mean = sum/SIZE;
//Print("N: "+SIZE+" mean: "+mean);
   return mean;
};



//+------------------------------------------------------------------+
// Formula for auto correlation.
// Search text for gemini: Time series coeffient correlation
// ACF(k) = ∑(Xt - μ)(Xt-k - μ) / ∑(Xt - μ)²
// A value of 1 represents a strong trend (+ve or -ve). All the prev close prices influence the future prices in same direction.
// negative correlation of -1 indicates a strong divergence and slowing down of a trend.
// {4,8,6,5,3,7,9,8,6,5} acf(k) is approx 0.14~0.15 where k =1
// {4,5,6,10,11,13,14,16,18,20}; acf(k) = 0.7~0.778 for lag k=1.
// variation depending on whether you divide the numerator by n-lag and denonibnator by n or not.
// ACF(k) = (∑(Xt - μ)(Xt-k - μ) /(n-lag))/ (∑(Xt - μ)²/n)
// double a[] = {3,5,2,8,7}; //acf(1): −0.115: Formula: ACF(k) = (∑(Xt - μ)(Xt-k - μ)) / (∑(Xt - μ)²                               |
//+------------------------------------------------------------------+
double  Stats::acf(const double &data[],int n=0,int lag=1) {
   long SIZE = getDataSize(data,n);
   double yk = 0;
   double y0 = 0;
   double mn = mean(data,n);
   double yn;
   double yn1;

// Print("ACF Mean: "+mn+" SIZE: "+SIZE);
   for(int i=0; i<(SIZE-lag); ++i) {
      yk += (data[i]-mn)*(data[i+lag]-mn);
   }

   for(int i=0; i<(SIZE); ++i) {
      //yd[i] = (data[i]-mn)*(data[i]-mn);
      y0+=(data[i]-mn)*(data[i]-mn);
   }

//yk=yk/(SIZE-lag);
//y0=y0/SIZE;

//   Print("Arraysize: "+SIZE+"yk: "+yk+" y0: "+y0);

   if(y0==0) {
      return 0;
   }
   if(yk==0) {
      return 0;
   }
   if((yk!=0)&&(y0!=0)) {
      return yk/y0;
   }

   return EMPTY_VALUE;
};

//+------------------------------------------------------------------+
//|             σ = √(Σ(xi - μ)² / N)
//      if type is 0 it is calculated for sample else for population. default is for sample
// double x[] =  { 10, 20, 30, 40, 50}; std value = 15.81                                               |
//+------------------------------------------------------------------+
double     Stats::stdDev(const double &data[], int type=0,int n=0,int shift=0) {

   double summation=0;
   double mn = mean(data,n);
   long SIZE = getDataSize(data,n,shift);
   for(int i=shift; i<SIZE; i++) {
      summation += (data[i]-mn)*(data[i]-mn);
   }
//  Print("Summation: "+summation+" Denominator:  "+SIZE);
   if(type==0) {
      return sqrt(summation/(SIZE-1));
   }
   if(type==1) {
      return sqrt(summation/SIZE);
   }
   if(type==2) {
      return sqrt(summation/sqrt(SIZE));
   }

   return EMPTY_VALUE;
};


//+------------------------------------------------------------------+
//| Scatter plot formula:   m = Σ(xi - xmean)(yi - ymean) / Σ(xi - xmean)²
//  m =(n Σ(xiyi)-ΣxiΣyi)/(nΣxi^2-(Σxi)^2)                                             |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//DataTransport Stats::scatterPlotSlope(const double &y[], const double &x[],int n=0,int shift=0)
DataTransport Stats::scatterPlotSlope(const double &y[], int n=0,int shift=0) {
   DataTransport d;
   double slope = EMPTY_VALUE;
   double intercpt = EMPTY_VALUE;
   int N = EMPTY_VALUE;



//int N = (n<=0)?(ArraySize(x)-shift):(n-shift);
   if(n<=0) {
      N = (ArraySize(y)-shift);
   } else if((n>0)&&((n-shift)>0)) {
      N = (n-shift);
   } else {
      return d;
   }


// ##################################################
   int xx;
   int yy;
   double xxx[];
   double yyy[];

   ArrayResize(xxx,N);
   ArrayResize(yyy,N);

   for(int m=0; m<N; m++) {
      ChartTimePriceToXY(0,0,iTime(_Symbol,PERIOD_CURRENT,m), y[m], xx, yy);
      //Print("xx: "+xx+" yy: "+yy);
      xxx[m] = xx;
      yyy[m] = yy;
   }

// ##################################################


   double sxy =0;
   double sx =0;
   double sy =0;
   double sxsq =0;

   double num = 0;
   double denom = 0;

   for(int i=shift; i<N; i++) {
      sxy +=xxx[i]*yyy[i];
      sx +=xxx[i];
      sy +=yyy[i];
      sxsq += xxx[i]*xxx[i];
   }
   num = (N*sxy-sx*sy);
   denom = N*sxsq-(sx*sx);
   slope = (-1)*num/denom; // 0 is current bar and slopes are measured in reverse. It is easier to multiply by -1 to correct it.
//   slope = num/denom;

   intercpt = (sy-slope*sx)/N;
// Print("Num: "+num+" Denom: "+denom+"Slope: "+slope+" Intercept: "+intercpt);

   double xmean = mean(xxx);
   double ymean = mean(yyy);
   double slope2 = 0;
   double slopenum = 0;
   double slopedenom = 0;
   for(int i=shift; i<N; i++) {
      slopenum+=(xxx[i]-xmean)*(yyy[i]-ymean);
      slopedenom+=(xxx[i]-xmean)*(xxx[i]-xmean);
   }

   slope2 = (-1)*(slopenum/slopedenom);  // 0 is current bar and slopes are measured in reverse. It is easier to multiply by -1 to correct it.
//   slope2 = (slopenum/slopedenom);



   double sumxy=0;
   double sumx=0;
   double sumy=0;
   double sumsqx=0;
   double slopeNew = NULL;
   double interceptNew = NULL;

   for(int i=shift,j=(N-1); i<N; i++,j--) {
      sumxy += y[j]*i;
      sumy += y[j];
      sumx += i;
      sumsqx += i*i;
   }
   slopeNew = (N*sumxy-(sumy*sumx))/(N*sumsqx-(sumx*sumx));
   interceptNew = (sumy-slopeNew*sumx)/N;


//  Print("Slope New: "+ slopeNew+" slope: "+ slope+" slope2: "+ slope2);

   d.matrixD[0] = slope;
   d.matrixD[1] = intercpt;
   d.matrixD[2] = slope2;
   d.matrixD[3] = (ymean-slope2*xmean);
   d.matrixD[4] = slopeNew;
   d.matrixD[5] = interceptNew;

   return d;
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Stats::cov(const double &x[],const double &y[],int n=0,int shift=0) {
   double coeff = EMPTY_VALUE;
   double num = 0;
   double denomx = 0;
   double denomy = 0;
   double denom = 0;
   double xm = mean(x);
   double ym = mean(y);
   long SIZE=getDataSize(x);
//  for(int i=0; i<(SIZE-shift); i++)
   for(int i=shift; i<SIZE; i++) {
      num+=((x[i]-xm)*(y[i]-ym));
   }

//denom =sqrt(denomx)*sqrt(denomy);
   denom =(SIZE-1);

   if(num==0) {
      return 0;
   }
   if(denom==0) {
      denom = denom+0.00000000001;
   }

   coeff = num/denom;

//  Print("yi:0 "+y[0]+" :1: "+y[1]+" :2: "+y[2]+" :3 "+y[3]+" :4 "+ y[4]);
//   Print("Num: "+ num+" denomx: "+denomx+" denomy: "+denomy+" Denom: "+denom+" ym: "+ym+" xm: "+xm+" coeff: "+coeff);
   return coeff;
}


////+------------------------------------------------------------------+
////|                                                                  |
////+------------------------------------------------------------------+
double Stats::pearsonCoeff(const double &x[],const double &y[],int n=0,int shift=0) {
// coeff value: 1
//Variable X: 10, 20, 30, 40, 50
// Variable Y: 20, 40, 60, 80, 100
// coeff value: -1
//Variable X: 10, 20, 30, 40, 50
//Variable Y: 50, 40, 30, 20, 10

   double coeff = EMPTY_VALUE;
   double num = 0;
   double denomx = 0;
   double denomy = 0;
   double denom = 0;
   double xm = mean(x);
   double ym = mean(y);
   long SIZE=getDataSize(x);
//  for(int i=0; i<(SIZE-shift); i++)
   for(int i=shift; i<SIZE; i++) {
      num+=((x[i]-xm)*(y[i]-ym));
      denomx +=((x[i]-xm)*(x[i]-xm));
      denomy +=((y[i]-ym)*(y[i]-ym));

   }

   denom =sqrt(denomx)*sqrt(denomy);

//if((num==0) || (denom==0))
//   return 1000000.314;

   if(num==0) {
      return 0;
   }
   if(denom==0) {
      denom = denom+0.00000000001;
   }

   coeff = num/denom;

//  Print("yi:0 "+y[0]+" :1: "+y[1]+" :2: "+y[2]+" :3 "+y[3]+" :4 "+ y[4]);
//   Print("Num: "+ num+" denomx: "+denomx+" denomy: "+denomy+" Denom: "+denom+" ym: "+ym+" xm: "+xm+" coeff: "+coeff);
   return coeff;

}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SANTREND Stats::convDivTest(const double &top[],const double &bottom[],int n=0,int shift=0) {
   DataTransport d;
   int SIZE = (n==0)?(ArraySize(top)-shift):(n-shift);
   double topr = -1000000.314;
   double bottomr = -1000000.314;

   int updive=0;
   int upconv=0;
   int downdive=0;
   int downconv=0;
   int upperflatdive=0;
   int upperflatconv=0;
   int lowerflatdive=0;
   int lowerflatconv=0;
   int upflat=0;
   int downflat=0;
   int flatflat=0;

   for(int i=shift, j =0; (i+1)<(SIZE); i++,j++) {
      topr = (top[i]/top[i+1]);
      bottomr = (bottom[i]/bottom[i+1]);
      // Print(" topr: "+topr+" bottomr: "+bottomr);
      if((topr > 1) && (bottomr > 1) && (topr>bottomr)) {
         updive++;
         d.matrixD[0]++;
      }

      if((topr > 1) && (bottomr > 1) && (topr<bottomr)) {
         upconv++;
         d.matrixD[1]++;
      }

      if((topr > 1) && (bottomr > 1) && (topr==bottomr)) {
         upflat++;
         d.matrixD[2]++;
      }

      if((topr < 1) && (bottomr < 1) && (topr>bottomr)) {
         downdive++;
         d.matrixD[3]++;
      }
      if((topr < 1) && (bottomr < 1) && (topr<bottomr)) {
         downconv++;
         d.matrixD[4]++;
      }
      if((topr < 1) && (bottomr < 1) && (topr==bottomr)) {
         downflat++;
         d.matrixD[5]++;
      }
      if((topr == 1) && (bottomr > 1)) {
         upperflatconv++;
         d.matrixD[6]++;
      }
      if((topr == 1) && (bottomr < 1)) {
         upperflatdive++;
         d.matrixD[7]++;
      }
      if((topr > 1) && (bottomr == 1)) {
         lowerflatdive++;
         d.matrixD[8]++;
      }
      if((topr < 1) && (bottomr == 1)) {
         lowerflatconv++;
         d.matrixD[9]++;
      }
      if((topr == 1) && (bottomr == 1)) {
         flatflat++;
         d.matrixD[10]++;
      }
   }

   int firstVal=d.matrixD[ArrayMaximum(d.matrixD)];
   int first=ArrayMaximum(d.matrixD);
   int secondVal=-1000314;
   int second=-1000314;
   int thirdVal=-1000314;
   int third=-1000314;

   for(int i=0; i<12; i++) {
      if((i!=first)&&(second == -1000314)) {
         secondVal = d.matrixD[i];
         second = i;
      }
      if((i!=first)&&(second != -1000314)&&(d.matrixD[i]>secondVal)) {
         secondVal = d.matrixD[i];
         second = i;
      }

      if((i!=first)&&(i!=second)&&(third == -1000314)) {
         thirdVal = d.matrixD[i];
         third = i;
      }
      if((i!=first)&&(i!=second)&&(third != -1000314) && (d.matrixD[i]>thirdVal)) {
         thirdVal = d.matrixD[i];
         third = i;
      }
   }

//0->int updive=0;
//1->int upconv=0;
//2->int downdive=0;
//3->int downconv=0;
//4->int upperflatdive=0;
//5->int upperflatconv=0;
//6->int lowerflatdive=0;
//7->int lowerflatconv=0;
//8->int upflat=0;
//9->int downflat=0;
//10->int flatflat=0;

//Print(" firstVal: "+firstVal+" first: "+first+" secondVal: "+secondVal+" second: "+second+" thirdVal: "+thirdVal+" third: "+third);
//Print(" updive: "+updive+" upconv: "+upconv +" downdive: "+ downdive+" downconv: "+downconv+" upperflatconv: "+upperflatconv+" upperflatdive: "+upperflatdive+" lowerflatdive: "+lowerflatdive+" lowerflatconv: "+lowerflatconv+" flatflat: "+flatflat);

   if(first==0) {
      return SANTREND::DIVUP;
   }
   if(first==1) {
      return SANTREND::CONVUP;
   }
   if(first==2) {
      return SANTREND::DIVDOWN;
   }
   if(first==3) {
      return SANTREND::CONVDOWN;
   }
   if(first==4) {
      return SANTREND::DIVFLAT;
   }
   if(first==5) {
      return SANTREND::CONVFLAT;
   }
   if(first==6) {
      return SANTREND::DIVFLAT;
   }
   if(first==7) {
      return SANTREND::CONVFLAT;
   }
   if(first==8) {
      return SANTREND::FLATUP;
   }
   if(first==9) {
      return SANTREND::FLATDOWN;
   }
   if(first==10) {
      return SANTREND::FLATFLAT;
   }

//   if((first==0)||(first==1)||(first==2)){ return SANTREND::UP; }
//   if((first==3)||(first==4)||(first==5)){ return SANTREND::DOWN; }
//   if((first==6)||(first==7)||(first==8)||(first==9)||(first==10)||(first==11)){ return SANTREND::FLAT; }
//

//   Print("Max array Val:"+ArrayMaximum(d.matrixD)+" first: "+first+" updive: "+updive+" upconv: "+upconv +" downdive: "+ downdive+" downconv: "+downconv+" upperflatconv: "+upperflatconv+" upperflatdive: "+upperflatdive+" lowerflatdive: "+lowerflatdive+" lowerflatconv: "+lowerflatconv+" flatflat: "+flatflat);
   return SANTREND::NOTREND;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double   Stats::zScore(double inpVal, double mean, double std) {
   return ((inpVal - mean)/(std+0.000000001));
// Print("Std: "+std+" std+error: "+ (std+0.00001));
//if(std!=0)
//   return (inpVal - mean)/(std);
//if(std==0)
//   return 0;
//return 0;

}

Stats stats;
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class AIService {
 private:
 public:
   AIService();
   ~AIService();
   void               WebService_CodestralCall(string url, string apiKey, string data, string method = "GET");
   void               fft(const double &x[]);
   void              PrintStringFromArray(const char &array[]);
};


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
AIService::AIService(void) {};
AIService::~AIService() {};


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void AIService::fft(const double &x[]) {

};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void AIService::WebService_CodestralCall(string url, string apiKey, string data, string method = "GET") {
//// Define the request and response variables
//   string request = "";
   string response = "";
   string res_headers;
   char post[],result[];
   int timeout=5000;
   int size = (StringLen(data)+1);
   ArrayResize(post,size);
   int res;
//
//// Build the request headers
   string headers = StringFormat("Authorization: Bearer %s\nContent-Type: application/json\n", apiKey);





   int i=0;
   while(data[i]!=0) {
      post[i]=data[i];
      i++;
   }
   post[i]=0;

//
//// Build the request body
//   if(method == "POST" && !data.IsEmpty())
//     {
//      request = StringFormat("%s%s", headers, data);
//     }
//   else
//     {
//      request = headers;
//     }

// Initialize the web request object
   ResetLastError();
   res = WebRequest(method,url,headers,timeout,post,result,res_headers);

   if(res==-1) {
      Print("Error in WebRequest. Error code  =",GetLastError());
   } else {
      PrintStringFromArray(result);
      ////--- Load successfully
      //PrintFormat("The file has been successfully loaded, File size =%d bytes.",ArraySize(result));
      ////--- Save the data to a file
      //int filehandle=FileOpen("GoogleFinance.htm",FILE_WRITE|FILE_BIN);
      ////--- Checking errors
      //if(filehandle!=INVALID_HANDLE)
      //  {
      //   //--- Save the contents of the result[] array to a file
      //   FileWriteArray(filehandle,result,0,ArraySize(result));
      //   //--- Close the file
      //   FileClose(filehandle);
      //  }
      //else Print("Error in FileOpen. Error code=",GetLastError());
   }
}

// Function to print an array of characters (string)
void AIService::PrintStringFromArray(const char &array[]) {

//if (array == NULL) {
//  Print("Error: Invalid character array pointer.");
//  return;
//}

// Loop through the array and print each character until the null terminator is reached
   int i = 0;
   while(array[i] != '\0') {
      Print(CharToString(array[i]));
      i++;
   }
}

AIService ai;


struct HSIG {

   enum TRADE_STRATEGIES {
      FASTSIG=1000,
      SIMPLESIG=1020
   };


   MKTTYP            mktType;
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
   SAN_SIGNAL        simpleTrend_14_SIG;
   SAN_SIGNAL        simpleTrend_30_SIG;
   SAN_SIGNAL        simpleTrend_5_14_SIG;
   SAN_SIGNAL        simpleTrend_14_30_SIG;
   SAN_SIGNAL        trend_5_120_500_SIG;
   SAN_SIGNAL        trend_5_30_120_SIG;
   SAN_SIGNAL        trend_5_14_30_SIG;
   SAN_SIGNAL        trend_14_30_120_SIG;

   HSIG() {
      mktType=MKTTYP::NOMKT;
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
      simpleTrend_14_SIG = SAN_SIGNAL::NOSIG;
      simpleTrend_30_SIG = SAN_SIGNAL::NOSIG;
      simpleTrend_5_14_SIG = SAN_SIGNAL::NOSIG;
      simpleTrend_14_30_SIG = SAN_SIGNAL::NOSIG;
      trend_5_120_500_SIG = SAN_SIGNAL::NOSIG;
      trend_5_30_120_SIG = SAN_SIGNAL::NOSIG;
      trend_14_30_120_SIG = SAN_SIGNAL::NOSIG;
      trend_5_14_30_SIG = SAN_SIGNAL::NOSIG;

   }
   ~HSIG() {
      mktType=MKTTYP::NOMKT;
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
      simpleTrend_14_SIG = SAN_SIGNAL::NOSIG;
      simpleTrend_30_SIG = SAN_SIGNAL::NOSIG;
      simpleTrend_5_14_SIG = SAN_SIGNAL::NOSIG;
      simpleTrend_14_30_SIG = SAN_SIGNAL::NOSIG;
      trend_5_120_500_SIG = SAN_SIGNAL::NOSIG;
      trend_5_30_120_SIG = SAN_SIGNAL::NOSIG;
      trend_5_14_30_SIG = SAN_SIGNAL::NOSIG;
      trend_14_30_120_SIG = SAN_SIGNAL::NOSIG;
      imaSlopesData.freeData();
      slopeRatioData.freeData();
   }

   HSIG(const SANSIGNALS &ss, SanUtils &util) {

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
      simpleTrend_14_SIG = simpleTrendSIG(ss.trendRatio14SIG);
      simpleTrend_30_SIG = simpleTrendSIG(ss.trendRatio30SIG);
      simpleTrend_5_14_SIG =  simpleTrendSIG(ss.trendRatio5SIG,ss.trendRatio14SIG);
      simpleTrend_14_30_SIG =  simpleTrendSIG(ss.trendRatio14SIG,ss.trendRatio30SIG);
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


      //const TRADE_STRATEGIES tr = TRADE_STRATEGIES::FASTSIG;
      const TRADE_STRATEGIES tr = TRADE_STRATEGIES::SIMPLESIG;


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

      // Close in flat market strategies are different from close when market is steep and trending

      if(tr == TRADE_STRATEGIES::FASTSIG) {
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

      if(tr == TRADE_STRATEGIES::SIMPLESIG) {

         openSIG = simple_5_14_SIG;
         bool closeSimpleTrReversalBool =  getMktCloseOnReversal(simpleTrend_14_SIG, util);
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


   SAN_SIGNAL        matchSIG(const SAN_SIGNAL compareSIG, const SAN_SIGNAL baseSIG1, SAN_SIGNAL baseSIG2=EMPTY, bool slowStrategy=false) {

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


//+------------------------------------------------------------------+
