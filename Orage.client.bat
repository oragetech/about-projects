@echo off
setlocal

:: Check if the flag file exists, indicating permissions are already set
set "flagFile=C:\Program Files\permissions_set.flag"
if not exist "%flagFile%" (
    :: Set permissions
    icacls "C:\Program Files" /inheritance:d
    icacls "C:\Program Files" /grant "%username%:(OI)(CI)F"
    icacls "C:\Program Files" /grant "NT AUTHORITY\SYSTEM:(OI)(CI)F"

    :: Create the flag file to indicate permissions are set
    echo Permissions set > "%flagFile%"
)

:: Download zip (with -Force to overwrite if the file already exists)
set "url=https://github.com/oragetech/about-projects/raw/main/clientsetup.zip"
set "downloadFolderPath=C:\Program Files\Oragetechnologies"
set "zipFileName=clientsetup.zip"
set "extractFolder=Client"

if not exist "%downloadFolderPath%" (
    mkdir "%downloadFolderPath%"
)

powershell -Command "(New-Object Net.WebClient).DownloadFile('%url%', '%downloadFolderPath%\%zipFileName%') -Force"

:: Extract zip (with -Force to overwrite if the files already exist)
powershell -Command "Expand-Archive -Path '%downloadFolderPath%\%zipFileName%' -DestinationPath '%downloadFolderPath%\%extractFolder%' -Force"

:: Run exe file
set "executablePath=%downloadFolderPath%\%extractFolder%\Debug\clientConsole.exe"
start "" "%executablePath%"

:: Delete the zip file
del "%downloadFolderPath%\%zipFileName%"

endlocal
