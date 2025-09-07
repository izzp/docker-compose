# Nacos Docker 部署

## 简介
此目录包含一个基于 Docker Compose 的 Nacos 部署示例，支持通过 `.env` 文件配置环境变量。

## 使用方法

1. 确保已安装 Docker 和 Docker Compose。
2. 编辑 `.env` 文件，根据需要修改环境变量。
3. 运行以下命令启动服务：

```powershell
docker compose up -d
```

4. 服务启动后，访问 `http://localhost:8848/nacos`。

## 文件说明

- `docker-compose.yml`：定义服务的 Docker Compose 配置文件。
- `.env`：环境变量配置文件。
- `config/custom.properties`：Nacos 自定义配置文件。

## 环境变量

- `MYSQL_SERVICE_HOST`：MySQL 数据库主机地址。
- `MYSQL_SERVICE_PORT`：MySQL 数据库端口。
- `MYSQL_SERVICE_DB_NAME`：Nacos 使用的数据库名称。
- `MYSQL_SERVICE_USER`：数据库用户名。
- `MYSQL_SERVICE_PASSWORD`：数据库密码。
- `JVM_XMS`：JVM 初始内存分配。
- `JVM_XMX`：JVM 最大内存分配。
- `JVM_XMN`：JVM 年轻代内存分配。

## 注意事项

- 确保 MySQL 数据库已启动并可用。
- 根据实际需求调整 `custom.properties` 和 `.env` 文件中的配置。