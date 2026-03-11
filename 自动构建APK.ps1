# 羽毛球场地预订 APK 构建脚本
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  羽毛球场地预订 - 自动构建 APK" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查当前目录
$scriptPath = $PSScriptRoot
if (-not $scriptPath) {
    $scriptPath = Get-Location
}

Write-Host "当前目录: $scriptPath" -ForegroundColor Yellow
Write-Host ""

# 检查 gradlew.bat
if (-not (Test-Path "$scriptPath\gradlew.bat")) {
    Write-Host "错误：未找到 gradlew.bat" -ForegroundColor Red
    Write-Host "请在 BadmintonAndroid 项目目录下运行此脚本" -ForegroundColor Red
    Read-Host "按回车键退出"
    exit 1
}

# 检查 Java
Write-Host "[1/4] 检查 Java 环境..." -ForegroundColor Green
$javaExe = Get-Command java -ErrorAction SilentlyContinue
$javaHome = $env:JAVA_HOME

if ($javaExe) {
    Write-Host "✅ 找到 Java" -ForegroundColor Green
    & java -version
    Write-Host ""
} elseif ($javaHome) {
    Write-Host "✅ 使用 JAVA_HOME: $javaHome" -ForegroundColor Green
    $env:PATH = "$javaHome\bin;$env:PATH"
    & java -version
    Write-Host ""
} else {
    # 搜索 JDK
    Write-Host "正在搜索 JDK 安装..." -ForegroundColor Yellow
    
    $jdkPaths = @(
        "C:\Program Files\Eclipse Adoptium",
        "C:\Program Files\Java",
        "C:\Program Files (x86)\Eclipse Adoptium",
        "C:\Program Files (x86)\Java"
    )
    
    $foundJdk = $false
    
    foreach ($path in $jdkPaths) {
        if (Test-Path $path) {
            $jdkFolders = Get-ChildItem -Path $path -Directory | Where-Object { $_.Name -like "*jdk-17*" -or $_.Name -like "*temurin*" }
            
            foreach ($folder in $jdkFolders) {
                $javaPath = "$($folder.FullName)\bin\java.exe"
                if (Test-Path $javaPath) {
                    $env:JAVA_HOME = $folder.FullName
                    $env:PATH = "$($folder.FullName)\bin;$env:PATH"
                    Write-Host "✅ 找到 JDK: $($folder.FullName)" -ForegroundColor Green
                    & java -version
                    $foundJdk = $true
                    break
                }
            }
        }
        if ($foundJdk) { break }
    }
    
    if (-not $foundJdk) {
        Write-Host ""
        Write-Host "========================================" -ForegroundColor Red
        Write-Host "未找到 JDK 17" -ForegroundColor Red
        Write-Host "========================================" -ForegroundColor Red
        Write-Host ""
        Write-Host "请先安装 JDK 17: https://adoptium.net/temurin/releases/?version=17" -ForegroundColor Yellow
        Write-Host "或手动设置 JAVA_HOME 环境变量" -ForegroundColor Yellow
        Write-Host ""
        Read-Host "按回车键退出"
        exit 1
    }
}

# 清理旧的构建
Write-Host "[2/4] 清理旧的构建文件..." -ForegroundColor Green
Set-Location $scriptPath
& .\gradlew.bat clean 2>$null | Out-Null
Write-Host "✅ 清理完成" -ForegroundColor Green
Write-Host ""

# 构建 APK
Write-Host "[3/4] 开始构建 Debug APK..." -ForegroundColor Green
Write-Host "这可能需要 10-20 分钟，请耐心等待..." -ForegroundColor Yellow
Write-Host ""

$buildResult = & .\gradlew.bat assembleDebug --no-daemon
$exitCode = $LASTEXITCODE

if ($exitCode -ne 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "构建失败！" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "可能的原因：" -ForegroundColor Yellow
    Write-Host "1. 网络连接问题（下载依赖失败）" -ForegroundColor White
    Write-Host "2. Gradle 配置问题" -ForegroundColor White
    Write-Host "3. 代码错误" -ForegroundColor White
    Write-Host ""
    Write-Host "建议使用 GitHub Actions 在线构建：" -ForegroundColor Cyan
    Write-Host "查看: GitHub构建APK指南.md" -ForegroundColor Cyan
    Write-Host ""
    Read-Host "按回车键退出"
    exit 1
}

# 检查 APK
Write-Host "[4/4] 检查生成的 APK..." -ForegroundColor Green
Write-Host ""

$apkPath = "$scriptPath\app\build\outputs\apk\debug\app-debug.apk"

if (Test-Path $apkPath) {
    $fileSize = (Get-Item $apkPath).Length
    $sizeMB = [math]::Round($fileSize / 1MB, 2)
    
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "✅ APK 构建成功！" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "文件位置：" -ForegroundColor Cyan
    Write-Host "  $apkPath" -ForegroundColor White
    Write-Host ""
    Write-Host "文件大小：约 $sizeMB MB" -ForegroundColor Cyan
    Write-Host ""
    
    $openFolder = Read-Host "是否打开文件夹？(Y/N)"
    if ($openFolder -eq "Y" -or $openFolder -eq "y") {
        explorer "app\build\outputs\apk\debug\"
    }
    
    Write-Host ""
    Write-Host "如何安装到手机：" -ForegroundColor Yellow
    Write-Host "1. 用 USB 线连接手机到电脑" -ForegroundColor White
    Write-Host "2. 将 APK 文件复制到手机" -ForegroundColor White
    Write-Host "3. 在手机上点击 APK 文件安装" -ForegroundColor White
    Write-Host "4. 允许安装未知来源应用" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host "错误：未找到 APK 文件" -ForegroundColor Red
}

Write-Host "完成！" -ForegroundColor Green
Read-Host "按回车键退出"
