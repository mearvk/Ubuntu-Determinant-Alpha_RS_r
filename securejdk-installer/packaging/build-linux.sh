#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/dist/linux-x86_64"
rm -rf "$OUT" "$ROOT/target/lib"
mkdir -p "$OUT"

cd "$ROOT"
mvn -B clean package dependency:copy-dependencies -DoutputDirectory=target/lib

MP="target/classes:$(printf '%s' target/lib/*.jar | tr ' ' ':')"
jpackage \
  --type app-image \
  --name SecureJDK28 \
  --app-version 28.0.0 \
  --vendor "Secure JDK" \
  --description "Secure JDK 28 JavaFX installer" \
  --module-path "$MP" \
  --module com.securejdk.installer/com.securejdk.installer.SecureJdkInstallerApp \
  --dest "$OUT"

APP="$OUT/SecureJDK28"
test -x "$APP/bin/SecureJDK28"
cp "$APP/bin/SecureJDK28" "$OUT/SecureJDK28.sans"
chmod 0755 "$OUT/SecureJDK28.sans"

cat > "$OUT/README.txt" <<'EOF'
Secure JDK 28 Linux Native Installer

SecureJDK28.sans is the ELF launcher generated from the JavaFX jpackage application image.
The complete self-contained application is in ./SecureJDK28/.

Run:
  ./SecureJDK28.sans

The .sans suffix is a Secure JDK product naming convention; the file remains an ELF executable.
EOF

tar -C "$OUT" -czf "$OUT/SecureJDK28-linux-x86_64.tar.gz" SecureJDK28 SecureJDK28.sans README.txt
file "$OUT/SecureJDK28.sans"
