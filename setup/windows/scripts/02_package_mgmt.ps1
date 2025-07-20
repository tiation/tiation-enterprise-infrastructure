#Requires -Version 5.1
<#
.SYNOPSIS
    Windows Package Management Setup Script
    
.DESCRIPTION
    Installs and configures package managers (Chocolatey, Winget, Scoop) and essential packages
    for Windows development environment setup.
    
.PARAMETER AutoRun
    Run without user prompts
    
.EXAMPLE
    .\02_package_mgmt.ps1
    Run interactively with prompts
    
.EXAMPLE
    .\02_package_mgmt.ps1 -AutoRun
    Run automatically without prompts
    
.NOTES
    Author: Windows Development Setup
    Version: 1.0.0
    Requires: Administrator privileges for some operations
#>

[CmdletBinding()]
param(
    [switch]$AutoRun
)

# Color codes for console output
$Colors = @{
    Red = [ConsoleColor]::Red
    Green = [ConsoleColor]::Green
    Yellow = [ConsoleColor]::Yellow
    Blue = [ConsoleColor]::Blue
    Cyan = [ConsoleColor]::Cyan
    Magenta = [ConsoleColor]::Magenta
    White = [ConsoleColor]::White
}

function Write-Log {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    
    switch ($Level) {
        "ERROR" { Write-Host "❌ $Message" -ForegroundColor $Colors.Red }
        "WARNING" { Write-Host "⚠️ $Message" -ForegroundColor $Colors.Yellow }
        "SUCCESS" { Write-Host "✅ $Message" -ForegroundColor $Colors.Green }
        "INFO" { Write-Host "ℹ️ $Message" -ForegroundColor $Colors.Blue }
        default { Write-Host "🔵 $Message" -ForegroundColor $Colors.White }
    }
}

function Confirm-Action {
    param([string]$Message)
    
    if ($AutoRun) {
        return $true
    }
    
    do {
        $response = Read-Host "$Message [y/N]"
        if ($response -match '^[Yy]$') {
            return $true
        }
        elseif ($response -match '^[Nn]$' -or $response -eq '') {
            return $false
        }
        else {
            Write-Host "Please enter 'y' for yes or 'n' for no." -ForegroundColor $Colors.Yellow
        }
    } while ($true)
}

