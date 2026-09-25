//+------------------------------------------------------------------+
//|                                                    SetLevels.mq4 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include "..\\Include\\RockEquity\\Classes\\Management.mqh";
#include "..\\Include\\RockEquity\\Constants.mqh";

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+

void OnStart()
  {          
      double Spread = (Ask-Bid);
      double Risk = Spread*RISK_REWARD_RATIO;
      
      Management::DeleteLevels(ChartID());
      
      Management::PlotLine(ChartID(), "SL", Bid - Risk, STOP_LOSS_COLOR);
      ObjectSetInteger(ChartID(), "SL", OBJPROP_SELECTED, true);
  
  }      
//+------------------------------------------------------------------+
