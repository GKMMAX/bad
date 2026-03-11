@echo off
chcp 65001 >nul
echo ========================================
echo   自动搜索 JDK 并构建 APK
echo ========================================
echo.

set FOUND_JAVA=

echo [1/4] 正在搜索 JDK 安装位置...

rem 搜索 Eclipse Adoptium
if exist "C:\Program Files\Eclipse Adoptium" (
    for /f "delims=" %%i in ('dir "C:\Program Files\Eclipse Adoptium\jdk-17*" /b /ad 2^>nul') do (
        if exist "C:\Program Files\Eclipse Adoptium\%%i\bin\java.exe" (
            set JAVA_HOME=C:\Program Files\Eclipse Adoptium\%%i
            set PATH=%JAVA_HOME%\bin;%PATH%
            echo 找到 JDK: %JAVA_HOME%
            goto :build
        )
    )
)

rem 搜索 Oracle JDK
if exist "C:\Program Files\Java" (
    for /f "delims=" %%i in ('dir "C:\Program Files\Java\jdk-17*" /b /ad 2^>nul') do (
        if exist "C:\Program Files\Java\%%i\bin\java.exe" (
            set JAVA_HOME=C:\Program Files\Java\%%i
            set PATH=%JAVA_HOME%\bin;%PATH%
            echo 找到 JDK: %JAVA_HOME%
            goto :build
        )
    )
)

rem 搜索 Program Files (x86)
if exist "C:\Program Files (x86)\Eclipse Adoptium" (
    for /f "delims=" %%i in ('dir "C:\Program Files (x86)\Eclipse Adoptium\jdk-17*" /b /ad 2^>nul') do (
        if exist "C:\Program Files (x86)\Eclipse Adoptium\%%i\bin\java.exe" (
            set JAVA_HOME=C:\Program Files (x86)\Eclipse Adoptium\%%i
            set PATH=%JAVA_HOME%\bin;%PATH%
            echo 找到 JDK: %JAVA_HOME%
            goto :build
        )
    )
)

echo.
echo ========================================
echo 未找到 JDK 17 自动安装
echo ========================================
echo.
echo 请运行：手动设置JDK路径.bat
echo 并手动输入您的 JDK 安装路径
echo.
pause
exit /b 1

:build
echo.
echo [2/4] 验证 Java 环境...
java -version
if errorlevel 1 (
    echo.
    echo Java 验证失败，请运行：手动设置JDK路径.bat
    pause
    exit /b 1
)
echo ✅ Java 环境正常
echo.

echo [3/4] 清理旧的构建文件...
call gradlew.bat clean 2>nul
echo.

echo ========================================
echo [4/4] 开始构建 Debug APK
echo ========================================
echo.
echo 首次构建需要下载依赖，可能需要 10-20 分钟
echo 请耐心等待，不要关闭此窗口...
echo.

call gradlew.bat assembleDebug --stacktrace --no-daemon

if errorlevel 1 (
    echo.
    echo ========================================
    echo 构建失败！
    echo ========================================
    echo.
    echo 常见原因：
    echo 1. 网络问题 - 无法下载依赖
    echo 2. Gradle 版本问题
    echo.
    echo 请查看上方的错误信息
    echo.
    pause
    exit /b 1
)

echo.
echo ========================================
echo 检查 APK 文件
echo ========================================
echo.

if exist "app\build\outputs\apk\debug\app-debug.apk" (
    for %%I in ("app\build\outputs\apk\debug\app-debug.apk") do set SIZE=%%~zI
    set /a SIZE_MB=%SIZE% / 1048576
    
    echo.
    echo ========================================
    echo ✅ APK 构建成功！
    echo ========================================
    echo.
    echo 文件位置：
    echo app\build\outputs\apk\debug\app-debug.apk
    echo.
    echo 文件大小：约 %SIZE_MB% MB
    echo.
    
    choice /c YN /n /m "是否打开 APK 所在文件夹? (Y/N): "
    if not errorlevel 2 (
        explorer app\build\outputs\apk\debug\
    )
) else (
    echo 未找到 APK 文件，请检查构建日志
)

echo.
pause
