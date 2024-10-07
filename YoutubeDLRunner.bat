@echo off
REM Set PowerShell execution policy to allow script execution
PowerShell -Command "Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force"

REM Run the YouTubeDL PowerShell script
PowerShell -File "C:\YoutubeDL\YoutubeDLPowerShell.ps1"

REM Pause to keep the window open if needed
pause
