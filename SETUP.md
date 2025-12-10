# 快速设置指南

## 1. 初始化 Git 仓库

```bash
git init
git add .
git commit -m "Initial commit: Nightly auto development system"
```

## 2. 推送到 GitHub

```bash
# 创建远程仓库（在 GitHub 网站上创建）
git remote add origin https://github.com/YOUR_USERNAME/autodev.git
git push -u origin main
```

## 3. 配置 GitHub Secrets

在仓库设置中添加以下 Secrets：

### PAT_TOKEN
- 访问 https://github.com/settings/tokens
- 点击 "Generate new token (classic)"
- 选择权限：
  - ✅ repo (Full control of private repositories)
  - ✅ workflow (Update GitHub Action workflows)
  - ✅ issues:write (Read and write issues)
- 复制生成的 token 并添加到仓库的 Secrets 中，命名为 `PAT_TOKEN`

### ANTHROPIC_API_KEY
- 访问 https://console.anthropic.com/
- 获取你的 API Key
- 添加到仓库的 Secrets 中，命名为 `ANTHROPIC_API_KEY`

## 4. 测试系统

### 添加测试任务
1. 在仓库中创建一个新的 Issue
2. 标题：`测试任务：添加一个示例功能`
3. 内容：描述一个简单的开发任务
4. 添加标签：`night-task`

### 手动触发工作流
1. 进入 GitHub Actions 页面
2. 选择 "Nightly Auto Development"
3. 点击 "Run workflow"
4. 点击 "Run workflow" 按钮

## 5. 查看结果

工作流执行完成后，检查：
1. 是否创建了新的分支
2. 是否创建了 Pull Request
3. Issue 是否被更新
4. 是否生成了日报

## 6. 自定义配置

根据项目需求，你可能需要：
- 更新 `.continue/config.json` 中的模型配置
- 修改 `package.json` 中的脚本命令
- 调整 GitHub Actions 的触发时间

## 故障排除

如果遇到问题：
1. 检查 GitHub Actions 日志
2. 确认所有 Secrets 已正确配置
3. 验证 PAT_TOKEN 权限
4. 查看是否有语法错误

完成后，你的夜间自动开发系统就可以正常运行了！🚀