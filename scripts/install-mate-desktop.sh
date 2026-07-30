#!/bin/bash
# SPDX-License-Identifier: GPL-2.0
#
# install-mate-desktop.sh — Install MATE Desktop with Red Cherry theme
#
# Provisions the MATE Desktop Environment into the assembled rootfs.
# Run inside chroot during rootfs-full assembly or on a live system.
#
# This gives a full graphical Ubuntu-like desktop with:
#   - LightDM display manager (graphical login)
#   - MATE Desktop 1.26+ (panels, file manager, settings)
#   - Marco window manager (compositing)
#   - Caja file manager
#   - Red/Cherry GTK theme
#   - Humanity icon theme (Ubuntu native)
#   - Galactic Cherry wallpapers
#   - Plymouth boot splash
#
# Usage:
#   In chroot: ./install-mate-desktop.sh
#   During build: chroot build/rootfs /usr/sbin/install-mate-desktop.sh
#
# Copyright (C) 2026 MEARVK LLC
# Author: Maximilian Eric Alexander Rupplin von Keffikon

set -e

echo "╔══════════════════════════════════════════════════╗"
echo "║  MATE Desktop — Galactic Cherry Red Theme       ║"
echo "║  Ubuntu Determinant Alpha RS                    ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""

# ============================================================
# Prerequisites check
# ============================================================

if [ "$(id -u)" -ne 0 ]; then
    echo "ERROR: Must run as root (or inside chroot)"
    exit 1
fi

# Ensure apt is available and DNS works (or skip if offline)
if ! command -v apt-get >/dev/null 2>&1; then
    echo "ERROR: apt-get not found. Is this an Ubuntu rootfs?"
    exit 1
fi

# ============================================================
# Configure apt sources (Noble Numbat 24.04)
# ============================================================

if [ ! -f /etc/apt/sources.list ] || ! grep -q "noble" /etc/apt/sources.list 2>/dev/null; then
    cat > /etc/apt/sources.list << 'EOF'
deb http://archive.ubuntu.com/ubuntu noble main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu noble-updates main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu noble-security main restricted universe multiverse
EOF
fi

# ============================================================
# Install MATE Desktop + LightDM
# ============================================================

echo "=== Updating package lists ==="
apt-get update -qq

echo ""
echo "=== Installing MATE Desktop Environment ==="

export DEBIAN_FRONTEND=noninteractive

# Core MATE desktop
apt-get install -y --no-install-recommends \
    mate-desktop-environment-core \
    mate-themes \
    mate-icon-theme \
    mate-terminal \
    mate-system-monitor \
    mate-utils \
    mate-media \
    mate-power-manager \
    mate-notification-daemon \
    pluma \
    eom \
    atril \
    engrampa \
    caja-open-terminal

# Display manager
echo ""
echo "=== Installing LightDM ==="
apt-get install -y --no-install-recommends \
    lightdm \
    lightdm-gtk-greeter \
    lightdm-gtk-greeter-settings

# Graphics stack
echo ""
echo "=== Installing graphics libraries ==="
apt-get install -y --no-install-recommends \
    xserver-xorg-core \
    xserver-xorg-input-libinput \
    xserver-xorg-video-fbdev \
    xserver-xorg-video-vesa \
    mesa-utils \
    libgl1-mesa-dri \
    libglib2.0-bin \
    dbus-x11 \
    x11-xserver-utils \
    x11-utils

# Fonts
echo ""
echo "=== Installing fonts ==="
apt-get install -y --no-install-recommends \
    fonts-ubuntu \
    fonts-dejavu-core \
    fonts-noto-core \
    fonts-noto-color-emoji

# Network (for GUI wifi/network config)
echo ""
echo "=== Installing NetworkManager ==="
apt-get install -y --no-install-recommends \
    network-manager \
    network-manager-gnome

# Audio
echo ""
echo "=== Installing audio ==="
apt-get install -y --no-install-recommends \
    pulseaudio \
    pavucontrol

# Plymouth boot splash
echo ""
echo "=== Installing Plymouth ==="
apt-get install -y --no-install-recommends \
    plymouth \
    plymouth-theme-ubuntu-text

# ============================================================
# Configure for graphical boot
# ============================================================

