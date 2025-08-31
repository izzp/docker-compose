# node 说明

使用 OpenResty 作为反向代理（IP 白名单），暴露 9110 给 Prometheus 抓取，node_exporter 以 host 网络运行并绑定到 127.0.0.1:9100。

快速使用：
1. 进入目录：
   cd monitor/node

2. 编辑 `nginx/conf.d/default.conf`，将 Lua 白名单替换为你的 Prometheus 抓取主机 IP。

3. 运行：
   docker-compose up -d

如何检查与重启：
- 查看容器状态：
  docker-compose ps

- 查看代理日志（实时）：
  docker-compose logs -f node_exporter_proxy

- 检查代理是否能访问 metrics（在 node 主机上执行）：
- 
  curl -sS http://127.0.0.1:9110/metrics | head -n 10

- 重启服务：
  docker-compose restart

停止并移除：
  docker-compose down

Prometheus 配置提示：
- 在 Prometheus 主机的 `prometheus.yml` 中把对应 node 的 target 设置为 `node-host:9110`（使用 node 的可达 IP）。