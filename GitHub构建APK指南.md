# GitHub Actions 在线构建 APK 指南

## 📌 概述

使用 GitHub Actions 在线构建 APK，无需本地安装 Android Studio 或 JDK。

**优点**：
- ✅ 完全免费
- ✅ 无需本地安装工具
- ✅ 自动化构建
- ✅ 10-15 分钟完成

## 🚀 快速开始（5分钟）

### 步骤 1：注册 GitHub 账号

1. 访问：https://github.com/signup
2. 创建免费账号
3. 验证邮箱

### 步骤 2：创建新仓库

1. 登录 GitHub
2. 点击右上角 "+" → "New repository"
3. 仓库名称：`BadmintonAndroid`
4. 选择 "Public" 或 "Private"
5. 点击 "Create repository"

### 步骤 3：上传项目文件

**方法 A：使用 GitHub Web 界面（最简单）**

1. 在新仓库页面，点击 "uploading an existing file"
2. 将 `BadmintonAndroid` 文件夹中的所有文件拖拽到浏览器
3. 填写提交信息：`Initial commit`
4. 点击 "Commit changes"

**方法 B：使用 Git 命令行**

```bash
# 打开项目文件夹
cd c:/Users/hp/WorkBuddy/Claw/BadmintonAndroid

# 初始化 Git 仓库
git init

# 添加所有文件
git add .

# 提交
git commit -m "Initial commit"

# 关联远程仓库（替换 YOUR_USERNAME）
git remote add origin https://github.com/YOUR_USERNAME/BadmintonAndroid.git

# 推送到 GitHub
git branch -M main
git push -u origin main
```

### 步骤 4：触发构建

1. 在 GitHub 仓库页面，点击 "Actions" 标签
2. 选择 "Build Android APK" 工作流
3. 点击 "Run workflow"
4. 选择 "debug" 或 "release"
5. 点击 "Run workflow" 按钮

### 步骤 5：下载 APK

1. 等待构建完成（约 10-15 分钟）
2. 构建完成后，进入 "Actions" 页面
3. 点击最新的构建记录
4. 在页面底部找到 "Artifacts" 部分
5. 点击 `app-debug.apk` 或 `app-release.apk` 下载

## 📦 APK 文件说明

### Debug APK
- 文件名：`app-debug.apk`
- 大小：约 15-25 MB
- 签名：使用 debug 密钥签名
- 适用：测试和开发

### Release APK
- 文件名：`app-release.apk`
- 大小：约 10-20 MB
- 签名：需要配置 release 密钥
- 适用：正式发布

**注意**：当前配置只支持 debug 构建。如需 release 构建，需要配置签名密钥。

## 🎯 自动构建（可选）

配置 GitHub 自动构建，每次推送代码时自动生成 APK。

### 启用自动构建

修改 `.github/workflows/build-apk.yml`，将触发条件改为：

```yaml
on:
  push:
    branches: [ main ]
  workflow_dispatch:
    inputs:
      build_type:
        description: 'Build type'
        required: true
        default: 'debug'
        type: choice
        options:
        - debug
        - release
```

现在每次推送代码到 main 分支，都会自动构建 Debug APK。

## 🔧 故障排除

### 构建失败

1. 检查构建日志：Actions → 构建记录 → 点击查看详情
2. 常见问题：
   - 代码错误：修复代码后重新推送
   - 依赖问题：检查 `build.gradle.kts` 中的依赖版本

### 下载失败

1. 确保 Artifact 还未过期（90天）
2. 重新运行构建生成新的 APK

## 📱 安装 APK

### 在 Android 手机上安装

1. 将 APK 传输到手机
2. 点击 APK 文件
3. 允许安装未知来源应用
4. 完成安装

### 使用 ADB 安装

```bash
# 连接手机并启用 USB 调试
adb install app-debug.apk
```

## ⚡ 快速参考

| 操作 | 时间 |
|------|------|
| 注册 GitHub | 2 分钟 |
| 创建仓库 | 1 分钟 |
| 上传项目 | 2 分钟 |
| 触发构建 | 30 秒 |
| 等待构建 | 10-15 分钟 |
| 下载 APK | 1 分钟 |
| **总计** | **15-20 分钟** |

## 📚 相关文档

- GitHub Actions 文档：https://docs.github.com/en/actions
- GitHub 上传文件指南：https://docs.github.com/en/repositories/working-with-files/managing-files

## 🎉 完成！

恭喜！您现在已经拥有一个可以在 Android 设备上安装的 APK 文件了！

---

**需要帮助？** 查看 Actions 构建日志获取详细信息。
