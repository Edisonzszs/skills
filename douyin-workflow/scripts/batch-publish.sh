#!/bin/bash
# 批量发布抖音视频

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOUYIN_DIR="$HOME/.douyin"

# 参数
VIDEOS_DIR=""
INTERVAL=30
ACCOUNT="default"

while [[ $# -gt 0 ]]; do
    case $1 in
        --interval|-i)
            INTERVAL="$2"
            shift 2
            ;;
        --account|-a)
            ACCOUNT="$2"
            shift 2
            ;;
        --help|-h)
            echo "用法: $0 <视频目录> [选项]"
            echo ""
            echo "选项:"
            echo "  --interval, -i MIN  发布间隔分钟（默认：30）"
            echo "  --account, -a NAME  使用账号名称"
            exit 0
            ;;
        *)
            VIDEOS_DIR="$1"
            shift
            ;;
    esac
done

if [ -z "$VIDEOS_DIR" ] || [ ! -d "$VIDEOS_DIR" ]; then
    echo "❌ 错误: 缺少视频目录或目录不存在"
    exit 1
fi

echo "📦 批量发布抖音视频"
echo "   目录: $VIDEOS_DIR"
echo "   间隔: $INTERVAL 分钟"
echo ""

# 遍历视频文件
count=0
for video in "$VIDEOS_DIR"/*.mp4 "$VIDEOS_DIR"/*.mov; do
    if [ -f "$video" ]; then
        count=$((count + 1))
        
        # 检查是否有对应的 txt 文件（标题描述）
        txt_file="${video%.*}.txt"
        title=""
        desc=""
        
        if [ -f "$txt_file" ]; then
            title=$(head -1 "$txt_file")
            desc=$(tail -n +2 "$txt_file" | tr '\n' ' ')
        fi
        
        echo "📹 [$count] 发布: $(basename "$video")"
        
        if [ -n "$title" ]; then
            echo "   标题: $title"
        fi
        
        # 调用发布脚本
        "$SCRIPT_DIR/publish-video.sh" \
            --video "$video" \
            --title "$title" \
            --desc "$desc"
        
        # 等待间隔（最后一个不等待）
        if [ $count -lt $(ls -1 "$VIDEOS_DIR"/*.mp4 "$VIDEOS_DIR"/*.mov 2>/dev/null | wc -l) ]; then
            echo "   ⏳ 等待 $INTERVAL 分钟..."
            sleep $((INTERVAL * 60))
        fi
    fi
done

echo ""
echo "✅ 批量发布完成，共 $count 条视频"