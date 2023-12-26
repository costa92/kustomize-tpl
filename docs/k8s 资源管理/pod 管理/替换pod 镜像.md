# 不同的环境设置不同的镜像

## 1.设置 deployment.yaml 文件中镜像命名 

```yaml
...
spec:
  replicas: 1
  selector:
    matchLabels:
      app: sammy-app
  template:
    metadata:
      labels:
        app: sammy-app
    spec:
      containers:
      - name: server
        image: default_image  # 默认镜像
  
```

## 2.修改各个环境的 kustomization.yaml 文件
```yaml
images:
- name: default_image # 这个名字要与deployment.yaml 中的镜像名字一致
  newName: nginx
  newTag: v1.16    # 镜像版本
```

## 3.生成 yaml 文件
```shell
```shell
kubectl kustomize ./overlays/dev/sammy-app
```
查看镜像是否为 nginx:v1.16 


## 4.部署
```shell
kubectl apply -k ./overlays/dev/sammy-app
```


## 5.删除
```shell
kubectl delete -k ./overlays/dev/sammy-app
```

## 6. 命令修改镜像版本
```shell
kustomize set image nginx=nginx:v1.17
```


