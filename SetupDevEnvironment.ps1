# *********************************************
# Ensure the script is running as Administrator
# *********************************************
If (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Script is not running as Administrator. Restarting elevated..."
    Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# ***************************************************************
# Enable Developer Mode by setting the required registry settings
# ***************************************************************
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"

# Create the registry key if it doesn't exist yet
if (-not (Test-Path $registryPath)) {
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion" -Name "AppModelUnlock" -Force | Out-Null
}

# Enable Developer Mode by setting both keys that some Windows versions require
Set-ItemProperty -Path $registryPath -Name "AllowDevelopmentWithoutDevLicense" -Value 1 -Type DWord
Set-ItemProperty -Path $registryPath -Name "DeveloperMode" -Value 1 -Type DWord

Write-Host "Developer Mode has been enabled."

# ***************************************
# Install Visual Studio Code via Winget
# ***************************************
if (!(Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "Winget is not installed or available. Please install the Windows Package Manager first."
} else {
    Write-Host "Installing Visual Studio Code..."
    winget install --id Microsoft.VisualStudioCode -e --accept-package-agreements --accept-source-agreements
}

# **********************************************************
# Download and Install Git for Windows from GitForWindows.org
# **********************************************************
# Note: This URL points to a specific Git for Windows version. 
# Update it as needed for the latest version.
$gitInstallerUrl = "https://github.com/git-for-windows/git/releases/download/v2.49.0.windows.1/Git-2.49.0-64-bit.exe"
$gitInstallerPath = "$env:TEMP\GitInstaller.exe"

try {
    Write-Host "Downloading Git installer from $gitInstallerUrl..."
    Invoke-WebRequest -Uri $gitInstallerUrl -OutFile $gitInstallerPath -ErrorAction Stop
    
    Write-Host "Download successful. Running the Git installer silently..."
    # The installer is NSIS-based. The "/VERYSILENT" flag minimizes UI, and "/NORESTART" prevents an automatic restart.
    Start-Process -FilePath $gitInstallerPath -ArgumentList "/VERYSILENT", "/NORESTART" -Wait -ErrorAction Stop
    
    Write-Host "Git for Windows installation completed successfully."
    
    # Clean up the installer file
    Remove-Item -Path $gitInstallerPath -Force
}
catch {
    Write-Host "An error occurred while downloading or installing Git for Windows: $_"
}

Write-Host "Script completed. A system restart may be required for all changes to take effect."