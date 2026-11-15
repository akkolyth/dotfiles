$ErrorActionPreference = 'Stop'
$source = Join-Path (Split-Path $PSScriptRoot -Parent) 'config\glazewm\workspace-session.ps1'
$destination = Join-Path $env:USERPROFILE '.glzr\glazewm\workspace-session.ps1'
$backup = "$destination.before-dotfiles.bak"

New-Item -ItemType Directory -Path (Split-Path $destination -Parent) -Force | Out-Null
$temp = "$destination.$PID.tmp"
try {
    Copy-Item -LiteralPath $source -Destination $temp
    if ((Get-FileHash -LiteralPath $temp).Hash -ne (Get-FileHash -LiteralPath $source).Hash) {
        throw 'Copied script does not match the source.'
    }
    $existing = Get-Item -LiteralPath $destination -Force -ErrorAction SilentlyContinue
    if ($existing) {
        if (-not (Test-Path -LiteralPath $backup)) {
            Copy-Item -LiteralPath $destination -Destination $backup
        }
        if ($existing.Attributes -band [IO.FileAttributes]::ReparsePoint) {
            [IO.File]::Delete($destination)
        }
    }
    Move-Item -LiteralPath $temp -Destination $destination -Force
} finally {
    if (Test-Path -LiteralPath $temp) { Remove-Item -LiteralPath $temp }
}
Get-Item -LiteralPath $destination | Select-Object FullName, LinkType, Length
