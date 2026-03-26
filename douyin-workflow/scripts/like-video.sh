#!/bin/bash
# 点赞抖音视频

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOUYIN_DIR="$HOME/.douyin"
COOKIES_FILE="$DOUYIN_DIR/cookies.json"

VIDEO_ID=""
ACTION="like"

while [[ $# -gt 0 ]]; do
    case $1 in
        --unlike)
            ACTION="unlike"
            shift
            ;;
        --help|-h)
            echo "用法: $0 <视频ID> [--unlike]"
            echo ""
            echo "选项:"
            echo "  --unlike  取消点赞"
            exit 0
            ;;
        *)
            VIDEO_ID="$1"
            shift
            ;;
    esac
done

if [ -z "$VIDEO_ID" ]; then
    echo "❌ 错误: 缺少视频ID"
    exit 1
fi

if [ ! -f "$COOKIES_FILE" ]; then
    echo "❌ 错误: 未登录"
    exit 1
fi

echo "👍 ${ACTION}视频: $VIDEO_ID"

python3 << EOF
import asyncio
import json
from pathlib import Path
from playwright.async_api import async_playwright

video_id = "$VIDEO_ID"
action = "$ACTION"
cookies_file = Path("$COOKIES_FILE")

async def like_video():
    async with async_playwright() as p:
        with open(cookies_file) as f:
            data = json.load(f)
        cookies = data.get("cookies", [])
        
        browser = await p.chromium.launch(headless=False)
        context = await browser.new_context()
        await context.add_cookies(cookies)
        
        page = await context.new_page()
        
        print("🌐 访问视频页面...")
        await page.goto(f"https://www.douyin.com/video/{video_id}")
        await page.wait_for_load_state("networkidle")
        await asyncio.sleep(2)
        
        # 查找点赞按钮
        like_button = await page.query_selector('[class*="like-icon"], [class*="digg"]')
        
        if like_button:
            await like_button.click()
            print(f"✅ 已{'取消点赞' if action == 'unlike' else '点赞'}")
        else:
            print("⚠️  未找到点赞按钮")
        
        await asyncio.sleep(1)
        await browser.close()

asyncio.run(like_video())
EOF

echo "✅ 完成"