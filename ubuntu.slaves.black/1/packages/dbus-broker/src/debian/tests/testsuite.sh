#!/bin/sh
set -uxe

DEB_HOST_GNU_TYPE="$(dpkg-architecture -qDEB_HOST_GNU_TYPE)"
meson test -C "obj-${DEB_HOST_GNU_TYPE}"
