#!/bin/sh

# 文件名
PROTECTED_FILE="public/alert-manager/alertmanager-config.yaml"

# 检查是否有修改
if git diff --cached --name-only | grep -q "^$PROTECTED_FILE$"; then
  echo "Error: You are trying to modify $PROTECTED_FILE, which is protected."
  exit 1
fi

# 允许提交
exit 0
