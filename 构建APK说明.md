# 构建 APK 文件说明

## 系统要求检查结果

### ❌ 当前环境状态

**Java 未安装**
- 系统中未找到 Java
- 无法直接构建 APK

## 解决方案

### 方案一：使用 Android Studio（推荐）

**优点**:
- 可视化操作，简单易用
- 自动下载所需工具
- 包含模拟器和调试工具

**步骤**:

1. **下载 Android Studio**
   - 访问: https://developer.android.com/studio
   - 下载最新版本（推荐 Hedgehog 或更高）
   - 文件大小约 1GB

2. **安装 Android Studio**
   - 运行安装程序
   - 按照向导完成安装
   - 选择 "Standard" 安装类型
   - 等待下载 SDK 等组件（可能需要较长时间）

3. **打开项目**
   ```
   启动 Android Studio -> File -> Open
   选择: c:/Users/hp/WorkBuddy/Claw/BadmintonAndroid
   ```

4. **等待 Gradle 同步**
   - 首次打开会自动下载 Gradle
   - 等待进度条完成（可能需要 10-30 分钟）
   - 右下角显示 "Syncing"

5. **构建 APK**
   - Build -> Build Bundle(s) / APK(s) -> Build APK(s)
   - 等待构建完成
   - APK 位置: `app/build/outputs/apk/debug/app-debug.apk`

6. **查找 APK**
   - 构建完成后会弹窗提示
   - 点击 "locate" 按钮
   - 或手动导航到: `app/build/outputs/apk/debug/`

### 方案二：在线构建服务

如果无法安装 Android Studio，可以使用在线构建服务：

#### 1. GitHub Actions（推荐）

**步骤**:

1. **将项目上传到 GitHub**
   ```bash
   cd c:/Users/hp/WorkBuddy/Claw
   git init
   git add BadmintonAndroid
   git commit -m "Initial commit"
   git remote add origin <your-repo-url>
   git push -u origin main
   ```

2. **创建 GitHub Actions 工作流**

   在项目中创建 `.github/workflows/build.yml`:

   ```yaml
   name: Build APK

   on:
     push:
       branches: [ main ]
     pull_request:
       branches: [ main ]
     workflow_dispatch:

   jobs:
     build:
       runs-on: ubuntu-latest

       steps:
       - uses: actions/checkout@v3

       - name: Set up JDK 17
         uses: actions/setup-java@v3
         with:
           java-version: '17'
           distribution: 'temurin'

       - name: Grant execute permission for gradlew
         run: chmod +x gradlew
         working-directory: ./BadmintonAndroid

       - name: Build with Gradle
         run: ./gradlew assembleDebug
         working-directory: ./BadmintonAndroid

       - name: Upload APK
         uses: actions/upload-artifact@v3
         with:
           name: app-debug
           path: BadmintonAndroid/app/build/outputs/apk/debug/*.apk
   ```

3. **触发构建**
   - 推送代码到 GitHub
   - 在 GitHub 的 Actions 页面点击 "Run workflow"

4. **下载 APK**
   - 构建完成后在 Actions 页面下载
   - 或者作为 Release 附件

#### 2. 其他在线构建平台

- **AppCenter**: https://appcenter.ms
- **Codemagic**: https://codemagic.io
- **Bitrise**: https://bitrise.io

### 方案三：使用命令行（需安装 Java）

如果想要使用命令行，需要先安装 Java 和 Android SDK：

#### 1. 安装 JDK 17

**Windows**:
- 下载: https://adoptium.net/temurin/releases/?version=17
- 选择 Windows x64 版本
- 安装并记住安装路径

**配置环境变量**:
```cmd
setx JAVA_HOME "C:\Program Files\Eclipse Adoptium\jdk-17.x.x-hotspot"
setx PATH "%PATH%;%JAVA_HOME%\bin"
```

#### 2. 下载 Android SDK

- 下载: https://developer.android.com/studio#command-tools
- 下载 "Command line tools only"
- 解压到某个目录，如 `C:\android-sdk`

**配置环境变量**:
```cmd
setx ANDROID_HOME "C:\android-sdk"
setx PATH "%PATH%;%ANDROID_HOME\cmdline-tools\latest\bin;%ANDROID_HOME\platform-tools"
```

#### 3. 接受许可证

```cmd
cd c:/Users/hp/WorkBuddy/Claw/BadmintonAndroid
sdkmanager --licenses
```

#### 4. 构建 APK

```cmd
cd c:/Users/hp/WorkBuddy/Claw/BadmintonAndroid
gradlew.bat assembleDebug
```

## 快速构建脚本

我已经准备了以下构建脚本：

### build_apk_debug.bat

