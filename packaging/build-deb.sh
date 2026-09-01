#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-2.0
#
# build-deb.sh — build .deb packages from the repository's precompiled installer
# binaries, driven by packaging/packages.manifest.
#
# Each package wraps exactly one native binary built from installer/linux/. The
# script first builds the binaries via the existing installer/linux/Makefile,
# then assembles one .deb per manifest entry.
#
# Portability: a .deb is just an `ar` archive of three members —
#   debian-binary, control.tar.gz, data.tar.gz
# so when dpkg-deb is unavailable (e.g. non-Debian build hosts, this repo's
# sandbox) the script assembles the archive with `ar` + `tar` directly. When
# dpkg-deb IS present it is preferred, for byte-for-byte-standard output.
#
# Output: packaging/out/pool/<pkg>_<version>_<arch>.deb
#
# Copyright (C) 2026 MEARVK LLC
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
LINUX="$ROOT/installer/linux"
MANIFEST="$HERE/packages.manifest"
OUT="$HERE/out"
POOL="$OUT/pool"

# ---- Shared package metadata (kept consistent across every package) ---------
VERSION="${DEB_VERSION:-1.0.0}"
MAINTAINER="${DEB_MAINTAINER:-MEARVK LLC <packages@mearvk.example>}"
ARCH="${DEB_ARCH:-$(dpkg --print-architecture 2>/dev/null || echo amd64)}"
SECTION="admin"
PRIORITY="optional"
HOMEPAGE="https://github.com/mearvk/Ubuntu.Determinant.Beta.Restricted"

echo "==> build-deb: version=$VERSION arch=$ARCH"

# ---- 1. Build the native binaries via the existing Makefile -----------------
echo "==> building installer binaries (make -C installer/linux all)"
make -C "$LINUX" all

# ---- 2. Assemble one .deb per manifest entry --------------------------------
rm -rf "$OUT"
mkdir -p "$POOL"

have_dpkg_deb=0
command -v dpkg-deb >/dev/null 2>&1 && have_dpkg_deb=1

# Assemble a .deb the portable way (ar + tar), used when dpkg-deb is absent.
# $1 = staging root containing DEBIAN/ and the installed tree; $2 = output path.
assemble_deb_portable() {
    local stage="$1" out="$2" tmp
    tmp="$(mktemp -d)"

    # control.tar.gz from the DEBIAN/ metadata dir.
    ( cd "$stage/DEBIAN" && tar --numeric-owner --owner=0 --group=0 -czf "$tmp/control.tar.gz" . )

    # data.tar.gz from everything EXCEPT DEBIAN/ (the payload filesystem tree).
    ( cd "$stage" && tar --numeric-owner --owner=0 --group=0 \
        --exclude=./DEBIAN -czf "$tmp/data.tar.gz" . )

    # debian-binary format marker.
    printf '2.0\n' > "$tmp/debian-binary"

    # A .deb is an ar archive with these three members in this order.
    rm -f "$out"
    ( cd "$tmp" && ar rc "$out" debian-binary control.tar.gz data.tar.gz )
    rm -rf "$tmp"
}

built=0
while IFS='|' read -r pkg src bin dir desc; do
    # Skip comments / blank lines.
    case "${pkg// /}" in ''|\#*) continue ;; esac
    pkg="$(echo "$pkg" | xargs)"
    bin="$(echo "$bin" | xargs)"
    dir="$(echo "$dir" | xargs)"
    desc="$(echo "$desc" | xargs)"

    binpath="$LINUX/$bin"
    if [ ! -x "$binpath" ]; then
        echo "!! missing built binary for $pkg: $binpath" >&2
        exit 1
    fi

    stage="$(mktemp -d)"
    mkdir -p "$stage/DEBIAN" "$stage/$dir"
    install -m 0755 "$binpath" "$stage/$dir/$pkg"

    # Installed-Size is in KiB, rounded up (Debian policy uses 1 KiB blocks).
    size_kib=$(( ( $(stat -c%s "$binpath") + 1023 ) / 1024 ))

    cat > "$stage/DEBIAN/control" <<EOF
Package: $pkg
Version: $VERSION
Architecture: $ARCH
Maintainer: $MAINTAINER
Section: $SECTION
Priority: $PRIORITY
Installed-Size: $size_kib
Homepage: $HOMEPAGE
Description: $desc
 Precompiled native installer component from the Ubuntu Determinant
 White Edition project. Runs privileged actions through a fixed-argv
 allow-list rather than a shell, and defaults to a safe dry-run.
EOF

    out="$POOL/${pkg}_${VERSION}_${ARCH}.deb"
    if [ "$have_dpkg_deb" -eq 1 ]; then
        dpkg-deb --root-owner-group --build "$stage" "$out" >/dev/null
    else
        assemble_deb_portable "$stage" "$out"
    fi
    rm -rf "$stage"

    echo "   built $out"
    built=$((built + 1))
done < "$MANIFEST"

echo "==> done: $built package(s) in $POOL"
[ "$have_dpkg_deb" -eq 1 ] || echo "   (assembled with ar+tar fallback; dpkg-deb not present)"
