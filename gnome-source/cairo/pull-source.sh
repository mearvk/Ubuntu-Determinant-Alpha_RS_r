#!/usr/bin/env bash
set -euo pipefail
umask 022

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
DEST="$ROOT/gnome-source/cairo"

# Cairo is a freedesktop.org project, not a GNOME GitHub repository.
# For ISO/source acquisition we use the official Cairo release archive rather
# than a live GitLab clone. This avoids credential-helper prompts and gives us
# a deterministic, checksummed source release.
VERSION="${CAIRO_VERSION:-1.18.4}"
BASE_URL="${CAIRO_RELEASE_BASE_URL:-https://cairographics.org/releases}"
ARCHIVE="cairo-${VERSION}.tar.xz"
URL="${CAIRO_SOURCE_URL:-${BASE_URL}/${ARCHIVE}}"
EXPECTED_SHA256="${CAIRO_SHA256:-}"

# Cairo 1.18.4 is the current pinned default. The official release page gives
# this SHA256 and identifies the signed 1.18.4 Git tag/commit.
if [ "$VERSION" = "1.18.4" ] && [ -z "$EXPECTED_SHA256" ]; then
  EXPECTED_SHA256="445ed8208a6e4823de1226a74ca319d3600e83f6369f99b14265006599c32ccb"
fi

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

command -v curl >/dev/null || { echo 'ERROR: curl is required' >&2; exit 1; }
command -v sha256sum >/dev/null || { echo 'ERROR: sha256sum is required' >&2; exit 1; }
command -v tar >/dev/null || { echo 'ERROR: tar is required' >&2; exit 1; }

case "$URL" in
  https://cairographics.org/releases/*|https://www.cairographics.org/releases/*)
    ;;
  *)
    echo "ERROR: CAIRO_SOURCE_URL must point to the official Cairo release archive." >&2
    echo "       Current URL: $URL" >&2
    exit 2
    ;;
esac

if [ -z "$EXPECTED_SHA256" ]; then
  echo "ERROR: No SHA256 is configured for Cairo ${VERSION}." >&2
  echo "       Supply CAIRO_SHA256 explicitly rather than downloading unverified source." >&2
  exit 2
fi

echo "=== Pulling Cairo source release ==="
echo "  Version:    $VERSION"
echo "  Archive:    $URL"
echo "  SHA256:     $EXPECTED_SHA256"

curl --fail --location --retry 3 --proto '=https' --tlsv1.2 \
  --output "$TMP/$ARCHIVE" "$URL"

ACTUAL_SHA256="$(sha256sum "$TMP/$ARCHIVE" | awk '{print $1}')"
if [ "$ACTUAL_SHA256" != "$EXPECTED_SHA256" ]; then
  echo "ERROR: Cairo source checksum mismatch." >&2
  echo "       Expected: $EXPECTED_SHA256" >&2
  echo "       Actual:   $ACTUAL_SHA256" >&2
  exit 1
fi

echo "=== Cairo source checksum verified ==="
sha256sum "$TMP/$ARCHIVE"

rm -rf "$TMP/cairo"
tar -xJf "$TMP/$ARCHIVE" -C "$TMP"

SRC="$TMP/cairo-${VERSION}"
test -d "$SRC" || { echo "ERROR: expected extracted directory $SRC not found" >&2; exit 1; }
test -f "$SRC/meson.build" || { echo 'ERROR: incomplete Cairo source tree (meson.build missing)' >&2; exit 1; }
test -f "$SRC/README.md" || { echo 'ERROR: incomplete Cairo source tree (README.md missing)' >&2; exit 1; }

# The release archive is already a source distribution and contains no Git
# metadata. Preserve it as our local upstream baseline, without overwriting
# any future Determinant offset/patch directory.
mkdir -p "$DEST"
rm -rf "$DEST/upstream"
mkdir -p "$DEST/upstream"
cp -a "$SRC/." "$DEST/upstream/"

cat > "$DEST/SOURCE-INFO.txt" <<EOF
Cairo upstream source baseline
Project: Cairo
Version: ${VERSION}
Archive: ${URL}
SHA256: ${EXPECTED_SHA256}
Source repository: https://gitlab.freedesktop.org/cairo/cairo
Official release page: https://cairographics.org/news/cairo-${VERSION}/

The source is imported under upstream/ so Determinant patches and offsets can
remain separate from the original upstream source.
EOF

printf 'Imported Cairo %s into %s/upstream\n' "$VERSION" "$DEST"
printf '%s\n' 'No GitHub/GitLab username or password is required for this release download.'
printf '%s\n' 'Upstream source: https://gitlab.freedesktop.org/cairo/cairo'
