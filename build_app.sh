#!/bin/bash

# GAL-SIM 桌面应用构建脚本
# 此脚本帮助自动化构建流程

set -e

echo "========================================"
echo "  GAL-SIM 桌面应用构建脚本"
echo "========================================"
echo ""

# 检查 Node.js 是否安装
if ! command -v node &> /dev/null; then
    echo "❌ 错误: Node.js 未安装"
    echo "   请访问 https://nodejs.org/ 下载并安装 Node.js"
    exit 1
fi

echo "✓ Node.js 版本: $(node --version)"

# 检查 npm 是否安装
if ! command -v npm &> /dev/null; then
    echo "❌ 错误: npm 未安装"
    echo "   请确保 npm 随 Node.js 一起安装"
    exit 1
fi

echo "✓ npm 版本: $(npm --version)"

# 检查 Python 是否安装
if ! command -v python3 &> /dev/null && ! command -v python &> /dev/null; then
    echo "❌ 错误: Python 未安装"
    echo "   请访问 https://www.python.org/ 下载并安装 Python 3.8+"
    exit 1
fi

PYTHON_CMD="python3"
if ! command -v python3 &> /dev/null; then
    PYTHON_CMD="python"
fi

echo "✓ Python 版本: $($PYTHON_CMD --version)"
echo ""

# 进入 electron 目录
cd electron

# 安装依赖
echo "📦 安装 Electron 依赖..."
npm install

echo ""
echo "========================================"
echo "  准备构建"
echo "========================================"
echo ""
echo "选择构建目标:"
echo "  1) 当前平台 (推荐)"
echo "  2) Windows (NSIS + Portable)"
echo "  3) macOS (DMG)"
echo "  4) Linux (AppImage + deb)"
echo "  5) 所有平台"
echo "  6) 仅测试构建 (不打包)"
echo ""
read -p "请输入选项 [1-6]: " choice

case $choice in
    1)
        echo ""
        echo "🚀 构建当前平台版本..."
        npm run dist
        ;;
    2)
        echo ""
        echo "🚀 构建 Windows 版本..."
        npm run dist:win
        ;;
    3)
        echo ""
        echo "🚀 构建 macOS 版本..."
        npm run dist:mac
        ;;
    4)
        echo ""
        echo "🚀 构建 Linux 版本..."
        npm run dist:linux
        ;;
    5)
        echo ""
        echo "🚀 构建所有平台版本..."
        npm run dist:all
        ;;
    6)
        echo ""
        echo "🚀 测试构建..."
        npm run build
        ;;
    *)
        echo "❌ 无效选项"
        exit 1
        ;;
esac

echo ""
echo "========================================"
echo "  构建完成!"
echo "========================================"
echo ""
echo "📦 构建产物位于: electron/dist/"
echo ""

if [ -d "dist" ]; then
    echo "生成的文件:"
    ls -lh dist/ | grep -v "^total" | grep -v "^d"
fi

echo ""
echo "✓ 构建成功完成"
echo ""
