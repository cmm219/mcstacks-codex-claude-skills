$ErrorActionPreference = "Stop"
$errors = 0

function Find-Claude {
    if ($env:CLAUDE_CLI_PATH -and (Test-Path -LiteralPath $env:CLAUDE_CLI_PATH)) {
        return $env:CLAUDE_CLI_PATH
    }

    $cmd = Get-Command claude -ErrorAction SilentlyContinue
    if ($cmd) {
        return $cmd.Source
    }

    $candidates = @(
        (Join-Path $env:APPDATA "npm\claude.cmd"),
        (Join-Path $env:APPDATA "npm\claude.ps1")
    )

    foreach ($candidate in $candidates) {
        if (Test-Path -LiteralPath $candidate) {
            return $candidate
        }
    }

    return $null
}

$codexSkills = if ($env:CODEX_HOME) {
    Join-Path $env:CODEX_HOME "skills"
} else {
    $homeDir = if ($env:USERPROFILE) { $env:USERPROFILE } else { $HOME }
    Join-Path $homeDir ".codex\skills"
}

Write-Output "McStacks preflight"
Write-Output "Platform: Windows PowerShell"
Write-Output "Codex skills directory: $codexSkills"

if (-not (Test-Path -LiteralPath $codexSkills)) {
    Write-Output "WARN: Codex skills directory does not exist. Run scripts\install.ps1 to create it."
}

$git = Get-Command git -ErrorAction SilentlyContinue
if ($git) {
    Write-Output "Git: $($git.Source)"
} else {
    Write-Output "ERROR: git not found on PATH."
    $errors++
}

$codex = Get-Command codex -ErrorAction SilentlyContinue
if ($codex) {
    Write-Output "Codex: $($codex.Source)"
    try {
        $codexVersion = & $codex.Source --version
        Write-Output "Codex version: $codexVersion"
    } catch {
        Write-Output "WARN: Codex version check failed: $($_.Exception.Message)"
    }
} else {
    Write-Output "WARN: codex not found on PATH. Skills may still work in Codex Desktop if installed."
}

$claudePath = Find-Claude
if ($claudePath) {
    Write-Output "Claude CLI: $claudePath"
    try {
        $claudeVersion = & $claudePath --version
        Write-Output "Claude version: $claudeVersion"
    } catch {
        Write-Output "WARN: Claude version check failed: $($_.Exception.Message)"
    }
} else {
    Write-Output "ERROR: Claude CLI not found. Install Claude Code or set CLAUDE_CLI_PATH."
    $errors++
}

if ($env:ANTHROPIC_API_KEY) {
    Write-Output "WARN: ANTHROPIC_API_KEY is set. Claude CLI calls may use API spend."
}
if ($env:ANTHROPIC_AUTH_TOKEN) {
    Write-Output "WARN: ANTHROPIC_AUTH_TOKEN is set. Check your Claude CLI auth route."
}
if ($env:ANTHROPIC_BASE_URL) {
    Write-Output "WARN: ANTHROPIC_BASE_URL is set. Claude CLI may use an alternate endpoint."
}

$policy = Get-ExecutionPolicy -Scope CurrentUser
Write-Output "PowerShell execution policy (CurrentUser): $policy"
if ($policy -in @("Restricted", "AllSigned")) {
    Write-Output "If scripts are blocked, run: powershell -ExecutionPolicy Bypass -File .\scripts\install.ps1"
}

$validator = Join-Path (Split-Path -Parent $PSScriptRoot) "scripts\validate-skills.mjs"
$node = Get-Command node -ErrorAction SilentlyContinue
if ($node -and (Test-Path -LiteralPath $validator)) {
    try {
        & $node.Source $validator
    } catch {
        Write-Output "ERROR: skill validation failed."
        $errors++
    }
} else {
    Write-Output "WARN: Node not found or validator missing; skipped skill validation."
}

if ($errors -gt 0) {
    exit 1
}
