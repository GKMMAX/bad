@echo off
chcp 65001 >nul
echo ========================================
echo   诊断和修复构建问题
echo ========================================
echo.

rem Set JAVA_HOME
set "JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-17.0.18.8-hotspot"
set "PATH=%JAVA_HOME%\bin;%PATH%"

echo [诊断 1/6] 检查 Java 环境...
java -version
if errorlevel 1 (
    echo Java 环境异常
    pause
    exit /b 1
)
echo Java 正常
echo.

echo [诊断 2/6] 检查项目文件...
if exist "app\src\main\AndroidManifest.xml" (
    echo AndroidManifest.xml 存在
) else (
    echo 错误：AndroidManifest.xml 不存在
    pause
    exit /b 1
)
if exist "app\build.gradle.kts" (
    echo build.gradle.kts 存在
) else (
    echo 错误：build.gradle.kts 不存在
    pause
    exit /b 1
)
if exist "gradle\wrapper\gradle-wrapper.jar" (
    echo gradle-wrapper.jar 存在
) else (
    echo 错误：gradle-wrapper.jar 不存在
    pause
    exit /b 1
)
echo.

echo [诊断 3/6] 检查 build 目录...
if exist "app\build" (
    echo build 目录存在
    dir app\build /b
) else (
    echo build 目录不存在（正常，这是首次构建）
)
echo.

echo [诊断 4/6] 尝试清理...
call gradlew.bat clean --stacktrace --no-daemon
echo.

echo [诊断 5/6] 尝试构建...
echo 开始构建，这将需要 10-20 分钟...
echo 请勿关闭窗口...
echo.
call gradlew.bat assembleDebug --stacktrace --no-daemon > build.log 2>&1

if exist "build.log" (
    echo.
    echo ========================================
    echo 构建日志已保存到 build.log
    echo ========================================
    echo.
    echo 查看最后的 20 行：
    powershell -Command "Get-Content build.log -Tail 20"
)

echo.
echo [诊断 6/6] 检查生成的 APK...
if exist "app\build\outputs\apk\debug\app-debug.apk" (
    for %%I in ("app\build\outputs\apk\debug\app-debug.apk") do set SIZE=%%~zI
    set /a SIZE_MB=%SIZE% / 1048576
    echo.
    echo ========================================
    echo 成功！APK 已生成
    echo ========================================
    echo 位置：app\build\outputs\apk\debug\app-debug.apk
    echo 大小：约 %SIZE_MB% MB
    echo.

    choice /c YN /n /m "打开文件夹？(Y/N): "
    if not errorlevel 2 (
        explorer "app\build\outputs\apk\debug\"
    )
) else (
    echo.
    echo ========================================
    echo 构建失败
    echo ========================================
    echo.
    echo 完整的构建日志已保存到：build.log
    echo.
    echo 请检查 build.log 文件查看错误详情
    echo.
    echo 常见错误原因：
    echo 1. 网络问题 - 无法下载 Gradle 或依赖
    echo 2. SDK 未安装 - Android SDK 缺失
    echo 3. 配置错误 - build.gradle 配置问题
    echo.
    echo 如果问题持续，建议使用 GitHub Actions 在线构建
    echo 查看：GitHub构建APK指南.md
)

echo.
pause
