#!/bin/bash
# fetch-openjdk.sh - Download and install OpenJDK 28 EA
#
# OpenJDK 28 is ~227 MB and exceeds GitHub file limits,
# so we fetch it at build time rather than storing it in the repo.
#
# License: GPL-2.0 with Classpath Exception (open source)
# Source: https://jdk.java.net/28/
#
# Copyright (C) 2026 MEARVK LLC

set -e

VERSION="28"
BUILD="8"
ARCH="linux-x64"
FILENAME="openjdk-${VERSION}-ea+${BUILD}_${ARCH}_bin.tar.gz"
URL="https://download.java.net/java/early_access/jdk${VERSION}/${BUILD}/GPL/${FILENAME}"
SHA256_URL="${URL}.sha256"

DEST_DIR="${1:-$(dirname "$0")}"
INSTALL_DIR="${2:-}"

echo "=== OpenJDK ${VERSION} Early Access (Build ${BUILD}) ==="
echo ""

# Download if not already present
if [ -f "$DEST_DIR/$FILENAME" ]; then
    echo "Already downloaded: $DEST_DIR/$FILENAME"
else
    echo "Downloading OpenJDK ${VERSION} EA+${BUILD} (linux-x64, ~227 MB)..."
    wget -q --show-progress -O "$DEST_DIR/$FILENAME" "$URL"
    echo ""
fi

# Verify checksum
echo "Verifying SHA256..."
EXPECTED_SHA=$(wget -qO- "$SHA256_URL" | awk '{print $1}')
ACTUAL_SHA=$(sha256sum "$DEST_DIR/$FILENAME" | awk '{print $1}')

if [ "$EXPECTED_SHA" = "$ACTUAL_SHA" ]; then
    echo "  ✓ Checksum verified"
else
    echo "  ✗ CHECKSUM MISMATCH!"
    echo "    Expected: $EXPECTED_SHA"
    echo "    Got:      $ACTUAL_SHA"
    rm -f "$DEST_DIR/$FILENAME"
    exit 1
fi

# Install if INSTALL_DIR specified
if [ -n "$INSTALL_DIR" ]; then
    echo ""
    echo "Installing to $INSTALL_DIR/usr/lib/jvm/openjdk-${VERSION}..."
    mkdir -p "$INSTALL_DIR/usr/lib/jvm"
    tar -xzf "$DEST_DIR/$FILENAME" -C "$INSTALL_DIR/usr/lib/jvm/"

    # The tarball extracts to jdk-28/
    JDK_DIR="$INSTALL_DIR/usr/lib/jvm/jdk-${VERSION}"

    # Create symlinks for system-wide access
    mkdir -p "$INSTALL_DIR/usr/bin"
    for bin in java javac jar jshell javadoc jlink jpackage; do
        ln -sf "/usr/lib/jvm/jdk-${VERSION}/bin/$bin" "$INSTALL_DIR/usr/bin/$bin"
    done

    # Set JAVA_HOME in profile
    mkdir -p "$INSTALL_DIR/etc/profile.d"
    cat > "$INSTALL_DIR/etc/profile.d/java.sh" << EOF
# OpenJDK ${VERSION} - Galactic Cherry Marvell Edition 98
export JAVA_HOME=/usr/lib/jvm/jdk-${VERSION}
export PATH=\$JAVA_HOME/bin:\$PATH
EOF

    echo "  ✓ JDK installed to /usr/lib/jvm/jdk-${VERSION}"
    echo "  ✓ Binaries symlinked to /usr/bin/"
    echo "  ✓ JAVA_HOME set in /etc/profile.d/java.sh"
    echo ""
    echo "  java --version:"
    if [ -x "$JDK_DIR/bin/java" ]; then
        "$JDK_DIR/bin/java" --version 2>/dev/null | head -1 || echo "    (cross-compiled, cannot execute here)"
    fi
fi

echo ""
echo "Done. OpenJDK ${VERSION} EA+${BUILD} ready."
