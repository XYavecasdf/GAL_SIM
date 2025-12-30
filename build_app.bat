@echo off
REM GAL-SIM 桌面应用构建脚本 (Windows)
REM 此脚本帮助自动化构建流程

setlocal enabledelayedexpansion

echo ========================================
echo   GAL-SIM 桌面应用构建脚本
echo ========================================
echo.

REM 检查 Node.js 是否安装
where node >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 错误: Node.js 未安装
    echo    请访问 https://nodejs.org/ 下载并安装 Node.js
    pause
    exit /b 1
)

for /f "tokens=*" %%i in ('node --version') do set NODE_VERSION=%%i
echo ✓ Node.js 版本: %NODE_VERSION%

REM 检查 npm 是否安装
where npm >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 错误: npm 未安装
    echo    请确保 npm 随 Node.js 一起安装
    pause
    exit /b 1
)

for /f "tokens=*" %%i in ('npm --version') do set NPM_VERSION=%%i
echo ✓ npm 版本: %NPM_VERSION%

REM 检查 Python 是否安装
where python >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 错误: Python 未安装
    echo    请访问 https://www.python.org/ 下载并安装 Python 3.8+
    pause
    exit /b 1
)

for /f "tokens=*" %%i in ('python --version') do set PYTHON_VERSION=%%i
echo ✓ Python 版本: %PYTHON_VERSION%
echo.

REM 进入 electron 目录
cd electron

REM 安装依赖
echo 📦 安装 Electron 依赖...
call npm install

echo.
echo ========================================
echo   准备构建
echo ========================================
echo.
echo 选择构建目标:
echo   1) 当前平台 (Windows, 推荐)
echo   2) Windows (NSIS + Portable)
echo   3) macOS (DMG)
echo   4) Linux (AppImage + deb)
echo   5) 所有平台
echo   6) 仅测试构建 (不打包)
echo.
set /p choice="请输入选项 [1-6]: "

if "%choice%"=="1" (
    echo.
    echo 🚀 构建当前平台版本...
    call npm run dist
) else if "%choice%"=="2" (
    echo.
    echo 🚀 构建 Windows 版本...
    call npm run dist:win
) else if "%choice%"=="3" (
    echo.
    echo 🚀 构建 macOS 版本...
    call npm run dist:mac
) else if "%choice%"=="4" (
    echo.
    echo 🚀 构建 Linux 版本...
    call npm run dist:linux
) else if "%choice%"=="5" (
    echo.
    echo 🚀 构建所有平台版本...
    call npm run dist:all
) else if "%choice%"=="6" (
    echo.
    echo 🚀 测试构建...
    call npm run build
) else (
    echo ❌ 无效选项
    pause
    exit /b 1
)

echo.
echo ========================================
echo   构建完成!
echo ========================================
echo.
echo 📦 构建产物位于: electron\dist\
echo.

if exist "dist" (
    echo 生成的文件:
    dir /b dist\*.exe dist\*.dmg dist\*.AppImage dist\*.deb 2>nul
)

echo.
echo ✓ 构建成功完成
echo.
pause
