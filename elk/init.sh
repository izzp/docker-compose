#!/bin/bash

# ELK Stack 完全初始化脚本
# 包含目录权限设置、Elasticsearch 启动、kibana_system 用户配置

set -e

echo "================================"
echo "ELK Stack 初始化"
echo "================================"
echo ""

# 1. 读取环境变量
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | grep -v '^$' | xargs)
else
    echo "错误: 找不到 .env 文件"
    exit 1
fi

# 2. 创建并设置目录权限
echo "1. 创建目录并设置权限..."
mkdir -p elasticsearch/data elasticsearch/logs
mkdir -p kibana/logs
mkdir -p logstash/data logstash/logs

sudo chown -R 1000:1000 elasticsearch/data elasticsearch/logs
sudo chown -R 1000:1000 logstash/data logstash/logs
sudo chmod -R 755 elasticsearch/data elasticsearch/logs logstash/data logstash/logs

echo "   ✓ 目录权限设置完成"

# 3. 启动 Elasticsearch
echo ""
echo "2. 启动 Elasticsearch..."
docker compose up -d elasticsearch

# 4. 等待 Elasticsearch 就绪
echo ""
echo "3. 等待 Elasticsearch 启动（约 1-2 分钟）..."
MAX_RETRIES=60
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -u "elastic:${ELASTIC_PASSWORD}" http://localhost:9200/_cluster/health 2>/dev/null)
    
    if [ "$RESPONSE" = "200" ]; then
        echo "   ✓ Elasticsearch 已就绪"
        break
    fi
    
    if [ $((RETRY_COUNT % 6)) -eq 0 ]; then
        echo "   等待中... (${RETRY_COUNT}s)"
    fi
    
    RETRY_COUNT=$((RETRY_COUNT + 1))
    sleep 5
done

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
    echo "   ✗ Elasticsearch 启动超时"
    echo "   查看日志: docker compose logs elasticsearch"
    exit 1
fi

# 5. 设置 kibana_system 密码
echo ""
echo "4. 设置 kibana_system 用户密码..."
RESULT=$(curl -s -w "\n%{http_code}" -X POST "http://localhost:9200/_security/user/kibana_system/_password" \
  -H "Content-Type: application/json" \
  -u "elastic:${ELASTIC_PASSWORD}" \
  -d "{\"password\": \"${KIBANA_SYSTEM_PASSWORD:-${ELASTIC_PASSWORD}}\"}")

HTTP_CODE=$(echo "$RESULT" | tail -n1)

if [ "$HTTP_CODE" = "200" ]; then
    echo "   ✓ kibana_system 密码设置成功"
else
    echo "   ✗ 设置密码失败 (HTTP $HTTP_CODE)"
    echo "$RESULT"
    exit 1
fi

# 6. 启动所有服务
echo ""
echo "5. 启动 Kibana 和 Logstash..."
docker compose up -d

echo ""
echo "================================"
echo "✓ ELK Stack 初始化完成！"
echo "================================"
echo ""
echo "访问信息:"
echo "  Kibana:    http://localhost:${KIBANA_PORT:-5601}"
echo "  用户名:    elastic"
echo "  密码:      ${ELASTIC_PASSWORD}"
echo ""
