# Windows Development Environment Setup Guide

This guide provides detailed instructions for setting up a complete development environment on Windows systems using the automated PowerShell scripts.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Detailed Setup](#detailed-setup)
- [Script Overview](#script-overview)
- [Customization](#customization)
- [Troubleshooting](#troubleshooting)
- [Post-Setup](#post-setup)

## Prerequisites

### System Requirements

- **Windows 10 version 1903 or later** (Windows 11 recommended)
- **PowerShell 5.1 or PowerShell 7+**
- **Administrator privileges** for some installations
- **Internet connection** for downloading packages
- **At least 20GB free disk space**

### Before You Begin

1. **Update Windows**:
   ```powershell
   # Check for Windows updates
   Get-WindowsUpdate -Install -AcceptAll -AutoReboot
   ```

2. **Install Git** (if not already installed):
   ```powershell
   winget install Git.Git
   ```

3. **Clone the repository**:
   ```powershell
   git clone https://github.com/tiation/windows-dev-setup.git
   cd windows-dev-setup
   ```

4. **Set execution policy**:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

## Quick Start

### Option 1: Complete Automated Setup

Run everything automatically without prompts:

```powershell
.\scripts\setup_master.ps1 -AutoRun
```

### Option 2: Interactive Setup

Run the master script with prompts for each component:

```powershell
.\scripts\setup_master.ps1
```

### Option 3: Individual Scripts

Run specific setup scripts as needed:

```powershell
# System preferences
.\scripts\01_system_prefs.ps1

# Package management
.\scripts\02_package_mgmt.ps1

# Development environment
.\scripts\03_dev_env.ps1
```

## Detailed Setup

### 1. System Preferences & Tweaks

**Script**: `01_system_prefs.ps1`

**What it does**:
- Configures Windows dark theme
- Optimizes system performance settings
- Enables Windows features (WSL2, Hyper-V)
- Configures power settings
- Sets up Windows Terminal
- Installs PowerToys

**Manual run**:
```powershell
.\scripts\01_system_prefs.ps1
```

### 2. Package Management

**Script**: `02_package_mgmt.ps1`

**What it does**:
- Installs Chocolatey package manager
- Installs Winget (Windows Package Manager)
- Installs Scoop command-line installer
- Installs development tools and applications
- Configures package managers for optimal use

**Manual run**:
```powershell
.\scripts\02_package_mgmt.ps1
```

### 3. Development Environment

**Script**: `03_dev_env.ps1`

**What it does**:
- Configures Git with user information and aliases
- Sets up SSH keys and GitHub integration
- Installs and configures PowerShell 7
- Sets up Windows Subsystem for Linux (WSL2)
- Configures PowerShell profile with modules
- Sets up development environment variables

**Manual run**:
```powershell
.\scripts\03_dev_env.ps1
```

### 4. Mobile Development

**Script**: `04_mobile_dev.ps1`

**What it does**:
- Installs Visual Studio with mobile workloads
- Installs Android Studio and SDK
- Sets up Flutter development environment
- Configures Xamarin development
- Installs React Native CLI
- Sets up mobile development tools

**Manual run**:
```powershell
.\scripts\04_mobile_dev.ps1
```

### 5. Cloud & DevOps Tools

**Script**: `05_cloud_devops.ps1`

**What it does**:
- Installs Docker Desktop with Kubernetes
- Sets up Azure CLI and Azure PowerShell
- Installs AWS CLI and AWS Tools for PowerShell
- Configures Google Cloud SDK
- Installs Terraform and infrastructure tools
- Sets up Kubernetes tools (kubectl, helm, k9s)

**Manual run**:
```powershell
.\scripts\05_cloud_devops.ps1
```

### 6. Workspace Structure

**Script**: `06_workspace_setup.ps1`

**What it does**:
- Creates organized workspace directory structure
- Sets up project templates and boilerplates
- Configures development scripts and utilities
- Sets up workspace environment variables
- Creates documentation and guides

**Manual run**:
```powershell
.\scripts\06_workspace_setup.ps1
```

### 7. IDEs & Development Tools

**Script**: `07_ide_tools.ps1`

**What it does**:
- Installs Visual Studio 2022
- Installs Visual Studio Code with extensions
- Installs JetBrains IDEs (IntelliJ, WebStorm, etc.)
- Configures IDE settings and themes
- Sets up debugging and testing tools

**Manual run**:
```powershell
.\scripts\07_ide_tools.ps1
```

## Script Overview

### Master Script Features

The `setup_master.ps1` script provides:

- **Interactive menu** for selecting components
- **Auto-run mode** for unattended installation
- **Progress tracking** with success/failure reporting
- **Error handling** and recovery options
- **Completion report** with next steps
- **Logging** to file for troubleshooting

### Individual Script Features

Each script includes:

- **Modular design** for specific functionality
- **Error handling** with try-catch blocks
- **Interactive confirmations** or auto-run support
- **Progress indicators** and status messages
- **Administrator privilege checking**
- **Idempotent operations** (safe to run multiple times)

## Customization

### Modifying Package Lists

Edit the package arrays in `02_package_mgmt.ps1`:

```powershell
# Add or remove Chocolatey packages
$packages = @(
    "existing-package",
    "your-new-package"
)

# Add or remove Winget packages
$packages = @(
    "Microsoft.ExistingApp",
    "YourCompany.YourApp"
)
```

### Customizing Git Configuration

Modify the Git setup in `03_dev_env.ps1`:

```powershell
# Add custom Git aliases
git config --global alias.your-alias "your-command"

# Change default editor
git config --global core.editor "code --wait"
```

### Adding Custom Scripts

1. Create a new `.ps1` script following the template
2. Add it to the master script's array
3. Update documentation

### Workspace Structure

Customize the workspace structure in `06_workspace_setup.ps1`:

```powershell
# Modify directory structure
$directories = @("your-custom-dirs")
```

## Troubleshooting

### Common Issues

#### Execution Policy Errors
```powershell
# Fix execution policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Check current policy
Get-ExecutionPolicy -List
```

#### Administrator Privileges
```powershell
# Check if running as administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Host "Please run as Administrator"
}
```

#### Package Installation Failures
```powershell
# Update package managers
choco upgrade all -y
winget upgrade --all
scoop update *

# Clear caches
choco cache clear
```

#### Git Configuration Issues
```powershell
# Check Git configuration
git config --list

# Reset Git configuration
git config --global --unset user.name
git config --global --unset user.email
```

#### WSL2 Problems
```powershell
# Check WSL status
wsl --status

# Update WSL
wsl --update

# Set default version
wsl --set-default-version 2
```

### Getting Help

1. **Check the log file** at `$env:TEMP\windows-dev-setup.log`
2. **Run individual scripts** to isolate issues
3. **Review the documentation** for specific components
4. **Open an issue** on GitHub with:
   - Windows version
   - PowerShell version
   - Error messages
   - Steps to reproduce

## Post-Setup

### Essential Next Steps

1. **Restart your computer** to apply all changes

2. **Configure Git credentials**:
   ```powershell
   git config --global user.name "Your Name"
   git config --global user.email "tiatheone@protonmail.com"
   ```

3. **Set up SSH keys**:
   ```powershell
   ssh-keygen -t ed25519 -C "tiatheone@protonmail.com"
   ```

4. **Test your setup**:
   ```powershell
   # Test Node.js
   node --version
   npm --version
   
   # Test Python
   python --version
   pip --version
   
   # Test Docker
   docker --version
   docker run hello-world
   
   # Test .NET
   dotnet --version
   ```

### Workspace Usage

After setup, you can use these PowerShell functions:

```powershell
# Navigate to workspace
Set-Location $env:USERPROFILE\workspace

# List projects
Get-ChildItem $env:USERPROFILE\workspace\10_projects

# Create new project
New-Item -Path "$env:USERPROFILE\workspace\10_projects\my-project" -ItemType Directory
```

### Development Workflow

1. **Open Windows Terminal**
2. **Navigate to your workspace**:
   ```powershell
   cd $env:USERPROFILE\workspace\10_projects
   ```
3. **Create a new project**:
   ```powershell
   mkdir my-new-project
   cd my-new-project
   ```
4. **Open in your IDE**:
   ```powershell
   code .  # VS Code
   # or
   idea .  # IntelliJ IDEA
   ```

### Maintenance

#### Regular Updates

```powershell
# Update Windows
Get-WindowsUpdate -Install -AcceptAll

# Update Chocolatey packages
choco upgrade all -y

# Update Winget packages
winget upgrade --all

# Update Scoop packages
scoop update *

# Update PowerShell modules
Update-Module -Force
```

#### Backup Your Configuration

```powershell
# Backup PowerShell profile
Copy-Item $PROFILE "$env:USERPROFILE\backup\powershell_profile.ps1"

# Backup Git configuration
git config --list > "$env:USERPROFILE\backup\git_config.txt"

# Backup VS Code settings
Copy-Item "$env:APPDATA\Code\User\settings.json" "$env:USERPROFILE\backup\"
```

## Advanced Features

### Windows Subsystem for Linux (WSL2)

After setup, you can use WSL2 for Linux development:

```powershell
# Install Ubuntu
wsl --install -d Ubuntu

# Access Ubuntu
wsl

# Install development tools in WSL
sudo apt update && sudo apt install -y git nodejs npm python3 pip
```

### Docker Development

```powershell
# Verify Docker installation
docker --version

# Run a development container
docker run -it --rm -v ${PWD}:/workspace -w /workspace node:18 bash
```

### Kubernetes Development

```powershell
# Check Kubernetes cluster
kubectl cluster-info

# Deploy an application
kubectl create deployment hello-world --image=gcr.io/google-samples/hello-app:1.0
```

## Additional Resources

- **GitHub Repository**: https://github.com/tiation/windows-dev-setup
- **Windows Documentation**: https://docs.microsoft.com/en-us/windows/
- **PowerShell Documentation**: https://docs.microsoft.com/en-us/powershell/
- **Development Tools**: Check individual tool documentation
- **Community Support**: GitHub Issues and Discussions

---

**Happy coding on Windows! 🚀**
