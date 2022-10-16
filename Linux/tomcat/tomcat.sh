#!/bin/bash

# 控制台颜色
GREEN="\033[1;32m"
RESET="$(tput sgr0)"

docker-compose -f docker-compose-tomcat.yml -p tomcat up -d

printf "${GREEN}"
cat <<EOF
=======Tomcat已启动=======
    访问地址：ip:8080
==========================
EOF
printf "${RESET}"