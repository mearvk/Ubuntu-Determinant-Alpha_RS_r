#!/usr/bin/env bash
set -euo pipefail

# SPDX-License-Identifier: GPL-2.0
# Ubuntu Determinant GNOME Desktop installer.
# This is the production GNOME option; MATE remains available separately.

if [ "$(id -u)" -ne 0 ]; then
  echo "ERROR: Must run as root (or inside chroot)." >&2
  exit 1
fi
command -v apt-get >/dev/null 2>&1 || { echo "ERROR: apt-get not found." >&2; exit 1; }
export DEBIAN_FRONTEND=noninteractive

# The current ISO base is Ubuntu Noble; retain an existing configured archive
# when present, otherwise provide the standard Ubuntu repositories.
if [ ! -f /etc/apt/sources.list ] && [ ! -f /etc/apt/sources.list.d/ubuntu.sources ]; then
  cat > /etc/apt/sources.list <<'SOURCES'
deb http://archive.ubuntu.com/ubuntu noble main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu noble-updates main restricted universe multiverse
deb http://security.ubuntu.com/ubuntu noble-security main restricted universe multiverse
SOURCES
fi

apt-get update -qq

echo "=== Installing GNOME Desktop ==="
apt-get install -y --no-install-recommends \
  gnome-shell gnome-session mutter nautilus gnome-settings-daemon \
  gnome-control-center gnome-terminal gnome-system-monitor \
  gnome-software gnome-tweaks gnome-shell-extensions \
  gdm3 \
  xserver-xorg-core xserver-xorg-input-libinput \
  mesa-utils libgl1-mesa-dri dbus-x11 x11-xserver-utils x11-utils \
  fonts-ubuntu fonts-dejavu-core fonts-noto-core fonts-noto-color-emoji \
  network-manager network-manager-gnome \
  pipewire pipewire-pulse wireplumber pavucontrol \
  plymouth plymouth-theme-ubuntu-text

# GNOME uses GDM. Keep the display manager choice explicit so a previous
# LightDM/MATE installation does not silently remain the active session.
install -d /etc/systemd/system
printf '%s\n' '/usr/sbin/gdm3' > /etc/X11/default-display-manager
systemctl set-default graphical.target 2>/dev/null || \
  ln -sf /lib/systemd/system/graphical.target /etc/systemd/system/default.target
systemctl enable gdm3 2>/dev/null || \
  ln -sf /lib/systemd/system/gdm3.service /etc/systemd/system/display-manager.service
systemctl disable lightdm 2>/dev/null || true

# Prefer GNOME as the login session without forcing a user account.
install -d /etc/gdm3
cat > /etc/gdm3/custom.conf <<'GDM'
[daemon]
# Ubuntu Determinant defaults to GNOME; users may select another installed
# session from the GDM session chooser.
GDM

glib-compile-schemas /usr/share/glib-2.0/schemas/ 2>/dev/null || true

# Keep existing Determinant wallpaper assets available to GNOME.
if [ -d /usr/share/backgrounds/galactic-cherry ]; then
  install -d /usr/share/backgrounds/ubuntu-determinant
  cp -a /usr/share/backgrounds/galactic-cherry/. /usr/share/backgrounds/ubuntu-determinant/ 2>/dev/null || true
fi

echo "=== GNOME Desktop installed ==="
echo "  Shell:           GNOME Shell"
echo "  WM/compositor:   Mutter"
echo "  Files:            Nautilus"
echo "  Login:            GDM3"
