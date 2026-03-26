#!/bin/bash
# 发送抖音私信

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOUYIN_DIR="$HOME/.douyin"
COOKIES_FILE="$DOUYIN_DIR/cookies.json"

USER_ID=""
CONTENT=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --content|-c)
            CONTENT="$2"
            shift 2
            ;;
        --help|-h)
            echo "用法: $0 <用户ID> --content \"消息内容\""
            exit 0
            ;;
        *)
            USER_ID="$1"
            shift
            ;;
    esac
done

if [ -z "$USER_ID" ] || [ -z "$CONTENT" ]; then
    echo "❌ 错误: 缺少参数"
    exit 1
fi

if [ ! -f "$COOKIES_FILE" ]; then
    echo "❌ 错误: 未登录"
    exit 1
fi

echo "✉️ 发送私信"
echo "   用户: $USER_ID"
echo "   内容: $CONTENT"
echo ""

python3 << EOF
import asyncio
import json
from pathlib import Path
from playwright.async_api import async_playwright

user_id = "$USER_ID"
content = "$CONTENT"
cookies_file = Path("$COOKIES_FILE")

async def send_message():
    async with async_playwright() as p:
        with open(cookies_file) as f:
            data = json.load(f)
        cookies = data.get("cookies", [])
        
        browser = await p.chromium.launch(headless=False)
        context = await browser.new_context()
        await context.add_cookies(cookies)
        
        page = await context.new_page()
        
        print("🌐 访问用户主页...")
        await page.goto(f"https://www.douyin.com/user/{user_id}")
        await page.wait_for_load_state("networkidle")
        await asyncio.sleep(2)
        
        print("📝 发送私信...")
        # 点击私信按钮
        msg_button = await page.query_selector('[class*="private-message"], [class*="message-btn"]')
        if msg_button:
            await msg_button.click()
            await asyncio.sleep(1)
            
            # 输入消息
            input_box = await page.query_selector('textarea, [contenteditable="true"]')
            if input_box:
                await input_box.fill(content)
                await asyncio.sleep(0.5)
                
                # 发送
                send_button = await page.query_selector('[class*="send"], button[type="submit"]')
                if send_button:
                    await send_button.click()
                    print("✅ 私信已发送")
        
        await asyncio.sleep(1)
        await browser.close()

asyncio.run(send_message())
EOF

echo "✅ 完成"