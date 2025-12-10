#!/bin/bash

set -e

ISSUE_NUMBER="$1"

# 如果没有 issue number，创建默认分支
if [ -z "$ISSUE_NUMBER" ]; then
  BRANCH_NAME="nightly/auto-$(date +%Y%m%d)"
else
  BRANCH_NAME="nightly/issue-$ISSUE_NUMBER-$(date +%Y%m%d)"
fi

echo "创建分支: $BRANCH_NAME"

# 确保在主分支上
git checkout main || git checkout master
git pull origin main || git pull origin master

# 创建并切换到新分支
git checkout -b "$BRANCH_NAME"

# 推送分支到远程
git push -u origin "$BRANCH_NAME"

# 输出分支名称供后续步骤使用
echo "branch-name=$BRANCH_NAME" >> $GITHUB_OUTPUT