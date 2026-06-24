#!/usr/bin/env bash

set -euo pipefail

# --------------------------------------------------
# Git History Cleaner
# 删除指定文件/目录的所有历史记录
# --------------------------------------------------

echo "========================================"
echo "Git History Cleaner"
echo "========================================"
echo

# 检查是否在 git 仓库中

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || true)

if [ -z "$REPO_ROOT" ]; then
echo "❌ 当前目录不在 Git 仓库内"
exit 1
fi

cd "$REPO_ROOT"

# 检查参数

if [ $# -eq 0 ]; then
echo "用法:"
echo
echo "  $0 <file-or-folder> [more paths...]"
echo
echo "示例:"
echo "  $0 images/a.jpg"
echo "  $0 images/bad"
echo "  $0 images/a.jpg images/bad"
exit 1
fi

# 检查 git-filter-repo
if ! command -v git-filter-repo >/dev/null 2>&1; then
echo "⚠️ 未检测到 git-filter-repo"
echo

```
if command -v brew >/dev/null 2>&1; then
    echo "正在通过 Homebrew 安装..."
    brew install git-filter-repo
elif command -v pip3 >/dev/null 2>&1; then
    echo "正在通过 pip3 安装..."
    pip3 install git-filter-repo
elif command -v pip >/dev/null 2>&1; then
    echo "正在通过 pip 安装..."
    pip install git-filter-repo
else
    echo "❌ 无法自动安装 git-filter-repo"
    echo "请手动安装后重试"
    exit 1
fi
```

fi

echo
echo "仓库:"
echo "$REPO_ROOT"
echo

FILTER_ARGS=()

for TARGET in "$@"; do

```
if [ ! -e "$TARGET" ]; then
    echo "⚠️ 跳过不存在的路径:"
    echo "   $TARGET"
    continue
fi

REL_PATH=$(realpath --relative-to="$REPO_ROOT" "$TARGET" 2>/dev/null || python3 - <<PY
```

import os
print(os.path.relpath("$TARGET", "$REPO_ROOT"))
PY
)

```
echo "✔ 添加:"
echo "   $REL_PATH"

FILTER_ARGS+=(--path "$REL_PATH")
```

done

if [ ${#FILTER_ARGS[@]} -eq 0 ]; then
echo
echo "❌ 没有有效路径"
exit 1
fi

echo
echo "========================================"
echo "将永久删除以下内容的所有历史:"
echo "========================================"
printf '%s\n' "${FILTER_ARGS[@]}"
echo

read -p "继续? (y/N): " CONFIRM

if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
echo "已取消"
exit 0
fi

echo
echo "开始重写历史..."
echo

git filter-repo 
--force 
"${FILTER_ARGS[@]}" 
--invert-paths

echo
echo "清理无引用对象..."
echo

git reflog expire --expire=now --all
git gc --prune=now --aggressive

echo
echo "========================================"
echo "完成"
echo "========================================"
echo
echo "下一步:"
echo
echo "git push --force --all"
echo "git push --force --tags"
echo
echo "查看仓库大小:"
echo
echo "git count-objects -vH"
