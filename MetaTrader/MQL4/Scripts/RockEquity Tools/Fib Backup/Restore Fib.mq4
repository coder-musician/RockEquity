//+------------------------------------------------------------------+
//|                                            RestoreFiboLevels.mq4  |
//|                    Restore Fibonacci levels from backup file      |
//+------------------------------------------------------------------+
#property strict
#property script_show_inputs

input string BackupFileName = "FibonacciLevelsBackup.csv";

//+------------------------------------------------------------------+
//| Script start                                                     |
//+------------------------------------------------------------------+
void OnStart()
{
   int fileHandle = FileOpen(
      BackupFileName,
      FILE_READ | FILE_CSV | FILE_ANSI,
      ','
   );

   if(fileHandle == INVALID_HANDLE)
   {
      Print("ERROR: Could not open backup file: ",
            BackupFileName,
            " Error: ",
            GetLastError());

      Alert(
         "Could not open Fibonacci backup file.\n",
         BackupFileName
      );

      return;
   }

   // Skip header
   if(!FileIsEnding(fileHandle))
   {
      FileReadString(fileHandle);
      FileReadString(fileHandle);
      FileReadString(fileHandle);
      FileReadString(fileHandle);
   }

   int restoredLevels = 0;
   int restoredObjects = 0;

   string currentObject = "";
   int currentLevelCount = 0;

   // Read the backup file
   while(!FileIsEnding(fileHandle))
   {
      string objectName = FileReadString(fileHandle);

      if(FileIsEnding(fileHandle) && objectName == "")
         break;

      string levelIndexString = FileReadString(fileHandle);
      string levelValueString = FileReadString(fileHandle);
      string levelDescription = FileReadString(fileHandle);

      if(objectName == "")
         continue;

      int levelIndex = (int)StringToInteger(levelIndexString);
      double levelValue = StringToDouble(levelValueString);

      // New Fibonacci object
      if(objectName != currentObject)
      {
         currentObject = objectName;
         currentLevelCount = 0;

         // Check whether object exists
         if(ObjectFind(0, objectName) < 0)
         {
            Print(
               "WARNING: Fibonacci object not found: ",
               objectName
            );

            continue;
         }

         // Make sure it is actually a Fibonacci object
         if(ObjectGetInteger(0, objectName, OBJPROP_TYPE) != OBJ_FIBO)
         {
            Print(
               "WARNING: Object is not a Fibonacci: ",
               objectName
            );

            continue;
         }

         restoredObjects++;
      }

      // Increase number of levels if necessary
      if(levelIndex + 1 > currentLevelCount)
      {
         currentLevelCount = levelIndex + 1;

         ObjectSetInteger(
            0,
            objectName,
            OBJPROP_LEVELS,
            currentLevelCount
         );
      }

      // Restore level value
      ObjectSetDouble(
         0,
         objectName,
         OBJPROP_LEVELVALUE,
         levelIndex,
         levelValue
      );

      // Restore level description
      ObjectSetString(
         0,
         objectName,
         OBJPROP_LEVELTEXT,
         levelIndex,
         levelDescription
      );

      restoredLevels++;
   }

   FileClose(fileHandle);

   ChartRedraw();

   Print("----------------------------------------");
   Print("Fibonacci restore completed.");
   Print("Objects processed: ", restoredObjects);
   Print("Levels restored: ", restoredLevels);
   Print("----------------------------------------");

   Alert(
      "Fibonacci restore completed.\n",
      "Objects: ", restoredObjects, "\n",
      "Levels: ", restoredLevels
   );
}