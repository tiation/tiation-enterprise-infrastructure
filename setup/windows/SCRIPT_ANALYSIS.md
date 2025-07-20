# Windows Setup Scripts Analysis and Categorization

## Overview
This document analyzes Windows development environment setup scripts and categorizes their functionalities for creating modular PowerShell scripts. The analysis covers Windows-specific configurations, package management, and development environment setup.

## Scripts Structure
1. `01_system_prefs.ps1` - Windows System Preferences and Tweaks
2. `02_package_mgmt.ps1` - Package Management (Chocolatey, Winget, Scoop)
3. `03_dev_env.ps1` - Development Environment Setup
4. `04_mobile_dev.ps1` - Mobile Development Tools
5. `05_cloud_devops.ps1` - Cloud and DevOps Tools
6. `06_workspace_setup.ps1` - Directory Structure and Workspace
7. `07_ide_tools.ps1` - IDEs and Development Tools
8. `setup_master.ps1` - Master Orchestration Script

## Functional Categories

### 1. SYSTEM PREFERENCES & TWEAKS
Windows-specific configurations and system enhancements:

**Windows Settings:**
```powershell
# Set dark theme
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0

# Configure taskbar
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarGlomLevel" -Value 1
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value 0

# File Explorer settings
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Value 1
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Value 1

# Performance tweaks
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 2
```

**Windows Features:**
```powershell
# Enable Windows Subsystem for Linux
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart

# Enable Windows Subsystem for Linux 2
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart

# Enable Hyper-V
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All -NoRestart

# Enable Windows Terminal
Add-AppxPackage -Path "Microsoft.WindowsTerminal"
```

**Power Settings:**
```powershell
# Set power plan to High Performance
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

# Disable hibernation
powercfg -h off

# Configure sleep settings
powercfg -change -monitor-timeout-ac 0
powercfg -change -standby-timeout-ac 0
```

### 2. PACKAGE MANAGEMENT
**Chocolatey Installation:**
```powershell
# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install packages
choco install git -y
choco install vscode -y
choco install googlechrome -y
choco install firefox -y
choco install 7zip -y
choco install nodejs -y
choco install python -y
choco install dotnet -y
choco install openjdk -y
choco install docker-desktop -y
choco install kubernetes-cli -y
choco install terraform -y
choco install azure-cli -y
choco install awscli -y
```

**Winget Installation:**
```powershell
# Winget is included in Windows 11 and Windows 10 with App Installer
# Install applications
winget install Microsoft.VisualStudio.2022.Community
winget install Microsoft.VisualStudioCode
winget install Microsoft.WindowsTerminal
winget install Microsoft.PowerShell
winget install JetBrains.IntelliJIDEA.Community
winget install Google.AndroidStudio
winget install Discord.Discord
winget install Slack.Slack
winget install Spotify.Spotify
winget install VideoLAN.VLC
winget install OBSProject.OBSStudio
```

**Scoop Installation:**
```powershell
# Install Scoop
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex

# Add buckets
scoop bucket add extras
scoop bucket add java
scoop bucket add versions

# Install applications
scoop install git
scoop install nvm
scoop install python
scoop install go
scoop install rust
scoop install neovim
scoop install ripgrep
scoop install fzf
scoop install jq
scoop install curl
scoop install wget
```

### 3. DEVELOPMENT ENVIRONMENT SETUP
**Git Configuration:**
```powershell
# Interactive Git setup
$gitName = Read-Host "Enter your Git global user.name"
git config --global user.name "$gitName"
$gitEmail = Read-Host "Enter your Git global user.email"
git config --global user.email "$gitEmail"

# Git settings
git config --global core.editor "code --wait"
git config --global init.defaultBranch main
git config --global core.autocrlf input
git config --global core.longpaths true

# Git aliases
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
git config --global alias.st "status"
git config --global alias.co "checkout"
git config --global alias.br "branch"
```

