# Static Assets

静态资产仓库，用于存储和管理项目的静态资源文件。

## 📋 仓库介绍

本仓库包含按日期、语言和浏览器类型组织的静态资源文件，主要包括图片等媒体文件。

**仓库大小**：~620.69 MiB  
**所有者**：ext-colorful  
**主分支**：main

## 📁 文件结构

```
static-assets/
├── images/
│   ├── 2026/06/17/              # 2026年6月17日资源
│   │   ├── en_US/
│   │   │   └── chrome/
│   │   └── zh_CN/
│   │       └── edge/
│   ├── 2026/04/16/              # 2026年4月16日资源
│   │   ├── en_US/
│   │   │   └── chrome/
│   │   ├── pt_BR/
│   │   │   └── chrome/
│   │   └── zh_CN/
│   │       └── edge/
│   └── ...
├── git-clean-history.sh         # Git 历史清理脚本
├── git-clean-history-push.sh    # 推送脚本
└── README.md                     # 本文件
```

### 目录命名规则

- **日期格式**：`YYYY/MM/DD`
- **语言代码**：采用 ISO 639-1 或区域代码（如 en_US、zh_CN、pt_BR 等）
- **浏览器类型**：chrome、edge 等

### 当前语言覆盖

- 中文（简体）：zh_CN
- 中文（繁體）：zh_TW
- 英文（美国）：en_US
- 英文（英国）：en_GB
- 日语：ja
- 俄语：ru
- 法语：fr
- 荷兰语：nl
- 西班牙语（墨西哥）：es_MX
- 葡萄牙语（巴西）：pt_BR
- 越南语：vi
- 捷克语：cs
- 芬兰语：fi

## 🔧 维护工具

### Git 历史清理脚本

**文件**：`git-clean-history.sh`

用于从 Git 历史中永久删除指定的文件或目录，这在以下场景中很有用：

- 删除误提交的大文件
- 移除包含敏感信息的文件
- 清理不需要的过期目录
- 减小仓库大小，加快 clone/push/pull 速度

**使用示例**：

```bash
# 首次使用时确保脚本有执行权限
chmod +x git-clean-history.sh git-clean-history-push.sh

# 删除单个文件的历史
./git-clean-history.sh images/old-image.jpg

# 删除整个目录的历史
./git-clean-history.sh images/2026/06/15/

# 删除多个目标
./git-clean-history.sh images/file1.jpg images/2026/06/15/
```

### 清理后推送

`git-clean-history.sh` 仅负责重写历史并清理本地无引用对象。它会在结尾打印下一步推送命令，但不会自动执行推送。

清理完成后，使用下面脚本重新配置远程并实际执行强制推送：

```bash
./git-clean-history-push.sh
```

如果你需要指定远程名称或 URL：

```bash
./git-clean-history-push.sh origin https://github.com/ext-colorful/static-assets.git
```

**运作流程**：

1. 验证 Git 仓库环境
2. 检查 `git-filter-repo` 工具（若未安装自动安装）
3. 验证指定路径存在
4. 显示待删除内容并请求确认
5. 使用 `git filter-repo` 重写历史
6. 清理无引用对象并执行垃圾回收
7. 提示推送更新

**⚠️ 重要提示**：

- 这是**破坏性操作**，会永久改变 Git 历史
- 执行后需要 `git push --force --all` 和 `git push --force --tags` 推送更新
- 所有团队成员需要重新 clone 或同步历史
- 建议执行前备份仓库

## 📊 操作历史

### 2026-06-24 - Git 历史清理

**操作内容**：

- **清理工具修复**：修复 `git-clean-history.sh` 脚本中的 Bash 语法错误
  - 移除错误的 Markdown 代码块（` ``` `）
  - 修复 Python heredoc 变量传递问题
  - 规范化缩进和命令格式

- **目标清理**：删除 `images/2026/06/21/zh_CN/chrome/` 目录的所有历史

- **远程仓库配置问题**：
  - 初始状态：未配置远程仓库地址
  - 错误信息：`fatal: No configured push destination`
  - 解决方案：执行 `git remote add origin https://github.com/ext-colorful/static-assets.git`
  - 验证：`git remote -v` ✓

- **推送更新**：
  - `git push --force --all` ✓
  - `git push --force --tags` ✓

**清理前后对比**：

| 指标 | 清理前 | 清理后 |
|-----|--------|--------|
| pack-objects 数量 | 3509 | 3509（待GC优化） |
| 仓库大小 | 620.69 MiB | 620.69 MiB（待清理验证） |
| 远程仓库配置 | ❌ 未配置 | ✓ 已配置 |

## 🚀 开发指南

### 添加新资源

1. 按日期和语言创建对应目录结构
2. 将资源文件放入浏览器类型子目录
3. 提交到 main 分支

### 删除过期资源

使用 `git-clean-history.sh` 脚本完全从历史中移除资源：

```bash
bash git-clean-history.sh images/YYYY/MM/DD/
```

### 检查仓库大小

```bash
git count-objects -vH
```

## 📝 注意事项

- **远程仓库配置**：确保已配置远程仓库地址
  ```bash
  git remote add origin https://github.com/ext-colorful/static-assets.git
  ```
  或使用 `git remote -v` 验证现有配置

- **Force Push 风险**：每次 force push 后，请通知团队成员更新本地仓库
  ```bash
  git fetch origin
  git reset --hard origin/main
  ```

- **清理前备份**：建议在实施大规模清理前创建备份

- **敏感信息**：误提交包含敏感信息的文件后应立即清理

## 📞 联系方式

有问题或需要维护请联系仓库所有者：ext-colorful

---

**最后更新**：2026-06-24
