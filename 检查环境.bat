@echo off
chcp 65001 > nul
echo ========================================
echo BadmintonBooking 环境检查工具
echo ========================================
echo.

echo [1/5] 检查 Java...
where java >nul 2>&1
if %errorlevel% equ 0 (
    echo [✓] Java 已安装
    java -version 2>&1 | findstr "version"
) else (
    echo [✗] Java 未安装
    echo     请安装 JDK 17: https://adoptium.net/temurin/releases/?version=17
)
echo.

echo [2/5] 检查 Gradle...
if exist "gradlew.bat" (
    echo [✓] Gradle Wrapper 存在
) else (
    echo [✗] Gradle Wrapper 不存在
)
echo.

echo [3/5] 检查项目结构...
if exist "app\build.gradle.kts" (
    echo [✓] 模块构建文件存在
) else (
    echo [✗] 模块构建文件不存在
)

if exist "app\src\main" (
    echo [✓] 源代码目录存在
) else (
    echo [✗] 源代码目录不存在
)

if exist "app\src\main\AndroidManifest.xml" (
    echo [✓] AndroidManifest.xml 存在
) else (
    echo [✗] AndroidManifest.xml 不存在
)
echo.

echo [4/5] 检查资源文件...
set /a resource_count=0
if exist "app\src\main\res\values\strings.xml" (
    echo [✓] strings.xml 存在
    set /a resource_count+=1
) else (
    echo [✗] strings.xml 不存在
)

if exist "app\src\main\res\values\colors.xml" (
    echo [✓] colors.xml 存在
    set /a resource_count+=1
) else (
    echo [✗] colors.xml 不存在
)

if exist "app\src\main\res\layout\activity_main.xml" (
    echo [✓] layout 文件存在
    set /a resource_count+=1
) else (
    echo [✗] layout 文件不存在
)
echo.

echo [5/5] 检查 Kotlin 源文件...
set /a kotlin_count=0
if exist "app\src\main\java\com\badminton\booking\MainActivity.kt" (
    set /a kotlin_count+=1
)
if exist "app\src\main\java\com\badminton\booking\WebViewActivity.kt" (
    set /a kotlin_count+=1
)
if exist "app\src\main\java\com\badminton\booking\ui\HomeFragment.kt" (
    set /a kotlin_count+=1
)
if exist "app\src\main\java\com\badminton\booking\ui\ConfigFragment.kt" (
    set /a kotlin_count+=1
)
if exist "app\src\main\java\com\badminton\booking\ui\StatusFragment.kt" (
    set /a kotlin_count+=1
)
echo [✓] 找到 %kotlin_count% 个 Kotlin 源文件
echo.

echo ========================================
echo 检查总结
echo ========================================

where java >nul 2>&1
if %errorlevel% equ 0 (
    echo [状态] 可以使用命令行构建
    echo.
    echo 运行以下命令构建 Debug APK:
    echo   build_apk_debug.bat
    echo.
    echo 或运行以下命令构建 Release APK:
    echo   build_apk_release.bat
) else (
    echo [状态] 无法使用命令行构建
    echo.
    echo 请选择以下方案之一:
    echo.
    echo [方案 A] 安装 Android Studio（推荐）
    echo   1. 下载: https://developer.android.com/studio
    echo   2. 安装并打开此项目
    echo   3. Build -^> Build Bundle(s) / APK(s) -^> Build APK(s)
    echo.
    echo [方案 B] 安装 JDK 17
    echo   1. 下载: https://adoptium.net/temurin/releases/?version=17
    echo   2. 安装并配置环境变量
    echo   3. 运行 build_apk_debug.bat
    echo.
    echo [方案 C] 使用在线构建服务
    echo   1. 将项目上传到 GitHub
    echo   2. 使用 GitHub Actions 自动构建
    echo   3. 下载构建的 APK
)
echo.

echo 详细说明请查看: 构建APK说明.md
echo.

pause
