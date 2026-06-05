param(
    [string]$Destination,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$install = Join-Path $scriptRoot "scripts\install.ps1"
$preflight = Join-Path $scriptRoot "scripts\preflight.ps1"

$installArgs = @()
if ($Destination) {
    $installArgs += "-Destination"
    $installArgs += $Destination
}
if ($Force) {
    $installArgs += "-Force"
}

& powershell -ExecutionPolicy Bypass -File $install @installArgs
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

& powershell -ExecutionPolicy Bypass -File $preflight
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}
