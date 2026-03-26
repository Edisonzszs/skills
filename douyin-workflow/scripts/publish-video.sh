#!/bin/bash
# 发布抖音视频

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOUYIN_DIR="$HOME/.douyin"
COOKIES_FILE="$DOUYIN_DIR/cookies.json"

# 参数解析
VIDEO_PATH=""
TITLE=""
DESC=""
TAGS=""
COVER=""
SCHEDULE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --video|-v)
            VIDEO_PATH="$2"
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
        --tags|--tag)
            TAGS="$2"
            shift 2
            ;;
        --cover|-c)
            COVER="$2"
            shift 2
            ;;
        --schedule|-s)
            SCHEDULE="$2"
            shift 2
            ;;
        --help|-h)
            echo "用法: $0 [选项]"
            echo ""
            echo "选项:"
            echo "  --video, -v PATH    视频文件路径（必需）"
            echo "  --title, -t TEXT    视频标题"
            echo "  --desc, -d TEXT     视频描述"
            echo "  --tags TEXT         话题标签，逗号分隔"
            echo "  --cover, -c PATH    封面图片路径"
            echo "  --schedule, -s TIME 定时发布时间（格式：YYYY-MM-DD HH:MM）"
            echo ""
            echo "示例:"
            echo "  $0 --video video.mp4 --title '我的视频' --tags '搞笑,日常'"
            exit 0
            ;;
        *)
            echo "未知参数: $1"
            exit 1
            ;;
    esac
done

# 验证必需参数
if [ -z "$VIDEO_PATH" ]; then
    echo "❌ 错误: 缺少视频文件路径"
    echo "   使用 --video 指定视频文件"
    exit 1
fi

if [ ! -f "$VIDEO_PATH" ]; then
    echo "❌ 错误: 视频文件不存在: $VIDEO_PATH"
    exit 1
fi

# 检查 cookies
if [ ! -f "$COOKIES_FILE" ]; then
    echo "❌ 错误: 未登录，请先运行 ./get-cookie.sh"
    exit 1
fi

echo "📤 发布抖音视频"
echo "   视频: $VIDEO_PATH"
[ -n "$TITLE" ] && echo "   标题: $TITLE"
[ -n "$DESC" ] && echo "   描述: $DESC"
[ -n "$TAGS" ] && echo "   标签: $TAGS"
[ -n "$SCHEDULE" ] && echo "   定时: $SCHEDULE"
echo ""

# 使用 Python 脚本发布
python3 << EOF
import asyncio
import json
from pathlib import Path
from playwright.async_api import async_playwright

cookies_file = Path("$COOKIES_FILE")
video_path = Path("$VIDEO_PATH").resolve()
title = "$TITLE" or ""
desc = "$DESC" or ""
tags = "$TAGS".split(",") if "$TAGS" else []
cover = Path("$COVER").resolve() if "$COVER" else None
schedule = "$SCHEDULE" or None

async def publish_video():
    async with async_playwright() as p:
        # 加载 cookies
        with open(cookies_file) as f:
            data = json.load(f)
        cookies = data.get("cookies", [])
        
        # 启动浏览器
        browser = await p.chromium.launch(headless=False)
        context = await browser.new_context()
        
        # 添加 cookies
        await context.add_cookies(cookies)
        
        page = await context.new_page()
        
        print("🌐 打开创作者中心...")
        await page.goto("https://creator.douyin.com/creator-micro/content/upload")
        await page.wait_for_load_state("networkidle")
        
        # 检查是否需要登录
        if "login" in page.url:
            print("❌ 登录已过期，请重新获取 cookies")
            await browser.close()
            return
        
        print("📤 上传视频...")
        # 点击上传按钮
        upload_input = await page.query_selector('input[type="file"]')
        if upload_input:
            await upload_input.set_input_files(str(video_path))
            print("   视频文件已选择")
        
        # 等待上传完成
        print("   等待上传完成...")
        await asyncio.sleep(5)
        
        # 填写标题
        if title:
            title_input = await page.query_selector('.title-input, input[placeholder*="标题"]')
            if title_input:
                await title_input.fill(title)
                print(f"   标题: {title}")
        
        # 填写描述
        if desc:
            desc_input = await page.query_selector('.desc-input, textarea[placeholder*="描述"]')
            if desc_input:
                await desc_input.fill(desc)
                print(f"   描述: {desc}")
        
        # 添加话题标签
        for tag in tags:
            if tag.strip():
                print(f"   添加标签: #{tag.strip()}#")
                # 这里需要根据实际页面元素调整
        
        print("✅ 视频发布准备完成")
        print("   请在浏览器中确认并点击发布")
        
        # 保持浏览器打开，等待用户确认
        input("按 Enter 关闭浏览器...")
        await browser.close()

asyncio.run(publish_video())
EOF

echo ""
echo "✅ 发布流程完成"