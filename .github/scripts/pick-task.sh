#!/bin/bash

set -e

# 获取传入的 issue number（如果有的话）
SPECIFIC_ISSUE="$1"

# 如果指定了特定的 issue，使用它
if [ -n "$SPECIFIC_ISSUE" ]; then
  echo "使用指定的 Issue: #$SPECIFIC_ISSUE"

  # 获取 issue 信息
  ISSUE_DATA=$(gh issue view "$SPECIFIC_ISSUE" --json title,body)
  ISSUE_TITLE=$(echo "$ISSUE_DATA" | jq -r '.title')
  ISSUE_BODY=$(echo "$ISSUE_DATA" | jq -r '.body')

  echo "issue-number=$SPECIFIC_ISSUE" >> $GITHUB_OUTPUT
  echo "issue-title=$ISSUE_TITLE" >> $GITHUB_OUTPUT
  echo "issue-body=$ISSUE_BODY" >> $GITHUB_OUTPUT

  exit 0
fi

# 否则，自动选择一个带有 "night-task" 标签的 issue
echo "查找带有 'night-task' 标签的 Issues..."

# 获取所有带有 night-task 标签的开放 issues
ISSUES=$(gh issue list --label "night-task" --state open --limit 10 --json number,title)

# 检查是否有找到 issues
if [ -z "$ISSUES" ]; then
  echo "没有找到带有 'night-task' 标签的开放 Issues"
  echo "issue-number=" >> $GITHUB_OUTPUT
  echo "issue-title=No night-task found" >> $GITHUB_OUTPUT
  echo "issue-body=" >> $GITHUB_OUTPUT
  exit 0
fi

# 选择第一个 issue
SELECTED_ISSUE=$(echo "$ISSUES" | jq -r '.[0]')
ISSUE_NUMBER=$(echo "$SELECTED_ISSUE" | jq -r '.number')
ISSUE_TITLE=$(echo "$SELECTED_ISSUE" | jq -r '.title')

echo "选择的 Issue: #$ISSUE_NUMBER - $ISSUE_TITLE"

# 获取完整的 issue 信息
ISSUE_DATA=$(gh issue view "$ISSUE_NUMBER" --json body)
ISSUE_BODY=$(echo "$ISSUE_DATA" | jq -r '.body')

# 输出结果供后续步骤使用
echo "issue-number=$ISSUE_NUMBER" >> $GITHUB_OUTPUT
echo "issue-title=$ISSUE_TITLE" >> $GITHUB_OUTPUT
{
  echo "issue-body<<EOF"
  echo "$ISSUE_BODY"
  echo "EOF"
} >> $GITHUB_OUTPUT

# 添加评论表明该 issue 已被选中
gh issue comment "$ISSUE_NUMBER" --body "🌙 夜间自动开发系统已选择此任务，正在处理中..."