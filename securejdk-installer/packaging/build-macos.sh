#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/dist/macos-aarch64"
rm -rf "$OUT" "$ROOT/target/lib"
mkdir -p "$OUT"

cd "$ROOT"
mvn -B clean package dependency:copy-dependencies -DoutputDirectory=target/lib

MP="target/classes:$(printf '%s' target/lib/*.jar | tr ' ' ':')"
jpackage \
  --type dmg \
  --name SecureJDK28 \
  --app-version 28.0.0 \
  --vendor "Secure JDK" \
  --description "Secure JDK 28 JavaFX installer" \
  --module-path "$MP" \
  --module com.securejdk.installer/com.securejdk.installer.SecureJdkInstallerApp \
  --mac-package-identifier com.securejdk.installer.SecureJDK28 \
  --mac-package-name SecureJDK28 \
  --dest "$OUT"

jpackage \
  --type app-image \
  --name SecureJDK28 \
  --app-version 28.0.0 \
  --vendor "Secure JDK" \
  --description "Secure JDK 28 JavaFX installer" \
  --module-path "$MP" \
  --module com.securejdk.installer/com.securejdk.installer.SecureJdkInstallerApp \
  --mac-package-identifier com.securejdk.installer.SecureJDK28 \
  --mac-package-name SecureJDK28 \
  --dest "$OUT"

cat > "$OUT/README.txt" <<'EOF'
Secure JDK 28 macOS Native Installer

SecureJDK28.dmg contains the signed/notarized-ready JavaFX application bundle.
Production release signing and notarization must be performed with the project's Apple Developer credentials.
EOF
