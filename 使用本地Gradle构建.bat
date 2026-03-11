@echo off
chcp 65001 >nul
echo ========================================
echo   Using Local Gradle to Build APK
echo ========================================
echo.

if not exist "gradle-8.4-bin.zip" (
    echo Gradle not found, downloading...
    powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://services.gradle.org/distributions/gradle-8.4-bin.zip', 'gradle-8.4-bin.zip')"
)

if exist "gradle-8.4" (
    echo Gradle already extracted
) else (
    echo Extracting Gradle...
    powershell -Command "Expand-Archive -Path 'gradle-8.4-bin.zip' -DestinationPath ."
)

set GRADLE_HOME=%cd%\gradle-8.4
set PATH=%GRADLE_HOME%\bin;%PATH%

echo [1/3] Checking Java...
java -version
if errorlevel 1 (
    echo Java not found
    pause
    exit /b 1
)
echo.
echo [2/3] Cleaning...
gradle clean
echo.
echo [3/3] Building APK...
echo This may take 15-20 minutes...
gradle assembleDebug

if exist "app\build\outputs\apk\debug\app-debug.apk" (
    echo.
    echo ========================================
    echo Build Successful!
    echo ========================================
    echo APK: app\build\outputs\apk\debug\app-debug.apk
    explorer app\build\outputs\apk\debug\
) else (
    echo Build failed
)

pause
