#!/bin/bash
# 搜索抖音内容

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOUYIN_DIR="$HOME/.douyin"

# 参数
KEYWORD=""
LIMIT=20
SORT="hot"
OUTPUT=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --limit|-l)
            LIMIT="$2"
            shift 2
            ;;
        --sort|-s)
            SORT="$2"
            shift 2
            ;;
        --output|-o)
            OUTPUT="$2"
            shift 2
            ;;
        --help|-h)
            echo "用法: $0 <关键词> [选项]"
            echo ""
            echo "选项:"
            echo "  --limit, -l N    结果数量（默认：20）"
            echo "  --sort, -s TYPE  排序方式：hot（热度）、time（时间）"
            echo "  --output, -o FILE 输出文件路径"
            exit 0
            ;;
        *)
            KEYWORD="$1"
            shift
            ;;
    esac
done

if [ -z "$KEYWORD" ]; then
    echo "❌ 错误: 缺少搜索关键词"
    echo "   用法: $0 <关键词>"
    exit 1
fi

echo "🔍 搜索抖音内容"
echo "   关键词: $KEYWORD"
echo "   数量: $LIMIT"
echo "   排序: $SORT"
echo ""

# 使用 OpenClaw 浏览器搜索
# 或者使用 web API（如果有）
python3 << EOF
import asyncio
import json
from pathlib import Path
from playwright.async_api import async_playwright

keyword = "$KEYWORD"
limit = $LIMIT
sort_type = "$SORT"
output_file = "$OUTPUT" or None

async def search_douyin():
    results = []
    
    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=True)
        page = await browser.new_page()
        
        print("🌐 访问抖音搜索...")
        search_url = f"https://www.douyin.com/search/{keyword}?type=video"
        if sort_type == "hot":
            search_url += "&sort_type=0"
        else:
            search_url += "&sort_type=1"
        
        await page.goto(search_url)
        await page.wait_for_load_state("networkidle")
        await asyncio.sleep(3)  # 等待内容加载
        
        # 提取搜索结果
        print("📝 提取搜索结果...")
        videos = await page.query_selector_all('.video-card, [class*="VideoCard"]')
        
        for i, video in enumerate(videos[:limit]):
            try:
                title_elem = await video.query_selector('[class*="title"], h3')
                title = await title_elem.inner_text() if title_elem else "无标题"
                
                link_elem = await video.query_selector('a')
                link = await link_elem.get_attribute('href') if link_elem else ""
                
                results.append({
                    "rank": i + 1,
                    "title": title.strip(),
                    "url": f"https://www.douyin.com{link}" if link.startswith("/") else link
                })
                
                print(f"   {i+1}. {title.strip()[:50]}")
            except Exception as e:
                continue
        
        await browser.close()
    
    # 输出结果
    if output_file:
        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump({
                "keyword": keyword,
                "total": len(results),
                "results": results
            }, f, ensure_ascii=False, indent=2)
        print(f"\n📄 结果已保存: {output_file}")
    
    return results

asyncio.run(search_douyin())
EOF

echo ""
echo "✅ 搜索完成"