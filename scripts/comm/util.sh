#!/usr/bin/env bash

# 使用sudo 命令
function conn::util::sudo()
{
  echo ${LINUX_PASSWORD} | sudo -S $1		
}

# 判断文件目录是否在
function conn::util::check_directory_existence()
{
   local dirname_path="$1"

   if [ -d "$dirname_path" ]; then
     return 0  # 目录存在
   else
     return 1  # 目录不存在
   fi
}


function conn::util::create::directory()
{
  local dirname_path="$1"
  if ! conn::util::check_directory_existence "$dirname_path"; then
    mkdir -p "$dirname_path";
  fi
}


