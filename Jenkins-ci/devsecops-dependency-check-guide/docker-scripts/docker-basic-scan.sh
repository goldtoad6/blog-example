# 基础扫描
docker run --rm \
    -v $(pwd):/src \
    -v $(pwd)/reports:/report \
    owasp/dependency-check:latest \
    --scan /src \
    --format ALL \
    --project "MyProject" \
    --out /report
