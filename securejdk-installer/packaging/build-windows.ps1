$ErrorActionPreference = 'Stop'

$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$Out = Join-Path $Root 'dist\windows-x64'

Remove-Item -Recurse -Force $Out -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force (Join-Path $Root 'target\lib') -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force $Out | Out-Null

Set-Location $Root
mvn -B clean package dependency:copy-dependencies -DoutputDirectory=target/lib

$libs = (Get-ChildItem (Join-Path $Root 'target\lib\*.jar') | ForEach-Object { $_.FullName }) -join ';'
$modulePath = "$(Join-Path $Root 'target\classes');$libs"

jpackage `
  --type exe `
  --name SecureJDK28 `
  --app-version 28.0.0 `
  --vendor 'Secure JDK' `
  --description 'Secure JDK 28 JavaFX installer' `
  --module-path $modulePath `
  --module 'com.securejdk.installer/com.securejdk.installer.SecureJdkInstallerApp' `
  --win-menu `
  --win-menu-group 'Secure JDK 28' `
  --win-shortcut `
  --win-dir-chooser `
  --dest $Out

$exe = Join-Path $Out 'SecureJDK28-28.0.0.exe'
if (Test-Path $exe) {
    Move-Item $exe (Join-Path $Out 'SecureJDK28.exe')
}

Get-ChildItem $Out
