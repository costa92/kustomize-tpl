# kustomizatio 命令


## 生成yaml文件

```bash
kustomize build . 
```

eg:
```bash
kustomize build  overlays/dev/sammy-app
```

## 应用kusomize
```bash
kubectl apply -k .
```

eg:
```bash
kubectl apply -k ./overlays/dev/sammy-app/
configmap/sammy-app-dev created
service/my-service-dev created
service/sammy-app-dev created
deployment.apps/sammy-app-dev created
```

## 删除kustomize
```bash
kubectl delete -k ./overlays/dev/sammy-app/
```

参考：

[kubernetes](https://kubernetes.io/zh-cn/docs/tasks/manage-kubernetes-objects/kustomization/)
