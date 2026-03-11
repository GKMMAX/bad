@echo off
chcp 65001 >nul
echo ========================================
echo   搜索 JDK 并构建 APK
echo ========================================
echo.

:: 搜索常见的 JDK 安装位置
echo 正在搜索 JDK 安装位置...
echo.

set FOUND_JAVA=

:: 搜索 Adoptium Temurin
for /f "delims=" %%i in ('dir "C:\Program Files\Eclipse Adoptium" /s /b java.exe 2^>nul') do (
    set FOUND_JAVA=%%i
    goto :found
)

:: 搜索 Oracle JDK
for /f "delims=" %%i in ('dir "C:\Program Files\Java" /s /b java.exe 2^>nul') do (
    set FOUND_JAVA=%%i
    goto :found
)

:: 搜索 AdoptOpenJDK
for /f "delims=" %%i in ('dir "C:\Program Files\AdoptOpenJDK" /s /b java.exe 2^>nul') do (
    set FOUND_JAVA=%%i
    goto :found
)

:: 搜索 Program Files (x86)
for /f "delims=" %%i in ('dir "C:\Program Files (x86)\Eclipse Adoptium" /s /b java.exe 2^>nul') do (
    set FOUND_JAVA=%%i
    goto :found
)

for /f "delims=" %%i in ('dir "C:\Program Files (x86)\Java" /s /b java.exe 2^>nul') do (
    set FOUND_JAVA=%%i
    goto :found
)

:found
if defined FOUND_JAVA (
    echo ✅ 找到 Java: %FOUND_JAVA%

    :: 提取 JDK 目录
    for %%i in ("%FOUND_JAVA%") do set JAVA_DIR=%%~dpi
    set JAVA_DIR=%JAVA_DIR:~0,-5%

    echo ✅ JDK 目录: %JAVA_DIR%
    echo.

    :: 设置 JAVA_HOME
    set JAVA_HOME=%JAVA_DIR%
    set PATH=%JAVA_HOME%\bin;%PATH%

    echo [1/4] 验证 Java 版本...
    java -version
    if errorlevel 1 (
        echo ❌ Java 验证失败
        pause
        exit /b 1
    )
    echo ✅ Java 验证通过
    echo.
) else (
    echo ❌ 未找到 JDK 安装
    echo.
    echo 请确保 JDK 17 已安装，或手动设置 JAVA_HOME 环境变量
    echo.
    echo 常见安装位置：
    echo - C:\Program Files\Eclipse Adoptium\jdk-17.x.x.x-hotspot\
    echo - C:\Program Files\Java\jdk-17\
    echo.
    echo 您可以手动运行构建脚本并设置 JAVA_HOME：
    echo set JAVA_HOME=您的JDK目录
    echo set PATH=%JAVA_HOME%\bin;%PATH%
    echo gradlew.bat assembleDebug
    echo.
    pause
    exit /b 1
)

:: 检查 Gradle
echo [2/4] 检查 Gradle 包装器...
if not exist "gradlew.bat" (
    echo ❌ 未找到 gradlew.bat
    echo 请确保在 BadmintonAndroid 项目目录下运行
    pause
    exit /b 1
)
echo ✅ Gradle 包装器存在
echo.

:: 清理旧构建
echo [3/4] 清理旧的构建文件...
call gradlew.bat clean
if errorlevel 1 (
    echo ⚠️ 清理失败，继续构建...
) else (
    echo ✅ 清理完成
)
echo.

:: 构建 APK
echo ========================================
echo [4/4] 开始构建 Debug APK
echo ========================================
echo.
echo 这可能需要 10-20 分钟，请耐心等待...
echo.

call gradlew.bat assembleDebug --stacktrace --no-daemon

if errorlevel 1 (
    echo.
    echo ========================================
    echo ❌ 构建失败！
    echo ========================================
    echo.
    echo 可能的原因：
    echo 1. 网络连接问题（下载依赖失败）
    echo 2. Gradle 配置问题
    echo 3. 代码错误
    echo.
    echo 请查看上方的错误信息
    echo.
    pause
    exit /b 1
)

:: 检查 APK
echo.
echo ========================================
echo 检查生成的 APK...
echo ========================================
echo.

if exist "app\build\outputs\apk\debug\app-debug.apk" (
    echo ✅ APK 构建成功！
    echo.
    echo 文件位置：
    echo app\build\outputs\apk\debug\app-debug.apk
    echo.

    :: 获取文件大小
    for %%I in ("app\build\outputs\apk\debug\app-debug.apk") do set SIZE=%%~zI
    set /a SIZE_MB=%SIZE% / 1048576
    echo APK 文件大小：约 %SIZE_MB% MB
    echo.

    echo ========================================
    echo ✅ 构建成功完成！
    echo ========================================
    echo.

    choice /c YN /n /m "是否打开 APK 所在文件夹? (Y/N): "
    if errorlevel 2 goto :end
    if errorlevel 1 (
        explorer app\build\outputs\apk\debug\
    )
) else (
    echo ❌ 未找到 APK 文件
    echo 请检查构建日志
)

:end
echo.
pause
