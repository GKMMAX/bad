@echo off
chcp 65001 > nul
echo ========================================
echo BadmintonBooking APK 构建脚本
echo ========================================
echo.

cd /d "%~dp0"

echo [1/3] 检查 Java 环境...
where java >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 未找到 Java
    echo 请先安装 JDK 17: https://adoptium.net/temurin/releases/?version=17
    echo.
    echo 或使用 Android Studio 构建项目
    pause
    exit /b 1
)
echo [✓] Java 已安装
java -version
echo.

echo [2/3] 构建 Debug APK...
echo 这可能需要几分钟，请耐心等待...
echo.
call gradlew.bat assembleDebug
if %errorlevel% neq 0 (
    echo.
    echo [错误] 构建失败
    echo 请检查错误信息并重试
    pause
    exit /b 1
)
echo.

echo [3/3] 构建完成！
echo.
echo ========================================
echo APK 位置:
echo app\build\outputs\apk\debug\app-debug.apk
echo ========================================
echo.
if exist "app\build\outputs\apk\debug\app-debug.apk" (
    echo 打开文件夹...
    explorer app\build\outputs\apk\debug\
) else (
    echo [警告] 未找到 APK 文件
)

echo.
echo 按任意键退出...
pause >nul