echo ""
echo "=== Configuring graphical target ==="

# Set default boot to graphical
systemctl set-default graphical.target 2>/dev/null || \
    ln -sf /lib/systemd/system/graphical.target /etc/systemd/system/default.target

# Enable LightDM
systemctl enable lightdm 2>/dev/null || \
    ln -sf /lib/systemd/system/lightdm.service /etc/systemd/system/display-manager.service

# Enable NetworkManager
systemctl enable NetworkManager 2>/dev/null || true

# ============================================================
# Red Cherry GTK Theme
# ============================================================

echo ""
echo "=== Configuring Red Cherry Theme ==="

# Create custom Red Cherry GTK theme based on Ambiant-MATE-Dark
# Override accent colors to cherry red
THEME_DIR="/usr/share/themes/GalacticCherry"
mkdir -p "${THEME_DIR}/gtk-3.0"
mkdir -p "${THEME_DIR}/gtk-2.0"
mkdir -p "${THEME_DIR}/metacity-1"

# GTK-3 CSS overrides — Red accent on dark background
cat > "${THEME_DIR}/gtk-3.0/gtk.css" << 'EOF'
/* Galactic Cherry Red Theme — based on Ambiant-MATE-Dark */
@import url("/usr/share/themes/Ambiant-MATE-Dark/gtk-3.0/gtk.css");

/* Override accent colors to cherry red */
@define-color selected_bg_color #C0392B;
@define-color selected_fg_color #FFFFFF;
@define-color link_color #E74C3C;
@define-color accent_color #C0392B;
@define-color theme_selected_bg_color #C0392B;
@define-color theme_selected_fg_color #FFFFFF;
@define-color suggested_action_bg #C0392B;
@define-color destructive_action_bg #922B21;

/* Panel: dark with subtle cherry tint */
@define-color panel_bg #1A0A0A;
@define-color panel_fg #F5E6E6;

/* Buttons */
button:checked,
button.suggested-action {
    background-color: #C0392B;
    color: #FFFFFF;
}

/* Headerbar selection */
headerbar selection,
.titlebar selection {
    background-color: #C0392B;
    color: #FFFFFF;
}

/* Switch */
switch:checked {
    background-color: #C0392B;
}

/* Progress bars */
progressbar progress,
levelbar block.filled {
    background-color: #C0392B;
}

/* Scrollbar */
scrollbar slider:hover {
    background-color: #E74C3C;
}

/* Check/Radio buttons */
check:checked,
radio:checked {
    background-color: #C0392B;
}
EOF

# GTK-2 theme — inherit Ambiant-MATE-Dark with red overrides
cat > "${THEME_DIR}/gtk-2.0/gtkrc" << 'EOF'
# Galactic Cherry Red — GTK2
include "/usr/share/themes/Ambiant-MATE-Dark/gtk-2.0/gtkrc"

style "cherry-default" {
    bg[SELECTED] = "#C0392B"
    fg[SELECTED] = "#FFFFFF"
    base[SELECTED] = "#C0392B"
    text[SELECTED] = "#FFFFFF"
}
widget_class "*" style "cherry-default"
EOF

# Metacity (Marco) window borders — red titlebar accent
cat > "${THEME_DIR}/metacity-1/metacity-theme-3.xml" << 'EOF'
<?xml version="1.0"?>
<metacity_theme>
<info>
  <name>GalacticCherry</name>
  <author>MEARVK LLC</author>
  <description>Dark theme with cherry red accents</description>
</info>
</metacity_theme>
EOF

# Create theme index
cat > "${THEME_DIR}/index.theme" << 'EOF'
[Desktop Entry]
Type=X-GNOME-Metatheme
Name=Galactic Cherry
Comment=Dark theme with cherry red accents for Ubuntu Determinant Alpha RS
Encoding=UTF-8

[X-GNOME-Metatheme]
GtkTheme=GalacticCherry
MetacityTheme=GalacticCherry
IconTheme=Humanity
CursorTheme=default
EOF

# ============================================================
# System-wide MATE defaults
# ============================================================

