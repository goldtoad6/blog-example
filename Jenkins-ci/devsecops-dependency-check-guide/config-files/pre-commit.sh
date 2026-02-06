#!/bin/sh
. "$(dirname "$0")/_/husky.sh"

cd frontend

# 运行 lint
npm run lint
if [ $? -ne 0 ]; then
    echo "❌ 代码检查失败，请修复后重试"
    exit 1
fi

# 运行依赖扫描（快速模式）
npm audit --audit-level=moderate
if [ $? -ne 0 ]; then
    echo "❌ 发现 npm 依赖漏洞"
    exit 1
fi

echo "✅ 预提交检查通过"
