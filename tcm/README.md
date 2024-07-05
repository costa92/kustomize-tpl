# tcm 文档

##  Gateway
### 1. 使用 gateway.networking
安装 Gateway
```yaml
apiVersion: gateway.networking.k8s.io/v1alpha2
kind: Gateway
metadata:
  name: blog-web-gateway
  namespace: dev  # namespace where the gateway is deployed
spec:
  gatewayClassName: traefik-gateway-class  #绑定的 GatewayClass 名称。
  listeners:  # 定义了一些监听项，供 Route 进行绑定
    - name: http #监听项名称。
      protocol: HTTP   #定义协议，HTTP或者HTTPS 
      port: 80   #监听项所占用的端口
      allowedRoutes:  #定义流量转发范围
        namespaces:
          from: All  #允许 Gateway 往所有的 Namespace 的 Pod 转发流量。
```

安装 httpRoute
```yaml
apiVersion: gateway.networking.k8s.io/v1alpha2
kind: HTTPRoute
metadata:
  name: blog-web-dev
  namespace: dev  # namespace where the gateway is deployed
  labels:
    app: blog-web
spec:
  parentRefs:   #绑定 Gateway 监听项
  - name: blog-web-gateway
  hostnames:     #为路由配置域名
  - hello-world.local  #可配置泛域名,可配置多个
  rules: #配置详细的路由规则，可配置多个，下面有对各种规则类型的详细解析
  - matches:  #匹配条件
    - path: #路径匹配
        type: PathPrefix  #路径类型：Exact 完全匹配/PathPrefix 前缀匹配/RegularExpression 正则匹配
        value: /
    backendRefs:  #后端路由
    - name: blog-web-service-dev # service 名称
      port: 80  #service 端口
      # weight: 100  #权重
```
### 2. 使用  networking.istio 
安装  Gateway
```yaml
apiVersion: networking.istio.io/v1beta1
kind: Gateway
metadata:
  name: blog-web-gateway-dev
  namespace: dev
spec:
  selector:
    istio: ingressgateway # use istio default controller
  servers:
    - hosts:
        - traefik.test.com  # 
      port:
        name: HTTP-80
        number: 80
        protocol: HTTP
```

安装 VirtualService
```yaml
# apiVersion: gateway.networking.k8s.io/v1beta1
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: blog-web-vs
  namespace: dev
spec:
  hosts:
  - "traefik.test.com"
  gateways:
  - blog-web-gateway-dev
  http:
  - match:
    - uri:
        prefix: /
    route:
    - destination:
        host:  blog-web-service-dev.dev.svc.cluster.local  # service 名称
        # subset: stable  # service 子集
```

注意： 使用 VirtualService 需要安装 IngressRoute
```yaml
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: blog-web-ingressroute
spec:
  entryPoints:
  - web
  routes:
  - match: Host(`traefik.test.com`) # 域名
    kind: Rule
    services:
      - name: istio-ingressgateway # 与svc的name一致
        port: 80      # 与svc的port一致
        namespace: istio-system # 与svc的namespace一致
        passHostHeader: true  # 是否传递host头
```
istio-ingressgateway:  是 istio的代理

```sh
kubectl get svc -n istio-system
```