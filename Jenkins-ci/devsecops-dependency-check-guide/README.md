# Dependency-Check 代码示例与配置文件

本目录包含从《打造 DevSecOps：以 Dependency-Check 为核心的安全实践指南》文档中提取的所有代码示例和配置文件，按类别整理，便于直接使用或参考。

## 目录结构

```
Dependency-Check/
├── bash-scripts/           # Bash 脚本（Linux/Mac）
├── config-files/           # 配置文件
├── docker-scripts/         # Docker 相关脚本
├── powershell-scripts/     # PowerShell 脚本（Windows）
└── README.md              # 本文件
```

## 文件说明

### 📁 bash-scripts/

Bash 脚本，适用于 Linux/Mac 环境。

| 文件名 | 说明 |
|--------|------|
| [install-dependency-check.sh](bash-scripts/install-dependency-check.sh) | Dependency-Check 安装脚本，包含下载、解压、验证安装 |
| [update-database.sh](bash-scripts/update-database.sh) | 更新漏洞数据库脚本（推荐首次运行） |
| [basic-scan.sh](bash-scripts/basic-scan.sh) | 基础扫描命令示例，包含基础和完整参数两种用法 |

### 📁 config-files/

各类配置文件，涵盖 Maven、npm、Jenkins、抑制规则等。

| 文件名 | 说明 |
|--------|------|
| [dependency-check.properties](config-files/dependency-check.properties) | Dependency-Check 属性配置文件，包含 NVD、代理、扫描等完整配置 |
| [pom-maven-plugin.xml](config-files/pom-maven-plugin.xml) | Maven 插件基础配置示例 |
| [pom-complete.xml](config-files/pom-complete.xml) | 完整的 Spring Boot + Dependency-Check + SonarQube 配置，包含多环境 Profile |
| [pom-sonarqube.xml](config-files/pom-sonarqube.xml) | SonarQube 集成配置片段 |
| [package.json](config-files/package.json) | npm 项目配置，包含 Dependency-Check 扫描脚本 |
| [Jenkinsfile](config-files/Jenkinsfile) | 完整的 Jenkins Pipeline 配置，包含安全扫描、门禁、容器扫描等 |
| [dependency-check-suppressions.xml](config-files/dependency-check-suppressions.xml) | 基础抑制文件示例 |
| [suppressions-detailed.xml](config-files/suppressions-detailed.xml) | 详细的抑制文件示例，包含多种抑制规则类型（CVE、CPE、文件路径、GAV、临时抑制） |
| [pre-commit.sh](config-files/pre-commit.sh) | Git 预提交钩子脚本，用于前端项目提交前自动检查 |
| [parse-report.py](config-files/parse-report.py) | Python 报告解析器，用于 CI/CD 流水线中的自动化处理 |

### 📁 docker-scripts/

Docker 相关脚本，适用于容器化部署和 CI/CD 场景。

| 文件名 | 说明 |
|--------|------|
| [docker-dependency-check.sh](docker-scripts/docker-dependency-check.sh) | Docker 封装脚本，带数据缓存优化，大幅提升扫描速度 |
| [docker-basic-scan.sh](docker-scripts/docker-basic-scan.sh) | Docker 基础扫描命令 |
| [docker-memory-limited.sh](docker-scripts/docker-memory-limited.sh) | 限制内存占用的 Docker 扫描命令，适用于资源受限环境 |

### 📁 powershell-scripts/

PowerShell 脚本，适用于 Windows 环境。

| 文件名 | 说明 |
|--------|------|
| [docker-windows.ps1](powershell-scripts/docker-windows.ps1) | Windows PowerShell 环境下的 Docker 命令示例 |

## 快速开始

### 1. 命令行方式（Linux/Mac）

```bash
# 安装
bash bash-scripts/install-dependency-check.sh

# 更新数据库
bash bash-scripts/update-database.sh

# 扫描项目
bash bash-scripts/basic-scan.sh
```

### 2. Docker 方式

```bash
# 基础扫描
bash docker-scripts/docker-basic-scan.sh

# 带数据缓存的扫描（推荐）
bash docker-scripts/docker-dependency-check.sh
```

### 3. Maven 项目集成

将 `config-files/pom-complete.xml` 中的配置复制到你的 `pom.xml`：

```xml
<plugin>
    <groupId>org.owasp</groupId>
    <artifactId>dependency-check-maven</artifactId>
    <version>12.1.0</version>
    <configuration>
        <nvdApiKey>${env.NVD_API_KEY}</nvdApiKey>
        <failBuildOnCVSS>7</failBuildOnCVSS>
        <format>ALL</format>
        <suppressionFiles>
            <suppressionFile>dependency-check-suppressions.xml</suppressionFile>
        </suppressionFiles>
    </configuration>
</plugin>
```

运行扫描：

```bash
mvn dependency-check:check
```

### 4. npm 项目集成

将 `config-files/package.json` 中的脚本添加到你的 `package.json`：

