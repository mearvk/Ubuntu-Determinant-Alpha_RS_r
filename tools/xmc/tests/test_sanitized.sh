#!/bin/sh
set -eu
compiler=${1:?sanitized compiler path required}
tmp=$(mktemp -d "${TMPDIR:-/tmp}/xmc-sanitize.XXXXXX")
trap 'rm -rf "$tmp"' EXIT HUP INT TERM

cat > "$tmp/Sanitize.java" <<'EOF'
public class Sanitize {
    public int add(int a, int b) { return a + b; }
}
EOF

"$compiler" "$tmp/Sanitize.java" >"$tmp/out"
test -s "$tmp/Sanitize.xclass"
echo "test_sanitized: PASS"
