install:
	curl -Lo ./kustomize https://github.com/kubernetes-sigs/kustomize/releases/download/v3.2.0/kustomize_3.2.0_linux_amd64
  chmod +x ./kustomize
  sudo mv kustomize /usr/local/bin
