#!/bin/bash

# 基础扫描
dependency-check.sh \
    --project "MyApplication" \
    --scan "/path/to/project" \
    --out "/path/to/reports" \
    --format HTML

# 完整参数示例
dependency-check.sh \
    --project "E-Commerce Platform" \
    --scan "/workspace/ecommerce" \
    --out "/reports/dependency-check" \
    --format ALL \
    --nvdApiKey YOUR_API_KEY \
    --failOnCVSS 7 \
    --enableExperimental
