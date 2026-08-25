#!/bin/sh
set -eu
PREFIX=/usr/local/sbin
UNIT_DIR=/etc/systemd/system
STATE=/var/lib/ctrmsctl
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

if [ "$(id -u)" -ne 0 ]; then
    echo "error: install.sh must be run as root" >&2
    exit 1
fi

mkdir -p "$PREFIX" "$STATE" "$UNIT_DIR"
cc -std=c11 -O2 -Wall -Wextra -Werror -D_GNU_SOURCE "$ROOT/ctrmsctl.c" -o "$PREFIX/ctrmsctl"
install -m 0644 "$ROOT/ctrmsctl.service" "$UNIT_DIR/ctrmsctl.service"
chmod 0755 "$PREFIX/ctrmsctl"
systemctl daemon-reload
systemctl enable ctrmsctl.service
systemctl restart ctrmsctl.service

echo "ctrmsctl installed and enabled."
echo "Query the metadata index with: ctrmsctl status"
echo "Search by basename with: ctrmsctl find NAME"
echo "Search paths with: ctrmsctl search TEXT"
echo "Locate a path fragment with: ctrmsctl locate PATH"
