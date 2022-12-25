#!/bin/bash

# 控制台颜色
GREEN="\033[1;32m"
RESET="$(tput sgr0)"

docker-compose -p nginx-proxy-manager up -d

printf "${GREEN}"
cat <<EOF
=======nginx-proxy-manager已启动=======
      访问地址：ip:81
      Email:  admin@example.com
      Password: changeme
======================================
EOF
printf "${RESET}"