#!/bin/bash

# 控制台颜色
GREEN="\033[1;32m"
RESET="$(tput sgr0)"

docker-compose -p qbittorrent up -d

printf "${GREEN}"
cat <<EOF
=======qbittorrent已启动=======
 访问地址：ip:8080
==============================
EOF
printf "${RESET}"