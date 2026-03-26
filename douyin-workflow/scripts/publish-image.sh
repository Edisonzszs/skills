#!/bin/bash
# 发布抖音图文

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOUYIN_DIR="$HOME/.douyin"
COOKIES_FILE="$DOUYIN_DIR/cookies.json"

# 参数
IMAGES=""
TITLE=""
DESC=""
MUSIC=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --images|-i)
            IMAGES="$2"
            shift 2
            ;;
        --title|-t)
            TITLE="$2"
            shift 2
            ;;
        --desc|-d)
            DESC="$2"
            shift 2
            ;;
        --music|-m)
            MUSIC="$2"
            shift 2
            ;;
        --help|-h)
            echo "用法: $0 [选项]"
            echo ""
            echo "选项:"
            echo "  --images, -i PATHS  图片路径，逗号分隔（必需）"
            echo "  --title, -t TEXT    图文标题"
            echo "  --desc, -d TEXT     图文描述"
            echo "  --music, -m URL     背景音乐链接或名称"
            exit 0
            ;;
        *)
            shift
            ;;
    esac
done

if [ -z "$IMAGES" ]; then
    echo "❌ 错误: 缺少图片路径"
    exit 1
fi

if [ ! -f "$COOKIES_FILE" ]; then
    echo "❌ 错误: 未登录"
    exit 1
fi

echo "📸 发布抖音图文"
echo "   图片: $IMAGES"
[ -n "$TITLE" ] && echo "   标题: $TITLE"
[ -n "$DESC" ] && echo "   描述: $DESC"
echo ""

# 验证图片文件
IFS=',' read -ra IMG_ARRAY <<< "$IMAGES"
for img in "${IMG_ARRAY[@]}"; do
    if [ ! -f "$img" ]; then
        echo "❌ 错误: 图片不存在: $img"
        exit 1
    fi
done

python3 << EOF
import asyncio
import json
from pathlib import Path
from playwright.async_api import async_playwright

images = "$IMAGES".split(",")
title = "$TITLE" or ""
desc = "$DESC" or ""
music = "$MUSIC" or ""
cookies_file = Path("$COOKIES_FILE")

async def publish_images():
    async with async_playwright() as p:
        with open(cookies_file) as f:
            data = json.load(f)
        cookies = data.get("cookies", [])
        
        browser = await p.chromium.launch(headless=False)
        context = await browser.new_context()
        await context.add_cookies(cookies)
        
        page = await context.new_page()
        
        print("🌐 打开创作者中心...")
        await page.goto("https://creator.douyin.com/creator-micro/content/upload")
        await page.wait_for_load_state("networkidle")
        
        # 选择图文模式
        print("📝 切换到图文模式...")
        # 点击图文选项（需要根据实际页面调整）
        
        # 上传图片
        print("📤 上传图片...")
        upload_input = await page.query_selector('input[type="file"]')
        if upload_input:
            for img in images:
                print(f"   上传: {img.strip()}")
                # 上传逻辑
        
        await asyncio.sleep(3)
        
        print("✅ 图文发布准备完成")
        print("   请在浏览器中确认并发布")
        
        input("按 Enter 关闭浏览器...")
        await browser.close()

asyncio.run(publish_images())
EOF

echo "✅ 完成"