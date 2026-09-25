//+------------------------------------------------------------------+
//|                                                        Utils.mqh |
//|                                  Copyright 2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property library

#include "Constants.mqh"

class Utils
  {
private:
   


   
   
public:
  
   Utils();
  ~Utils();
  
  // --------------------------- CHARTS
  
  static int GetHTFPeriod(int ltf_period) {
      
      int htf_period= 0;
      
      if(ltf_period == PERIOD_M1)
         htf_period = PERIOD_M5;
         
      if(ltf_period == PERIOD_M5)
         htf_period = PERIOD_M30;
         
      if(ltf_period == PERIOD_M15)
         htf_period = PERIOD_H1;
         
      if(ltf_period == PERIOD_M30)
         htf_period = PERIOD_H4;
         
      if(ltf_period == PERIOD_H1)
         htf_period = PERIOD_H4;
         
      if(ltf_period == PERIOD_H4)
         htf_period = PERIOD_D1;
         
      if(ltf_period == PERIOD_D1)
         htf_period = PERIOD_W1;
         
      if(ltf_period == PERIOD_W1)
         htf_period = PERIOD_MN1;
         
      return htf_period;
   }
   
// --------------------------- DATE / TIME  
  
   static string GetDate() {
      
      datetime local_time = TimeLocal();
      string datetime_string = TimeToString(local_time);
      
      string date = StringSubstr(datetime_string, 0, StringFind(datetime_string," "));
      
      StringReplace(date,".","");
      
      return date;
      
   }
   
   static string GetTime() {
      
      datetime local_time = TimeLocal();
      string datetime_string = TimeToString(local_time);
      
      string time = StringSubstr(datetime_string, StringFind(datetime_string," ")+1);
      StringReplace(time,":",".");
      
      StringReplace(time,".","");
      
      time = time + IntegerToString(Seconds());
      
      return time;
   }


  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Utils::Utils()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Utils::~Utils()
  {
  }
//+------------------------------------------------------------------+