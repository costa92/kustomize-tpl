# 安装 KubernetesGateway

## 安装命令
```sh
=> kubectl apply -k public/gateway/
```

## 验证

```sh
=> kubectl get GatewayClass 

NAME                    CONTROLLER   AGE
traefik-gateway-class                9m51s
```