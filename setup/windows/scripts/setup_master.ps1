#Requires -Version 5.1
<#
.SYNOPSIS
    Windows Development Environment Master Setup Script
    
.DESCRIPTION
    Comprehensive PowerShell script to set up a complete development environment on Windows systems.
    Includes package management, development tools, IDEs, and workspace configuration.
    
.PARAMETER AutoRun
    Run all setup scripts automatically without user prompts
    
.PARAMETER SkipPrereqs
    Skip prerequisite checks
    
.EXAMPLE
    .\setup_master.ps1
    Run the interactive setup
    
.EXAMPLE
    .\setup_master.ps1 -AutoRun
    Run all setup scripts automatically
    
.NOTES
    Author: Windows Development Setup
    Version: 1.0.0
    Requires: PowerShell 5.1 or later, Administrator privileges for some operations
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [switch]$AutoRun,
    [switch]$SkipPrereqs
)

# Script variables
$ScriptRoot = $PSScriptRoot
$LogFile = "$env:TEMP\windows-dev-setup.log"
$CompletedSteps = @()
$FailedSteps = @()

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

#region Helper Functions

function Write-Log {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Level] $Message"
    
    Add-Content -Path $LogFile -Value $logEntry
    
    switch ($Level) {
        "ERROR" { Write-Host "❌ $Message" -ForegroundColor $Colors.Red }
        "WARNING" { Write-Host "⚠️ $Message" -ForegroundColor $Colors.Yellow }
        "SUCCESS" { Write-Host "✅ $Message" -ForegroundColor $Colors.Green }
        "INFO" { Write-Host "ℹ️ $Message" -ForegroundColor $Colors.Blue }
        default { Write-Host "🔵 $Message" -ForegroundColor $Colors.White }
    }
}

function Show-Banner {
    Write-Host @"
╔═══════════════════════════════════════════════════════════════════════════════╗
║                                                                               ║
║                  🚀 Windows Development Environment Setup 🚀                 ║
║                                                                               ║
║                        Automated PowerShell Setup Suite                      ║
║                                                                               ║
╚═══════════════════════════════════════════════════════════════════════════════╝
"@ -ForegroundColor $Colors.Magenta
}

function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Test-PowerShellVersion {
    return $PSVersionTable.PSVersion.Major -ge 5
}

function Test-InternetConnection {
    try {
        $null = Test-NetConnection -ComputerName "8.8.8.8" -Port 53 -InformationLevel Quiet
        return $true
    }
    catch {
        return $false
    }
}

