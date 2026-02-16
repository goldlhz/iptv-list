#!/bin/bash
# IPTV 自动同步脚本

REPO_DIR="/Users/jack/.openclaw/workspace/iptv-list"
iSTORE_IP="192.168.7.156"
iSTORE_PORT="5182"
LOG_FILE="/tmp/iptv-sync.log"

cd "$REPO_DIR" || exit 1

echo "[$(date '+%Y-%m-%d %H:%M:%S')] 开始同步..." >> "$LOG_FILE"

# 获取最新 IPTV 列表
curl -s "http://${iSTORE_IP}:${iSTORE_PORT}" -o IPTV.m3u 2>> "$LOG_FILE"

if [ $? -eq 0 ] && [ -s IPTV.m3u ]; then
    LINE_COUNT=$(wc -l < IPTV.m3u)
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 获取成功，共 $LINE_COUNT 行" >> "$LOG_FILE"
    
    # 检查是否有变更
    if git diff --quiet IPTV.m3u 2>/dev/null; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] 列表无变更，跳过提交" >> "$LOG_FILE"
        exit 0
    fi
    
    # 更新 README
    cat > README.md << EOF
# IPTV 直播源列表

自动更新的 IPTV 直播源列表

## 使用方法

复制以下链接到电视/播放器：

\`\`\`
https://raw.githubusercontent.com/goldlhz/iptv-list/main/IPTV.m3u
\`\`\`

## 更新时间

$(date '+%Y-%m-%d %H:%M:%S')

## 频道数量

约 $((LINE_COUNT / 2)) 个频道

## 源地址

- 服务部署在: iStoreOS (192.168.7.156)
- 自动更新: 每 12 小时
- 项目: https://github.com/Guovin/iptv-api
EOF

    # Git 提交
    git add IPTV.m3u README.md
    git commit -m "Update IPTV list - $(date '+%Y-%m-%d %H:%M')" >> "$LOG_FILE" 2>&1
    
    # 推送到 GitHub
    if git push origin main >> "$LOG_FILE" 2>&1; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✅ 同步成功" >> "$LOG_FILE"
    else
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] ❌ 推送失败，请检查 GitHub 仓库" >> "$LOG_FILE"
    fi
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ❌ 获取 IPTV 列表失败" >> "$LOG_FILE"
fi
