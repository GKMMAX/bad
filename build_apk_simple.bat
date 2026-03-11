@echo off
chcp 65001 >nul
echo ========================================
echo   APK Build Script (Simple)
echo ========================================
echo.

rem Find Java
set JAVA_CMD=
for %%d in (C:\Program Files\Eclipse Adoptium\jdk-17* C:\Program Files\Java\jdk-17* C:\jdk-17*) do (
    if exist "%%d\bin\java.exe" (
        set JAVA_CMD=%%d\bin\java.exe
        echo Found Java: %%d
        goto :found_java
    )
)

if not defined JAVA_CMD (
    echo Java not found
    echo Please run this script after setting JAVA_HOME
    pause
    exit /b 1
)

:found_java
echo.
echo Java version:
"%JAVA_CMD%" -version
echo.

rem Use local Gradle if available, or download
if exist "gradle-8.4\bin\gradle.bat" (
    echo Using local Gradle
    set GRADLE_CMD=gradle-8.4\bin\gradle.bat
) else (
    echo Downloading Gradle...
    powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://services.gradle.org/distributions/gradle-8.4-bin.zip', 'gradle-8.4-bin.zip')" 2>nul

    if not exist "gradle-8.4-bin.zip" (
        echo Failed to download Gradle
        pause
        exit /b 1
    )

    echo Extracting Gradle...
    powershell -Command "Expand-Archive -Path 'gradle-8.4-bin.zip' -DestinationPath ."
)

echo.
echo ========================================
echo Building APK
echo ========================================
echo.

echo Step 1: Cleaning...
"%GRADLE_CMD%" clean --no-daemon

echo.
echo Step 2: Building Debug APK (this will take 10-20 minutes)...
"%GRADLE_CMD%" assembleDebug --no-daemon

if exist "app\build\outputs\apk\debug\app-debug.apk" (
    echo.
    echo ========================================
    echo SUCCESS!
    echo ========================================
    echo.
    echo APK Location: app\build\outputs\apk\debug\app-debug.apk
    echo.

    for %%I in ("app\build\outputs\apk\debug\app-debug.apk") do set SIZE=%%~zI
    set /a SIZE_MB=%SIZE% / 1048576
    echo File Size: about %SIZE_MB% MB
    echo.

    choice /c YN /n /m "Open folder? (Y/N): "
    if not errorlevel 2 (
        explorer "app\build\outputs\apk\debug\"
    )
) else (
    echo.
    echo Build failed
    echo.
    echo Possible reasons:
    echo 1. Network connection issue
    echo 2. Configuration error
    echo.
    echo Try GitHub Actions online build instead
)

echo.
pause
