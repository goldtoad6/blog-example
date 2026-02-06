#!/bin/bash

set -e

echo "开始安装 Dependency-Check..."

# 下载最新版本（以 12.1.0 为例）
wget https://github.com/jeremylong/DependencyCheck/releases/download/v12.1.0/dependency-check-12.1.0-release.zip || {
    echo "错误：下载失败，请检查网络连接"
    exit 1
}

# 解压
unzip dependency-check-12.1.0-release.zip -d /opt/dependency-check || {
    echo "错误：解压失败"
    exit 1
}

# 添加到 PATH（Linux/Mac）
export PATH=$PATH:/opt/dependency-check/bin

# 验证安装
dependency-check.sh --version || {
    echo "错误：安装验证失败"
    exit 1
}

echo "✅ Dependency-Check 安装成功"
