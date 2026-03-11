# BadmintonBooking Android 快速构建 APK 指南

## 前提条件

### 必需软件

1. **Android Studio**
   - 版本: Hedgehog (2023.1.1) 或更高
   - 下载: https://developer.android.com/studio

2. **JDK 17**
   - Android Studio 自带 JDK 17
   - 或单独安装 Oracle JDK 17

3. **Android SDK**
   - API 34 (Android 14)
   - 在 Android Studio 中: Tools -> SDK Manager -> 安装 Android 14

4. **Git** (可选，用于版本控制)
   - 下载: https://git-scm.com/downloads

## 项目准备

### 1. 克隆或下载项目

```bash
# 如果使用 Git
git clone <repository-url>
cd BadmintonAndroid

# 或者直接下载 ZIP 文件并解压
```

### 2. 打开项目

1. 启动 Android Studio
2. 选择 "Open an Existing Project"
3. 浏览到 `BadmintonAndroid` 文件夹
4. 点击 "OK"

### 3. 等待 Gradle 同步

- Android Studio 会自动开始同步 Gradle
- 等待进度条完成（首次可能需要几分钟）
- 如果同步失败，点击 "Try Again"

## 构建 Debug APK

### 方法一：通过 Android Studio

1. 在顶部工具栏，选择构建变体为 "debug"
2. 点击菜单: Build -> Build Bundle(s) / APK(s) -> Build APK(s)
3. 等待构建完成
4. 构建成功后会弹出提示，点击 "locate"
5. APK 位置: `app/build/outputs/apk/debug/app-debug.apk`

### 方法二：通过命令行

```bash
# Windows
gradlew.bat assembleDebug

# macOS/Linux
./gradlew assembleDebug
```

APK 位置: `app/build/outputs/apk/debug/app-debug.apk`

## 构建 Release APK

### 方法一：通过 Android Studio (推荐)

1. 创建密钥库（Keystore）

   如果已有密钥库，跳到步骤 2。

   在命令行执行：
   ```bash
   keytool -genkey -v -keystore badminton-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias badminton-key
   ```

   按提示输入：
   - 密码（至少 6 位字符）
   - 姓名、组织、城市、省份、国家代码
   - 密钥密码（可以与密钥库密码相同）

   记住所有输入的密码！

2. 在 Android Studio 中构建

   1. 点击菜单: Build -> Generate Signed Bundle / APK
   2. 选择 "APK"，点击 "Next"
   3. 选择或创建密钥库：
      - 点击 "Choose existing..." 选择已有密钥库
      - 或点击 "Create new..." 创建新密钥库
   4. 输入密钥库密码和密钥密码
   5. 选择 "release" 构建类型
   6. 点击 "Finish"
   7. 等待构建完成
   8. 构建成功后会弹出提示，点击 "locate"

   APK 位置: `app/build/outputs/apk/release/app-release.apk`

### 方法二：通过命令行

1. 创建密钥库（如果还没有）

   ```bash
   keytool -genkey -v -keystore badminton-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias badminton-key
   ```

2. 在 `app/build.gradle.kts` 中配置签名（可选）

   ```kotlin
   android {
       signingConfigs {
           create("release") {
               storeFile = file("../badminton-keystore.jks")
               storePassword = "your_store_password"
               keyAlias = "badminton-key"
               keyPassword = "your_key_password"
           }
       }
       
       buildTypes {
           release {
               signingConfig = signingConfigs.getByName("release")
           }
       }
   }
   ```

   **注意**: 不要将密码提交到代码仓库！使用环境变量或本地配置文件。

3. 构建命令

   ```bash
   # Windows
   gradlew.bat assembleRelease

   # macOS/Linux
   ./gradlew assembleRelease
   ```

## 在设备上安装

### 方法一：通过 Android Studio

1. 连接 Android 设备（确保 USB 调试已开启）
2. 点击工具栏的 Run 按钮 (▶)
3. 选择目标设备
4. 等待安装和启动

### 方法二：通过 ADB 命令

```bash
# 安装 APK
adb install app-debug.apk

# 或覆盖安装
adb install -r app-debug.apk
```

### 方法三：手动安装

