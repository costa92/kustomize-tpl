#!/usr/bin/env bash

# wget https://storage.googleapis.com/istio-release/releases/1.15.6/istio-1.15.6-linux-amd64.tar.gz &&
# tar zxvf istio-1.15.6-linux-amd64.tar.gz -C /usr/local/ &&
# istioctl install --set profile=demo -y 

WORD_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"

# TMP_DIR
TMP_DIR="${WORD_DIR}/tmp"

#  istio dir
ISTIO_DIR="${TMP_DIR}/istio"

# istio tmp dir
is_tmp_dir() {
    if [ ! -d "${TMP_DIR}" ]; then
        mkdir -p "${TMP_DIR}"
    fi
}


ISTIO_VERSION="1.15.6"

# istio download url
ISTIO_DOWNLOAD_URL="https://github.com/istio/istio/releases/download/${ISTIO_VERSION}/istio-${ISTIO_VERSION}-linux-amd64.tar.gz"
# istio download path
ISTIO_DOWNLOAD_PATH=${TMP_DIR}"/istio.tar.gz"
# istio install path
ISTIO_INSTALL_PATH="/usr/local/bin"

# istio install
install_istio() {
    echo "install istio"
    is_tmp_dir
    mkdir -p ${ISTIO_DIR}
    wget -O ${ISTIO_DOWNLOAD_PATH} ${ISTIO_DOWNLOAD_URL}
    tar -zxvf ${ISTIO_DOWNLOAD_PATH} -C ${ISTIO_DIR}
    sudo mv ${ISTIO_DIR}/istio-${ISTIO_VERSION}/bin/istioctl /usr/local/bin/istioctl
}

# istio check
istio_check() {
    if [ ! "$(command -v istioctl)" ]; then
        install_istio
    else 
        # istioctl version
        echo "istioctl is installed" 
    fi
}

# istio version
istio_version() {
    istioctl version
}

# istio help
istio_help() {
    istioctl help
}


istio_demo() {
    istioctl install --set profile=demo -y
}



eval $1