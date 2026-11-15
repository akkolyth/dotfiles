param([switch]$SkipRestore)

$ErrorActionPreference = 'Stop'
$cli = 'C:\Program Files\glzr.io\GlazeWM\cli\glazewm.exe'
$snapshot = Join-Path $PSScriptRoot 'workspace-session.json'
$log = Join-Path $PSScriptRoot 'workspace-session-error.log'
$session = (Get-Process -Id $PID).SessionId

function Get-Manager {
    Get-Process glazewm -ErrorAction SilentlyContinue |
        Where-Object { $_.SessionId -eq $session -and $_.Id -ne $PID } |
        Sort-Object StartTime | Select-Object -First 1
}

function Invoke-Glaze {
    param([string[]]$Arguments)
    $output = & $cli @Arguments
    if ($LASTEXITCODE -ne 0) { throw "GlazeWM CLI exited with code $LASTEXITCODE" }
    $reply = ($output -join [Environment]::NewLine) | ConvertFrom-Json
    if (-not $reply.success) { throw "GlazeWM rejected the request: $($reply.message)" }
    $reply.data
}

function Get-WorkspaceWindows {
    param($Nodes, [string]$Workspace)
    foreach ($node in $Nodes) {
        if ($node.type -eq 'window') {
            [pscustomobject]@{
                Id = $node.id
                Handle = $node.handle
                Process = $node.processName
                Class = $node.className
                Title = $node.title
                Workspace = $Workspace
            }
        } elseif ($node.children) {
            Get-WorkspaceWindows $node.children $Workspace
        }
    }
}

function Get-Layout {
    $data = Invoke-Glaze @('query', 'workspaces')
    foreach ($workspace in $data.workspaces) {
        Get-WorkspaceWindows $workspace.children $workspace.name
    }
}

function Save-Layout {
    param([array]$Windows)
    $data = @{ Boot = $boot; Windows = $Windows }
    $temp = "$snapshot.$PID.tmp"
    [IO.File]::WriteAllText($temp, (ConvertTo-Json -InputObject $data -Depth 5))
    if ([IO.File]::Exists($snapshot)) {
        [IO.File]::Replace($temp, $snapshot, [NullString]::Value)
    } else {
        [IO.File]::Move($temp, $snapshot)
    }
}

function Write-ErrorLog {
    param($Failure)
    Set-Content -LiteralPath $log -Value "$(Get-Date -Format o) $Failure"
}

$manager = Get-Manager
if (-not $manager) { exit }
$mutex = New-Object Threading.Mutex($false, "Local\GlazeWMWorkspaceSession-$($manager.Id)")
$ownsMutex = $false
try {
    try { $ownsMutex = $mutex.WaitOne(0) }
    catch [Threading.AbandonedMutexException] { $ownsMutex = $true }
    if (-not $ownsMutex) { return }

    $boot = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime.ToUniversalTime().Ticks
    if (-not $SkipRestore -and (Test-Path -LiteralPath $snapshot)) {
        $saved = Get-Content -LiteralPath $snapshot -Raw | ConvertFrom-Json
        $previous = @($saved.Windows)
        $pending = [Collections.Generic.List[object]]::new()
        foreach ($item in $previous) { $pending.Add($item) }
        $used = @{}
        $deadline = (Get-Date).AddSeconds(90)
        while ($pending.Count -gt 0 -and -not $manager.HasExited) {
            $lastPass = (Get-Date) -ge $deadline
            try {
                $live = @(Get-Layout)
                foreach ($item in $pending.ToArray()) {
                    $group = @($live | Where-Object {
                        $_.Process -eq $item.Process -and $_.Class -eq $item.Class
                    })
                    $match = @()
                    if ($saved.Boot -eq $boot) {
                        $match = @($group | Where-Object { $_.Handle -eq $item.Handle })
                    }
                    if ($match.Count -ne 1 -and $item.Title) {
                        $sameTitle = @($previous | Where-Object {
                            $_.Process -eq $item.Process -and $_.Class -eq $item.Class -and
                            $_.Title -eq $item.Title
                        })
                        if ($sameTitle.Count -eq 1) {
                            $match = @($group | Where-Object { $_.Title -eq $item.Title })
                        }
                    }
                    if ($match.Count -ne 1 -and $lastPass -and $group.Count -eq 1) {
                        $oldGroup = @($previous | Where-Object {
                            $_.Process -eq $item.Process -and $_.Class -eq $item.Class
                        })
                        if ($oldGroup.Count -eq 1) { $match = $group }
                    }
                    if ($match.Count -ne 1 -or $used.ContainsKey($match[0].Id)) { continue }
                    $window = $match[0]
                    if ($manager.HasExited) { break }
                    if ($window.Workspace -ne $item.Workspace) {
                        Invoke-Glaze @('command', '--id', $window.Id, 'move', '--workspace', $item.Workspace) | Out-Null
                    }
                    $used[$window.Id] = $true
                    [void]$pending.Remove($item)
                }
            } catch { Write-ErrorLog $_ }
            if ($lastPass -or $pending.Count -eq 0) { break }
            Start-Sleep -Seconds 3
        }
    }

    while (-not $manager.HasExited) {
        try {
            $windows = @(Get-Layout)
            if ($windows.Count -gt 0 -and -not $manager.HasExited) {
                Save-Layout $windows
            }
        } catch { Write-ErrorLog $_ }
        [void]$manager.WaitForExit(60000)
    }
} catch {
    Write-ErrorLog $_
} finally {
    if ($ownsMutex) { $mutex.ReleaseMutex() }
    $mutex.Dispose()
}
