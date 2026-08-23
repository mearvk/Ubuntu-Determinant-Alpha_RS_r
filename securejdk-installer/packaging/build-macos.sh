#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ARCH="$(uname -m)"
OUT="$ROOT/dist/macos-$ARCH"
rm -rf "$OUT" "$ROOT/target/lib"
mkdir -p "$OUT"

cd "$ROOT"
mvn -B clean package dependency:copy-dependencies -DoutputDirectory=target/lib

MP="target/classes:$(printf '%s' target/lib/*.jar | tr ' ' ':')"

COMMON=(
  --name SecureJDK28
  --app-version 28.0.0
  --vendor "Secure JDK"
  --description "Secure JDK 28 JavaFX installer"
  --module-path "$MP"
  --module com.securejdk.installer/com.securejdk.installer.SecureJdkInstallerApp
  --mac-package-identifier com.securejdk.installer.SecureJDK28
  --mac-package-name SecureJDK28
  --dest "$OUT"
)

jpackage --type dmg "${COMMON[@]}"
jpackage --type app-image "${COMMON[@]}"

cat > "$OUT/README.txt" <<'EOF'
Secure JDK 28 macOS Native Installer

SecureJDK28.dmg contains the JavaFX application bundle.
The production release must be signed and notarized with the project's Apple Developer credentials before public distribution.
EOF
