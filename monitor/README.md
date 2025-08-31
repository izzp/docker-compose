# monitor

本目录包含基于 Docker Compose 的监控栈示例：Prometheus、Grafana 及用于主机采集的 node_exporter 代理配置。

概览

- Prometheus：配置文件位于 `monitor/prometheus/prometheus.yml`，数据卷 `prometheus_data`。Compose 在 `monitor/compose.yml` 中定义。
- Grafana：在 `monitor/compose.yml` 中定义，默认管理账号在 `monitor/compose.yml` 中设置（请修改默认密码）。
- node_exporter + 代理（OpenResty）：每台被监控主机运行 `monitor/node` 下的 Compose，使用 OpenResty 作为反向代理（监听 39100）并通过 IP 白名单限制访问。代理配置位于 `monitor/node/nginx/conf.d/default.conf`。

快速使用

1. 启动整体监控（在监控主机）：

   ```powershell
   cd monitor
   docker compose up -d
   ```

2. 在每台被监控主机上（node）：
   - 进入 `monitor/node`，运行 `docker compose up -d`，该 Compose 会在主机上以 host 网络模式启动 `node_exporter`（绑定到 `127.0.0.1:9100`）和 `openresty` 代理（监听 0.0.0.0:9110）。
   - 编辑 `monitor/node/nginx/conf.d/default.conf`，将 `access_by_lua_block` 中的 allow 表替换为你的 Prometheus 抓取 IP 列表。

3. 配置 Prometheus 抓取（在 Prometheus 主机）
   - 编辑 `monitor/prometheus/prometheus.yml`，将 `targets` 替换为你的代理地址列表，例如：
     ```yaml
     static_configs:
       - targets: ['node1.example.com:39100','node2.example.com:39100']
     ```
   - 若使用 HTTP（非 TLS），可直接抓取；若使用 HTTPS，请配置 `tls_config` 或使用受信任证书。



文件位置参考

- `monitor/compose.yml`：监控栈主 Compose（Prometheus、Grafana、可选的 node_exporter）。
- `monitor/prometheus/prometheus.yml`：Prometheus 配置。
- `monitor/node/nginx/conf.d/default.conf`：OpenResty代理配置（IP 白名单）。
