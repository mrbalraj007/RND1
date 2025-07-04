<powershell>
# Windows Server 2025 Setup Script for DevOps Tools

# Set execution policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force

# Create log file
$LogFile = "C:\Windows\Temp\setup.log"
Start-Transcript -Path $LogFile

# Enable Windows Features
Write-Output "Enabling Windows Features..."
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole -All
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServer -All
Enable-WindowsOptionalFeature -Online -FeatureName IIS-CommonHttpFeatures -All
Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpRedirect -All

# Install Chocolatey
Write-Output "Installing Chocolatey..."
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Refresh environment variables
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Install essential tools via Chocolatey
Write-Output "Installing development tools..."
choco install -y git
choco install -y nodejs
choco install -y python3
choco install -y docker-desktop
choco install -y vscode
choco install -y postman
choco install -y 7zip
choco install -y googlechrome
choco install -y putty
choco install -y openssh

# Install PowerShell 7
choco install -y powershell-core

# Install .NET SDK
choco install -y dotnet-sdk

# Install Azure CLI
choco install -y azure-cli

# Install AWS CLI
choco install -y awscli

# Configure Windows for development
Write-Output "Configuring Windows settings..."

# Enable Developer Mode
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v "AllowDevelopmentWithoutDevLicense" /d "1"

# Enable Remote Desktop
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -Value 0
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

# Configure WinRM for remote management
Write-Output "Configuring WinRM..."
winrm quickconfig -q
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'

# Configure firewall rules
Write-Output "Configuring firewall rules..."
New-NetFirewallRule -DisplayName "HTTP" -Direction Inbound -Protocol TCP -LocalPort 80 -Action Allow
New-NetFirewallRule -DisplayName "HTTPS" -Direction Inbound -Protocol TCP -LocalPort 443 -Action Allow
New-NetFirewallRule -DisplayName "SonarQube" -Direction Inbound -Protocol TCP -LocalPort 9000 -Action Allow
New-NetFirewallRule -DisplayName "Jenkins" -Direction Inbound -Protocol TCP -LocalPort 8080 -Action Allow
New-NetFirewallRule -DisplayName "Custom Apps" -Direction Inbound -Protocol TCP -LocalPort 3000 -Action Allow

# Create directories for DevOps tools
Write-Output "Creating directories..."
New-Item -ItemType Directory -Force -Path "C:\DevOps"
New-Item -ItemType Directory -Force -Path "C:\DevOps\Scripts"
New-Item -ItemType Directory -Force -Path "C:\DevOps\Logs"

# Set timezone
tzutil /s "UTC"

# Create a welcome message
$WelcomeMessage = @"
Windows Server 2025 DevOps Environment Setup Complete!

Installed Tools:
- Git
- Node.js
- Python 3
- Docker Desktop
- Visual Studio Code
- Postman
- Azure CLI
- AWS CLI
- PowerShell 7
- .NET SDK

Services Configured:
- IIS Web Server
- WinRM (Port 5985/5986)
- Remote Desktop (Port 3389)
- Firewall rules for development ports

Next Steps:
1. Connect via RDP using: ${env:COMPUTERNAME}
2. Complete Docker Desktop setup
3. Configure additional development tools as needed

Setup completed at: $(Get-Date)
"@

$WelcomeMessage | Out-File -FilePath "C:\DevOps\README.txt"

Write-Output "Setup completed successfully!"
Stop-Transcript
</powershell>
