//+------------------------------------------------------------------+
//|                                                 CustomVolume.mqh |
//|                                  CopyRight 2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include "..\\Constants.mqh"
   
class CustomVolume
  {
private:

   static void DeleteVolume(long ChartId, string volumaName) {
   
      ObjectDelete(ChartId, volumaName);         
   }
   
public:
   
   CustomVolume();
   ~CustomVolume();
   
   static void PlotCustomVolume(long ChartId, bool newcandle) {
      
      string objectName = "Volume";

      //if(newcandle) {
      
         DeleteVolume(ChartID(), objectName);  
         
         //if(ChartPeriod() == LTF_PERIOD) {
         
            double AverageVolume = 0;
            long CurrentVolume = iVolume(Symbol(),Period(),1);
                  
            for(int i=2; i < BARS_INCLUDED; i++) {
            
               AverageVolume = AverageVolume + iVolume(Symbol(),Period(),i);
            }
            
            AverageVolume = AverageVolume/(BARS_INCLUDED - 2);
            AverageVolume = NormalizeDouble(AverageVolume,0);
                  
            double VolumeRate = (CurrentVolume / AverageVolume)*100;      
            string VolumeRateString = DoubleToStr(VolumeRate,0);            
            
            datetime RightEdgeTime = TimeCurrent() + (VOLUME_OFFSET_VALUE * PeriodSeconds());      
            ObjectCreate(ChartId, objectName, OBJ_TEXT, 0, RightEdgeTime, Ask);
            
            ObjectSetString(ChartId, objectName, OBJPROP_TEXT, VolumeRateString + "%");
            ObjectSetInteger(ChartId, objectName, OBJPROP_FONTSIZE, VOLUMES_FONT_SIZE);      
            ObjectSetInteger(ChartId, objectName, OBJPROP_COLOR, VOLUMES_FONT_COLOR);
         //}
      //}
      //else {
      
        // bool MoveLine = ObjectSetDouble(ChartId, objectName, OBJPROP_PRICE1, Ask);
      //}
   }
   
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CustomVolume::CustomVolume()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CustomVolume::~CustomVolume()
  {
  }
//+------------------------------------------------------------------+
