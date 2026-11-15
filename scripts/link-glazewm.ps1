$ErrorActionPreference = 'Stop'
$source = Join-Path (Split-Path $PSScriptRoot -Parent) 'config\glazewm\workspace-session.ps1'
$destination = Join-Path $env:USERPROFILE '.glzr\glazewm\workspace-session.ps1'
$tempLink = "$destination.dotfiles-link"
$backup = "$destination.before-dotfiles.bak"

if (Test-Path -LiteralPath $tempLink) { throw "Temporary link already exists: $tempLink" }
New-Item -ItemType SymbolicLink -Path $tempLink -Target $source | Out-Null
try {
    if ((Get-FileHash -LiteralPath $tempLink).Hash -ne (Get-FileHash -LiteralPath $source).Hash) {
        throw 'Symlink content does not match the source.'
    }
    if (Test-Path -LiteralPath $destination) {
        if (Test-Path -LiteralPath $backup) { throw "Backup already exists: $backup" }
        Move-Item -LiteralPath $destination -Destination $backup
    }
    try { Move-Item -LiteralPath $tempLink -Destination $destination }
    catch {
        if (Test-Path -LiteralPath $backup) { Move-Item -LiteralPath $backup -Destination $destination }
        throw
    }
} finally {
    if (Test-Path -LiteralPath $tempLink) { Remove-Item -LiteralPath $tempLink }
}
Get-Item -LiteralPath $destination | Select-Object FullName, LinkType, Target
