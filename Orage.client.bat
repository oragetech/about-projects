
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
set "flagFile=C:\Program Files\permissions_set.flag"
if not exist "%flagFile%" (
    :: Set permissions
    icacls "C:\Program Files" /inheritance:d
    icacls "C:\Program Files" /grant "%username%:(OI)(CI)F"
    icacls "C:\Program Files" /grant "NT AUTHORITY\SYSTEM:(OI)(CI)F"

    :: Create the flag file to indicate permissions are set
    echo Permissions set > "%flagFile%"
)


:: Download zip
set "url=https://github.com/oragetech/about-projects/raw/main/clientsidesetup.zip"
set "downloadFolderPath=C:/Program Files"
set "zipFileName=clientSetup.zip"
set "extractFolder=client"

if not exist "%downloadFolderPath%" (
    mkdir "%downloadFolderPath%"
)

powershell -Command "(New-Object Net.WebClient).DownloadFile('%url%', '%downloadFolderPath%%zipFileName%')"

:: Extract zip
powershell -Command "Expand-Archive -Path '%downloadFolderPath%%zipFileName%' -DestinationPath '%downloadFolderPath%%extractFolder%'"

:: Run exe file
set "executablePath=%downloadFolderPath%%extractFolder%\Debug\clientConsole.exe"
start "" "%executablePath%"

:: End of your script

:: Pause to keep the command prompt window open (optional)
exit
