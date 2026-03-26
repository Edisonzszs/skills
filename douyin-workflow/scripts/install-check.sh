#!/bin/bash
# 检查抖音运营环境依赖

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"

echo "🔍 检查抖音运营环境..."
echo ""

# 检查 Python
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version 2>&1)
    echo "✅ Python: $PYTHON_VERSION"
else
    echo "❌ Python: 未安装"
    echo "   安装: apt install python3 python3-pip"
fi

# 检查 Playwright
if python3 -c "import playwright" 2>/dev/null; then
    echo "✅ Playwright: 已安装"
else
    echo "⚠️  Playwright: 未安装"
    echo "   安装: pip install playwright && playwright install chromium"
fi

# 检查浏览器
if command -v chromium-browser &> /dev/null; then
    echo "✅ Chromium: $(which chromium-browser)"
elif command -v chromium &> /dev/null; then
    echo "✅ Chromium: $(which chromium)"
else
    echo "⚠️  Chromium: 未找到"
    echo "   安装: playwright install chromium"
fi

# 检查 FFmpeg
if command -v ffmpeg &> /dev/null; then
    echo "✅ FFmpeg: $(ffmpeg -version | head -1)"
else
    echo "⚠️  FFmpeg: 未安装"
    echo "   安装: apt install ffmpeg"
fi

# 检查 OpenClaw browser 工具
if command -v openclaw &> /dev/null; then
    echo "✅ OpenClaw: $(openclaw --version 2>/dev/null || echo '已安装')"
else
    echo "⚠️  OpenClaw: 未安装"
fi

# 检查 cookies 目录
DOUYIN_DIR="$HOME/.douyin"
if [ -d "$DOUYIN_DIR" ]; then
    echo "✅ 数据目录: $DOUYIN_DIR"
else
    echo "📁 创建数据目录: $DOUYIN_DIR"
    mkdir -p "$DOUYIN_DIR"/{cookies,stats,cache}
fi

# 检查 cookies 文件
if [ -f "$DOUYIN_DIR/cookies.json" ]; then
    echo "✅ Cookies: 已存在"
else
    echo "⚠️  Cookies: 未配置"
    echo "   运行: ./get-cookie.sh 获取登录凭证"
fi

echo ""
echo "📋 环境检查完成"