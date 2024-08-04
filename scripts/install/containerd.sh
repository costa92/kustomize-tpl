#!/usr/bin/evn bash

# 项目的目录
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)"
# load 
source "${PROJECT_ROOT}/scripts/install/common.sh"


containerd::check(){
  echo "start check ..."
}

containerd::lib::install()
{

  conn::util::sudo "apt-get update -y"
  conn::util::sudo "apt install ca-certificates curl gnupg lsb-release -y"
}

containerd::install()
{
  echo "start installl ..."  
  # install lib
  # containerd::lib::install
  
  # 
}


# 下载 containerd 相关的文件
containerd::download() {
   echo "start download containerd ..."
   download::install::containerd
   echo "start service install"
   containerd::service::install
   echo "start install runc"
   containerd::install::runc
   echo "install cni plugins"
   containerd::install:cri
   echo "install nerdctl "
   containerd::install::nerdctl
   echo "install crictl "
   contalnerd::install::crictl
   echo  "end downlaod containerd ..."

   echo "启动containerd服务"

   conn::util::sudo "systemctl daemon-reload"
   conn::util::sudo "systemctl enable containerd.service"
   conn::util::sudo "systemctl restart containerd.service"
}


download::install::containerd() {
  local download_dir="${TMP_PATH}/containerd"
  echo $download_dir
  conn::util::create::directory $download_dir
  # 判断是否已经下载过
  if [ ! -e "${download_dir}/containerd-${ContainerdVersion}-linux-amd64.tar.gz" ];then
    wget -P $download_dir https://github.com/containerd/containerd/releases/download/v${ContainerdVersion}/containerd-${ContainerdVersion}-linux-amd64.tar.gz
  fi

  conn::util::sudo "tar Cxzvf /usr/local ${download_dir}/containerd-${ContainerdVersion}-linux-amd64.tar.gz"
}


containerd::service::install()
{
  local service_path="${TMP_PATH}/containerd/containerd.service"
  cat <<EOF | tee ${service_path} 

# Copyright The containerd Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

[Unit]
Description=containerd container runtime
Documentation=https://containerd.io
After=network.target local-fs.target

[Service]
ExecStartPre=-/sbin/modprobe overlay
ExecStart=/usr/local/bin/containerd

Type=notify
Delegate=yes
KillMode=process
Restart=always
RestartSec=5
# Having non-zero Limit*s causes performance problems due to accounting overhead
# in the kernel. We recommend using cgroups to do container-local accounting.
LimitNPROC=infinity
LimitCORE=infinity
LimitNOFILE=infinity
# Comment TasksMax if your systemd version does not supports it.
# Only systemd 226 and above support this version.
TasksMax=infinity
OOMScoreAdjust=-999

[Install]
WantedBy=multi-user.target
EOF

  conn::util::sudo "mv ${service_path} /lib/systemd/system/"
  if command -v "containerd" >/dev/null 2>&1; then
    conn::util::sudo "mkdir -p /etc/containerd/"
    local tmp_file="${TMP_PATH}/containerd/config.toml"
    containerd config default > "${tmp_file}" 
    sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' ${tmp_file}
    sed -i "s|sandbox_image = \"registry.k8s.io/pause:3.8\"|sandbox_image = \"registry.aliyuncs.com/google_containers/pause:3.9\"|" ${tmp_file}
    sed -i '/\[plugins\."io.containerd.grpc.v1.cri"\.registry\.mirrors\]/a \ \ \ \ \ \ \ \ [plugins."io.containerd.grpc.v1.cri".registry.mirrors."docker.io"]\n \ \ \ \ \ \  \ \ endpoint = ["https://hub-mirror.c.163.com"]' ${tmp_file}
    conn::util::sudo "mv ${tmp_file} /etc/containerd/config.toml"
  fi
}


containerd::install::runc()
{

  local download_dir="${TMP_PATH}/containerd"
  echo $download_dir
  conn::util::create::directory $download_dir
  # 判断是否已经下载过
  if [ ! -e "${download_dir}/runc.amd64" ]; then
    wget -P $download_dir https://github.com/opencontainers/runc/releases/download/v${RuncVersion}/runc.amd64
  fi
  
  conn::util::sudo "mv ${download_dir}/unc.amd64 /usr/local/bin/runc"
  conn::util::sudo "chmod +x /usr/local/bin/runc"

}


containerd::install:cri()
{
  
	local download_dir="${TMP_PATH}/containerd"
  echo $download_dir
  conn::util::create::directory $download_dir
  # 判断是否已经下载过
  if [ ! -e "${download_dir}/cni-plugins-linux-amd64-v${CniVersion}.tgz" ]; then
    wget -P $download_dir https://github.com/containernetworking/plugins/releases/download/v${CniVersion}/cni-plugins-linux-amd64-v${CniVersion}.tgz
  fi

  conn::util::sudo "mkdir -p /opt/cni/bin"
  conn::util::sudo "tar Cxzvf /opt/cni/bin ${download_dir}/cni-plugins-linux-amd64-v${CniVersion}.tgz"

}

containerd::install::nerdctl()
{

  local download_dir="${TMP_PATH}/containerd"
  echo $download_dir
  conn::util::create::directory $download_dir
  # 判断是否已经下载过
  if [ ! -e "${download_dir}/nerdctl-${NerdctlVersion}-linux-amd64.tar.gz" ]; then
    wget -P $download_dir  https://github.com/containerd/nerdctl/releases/download/v${NerdctlVersion}/nerdctl-${NerdctlVersion}-linux-amd64.tar.gz
  fi

  conn::util::sudo "tar Cxzvf /usr/local/bin ${download_dir}/nerdctl-${NerdctlVersion}-linux-amd64.tar.gz"

}


contalnerd::install::crictl()
{

  local download_dir="${TMP_PATH}/containerd"
  echo $download_dir
  conn::util::create::directory $download_dir
  # 判断是否已经下载过
  if [ ! -e "${download_dir}/crictl-v${CrictlVersion}-linux-amd64.tar.gz" ]; then
    wget -P $download_dir https://github.com/kubernetes-sigs/cri-tools/releases/download/v${CrictlVersion}/crictl-v${CrictlVersion}-linux-amd64.tar.gz
  fi

  conn::util::sudo "tar Cxzvf /usr/local/bin ${download_dir}/crictl-v${CrictlVersion}-linux-amd64.tar.gz"

  cat > ${download_dir}/crictl.yaml << \EOF
runtime-endpoint: unix:///run/containerd/containerd.sock
image-endpoint: unix:///run/containerd/containerd.sock
timeout: 2
debug: false
pull-image-on-create: false
EOF

  conn::util::sudo "mv ${download_dir}/crictl.yaml /etc/crictl.yaml"
}


if [[ "$*" =~ containerd:: ]];then
  eval $*
fi
