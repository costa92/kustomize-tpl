#!/usr/bin/env bash

# 项目的目录
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)"
# load 
source "${PROJECT_ROOT}/scripts/install/common.sh"



# 手动启用 IPv4 数据包转发
install::set::sysctl() {
  cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward=1
vm.max_map_count=262144
EOF

  conn::util::sudo "sysctl --system"

}

install::load::ipvs() {
   conn::util::sudo "modprobe br_netfilter"
   conn::util::sudo "modprobe -- ip_vs"
   conn::util::sudo "modprobe -- ip_vs_sh"
   conn::util::sudo "modprobe -- ip_vs_rr"
   conn::util::sudo "modprobe -- ip_vs_wrr"
   conn::util::sudo "modprobe -- nf_conntrack_ipv4"
}

# net.ipv4.ip_forward 是否设置为 1：
install::sysctl::check() {
  conn::util::sudo "sysctl net.ipv4.ip_forward"	
}


if [[ "$*" =~ install:: ]];then
  eval $*
fi
