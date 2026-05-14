param(
    [string]$Destination,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$source = Join-Path $repoRoot "skills"

if (-not (Test-Path -LiteralPath $source)) {
    throw "Cannot find skills directory: $source"
}

if (-not $Destination) {
    if ($env:CODEX_HOME) {
        $Destination = Join-Path $env:CODEX_HOME "skills"
    } else {
        $homeDir = if ($env:USERPROFILE) { $env:USERPROFILE } else { $HOME }
        $Destination = Join-Path $homeDir ".codex\skills"
    }
}

New-Item -ItemType Directory -Path $Destination -Force | Out-Null

Get-ChildItem -LiteralPath $source -Directory | ForEach-Object {
    $target = Join-Path $Destination $_.Name
    if (Test-Path -LiteralPath $target) {
        if (-not $Force) {
            throw "Target already exists: $target. Re-run with -Force to overwrite."
        }
        Remove-Item -LiteralPath $target -Recurse -Force
    }
    Copy-Item -LiteralPath $_.FullName -Destination $target -Recurse
    Write-Output "Installed $($_.Name) -> $target"
}

Write-Output ""
Write-Output "Done. Run scripts\preflight.ps1 to verify Claude/Codex paths."
