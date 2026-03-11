@echo off
chcp 65001 >nul
echo ========================================
echo   手动设置 JDK 路径并构建
echo ========================================
echo.

if exist "gradlew.bat" (
    echo ✅ 在正确的项目目录
) else (
    echo ❌ 请在 BadmintonAndroid 项目目录下运行此脚本
    pause
    exit /b 1
)

echo.
echo 请输入您的 JDK 17 安装路径
echo.
echo 示例：
echo C:\Program Files\Eclipse Adoptium\jdk-17.0.9.101-hotspot
echo C:\Program Files\Java\jdk-17
echo.
echo 如果您不知道路径，可以：
echo 1. 打开文件资源管理器
echo 2. 在 C:\Program Files\ 下搜索 "java.exe"
echo 3. 找到 jdk-17.x.x 文件夹的完整路径
echo.

set /p JDK_PATH="请输入 JDK 路径: "

if "%JDK_PATH%"=="" (
    echo ❌ 路径不能为空
    pause
    exit /b 1
)

:: 去除路径末尾的斜杠
if "%JDK_PATH:~-1%"=="\" set JDK_PATH=%JDK_PATH:~0,-1%

echo.
echo 您输入的路径：%JDK_PATH%
echo.

:: 检查路径是否存在
if not exist "%JDK_PATH%\bin\java.exe" (
    echo ❌ 在该路径下未找到 java.exe
    echo 请检查路径是否正确
    echo.
    pause
    exit /b 1
)

echo ✅ 找到 java.exe
echo.

:: 设置环境变量
set JAVA_HOME=%JDK_PATH%
set PATH=%JAVA_HOME%\bin;%PATH%

echo [1/4] 验证 Java 版本...
java -version
if errorlevel 1 (
    echo ❌ Java 验证失败
    pause
    exit /b 1
)
echo.
echo ✅ Java 环境设置完成
echo.

:: 清理
echo [2/4] 清理旧的构建...
call gradlew.bat clean
echo.

:: 构建
echo [3/4] 开始构建 APK...
echo 这可能需要 10-20 分钟...
echo.
call gradlew.bat assembleDebug --no-daemon

if errorlevel 1 (
    echo.
    echo ❌ 构建失败
    pause
    exit /b 1
)

:: 完成
echo.
echo [4/4] 检查 APK 文件...
if exist "app\build\outputs\apk\debug\app-debug.apk" (
    echo ✅ 构建成功！
    echo.
    echo APK 位置：app\build\outputs\apk\debug\app-debug.apk
    echo.
    choice /c YN /n /m "打开文件夹? (Y/N): "
    if not errorlevel 2 explorer app\build\outputs\apk\debug\
) else (
    echo ❌ 未找到 APK
)

pause
