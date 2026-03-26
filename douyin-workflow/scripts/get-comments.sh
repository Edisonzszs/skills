#!/bin/bash
# 获取抖音视频评论

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOUYIN_DIR="$HOME/.douyin"
COOKIES_FILE="$DOUYIN_DIR/cookies.json"

# 参数
VIDEO_ID=""
LIMIT=50
OUTPUT=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --limit|-l)
            LIMIT="$2"
            shift 2
            ;;
        --output|-o)
            OUTPUT="$2"
            shift 2
            ;;
        --help|-h)
            echo "用法: $0 <视频ID> [选项]"
            echo ""
            echo "选项:"
            echo "  --limit, -l N    评论数量（默认：50）"
            echo "  --output, -o FILE 输出文件路径"
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
    echo "   用法: $0 <视频ID>"
    exit 1
fi

echo "💬 获取视频评论"
echo "   视频ID: $VIDEO_ID"
echo "   数量: $LIMIT"
echo ""

python3 << EOF
import asyncio
import json
from pathlib import Path
from playwright.async_api import async_playwright

video_id = "$VIDEO_ID"
limit = $LIMIT
output_file = "$OUTPUT" or None
cookies_file = Path("$COOKIES_FILE")

async def get_comments():
    async with async_playwright() as p:
        # 加载 cookies
        if cookies_file.exists():
            with open(cookies_file) as f:
                data = json.load(f)
            cookies = data.get("cookies", [])
        else:
            cookies = []
        
        browser = await p.chromium.launch(headless=True)
        context = await browser.new_context()
        
        if cookies:
            await context.add_cookies(cookies)
        
        page = await context.new_page()
        
        print("🌐 访问视频页面...")
        await page.goto(f"https://www.douyin.com/video/{video_id}")
        await page.wait_for_load_state("networkidle")
        await asyncio.sleep(2)
        
        # 提取评论
        print("📝 提取评论...")
        comments = []
        
        comment_elements = await page.query_selector_all('[class*="comment-item"], [class*="CommentItem"]')
        
        for i, elem in enumerate(comment_elements[:limit]):
            try:
                user_elem = await elem.query_selector('[class*="user-name"], [class*="nickname"]')
                user = await user_elem.inner_text() if user_elem else "匿名用户"
                
                content_elem = await elem.query_selector('[class*="comment-content"], [class*="text"]')
                content = await content_elem.inner_text() if content_elem else ""
                
                like_elem = await elem.query_selector('[class*="like-count"]')
                likes = await like_elem.inner_text() if like_elem else "0"
                
                comments.append({
                    "user": user.strip(),
                    "content": content.strip(),
                    "likes": likes.strip()
                })
                
                print(f"   {i+1}. {user.strip()}: {content.strip()[:50]}")
            except:
                continue
        
        await browser.close()
        
        # 输出结果
        if output_file:
            with open(output_file, 'w', encoding='utf-8') as f:
                json.dump({
                    "video_id": video_id,
                    "total": len(comments),
                    "comments": comments
                }, f, ensure_ascii=False, indent=2)
            print(f"\n📄 结果已保存: {output_file}")
        
        return comments

asyncio.run(get_comments())
EOF

echo ""
echo "✅ 评论获取完成"