```json
{
  "scripts": {
    "owasp:check": "dependency-check --project MyProject --scan package.json --format HTML --out reports"
  }
}
```

运行扫描：

```bash
npm run owasp:check
```

### 5. Jenkins CI/CD 集成

将 `config-files/Jenkinsfile` 复制到项目根目录，根据实际情况修改：

- 修改 `NVD_API_KEY` credentials 名称
- 修改 `DOCKER_REGISTRY` 地址
- 修改 `APP_NAME` 项目名称

### 6. 抑制文件使用

将 `config-files/suppressions-detailed.xml` 复制到项目根目录，并根据实际情况修改抑制规则。

**重要提示**：
- 每条抑制规则必须包含详细的 `notes` 说明
- 定期审查抑制规则（建议每季度）
- 抑制文件应纳入版本控制

## 配置说明

### NVD API Key

强烈建议申请 NVD API Key 以提升扫描速度：

1. 访问 https://nvd.nist.gov/developers/request-an-api-key
2. 填写信息并验证邮箱
3. 将 API Key 配置到环境变量或配置文件中

**环境变量配置**：
```bash
export NVD_API_KEY=your_api_key_here
```

**配置文件配置**：
```properties
nvd.api.key=YOUR_NVD_API_KEY_HERE
```

### CVSS 阈值

根据项目安全要求设置不同的 CVSS 阈值：

| 环境 | 阈值 | 说明 |
|------|--------|------|
| 开发环境 | 11（不阻断） | 允许所有漏洞通过 |
| 测试环境 | 7 | 阻断高危及以上漏洞 |
| 生产环境 | 5 | 严格检查，阻断中危及以上漏洞 |

### 数据持久化（Docker）

使用数据卷映射缓存漏洞数据库，避免每次重新下载：

```bash
docker run --rm \
    -v $(pwd):/src:ro \
    -v /path/to/dc-data:/usr/share/dependency-check/data:rw \
    owasp/dependency-check:latest \
    --scan /src
```

## 最佳实践

### 1. 安全门禁策略

- **严重漏洞（CVSS >= 9.0）**：必须阻断发布
- **高危漏洞（CVSS >= 7.0）**：需要安全团队确认后才能发布
- **中危漏洞（CVSS >= 4.0）**：标记为不稳定，安排修复计划

### 2. 抑制文件管理

- 每条抑制规则必须包含详细的说明
- 包含审核日期和审核人信息
- 设置临时抑制的过期日期
- 每季度审查并清理过期规则

### 3. CI/CD 集成

- 在构建阶段执行依赖扫描
- 并行执行后端和前端扫描
- 使用安全门禁自动阻断不安全的发布
- 集成 SonarQube 统一查看代码质量和安全

### 4. 性能优化

- 使用 Docker 数据卷缓存漏洞数据库
- 设置定时任务定期更新数据库
- 大型项目采用增量扫描策略
- 限制内存占用避免资源耗尽

## 常见问题

### Q1: 首次扫描为什么这么慢？

首次扫描需要下载完整的漏洞数据库（约 2GB），可能需要数小时。建议：
- 申请 NVD API Key 提升下载速度
- 使用 Docker 数据卷缓存数据库
- 设置定时任务定期更新

### Q2: 如何处理误报？

使用抑制文件排除误报：
- 按 CVE 编号抑制
- 按 CPE 标识抑制
- 按文件路径抑制
- 按 Maven GAV 抑制

### Q3: Windows 环境如何使用？

- 使用 PowerShell 脚本（`powershell-scripts/docker-windows.ps1`）
- 注意路径分隔符问题，使用正斜杠 `/`
- 使用 `$(PWD)` 自动处理路径转换

### Q4: 如何集成到现有 CI/CD？

参考 `config-files/Jenkinsfile`，根据你的 CI/CD 工具调整：
- Jenkins：直接使用提供的 Jenkinsfile
- GitLab CI：转换为 `.gitlab-ci.yml`
- GitHub Actions：转换为 `.github/workflows/`

## 参考资料

- [Dependency-Check 官方文档](https://jeremylong.github.io/DependencyCheck/)
- [NVD 漏洞数据库](https://nvd.nist.gov/)
- [OWASP 官网](https://owasp.org/)
- [完整指南文档](devsecops-dependency-check-guide.md)

## 版本信息

- Dependency-Check 版本：12.1.0
- 文档版本：基于 2025 年 2 月 17 日发布的版本编写
- 注意：该项目已于 2025 年 9 月 27 日归档，不再维护

## 替代方案

由于 Dependency-Check 已归档，建议关注以下活跃维护的替代方案：

- [Snyk](https://snyk.io/) - 商业工具，有免费版
- [Trivy](https://aquasecurity.github.io/trivy/) - 开源，支持容器和依赖扫描
- [Grype](https://github.com/anchore/grype) - 开源，专注于漏洞扫描

## 许可证

本目录中的代码示例和配置文件基于原文档内容整理，仅供学习和参考使用。