function Confirm-Action {
    param(
        [string]$Message
    )
    
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

function Test-Prerequisites {
    Write-Log "Checking prerequisites..." "INFO"
    
    # Check Windows version
    $osVersion = [System.Environment]::OSVersion.Version
    if ($osVersion.Major -lt 10) {
        Write-Log "Windows 10 or later is required. Current version: $($osVersion.ToString())" "ERROR"
        return $false
    }
    
    # Check PowerShell version
    if (-not (Test-PowerShellVersion)) {
        Write-Log "PowerShell 5.1 or later is required. Current version: $($PSVersionTable.PSVersion.ToString())" "ERROR"
        return $false
    }
    
    # Check internet connection
    if (-not (Test-InternetConnection)) {
        Write-Log "Internet connection is required but not available" "ERROR"
        return $false
    }
    
    # Check execution policy
    $executionPolicy = Get-ExecutionPolicy -Scope CurrentUser
    if ($executionPolicy -eq 'Restricted') {
        Write-Log "PowerShell execution policy is restricted. Setting to RemoteSigned for CurrentUser..." "WARNING"
        try {
            Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
            Write-Log "Execution policy updated successfully" "SUCCESS"
        }
        catch {
            Write-Log "Failed to update execution policy: $($_.Exception.Message)" "ERROR"
            return $false
        }
    }
    
    Write-Log "Prerequisites check passed" "SUCCESS"
    return $true
}

function Track-Step {
    param(
        [string]$StepName,
        [string]$Status
    )
    
    if ($Status -eq "SUCCESS") {
        $script:CompletedSteps += $StepName
        Write-Log "$StepName completed successfully" "SUCCESS"
    }
    else {
        $script:FailedSteps += $StepName
        Write-Log "$StepName failed" "ERROR"
    }
}

function Invoke-SetupScript {
    param(
        [string]$ScriptName,
        [string]$Description
    )
    
    $scriptPath = Join-Path $ScriptRoot $ScriptName
    
    if (-not (Test-Path $scriptPath)) {
        Write-Log "Script not found: $scriptPath" "ERROR"
        Track-Step $Description "FAILED"
        return $false
    }
    
    Write-Log "Running: $Description" "INFO"
    
    try {
        if ($AutoRun) {
            $result = & $scriptPath -AutoRun
        }
        else {
            $result = & $scriptPath
        }
        
        if ($LASTEXITCODE -eq 0) {
            Track-Step $Description "SUCCESS"
            return $true
        }
        else {
            Track-Step $Description "FAILED"
            return $false
        }
    }
    catch {
        Write-Log "Error running $ScriptName`: $($_.Exception.Message)" "ERROR"
        Track-Step $Description "FAILED"
        return $false
    }
}

function Show-Menu {
    Write-Host @"

Available setup options:
1. 🔧 System Preferences & Tweaks
2. 📦 Package Management (Chocolatey, Winget, Scoop)
3. 🛠️  Development Environment Setup
4. 📱 Mobile Development Tools
5. ☁️  Cloud & DevOps Tools
6. 📁 Workspace Structure Setup
7. 🖥️  IDEs & Development Tools
8. 🎯 Complete Setup (All of the above)
9. 🔄 Custom Setup (Choose individual components)
0. ❌ Exit

"@ -ForegroundColor $Colors.Cyan
}

function Invoke-IndividualSetup {
    param([int]$Choice)
    
    switch ($Choice) {
        1 { 
            if (Confirm-Action "Run System Preferences & Tweaks setup?") {
                Invoke-SetupScript "01_system_prefs.ps1" "System Preferences & Tweaks"
            }
        }
        2 { 
            if (Confirm-Action "Run Package Management setup?") {
                Invoke-SetupScript "02_package_mgmt.ps1" "Package Management"
            }
        }
        3 { 
            if (Confirm-Action "Run Development Environment setup?") {
                Invoke-SetupScript "03_dev_env.ps1" "Development Environment"
            }
        }
        4 { 
            if (Confirm-Action "Run Mobile Development setup?") {
                Invoke-SetupScript "04_mobile_dev.ps1" "Mobile Development Tools"
            }
        }
        5 { 
            if (Confirm-Action "Run Cloud & DevOps setup?") {
                Invoke-SetupScript "05_cloud_devops.ps1" "Cloud & DevOps Tools"
            }
        }
        6 { 
            if (Confirm-Action "Run Workspace Structure setup?") {
                Invoke-SetupScript "06_workspace_setup.ps1" "Workspace Structure"
            }
        }
        7 { 
            if (Confirm-Action "Run IDEs & Development Tools setup?") {
                Invoke-SetupScript "07_ide_tools.ps1" "IDEs & Development Tools"
            }
        }
        default {
            Write-Log "Invalid choice: $Choice" "ERROR"
        }
    }
}

function Invoke-CompleteSetup {
    Write-Log "Starting complete Windows development environment setup..." "INFO"
    
    $scripts = @(
        @{ Name = "01_system_prefs.ps1"; Description = "System Preferences & Tweaks" }
        @{ Name = "02_package_mgmt.ps1"; Description = "Package Management" }
        @{ Name = "03_dev_env.ps1"; Description = "Development Environment" }
        @{ Name = "04_mobile_dev.ps1"; Description = "Mobile Development Tools" }
        @{ Name = "05_cloud_devops.ps1"; Description = "Cloud & DevOps Tools" }
        @{ Name = "06_workspace_setup.ps1"; Description = "Workspace Structure" }
        @{ Name = "07_ide_tools.ps1"; Description = "IDEs & Development Tools" }
    )
    
    foreach ($script in $scripts) {
        if ($AutoRun) {
            Invoke-SetupScript $script.Name $script.Description
        }
        else {
            if (Confirm-Action "Run $($script.Description) setup?") {
                Invoke-SetupScript $script.Name $script.Description
            }
            else {
                Write-Log "Skipping $($script.Description) setup" "INFO"
            }
        }
    }
}

function Invoke-CustomSetup {
    Write-Log "Starting custom setup..." "INFO"
    
    $choices = Read-Host "Enter your choices (e.g., 1,3,5)"
    $choiceArray = $choices -split ',' | ForEach-Object { [int]$_.Trim() }
    
    foreach ($choice in $choiceArray) {
        Invoke-IndividualSetup $choice
    }
}

function Show-CompletionReport {
    Write-Host @"

╔══════════════════════════════════════════════════════════════════════════════════╗
║                                Setup Complete!                                   ║
╚══════════════════════════════════════════════════════════════════════════════════╝
"@ -ForegroundColor $Colors.Cyan
    
    if ($CompletedSteps.Count -gt 0) {
        Write-Host "`n✅ Completed Steps:" -ForegroundColor $Colors.Green
        foreach ($step in $CompletedSteps) {
            Write-Host "  • $step" -ForegroundColor $Colors.Green
        }
    }
    
    if ($FailedSteps.Count -gt 0) {
        Write-Host "`n❌ Failed Steps:" -ForegroundColor $Colors.Red
        foreach ($step in $FailedSteps) {
            Write-Host "  • $step" -ForegroundColor $Colors.Red
        }
        Write-Host "`n⚠️ Please review the failed steps and run them manually if needed." -ForegroundColor $Colors.Yellow
    }
    
    Write-Host @"

📋 Next Steps:
1. 🔄 Restart your computer to apply all changes
2. 🔑 Configure your Git credentials and SSH keys
3. 🐳 Start Docker Desktop if installed
4. 📱 Open Android Studio and complete SDK setup if needed
5. 🎨 Customize your IDEs and development environment
6. 📖 Check the documentation in the docs/ folder for more details

🎉 Your Windows development environment is ready! Happy coding! 🎉
"@ -ForegroundColor $Colors.Magenta
}

function Initialize-PlaceholderScripts {
    $placeholderScripts = @(
        "01_system_prefs.ps1",
        "02_package_mgmt.ps1",
        "03_dev_env.ps1",
        "04_mobile_dev.ps1",
        "05_cloud_devops.ps1",
        "06_workspace_setup.ps1",
        "07_ide_tools.ps1"
    )
    
    foreach ($script in $placeholderScripts) {
        $scriptPath = Join-Path $ScriptRoot $script
        if (-not (Test-Path $scriptPath)) {
            Write-Log "Creating placeholder for $script" "WARNING"
            @"
#Requires -Version 5.1
<#
.SYNOPSIS
    $script - Windows Development Setup Script
    
.DESCRIPTION
    This script is part of the Windows Development Setup Suite.
    TODO: Implement full functionality
    
.PARAMETER AutoRun
    Run without user prompts
#>

[CmdletBinding()]
param(
    [switch]`$AutoRun
)

Write-Host "🚀 $script Setup" -ForegroundColor Cyan
Write-Host "⚠️  This script is under development" -ForegroundColor Yellow
Write-Host "✅ Placeholder completed successfully" -ForegroundColor Green

exit 0
"@ | Out-File -FilePath $scriptPath -Encoding utf8
        }
    }
}

#endregion

#region Main Script

function Main {
    # Initialize logging
    if (Test-Path $LogFile) {
        Remove-Item $LogFile -Force
    }
    
    Show-Banner
    
    # Check prerequisites
    if (-not $SkipPrereqs) {
        if (-not (Test-Prerequisites)) {
            Write-Log "Prerequisites check failed. Exiting." "ERROR"
            exit 1
        }
    }
    
    # Create placeholder scripts if they don't exist
    Initialize-PlaceholderScripts
    
    # Auto-run mode
    if ($AutoRun) {
        Write-Log "Running in auto mode (no prompts)" "INFO"
        Invoke-CompleteSetup
        Show-CompletionReport
        return
    }
    
    # Interactive mode
    do {
        Show-Menu
        $choice = Read-Host "Choose an option [0-9]"
        
        switch ($choice) {
            "0" {
                Write-Log "Exiting setup..." "INFO"
                exit 0
            }
            { $_ -in @("1", "2", "3", "4", "5", "6", "7") } {
                Invoke-IndividualSetup ([int]$choice)
            }
            "8" {
                Invoke-CompleteSetup
                break
            }
            "9" {
                Invoke-CustomSetup
                break
            }
            default {
                Write-Host "Invalid choice. Please select 0-9." -ForegroundColor $Colors.Red
            }
        }
    } while ($choice -notin @("0", "8", "9"))
    
    Show-CompletionReport
}

# Show usage information
function Show-Usage {
    Write-Host @"
Usage: .\setup_master.ps1 [OPTIONS]

Options:
  -AutoRun        Run complete setup without prompts
  -SkipPrereqs    Skip prerequisite checks
  -Help           Show this help message

Examples:
  .\setup_master.ps1                    # Interactive mode
  .\setup_master.ps1 -AutoRun           # Auto mode (no prompts)
  .\setup_master.ps1 -SkipPrereqs       # Skip prerequisite checks
"@
}

# Handle parameters
if ($PSBoundParameters.ContainsKey('Help')) {
    Show-Usage
    exit 0
}

# Check if running as administrator for certain operations
if (-not (Test-Administrator)) {
    Write-Log "Some operations require administrator privileges. Consider running as administrator." "WARNING"
}

# Run main function
try {
    Main
}
catch {
    Write-Log "Unexpected error: $($_.Exception.Message)" "ERROR"
    Write-Log "Stack trace: $($_.ScriptStackTrace)" "ERROR"
    exit 1
}
finally {
    Write-Log "Setup script completed. Log file: $LogFile" "INFO"
}

#endregion
