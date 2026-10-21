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

void OnStart() {
   
        
   string templateName = "RockEquity-" + Symbol() + ".tpl";
   
   ChartSaveTemplate(ChartID(), templateName);
   
   
   long chart_id = ChartFirst();
   
   while(chart_id >= 0) {
   
      if(ChartSymbol(chart_id) == Symbol() && chart_id != ChartID()) {
      
         ChartApplyTemplate(chart_id, templateName);
      }
      
      chart_id = ChartNext(chart_id);
       
   }   
}
//+------------------------------------------------------------------+
