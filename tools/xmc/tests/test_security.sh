#!/bin/sh
set -eu
cd "$(dirname "$0")/.."

# Regression guard: trusted compiler paths must not reintroduce shell command
# construction or shell-pipe execution.
if grep -nE '\b(system|popen)\s*\(' xmc-driver.c xmc-os-register.c >/dev/null 2>&1; then
    echo "test_security: shell process API found in trusted driver/registration code" >&2
    exit 1
fi

tmp=$(mktemp -d "${TMPDIR:-/tmp}/xmc-security.XXXXXX")
trap 'rm -rf "$tmp"' EXIT HUP INT TERM

# Apostrophes in source paths must remain data, not shell syntax.
src="$tmp/O'Brien.java"
cat > "$src" <<'EOF'
public class OBrien {
    public int value() { return 1; }
}
EOF
./xmc "$src" >"$tmp/out"
test -s "$tmp/O'Brien.xclass"

echo "test_security: PASS"
