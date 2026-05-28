--- Include/Sandeep/v2/SanHSIG-v2.mqh (before)
+++ Include/Sandeep/v2/SanHSIG-v2.mqh (after - use kineticAccelerationSIG for stationarity)
@@ -727,8 +727,15 @@ void   HSIG::initSIG(const SANSIGNALS &ss, SanUtils &util) {
    baseTrendSIG = imaTrendSIG(ss.ima120240SIG, ss.trendRatio120SIG, ss.trendRatio240SIG);
 //baseSlopeSIG = slopeSIG(ss.baseSlopeData, 3, 0.6);
 //baseSlopeSIG = slopeSIG(ss.baseSlopeData, 3, 0.2);
-   baseSlopeSIG = slopeSIG(ss.baseSlopeData, 3, 0.05);
+   // PATCH: Use the stationary kinetic acceleration ratio (the simple slope philosophy)
+   // instead of a raw magnitude threshold on the slow slope.
+   // SS::update already called kineticAccelerationSIG(baseSlopeData.val1, .val2, 0.005)
+   // which computes:  ratio = (fastSlope - slowSlope) / slowSlope
+   // This ratio + its gates (-0.05 enter / -0.1 CLOSE) is far more stationary
+   // across assets and timeframes than any fixed pips-per-bar magnitude.
+   baseSlopeSIG = ss.baseSlopeSIG;
 
 //cTSIG = cTradeSIG(ss, util, 1);
    atrCandle_tradeSIG = cTradeSIG_v2(ss, util, 1);
    tradeSIG = atrCandle_tradeSIG;
    c_SIG = cSIG(ss, util, 1);
