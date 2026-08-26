$ErrorActionPreference = 'Stop'

$Repository = 'https://github.com/apache/maven.git'
$Revision = 'master'
$Target = Join-Path (Split-Path -Parent $PSScriptRoot) 'upstream'

if (Test-Path $Target) {
    throw "Refusing to overwrite existing Maven source: $Target"
}

Write-Host "Cloning Apache Maven source from $Repository"
Write-Host "Requested revision: $Revision"

git clone --no-tags $Repository $Target
Push-Location $Target
try {
    git fetch --depth 1 origin $Revision
    git checkout --detach FETCH_HEAD
    $Commit = git rev-parse HEAD
    Write-Host "Pinned source revision: $Commit"
}
finally {
    Pop-Location
}

Write-Host "Source checkout complete: $Target"
