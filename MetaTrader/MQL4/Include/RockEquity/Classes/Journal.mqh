//+------------------------------------------------------------------+
//|                                                      Journal.mqh |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include "..\\Constants.mqh"
#include "..\\Utils.mqh"

class Journal
  {
private:
   
      static string GetImagesFolder(string symbol, string timeframe) {
         
         datetime ServerTime = TimeCurrent();
         string ServerTimeString = TimeToString(ServerTime);
         ServerTimeString = StringSubstr(ServerTimeString,0,10);
         
         //string ImageRootPath = IMAGE_PATH + symbol + "\\" + ServerTimeString + "\\" + timeframe + "\\";
         string ImageRootPath = timeframe + "\\";
         
         return  ImageRootPath;
   }   
      
      static string GetImageName(string symbol, string desc, string timeframe) {
      
         datetime LocalTime = TimeLocal();
         datetime ServerTime = TimeCurrent();
         
         string LocalTimeString = TimeToString(LocalTime);
         StringReplace(LocalTimeString, " ", "_");
         StringReplace(LocalTimeString, ":", ".");
         
         string ServerTimeString = TimeToString(ServerTime);
         StringReplace(ServerTimeString, " ", "_");
         StringReplace(ServerTimeString, ":", ".");
         
         string ImageName = symbol + "--" + ServerTimeString + "--" + LocalTimeString + 
            "--" + desc + "--" + timeframe + IMAGE_EXTENSION;
         
         return ImageName;
   }
      
      static string GetImageFullPath(string symbol, string desc, string timeframe) {
         
         return GetImagesFolder(symbol, timeframe) + 
            GetImageName(symbol, desc, timeframe);
      }
      
      static void TakeSnapshot(long ltf_chart_id, long htf_chart_id, string desc) {
         
         string symbol = ChartSymbol(ltf_chart_id);
         string imagePath = GetImageFullPath(symbol, desc, "LTF");
               
         bool SnapSuccess = ChartScreenShot(LTF_CHART_ID, imagePath, IMAGE_XPIX, IMAGE_YPIX, ALIGN_RIGHT); 
         
         symbol = ChartSymbol(htf_chart_id);
         imagePath = GetImageFullPath(symbol, desc, "HTF");
         
         SnapSuccess = ChartScreenShot(HTF_CHART_ID, imagePath, IMAGE_XPIX, IMAGE_YPIX, ALIGN_RIGHT); 
      }

   
public:

   Journal();
  ~Journal();
  
   static void TakeMarketSnapshot(long ltf_chart_id, long htf_chart_id) {
      
      TakeSnapshot(ltf_chart_id, htf_chart_id, "Market");
   }
   
   static void TakeOpenSnapshot(long ltf_chart_id, long htf_chart_id) {
      
      TakeSnapshot(ltf_chart_id, htf_chart_id, "Open--" + IntegerToString(ORDER_TICKET));
   }
   
   static void TakeTradeNextSnapshot(long ltf_chart_id, long htf_chart_id) {
      
      TakeSnapshot(ltf_chart_id, htf_chart_id, "Next--" + IntegerToString(ORDER_TICKET));
   }
   
   static void TakeCloseSnapshot(long ltf_chart_id, long htf_chart_id) {
      
      TakeSnapshot(ltf_chart_id, htf_chart_id, "Close--" + IntegerToString(ORDER_TICKET));
   }
   
   static void TakeCustomSnapshot(long ltf_chart_id, long htf_chart_id) {
   
      string ImageFolder = GetImagesFolder(Symbol(), "Custom\\" + Symbol() + "\\LTF\\");
      string ImageName = GetImageName(Symbol(), "Custom", "LTF");
      
      string symbol = ChartSymbol(LTF_CHART_ID);
      string imagePath = ImageFolder+ImageName;            
      bool SnapSuccess = ChartScreenShot(LTF_CHART_ID, imagePath, IMAGE_XPIX, IMAGE_YPIX, ALIGN_RIGHT);
      
      
      ImageFolder = GetImagesFolder(Symbol(), "Custom\\" + Symbol() + "\\HTF\\");
      ImageName = GetImageName(Symbol(), "Custom", "HTF");
      
      symbol = ChartSymbol(HTF_CHART_ID);
      imagePath = ImageFolder+ImageName;   
      SnapSuccess = ChartScreenShot(HTF_CHART_ID, imagePath, IMAGE_XPIX, IMAGE_YPIX, ALIGN_RIGHT);
   }
   
      
  };
  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Journal::Journal()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Journal::~Journal()
  {
  }
//+------------------------------------------------------------------+


  /*static void TakeSnapshot(string symbol, string Description) {
            
      long HtfChartId;
      long LtfChartId;
      
      Utils::GetChartIDs(symbol, HtfChartId, LtfChartId);
      Utils::
      
      if(Description != "")
         Description = "-" + Description;
      
      string FileName = symbol + "-" + Utils::GetDate() + "-" + Utils::GetTime() + Description + IMAGE_EXTENSION;
      
      long chartID = LtfChartId;
      string timeFrame = "LTF";
      
      string FilePath = timeFrame + "\\";
      string FullPath = FilePath + FileName;
      
      bool SnapSuccess = ChartScreenShot(chartID, FullPath, IMAGE_XPIX, IMAGE_YPIX, ALIGN_RIGHT); 
      
      Sleep(100);
      
      chartID = HtfChartId;
      timeFrame = "HTF";
      
      FilePath = timeFrame + "\\";
      FullPath = FilePath + FileName;
      
      SnapSuccess = ChartScreenShot(chartID, FullPath, IMAGE_XPIX, IMAGE_YPIX, ALIGN_RIGHT);
      
   }
   
   static void TakeSnapshotID(long htfid, long ltfid, string Description) {
      
      string symbol = ChartSymbol(htfid);
      
      if(Description != "")
         Description = "-" + Description;
            
      string FileName = symbol + "-" + Utils::GetDate() + "-" + Utils::GetTime() + Description + IMAGE_EXTENSION;
      
      string FullPath = "LTF\\" + FileName;      
      bool SnapSuccess = ChartScreenShot(ltfid, FullPath, IMAGE_XPIX, IMAGE_YPIX, ALIGN_RIGHT); 
      
      Sleep(100);
      
      FullPath = "HTF\\" + FileName; 
      
      SnapSuccess = ChartScreenShot(htfid, FullPath, IMAGE_XPIX, IMAGE_YPIX, ALIGN_RIGHT);
      
   }
   
   static void MarketSnapshot(string symbol) {
      
      Journal::TakeSnapshot(symbol, "");
   }
   
   static void TradeSnapshot(string symbol, string tradeID) {
      
      Journal::TakeSnapshot(symbol, tradeID);   
   }   
   
   static void CustomSnapshot(string symbol) {
      
      Journal::TakeSnapshot(symbol, "Custom");
   }*/