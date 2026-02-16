#!/bin/bash
# GitHub 仓库设置脚本

cd /Users/jack/.openclaw/workspace/iptv-list

# 添加远程仓库（需要用户先在 GitHub 创建 goldlhz/iptv-list 仓库）
git remote add origin https://github.com/goldlhz/iptv-list.git 2>/dev/null || echo "远程仓库已添加"

# 设置默认分支
git branch -M main

echo "======================================"
echo "GitHub 仓库设置说明"
echo "======================================"
echo ""
echo "1. 先在 GitHub 创建仓库:"
echo "   访问: https://github.com/new"
echo "   仓库名: iptv-list"
echo "   选择 Public"
echo ""
echo "2. 然后运行以下命令推送:"
echo "   cd ~/.openclaw/workspace/iptv-list"
echo "   git push -u origin main"
echo ""
echo "3. 之后 IPTV 链接为:"
echo "   https://raw.githubusercontent.com/goldlhz/iptv-list/main/IPTV.m3u"
echo ""
echo "======================================"
