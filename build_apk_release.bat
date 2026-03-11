@echo off
chcp 65001 > nul
echo ========================================
echo BadmintonBooking Release APK 构建脚本
echo ========================================
echo.

cd /d "%~dp0"

echo [1/5] 检查 Java 环境...
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

echo [2/5] 检查密钥库...
if not exist "badminton-keystore.jks" (
    echo [提示] 未找到密钥库，将创建新密钥库
    echo.
    echo 请按照提示输入密钥库信息:
    echo - 密码（至少6位字符）
    echo - 姓名、组织、城市、省份、国家代码（如 CN）
    echo - 密钥密码（可以与密钥库密码相同）
    echo.
    keytool -genkey -v -keystore badminton-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias badminton-key
    if %errorlevel% neq 0 (
        echo.
        echo [错误] 密钥库创建失败
        pause
        exit /b 1
    )
    echo.
    echo [✓] 密钥库创建成功
) else (
    echo [✓] 已找到密钥库
)
echo.

echo [3/5] 检查构建配置...
if not exist "app\build.gradle.kts" (
    echo [错误] 未找到 build.gradle.kts
    pause
    exit /b 1
)
echo [✓] 构建配置文件存在
echo.

echo [4/5] 构建 Release APK...
echo 这可能需要几分钟，请耐心等待...
echo.
call gradlew.bat assembleRelease
if %errorlevel% neq 0 (
    echo.
    echo [错误] 构建失败
    echo 请检查错误信息并重试
    pause
    exit /b 1
)
echo.

echo [5/5] 构建完成！
echo.
echo ========================================
echo APK 位置:
echo app\build\outputs\apk\release\app-release.apk
echo ========================================
echo.
if exist "app\build\outputs\apk\release\app-release.apk" (
    echo 打开文件夹...
    explorer app\build\outputs\apk\release\
    
    echo.
    echo APK 文件信息:
    dir "app\build\outputs\apk\release\app-release.apk" | find "app-release.apk"
) else (
    echo [警告] 未找到 APK 文件
)

echo.
echo 按任意键退出...
pause >nul
