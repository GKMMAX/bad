@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
echo.
echo ========================================
echo   羽毛球场地预订 - 构建 APK
echo ========================================
echo.

if not exist "gradlew.bat" (
    echo 错误：请在 BadmintonAndroid 目录下运行此脚本
    pause
    exit /b 1
)

rem 检查 Java
java -version >nul 2>&1
if not errorlevel 1 (
    echo 检测到 Java 已安装
    java -version
    echo.
    goto :build
)

echo 未检测到 Java 环境变量
echo.
echo 请选择：
echo.
echo 1. 尝试自动搜索 JDK
echo 2. 手动输入 JDK 路径
echo 3. 使用 GitHub Actions 在线构建（推荐）
echo.
choice /c 123 /n /m "请选择 (1/2/3): "
if errorlevel 3 goto github
if errorlevel 2 goto manual
if errorlevel 1 goto search

:search
echo.
echo 正在搜索 JDK 17...
echo.

rem 搜索 C 盘根目录的 jdk-17
for /d %%d in (C:\jdk-17*) do (
    if exist "%%d\bin\java.exe" (
        set JAVA_HOME=%%d
        set PATH=!JAVA_HOME!\bin;!PATH!
        echo 找到 JDK: !JAVA_HOME!
        goto :verify
    )
)

rem 搜索常见位置
if exist "C:\Program Files\Eclipse Adoptium" (
    for /d %%d in ("C:\Program Files\Eclipse Adoptium\*") do (
        echo %%d | findstr /i "jdk-17" >nul
        if not errorlevel 1 (
            if exist "%%d\bin\java.exe" (
                set JAVA_HOME=%%d
                set PATH=!JAVA_HOME!\bin;!PATH!
                echo 找到 JDK: !JAVA_HOME!
                goto :verify
            )
        )
    )
)

echo.
echo 未自动找到 JDK 17
echo.
goto :manual

:manual
echo.
echo ========================================
echo   手动输入 JDK 路径
echo ========================================
echo.
echo 请输入您的 JDK 17 安装路径
echo 例如：
echo   C:\jdk-17.0.9
echo   C:\Program Files\Eclipse Adoptium\jdk-17.0.9.101-hotspot
echo.
set /p JDK_PATH=JDK 路径: 

if "%JDK_PATH%"=="" (
    echo 路径不能为空
    pause
    exit /b 1
)

rem 去除末尾的斜杠
if "%JDK_PATH:~-1%"=="\" set JDK_PATH=%JDK_PATH:~0,-1%

if not exist "%JDK_PATH%\bin\java.exe" (
    echo.
    echo 错误：在该路径下未找到 java.exe
    echo 请检查路径是否正确
    pause
    exit /b 1
)

set JAVA_HOME=%JDK_PATH%
set PATH=%JAVA_HOME%\bin;%PATH%
echo.
echo 设置 JAVA_HOME: %JAVA_HOME%
echo.

:verify
echo ========================================
echo   验证 Java 环境
echo ========================================
echo.
java -version
if errorlevel 1 (
    echo.
    echo Java 验证失败
    pause
    exit /b 1
)
echo.
echo Java 环境正常
echo.

:build
echo ========================================
echo   开始构建 APK
echo ========================================
echo.
echo 步骤 1/3：清理旧的构建文件...
call gradlew.bat clean >nul 2>&1
echo 完成
echo.

echo 步骤 2/3：构建 Debug APK...
echo 注意：首次构建需要下载依赖，可能需要 10-20 分钟
echo 请耐心等待，不要关闭此窗口...
echo.

call gradlew.bat assembleDebug --no-daemon

if errorlevel 1 (
    echo.
    echo ========================================
    echo 构建失败
    echo ========================================
    echo.
    echo 可能的原因：
    echo 1. 网络问题 - 无法下载 Gradle 或依赖库
    echo 2. Java 版本不兼容
    echo 3. 项目配置问题
    echo.
    echo 建议尝试 GitHub Actions 在线构建（无需本地 Java）
    echo.
    pause
    exit /b 1
)

echo.
echo 步骤 3/3：检查生成的 APK...
echo.

if exist "app\build\outputs\apk\debug\app-debug.apk" (
    for %%I in ("app\build\outputs\apk\debug\app-debug.apk") do set SIZE=%%~zI
    set /a SIZE_MB=!SIZE!/1048576
    
    echo.
    echo ========================================
    echo ✅ 构建成功！
    echo ========================================
    echo.
    echo APK 文件位置：
    echo   app\build\outputs\apk\debug\app-debug.apk
    echo.
    echo 文件大小：约 !SIZE_MB! MB
    echo.
    
    choice /c YN /n /m "是否打开文件夹? (Y/N): "
    if not errorlevel 2 (
        explorer "app\build\outputs\apk\debug\"
    )
) else (
    echo 错误：未找到 APK 文件
)

echo.
echo 如何安装到手机：
echo 1. 用 USB 线连接手机到电脑
echo 2. 将 APK 文件复制到手机
echo 3. 在手机上点击 APK 安装
echo 4. 允许安装未知来源应用
echo.
pause
exit /b 0

:github
echo.
echo ========================================
echo   GitHub Actions 在线构建
echo ========================================
echo.
echo 这是无需安装 Java 的最佳方案
echo.
echo 详细步骤请查看：GitHub构建APK指南.md
echo.
echo 或访问：https://github.com/signup
echo.
pause
