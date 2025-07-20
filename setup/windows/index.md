---
layout: default
title: Windows Development Setup
---

# Windows Development Setup

Enterprise-grade Windows development environment setup with automated configuration and professional productivity tools.

## Features

- **Automated Setup**: PowerShell-based one-command installation
- **Enterprise Ready**: Professional tools and configurations for Windows
- **WSL2 Integration**: Linux development tools on Windows
- **Security Focused**: Windows security best practices
- **Productivity Optimized**: Streamlined development workflow

## Quick Start

```powershell
# Run in PowerShell as Administrator
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
git clone https://github.com/tiation/windows-dev-setup.git
cd windows-dev-setup
.\setup.ps1
```

## What's Included

- **Development Tools**: Git, Docker Desktop, Node.js, Python, Visual Studio Code
- **Windows Subsystem for Linux**: WSL2 with Ubuntu development environment
- **Package Management**: Chocolatey and Windows Package Manager
- **Terminal Enhancement**: Windows Terminal with PowerShell customization
- **Security Tools**: Windows security hardening and enterprise policies

## Enterprise Features

- **Domain Integration**: Active Directory and enterprise authentication
- **Group Policy**: Enterprise policy compliance
- **Security Hardening**: Windows security best practices
- **Automation**: Fully automated setup with PowerShell DSC

## System Requirements

- Windows 10 version 2004 or later, or Windows 11
- Administrator privileges
- Internet connection for package downloads
- 8GB RAM minimum (16GB recommended)

## Documentation

For detailed installation instructions and customization options, see the [README](README.md).

## Support

This setup script supports:
- Windows 10 Pro/Enterprise/Education
- Windows 11 Pro/Enterprise/Education
- Azure AD and on-premises Active Directory
- Enterprise security policies

---

*Enterprise Windows development environment by Tiation*
