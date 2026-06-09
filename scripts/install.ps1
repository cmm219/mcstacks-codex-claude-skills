param(
    [string]$Destination,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$source = $repoRoot

if (-not $Destination) {
    if ($env:CODEX_HOME) {
        $Destination = Join-Path $env:CODEX_HOME "skills"
    } else {
        $homeDir = if ($env:USERPROFILE) { $env:USERPROFILE } else { $HOME }
        $Destination = Join-Path $homeDir ".codex\skills"
    }
}

New-Item -ItemType Directory -Path $Destination -Force | Out-Null

# Claude-driver skills live in this repo for visibility but install into the
# Claude Code skills directory, not the Codex skills directory.
$claudeDriverSkills = @("codex-readonly-review")

$skillDirs = Get-ChildItem -LiteralPath $source -Directory | Where-Object {
    Test-Path -LiteralPath (Join-Path $_.FullName "SKILL.md")
}

$skillDirs | Where-Object { $claudeDriverSkills -contains $_.Name } | ForEach-Object {
    Write-Output "Skipped $($_.Name) (Claude-driver skill; install into your Claude Code skills directory instead)"
}
$skillDirs = @($skillDirs | Where-Object { $claudeDriverSkills -notcontains $_.Name })

if (-not $skillDirs) {
    throw "No root-level skill directories found in: $source"
}

$skillDirs | ForEach-Object {
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

$sourceHead = "unknown"
$head = (git -C $repoRoot rev-parse HEAD 2>$null)
if ($LASTEXITCODE -eq 0 -and $head) { $sourceHead = $head.Trim() }

$sourceRemote = "https://github.com/cmm219/mcstacks-codex-claude-skills.git"
$remote = (git -C $repoRoot remote get-url origin 2>$null)
if ($LASTEXITCODE -eq 0 -and $remote) { $sourceRemote = $remote.Trim() }

$version = "unknown"
$changelog = Join-Path $repoRoot "CHANGELOG.md"
if (Test-Path -LiteralPath $changelog) {
    $versionLine = Get-Content -Path $changelog | Where-Object { $_ -match '^##\s+([0-9]+\.[0-9]+\.[0-9]+)' } | Select-Object -First 1
    if ($versionLine -match '^##\s+([0-9]+\.[0-9]+\.[0-9]+)') { $version = $Matches[1] }
}

$manifestDir = Join-Path $Destination ".mcstacks"
New-Item -ItemType Directory -Path $manifestDir -Force | Out-Null
$manifest = [ordered]@{
    schemaVersion = 1
    name = "mcstacks"
    version = $version
    installedAtUtc = (Get-Date).ToUniversalTime().ToString("o")
    installType = "repo-root"
    sourcePath = $repoRoot
    sourceRemote = $sourceRemote
    sourceHead = $sourceHead
    destination = $Destination
    skills = @($skillDirs | ForEach-Object {
        [ordered]@{
            name = $_.Name
            installedPath = (Join-Path $Destination $_.Name)
        }
    })
}
$manifestJson = $manifest | ConvertTo-Json -Depth 5
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText((Join-Path $manifestDir "manifest.json"), "$manifestJson`n", $utf8NoBom)

Write-Output ""
Write-Output "Done. Run scripts\preflight.ps1 to verify Claude/Codex paths."
