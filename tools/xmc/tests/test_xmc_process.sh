#!/bin/sh
set -eu
cd "$(dirname "$0")/.."

tmp=$(mktemp -d "${TMPDIR:-/tmp}/xmc-process.XXXXXX")
trap 'rm -rf "$tmp"' EXIT HUP INT TERM

cat > "$tmp/Process.java" <<'EOF'
public class Process {
    private int value = 7;
    public int value() { return value; }
}
EOF

./xmc "$tmp/Process.java" >"$tmp/driver.out"
test -s "$tmp/Process.xclass"

grep -q "Process.xclass" "$tmp/driver.out"

echo "test_xmc_process: PASS"
