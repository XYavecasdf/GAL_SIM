#!/bin/bash

# GAL-SIM Python 依赖安装脚本
# 此脚本帮助用户在首次使用应用前安装必需的 Python 依赖

set -e

echo "========================================"
echo "  GAL-SIM Python 依赖安装"
echo "========================================"
echo ""

# 检查 Python 是否安装
PYTHON_CMD=""
if command -v python3 &> /dev/null; then
    PYTHON_CMD="python3"
elif command -v python &> /dev/null; then
    PYTHON_CMD="python"
else
    echo "❌ 错误: 未找到 Python"
    echo "   请先安装 Python 3.8 或更高版本"
    echo "   访问 https://www.python.org/downloads/"
    exit 1
fi

echo "✓ 找到 Python: $($PYTHON_CMD --version)"
echo ""

# 检查 pip 是否可用
if ! $PYTHON_CMD -m pip --version &> /dev/null; then
    echo "❌ 错误: pip 未安装"
    echo "   请确保 pip 随 Python 一起安装"
    exit 1
fi

echo "✓ 找到 pip: $($PYTHON_CMD -m pip --version)"
echo ""

# 确定脚本所在目录（应用目录）
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 检查 requirements.txt 是否存在
if [ ! -f "$SCRIPT_DIR/requirements.txt" ]; then
    echo "❌ 错误: 未找到 requirements.txt 文件"
    echo "   请确保此脚本与 requirements.txt 在同一目录"
    exit 1
fi

echo "📦 开始安装 Python 依赖..."
echo "   这可能需要几分钟时间，请耐心等待"
echo ""
echo "提示: 如果遇到权限问题，可以尝试："
echo "  1. 使用管理员权限运行此脚本"
echo "  2. 或添加 --user 标志: $PYTHON_CMD -m pip install --user -r requirements.txt"
echo ""

# 安装依赖
$PYTHON_CMD -m pip install -r "$SCRIPT_DIR/requirements.txt"

if [ $? -eq 0 ]; then
    echo ""
    echo "========================================"
    echo "  ✓ 依赖安装成功!"
    echo "========================================"
    echo ""
    echo "现在您可以启动 GAL-SIM 应用了"
    echo ""
else
    echo ""
    echo "========================================"
    echo "  ❌ 依赖安装失败"
    echo "========================================"
    echo ""
    echo "请检查错误信息并重试，或手动执行："
    echo "  $PYTHON_CMD -m pip install -r requirements.txt"
    echo ""
    exit 1
fi
