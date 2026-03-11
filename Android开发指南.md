# BadmintonBooking Android 开发指南

## 项目概述

这是一个 Android 应用程序，用于自动预订香港康文署 SmartPlay 系统的羽毛球场。

## 技术栈

- **语言**: Kotlin
- **最低 SDK**: API 24 (Android 7.0)
- **目标 SDK**: API 34 (Android 14)
- **UI 框架**: Material Design 3 + ViewBinding
- **网络**: OkHttp
- **并发**: Kotlin Coroutines
- **数据存储**: SharedPreferences + Gson

## 开发环境设置

### 1. 安装必要工具

- **Android Studio**: Hedgehog (2023.1.1) 或更高版本
  - 下载地址: https://developer.android.com/studio
  
- **JDK**: JDK 17 或更高版本
  - Android Studio 自带 JDK 17
  
- **Android SDK**: API 34
  - 在 Android Studio 中: Tools -> SDK Manager -> 安装 Android 14 (API 34)

### 2. 打开项目

1. 启动 Android Studio
2. 选择 "Open an Existing Project"
3. 浏览到 `BadmintonAndroid` 文件夹
4. 点击 OK

### 3. 同步 Gradle

项目打开后，Android Studio 会自动提示同步 Gradle：
- 点击 "Sync Now" 或
- 使用菜单: File -> Sync Project with Gradle Files

### 4. 配置 Gradle (可选)

如果需要修改 Gradle 设置：
- 打开 `gradle.properties`
- 修改 JVM 内存等配置

## 项目结构

```
BadmintonAndroid/
├── app/
│   ├── src/
│   │   └── main/
│   │       ├── java/com/badminton/booking/
│   │       │   ├── MainActivity.kt              # 主Activity
│   │       │   ├── WebViewActivity.kt          # WebView活动
│   │       │   ├── ui/
│   │       │   │   ├── HomeFragment.kt         # 首页Fragment
│   │       │   │   ├── ConfigFragment.kt       # 配置Fragment
│   │       │   │   └── StatusFragment.kt       # 状态Fragment
│   │       │   ├── model/
│   │       │   │   ├── BookingConfig.kt        # 配置数据模型
│   │       │   │   └── Venue.kt               # 场馆数据模型
│   │       │   ├── network/
│   │       │   │   └── BookingService.kt      # 网络服务
│   │       │   └── utils/
│   │       │   │   └── ConfigManager.kt       # 配置管理工具
│   │       ├── res/
│   │       │   ├── layout/                    # 布局文件
│   │       │   ├── values/                    # 资源值
│   │       │   ├── mipmap-*/                 # 图标资源
│   │       │   └── xml/                      # XML配置
│   │       └── AndroidManifest.xml           # 应用清单
│   ├── build.gradle.kts                      # 模块级构建文件
│   └── proguard-rules.pro                   # ProGuard规则
├── build.gradle.kts                         # 项目级构建文件
├── settings.gradle.kts                      # Gradle设置
├── gradle.properties                        # Gradle属性
└── gradlew.bat                             # Gradle包装器
```

## 主要组件说明

### 1. MainActivity (主界面)

包含三个选项卡：
- **首页** (HomeFragment): 预订控制
- **配置** (ConfigFragment): 设置账户和预订信息
- **状态** (StatusFragment): 查看系统状态和日志

### 2. HomeFragment (首页)

功能：
- 显示当前状态
- 开始/停止预订按钮
- 打开网站按钮
- 使用说明

### 3. ConfigFragment (配置页)

功能：
- 账户信息输入（用户名、密码）
- 场馆选择（60+场馆下拉菜单）
- 日期选择（日期选择器）
- 时段多选（16个时段Chip）
- 保存/加载配置

### 4. StatusFragment (状态页)

功能：
- 显示系统状态（网站地址、程序状态、浏览器状态、连接状态）
- 实时日志显示
- 清空日志按钮

### 5. WebViewActivity (WebView活动)

功能：
- 显示 SmartPlay 登录页面
- 完成/取消登录按钮
- 支持页面导航

### 6. BookingConfig (配置模型)

数据类，包含：
- username: 用户名
- password: 密码
- venue: 场馆名称
- date: 预订日期
- timeSlots: 时段列表
- bookingTime: 预订时间
- isAutoLogin: 是否自动登录

支持方法：
- `load(context)`: 从 SharedPreferences 加载配置
- `save(context, config)`: 保存配置到 SharedPreferences
- `isComplete()`: 检查配置是否完整

### 7. Venue (场馆模型)

数据类，包含：
- name: 场馆名称
- district: 所属区域
- id: 场馆ID

Venues 对象包含：
- `allVenues`: 58个香港康文署场馆列表
- `getVenueNames()`: 获取所有场馆名称
- `getVenueByName(name)`: 根据名称获取场馆
- `getVenuesByDistrict(district)`: 获取指定区域的场馆

### 8. BookingService (网络服务)

