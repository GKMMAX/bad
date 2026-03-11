# BadmintonBooking Android App

香港康文署 SmartPlay 羽毛球场自动预订程序 - Android 版本

## 项目概述

这是一个 Android 应用程序，用于自动预订香港康文署 SmartPlay 系统的羽毛球场。支持自动登录、场地选择、时段预订等功能。

## 功能特性

- ✅ 自动登录 SmartPlay 系统
- ✅ 支持 60+ 香港康文署场馆
- ✅ 可选择日期和多个时段
- ✅ 实时状态监控
- ✅ 配置保存和加载
- ✅ 日志记录和查看

## 技术栈

- **语言**: Kotlin
- **最低 SDK**: API 24 (Android 7.0)
- **目标 SDK**: API 34 (Android 14)
- **网络**: OkHttp + WebView
- **存储**: SharedPreferences
- **UI**: Material Design 3

## 项目结构

```
BadmintonAndroid/
├── app/
│   ├── src/
│   │   └── main/
│   │       ├── java/com/badminton/booking/
│   │       │   ├── MainActivity.kt         # 主Activity
│   │       │   ├── ui/
│   │       │   │   ├── HomePageFragment.kt   # 首页
│   │       │   │   ├── ConfigFragment.kt     # 配置页
│   │       │   │   └── StatusFragment.kt     # 状态页
│   │       │   ├── model/
│   │       │   │   ├── BookingConfig.kt      # 配置数据模型
│   │       │   │   └── Venue.kt              # 场馆数据模型
│   │       │   ├── network/
│   │       │   │   └── BookingService.kt     # 网络服务
│   │       │   ├── utils/
│   │       │   │   └── ConfigManager.kt      # 配置管理
│   │       │   └── WebViewActivity.kt        # WebView活动
│   │       ├── res/
│   │       │   ├── layout/
│   │       │   ├── values/
│   │       │   └── drawable/
│   │       └── AndroidManifest.xml
│   └── build.gradle.kts
├── build.gradle.kts
├── settings.gradle.kts
└── README.md
```

## 使用方法

### 开发环境要求

- Android Studio Hedgehog (2023.1.1) 或更高版本
- JDK 17
- Android SDK API 34
- Gradle 8.2

### 构建步骤

1. 克隆项目
```bash
git clone <repository-url>
cd BadmintonAndroid
```

2. 在 Android Studio 中打开项目

3. 同步 Gradle
   - 点击 "Sync Now" 或使用菜单: File -> Sync Project with Gradle Files

4. 运行应用
   - 连接 Android 设备或启动模拟器
   - 点击 Run 按钮 (Shift + F10)

### 生成 APK

1. Debug 版本
   - Build -> Build Bundle(s) / APK(s) -> Build APK(s)
   - APK 位置: `app/build/outputs/apk/debug/app-debug.apk`

2. Release 版本
   - Build -> Generate Signed Bundle / APK
   - 按照向导步骤操作
   - APK 位置: `app/build/outputs/apk/release/app-release.apk`

## 使用说明

### 首次使用

1. 打开应用
2. 进入"配置"页面
3. 填写 SmartPlay 账户信息
4. 选择场馆、日期和时段
5. 保存配置

### 开始预订

1. 进入"首页"
2. 点击"开始预订"按钮
3. 应用将自动打开 SmartPlay 网站并执行预订
4. 可在"状态"页面查看实时状态

## 注意事项

- 需要网络连接
- 需要有效的 SmartPlay 账户
- 请遵守香港康文署预订规则
- 首次使用需要完成手动登录

## 开发计划

- [x] 基础项目结构
- [ ] 用户界面实现
- [ ] 网络请求功能
- [ ] 登录自动化
- [ ] 预订逻辑
- [ ] 状态监控
- [ ] 日志系统
- [ ] 错误处理

## 许可说明

本程序仅供个人学习使用

请遵守香港康文署预订规则

## 更新记录

### v1.0.0 (开发中)
- 项目初始化
- 基础架构搭建
