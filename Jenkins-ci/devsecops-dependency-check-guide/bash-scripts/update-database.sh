#!/bin/bash

# 仅更新数据库（推荐首次运行）
dependency-check.sh --nvdApiKey YOUR_API_KEY --updateonly || {
    echo "错误：数据库更新失败"
    echo "请检查："
    echo "1. NVD API Key 是否正确"
    echo "2. 网络连接是否正常"
    exit 1
}
