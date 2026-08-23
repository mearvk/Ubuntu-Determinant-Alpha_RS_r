[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('status','search','install','update','update-all','remove','verify')]
    [string]$Action,

    [string]$Name
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Require-Winget {
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        throw 'winget is not available. Install or enable Microsoft App Installer before using this helper.'
    }
}

function Show-Target {
    param([string]$Operation, [string]$Package)
    Write-Host "Planned operation: $Operation"
    Write-Host "Target: $Package"
    Write-Host 'Persistent changes require explicit authorization.'
}

switch ($Action) {
    'status' {
        Require-Winget
        winget --version
        winget source list
    }
    'search' {
        if ([string]::IsNullOrWhiteSpace($Name)) { throw 'Name is required.' }
        Require-Winget
        winget search --name $Name
    }
    'install' {
        if ([string]::IsNullOrWhiteSpace($Name)) { throw 'Name is required.' }
        Require-Winget
        Show-Target 'install' $Name
        $answer = Read-Host 'Authorize this installation? [y/N]'
        if ($answer -notmatch '^(y|yes)$') { Write-Host 'Cancelled.'; exit 0 }
        winget install --name $Name --source winget --accept-source-agreements
    }
    'update' {
        if ([string]::IsNullOrWhiteSpace($Name)) { throw 'Name is required.' }
        Require-Winget
        Show-Target 'update' $Name
        $answer = Read-Host 'Authorize this update? [y/N]'
        if ($answer -notmatch '^(y|yes)$') { Write-Host 'Cancelled.'; exit 0 }
        winget upgrade --name $Name --source winget --accept-source-agreements
    }
    'update-all' {
        Require-Winget
        Show-Target 'update all applicable packages' 'winget'
        $answer = Read-Host 'Authorize all applicable updates? [y/N]'
        if ($answer -notmatch '^(y|yes)$') { Write-Host 'Cancelled.'; exit 0 }
        winget upgrade --all --source winget --accept-source-agreements
    }
    'remove' {
        if ([string]::IsNullOrWhiteSpace($Name)) { throw 'Name is required.' }
        Require-Winget
        Show-Target 'remove' $Name
        $answer = Read-Host 'Authorize this removal? [y/N]'
        if ($answer -notmatch '^(y|yes)$') { Write-Host 'Cancelled.'; exit 0 }
        winget uninstall --name $Name
    }
    'verify' {
        if ([string]::IsNullOrWhiteSpace($Name)) { throw 'Name is required.' }
        Require-Winget
        winget list --name $Name
    }
}
