# Windows Development Environment Setup

🚀 **Automated Windows Development Environment Setup Scripts**

A comprehensive collection of modular PowerShell scripts to set up a complete development environment on Windows systems. Perfect for developers who want to quickly bootstrap their Windows workstation with all essential tools and configurations.

## 🎯 What This Does

- **System Configuration**: Windows system preferences and tweaks
- **Package Management**: Chocolatey, Winget, and Scoop package managers
- **Development Environment**: Git, SSH, PowerShell setup, WSL configuration
- **Runtime Setup**: Node.js, Python, .NET, Java, and language-specific environments
- **Mobile Development**: Flutter, Android SDK, Visual Studio setup
- **Container & Kubernetes**: Docker Desktop, Kubernetes tools
- **Directory Structure**: Organized development workspace
- **IDE & Tools**: Visual Studio, VS Code, JetBrains IDEs, and extensions

## 📁 Repository Structure

```
windows-dev-setup/
├── scripts/
│   ├── 01_system_prefs.ps1        # System preferences and tweaks
│   ├── 02_package_mgmt.ps1        # Package management (Chocolatey, Winget, Scoop)
│   ├── 03_dev_env.ps1             # Development environment setup
│   ├── 04_mobile_dev.ps1          # Mobile development tools
│   ├── 05_cloud_devops.ps1        # Cloud and DevOps tools
│   ├── 06_workspace_setup.ps1     # Directory structure and workspace
│   ├── 07_ide_tools.ps1           # IDEs and development tools
│   └── setup_master.ps1           # Master orchestration script
├── docs/
│   └── windows_setup.md           # Detailed setup documentation
├── README.md                      # This file
├── SCRIPT_ANALYSIS.md             # Script analysis and categorization
├── FUNCTIONS_REFERENCE.md         # Common functions reference
└── LICENSE                        # MIT License
```

## 🚀 Quick Start

### Prerequisites
- **Windows 10 version 1903 or later** (Windows 11 recommended)
- **PowerShell 5.1 or PowerShell 7+**
- **Administrator privileges** for some installations
- **Internet connection**

### Option 1: Run Everything (Recommended for new setups)
```powershell
# Open PowerShell as Administrator
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
git clone https://github.com/tiation/windows-dev-setup.git
cd windows-dev-setup
.\scripts\setup_master.ps1
```

### Option 2: Run Individual Modules
```powershell
# System preferences and tweaks
.\scripts\01_system_prefs.ps1

# Install packages
.\scripts\02_package_mgmt.ps1

# Development environment
.\scripts\03_dev_env.ps1

# Mobile development tools
.\scripts\04_mobile_dev.ps1

# Cloud and DevOps tools
.\scripts\05_cloud_devops.ps1

# Workspace setup
.\scripts\06_workspace_setup.ps1

# IDEs and tools
.\scripts\07_ide_tools.ps1
```

### Option 3: Auto-run Mode (No prompts)
```powershell
.\scripts\setup_master.ps1 -AutoRun
```

## 🛠️ What Gets Installed

### Package Managers
- **Chocolatey** - Windows package manager
- **Winget** - Microsoft's package manager
- **Scoop** - Command-line installer for Windows

### Development Tools
- **Git** with Git Bash and credentials manager
- **Windows Terminal** with custom configurations
- **PowerShell 7** with modules and profiles
- **Windows Subsystem for Linux (WSL2)** with Ubuntu

### Programming Languages & Runtimes
- **Node.js** (via nvm-windows)
- **Python 3.11** with pip and virtual environments
- **.NET SDK** (latest LTS)
- **Java** (OpenJDK and Oracle)
- **Go** programming language
- **Rust** development environment

### Development Environments
- **Visual Studio 2022** (Community/Professional)
- **Visual Studio Code** with extensions
- **JetBrains IDEs** (IntelliJ, WebStorm, etc.)
- **Android Studio** for mobile development
- **Docker Desktop** for containerization

### Mobile Development
- **Flutter SDK** with Windows desktop support
- **Android SDK** and tools
- **React Native CLI**
- **Ionic CLI**
- **Xamarin** (with Visual Studio)

### Cloud & DevOps Tools
- **Docker Desktop** with Kubernetes
- **Azure CLI** and Azure PowerShell
- **AWS CLI** and AWS Tools for PowerShell
- **Google Cloud SDK**
- **Terraform** and infrastructure tools
- **Kubernetes** tools (kubectl, helm, k9s)

### Productivity Applications
- **Browsers**: Chrome, Firefox, Edge Dev
- **Communication**: Slack, Discord, Teams
- **Media**: VLC, OBS Studio
- **Utilities**: 7-Zip, WinRAR, PowerToys
- **Note-taking**: Obsidian, Notion

### System Enhancements
- **Windows Terminal** with Oh My Posh
- **PowerShell modules** for productivity
- **WSL2** with Ubuntu distribution
- **Hyper-V** for virtualization
- **Windows Features** optimization

## 🔧 Customization

Each script is modular and can be customized:

1. **Edit variables** at the top of each script
2. **Comment out** sections you don't need
3. **Add your own** package lists or configurations
4. **Modify prompts** for different confirmation behavior

## 📋 Prerequisites

- Windows 10 version 1903 or later (Windows 11 recommended)
- PowerShell 5.1 or PowerShell 7+
- Administrator privileges for some installations
- Internet connection
- At least 20GB free disk space

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test on a clean Windows installation
5. Submit a pull request

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

## 📖 Documentation

- [Detailed Setup Guide](docs/windows_setup.md)
- [Script Analysis](SCRIPT_ANALYSIS.md)
- [Functions Reference](FUNCTIONS_REFERENCE.md)

## 🔒 Security

- Scripts use official package repositories
- Execution policy is set appropriately
- No credentials are stored in scripts
- All downloads are from trusted sources

## 📜 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by various Windows setup scripts and dotfiles
- Built for developers who value automation and consistency
- Designed with security and modularity in mind

---

## 🎮 Gaming & Entertainment (Optional)

The scripts can optionally install:
- **Steam** gaming platform
- **Discord** for communication
- **OBS Studio** for streaming
- **VLC Media Player**
- **Spotify** desktop app

---

## 🏢 Enterprise Features

- **Windows Subsystem for Linux (WSL2)**
- **Hyper-V** virtualization
- **Windows Terminal** with custom profiles
- **PowerShell 7** with enterprise modules
- **Group Policy** compatible configurations

---

**⚡ Ready to supercharge your Windows development environment?**

```powershell
git clone https://github.com/tiation/windows-dev-setup.git && cd windows-dev-setup && .\scripts\setup_master.ps1
```

## Related Repositories

This repository is part of the Tiation GitHub ecosystem. For a complete overview of all repositories and their relationships, see the [Repository Index](./REPOSITORY_INDEX.md).

### Direct Dependencies
- [git-workspace](../git-workspace/) - Git workflow tools
- [workflows](../workflows/) - Automation workflows
- [server-configs-gae](../server-configs-gae/) - Server configurations

### Quick Links
- [Repository Index](./REPOSITORY_INDEX.md) - Complete repository overview
- [Development Setup](../ubuntu-dev-setup/README.md) - Development environment setup
- [Workflows](../workflows/) - CI/CD templates
- [Infrastructure](../server-configs-gae/) - Deployment configurations

---
*Part of the [Tiation](../tiation/) ecosystem*