功能：
- 检查网站连接
- 获取页面内容
- 处理网络请求

## 构建应用

### Debug 版本

1. 连接 Android 设备或启动模拟器
2. 点击工具栏的 Run 按钮 (▶) 或按 Shift + F10
3. 等待编译和安装完成

### Release 版本

1. Build -> Generate Signed Bundle / APK
2. 选择 "APK"
3. 创建或选择密钥库 (keystore)
4. 填写密钥信息
5. 选择 release 构建类型
6. 点击 Finish

APK 位置: `app/build/outputs/apk/release/app-release.apk`

### 使用命令行构建

```bash
# Debug 版本
./gradlew assembleDebug

# Release 版本
./gradlew assembleRelease

# 安装到设备
./gradlew installDebug
```

## 运行应用

### 在模拟器上运行

1. Tools -> AVD Manager
2. 创建或选择一个虚拟设备
3. 点击 Run 按钮

### 在真机上运行

1. 在手机上启用开发者选项
2. 启用 USB 调试
3. 用 USB 连接手机
4. 点击 Run 按钮

## 测试

### 单元测试

测试文件位置: `app/src/test/`

```bash
# 运行单元测试
./gradlew test

# 运行特定测试类
./gradlew test --tests com.badminton.booking.BookingConfigTest
```

### UI 测试

测试文件位置: `app/src/androidTest/`

```bash
# 运行UI测试
./gradlew connectedAndroidTest
```

## 依赖管理

### 添加新依赖

在 `app/build.gradle.kts` 的 `dependencies` 块中添加：

```kotlin
implementation("com.example:library:1.0.0")
```

然后点击 "Sync Now"。

### 查看依赖

```bash
# 查看所有依赖
./gradlew dependencies
```

## 常见问题

### 1. Gradle 同步失败

**解决方案:**
- 检查网络连接
- 清理 Gradle 缓存: File -> Invalidate Caches / Restart
- 删除 `.gradle` 文件夹后重新同步

### 2. 无法找到设备

**解决方案:**
- 检查 USB 调试是否开启
- 重新连接 USB 线
- 尝试使用其他 USB 端口
- 安装设备驱动程序

### 3. 构建失败

**解决方案:**
- Clean Project: Build -> Clean Project
- 重新构建: Build -> Rebuild Project
- 检查 SDK 版本是否正确

### 4. 依赖冲突

**解决方案:**
- 在 `app/build.gradle.kts` 中排除冲突的模块
- 使用 `resolutionStrategy` 解决版本冲突

## 代码规范

### Kotlin 代码风格

- 遵循 Kotlin 官方编码规范
- 使用 KDoc 添加注释
- 变量名使用 camelCase
- 类名使用 PascalCase
- 常量使用 UPPER_SNAKE_CASE

### 资源命名

- 布局文件: `fragment_*.xml`, `activity_*.xml`
- 字符串资源: `prefix_name` (如 `btn_save`)
- 颜色资源: `category_name` (如 `primary_color`)
- 图片资源: `ic_*` (图标), `img_*` (图片)

### Git 提交规范

```
type(scope): subject

type: feat, fix, docs, style, refactor, test, chore
scope: ui, network, model, utils, etc.
subject: 简短描述

例如:
feat(ui): 添加配置页面
fix(network): 修复登录请求超时问题
docs(readme): 更新开发文档
```

## 性能优化建议

1. **减少布局层级**: 使用 ConstraintLayout 减少嵌套
2. **延迟加载**: 使用 ViewBinding 的延迟初始化
3. **内存泄漏**: 避免在 Activity/Fragment 中持有长生命周期引用
4. **网络请求**: 使用 Coroutines 进行异步操作
5. **图片优化**: 使用 WebP 格式，适当压缩

## 安全建议

1. **存储密码**: 使用 Android Keystore 或加密后存储
2. **网络安全**: 使用 HTTPS，证书固定
3. **权限**: 只申请必要的权限
4. **代码混淆**: Release 版本启用 ProGuard

## 下一步开发

### 待实现功能

1. **自动化预订**
   - 使用 JavaScript 注入自动填写表单
   - 实现自动点击预订按钮
   - 处理验证码（如果需要）

2. **定时任务**
   - 使用 AlarmManager 或 WorkManager
   - 在指定时间自动开始预订

3. **通知功能**
   - 预订成功/失败通知
   - 使用 Firebase Cloud Messaging

4. **多语言支持**
   - 添加英文资源
   - 支持系统语言切换

5. **深色模式**
   - 完善深色主题
   - 遵循系统设置

## 参考资料

- [Android Developers](https://developer.android.com/)
- [Kotlin Language](https://kotlinlang.org/docs/home.html)
- [Material Design](https://m3.material.io/)
- [OkHttp Documentation](https://square.github.io/okhttp/)
- [Android Gradle Plugin](https://developer.android.com/studio/build)

## 联系方式

如有问题或建议，请联系开发团队。

---

**版本**: v1.0.0
**最后更新**: 2026-03-10
