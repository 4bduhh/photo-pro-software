@echo off
setlocal
title PhotoPrint Pro - Install

set "APP_URL=https://pro-software-ecru.vercel.app/"

set "BROWSER="
for %%P in (
  "%ProgramFiles%\Google\Chrome\Application\chrome.exe"
  "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe"
  "%LocalAppData%\Google\Chrome\Application\chrome.exe"
  "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe"
  "%ProgramFiles%\Microsoft\Edge\Application\msedge.exe"
) do (
  if not defined BROWSER if exist %%P set "BROWSER=%%~P"
)

if not defined BROWSER (
  echo Chrome or Edge was not found on this PC. Please install Google Chrome and run this again.
  pause
  exit /b 1
)

set "PROFILE=C:\PhotoPrintPro"
if not exist "%PROFILE%" mkdir "%PROFILE%"

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$icon=$env:BROWSER+',0';" ^
  "try{ Add-Type -AssemblyName System.Drawing; $png=$env:PROFILE+'\icon.png'; (New-Object Net.WebClient).DownloadFile($env:APP_URL+'icons/icon-192.png',$png); $bmp=New-Object System.Drawing.Bitmap($png); $ic=[System.Drawing.Icon]::FromHandle($bmp.GetHicon()); $fs=[IO.File]::Create($env:PROFILE+'\app.ico'); $ic.Save($fs); $fs.Close(); $icon=$env:PROFILE+'\app.ico' }catch{};" ^
  "$d=[Environment]::GetFolderPath('Desktop');" ^
  "$s=(New-Object -ComObject WScript.Shell).CreateShortcut((Join-Path $d 'PhotoPrint Pro.lnk'));" ^
  "$s.TargetPath=$env:BROWSER;" ^
  "$s.Arguments='--kiosk-printing --app=' + $env:APP_URL + ' --user-data-dir=' + $env:PROFILE;" ^
  "$s.IconLocation=$icon;" ^
  "$s.Description='PhotoPrint Pro';" ^
  "$s.Save()"

if errorlevel 1 (
  echo Could not create the desktop icon.
  pause
  exit /b 1
)

echo.
echo  Done! "PhotoPrint Pro" icon is now on your Desktop.
echo.
echo  IMPORTANT (one time):
echo   Windows Settings ^> Printers ^& scanners ^> choose your photo printer
echo   ^> "Set as default". Print now sends to the default printer.
echo.
pause