#!/bin/bash

# 控制台颜色
GREEN="\033[1;32m"
RESET="$(tput sgr0)"

docker-compose -f compose-gitea.yaml -p gitea up -d

printf "${GREEN}"
cat <<EOF
=======Gitea已启动=======
   访问地址：ip:3000
   SSH地址：ip:222
=========================
EOF
printf "${RESET}"