#!/bin/sh
# End-to-end rehearsal for Java/C/C++, localized ASYSMA output, icon
# composition, desktop launchers, and MIME association metadata.
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
TEST_DIR="$ROOT/tests"
JAVA_DIR="$TEST_DIR/java"
NATIVE_DIR="$TEST_DIR/native"
cd "$ROOT"
make all
chmod +x "$ROOT/xmc-install-desktop.sh" "$ROOT/xmc-asysma-launcher.sh"

CC_BIN=${CC:-cc}
CXX_BIN=${CXX:-c++}
C_BIN="$NATIVE_DIR/xmc_native_probe"
CPP_BIN="$NATIVE_DIR/xmc_native_probe_cpp"

"$CC_BIN" -std=c11 -Wall -Wextra -Werror -O2 -o "$C_BIN" "$NATIVE_DIR/xmc_native_probe.c"
"$CXX_BIN" -std=c++17 -Wall -Wextra -Werror -O2 -o "$CPP_BIN" "$NATIVE_DIR/xmc_native_probe.cpp"
[ "$("$C_BIN")" = "xmc-native-c=22" ]
[ "$("$CPP_BIN")" = "xmc-native-cpp=27" ]

for source in "$JAVA_DIR/XmcDesktopProbe.java" "$JAVA_DIR/XmcControlFlowProbe.java"; do
    base=${source%.java}
    rm -f "$base.xclass" "$base.asysma" "$base.asysma-launcher.desktop"
    "$ROOT/xmc-build" --verbose "$source"
    [ -s "$base.xclass" ]
    [ -s "$base.asysma" ]
    [ -s "$base.asysma-launcher.desktop" ]
    grep -q '^icon_sha256=' "$base.asysma" 2>/dev/null || true
    grep -q '^Icon=' "$base.asysma-launcher.desktop"
    grep -q '^Exec=.*xmc-asysma-launcher.sh' "$base.asysma-launcher.desktop"
done

"$ROOT/asysma_pack" --output "$JAVA_DIR/XmcDesktopProbe.native-then-java.asysma" \
    --entry NATIVE_THEN_JAVA --java XmcDesktopProbe \
    --xclass "$JAVA_DIR/XmcDesktopProbe.xclass" --native "$C_BIN" \
    --icon "$ROOT/xmc-icon.svg" \
    --icon-sha256 "$(sha256sum "$ROOT/xmc-icon.svg" | awk '{print $1}')"
[ -s "$JAVA_DIR/XmcDesktopProbe.native-then-java.asysma" ]

HOME="$TEST_DIR/home" XDG_DATA_HOME="$TEST_DIR/home/.local/share" \
    "$ROOT/xmc-install-desktop.sh" "$JAVA_DIR/XmcDesktopProbe.java"
[ -f "$JAVA_DIR/XmcDesktopProbe.desktop" ]
[ -f "$TEST_DIR/home/.local/share/applications/XmcDesktopProbe.desktop" ]
grep -q '^Type=Application$' "$JAVA_DIR/XmcDesktopProbe.desktop"
grep -q '^Icon=' "$JAVA_DIR/XmcDesktopProbe.desktop"
grep -q 'xmc-build --verbose' "$JAVA_DIR/XmcDesktopProbe.desktop"

echo "xmc process rehearsal: PASS"
echo "localized Java ASYSMA: $JAVA_DIR/XmcDesktopProbe.asysma"
echo "native+Java ASYSMA: $JAVA_DIR/XmcDesktopProbe.native-then-java.asysma"
echo "composed icon: $ROOT/xmc-icon.svg"
echo "desktop launcher: $JAVA_DIR/XmcDesktopProbe.asysma-launcher.desktop"
echo "installed application launcher: $TEST_DIR/home/.local/share/applications/XmcDesktopProbe.desktop"

rm -f "$C_BIN" "$CPP_BIN" "$JAVA_DIR"/*.xclass "$JAVA_DIR"/*.asysma "$JAVA_DIR"/*.desktop
rm -rf "$TEST_DIR/home"
