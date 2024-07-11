#!/bin/sh


# 从环境变量中获取要保护的文件列表
#  IFS=',' read -r -a PROTECTED_FILES <<< "$PROTECTED_FILES_ENV"
#  export PROTECTED_FILES_ENV="protected_file1.txt,protected_file2.txt"

# 检查是否有修改
# 要保护的文件列表
PROTECTED_FILES=(
    "public/alert-manager/alertmanager-config.yaml" 
)

# 检查是否有文件被修改
for FILE in "${PROTECTED_FILES[@]}"; do
  if git diff --cached --name-only | grep -q "^$FILE$"; then
    echo "Error: You are trying to modify $FILE, which is protected."
    exit 1
  fi
done


# 允许提交
exit 0
