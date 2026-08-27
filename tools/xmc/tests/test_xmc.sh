#!/bin/sh
set -eu
cd "$(dirname "$0")/.."

tmp=$(mktemp -d "${TMPDIR:-/tmp}/xmc-test.XXXXXX")
trap 'rm -rf "$tmp"' EXIT HUP INT TERM

cat > "$tmp/Hello.java" <<'EOF'
public class Hello {
    public static void main(String[] args) {
        System.out.println("hello");
    }
}
EOF

./xmc-core "$tmp/Hello.java" >"$tmp/compiler.out"
test -s "$tmp/Hello.xclass"
grep -q "Hello" "$tmp/Hello.xclass"

echo "test_xmc: PASS"
