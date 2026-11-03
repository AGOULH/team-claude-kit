# One-line full install (Windows PowerShell):
#   irm https://raw.githubusercontent.com/AGOULH/team-claude-kit/main/setup.ps1 | iex
$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$tmp = Join-Path $env:TEMP ("team-claude-kit-" + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $tmp | Out-Null
Write-Host "Downloading kit..."
Invoke-WebRequest -UseBasicParsing https://codeload.github.com/AGOULH/team-claude-kit/zip/refs/heads/main -OutFile "$tmp\kit.zip"
Expand-Archive "$tmp\kit.zip" -DestinationPath $tmp -Force
powershell -NoProfile -ExecutionPolicy Bypass -File "$tmp\team-claude-kit-main\install.ps1"
Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue
