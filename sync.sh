#!/bin/bash
# IPTV 列表自动同步到 GitHub

REPO_DIR="/Users/jack/.openclaw/workspace/iptv-list"
iSTORE_IP="192.168.7.156"
iSTORE_PORT="5182"

cd "$REPO_DIR"

# 获取 IPTV 列表
echo "正在获取 IPTV 列表..."
curl -s "http://${iSTORE_IP}:${iSTORE_PORT}/result.txt" -o IPTV.m3u 2>/dev/null

if [ $? -eq 0 ] && [ -s IPTV.m3u ]; then
    echo "✅ 获取成功，文件大小: $(ls -lh IPTV.m3u | awk '{print $5}')"
    
    # 更新 README
    echo "# IPTV 直播源列表" > README.md
    echo "" >> README.md
    echo "自动更新的 IPTV 直播源列表" >> README.md
    echo "" >> README.md
    echo "## 使用方法" >> README.md
    echo "复制以下链接到播放器:" >> README.md
    echo "\`\`\`" >> README.md
    echo "https://raw.githubusercontent.com/goldlhz/iptv-list/main/IPTV.m3u" >> README.md
    echo "\`\`\`" >> README.md
    echo "" >> README.md
    echo "## 更新时间" >> README.md
    echo "$(date '+%Y-%m-%d %H:%M:%S')" >> README.md
    
    # Git 提交
    git add IPTV.m3u README.md
    git commit -m "Update IPTV list - $(date '+%Y-%m-%d %H:%M')" 2>/dev/null
    
    # 推送到 GitHub
    git push origin main 2>/dev/null && echo "✅ 已推送到 GitHub"
else
    echo "❌ 获取失败或文件为空"
fi
