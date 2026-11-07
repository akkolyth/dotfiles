param([switch]$Apply)

$ErrorActionPreference = 'Stop'
$source = Join-Path $PSScriptRoot '../config/alacritty/alacritty.toml'
$destination = Join-Path $env:APPDATA 'alacritty/alacritty.toml'

if (Test-Path -LiteralPath $destination) {
    if ((Get-FileHash -LiteralPath $source).Hash -eq (Get-FileHash -LiteralPath $destination).Hash) {
        Write-Output "Already installed $destination"
        return
    }
    if ($Apply) {
        $backup = "$destination.backup-$([Guid]::NewGuid().ToString('N'))"
        Copy-Item -LiteralPath $destination -Destination $backup
        Write-Output "Backed up existing config to $backup"
    } else {
        Write-Output "Would back up and replace $destination"
        return
    }
}

if (!$Apply) {
    Write-Output "Would install $destination"
    return
}

New-Item -ItemType Directory -Path (Split-Path -Parent $destination) -Force | Out-Null
Copy-Item -LiteralPath $source -Destination $destination -Force
Write-Output "Installed $destination"