function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Install-Chocolatey {
    Write-Log "Installing Chocolatey package manager..." "INFO"
    
    # Check if Chocolatey is already installed
    if (Get-Command choco -ErrorAction SilentlyContinue) {
        Write-Log "Chocolatey is already installed" "INFO"
        return $true
    }
    
    try {
        # Set execution policy for this process
        Set-ExecutionPolicy Bypass -Scope Process -Force
        
        # Enable TLS 1.2
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        
        # Download and install Chocolatey
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        
        # Refresh environment variables
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
        
        Write-Log "Chocolatey installed successfully" "SUCCESS"
        return $true
    }
    catch {
        Write-Log "Failed to install Chocolatey: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

function Install-ChocolateyPackages {
    Write-Log "Installing Chocolatey packages..." "INFO"
    
    $packages = @(
        "git",
        "vscode",
        "googlechrome",
        "firefox",
        "7zip",
        "nodejs",
        "python",
        "dotnet-sdk",
        "openjdk",
        "docker-desktop",
        "kubernetes-cli",
        "terraform",
        "azure-cli",
        "awscli",
        "postman",
        "insomnia-rest-api-client",
        "slack",
        "discord",
        "spotify",
        "vlc",
        "obs-studio",
        "powertoys",
        "sysinternals",
        "notepadplusplus",
        "winrar",
        "fiddler",
        "wireshark",
        "putty",
        "winscp",
        "filezilla",
        "greenshot",
        "paint.net",
        "gimp",
        "audacity",
        "handbrake",
        "kdiff3",
        "windirstat",
        "procexp",
        "procmon",
        "autoruns",
        "bginfo"
    )
    
    foreach ($package in $packages) {
        try {
            Write-Log "Installing $package..." "INFO"
            choco install $package -y
            Write-Log "Successfully installed $package" "SUCCESS"
        }
        catch {
            Write-Log "Failed to install $package: $($_.Exception.Message)" "WARNING"
        }
    }
    
    Write-Log "Chocolatey packages installation completed" "SUCCESS"
}

function Install-Winget {
    Write-Log "Setting up Winget package manager..." "INFO"
    
    # Check if Winget is available
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        Write-Log "Winget is already available" "INFO"
        return $true
    }
    
    try {
        # Install App Installer from Microsoft Store (includes Winget)
        Write-Log "Installing App Installer (includes Winget)..." "INFO"
        
        # For Windows 10 version 1809 and later, Winget should be available via App Installer
        # If not available, try to install it
        $appInstaller = Get-AppxPackage -Name "Microsoft.DesktopAppInstaller" -ErrorAction SilentlyContinue
        
        if (-not $appInstaller) {
            # Try to install App Installer
            Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
        }
        
        Write-Log "Winget setup completed" "SUCCESS"
        return $true
    }
    catch {
        Write-Log "Failed to setup Winget: $($_.Exception.Message)" "WARNING"
        return $false
    }
}

function Install-WingetPackages {
    Write-Log "Installing Winget packages..." "INFO"
    
    $packages = @(
        "Microsoft.VisualStudio.2022.Community",
        "Microsoft.VisualStudioCode",
        "Microsoft.WindowsTerminal",
        "Microsoft.PowerShell",
        "Microsoft.PowerToys",
        "JetBrains.IntelliJIDEA.Community",
        "JetBrains.WebStorm",
        "JetBrains.PyCharm.Community",
        "JetBrains.Rider",
        "Google.AndroidStudio",
        "Discord.Discord",
        "Slack.Slack",
        "Spotify.Spotify",
        "VideoLAN.VLC",
        "OBSProject.OBSStudio",
        "Notion.Notion",
        "Obsidian.Obsidian",
        "Figma.Figma",
        "Adobe.AdobeCreativeCloud",
        "Mozilla.Firefox",
        "Google.Chrome",
        "Microsoft.Edge.Dev",
        "Brave.Brave",
        "Tor.TorBrowser",
        "WinSCP.WinSCP",
        "PuTTY.PuTTY",
        "Telerik.Fiddler.Everywhere",
        "Postman.Postman",
        "Insomnia.Insomnia",
        "Docker.DockerDesktop",
        "Amazon.AWSCLI",
        "Microsoft.AzureCLI",
        "Google.CloudSDK",
        "Hashicorp.Terraform",
        "Kubernetes.kubectl",
        "Helm.Helm",
        "Git.Git",
        "GitHub.GitHubDesktop",
        "Microsoft.VisualStudio.2022.BuildTools",
        "Microsoft.DotNet.SDK.7",
        "OpenJS.NodeJS",
        "Python.Python.3.11",
        "Oracle.JavaRuntimeEnvironment",
        "AdoptOpenJDK.OpenJDK.11",
        "GoLang.Go",
        "Rustlang.Rustup"
    )
    
    foreach ($package in $packages) {
        try {
            Write-Log "Installing $package..." "INFO"
            winget install $package --silent --accept-package-agreements --accept-source-agreements
            Write-Log "Successfully installed $package" "SUCCESS"
        }
        catch {
            Write-Log "Failed to install $package: $($_.Exception.Message)" "WARNING"
        }
    }
    
    Write-Log "Winget packages installation completed" "SUCCESS"
}

function Install-Scoop {
    Write-Log "Installing Scoop package manager..." "INFO"
    
    # Check if Scoop is already installed
    if (Get-Command scoop -ErrorAction SilentlyContinue) {
        Write-Log "Scoop is already installed" "INFO"
        return $true
    }
    
    try {
        # Set execution policy for current user
        Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        
        # Download and install Scoop
        Invoke-RestMethod get.scoop.sh | Invoke-Expression
        
        Write-Log "Scoop installed successfully" "SUCCESS"
        return $true
    }
    catch {
        Write-Log "Failed to install Scoop: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

function Install-ScoopPackages {
    Write-Log "Installing Scoop packages..." "INFO"
    
    try {
        # Add additional buckets
        scoop bucket add extras
        scoop bucket add java
        scoop bucket add versions
        scoop bucket add nerd-fonts
        
        $packages = @(
            "git",
            "nvm",
            "python",
            "go",
            "rust",
            "neovim",
            "ripgrep",
            "fzf",
            "jq",
            "curl",
            "wget",
            "which",
            "grep",
            "sed",
            "less",
            "sudo",
            "touch",
            "unzip",
            "zip",
            "tar",
            "gzip",
            "7zip",
            "aria2",
            "ffmpeg",
            "imagemagick",
            "pandoc",
            "hugo",
            "nodejs",
            "yarn",
            "pnpm",
            "php",
            "composer",
            "ruby",
            "perl",
            "sqlite",
            "postgresql",
            "mysql",
            "redis",
            "mongodb",
            "dotnet-sdk",
            "openjdk",
            "maven",
            "gradle",
            "ant",
            "cmake",
            "make",
            "gcc",
            "llvm",
            "rustup",
            "cargo",
            "terraform",
            "kubectl",
            "helm",
            "k9s",
            "minikube",
            "docker",
            "docker-compose",
            "vagrant",
            "virtualbox",
            "aws",
            "azure-cli",
            "gcloud",
            "heroku",
            "gh",
            "hub",
            "lazygit",
            "delta",
            "bat",
            "fd",
            "dust",
            "procs",
            "tokei",
            "hyperfine",
            "bandwhich",
            "btm",
            "zoxide",
            "starship",
            "oh-my-posh"
        )
        
        foreach ($package in $packages) {
            try {
                Write-Log "Installing $package..." "INFO"
                scoop install $package
                Write-Log "Successfully installed $package" "SUCCESS"
            }
            catch {
                Write-Log "Failed to install $package: $($_.Exception.Message)" "WARNING"
            }
        }
        
        Write-Log "Scoop packages installation completed" "SUCCESS"
    }
    catch {
        Write-Log "Failed to install Scoop packages: $($_.Exception.Message)" "ERROR"
    }
}

function Update-PackageManagers {
    Write-Log "Updating package managers..." "INFO"
    
    # Update Chocolatey
    if (Get-Command choco -ErrorAction SilentlyContinue) {
        try {
            choco upgrade all -y
            Write-Log "Chocolatey packages updated" "SUCCESS"
        }
        catch {
            Write-Log "Failed to update Chocolatey packages: $($_.Exception.Message)" "WARNING"
        }
    }
    
    # Update Winget
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        try {
            winget upgrade --all --silent
            Write-Log "Winget packages updated" "SUCCESS"
        }
        catch {
            Write-Log "Failed to update Winget packages: $($_.Exception.Message)" "WARNING"
        }
    }
    
    # Update Scoop
    if (Get-Command scoop -ErrorAction SilentlyContinue) {
        try {
            scoop update
            scoop update *
            Write-Log "Scoop packages updated" "SUCCESS"
        }
        catch {
            Write-Log "Failed to update Scoop packages: $($_.Exception.Message)" "WARNING"
        }
    }
}

function Set-PackageManagerConfig {
    Write-Log "Configuring package managers..." "INFO"
    
    # Configure Chocolatey
    if (Get-Command choco -ErrorAction SilentlyContinue) {
        try {
            choco feature enable -n=allowGlobalConfirmation
            choco feature enable -n=useRememberedArgumentsForUpgrades
            Write-Log "Chocolatey configured" "SUCCESS"
        }
        catch {
            Write-Log "Failed to configure Chocolatey: $($_.Exception.Message)" "WARNING"
        }
    }
    
    # Configure Scoop
    if (Get-Command scoop -ErrorAction SilentlyContinue) {
        try {
            scoop config aria2-warning-enabled false
            scoop config aria2-enabled true
            Write-Log "Scoop configured" "SUCCESS"
        }
        catch {
            Write-Log "Failed to configure Scoop: $($_.Exception.Message)" "WARNING"
        }
    }
}

function Main {
    Write-Log "🚀 Starting Windows Package Management Setup" "INFO"
    
    # Check if running on Windows
    if ($PSVersionTable.Platform -and $PSVersionTable.Platform -ne "Win32NT") {
        Write-Log "This script is designed for Windows systems" "ERROR"
        exit 1
    }
    
    # Check for administrator privileges
    if (-not (Test-Administrator)) {
        Write-Log "Some operations require administrator privileges. Consider running as administrator." "WARNING"
    }
    
    # Install and configure package managers
    if (Confirm-Action "Install Chocolatey package manager?") {
        Install-Chocolatey
        Install-ChocolateyPackages
    }
    
    if (Confirm-Action "Setup Winget package manager?") {
        Install-Winget
        Install-WingetPackages
    }
    
    if (Confirm-Action "Install Scoop package manager?") {
        Install-Scoop
        Install-ScoopPackages
    }
    
    if (Confirm-Action "Configure package managers?") {
        Set-PackageManagerConfig
    }
    
    if (Confirm-Action "Update all packages?") {
        Update-PackageManagers
    }
    
    Write-Log "🎉 Windows package management setup complete!" "SUCCESS"
    Write-Log "Please restart your PowerShell session to ensure all changes take effect" "INFO"
}

# Run main function if script is executed directly
if ($MyInvocation.InvocationName -ne '.') {
    Main
}

exit 0
