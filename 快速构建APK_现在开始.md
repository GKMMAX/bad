# 🚀 立即构建 APK - 快速指南

## 📌 当前状态

检测到您已安装 JDK 17，但 **JAVA_HOME 环境变量未设置**。

## ✅ 解决方案（3种方法，任选其一）

---

## 方法一：临时设置环境变量后构建（推荐，2分钟）

### 步骤：

1. **找到 JDK 安装路径**
   - 打开文件资源管理器
   - 进入 `C:\Program Files\`
   - 查找包含 `jdk-17` 或 `Eclipse` 的文件夹
   - 例如：`C:\Program Files\Eclipse Adoptium\jdk-17.0.9.101-hotspot`

2. **打开命令提示符**
   - 按 `Win + R`
   - 输入 `cmd` 并回车

3. **切换到项目目录**
   ```cmd
   cd C:\Users\hp\WorkBuddy\Claw\BadmintonAndroid
   ```

4. **临时设置 JAVA_HOME**（将路径替换为您的 JDK 路径）
   ```cmd
   set JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-17.0.9.101-hotspot
   set PATH=%JAVA_HOME%\bin;%PATH%
   ```

5. **验证 Java**
   ```cmd
   java -version
   ```
   应该显示 `openjdk version "17.x.x"`

6. **构建 APK**
   ```cmd
   gradlew.bat assembleDebug
   ```

7. **等待完成**（10-20 分钟）

8. **找到 APK**
   ```
   app\build\outputs\apk\debug\app-debug.apk
   ```

---

## 方法二：使用交互式脚本（最简单）

直接双击运行项目中的以下文件：

```
C:\Users\hp\WorkBuddy\Claw\BadmintonAndroid\立即构建APK.bat
```

脚本会：
1. 自动搜索 JDK
2. 如果找不到，提示您输入路径
3. 自动设置环境变量
4. 开始构建

---

## 方法三：永久设置环境变量

### 步骤：

1. **打开系统属性**
   - 右键"此电脑" → "属性"
   - 点击"高级系统设置"
   - 点击"环境变量"

2. **添加 JAVA_HOME**
   - 在"系统变量"区域，点击"新建"
   - 变量名：`JAVA_HOME`
   - 变量值：您的 JDK 安装路径
     例如：`C:\Program Files\Eclipse Adoptium\jdk-17.0.9.101-hotspot`
   - 点击"确定"

3. **修改 Path**
   - 找到"系统变量"中的 `Path`
   - 点击"编辑"
   - 点击"新建"
   - 输入：`%JAVA_HOME%\bin`
   - 点击"确定"保存所有设置

4. **重启命令提示符**

5. **验证**
   ```cmd
   java -version
   ```

6. **构建**
   ```cmd
   cd C:\Users\hp\WorkBuddy\Claw\BadmintonAndroid
   gradlew.bat assembleDebug
   ```

---

## 🔍 如何找到 JDK 路径

### 方法 A：搜索文件
1. 打开文件资源管理器
2. 进入 `C:\Program Files\`
3. 在右上角搜索框输入 `java.exe`
4. 找到路径为 `jdk-17.x.x\bin\java.exe` 的文件
5. JDK 路径就是该文件所在的上两级目录

### 方法 B：控制面板
1. 打开"控制面板" → "程序和功能"
2. 查找 Java SE Development Kit 或 Eclipse Adoptium
3. 右键点击 → "更改" → 可以看到安装路径

---

## 📦 构建完成后

### APK 位置
```
C:\Users\hp\WorkBuddy\Claw\BadmintonAndroid\app\build\outputs\apk\debug\app-debug.apk
```

### APK 大小
约 15-25 MB

### 安装到手机
1. 用 USB 线连接手机
2. 复制 APK 到手机
3. 点击安装
4. 允许"未知来源"应用

---

## ⚠️ 常见问题

### Q: 找不到 java.exe
A: 确认 JDK 已正确安装。如果未安装，访问：
https://adoptium.net/temurin/releases/?version=17

### Q: java -version 报错
A: 检查 JAVA_HOME 路径是否正确，路径中不应包含 `bin`

### Q: gradlew.bat 报错
A: 首次运行需要下载依赖，确保网络连接正常

### Q: 构建超时
A: 网络问题，尝试：
- 使用手机热点
- 配置代理（如果在国内）
- 使用 GitHub Actions 在线构建

---

## 🎯 推荐

**如果您现在就想获得 APK，最快的方法：**

1. **方法二**（最简单）：双击 `立即构建APK.bat`
2. **方法一**（直接）：使用命令行临时设置环境变量

**预计时间**：15-20 分钟

---

## 📞 需要帮助？

- 查看 `GitHub构建APK指南.md` 使用在线构建
- 查看 `快速构建APK.md` 获取详细步骤

---

## 🚀 立即开始

**推荐方式**：双击运行
```
C:\Users\hp\WorkBuddy\Claw\BadmintonAndroid\立即构建APK.bat
```

或手动执行命令（临时设置环境变量）：
```cmd
set JAVA_HOME=您的JDK路径
set PATH=%JAVA_HOME%\bin;%PATH%
cd C:\Users\hp\WorkBuddy\Claw\BadmintonAndroid
gradlew.bat assembleDebug
```
