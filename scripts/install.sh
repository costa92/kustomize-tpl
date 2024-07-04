#!/usr/bin/env bash

# Copyright 2023 The costalong.
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

set -o errexit
set -o nounset
set -o pipefail

# kustomize version
KUSTOMIZE_VERSION="v4.5.4"

# kustomize download url
KUSTOMIZE_DOWNLOAD_URL="https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_amd64.tar.gz"


# kustomize download path
KUSTOMIZE_DOWNLOAD_PATH="/tmp/kustomize.tar.gz"

# kustomize install path
KUSTOMIZE_INSTALL_PATH="/usr/local/bin/kustomize"

# kustomize install
install_kustomize() {
    echo "install kustomize"
    mkdir -p /tmp/kustomize
    wget -O ${KUSTOMIZE_DOWNLOAD_PATH} ${KUSTOMIZE_DOWNLOAD_URL}
    tar -zxvf ${KUSTOMIZE_DOWNLOAD_PATH} -C /tmp/kustomize
    sudo mv /tmp/kustomize/kustomize /usr/local/bin/kustomize
    rm -rf /tmp/kustomize
    rm -rf ${KUSTOMIZE_DOWNLOAD_PATH}
}

# kustomize version
kustomize_version() {
    kustomize version
}

# kustomize help
kustomize_help() {
    kustomize help
}

eval $(echo "$@")