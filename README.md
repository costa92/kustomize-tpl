# kustomize-tpl
kustomize 模板


## 开始安装
1. [安装 kustomize](docs/安装/kustomize/install.md)
2. 安装traefik

```sh
kubectl apply -k public/traefik/w
```
3. 安装kubernetes gateway

```sh
kubectl apply -k public/gateway/
```
4. [安装 istio](docs/安装/istio/install.md)

5. 安装 dev 空间

```sh
 kubectl apply -k overlays/dev/
```

### 使用的是 kubernetes gateway
6. 安装 Gateway
```sh
kubectl apply -f tcm/gw/blog-gw.yaml
```
7. 安装 dev blog

```sh
kubectl apply -k overlays/dev/blog-web/
```


### 使用的是 istio

6. 安装 Gateway

```sh
kubectl apply -f tcm/gw/blog-gv-istio.yaml
```

7. 安装 dev blog

```sh
kubectl apply -k overlays/dev/blog-web/
```

8. 安装 VirtualService

```sh
kubectl apply -f tcm/vs/blog-vs-istio.yaml
```


## 修改配置重启

```sh
kubectl rollout restart deployment prometheus -n prometheus
```

## 监控 
[kube-state-metrics](https://github.com/kubernetes/kube-state-metrics)
[docker ](https://hub.docker.com/r/bitnami/kube-state-metrics/tags)