1. 将 APK 文件传输到 Android 设备
2. 在设备上找到 APK 文件
3. 点击安装
4. 如果提示"允许安装未知来源应用"，请允许

## 构建变体说明

### Debug APK

- **用途**: 开发和测试
- **大小**: 较大（包含调试信息）
- **签名**: 使用默认 debug 密钥
- **性能**: 未优化
- **可安装**: 所有设备

### Release APK

- **用途**: 发布和分发
- **大小**: 较小（已优化）
- **签名**: 使用自定义密钥
- **性能**: 已优化
- **可安装**: 所有设备

## 常见问题

### 1. Gradle 同步失败

**解决方案:**

```bash
# 清理 Gradle 缓存
./gradlew clean

# 或在 Android Studio 中
File -> Invalidate Caches -> Invalidate and Restart
```

### 2. 找不到 Android SDK

**解决方案:**

1. File -> Project Structure -> SDK Location
2. 设置 Android SDK 位置
3. 点击 Apply

### 3. 构建时出现 "License not accepted" 错误

**解决方案:**

```bash
# 接受所有 SDK 许可
./gradlew --stacktrace
```

或在 Android Studio 中:
1. Tools -> SDK Manager
2. 勾选 "Android SDK Platform-Tools"
3. 点击 "Accept License"
4. 点击 "Install"

### 4. 构建超时

**解决方案:**

在 `gradle.properties` 中增加内存：
```properties
org.gradle.jvmargs=-Xmx4096m -Dfile.encoding=UTF-8
```

### 5. 密钥库密码忘记

**解决方案:**

如果忘记密钥库密码，需要重新创建密钥库并重新签名 APK。新密钥签名的 APK 需要卸载旧版本才能安装。

### 6. APK 安装失败

**可能原因:**
- 应用已安装，签名不匹配
- 设备存储空间不足
- Android 版本过低

**解决方案:**
- 卸载旧版本后重新安装
- 清理设备存储空间
- 确认设备 Android 版本 >= 7.0

## 优化构建

### 减小 APK 大小

在 `app/build.gradle.kts` 中启用代码压缩：

```kotlin
android {
    buildTypes {
        release {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}
```

### 加速构建

在 `gradle.properties` 中配置：

```properties
org.gradle.parallel=true
org.gradle.caching=true
org.gradle.configureondemand=true
```

### 使用构建缓存

```bash
# 清理构建缓存
./gradlew cleanBuildCache

# 禁用构建缓存
./gradlew build --no-build-cache
```

## 版本管理

### 更新版本号

在 `app/build.gradle.kts` 中修改：

```kotlin
defaultConfig {
    versionCode = 2  // 每次发布增加
    versionName = "1.0.1"  // 用户可见的版本
}
```

### 生成版本信息

```bash
# 查看当前版本
./gradlew :app:dependencies
```

## 分发 APK

### 上传到应用商店

1. 使用 Release APK 或 App Bundle (AAB)
2. 签名必须一致
3. 遵循应用商店的发布流程

### 直接分享

1. 将 APK 文件上传到文件分享服务
2. 分享下载链接
3. 用户下载后手动安装

### 内部分发

使用 Android App Bundle：
1. Build -> Generate Signed Bundle / APK
2. 选择 "Android App Bundle"
3. 构建 .aab 文件
4. 上传到 Google Play Console 或其他分发平台

## 检查构建结果

### 查看构建信息

```bash
# 查看任务
./gradlew tasks

# 查看依赖
./gradlew dependencies

# 查看项目属性
./gradlew properties
```

### 验证 APK

使用 `aapt` 工具：

```bash
# 查看 APK 信息
aapt dump badging app-release.apk

# 查看 APK 内容
aapt list app-release.apk
```

## 参考资源

- [Android 官方文档](https://developer.android.com/studio/build)
- [Gradle 用户指南](https://docs.gradle.org/current/userguide/userguide.html)
- [APK 签名最佳实践](https://developer.android.com/studio/publish/app-signing)

## 技术支持

如遇到问题：
1. 查看错误日志
2. 检查环境配置
3. 参考 Android 官方文档
4. 联系技术支持

---

**祝构建顺利！🚀**
