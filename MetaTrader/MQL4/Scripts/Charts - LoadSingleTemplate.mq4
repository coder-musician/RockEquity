//+------------------------------------------------------------------+
//|                                                      TestBed.mq4 |
//|                                  Copyright 2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+

#include "..\\Include\\RockEquity\\Classes\\RockExpert.mqh";

void OnStart() {
   
   string templateName = "RockEquity-" + Symbol() + ".tpl";
   ChartApplyTemplate(ChartID(), templateName);
   
   
}
//+------------------------------------------------------------------+
