#!/bin/bash
# dependency-check.sh - 封装脚本

set -e

DC_VERSION="latest"
DC_DIRECTORY="$HOME/OWASP-Dependency-Check"
DATA_DIRECTORY="$DC_DIRECTORY/data"
REPORT_DIRECTORY="$(pwd)/reports"

# 检查 NVD API Key
if [ -z "${NVD_API_KEY}" ]; then
    echo "错误：未设置 NVD_API_KEY 环境变量"
    echo "请先设置：export NVD_API_KEY=your_api_key"
    exit 1
fi

# 创建必要目录
echo "创建数据目录：$DATA_DIRECTORY"
mkdir -p "$DATA_DIRECTORY" || {
    echo "错误：创建数据目录失败"
    exit 1
}

echo "创建报告目录：$REPORT_DIRECTORY"
mkdir -p "$REPORT_DIRECTORY" || {
    echo "错误：创建报告目录失败"
    exit 1
}

# 运行扫描
echo "开始扫描项目：$(basename $(pwd))"
docker run --rm \
    -e user=$USER \
    -u $(id -u ${USER}):$(id -g ${USER}) \
    --volume $(pwd):/src:ro \
    --volume "$DATA_DIRECTORY":/usr/share/dependency-check/data:rw \
    --volume "$REPORT_DIRECTORY":/report:rw \
    owasp/dependency-check:$DC_VERSION \
    --nvdApiKey ${NVD_API_KEY} \
    --scan /src \
    --format "ALL" \
    --project "$(basename $(pwd))" \
    --out /report \
    --failOnCVSS 7 || {
    echo "错误：依赖扫描失败"
    exit 1
}

echo "扫描完成！报告已保存到：$REPORT_DIRECTORY"
