#!/bin/bash
# 获取抖音登录 Cookies

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOUYIN_DIR="$HOME/.douyin"
COOKIES_FILE="$DOUYIN_DIR/cookies.json"

echo "🔑 抖音登录获取 Cookies"
echo ""
echo "方式一：使用 OpenClaw 浏览器（推荐）"
echo "----------------------------------------"
echo "1. 启动浏览器: openclaw browser --browser-profile openclaw start"
echo "2. 打开创作者中心: openclaw browser --browser-profile openclaw open 'https://creator.douyin.com/'"
echo "3. 手动登录抖音账号"
echo "4. 登录成功后，cookies 自动保存在浏览器配置文件中"
echo ""
echo "方式二：使用 Python 脚本"
echo "----------------------------------------"

# 检查 Playwright
if ! python3 -c "import playwright" 2>/dev/null; then
    echo "❌ 请先安装 Playwright: pip install playwright && playwright install chromium"
    exit 1
fi

# 创建获取 cookies 的 Python 脚本
cat > /tmp/get_douyin_cookie.py << 'EOF'
import asyncio
import json
from pathlib import Path
from playwright.async_api import async_playwright

COOKIES_FILE = Path.home() / ".douyin" / "cookies.json"

async def get_cookies():
    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=False)
        context = await browser.new_context()
        page = await context.new_page()
        
        print("🌐 正在打开抖音创作者中心...")
        await page.goto("https://creator.douyin.com/")
        
        print("⏳ 请在浏览器中登录抖音账号...")
        print("   登录完成后，按 Enter 键继续...")
        input()
        
        # 获取 cookies
        cookies = await context.cookies()
        
        # 保存 cookies
        COOKIES_FILE.parent.mkdir(parents=True, exist_ok=True)
        with open(COOKIES_FILE, 'w') as f:
            json.dump({
                "cookies": cookies,
                "created_at": "auto",
                "domain": ".douyin.com"
            }, f, indent=2)
        
        print(f"✅ Cookies 已保存到: {COOKIES_FILE}")
        
        await browser.close()

asyncio.run(get_cookies())
EOF

echo "🚀 启动浏览器..."
python3 /tmp/get_douyin_cookie.py

echo ""
echo "✅ 完成！Cookies 已保存"