//+------------------------------------------------------------------+
//|                                          Orders - PlaceOrder.mq4 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include "..\\Include\\RockEquity\\Constants.mqh";
#include "..\\Include\\RockEquity\\Classes\\Orders.mqh";

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//--- 
      PROFIT_LIMIT_AMOUNT = AccountBalance() + (AccountBalance() * PROFIT_LIMIT_PERCENTAGE/100);
      
      Alert(PROFIT_LIMIT_AMOUNT);
      
      if(SET_PROFIT_LIMIT && (AccountBalance() < PROFIT_LIMIT_AMOUNT))
         Orders::PlaceOrder(ChartID(), Symbol());
      else
         Alert("Profit Limit Reached");
   
  }
//+------------------------------------------------------------------+

