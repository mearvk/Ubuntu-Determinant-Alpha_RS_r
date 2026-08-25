#!/bin/sh
# End-to-end rehearsal for Java input, native C/C++ payloads, localized
# .xclass/.asysma output, and the optional desktop launcher.
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
TEST_DIR="$ROOT/tests"
JAVA_DIR="$TEST_DIR/java"
NATIVE_DIR="$TEST_DIR/native"

cd "$ROOT"
make all
chmod +x "$ROOT/xmc-install-desktop.sh"

CC_BIN=${CC:-cc}
CXX_BIN=${CXX:-c++}

C_BIN="$NATIVE_DIR/xmc_native_probe"
CPP_BIN="$NATIVE_DIR/xmc_native_probe_cpp"

"$CC_BIN" -std=c11 -Wall -Wextra -Werror -O2 \
    -o "$C_BIN" "$NATIVE_DIR/xmc_native_probe.c"
"$CXX_BIN" -std=c++17 -Wall -Wextra -Werror -O2 \
    -o "$CPP_BIN" "$NATIVE_DIR/xmc_native_probe.cpp"

[ "$("$C_BIN")" = "xmc-native-c=22" ]
[ "$("$CPP_BIN")" = "xmc-native-cpp=27" ]

for source in \
    "$JAVA_DIR/XmcDesktopProbe.java" \
    "$JAVA_DIR/XmcControlFlowProbe.java"
do
    rm -f "${source%.java}.xclass" "${source%.java}.asysma"
    "$ROOT/xmc-build" --verbose "$source"
    [ -s "${source%.java}.xclass" ]
    [ -s "${source%.java}.asysma" ]
    # The unified driver deliberately localizes artifacts beside the source.
    [ "$(dirname "${source%.java}.asysma")" = "$(dirname "$source")" ]
done

# Exercise explicit native packaging against the Java XMC artifact.
"$ROOT/asysma_pack" \
    --output "$JAVA_DIR/XmcDesktopProbe.native-then-java.asysma" \
    --entry NATIVE_THEN_JAVA \
    --java XmcDesktopProbe \
    --xclass "$JAVA_DIR/XmcDesktopProbe.xclass" \
    --native "$C_BIN"

[ -s "$JAVA_DIR/XmcDesktopProbe.native-then-java.asysma" ]

# Verify the desktop installer produces a real per-source launcher.
HOME="$TEST_DIR/home" XDG_DATA_HOME="$TEST_DIR/home/.local/share" \
    "$ROOT/xmc-install-desktop.sh" "$JAVA_DIR/XmcDesktopProbe.java"

[ -f "$JAVA_DIR/XmcDesktopProbe.desktop" ]
[ -f "$TEST_DIR/home/.local/share/applications/XmcDesktopProbe.desktop" ]

grep -q '^Type=Application$' "$JAVA_DIR/XmcDesktopProbe.desktop"
grep -q '^Terminal=true$' "$JAVA_DIR/XmcDesktopProbe.desktop"
grep -q 'xmc-build --verbose' "$JAVA_DIR/XmcDesktopProbe.desktop"

echo "xmc process rehearsal: PASS"
echo "localized Java ASYSMA: $JAVA_DIR/XmcDesktopProbe.asysma"
echo "native+Java ASYSMA: $JAVA_DIR/XmcDesktopProbe.native-then-java.asysma"
echo "desktop launcher: $JAVA_DIR/XmcDesktopProbe.desktop"

rm -f "$C_BIN" "$CPP_BIN" \
      "$JAVA_DIR"/*.xclass "$JAVA_DIR"/*.asysma "$JAVA_DIR"/*.desktop
rm -rf "$TEST_DIR/home"
