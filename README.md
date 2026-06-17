# Static Assets

静态资源仓库，包含按日期、语言和浏览器类型组织的图像文件。

## 目录结构

```
images/
├── 2026/
│   └── 06/
│       └── 17/
└── YYYYMMDD/
    └── {locale}/
        └── {browser}/
            └── *.{jpg,png,gif,webp,svg}
```

## 参数说明

- **YYYYMMDD**: 日期标识符（年年年年月月日日）
- **locale**: 语言和地区代码（如 en_US, zh_CN, fr 等）
- **browser**: 浏览器类型（chrome, edge 等）

## 支持的语言和地区

- en_US (English - United States)
- en_GB (English - United Kingdom)
- zh_CN (Chinese - Simplified)
- zh_TW (Chinese - Traditional)
- pt_BR (Portuguese - Brazil)
- ru (Russian)
- fr (French)
- es_MX (Spanish - Mexico)
- nl (Dutch)
- ja (Japanese)
- vi (Vietnamese)
- fi (Finnish)
- cs (Czech)
- en_CN (English - China)

## 支持的浏览器

- chrome
- edge

## 使用指南

1. 按照日期创建新目录：`images/YYYYMMDD/`
2. 在对应语言目录下创建浏览器文件夹
3. 将图像文件放入相应目录
4. 提交更改到 git

## 许可

请参考项目许可证文件。
