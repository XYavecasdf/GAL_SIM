@echo off
REM GAL-SIM Python 依赖安装脚本 (Windows)
REM 此脚本帮助用户在首次使用应用前安装必需的 Python 依赖

setlocal enabledelayedexpansion

echo ========================================
echo   GAL-SIM Python 依赖安装
echo ========================================
echo.

REM 检查 Python 是否安装
where python >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 错误: 未找到 Python
    echo    请先安装 Python 3.8 或更高版本
    echo    访问 https://www.python.org/downloads/
    pause
    exit /b 1
)

for /f "tokens=*" %%i in ('python --version') do set PYTHON_VERSION=%%i
echo ✓ 找到 Python: %PYTHON_VERSION%
echo.

REM 检查 pip 是否可用
python -m pip --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 错误: pip 未安装
    echo    请确保 pip 随 Python 一起安装
    pause
    exit /b 1
)

for /f "tokens=*" %%i in ('python -m pip --version') do set PIP_VERSION=%%i
echo ✓ 找到 pip: %PIP_VERSION%
echo.

REM 检查 requirements.txt 是否存在
if not exist "%~dp0requirements.txt" (
    echo ❌ 错误: 未找到 requirements.txt 文件
    echo    请确保此脚本与 requirements.txt 在同一目录
    pause
    exit /b 1
)

echo 📦 开始安装 Python 依赖...
echo    这可能需要几分钟时间，请耐心等待
echo.
echo 提示: 如果遇到权限问题，可以尝试：
echo   1. 以管理员身份运行此脚本
echo   2. 或添加 --user 标志: python -m pip install --user -r requirements.txt
echo.

REM 安装依赖
python -m pip install -r "%~dp0requirements.txt"

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo   ✓ 依赖安装成功!
    echo ========================================
    echo.
    echo 现在您可以启动 GAL-SIM 应用了
    echo.
) else (
    echo.
    echo ========================================
    echo   ❌ 依赖安装失败
    echo ========================================
    echo.
    echo 请检查错误信息并重试，或手动执行：
    echo   python -m pip install -r requirements.txt
    echo.
)

pause
