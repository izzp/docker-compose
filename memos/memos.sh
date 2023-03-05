#!/bin/bash

# 控制台颜色
GREEN="\033[1;32m"
RESET="$(tput sgr0)"

docker-compose -p memos up -d

printf "${GREEN}"
cat <<EOF
==========memos已启动=========
      访问地址：ip:5230
===============================
EOF
printf "${RESET}"