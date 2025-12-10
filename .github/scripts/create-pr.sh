#!/bin/bash

set -e

BRANCH_NAME="$1"
ISSUE_TITLE="$2"
ISSUE_NUMBER="$3"

# 如果没有 issue number，使用通用标题
if [ -z "$ISSUE_NUMBER" ]; then
  PR_TITLE="自动开发: $ISSUE_TITLE"
  PR_BODY="此 PR 由夜间自动开发系统创建。

## 开发内容
$ISSUE_TITLE

---
🤖 由 GitHub Actions 自动生成"
else
  PR_TITLE="自动开发: $ISSUE_TITLE (Issue #$ISSUE_NUMBER)"
  PR_BODY="此 PR 由夜间自动开发系统创建，解决了 Issue #$ISSUE_NUMBER。

## 开发内容
$ISSUE_TITLE

## 关联 Issue
Closes #$ISSUE_NUMBER

---
🤖 由 GitHub Actions 自动生成"
fi

# 检查是否已经存在 PR
EXISTING_PR=$(gh pr list --head "$BRANCH_NAME" --json number --limit 1)

if [ -n "$EXISTING_PR" ]; then
  echo "PR 已存在，更新 PR 描述"
  PR_NUMBER=$(echo "$EXISTING_PR" | jq -r '.[0].number')
  gh pr edit "$PR_NUMBER" --title "$PR_TITLE" --body "$PR_BODY"
  PR_URL="https://github.com/${GITHUB_REPOSITORY}/pull/$PR_NUMBER"
else
  echo "创建新的 PR"
  PR_URL=$(gh pr create \
    --base main \
    --head "$BRANCH_NAME" \
    --title "$PR_TITLE" \
    --body "$PR_BODY" \
    --label "auto-generated" \
    --label "nightly-dev")
fi

echo "PR 已创建/更新: $PR_URL"

# 输出 PR URL 供后续步骤使用
echo "pr-url=$PR_URL" >> $GITHUB_OUTPUT

# 如果有关联的 issue，添加评论
if [ -n "$ISSUE_NUMBER" ]; then
  gh issue comment "$ISSUE_NUMBER" --body "✅ 夜间自动开发已完成，已创建 PR: $PR_URL"
fi