#!/bin/bash
# 分析抖音账号

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOUYIN_DIR="$HOME/.douyin"
COOKIES_FILE="$DOUYIN_DIR/cookies.json"

# 参数
USER_ID=""
OUTPUT=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --output|-o)
            OUTPUT="$2"
            shift 2
            ;;
        --help|-h)
            echo "用法: $0 <用户ID> [选项]"
            echo ""
            echo "选项:"
            echo "  --output, -o FILE  输出文件路径"
            exit 0
            ;;
        *)
            USER_ID="$1"
            shift
            ;;
    esac
done

if [ -z "$USER_ID" ]; then
    echo "❌ 错误: 缺少用户ID"
    exit 1
fi

echo "🔍 分析抖音账号: $USER_ID"
echo ""

REPORT_FILE="${OUTPUT:-$DOUYIN_DIR/reports/account-$USER_ID-$(date +%Y%m%d).md}"
mkdir -p "$(dirname "$REPORT_FILE")"

python3 << EOF
import asyncio
import json
from datetime import datetime
from pathlib import Path
from playwright.async_api import async_playwright

user_id = "$USER_ID"
report_file = Path("$REPORT_FILE")

async def analyze_account():
    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=True)
        page = await browser.new_page()
        
        print("🌐 访问用户主页...")
        await page.goto(f"https://www.douyin.com/user/{user_id}")
        await page.wait_for_load_state("networkidle")
        await asyncio.sleep(3)
        
        # 提取账号信息
        print("📝 提取账号数据...")
        account_info = {
            "user_id": user_id,
            "analyzed_at": datetime.now().strftime("%Y-%m-%d %H:%M"),
            "metrics": {}
        }
        
        try:
            # 昵称
            nickname_elem = await page.query_selector('[class*="nickname"], h1')
            if nickname_elem:
                account_info["nickname"] = await nickname_elem.inner_text()
            
            # 粉丝数
            fans_elem = await page.query_selector('[class*="fans"] [class*="count"]')
            if fans_elem:
                account_info["metrics"]["fans"] = await fans_elem.inner_text()
            
            # 关注数
            following_elem = await page.query_selector('[class*="following"] [class*="count"]')
            if following_elem:
                account_info["metrics"]["following"] = await following_elem.inner_text()
            
            # 获赞数
            likes_elem = await page.query_selector('[class*="liked"] [class*="count"]')
            if likes_elem:
                account_info["metrics"]["likes"] = await likes_elem.inner_text()
                
        except Exception as e:
            print(f"⚠️  部分数据提取失败: {e}")
        
        await browser.close()
        
        # 生成报告
        report = f"""# 抖音账号分析报告

**用户ID:** {user_id}
**昵称:** {account_info.get('nickname', '未知')}
**分析时间:** {account_info['analyzed_at']}

---

## 📊 账号数据

| 指标 | 数值 |
|------|------|
| 粉丝数 | {account_info['metrics'].get('fans', '-')} |
| 关注数 | {account_info['metrics'].get('following', '-')} |
| 获赞数 | {account_info['metrics'].get('likes', '-')} |

---

## 📈 内容分析

> 详细内容分析需要更多数据...

---

*报告由 OpenClaw Douyin Workflow 自动生成*
"""
        
        report_file.parent.mkdir(parents=True, exist_ok=True)
        report_file.write_text(report, encoding='utf-8')
        
        print(f"\n📄 报告已生成: {report_file}")
        
        return account_info

asyncio.run(analyze_account())
EOF

echo ""
echo "✅ 账号分析完成"