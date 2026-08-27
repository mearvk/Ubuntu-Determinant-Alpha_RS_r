$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$Src = Join-Path $Root 'dino'
$Build = Join-Path $Root 'build-windows'

if (-not (Test-Path $Src)) { throw "ERROR: $Src does not exist. Run pull-dino.sh in a Git-compatible environment first." }
if (-not (Get-Command meson -ErrorAction SilentlyContinue)) { throw 'ERROR: meson is required.' }
if (-not (Get-Command ninja -ErrorAction SilentlyContinue)) { throw 'ERROR: ninja is required.' }

meson setup $Build $Src --buildtype=debugoptimized --warnlevel=3
meson compile -C $Build
Write-Host "Trillian/Dino Windows build completed: $Build"
