#!/bin/bash
# 通用 MCP 工具调用

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOUYIN_DIR="$HOME/.douyin"

# MCP 服务器地址
MCP_URL="${DOUYIN_MCP_URL:-http://localhost:18060}"

TOOL_NAME=""
PARAMS=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --params|-p)
            PARAMS="$2"
            shift 2
            ;;
        --help|-h)
            echo "用法: $0 <工具名> [--params '{...}']"
            echo ""
            echo "可用工具:"
            echo "  check_login_status    检查登录状态"
            echo "  search_feeds          搜索内容"
            echo "  get_feed_detail       获取帖子详情"
            echo "  post_comment          发表评论"
            echo "  like_feed             点赞"
            echo "  publish_content       发布内容"
            exit 0
            ;;
        *)
            TOOL_NAME="$1"
            shift
            ;;
    esac
done

if [ -z "$TOOL_NAME" ]; then
    echo "❌ 错误: 缺少工具名"
    exit 1
fi

echo "🔧 调用 MCP 工具: $TOOL_NAME"

if [ -n "$PARAMS" ]; then
    curl -s -X POST "$MCP_URL/mcp" \
        -H "Content-Type: application/json" \
        -d "{\"tool\": \"$TOOL_NAME\", \"params\": $PARAMS}" | jq .
else
    curl -s -X POST "$MCP_URL/mcp" \
        -H "Content-Type: application/json" \
        -d "{\"tool\": \"$TOOL_NAME\"}" | jq .
fi