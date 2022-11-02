#!/bin/bash

# 控制台颜色
GREEN="\033[1;32m"
RESET="$(tput sgr0)"

docker-compose -p bark up -d

printf "${GREEN}"
cat <<EOF
======bark推送已启动======
    访问地址：ip:3002
==========================
EOF
printf "${RESET}"
