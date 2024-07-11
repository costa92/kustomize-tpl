# volumes

## 问题

1. 错误信息 GF_PATHS_DATA='/var/lib/grafana' is not writable 表明 Grafana 容器无法写入挂载在 /var/lib/grafana 的数据目录。这通常是由于挂载卷的权限设置不正确导致的。

解决： 主机上挂载的路径是 /data/monitoring/grafana

查看 Grafana 容器挂载的路径

```sh
ls -ld /data/monitoring/grafana
```

更改挂载卷的权限
```sh
mkdir -p /data/monitoring/grafana
chown -R 472:472 /data/monitoring/grafana
```

确保目录具有写权限：

```sh
chmod -R 777 /data/monitoring/grafana
```
