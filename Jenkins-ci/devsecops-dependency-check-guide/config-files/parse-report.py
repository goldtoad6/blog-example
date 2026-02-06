#!/usr/bin/env python3
"""
Dependency-Check 报告解析器
用于 CI/CD 流水线中的自动化处理
"""

import json
import sys
from dataclasses import dataclass
from typing import List, Optional
from datetime import datetime

@dataclass
class Vulnerability:
    cve: str
    severity: str
    cvss_score: float
    description: str
    fixed_version: Optional[str] = None

@dataclass
class Dependency:
    name: str
    version: str
    file_path: str
    vulnerabilities: List[Vulnerability]

class DependencyCheckParser:
    def __init__(self, report_path: str):
        with open(report_path, 'r', encoding='utf-8') as f:
            self.report = json.load(f)

    def get_summary(self) -> dict:
        """获取漏洞汇总统计"""
        vulns = self._extract_vulnerabilities()

        return {
            'total_dependencies': len(self.report.get('dependencies', [])),
            'vulnerable_dependencies': len([d for d in self.report.get('dependencies', [])
                                           if d.get('vulnerabilities')]),
            'total_vulnerabilities': len(vulns),
            'critical': len([v for v in vulns if v.cvss_score >= 9.0]),
            'high': len([v for v in vulns if 7.0 <= v.cvss_score < 9.0]),
            'medium': len([v for v in vulns if 4.0 <= v.cvss_score < 7.0]),
            'low': len([v for v in vulns if 0.1 <= v.cvss_score < 4.0]),
        }

    def get_vulnerabilities_by_severity(self, min_cvss: float = 0) -> List[Vulnerability]:
        """按严重程度获取漏洞列表"""
        all_vulns = self._extract_vulnerabilities()
        return [v for v in all_vulns if v.cvss_score >= min_cvss]

    def generate_markdown_report(self) -> str:
        """生成 Markdown 格式的报告摘要"""
        summary = self.get_summary()

        report = f"""# Dependency-Check 安全报告

## 扫描概况

- **扫描时间**: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
- **总依赖数**: {summary['total_dependencies']}
- **存在漏洞的依赖**: {summary['vulnerable_dependencies']}
- **漏洞总数**: {summary['total_vulnerabilities']}

## 漏洞分布

| 严重程度 | 数量 | 说明 |
|---------|------|------|
| 🔴 Critical | {summary['critical']} | CVSS 9.0-10.0 |
| 🟠 High | {summary['high']} | CVSS 7.0-8.9 |
| 🟡 Medium | {summary['medium']} | CVSS 4.0-6.9 |
| 🟢 Low | {summary['low']} | CVSS 0.1-3.9 |

## 高危漏洞详情

"""

        critical_high = self.get_vulnerabilities_by_severity(7.0)
        for vuln in critical_high[:10]:  # 只显示前10个
            report += f"""### {vuln.cve} ({vuln.severity})

- **CVSS Score**: {vuln.cvss_score}
- **影响组件**: {vuln.name}
- **漏洞描述**: {vuln.description[:200]}...

"""

        return report

    def _extract_vulnerabilities(self) -> List[Vulnerability]:
        """提取所有漏洞信息"""
        vulnerabilities = []

        for dep in self.report.get('dependencies', []):
            for vuln_data in dep.get('vulnerabilities', []):
                cvssv3 = vuln_data.get('cvssv3', {})
                vuln = Vulnerability(
                    cve=vuln_data.get('name', 'Unknown'),
                    severity=vuln_data.get('severity', 'Unknown'),
                    cvss_score=cvssv3.get('baseScore', 0),
                    description=vuln_data.get('description', 'No description'),
                    fixed_version=self._extract_fixed_version(vuln_data)
                )
                vulnerabilities.append(vuln)

        return vulnerabilities

    def _extract_fixed_version(self, vuln_data: dict) -> Optional[str]:
        """提取修复版本信息"""
        # 从漏洞数据中解析建议的修复版本
        for ref in vuln_data.get('references', []):
            if 'upgrade' in ref.get('name', '').lower():
                return ref.get('name')
        return None

def main():
    if len(sys.argv) < 2:
        print("Usage: python parse_report.py <report.json>")
        sys.exit(1)

    parser = DependencyCheckParser(sys.argv[1])
    summary = parser.get_summary()

    print(json.dumps(summary, indent=2))

    # 如果有严重漏洞，返回非0退出码
    if summary['critical'] > 0:
        sys.exit(1)

if __name__ == '__main__':
    main()
