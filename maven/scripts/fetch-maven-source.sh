#!/usr/bin/env sh
set -eu

REPO="https://github.com/apache/maven.git"
REVISION="master"
TARGET="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)/upstream"

if [ -e "$TARGET" ]; then
  echo "Refusing to overwrite existing Maven source: $TARGET" >&2
  exit 2
fi

echo "Cloning Apache Maven source from $REPO"
echo "Requested revision: $REVISION"
git clone --no-tags "$REPO" "$TARGET"
cd "$TARGET"
git fetch --depth 1 origin "$REVISION"
git checkout --detach FETCH_HEAD

echo "Pinned source revision: $(git rev-parse HEAD)"
echo "Source checkout complete: $TARGET"
