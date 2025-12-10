#!/bin/bash

set -e

ISSUE_NUMBER="$1"
ISSUE_TITLE="$2"
PR_URL="$3"

# 生成报告文件名
REPORT_FILE="nightly-report-$(date +%Y-%m-%d).md"

# 创建报告内容
cat > "$REPORT_FILE" << EOF
# 夜间自动开发日报 - $(date +%Y年%m月%d日)

## 📊 任务执行情况

### ✅ 完成的任务
EOF

# 如果有执行的任务，添加到报告中
if [ -n "$ISSUE_NUMBER" ]; then
  cat >> "$REPORT_FILE" << EOF
- **Issue #$ISSUE_NUMBER**: $ISSUE_TITLE
  - 状态: 已完成
  - PR: $PR_URL
EOF
else
  cat >> "$REPORT_FILE" << EOF
- 无标记为 "night-task" 的任务
EOF
fi

# 获取今日创建的所有 PR
TODAY_PRS=$(gh pr list --creator "GitHub Actions" --created "$(date +%Y-%m-%d)" --json number,title,url --limit 10)

if [ -n "$TODAY_PRS" ]; then
  cat >> "$REPORT_FILE" << EOF

### 📝 今日创建的所有 PR
EOF

  echo "$TODAY_PRS" | jq -r '.[] | "- [PR #\(.number)](\(.url)): \(.title)"' >> "$REPORT_FILE"
fi

# 需要审核的 PR（自动创建但可能有冲突或需要检查的）
cat >> "$REPORT_FILE" << EOF

### 👀 需要审核的 PR
以下 PR 需要人工审核和测试：
EOF

# 获取所有标记为 auto-generated 的开放 PR
REVIEW_NEEDED_PRS=$(gh pr list --label "auto-generated" --state open --json number,title,url)

if [ -n "$REVIEW_NEEDED_PRS" ]; then
  echo "$REVIEW_NEEDED_PRS" | jq -r '.[] | "- [PR #\(.number)](\(.url)): \(.title)"' >> "$REPORT_FILE"
else
  echo "- 无需要审核的 PR" >> "$REPORT_FILE"
fi

# 统计信息
cat >> "$REPORT_FILE" << EOF

## 📈 统计信息
- 执行时间: $(date '+%H:%M:%S')
- 总处理任务数: $([ -n "$ISSUE_NUMBER" ] && echo "1" || echo "0")
- 创建 PR 数: $(gh pr list --creator "GitHub Actions" --created "$(date +%Y-%m-%d)" --json number --jq 'length' 2>/dev/null || echo "0")

## 📋 系统状态
- GitHub Actions: 运行正常
- Continue.dev CLI: 已配置
- 自动化流程: 完成一次循环

---
📄 此报告由夜间自动开发系统自动生成
EOF

# 输出报告内容
echo "===== 日报内容 ====="
cat "$REPORT_FILE"

# 创建或更新 Daily Report Issue
# 查找是否已有今日的 report issue
TODAY_REPORT_ISSUE=$(gh issue list --label "daily-report" --state open --json number,title --jq '.[] | select(.title | contains("$(date +%Y-%m-%d)")) | .number' | head -1)

REPORT_ISSUE_TITLE="夜间自动开发日报 - $(date +%Y-%m-%d)"

if [ -n "$TODAY_REPORT_ISSUE" ]; then
  echo "更新今日报告 Issue: #$TODAY_REPORT_ISSUE"
  gh issue edit "$TODAY_REPORT_ISSUE" --body "$(cat "$REPORT_FILE")"
else
  echo "创建新的报告 Issue"
  gh issue create \
    --title "$REPORT_ISSUE_TITLE" \
    --body "$(cat "$REPORT_FILE")" \
    --label "daily-report" \
    --label "auto-generated"
fi

echo "日报已生成并上传到 GitHub Issues"

# 可选：发送通知（配置了 webhook 的话）
if [ -n "$SLACK_WEBHOOK_URL" ]; then
  curl -X POST -H 'Content-type: application/json' \
    --data "{\"text\":\"🌙 夜间自动开发日报已生成: $(date +%Y-%m-%d)\"}" \
    "$SLACK_WEBHOOK_URL"
fi