**PowerShell Profile Setup:**
```powershell
# Create PowerShell profile directory
$profileDir = Split-Path $PROFILE
if (!(Test-Path $profileDir)) { New-Item -Path $profileDir -ItemType Directory -Force }

# Install PowerShell modules
Install-Module -Name PSReadLine -Force
Install-Module -Name posh-git -Force
Install-Module -Name oh-my-posh -Force
Install-Module -Name Terminal-Icons -Force
Install-Module -Name PSFzf -Force

# Configure PowerShell profile
@'
# Import modules
Import-Module posh-git
Import-Module oh-my-posh
Import-Module Terminal-Icons
Import-Module PSFzf

# Set theme
Set-PoshPrompt -Theme robbyrussell

# Set aliases
Set-Alias -Name ll -Value Get-ChildItem
Set-Alias -Name la -Value Get-ChildItem
Set-Alias -Name grep -Value Select-String
Set-Alias -Name touch -Value New-Item
'@ | Out-File -FilePath $PROFILE -Encoding utf8
```

**WSL2 Setup:**
```powershell
# Enable WSL2
wsl --install -d Ubuntu

# Set WSL2 as default
wsl --set-default-version 2

# Install Ubuntu distribution
wsl --install -d Ubuntu-20.04

# Configure WSL2
wsl --set-default Ubuntu-20.04
```

### 4. RUNTIME SETUP
**Node.js & NPM:**
```powershell
# Install nvm-windows
scoop install nvm

# Install Node.js LTS
nvm install lts
nvm use lts

# Install global packages
npm install -g yarn
npm install -g pnpm
npm install -g @angular/cli
npm install -g @vue/cli
npm install -g create-react-app
npm install -g typescript
npm install -g ts-node
npm install -g eslint
npm install -g prettier
npm install -g nodemon
```

**Python Environment:**
```powershell
# Install Python via Chocolatey
choco install python -y

# Install pipenv and poetry
pip install pipenv
pip install poetry

# Create virtual environment
python -m venv $env:USERPROFILE\ai-dev
& "$env:USERPROFILE\ai-dev\Scripts\Activate.ps1"

# Install common packages
pip install numpy pandas matplotlib seaborn
pip install jupyter jupyterlab
pip install requests beautifulsoup4
pip install flask django fastapi
pip install pytest black flake8
pip install torch torchvision torchaudio
pip install tensorflow
pip install transformers
```

**.NET Environment:**
```powershell
# Install .NET SDK
choco install dotnet-sdk -y

# Install global tools
dotnet tool install --global dotnet-ef
dotnet tool install --global dotnet-aspnet-codegenerator
dotnet tool install --global Microsoft.dotnet-httprepl
```

### 5. MOBILE DEVELOPMENT
**Flutter Setup:**
```powershell
# Install Flutter
choco install flutter -y

# Configure Flutter
flutter config --enable-windows-desktop
flutter config --enable-android
flutter doctor

# Accept Android licenses
flutter doctor --android-licenses
```

**Android Development:**
```powershell
# Install Android Studio
choco install androidstudio -y

# Set environment variables
[Environment]::SetEnvironmentVariable("ANDROID_HOME", "$env:LOCALAPPDATA\Android\Sdk", "User")
[Environment]::SetEnvironmentVariable("PATH", "$env:PATH;$env:LOCALAPPDATA\Android\Sdk\platform-tools", "User")

# Install React Native CLI
npm install -g @react-native-community/cli
```

**Visual Studio for Mobile:**
```powershell
# Install Visual Studio with mobile workloads
choco install visualstudio2022community -y --params "--add Microsoft.VisualStudio.Workload.NetCoreTools --add Microsoft.VisualStudio.Workload.ManagedDesktop --add Microsoft.VisualStudio.Workload.NetCrossPlat"
```

### 6. CONTAINER & KUBERNETES
**Docker Desktop:**
```powershell
# Install Docker Desktop
choco install docker-desktop -y

# Wait for Docker to start
do {
    Start-Sleep -Seconds 5
    $dockerStatus = docker version 2>$null
} while (!$dockerStatus)

# Enable Kubernetes in Docker Desktop
Write-Host "Please enable Kubernetes in Docker Desktop settings manually"
```

**Kubernetes Tools:**
```powershell
# Install kubectl
choco install kubernetes-cli -y

# Install Helm
choco install kubernetes-helm -y

# Install k9s
choco install k9s -y

# Install Azure CLI
choco install azure-cli -y

# Install AWS CLI
choco install awscli -y
```

