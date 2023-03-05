#!/bin/bash

# 控制台颜色
GREEN="\033[1;32m"
RESET="$(tput sgr0)"

docker-compose -p vaultwarden up -d

printf "${GREEN}"
cat <<EOF
=======vaultwarden已启动=======
      访问地址：ip:3001
===============================
EOF
printf "${RESET}"