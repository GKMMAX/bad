@echo off
chcp 65001 >nul
echo ========================================
echo   自动查找 JDK 并构建 APK
echo ========================================
echo.

rem Try multiple common JDK paths
set JDK_PATH=

if exist "C:\Program Files\Eclipse Adoptium\jdk-17.0.18-hotspot\bin\java.exe" (
    set JDK_PATH=C:\Program Files\Eclipse Adoptium\jdk-17.0.18-hotspot
    echo Found JDK: %JDK_PATH%
    goto :build
)

if exist "C:\Program Files\Eclipse Adoptium\jdk-17.0.9-hotspot\bin\java.exe" (
    set JDK_PATH=C:\Program Files\Eclipse Adoptium\jdk-17.0.9-hotspot
    echo Found JDK: %JDK_PATH%
    goto :build
)

if exist "C:\Program Files\Eclipse Adoptium\jdk-17.0.8-hotspot\bin\java.exe" (
    set JDK_PATH=C:\Program Files\Eclipse Adoptium\jdk-17.0.8-hotspot
    echo Found JDK: %JDK_PATH%
    goto :build
)

if exist "C:\Program Files\Java\jdk-17.0.18\bin\java.exe" (
    set JDK_PATH=C:\Program Files\Java\jdk-17.0.18
    echo Found JDK: %JDK_PATH%
    goto :build
)

if exist "C:\jdk-17.0.18\bin\java.exe" (
    set JDK_PATH=C:\jdk-17.0.18
    echo Found JDK: %JDK_PATH%
    goto :build
)

if exist "C:\jdk-17\bin\java.exe" (
    set JDK_PATH=C:\jdk-17
    echo Found JDK: %JDK_PATH%
    goto :build
)

echo.
echo ========================================
echo JDK 17 not found in common locations
echo ========================================
echo.
echo Please enter your JDK 17 installation path:
echo.
echo Examples:
echo   C:\Program Files\Eclipse Adoptium\jdk-17.0.18-hotspot
echo   C:\Program Files\Java\jdk-17.0.18
echo   C:\jdk-17
echo.
set /p JDK_PATH="JDK Path: "

if "%JDK_PATH%"=="" (
    echo No path entered
    pause
    exit /b 1
)

rem Remove trailing backslash if present
if "%JDK_PATH:~-1%"=="\" set JDK_PATH=%JDK_PATH:~0,-1%

:build
echo.
echo Verifying Java...
if exist "%JDK_PATH%\bin\java.exe" (
    echo Testing Java...
    "%JDK_PATH%\bin\java.exe" -version
    if errorlevel 1 (
        echo.
        echo Java verification failed
        pause
        exit /b 1
    )
    echo.
    echo Java is working!
    echo.
) else (
    echo Error: java.exe not found at:
    echo %JDK_PATH%\bin\java.exe
    echo.
    pause
    exit /b 1
)

rem Set environment variables
set "JAVA_HOME=%JDK_PATH%"
set "PATH=%JAVA_HOME%\bin;%PATH%"

echo ========================================
echo Building APK
echo ========================================
echo.

echo Step 1: Cleaning old build...
call gradlew.bat clean --no-daemon
echo.

echo Step 2: Building Debug APK...
echo This will take 10-20 minutes, please wait...
echo Do NOT close this window!
echo.

call gradlew.bat assembleDebug --no-daemon --stacktrace

if exist "app\build\outputs\apk\debug\app-debug.apk" (
    echo.
    echo ========================================
    echo SUCCESS! APK built successfully!
    echo ========================================
    echo.
    for %%I in ("app\build\outputs\apk\debug\app-debug.apk") do set SIZE=%%~zI
    set /a SIZE_MB=%SIZE% / 1048576
    echo APK Location: app\build\outputs\apk\debug\app-debug.apk
    echo File Size: about %SIZE_MB% MB
    echo.
    choice /c YN /n /m "Open folder? (Y/N): "
    if not errorlevel 2 (
        explorer "app\build\outputs\apk\debug\"
    )
) else (
    echo.
    echo ========================================
    echo Build failed
    echo ========================================
    echo.
    echo Please check the error messages above.
    echo.
    echo Alternative: Use GitHub Actions online build
    echo See: GitHub构建APK指南.md
)

echo.
pause
