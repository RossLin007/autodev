#!/bin/bash

set -e

ISSUE_TYPE="$1"

echo "检测到问题，尝试自动修复: $ISSUE_TYPE"

# 创建修复提示文件
FIX_PROMPT_FILE="/tmp/fix-prompt.md"

cat > "$FIX_PROMPT_FILE" << EOF
# 自动修复请求

## 问题类型
$ISSUE_TYPE

## 修复要求
请分析并修复以下问题：
1. 修复所有 linting 错误
2. 修复所有测试失败
3. 确保代码符合项目规范
4. 不要改变功能逻辑，只修复错误

## 注意事项
- 保持代码的功能不变
- 确保修复后能通过所有检查
- 添加必要的注释说明修复内容

请直接修复问题，不要询问。
EOF

# 使用 Continue.dev 修复问题
echo "使用 Continue.dev 修复问题..."
continue chat --message "$(cat "$FIX_PROMPT_FILE")" --no-input

echo "问题修复完成"