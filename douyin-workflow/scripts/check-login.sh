#!/bin/bash
# 检查抖音登录状态

set -e

DOUYIN_DIR="$HOME/.douyin"
COOKIES_FILE="$DOUYIN_DIR/cookies.json"

echo "🔍 检查抖音登录状态..."
echo ""

if [ ! -f "$COOKIES_FILE" ]; then
    echo "❌ Cookies 文件不存在"
    echo "   运行: ./get-cookie.sh 获取登录凭证"
    exit 1
fi

# 使用 Python 检查 cookies 有效性
python3 << 'EOF'
import json
from pathlib import Path
from datetime import datetime

cookies_file = Path.home() / ".douyin" / "cookies.json"

try:
    with open(cookies_file) as f:
        data = json.load(f)
    
    cookies = data.get("cookies", [])
    
    # 检查关键 cookies
    required = ["sessionid", "ttwid"]
    found = []
    for cookie in cookies:
        if cookie.get("name") in required:
            found.append(cookie.get("name"))
    
    if len(found) >= 2:
        print("✅ 登录状态: 有效")
        print(f"   Cookies 数量: {len(cookies)}")
        print(f"   关键凭证: {', '.join(found)}")
    else:
        print("⚠️  登录状态: 可能已过期")
        print("   建议重新登录: ./get-cookie.sh")
        
except Exception as e:
    print(f"❌ 检查失败: {e}")
EOF

echo ""