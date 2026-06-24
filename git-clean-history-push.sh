#!/usr/bin/env bash

set -euo pipefail

# --------------------------------------------------
# Git History Push Helper
# 清理历史后重新配置远程并强制推送所有分支和标签
# --------------------------------------------------

REMOTE_NAME=${1:-origin}
REMOTE_URL=${2:-https://github.com/ext-colorful/static-assets.git}

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || true)
if [ -z "$REPO_ROOT" ]; then
    echo "❌ 当前目录不在 Git 仓库内"
    exit 1
fi

cd "$REPO_ROOT"

echo "仓库: $REPO_ROOT"
echo "远程名称: $REMOTE_NAME"
echo "远程 URL: $REMOTE_URL"

git remote get-url "$REMOTE_NAME" >/dev/null 2>&1 || {
    echo "远程 '$REMOTE_NAME' 未配置，正在添加..."
    git remote add "$REMOTE_NAME" "$REMOTE_URL"
}

echo
if git remote get-url "$REMOTE_NAME" >/dev/null 2>&1; then
    echo "已配置远程：$(git remote get-url "$REMOTE_NAME")"
else
    echo "❌ 无法获取远程 URL"
    exit 1
fi

echo
read -p "确认推送到 '$REMOTE_NAME'？(y/N): " CONFIRM
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo "已取消"
    exit 0
fi

echo
echo "正在强制推送所有分支..."
git push --force "$REMOTE_NAME" --all

echo
echo "正在强制推送所有标签..."
git push --force "$REMOTE_NAME" --tags

echo
echo "推送完成。"
