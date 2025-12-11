#!/bin/bash

set -e

ISSUE_TITLE="$1"
ISSUE_BODY="$2"

echo "开始执行开发任务: $ISSUE_TITLE"

# 创建一个临时的任务描述文件
TASK_DESC_FILE="/tmp/nightly-task.md"

cat > "$TASK_DESC_FILE" << EOF
# 夜间开发任务

## 任务标题
$ISSUE_TITLE

## 任务描述
$ISSUE_BODY

## 指示
请根据上述任务描述，完成以下工作：
1. 分析任务需求
2. 查看现有代码结构
3. 实现所需功能
4. 确保代码质量和一致性
5. 添加必要的测试

请直接修改文件，不要询问任何问题。
EOF

# 使用 Continue.dev CLI 执行任务
echo "使用 Continue.dev 执行开发任务..."
continue chat --message "$(cat "$TASK_DESC_FILE")" --no-input

echo "开发任务完成"