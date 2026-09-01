#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-2.0
#
# make-repo.sh — generate a flat/pool APT repository index over the .deb files
# in packaging/out/pool/, producing the dists/ tree apt expects:
#
#   out/
#     pool/                         <- the .deb files (built by build-deb.sh)
#     dists/stable/
#       Release                     <- top-level index (later GPG-signed in CI)
#       main/binary-<arch>/
#         Packages
#         Packages.gz
#
# It prefers apt-ftparchive, then dpkg-scanpackages; if neither exists it falls
# back to a portable pure-shell generator so the index can still be produced on
# minimal hosts (e.g. this repo's sandbox). GPG signing is intentionally NOT
# done here — the CI workflow signs Release after calling this script, so the
# private key never has to touch a developer machine.
#
# Copyright (C) 2026 MEARVK LLC
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
OUT="${1:-$HERE/out}"
POOL="$OUT/pool"

SUITE="${APT_SUITE:-stable}"
COMPONENT="${APT_COMPONENT:-main}"
ARCH="${DEB_ARCH:-$(dpkg --print-architecture 2>/dev/null || echo amd64)}"
ORIGIN="Ubuntu Determinant"
LABEL="Ubuntu Determinant White Edition"

if [ ! -d "$POOL" ] || [ -z "$(ls -A "$POOL"/*.deb 2>/dev/null || true)" ]; then
    echo "!! no .deb files in $POOL — run packaging/build-deb.sh first" >&2
    exit 1
fi

BINDIR="$OUT/dists/$SUITE/$COMPONENT/binary-$ARCH"
mkdir -p "$BINDIR"

echo "==> generating Packages index for arch=$ARCH suite=$SUITE component=$COMPONENT"

# ---- Packages file ----------------------------------------------------------
# Paths inside Packages must be relative to the repository root (OUT), so apt
# fetches e.g. pool/os-security-installer_1.0.0_amd64.deb.
generate_packages_portable() {
    local deb ctl size sha256 md5 sha1 fname
    : > "$BINDIR/Packages"
    for deb in "$POOL"/*.deb; do
        fname="pool/$(basename "$deb")"
        size=$(stat -c%s "$deb")
        md5=$(md5sum "$deb" | awk '{print $1}')
        sha1=$(sha1sum "$deb" | awk '{print $1}')
        sha256=$(sha256sum "$deb" | awk '{print $1}')

        # Extract the control file from the .deb (ar member control.tar.gz).
        ctl="$(mktemp -d)"
        ( cd "$ctl" && ar x "$deb" control.tar.gz 2>/dev/null && tar -xzf control.tar.gz ./control 2>/dev/null || tar -xzf control.tar.gz control 2>/dev/null || true )
        # Emit the stanza: control fields + apt pool/checksum fields.
        # Insert Filename/Size/checksums right after the Description-less head by
        # simply appending the standard fields; apt accepts field order freely.
        sed -e '/^$/d' "$ctl/control" >> "$BINDIR/Packages"
        {
            echo "Filename: $fname"
            echo "Size: $size"
            echo "MD5sum: $md5"
            echo "SHA1: $sha1"
            echo "SHA256: $sha256"
            echo ""
        } >> "$BINDIR/Packages"
        rm -rf "$ctl"
    done
}

if command -v apt-ftparchive >/dev/null 2>&1; then
    ( cd "$OUT" && apt-ftparchive packages pool > "dists/$SUITE/$COMPONENT/binary-$ARCH/Packages" )
elif command -v dpkg-scanpackages >/dev/null 2>&1; then
    ( cd "$OUT" && dpkg-scanpackages --multiversion pool /dev/null > "dists/$SUITE/$COMPONENT/binary-$ARCH/Packages" )
else
    echo "   (apt-ftparchive/dpkg-scanpackages absent; using portable generator)"
    generate_packages_portable
fi

gzip -9 -c "$BINDIR/Packages" > "$BINDIR/Packages.gz"

# ---- Release file -----------------------------------------------------------
RELEASE="$OUT/dists/$SUITE/Release"
DATE="$(date -Ru | sed 's/+0000/GMT/')"

# Helper: emit "<checksum> <size> <path>" lines for each index file, with the
# path relative to dists/<suite>/ as apt requires.
checksum_block() {
    local algo="$1" tool="$2" f rel
    echo "$algo:"
    for f in "$OUT/dists/$SUITE/$COMPONENT/binary-$ARCH/Packages" \
             "$OUT/dists/$SUITE/$COMPONENT/binary-$ARCH/Packages.gz"; do
        rel="${f#$OUT/dists/$SUITE/}"
        printf ' %s %16d %s\n' "$($tool "$f" | awk '{print $1}')" "$(stat -c%s "$f")" "$rel"
    done
}

if command -v apt-ftparchive >/dev/null 2>&1; then
    apt-ftparchive \
        -o "APT::FTPArchive::Release::Origin=$ORIGIN" \
        -o "APT::FTPArchive::Release::Label=$LABEL" \
        -o "APT::FTPArchive::Release::Suite=$SUITE" \
        -o "APT::FTPArchive::Release::Codename=$SUITE" \
        -o "APT::FTPArchive::Release::Components=$COMPONENT" \
        -o "APT::FTPArchive::Release::Architectures=$ARCH" \
        release "$OUT/dists/$SUITE" > "$RELEASE"
else
    {
        echo "Origin: $ORIGIN"
        echo "Label: $LABEL"
        echo "Suite: $SUITE"
        echo "Codename: $SUITE"
        echo "Components: $COMPONENT"
        echo "Architectures: $ARCH"
        echo "Date: $DATE"
        checksum_block "MD5Sum" md5sum
        checksum_block "SHA256" sha256sum
    } > "$RELEASE"
fi

echo "==> wrote:"
echo "    $BINDIR/Packages(.gz)"
echo "    $RELEASE"
echo "==> NOTE: Release is unsigned here; CI signs it into InRelease + Release.gpg."
