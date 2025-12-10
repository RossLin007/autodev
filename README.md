# 夜间自动开发系统

这是一个基于 GitHub Actions 和 Continue.dev CLI 的自动化开发系统，能够在夜间自动处理标记为 `night-task` 的 GitHub Issues。

## 🌙 功能特性

- 自动扫描并处理带 `night-task` 标签的 Issues
- 创建独立的开发分支
- 使用 Continue.dev CLI 自动编写代码
- 自动运行 linting 和测试
- 测试失败时自动修复
- 创建 Pull Request
- 生成每日开发报告

## 📋 系统要求

### GitHub Secrets 配置

在仓库设置中添加以下 Secrets：

1. **`PAT_TOKEN`** (必需)
   - 类型: Personal Access Token
   - 权限: `repo`, `workflow`, `issues:write`
   - 说明: 用于创建分支、PR 和评论的访问令牌

2. **`ANTHROPIC_API_KEY`** (必需)
   - 类型: API Key
   - 说明: Continue.dev CLI 使用的 Anthropic API 密钥

3. **`SLACK_WEBHOOK_URL`** (可选)
   - 类型: Webhook URL
   - 说明: 如果需要发送 Slack 通知

### 项目要求

- 项目使用 Git 进行版本控制
- 建议有 `package.json` 文件（用于 npm 脚本）
- 配置好 linting 和测试脚本

## 🚀 使用方法

### 自动运行

系统会在每天凌晨 2:00 (UTC) 自动运行，处理所有标记为 `night-task` 的 Issues。

### 手动触发

你也可以手动触发工作流：

1. 进入 GitHub Actions 页面
2. 选择 "Nightly Auto Development" 工作流
3. 点击 "Run workflow"
4. 可选：输入特定的 Issue 编号

### 添加夜间任务

1. 创建新的 Issue
2. 添加 `night-task` 标签
3. 详细描述任务需求
4. 系统会在下次运行时自动处理

## 📁 文件结构

```
.github/
├── workflows/
│   └── nightly-dev.yml          # 主要工作流配置
└── scripts/
    ├── pick-task.sh              # 任务选择脚本
    ├── create-branch.sh          # 分支创建脚本
    ├── run-development.sh        # 开发执行脚本
    ├── create-pr.sh              # PR 创建脚本
    ├── fix-issues.sh             # 问题修复脚本
    └── generate-report.sh        # 日报生成脚本

.continue/
└── config.yaml                  # Continue.dev CLI 配置
```

## 📊 日报查看

系统会自动创建带有 `daily-report` 标签的 Issue，包含：
- 完成的任务列表
- 创建的 PR 链接
- 需要人工审核的项目
- 系统运行统计

## ⚙️ 自定义配置

### Continue.dev 配置

编辑 `.continue/config.yaml` 来自定义 AI 模型和行为：

```json
{
  "models": [
    {
      "provider": "anthropic",
      "model": "claude-3.5-sonnet",
      "apiKey": "${ANTHROPIC_API_KEY}"
    }
  ],
  "rules": [
    // 添加你的编码规则
  ]
}
```

### 调整执行时间

修改 `.github/workflows/nightly-dev.yml` 中的 cron 表达式：

```yaml
schedule:
  - cron: '0 2 * * *'  # 每天 UTC 02:00
```

### 自定义分支命名

编辑 `create-branch.sh` 脚本中的分支命名逻辑。

## 🔧 故障排除

### 常见问题

1. **权限错误**
   - 确保 PAT_TOKEN 有足够权限
   - 检查仓库设置是否允许 Actions 创建 PR

2. **API 限制**
   - 检查 Anthropic API 配额
   - 确认 API Key 正确配置

3. **测试失败**
   - 系统会自动尝试修复
   - 如仍失败，需要人工介入

### 查看日志

在 GitHub Actions 页面查看详细执行日志：
- 任务选择过程
- AI 开发过程
- 测试结果
- 错误信息

## 🤝 贡献指南

1. Fork 本仓库
2. 创建功能分支
3. 提交更改
4. 创建 Pull Request

## 📄 许可证

MIT License

## 🆘 支持

如有问题或建议，请创建 Issue 并标记为 `help-needed`。# autodev
