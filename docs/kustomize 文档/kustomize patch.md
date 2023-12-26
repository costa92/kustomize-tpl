#kustomize patchs 

## use patches to add or override resources

new file: overlay/dev/sammy-app/service-patch.yaml

```yaml
- op: replace
  path: /spec/type
  value: LoadBalancer
  path: /spec/ports/0/targetPort
  value: 80
```
update file: overlay/dev/sammy-app/kustomization.yaml

```yaml
patches:
- path: configmap.yaml  
- target:
    version: v1  
    kind: Service 
    name: my-service
  path: service-patch.yaml
```

## 参考文档:
[Kustomize — use patches to add or override resources](https://medium.com/@giorgiodevops/kustomize-use-patches-to-add-or-override-resources-48ef65cb634c)
