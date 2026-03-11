@echo off
chcp 65001 >nul
echo ========================================
echo   羽毛球场地预订 - APK 构建工具
echo ========================================
echo.

:: 检查是否在项目目录
if not exist "app\build.gradle.kts" (
    echo ❌ 错误：请在 BadmintonAndroid 项目目录下运行此脚本
    echo.
    pause
    exit /b 1
)

:: 检查 Java
echo [1/5] 检查 Java 环境...
java -version >nul 2>&1
if errorlevel 1 (
    echo ❌ 未检测到 Java，正在尝试检测 Android Studio 的 JDK...
    if exist "C:\Program Files\Android\Android Studio\jbr\bin\java.exe" (
        set "JAVA_HOME=C:\Program Files\Android\Android Studio\jbr"
        set "PATH=%JAVA_HOME%\bin;%PATH%"
        echo ✅ 找到 Android Studio JDK
    ) else (
        echo ❌ 未检测到 Java 环境
        echo.
        echo 请选择构建方式：
        echo.
        echo [1] 使用 GitHub Actions 在线构建（推荐，无需安装工具）
        echo [2] 安装 JDK 17 本地构建
        echo [3] 使用 Android Studio 构建
        echo.
        choice /c 123 /n /m "请选择 (1/2/3): "
        if errorlevel 3 goto android_studio
        if errorlevel 2 goto install_jdk
        if errorlevel 1 goto github_build
        exit /b 1
    )
) else (
    echo ✅ Java 环境检测通过
)

:: 检查 Gradle
echo [2/5] 检查 Gradle 环境...
if not exist "gradlew.bat" (
    echo ❌ 未找到 gradlew.bat
    pause
    exit /b 1
)
echo ✅ Gradle 包装器存在

:: 清理旧的构建
echo [3/5] 清理旧的构建文件...
call gradlew.bat clean >nul 2>&1
if errorlevel 1 (
    echo ⚠️ 清理失败，继续构建...
) else (
    echo ✅ 清理完成
)

:: 构建 Debug APK
echo.
echo [4/5] 开始构建 Debug APK...
echo 这可能需要 10-20 分钟，请耐心等待...
echo.
call gradlew.bat assembleDebug --stacktrace
if errorlevel 1 (
    echo.
    echo ❌ 构建失败！
    echo.
    echo 可能的原因：
    echo 1. 网络连接问题（下载依赖失败）
    echo 2. 代码错误
    echo 3. Gradle 版本问题
    echo.
    echo 查看上方错误信息，或使用 GitHub Actions 在线构建
    echo.
    pause
    exit /b 1
)

:: 检查 APK 文件
echo [5/5] 检查生成的 APK...
if exist "app\build\outputs\apk\debug\app-debug.apk" (
    echo.
    echo ========================================
    echo ✅ 构建成功！
    echo ========================================
    echo.
    echo APK 文件位置：
    echo app\build\outputs\apk\debug\app-debug.apk
    echo.

    :: 获取文件大小
    for %%I in ("app\build\outputs\apk\debug\app-debug.apk") do set SIZE=%%~zI
    set /a SIZE_MB=%SIZE% / 1048576
    echo APK 文件大小：约 %SIZE_MB% MB
    echo.

    echo 是否打开 APK 所在文件夹？
    choice /c YN /n /m "请选择 (Y/N): "
    if errorlevel 2 goto end
    if errorlevel 1 (
        explorer app\build\outputs\apk\debug\
    )
    goto end
) else (
    echo.
    echo ❌ 未找到 APK 文件
    echo 请查看构建日志
    pause
    exit /b 1
)

:github_build
echo.
echo ========================================
echo   GitHub Actions 在线构建
echo ========================================
echo.
echo 这是无需安装任何工具的最快方法！
echo.
echo 步骤：
echo 1. 打开浏览器，访问：https://github.com/signup
echo 2. 创建免费账号（如已有则登录）
echo 3. 创建新仓库
echo 4. 将项目文件夹中的所有文件上传
echo 5. 点击 Actions 标签
echo 6. 运行 "Build Android APK" 工作流
echo 7. 等待 10-15 分钟后下载 APK
echo.
echo 详细指南：请查看 "GitHub构建APK指南.md"
echo.
pause
exit /b 0

:install_jdk
echo.
echo ========================================
echo   安装 JDK 17
echo ========================================
echo.
echo 步骤：
echo 1. 访问：https://adoptium.net/temurin/releases/?version=17
echo 2. 下载 Windows x64 版本的 JDK 17
echo 3. 运行安装程序
echo 4. 安装完成后，重新运行此脚本
echo.
echo 或查看 "快速构建APK.md" 获取详细步骤
echo.
start https://adoptium.net/temurin/releases/?version=17
pause
exit /b 0

:android_studio
echo.
echo ========================================
echo   使用 Android Studio
echo ========================================
echo.
echo 步骤：
echo 1. 下载 Android Studio：https://developer.android.com/studio
echo 2. 安装并运行
echo 3. 打开项目文件夹
echo 4. Build → Build Bundle(s) / APK(s) → Build APK(s)
echo.
echo 详细指南：请查看 "快速构建APK.md"
echo.
start https://developer.android.com/studio
pause
exit /b 0

:end
echo.
echo ========================================
echo   完成！
echo ========================================
echo.
echo 如何安装 APK 到手机：
echo.
echo 方法 1：数据线传输
echo   1. 用 USB 线连接手机到电脑
echo   2. 将 APK 文件复制到手机
echo   3. 在手机上点击 APK 文件安装
echo.
echo 方法 2：微信/QQ 传输
echo   1. 将 APK 发送到微信/QQ
echo   2. 在手机上下载并安装
echo.
echo 注意：首次安装需要允许"未知来源"应用
echo.
pause
