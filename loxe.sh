#!/bin/bash

# 用法:
#   loxe pull quay.io/prometheus/prometheus:v3.6.0

cmd=$1
image=$2

if [[ "$cmd" != "pull" ]]; then
    echo "用法: loxe pull <image>"
    exit 1
fi

if [[ -z "$image" ]]; then
    echo "缺少镜像名称"
    exit 1
fi

# ==== 去掉所有前缀 ====
# 支持 docker.io / quay.io / ghcr.io / registry.k8s.io / gcr.io 等
unprefixed_image=$(echo "$image" | awk -F'/' '{print $NF}')

# ==== 阿里云镜像仓库路径 ====
mirror="registry.cn-hangzhou.aliyuncs.com/imagehubs/${unprefixed_image}"

echo "==> 拉取: $mirror"
docker pull "$mirror" || exit 1

echo "==> 标记为: $unprefixed_image"
docker tag "$mirror" "$image" && docker rmi "$mirror"

echo "==> 完成"
