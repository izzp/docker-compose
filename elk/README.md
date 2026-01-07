# ELK Stack 9.2.1

基于 Docker Compose 的 ELK (Elasticsearch + Logstash + Kibana) 日志收集系统，用于收集 Spring Boot 和其他应用的日志。

## 版本信息

- Elasticsearch: 9.2.1
- Logstash: 9.2.1
- Kibana: 9.2.1

## 快速开始

### 1. 配置环境变量

编辑 `.env` 文件设置密码和资源配置：

```env
ELASTIC_PASSWORD=your_secure_password       # 修改为强密码
KIBANA_SYSTEM_PASSWORD=your_secure_password # Kibana 用户密码（可选，默认同上）
ES_HEAP_SIZE=1g                             # Elasticsearch 堆内存
LS_HEAP_SIZE=512m                           # Logstash 堆内存
```

### 2. 运行初始化脚本 (Linux/macOS)

首次部署时运行初始化脚本，它会自动完成所有设置：

```bash
chmod +x init.sh
./init.sh
```

脚本会自动完成：
- 创建并设置目录权限
- 启动 Elasticsearch 并等待就绪
- 配置 kibana_system 用户
- 启动所有服务

### 3. 访问 Kibana

- URL: http://localhost:5601
- 用户名: `elastic`
- 密码: 在 `.env` 中设置的 `ELASTIC_PASSWORD`

## 端口说明

| 服务 | 端口 | 说明 |
|------|------|------|
| Elasticsearch | 9200 | HTTP API |
| Elasticsearch | 9300 | 集群通信 |
| Kibana | 5601 | Web 界面 |
| Logstash | 38001 | TCP 日志输入 (Spring Boot) |
| Logstash | 5044 | Beats 输入 |
| Logstash | 9600 | 监控 API |

## 目录结构

```
elk/
├── .env                           # 环境变量配置
├── .env.example                   # 环境变量模板
├── .gitignore                     # Git 忽略文件
├── README.md                      # 说明文档
├── compose.yaml                   # Docker Compose 配置
├── elasticsearch/
│   ├── config/
│   │   └── elasticsearch.yml  # ES 配置
│   ├── data/                  # ES 数据目录
│   └── logs/                  # ES 日志目录
├── kibana/
│   └── config/
│       └── kibana.yml         # Kibana 配置
└── logstash/
    ├── config/
    │   ├── logstash.yml       # Logstash 配置
    │   └── pipelines/
    │       └── logstash.conf  # Pipeline 配置
    ├── data/                  # Logstash 数据
    └── logs/                  # Logstash 日志
```

## 配置项说明

### `.env` 文件配置

| 配置项 | 默认值 | 说明 |
|--------|--------|------|
| ELK_VERSION | 9.2.1 | ELK 版本 |
| ELASTIC_PASSWORD | changeme | Elasticsearch 密码 (必须修改) |
| ES_HEAP_SIZE | 1g | Elasticsearch 堆内存大小 |
| LS_HEAP_SIZE | 512m | Logstash 堆内存大小 |
| ES_PORT | 9200 | Elasticsearch 端口 |
| KIBANA_PORT | 5601 | Kibana 端口 |
| LOGSTASH_TCP_PORT | 38001 | Logstash TCP 输入端口 |
| LOGSTASH_BEATS_PORT | 5044 | Logstash Beats 输入端口 |

## 资源限制

- Elasticsearch: 2 CPU / 2GB 内存
- Kibana: 1 CPU / 1GB 内存
- Logstash: 1 CPU / 1GB 内存

## 常用命令

```bash
# 启动服务
docker compose up -d

# 停止服务
docker compose down

# 查看日志
docker compose logs -f

# 查看特定服务日志
docker compose logs -f elasticsearch
docker compose logs -f kibana
docker compose logs -f logstash

# 重启服务
docker compose restart

# 查看服务状态
docker compose ps

# 清理数据并重新启动
docker compose down -v
docker compose up -d
```

### 3. 索引生命周期管理

可在 Kibana 中配置 ILM (Index Lifecycle Management) 自动管理索引：

#### 配置步骤

1. **访问 ILM 管理页面**
   - 登录 Kibana
   - 导航至：`Stack Management` → `Index Lifecycle Policies`

2. **创建生命周期策略**
   
   点击 `Create policy`，配置以下阶段：
   
   - **Hot 阶段**（活跃数据）
     - Rollover: 当索引大小达到 50GB 或时间达到 1 天时滚动
     - Max age: 1d
     - Max size: 50gb
   
   - **Warm 阶段**（历史数据）
     - Min age: 3d（3天后进入）
     - Shrink: 收缩分片数量
     - Force merge: 合并段以优化存储
   
   - **Cold 阶段**（冷数据）
     - Min age: 7d（7天后进入）
     - Searchable snapshot: 转换为可搜索快照
   
   - **Delete 阶段**（删除）
     - Min age: 30d（30天后删除）

#### 监控 ILM 执行

在 Kibana 中查看 ILM 执行状态：
- `Stack Management` → `Index Management`
- 查看索引的 `Lifecycle` 列，显示当前阶段
- 点击索引可查看详细的生命周期信息
