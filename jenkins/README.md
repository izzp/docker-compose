# Jenkins

基于 Docker Compose 的 Jenkins 部署配置。

## 配置说明

编辑 `.env` 文件修改配置：

- `JENKINS_VERSION`: Jenkins 版本（默认：lts）
- `JENKINS_HTTP_PORT`: Web 访问端口（默认：19000）
- `JENKINS_AGENT_PORT`: Agent 连接端口（默认：50000）

## 启动服务

```bash
docker compose up -d
```

## 停止服务

```bash
docker compose down
```

## 查看日志

```bash
docker compose logs -f
```

## 初始密码

首次启动后，查看初始管理员密码：

```bash
docker logs jenkins
```

或从文件读取：

```bash
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

## 访问地址

http://localhost:19080

## 数据目录

- `./data` - Jenkins 主目录（包含配置、插件、任务等）

## 注意事项

- 容器以 root 用户运行，并挂载了 Docker socket，可直接使用 Docker 命令
- 确保宿主机端口未被占用
- 首次启动需要安装插件，可能需要较长时间
