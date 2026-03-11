# Badminton Booking APK Build Script
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Badminton Booking - Auto Build APK" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$scriptPath = $PSScriptRoot
if (-not $scriptPath) {
    $scriptPath = Get-Location
}

Write-Host "Current directory: $scriptPath" -ForegroundColor Yellow
Write-Host ""

if (-not (Test-Path "$scriptPath\gradlew.bat")) {
    Write-Host "Error: gradlew.bat not found" -ForegroundColor Red
    Write-Host "Please run this script in BadmintonAndroid directory" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "[1/4] Checking Java environment..." -ForegroundColor Green
$javaExe = Get-Command java -ErrorAction SilentlyContinue
$javaHome = $env:JAVA_HOME

if ($javaExe) {
    Write-Host "Java found" -ForegroundColor Green
    & java -version
    Write-Host ""
} elseif ($javaHome) {
    Write-Host "Using JAVA_HOME: $javaHome" -ForegroundColor Green
    $env:PATH = "$javaHome\bin;$env:PATH"
    & java -version
    Write-Host ""
} else {
    Write-Host "Searching for JDK installation..." -ForegroundColor Yellow
    
    $jdkPaths = @(
        "C:\Program Files\Eclipse Adoptium",
        "C:\Program Files\Java",
        "C:\Program Files (x86)\Eclipse Adoptium",
        "C:\Program Files (x86)\Java"
    )
    
    $foundJdk = $false
    
    foreach ($path in $jdkPaths) {
        if (Test-Path $path) {
            $jdkFolders = Get-ChildItem -Path $path -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "*jdk-17*" -or $_.Name -like "*temurin*" }
            
            foreach ($folder in $jdkFolders) {
                $javaPath = "$($folder.FullName)\bin\java.exe"
                if (Test-Path $javaPath) {
                    $env:JAVA_HOME = $folder.FullName
                    $env:PATH = "$($folder.FullName)\bin;$env:PATH"
                    Write-Host "JDK found: $($folder.FullName)" -ForegroundColor Green
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
        Write-Host "JDK 17 not found" -ForegroundColor Red
        Write-Host "========================================" -ForegroundColor Red
        Write-Host ""
        Write-Host "Please install JDK 17: https://adoptium.net/temurin/releases/?version=17" -ForegroundColor Yellow
        Write-Host "Or set JAVA_HOME environment variable" -ForegroundColor Yellow
        Write-Host ""
        Read-Host "Press Enter to exit"
        exit 1
    }
}

Write-Host "[2/4] Cleaning old build files..." -ForegroundColor Green
Set-Location $scriptPath
& .\gradlew.bat clean 2>$null | Out-Null
Write-Host "Clean complete" -ForegroundColor Green
Write-Host ""

Write-Host "[3/4] Building Debug APK..." -ForegroundColor Green
Write-Host "This may take 10-20 minutes, please wait..." -ForegroundColor Yellow
Write-Host ""

$buildResult = & .\gradlew.bat assembleDebug --no-daemon
$exitCode = $LASTEXITCODE

if ($exitCode -ne 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "Build failed!" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Possible reasons:" -ForegroundColor Yellow
    Write-Host "1. Network connection issue" -ForegroundColor White
    Write-Host "2. Gradle configuration issue" -ForegroundColor White
    Write-Host "3. Code error" -ForegroundColor White
    Write-Host ""
    Write-Host "Try GitHub Actions online build instead:" -ForegroundColor Cyan
    Write-Host "See: GitHub构建APK指南.md" -ForegroundColor Cyan
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "[4/4] Checking generated APK..." -ForegroundColor Green
Write-Host ""

$apkPath = "$scriptPath\app\build\outputs\apk\debug\app-debug.apk"

if (Test-Path $apkPath) {
    $fileSize = (Get-Item $apkPath).Length
    $sizeMB = [math]::Round($fileSize / 1MB, 2)
    
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "APK build successful!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "APK location:" -ForegroundColor Cyan
    Write-Host "  $apkPath" -ForegroundColor White
    Write-Host ""
    Write-Host "File size: about $sizeMB MB" -ForegroundColor Cyan
    Write-Host ""
    
    $openFolder = Read-Host "Open folder? (Y/N)"
    if ($openFolder -eq "Y" -or $openFolder -eq "y") {
        explorer "app\build\outputs\apk\debug\"
    }
    
    Write-Host ""
    Write-Host "How to install on phone:" -ForegroundColor Yellow
    Write-Host "1. Connect phone to PC with USB cable" -ForegroundColor White
    Write-Host "2. Copy APK file to phone" -ForegroundColor White
    Write-Host "3. Click APK file to install" -ForegroundColor White
    Write-Host "4. Allow installation from unknown sources" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host "Error: APK file not found" -ForegroundColor Red
}

Write-Host "Done!" -ForegroundColor Green
Read-Host "Press Enter to exit"
