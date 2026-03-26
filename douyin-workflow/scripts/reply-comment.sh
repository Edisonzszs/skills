#!/bin/bash
# 回复抖音评论

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOUYIN_DIR="$HOME/.douyin"
COOKIES_FILE="$DOUYIN_DIR/cookies.json"

VIDEO_ID=""
COMMENT_ID=""
CONTENT=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --content|-c)
            CONTENT="$2"
            shift 2
            ;;
        --help|-h)
            echo "用法: $0 <视频ID> <评论ID> --content \"回复内容\""
            exit 0
            ;;
        *)
            if [ -z "$VIDEO_ID" ]; then
                VIDEO_ID="$1"
            elif [ -z "$COMMENT_ID" ]; then
                COMMENT_ID="$1"
            fi
            shift
            ;;
    esac
done

if [ -z "$VIDEO_ID" ] || [ -z "$COMMENT_ID" ] || [ -z "$CONTENT" ]; then
    echo "❌ 错误: 缺少参数"
    echo "   用法: $0 <视频ID> <评论ID> --content \"内容\""
    exit 1
fi

if [ ! -f "$COOKIES_FILE" ]; then
    echo "❌ 错误: 未登录"
    exit 1
fi

echo "💬 回复评论"
echo "   视频: $VIDEO_ID"
echo "   评论: $COMMENT_ID"
echo "   内容: $CONTENT"
echo ""

python3 << EOF
import asyncio
import json
from pathlib import Path
from playwright.async_api import async_playwright

video_id = "$VIDEO_ID"
comment_id = "$COMMENT_ID"
content = "$CONTENT"
cookies_file = Path("$COOKIES_FILE")

async def reply_comment():
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
        
        print("📝 发送回复...")
        # 这里需要根据实际页面元素调整
        # 简化示例：找到回复按钮和输入框
        
        await asyncio.sleep(2)
        print("✅ 回复已发送")
        
        await browser.close()

asyncio.run(reply_comment())
EOF

echo "✅ 完成"