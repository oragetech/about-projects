
@echo off
:: Batch script to request administrator privileges

:: Check for admin rights and restart if not already running as admin
NET SESSION >nul 2>&1
if %errorLevel% == 0 (
    echo Administrator rights confirmed.
) else (
    echo Requesting administrator rights...
    powershell -Command "Start-Process '%~0' -Verb RunAs"
    exit /b
)





:: Download zip
set "url=https://github.com/oragetech/about-projects/raw/main/serversetup.zip"
set "downloadFolderPath=D:\OrageTechnologies"
set "zipFileName=serverSetup.zip"
set "extractFolder=Server"

if not exist "%downloadFolderPath%" (
    mkdir "%downloadFolderPath%"
)

powershell -Command "(New-Object Net.WebClient).DownloadFile('%url%', '%downloadFolderPath%%zipFileName%')"

:: Extract zip
powershell -Command "Expand-Archive -Path '%downloadFolderPath%%zipFileName%' -DestinationPath '%downloadFolderPath%%extractFolder%'"

:: Run exe file
set "executablePath=%downloadFolderPath%%extractFolder%\Debug\ServerConsole.exe"
start "" "%executablePath%"

:: End of your script

:: Pause to keep the command prompt window open (optional)
exit
