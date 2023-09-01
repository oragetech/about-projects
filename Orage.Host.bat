@echo off
setlocal

:: Check if the flag file exists to skip permission setup
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
set "url=https://github.com/oragetech/about-projects/raw/main/serversetup.zip"
set "downloadFolderPath=C:\Program Files\Oragetechnologies"
set "zipFileName=serversetup.zip"
set "extractFolder=Host"

if not exist "%downloadFolderPath%" (
    mkdir "%downloadFolderPath%"
)

powershell -Command "(New-Object Net.WebClient).DownloadFile('%url%', '%downloadFolderPath%\%zipFileName%')"

:: Extract zip
powershell -Command "Expand-Archive -Path '%downloadFolderPath%\%zipFileName%' -DestinationPath '%downloadFolderPath%\%extractFolder%'"

:: Run exe file
set "executablePath=%downloadFolderPath%\%extractFolder%\Debug\ServerConsole.exe"
start "" "%executablePath%"

:: Delete the zip file
del "%downloadFolderPath%\%zipFileName%"

:: Close the Command Prompt window
exit

endlocal
