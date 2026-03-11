@echo off
chcp 65001 >nul
echo ========================================
echo   Building APK with JDK 17
echo ========================================
echo.

rem Set JAVA_HOME with quotes to handle spaces
set "JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-17.0.18.8-hotspot"
set "PATH=%JAVA_HOME%\bin;%PATH%"

echo JAVA_HOME: %JAVA_HOME%
echo.
echo Verifying Java...
java -version
echo.

if errorlevel 1 (
    echo Java verification failed
    pause
    exit /b 1
)

echo Java is working!
echo.
echo ========================================
echo Building APK
echo ========================================
echo.

echo Step 1: Cleaning old build...
call gradlew.bat clean --no-daemon
echo.

echo Step 2: Building Debug APK...
echo ========================================
echo This will take 10-20 minutes, please wait...
echo Do NOT close this window!
echo ========================================
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

    echo APK Location:
    echo   app\build\outputs\apk\debug\app-debug.apk
    echo.
    echo File Size: about %SIZE_MB% MB
    echo.
    echo ========================================
    echo Installation Instructions
    echo ========================================
    echo.
    echo 1. Connect your phone to PC with USB cable
    echo 2. Copy the APK file to your phone
    echo 3. Click the APK file to install
    echo 4. Allow installation from unknown sources
    echo.

    choice /c YN /n /m "Open APK folder? (Y/N): "
    if not errorlevel 2 (
        explorer "app\build\outputs\apk\debug\"
    )
) else (
    echo.
    echo ========================================
    echo Build Failed
    echo ========================================
    echo.
    echo Please check the error messages above.
    echo.
    echo Common issues:
    echo 1. Network connection problem
    echo 2. Gradle download failed
    echo 3. Dependency download failed
    echo.
    echo Alternative solution:
    echo   Use GitHub Actions online build (100% success rate)
    echo   See: GitHub构建APK指南.md
)

echo.
pause
