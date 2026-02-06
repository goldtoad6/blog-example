# 限制内存占用的 Docker 命令
docker run --rm \
    --memory="2g" \
    --memory-swap="2g" \
    -v $(pwd):/src \
    -v $(pwd)/dc-data:/usr/share/dependency-check/data \
    owasp/dependency-check:latest \
    --scan /src
