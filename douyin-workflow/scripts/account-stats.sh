#!/bin/bash
# 账号数据统计

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOUYIN_DIR="$HOME/.douyin"
COOKIES_FILE="$DOUYIN_DIR/cookies.json"
STATS_DIR="$DOUYIN_DIR/stats"

# 参数
RANGE="today"
OUTPUT=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --range|-r)
            RANGE="$2"
            shift 2
            ;;
        --output|-o)
            OUTPUT="$2"
            shift 2
            ;;
        --help|-h)
            echo "用法: $0 [选项]"
            echo ""
            echo "选项:"
            echo "  --range, -r RANGE  时间范围：today/week/month"
            echo "  --output, -o FILE  输出文件路径"
            exit 0
            ;;
        *)
            shift
            ;;
    esac
done

echo "📊 抖音账号数据统计"
echo "   时间范围: $RANGE"
echo ""

mkdir -p "$STATS_DIR"

python3 << EOF
import asyncio
import json
from datetime import datetime, timedelta
from pathlib import Path
from playwright.async_api import async_playwright

cookies_file = Path("$COOKIES_FILE")
stats_dir = Path("$STATS_DIR")
time_range = "$RANGE"
output_file = "$OUTPUT" or None

async def get_account_stats():
    async with async_playwright() as p:
        if cookies_file.exists():
            with open(cookies_file) as f:
                data = json.load(f)
            cookies = data.get("cookies", [])
        else:
            print("❌ 未登录，请先运行 ./get-cookie.sh")
            return
        
        browser = await p.chromium.launch(headless=True)
        context = await browser.new_context()
        await context.add_cookies(cookies)
        
        page = await context.new_page()
        
        print("🌐 访问创作者中心...")
        await page.goto("https://creator.douyin.com/creator-micro/home")
        await page.wait_for_load_state("networkidle")
        await asyncio.sleep(3)
        
        # 提取数据
        print("📝 提取账号数据...")
        stats = {
            "date": datetime.now().strftime("%Y-%m-%d"),
            "range": time_range,
            "metrics": {}
        }
        
        # 尝试提取各项指标
        try:
            # 粉丝数
            fans_elem = await page.query_selector('[class*="fans-count"], [class*="follower"]')
            if fans_elem:
                stats["metrics"]["fans"] = await fans_elem.inner_text()
            
            # 总播放量
            views_elem = await page.query_selector('[class*="play-count"], [class*="view"]')
            if views_elem:
                stats["metrics"]["total_views"] = await views_elem.inner_text()
            
            # 总点赞数
            likes_elem = await page.query_selector('[class*="like-count"], [class*="digg"]')
            if likes_elem:
                stats["metrics"]["total_likes"] = await likes_elem.inner_text()
                
        except Exception as e:
            print(f"⚠️  数据提取部分失败: {e}")
        
        await browser.close()
        
        # 保存数据
        today_file = stats_dir / "daily" / f"{stats['date']}.json"
        today_file.parent.mkdir(parents=True, exist_ok=True)
        with open(today_file, 'w', encoding='utf-8') as f:
            json.dump(stats, f, ensure_ascii=False, indent=2)
        
        # 输出结果
        print("\n📊 账号数据:")
        for key, value in stats["metrics"].items():
            print(f"   {key}: {value}")
        
        print(f"\n📄 数据已保存: {today_file}")
        
        if output_file:
            import shutil
            shutil.copy(today_file, output_file)
            print(f"   副本: {output_file}")
        
        return stats

asyncio.run(get_account_stats())
EOF

echo ""
echo "✅ 数据统计完成"