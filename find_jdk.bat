@echo off
chcp 65001 >nul
echo ========================================
echo   Find JDK Path
echo ========================================
echo.

echo Searching for JDK 17...
echo.

rem Search Eclipse Adoptium
if exist "C:\Program Files\Eclipse Adoptium" (
    echo Found Eclipse Adoptium folder
    echo.
    for /d %%d in ("C:\Program Files\Eclipse Adoptium\*") do (
        if exist "%%d\bin\java.exe" (
            echo Found JDK: %%d
            echo.
            echo Testing Java...
            "%%d\bin\java.exe" -version
            if not errorlevel 1 (
                echo.
                echo ========================================
                echo JDK Path Found!
                echo ========================================
                echo.
                echo Copy this path:
                echo %%d
                echo.
                echo Then run these commands:
                echo.
                echo set JAVA_HOME=%%d
                echo set PATH=%%JAVA_HOME%%\bin;%%PATH%%
                echo cd C:\Users\hp\WorkBuddy\Claw\BadmintonAndroid
                echo gradlew.bat assembleDebug
                echo.
                pause
                exit /b 0
            )
        )
    )
)

echo JDK not found in Eclipse Adoptium
echo.
echo Searching other locations...
echo.

rem Search Program Files\Java
if exist "C:\Program Files\Java" (
    for /d %%d in ("C:\Program Files\Java\*") do (
        echo Checking: %%d
        if exist "%%d\bin\java.exe" (
            "%%d\bin\java.exe" -version
            echo.
            echo Use this path: %%d
            pause
            exit /b 0
        )
    )
)

rem Search C:\ directly
for /d %%d in (C:\jdk-17*) do (
    if exist "%%d\bin\java.exe" (
        echo Found: %%d
        "%%d\bin\java.exe" -version
        pause
        exit /b 0
    )
)

echo.
echo ========================================
echo JDK not found automatically
echo ========================================
echo.
echo Please check if JDK 17 is installed
echo.
echo Common installation paths:
echo - C:\Program Files\Eclipse Adoptium\jdk-17.x.x
echo - C:\Program Files\Java\jdk-17
echo - C:\jdk-17
echo.
echo If installed, please enter the path manually
set /p JDK_PATH="Enter JDK path: "

if "%JDK_PATH%"=="" (
    echo No path entered
    pause
    exit /b 1
)

if exist "%JDK_PATH%\bin\java.exe" (
    echo.
    echo Testing Java...
    "%JDK_PATH%\bin\java.exe" -version
    if not errorlevel 1 (
        echo.
        echo Found valid JDK!
        echo.
        echo Run these commands:
        echo.
        echo set JAVA_HOME=%JDK_PATH%
        echo set PATH=%%JAVA_HOME%%\bin;%%PATH%%
        echo cd C:\Users\hp\WorkBuddy\Claw\BadmintonAndroid
        echo gradlew.bat assembleDebug
        echo.
    )
) else (
    echo Invalid path: java.exe not found
)

pause