```batch
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
    pause
    exit /b 1
)
java -version
echo.

echo [2/3] 构建 Debug APK...
call gradlew.bat assembleDebug
if %errorlevel% neq 0 (
    echo [错误] 构建失败
    pause
    exit /b 1
)
echo.

echo [3/3] 构建完成！
echo.
echo APK 位置: app\build\outputs\apk\debug\app-debug.apk
echo.
echo 打开文件夹...
explorer app\build\outputs\apk\debug\

pause
```

### build_apk_release.bat

```batch
@echo off
chcp 65001 > nul
echo ========================================
echo BadmintonBooking Release APK 构建脚本
echo ========================================
echo.

cd /d "%~dp0"

echo [1/4] 检查 Java 环境...
where java >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 未找到 Java
    echo 请先安装 JDK 17: https://adoptium.net/temurin/releases/?version=17
    pause
    exit /b 1
)
java -version
echo.

echo [2/4] 检查密钥库...
if not exist "badminton-keystore.jks" (
    echo [提示] 未找到密钥库，将创建新密钥库
    keytool -genkey -v -keystore badminton-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias badminton-key
    if %errorlevel% neq 0 (
        echo [错误] 密钥库创建失败
        pause
        exit /b 1
    )
)
echo.

echo [3/4] 构建 Release APK...
call gradlew.bat assembleRelease
if %errorlevel% neq 0 (
    echo [错误] 构建失败
    pause
    exit /b 1
)
echo.

echo [4/4] 构建完成！
echo.
echo APK 位置: app\build\outputs\apk\release\app-release.apk
echo.
echo 打开文件夹...
explorer app\build\outputs\apk\release\

pause
```

## 当前项目状态

### ✅ 已完成

- 完整的 Android 项目代码
- Gradle 构建配置文件
- 所有的 UI 界面
- 数据模型和工具类
- 资源文件（图标、字符串、颜色）
- 完整的文档

### ⚠️ 缺少

- Gradle Wrapper 文件（需要 Android Studio 生成）
- 已编译的 APK 文件（需要构建生成）
- Java 运行环境（系统未安装）

## 建议

### 对于普通用户

**推荐方案**:
1. 使用 GitHub Actions 在线构建
2. 或找有 Android Studio 的朋友帮忙构建
3. 或联系开发团队获取预编译的 APK

### 对于开发者

**推荐方案**:
1. 安装 Android Studio（最佳体验）
2. 或安装 JDK 17 + Android SDK 命令行工具
3. 使用提供的构建脚本

## 项目文件清单

### 核心文件

```
BadmintonAndroid/
├── app/
│   ├── src/
│   │   └── main/
│   │       ├── java/com/badminton/booking/
│   │       │   ├── MainActivity.kt
│   │       │   ├── WebViewActivity.kt
│   │       │   ├── ui/
│   │       │   │   ├── HomeFragment.kt
│   │       │   │   ├── ConfigFragment.kt
│   │       │   │   └── StatusFragment.kt
│   │       │   ├── model/
│   │       │   │   ├── BookingConfig.kt
│   │       │   │   └── Venue.kt
│   │       │   ├── network/
│   │       │   │   └── BookingService.kt
│   │       │   └── utils/
│   │       │   │   └── ConfigManager.kt
│   │       └── res/
│   │           ├── layout/
│   │           ├── values/
│   │           ├── mipmap-*/
│   │           └── xml/
│   ├── build.gradle.kts
│   └── proguard-rules.pro
├── build.gradle.kts
├── settings.gradle.kts
├── gradle.properties
├── gradlew.bat
└── 文档文件（5个）
```

## 获取 APK 的最简单方法

1. **联系开发团队**
   - 请求提供预编译的 APK
   - 获取最新的测试版本

2. **使用 GitHub Actions**
   - 将项目上传到 GitHub
   - 启用自动构建
   - 下载构建的 APK

3. **使用在线构建平台**
   - Codemagic（免费额度）
   - AppCenter（部分免费）
   - Bitrise（免费额度）

## 下一步

如果您想要继续，请选择以下方案之一：

### 方案 A: 安装 Android Studio（推荐）
1. 下载并安装 Android Studio
2. 打开项目并构建 APK
3. 最简单和最可靠的方式

### 方案 B: 使用 GitHub Actions
1. 创建 GitHub 仓库
2. 上传项目代码
3. 配置 Actions 工作流
4. 下载构建的 APK

### 方案 C: 请求预编译的 APK
1. 联系开发团队
2. 请求最新的 APK 文件
3. 直接安装使用

---

**选择最适合您的方案！** 📱

如有任何问题，请参考相关文档或联系技术支持。
