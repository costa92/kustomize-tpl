wget https://storage.googleapis.com/istio-release/releases/1.15.6/istio-1.15.6-linux-amd64.tar.gz &&
tar zxvf istio-1.15.6-linux-amd64.tar.gz -C /usr/local/ &&
istioctl install --set profile=demo -y 