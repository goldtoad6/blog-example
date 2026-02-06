# Windows PowerShell - 正确写法
docker run --rm `
    -v "${PWD}:/src" `
    -v "${PWD}\dc-data:/usr/share/dependency-check/data" `
    owasp/dependency-check:latest `
    --scan /src
