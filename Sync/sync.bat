@echo off

set "SOURCE=C:\Users\alexa\AppData\Roaming\MetaQuotes\Terminal\16616473FC1E28EAD2003DE66409B757\templates"
set "DEST=.\templates"

echo Syncing...
echo Source: %SOURCE%
echo Destination: %DEST%
echo.

robocopy "%SOURCE%" "%DEST%" /MIR /COPY:DAT /DCOPY:DAT /R:2 /W:2

echo.
echo Sync completed.
pause
::-------------------------------------------------------------------------------------------------------------

set "SOURCE=C:\Users\alexa\AppData\Roaming\MetaQuotes\Terminal\16616473FC1E28EAD2003DE66409B757\MQL4\Experts"
set "DEST=.\MQL4\Experts"

echo Syncing...
echo Source: %SOURCE%
echo Destination: %DEST%
echo.

robocopy "%SOURCE%" "%DEST%" /MIR /COPY:DAT /DCOPY:DAT /R:2 /W:2

echo.
echo Sync completed.
pause
::-------------------------------------------------------------------------------------------------------------

set "SOURCE=C:\Users\alexa\AppData\Roaming\MetaQuotes\Terminal\16616473FC1E28EAD2003DE66409B757\MQL4\Resources"
set "DEST=.\MQL4\Resources"

echo Syncing...
echo Source: %SOURCE%
echo Destination: %DEST%
echo.

robocopy "%SOURCE%" "%DEST%" /MIR /COPY:DAT /DCOPY:DAT /R:2 /W:2

echo.
echo Sync completed.
pause
::-------------------------------------------------------------------------------------------------------------

set "SOURCE=C:\Users\alexa\AppData\Roaming\MetaQuotes\Terminal\16616473FC1E28EAD2003DE66409B757\MQL4\Scripts"
set "DEST=.\MQL4\Scripts"

echo Syncing...
echo Source: %SOURCE%
echo Destination: %DEST%
echo.

robocopy "%SOURCE%" "%DEST%" /MIR /COPY:DAT /DCOPY:DAT /R:2 /W:2

echo.
echo Sync completed.
pause

::-------------------------------------------------------------------------------------------------------------

set "SOURCE=C:\Users\alexa\AppData\Roaming\MetaQuotes\Terminal\16616473FC1E28EAD2003DE66409B757\MQL4\Include\RockEquity"
set "DEST=.\MQL4\Include\RockEquity"

echo Syncing...
echo Source: %SOURCE%
echo Destination: %DEST%
echo.

robocopy "%SOURCE%" "%DEST%" /MIR /COPY:DAT /DCOPY:DAT /R:2 /W:2

echo.
echo Sync completed.
pause
::-------------------------------------------------------------------------------------------------------------



