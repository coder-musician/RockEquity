//+------------------------------------------------------------------+
//|                                             BackupFiboLevels.mq4  |
//|                         Backup Fibonacci levels from current chart |
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
      FILE_WRITE | FILE_CSV | FILE_ANSI,
      ','
   );

   if(fileHandle == INVALID_HANDLE)
   {
      Print("ERROR: Could not create backup file: ",
            BackupFileName,
            " Error: ",
            GetLastError());

      return;
   }

   // Header
   FileWrite(
      fileHandle,
      "ObjectName",
      "LevelIndex",
      "LevelValue",
      "LevelDescription"
   );

   int totalObjects = ObjectsTotal(0, 0, -1);
   int fiboCount = 0;
   int levelCount = 0;

   // Scan all objects on the current chart
   for(int i = 0; i < totalObjects; i++)
   {
      string objectName = ObjectName(0, i, 0, -1);

      if(objectName == "")
         continue;

      // Is this a Fibonacci Retracement?
      if(ObjectGetInteger(0, objectName, OBJPROP_TYPE) != OBJ_FIBO)
         continue;

      fiboCount++;

      // Number of Fibonacci levels
      int levels = (int)ObjectGetInteger(
         0,
         objectName,
         OBJPROP_LEVELS
      );

      Print("Found Fibonacci: ",
            objectName,
            " | Levels: ",
            levels);

      // Save each level
      for(int level = 0; level < levels; level++)
      {
         double levelValue = ObjectGetDouble(
            0,
            objectName,
            OBJPROP_LEVELVALUE,
            level
         );

         string levelDescription = ObjectGetString(
            0,
            objectName,
            OBJPROP_LEVELTEXT,
            level
         );

         FileWrite(
            fileHandle,
            objectName,
            level,
            DoubleToString(levelValue, 8),
            levelDescription
         );

         levelCount++;
      }
   }

   FileClose(fileHandle);

   Print("----------------------------------------");
   Print("Fibonacci backup completed.");
   Print("Fibonacci objects found: ", fiboCount);
   Print("Total levels backed up: ", levelCount);
   Print("Backup file: ", BackupFileName);
   Print("----------------------------------------");

   Alert(
      "Fibonacci backup completed.\n",
      "Objects: ", fiboCount, "\n",
      "Levels: ", levelCount, "\n",
      "File: ", BackupFileName
   );
}