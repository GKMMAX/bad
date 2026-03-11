@echo off
chcp 65001 >nul
echo Starting APK build script...
powershell -ExecutionPolicy Bypass -File "%~dp0auto_build_apk.ps1"
pause
