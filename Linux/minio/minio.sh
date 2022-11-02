#!/bin/bash

# 控制台颜色
GREEN="\033[1;32m"
RESET="$(tput sgr0)"

docker-compose -p minio up -d

printf "${GREEN}"
cat <<EOF
=======minio已启动=======
 访问地址：ip:9001
 账号密码：root/password
=========================
EOF
printf "${RESET}"