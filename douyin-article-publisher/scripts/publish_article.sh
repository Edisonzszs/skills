#!/bin/bash
# 抖音文章发布辅助脚本
# 用法: ./publish_article.sh "标题" "摘要" "正文文件路径"

TITLE="${1:-AI热点速递}"
SUMMARY="${2:-AI圈最新动态}"
CONTENT_FILE="${3:-/dev/stdin}"

echo "=================================="
echo "抖音文章发布参数"
echo "=================================="
echo "标题: $TITLE ($(echo -n "$TITLE" | wc -c)/30)"
echo "摘要: $SUMMARY ($(echo -n "$SUMMARY" | wc -c)/30)"
echo "=================================="

# 检查字数
TITLE_LEN=$(echo -n "$TITLE" | wc -c)
SUMMARY_LEN=$(echo -n "$SUMMARY" | wc -c)

if [ "$TITLE_LEN" -gt 30 ]; then
    echo "⚠️ 标题超过30字，需要缩短"
    exit 1
fi

if [ "$SUMMARY_LEN" -gt 30 ]; then
    echo "⚠️ 摘要超过30字，需要缩短"
    exit 1
fi

echo "✅ 参数检查通过"
echo ""
echo "发布步骤："
echo "1. 打开 https://creator.douyin.com/"
echo "2. 点击「发布文章」"
echo "3. 填写标题：$TITLE"
echo "4. 填写摘要：$SUMMARY"
echo "5. 粘贴正文内容"
echo "6. 点击「AI 配图」生成封面"
echo "7. 点击「选择配乐」搜索「Warhorse 战马」"
echo "8. 点击「发布」"