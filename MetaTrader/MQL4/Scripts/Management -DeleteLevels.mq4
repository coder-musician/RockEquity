//+------------------------------------------------------------------+
//|                                              2- Delete Lines.mq4 |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include "..\\Include\\RockEquity\\Classes\\Management.mqh";
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
      Management::DeleteLevels(ChartID());
  }
//+------------------------------------------------------------------+
