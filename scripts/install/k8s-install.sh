#!/usr/bin/env bash


# 项目的目录
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)"
# load 
source "${PROJECT_ROOT}/scripts/install/common.sh"



k8s::install(){

 k8s::install::aliyun::sources
 k8s::install-lib
 conn::util::sudo "apt-get install -y kubelet kubeadm kubectl"
 conn::util::sudo "apt-mark hold kubelet kubeadm kubectl"
}

k8s::install::start(){
  conn::util::sudo "systemctl enable kubelet"
}

k8s::install::bash-completion()
{
  # conn::util::sudo "apt install -y bash-completion"
  mkdir -p ${HOME}/.bash_completion.d
  kubeadm completion bash > ${HOME}/.bash_completion.d/kubeadm
  kubectl completion bash > ${HOME}/.bash_completion.d/kubectl
  # 加入 ~/.bashrc
# 定义多行字符串变量
content='
# Load kubectl bash completion
if [ -f ~/.bash_completion.d/kubectl ]; then
    source ~/.bash_completion.d/kubectl
fi

if [ -f ~/.bash_completion.d/kubeadm ]; then
    source ~/.bash_completion.d/kubeadm
fi
'

# 将内容追加到 ~/.bashrc 的末尾
echo "$content" >> ~/.bashrc

# 重新加载 ~/.bashrc 文件
source ~/.bashrc
}


k8s::install::generate::config()
{
   local tmp_dir_path="${TMP_PATH}/k8s/"
   echo ${tmp_dir_path}
   local tmp_config="${tmp_dir_path}kubeadm-init.yml"
   conn::util::create::directory "${TMP_PATH}/k8s"
   kubeadm config print init-defaults >> ${tmp_config}
}

k8s::install-lib()
{
  conn::util::sudo "apt-get update -y"
  # apt-transport-https 可能是一个虚拟包（dummy package）；如果是的话，你可以跳过安装这个包
  conn::util::sudo "apt-get install -y apt-transport-https ca-certificates curl gpg"
}



k8s::add::keyrings()
{
  local keyrings_path="/etc/apt/keyrings"
  conn::util::create::directory ${keyrings_path}
  echo ${LINUX_PASSWORD} | curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
}


k8s::add::sources()
{
  echo ${LINUX_PASSWORD} | echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
 
}


k8s::install::aliyun::sources()
{
   echo ${LINUX_PASSWORD} | curl -s https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | sudo apt-key add -
   echo ${LINUX_PASSWORD} | echo 'deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main' |sudo tee /etc/apt/sources.list.d/kubernetes.list
}

if [[ "$*" =~ "k8s::install" ]]; then
  eval "$*"
fi