# MATE default settings (dconf)
MATE_DEFAULTS="/usr/share/glib-2.0/schemas/99_galactic-cherry.gschema.override"
cat > "${MATE_DEFAULTS}" << 'EOF'
[org.mate.interface]
gtk-theme='GalacticCherry'
icon-theme='Humanity'
font-name='Ubuntu 11'
document-font-name='Ubuntu 11'
monospace-font-name='Ubuntu Mono 13'

[org.mate.Marco.general]
theme='GalacticCherry'
titlebar-font='Ubuntu Bold 11'
compositing-manager=true

[org.mate.background]
picture-filename='/usr/share/backgrounds/galactic-cherry/galactic-cherry-default.svg'
picture-options='zoom'
primary-color='#1A0A0A'
secondary-color='#2C1010'
color-shading-type='vertical'

[org.mate.caja.desktop]
font='Ubuntu 11'

[org.mate.panel]
default-layout='redmond'

[org.mate.session]
required-components-list=['windowmanager', 'panel', 'filemanager']

[org.mate.peripherals-mouse]
cursor-theme='default'

[org.mate.NotificationDaemon]
theme='slider'

[org.mate.power-manager]
sleep-display-ac=900
sleep-display-battery=300
EOF

# Compile schemas
glib-compile-schemas /usr/share/glib-2.0/schemas/ 2>/dev/null || true

# ============================================================
# LightDM Configuration — Cherry login screen
# ============================================================

mkdir -p /etc/lightdm

cat > /etc/lightdm/lightdm.conf << 'EOF'
[LightDM]
logind-check-graphical=true

[Seat:*]
greeter-session=lightdm-gtk-greeter
user-session=mate
autologin-user-timeout=0

[VNC Server]
enabled=false
EOF

cat > /etc/lightdm/lightdm-gtk-greeter.conf << 'EOF'
[greeter]
background=/usr/share/backgrounds/galactic-cherry/galactic-cherry-default.svg
theme-name=GalacticCherry
icon-theme-name=Humanity
font-name=Ubuntu 11
xft-antialias=true
xft-dpi=96
xft-hintstyle=hintslight
xft-rgba=rgb
indicators=~host;~spacer;~clock;~spacer;~session;~power
clock-format=%H:%M  %a %d %b
position=50%,center 50%,center
panel-position=top
EOF

# ============================================================
# Wallpaper integration
# ============================================================

# Ensure Galactic Cherry wallpapers are in the right place
WALLPAPER_DIR="/usr/share/backgrounds/galactic-cherry"
if [ ! -d "${WALLPAPER_DIR}" ]; then
    mkdir -p "${WALLPAPER_DIR}"
    echo "NOTE: Wallpapers will be installed by 'make wallpapers-install'"
fi

