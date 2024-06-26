#!/bin/bash

# 容器名称
CONTAINER_NAME="x-ui-v1"

# 日志文件名
LOG_FILE="update-geo.txt"

# 获取当前时间并格式化
CURRENT_TIME=$(date +"%Y-%m-%d %H:%M:%S")

echo "当前时间：$CURRENT_TIME"

# 下载 geoip.dat 文件并保存为 geoip.dat
curl -L -o geoip.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat

# 下载 geosite.dat 文件并保存为 geosite.dat
curl -L -o geosite.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat

# 获取容器 ID
CONTAINER_ID=$(docker ps -qf "name=${CONTAINER_NAME}")

if [ -z "$CONTAINER_ID" ]; then
  echo "未找到名称为 ${CONTAINER_NAME} 的运行中的容器。"
  exit 1
fi

# 将文件复制到容器的 /root/bin 目录下
docker cp geoip.dat ${CONTAINER_ID}:/root/bin/geoip.dat
docker cp geosite.dat ${CONTAINER_ID}:/root/bin/geosite.dat

# 清理本地下载的文件
rm geoip.dat geosite.dat

echo "文件已成功移动到容器 ${CONTAINER_NAME} 的 /root/bin 目录下。"

# 重启容器
docker restart ${CONTAINER_NAME}
