#!/usr/bin/env bash

# 项目的目录
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)"
# load 
source "${PROJECT_ROOT}/scripts/install/common.sh"



# 手动启用 IPv4 数据包转发
install::set::sysctl() {
  cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
EOF

  conn::util::sudo "sysctl --system"
}


# net.ipv4.ip_forward 是否设置为 1：
install::sysctl::check() {
  conn::util::sudo "sysctl net.ipv4.ip_forward"	
}


if [[ "$*" =~ install:: ]];then
  eval $*
fi