### 7. IDE & DEVELOPMENT TOOLS
**Visual Studio Code:**
```powershell
# Install VS Code
choco install vscode -y

# Install extensions
code --install-extension ms-python.python
code --install-extension ms-vscode.csharp
code --install-extension ms-vscode.vscode-typescript-next
code --install-extension bradlc.vscode-tailwindcss
code --install-extension esbenp.prettier-vscode
code --install-extension ms-vscode.vscode-json
code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools
code --install-extension ms-vscode-remote.remote-wsl
```

**JetBrains IDEs:**
```powershell
# Install JetBrains Toolbox
choco install jetbrainstoolbox -y

# Individual IDEs can be installed via:
# choco install intellijidea-community -y
# choco install webstorm -y
# choco install pycharm-community -y
# choco install rider -y
```

### 8. DIRECTORY STRUCTURE
**Development Workspace:**
```powershell
# Create workspace directories
$workspaceRoot = "$env:USERPROFILE\workspace"
$directories = @(
    "00_org", "10_projects", "20_assets", "30_docs", 
    "40_ops", "70_data", "99_tmp"
)

foreach ($dir in $directories) {
    New-Item -Path "$workspaceRoot\$dir" -ItemType Directory -Force
}

# Create project subdirectories
$projectTypes = @("web", "mobile", "desktop", "backend", "frontend")
foreach ($type in $projectTypes) {
    New-Item -Path "$workspaceRoot\10_projects\$type" -ItemType Directory -Force
}
```

### 9. SYSTEM UTILITIES
**Windows Terminal Configuration:**
```powershell
# Install Windows Terminal
winget install Microsoft.WindowsTerminal

# Configure Windows Terminal with custom settings
$terminalSettings = @{
    "defaultProfile" = "{61c54bbd-c2c6-5271-96e7-009a87ff44bf}"
    "profiles" = @{
        "defaults" = @{
            "fontFace" = "Cascadia Code PL"
            "fontSize" = 12
            "colorScheme" = "One Half Dark"
        }
        "list" = @(
            @{
                "guid" = "{61c54bbd-c2c6-5271-96e7-009a87ff44bf}"
                "name" = "Windows PowerShell"
                "commandline" = "powershell.exe"
                "startingDirectory" = "%USERPROFILE%"
            }
        )
    }
} | ConvertTo-Json -Depth 10

$terminalSettings | Out-File -FilePath "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -Encoding utf8
```

**PowerToys Installation:**
```powershell
# Install PowerToys
winget install Microsoft.PowerToys

# Configure PowerToys (settings are typically configured via GUI)
```

## Windows-Specific Considerations

### Package Manager Hierarchy
1. **Chocolatey**: Most comprehensive, good for development tools
2. **Winget**: Microsoft's official package manager, growing ecosystem
3. **Scoop**: Command-line focused, good for portable applications
4. **Direct Downloads**: For specific applications not available in package managers

### Security Considerations
- **Execution Policy**: Set appropriate PowerShell execution policy
- **UAC**: Some installations require administrator privileges
- **Windows Defender**: Configure exclusions for development folders
- **Firewall**: Configure for Docker and development servers

### Windows Features
- **WSL2**: Enable for Linux development environment
- **Hyper-V**: For virtualization and Docker
- **Windows Terminal**: Modern terminal with tabs and customization
- **PowerShell 7**: Cross-platform PowerShell with enhanced features

## Script Modularity

Each script includes:
- Error handling with try-catch blocks
- Interactive confirmation prompts
- Logging with timestamps
- Administrator privilege checking
- Progress indicators
- Cleanup functions

## Recommended Execution Order

1. **01_system_prefs.ps1** - System preferences and Windows features
2. **02_package_mgmt.ps1** - Install package managers and core tools
3. **03_dev_env.ps1** - Development environment setup
4. **04_mobile_dev.ps1** - Mobile development tools
5. **05_cloud_devops.ps1** - Cloud and DevOps tools
6. **06_workspace_setup.ps1** - Directory structure and workspace
7. **07_ide_tools.ps1** - IDEs and development tools

## PowerShell Best Practices

- Use approved verbs for function names
- Implement proper error handling
- Support -WhatIf and -Confirm parameters
- Use Write-Progress for long-running operations
- Follow PowerShell coding conventions
- Test on different Windows versions