# Create MATE background properties file for wallpaper picker
mkdir -p /usr/share/mate-background-properties
cat > /usr/share/mate-background-properties/galactic-cherry.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE wallpapers SYSTEM "mate-wp-list.dtd">
<wallpapers>
  <wallpaper deleted="false">
    <name>Galactic Cherry (Default)</name>
    <filename>/usr/share/backgrounds/galactic-cherry/galactic-cherry-default.svg</filename>
    <options>zoom</options>
    <shade_type>solid</shade_type>
    <pcolor>#1A0A0A</pcolor>
  </wallpaper>
  <wallpaper deleted="false">
    <name>Cherry Dawn</name>
    <filename>/usr/share/backgrounds/galactic-cherry/cherry-dawn.svg</filename>
    <options>zoom</options>
  </wallpaper>
  <wallpaper deleted="false">
    <name>Galaxy Core</name>
    <filename>/usr/share/backgrounds/galactic-cherry/galaxy-core.svg</filename>
    <options>zoom</options>
  </wallpaper>
  <wallpaper deleted="false">
    <name>Cherry Blossom Night</name>
    <filename>/usr/share/backgrounds/galactic-cherry/cherry-blossom-night.svg</filename>
    <options>zoom</options>
  </wallpaper>
  <wallpaper deleted="false">
    <name>Aurora Cherry</name>
    <filename>/usr/share/backgrounds/galactic-cherry/aurora-cherry.svg</filename>
    <options>zoom</options>
  </wallpaper>
  <wallpaper deleted="false">
    <name>Moonlit Ocean</name>
    <filename>/usr/share/backgrounds/galactic-cherry/moonlit-ocean.svg</filename>
    <options>zoom</options>
  </wallpaper>
  <wallpaper deleted="false">
    <name>Cherry Light</name>
    <filename>/usr/share/backgrounds/galactic-cherry/cherry-light.svg</filename>
    <options>zoom</options>
  </wallpaper>
  <wallpaper deleted="false">
    <name>Cherry Nebula</name>
    <filename>/usr/share/backgrounds/galactic-cherry/cherry-nebula.svg</filename>
    <options>zoom</options>
  </wallpaper>
  <wallpaper deleted="false">
    <name>Minimal Dark</name>
    <filename>/usr/share/backgrounds/galactic-cherry/minimal-dark.svg</filename>
    <options>zoom</options>
  </wallpaper>
  <wallpaper deleted="false">
    <name>Marvell 001</name>
    <filename>/usr/share/backgrounds/galactic-cherry/ubuntu_marvell_001.jpeg</filename>
    <options>zoom</options>
  </wallpaper>
  <wallpaper deleted="false">
    <name>Marvell 002</name>
    <filename>/usr/share/backgrounds/galactic-cherry/ubuntu_marvell_002.jpeg</filename>
    <options>zoom</options>
  </wallpaper>
  <wallpaper deleted="false">
    <name>Marvell 003</name>
    <filename>/usr/share/backgrounds/galactic-cherry/ubuntu_marvell_003.jpeg</filename>
    <options>zoom</options>
  </wallpaper>
  <wallpaper deleted="false">
    <name>Marvell 004</name>
    <filename>/usr/share/backgrounds/galactic-cherry/ubuntu_marvell_004.jpeg</filename>
    <options>zoom</options>
  </wallpaper>
  <wallpaper deleted="false">
    <name>Marvell 005</name>
    <filename>/usr/share/backgrounds/galactic-cherry/ubuntu_marvell_005.jpeg</filename>
    <options>zoom</options>
  </wallpaper>
  <wallpaper deleted="false">
    <name>Marvell 006</name>
    <filename>/usr/share/backgrounds/galactic-cherry/ubuntu_marvell_006.jpeg</filename>
    <options>zoom</options>
  </wallpaper>
  <wallpaper deleted="false">
    <name>Marvell 007</name>
    <filename>/usr/share/backgrounds/galactic-cherry/ubuntu_marvell_007.jpeg</filename>
    <options>zoom</options>
  </wallpaper>
  <wallpaper deleted="false">
    <name>Marvell 008</name>
    <filename>/usr/share/backgrounds/galactic-cherry/ubuntu_marvell_008.jpeg</filename>
    <options>zoom</options>
  </wallpaper>
  <wallpaper deleted="false">
    <name>Marvell 009</name>
    <filename>/usr/share/backgrounds/galactic-cherry/ubuntu_marvell_009.jpeg</filename>
    <options>zoom</options>
  </wallpaper>
  <wallpaper deleted="false">
    <name>Marvell 010</name>
    <filename>/usr/share/backgrounds/galactic-cherry/ubuntu_marvell_010.jpeg</filename>
    <options>zoom</options>
  </wallpaper>
</wallpapers>
EOF

# ============================================================
# Cleanup
# ============================================================

echo ""
echo "=== Cleaning apt cache ==="
apt-get clean
rm -rf /var/lib/apt/lists/*

# ============================================================
# Summary
# ============================================================

echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║  MATE DESKTOP INSTALLED                         ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""
echo "  Desktop:      MATE (Ubuntu-style)"
echo "  Theme:        Galactic Cherry Red (dark + #C0392B accents)"
echo "  Icons:        Humanity (Ubuntu native)"
echo "  Login:        LightDM with Cherry background"
echo "  Boot target:  graphical.target"
echo "  Wallpapers:   9 SVG + 10 JPEG (19 total)"
echo "  Fonts:        Ubuntu, DejaVu, Noto"
echo "  Audio:        PulseAudio"
echo "  Network:      NetworkManager (GUI)"
echo ""
echo "  On boot: LightDM → MATE session → Cherry Red desktop"
echo ""
echo "  To test: systemctl start lightdm"
echo ""
