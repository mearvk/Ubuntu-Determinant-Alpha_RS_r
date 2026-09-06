# Packages — Ranked by Importance (8-Column Matrix)

## Homomorphic Ego Concentration

Each package is projected onto a perceivable scale of **0 to 83**:

- **83** = Perfectly standard. Foundational to computing itself.
- **0** = Perfectly non-relevant to standard. Decorative, niche, ornamental.

The *homomorphic ego concentration* is a structure-preserving map from the
space of all software packages to a single scalar representing how essential
a package is to the concept of "software standard next to man the sage."

## Column definitions

1. **Rank** — position in the disc-1 importance ordering (1 = most important).
2. **Software** — source package name (Ubuntu 22.04.3, disc 1).
3. **Years developed** — first public release year of the upstream project, where
   reliably known; otherwise `TBD` (not fabricated — this archive was assembled
   offline and per-package upstream dates are not verified here).
4. **Software house** — the upstream steward/organization, where reliably known;
   otherwise `TBD`.
5. **Age of expertise** — years of upstream maturity = 2026 − first release year,
   where known; otherwise `TBD`.
6. **Relative value** — band derived from the importance score: Foundational (≥75),
   High (60–74), Moderate (30–59), Low (10–29), Minimal (<10).
7. **Importance (0–83)** — the existing homomorphic-ego-concentration score,
   preserved verbatim.
8. **Improve** — importance of improving/integrating the package, derived from its
   score (with a short reason).
9. **Description** — from `DESCRIPTORS.md` (verbatim).

> Honesty note: **Years developed** and **Software house** are filled only where
> genuinely known; the majority are `TBD` rather than guessed. Descriptions and
> 0–83 scores are carried over from the existing `DESCRIPTORS.md` and the prior
> ranked `README.md`; they were not regenerated.

**Total packages: 681**

| Rank | Software | Years developed | Software house | Age of expertise | Relative value | Importance (0–83) | Improve | Description |
|-----:|---------|-----------------|----------------|-----------------:|----------------|:-----------------:|---------|-------------|
| 1 | **glibc** | 1988 | GNU / Free Software Foundation | 38 | Foundational | 83 | High — foundational; changes need strong evidence and review | GNU C Library — system's core C library |
| 2 | **coreutils** | 2002 | GNU Project | 24 | Foundational | 82 | High — foundational; changes need strong evidence and review | GNU core utilities (ls, cp, mv, cat, chmod, etc.) |
| 3 | **bash** | 1989 | GNU / Free Software Foundation | 37 | Foundational | 81 | High — foundational; changes need strong evidence and review | GNU Bourne Again SHell — default Linux command interpreter |
| 4 | **binutils** | 1990 | GNU Project | 36 | Foundational | 80 | High — foundational; changes need strong evidence and review | GNU binary utilities (ld, as, objdump, nm, etc.) |
| 5 | **gcc-defaults** | 1987 | GNU Project | 39 | Foundational | 80 | High — foundational; changes need strong evidence and review | Default GCC compiler version selection |
| 6 | **apt** | 1998 | Debian Project | 28 | Foundational | 79 | High — foundational; changes need strong evidence and review | Advanced Package Tool — Debian/Ubuntu package manager |
| 7 | **dpkg** | 1994 | Debian Project | 32 | Foundational | 79 | High — foundational; changes need strong evidence and review | Debian package management system core tool |
| 8 | **e2fsprogs** | 1993 | Theodore Ts'o / community | 33 | Foundational | 78 | High — foundational; changes need strong evidence and review | ext2/ext3/ext4 filesystem utilities |
| 9 | **findutils** | 1990 | GNU Project | 36 | Foundational | 78 | High — foundational; changes need strong evidence and review | GNU file-finding utilities (find, xargs, locate) |
| 10 | **grep** | 1984 | GNU Project | 42 | Foundational | 78 | High — foundational; changes need strong evidence and review | GNU grep — pattern matching utility |
| 11 | **gzip** | 1992 | GNU Project | 34 | Foundational | 78 | High — foundational; changes need strong evidence and review | GNU compression utility |
| 12 | **util-linux** | 1980 | Linux community (util-linux project) | 46 | Foundational | 78 | High — foundational; changes need strong evidence and review | Miscellaneous Linux system utilities (mount, fdisk, lsblk, etc.) |
| 13 | **base-files** | 1995 | Debian Project | 31 | Foundational | 77 | High — foundational; changes need strong evidence and review | Debian/Ubuntu base system configuration files |
| 14 | **base-passwd** | 1995 | Debian Project | 31 | Foundational | 77 | High — foundational; changes need strong evidence and review | Base system master password and group files |
| 15 | **bzip2** | 1996 | Julian Seward | 30 | Foundational | 77 | High — foundational; changes need strong evidence and review | Block-sorting file compressor |
| 16 | **dash** | TBD | TBD | TBD | Foundational | 77 | High — foundational; changes need strong evidence and review | POSIX-compliant shell (default /bin/sh in Debian/Ubuntu) |
| 17 | **diffutils** | 1988 | GNU Project | 38 | Foundational | 77 | High — foundational; changes need strong evidence and review | GNU file comparison utilities (diff, diff3, sdiff, cmp) |
| 18 | **adduser** | 1994 | Debian Project | 32 | Foundational | 76 | High — foundational; changes need strong evidence and review | Utility for adding and removing users and groups |
| 19 | **cpio** | TBD | TBD | TBD | Foundational | 76 | High — foundational; changes need strong evidence and review | GNU cpio archive utility |
| 20 | **hostname** | TBD | TBD | TBD | Foundational | 76 | High — foundational; changes need strong evidence and review | Utility for displaying/setting system hostname |
| 21 | **curl** | TBD | TBD | TBD | Foundational | 75 | High — foundational; changes need strong evidence and review | Command-line tool for transferring data via URLs (HTTP, FTP, etc.) |
| 22 | **git** | TBD | TBD | TBD | Foundational | 75 | High — foundational; changes need strong evidence and review | Fast distributed version control system |
| 23 | **gnutls28** | TBD | TBD | TBD | Foundational | 75 | High — foundational; changes need strong evidence and review | GNU TLS library — transport layer security implementation |
| 24 | **ca-certificates** | TBD | TBD | TBD | High | 74 | High — foundational; changes need strong evidence and review | Common CA certificates for SSL/TLS verification |
| 25 | **dbus** | TBD | TBD | TBD | High | 74 | High — foundational; changes need strong evidence and review | Simple interprocess messaging system (D-Bus) |
| 26 | **gnupg2** | 1997 | GnuPG Project / g10 Code | 29 | High | 74 | High — foundational; changes need strong evidence and review | GNU Privacy Guard — OpenPGP encryption and signing |
| 27 | **cmake** | TBD | TBD | TBD | High | 73 | High — foundational; changes need strong evidence and review | Cross-platform build system generator |
| 28 | **cryptsetup** | TBD | TBD | TBD | High | 73 | High — foundational; changes need strong evidence and review | Disk encryption setup utility (LUKS) |
| 29 | **grub2** | TBD | TBD | TBD | High | 73 | High — foundational; changes need strong evidence and review | GRand Unified Bootloader version 2 |
| 30 | **lvm2** | TBD | TBD | TBD | High | 73 | High — foundational; changes need strong evidence and review | Linux Logical Volume Manager tools |
| 31 | **python3-defaults** | 1991 | Python Software Foundation | 35 | High | 73 | High — foundational; changes need strong evidence and review | Default Python 3 interpreter selection |
| 32 | **autoconf** | 1991 | GNU Project | 35 | High | 72 | High — foundational; changes need strong evidence and review | GNU Autoconf — generates configure scripts from templates |
| 33 | **automake-1.16** | 1994 | GNU Project | 32 | High | 72 | High — foundational; changes need strong evidence and review | GNU Automake — generates Makefile.in from Makefile.am |
| 34 | **build-essential** | TBD | TBD | TBD | High | 72 | High — foundational; changes need strong evidence and review | Metapackage for essential Debian build tools (gcc, make, etc.) |
| 35 | **gettext** | TBD | TBD | TBD | High | 72 | High — foundational; changes need strong evidence and review | GNU internationalization (i18n) utilities |
| 36 | **bison** | TBD | TBD | TBD | High | 71 | High — foundational; changes need strong evidence and review | GNU parser generator (YACC-compatible) |
| 37 | **ed** | TBD | TBD | TBD | High | 71 | High — foundational; changes need strong evidence and review | GNU line-oriented text editor |
| 38 | **expat** | TBD | TBD | TBD | High | 71 | High — foundational; changes need strong evidence and review | XML parsing C library |
| 39 | **file** | TBD | TBD | TBD | High | 71 | High — foundational; changes need strong evidence and review | File type identification utility using magic numbers |
| 40 | **flex** | TBD | TBD | TBD | High | 71 | High — foundational; changes need strong evidence and review | Fast lexical analyzer generator |
| 41 | **fontconfig** | TBD | TBD | TBD | High | 71 | High — foundational; changes need strong evidence and review | Font configuration and customization library |
| 42 | **freetype** | TBD | TBD | TBD | High | 71 | High — foundational; changes need strong evidence and review | FreeType font rendering library |
| 43 | **gawk** | 1986 | GNU Project | 40 | High | 71 | High — foundational; changes need strong evidence and review | GNU AWK text processing language |
| 44 | **harfbuzz** | TBD | TBD | TBD | High | 71 | High — foundational; changes need strong evidence and review | OpenType text shaping engine |
| 45 | **acl** | 2001 | SGI / Linux community | 25 | High | 70 | High — foundational; changes need strong evidence and review | Access control list utilities for managing POSIX ACLs on filesystems |
| 46 | **apparmor** | 1998 | Immunix / SUSE / Canonical | 28 | High | 70 | High — foundational; changes need strong evidence and review | Linux security module for mandatory access control |
| 47 | **attr** | 2001 | SGI / Linux community | 25 | High | 70 | High — foundational; changes need strong evidence and review | Extended attribute utilities for Linux filesystems |
| 48 | **audit** | 2004 | Red Hat (Linux Audit) | 22 | High | 70 | High — foundational; changes need strong evidence and review | Linux kernel auditing framework userspace tools |
| 49 | **policykit-1** | TBD | TBD | TBD | High | 70 | High — foundational; changes need strong evidence and review | PolicyKit authorization framework (system-wide privilege control) |
| 50 | **apache2** | 1995 | Apache Software Foundation | 31 | High | 69 | Medium — meaningful integration/hardening value | Apache HTTP Server — the world's most popular web server |
| 51 | **bind9** | TBD | TBD | TBD | High | 69 | Medium — meaningful integration/hardening value | Berkeley Internet Name Domain (BIND) DNS server |
| 52 | **network-manager** | TBD | TBD | TBD | High | 69 | Medium — meaningful integration/hardening value | NetworkManager — automatic network connection management |
| 53 | **cron** | TBD | TBD | TBD | High | 68 | Medium — meaningful integration/hardening value | Daemon for executing scheduled commands |
| 54 | **cups** | TBD | TBD | TBD | High | 68 | Medium — meaningful integration/hardening value | Common Unix Printing System |
| 55 | **avahi** | TBD | TBD | TBD | High | 67 | Medium — meaningful integration/hardening value | Multicast DNS/DNS-SD service discovery framework |
| 56 | **bluez** | TBD | TBD | TBD | High | 67 | Medium — meaningful integration/hardening value | Official Linux Bluetooth protocol stack |
| 57 | **exim4** | TBD | TBD | TBD | High | 67 | Medium — meaningful integration/hardening value | Exim Internet Mailer version 4 (MTA) |
| 58 | **dkms** | TBD | TBD | TBD | High | 66 | Medium — meaningful integration/hardening value | Dynamic Kernel Module Support — auto-rebuild modules on kernel update |
| 59 | **elfutils** | TBD | TBD | TBD | High | 66 | Medium — meaningful integration/hardening value | ELF binary utilities and library (libelf, libdw) |
| 60 | **gdb** | TBD | TBD | TBD | High | 66 | Medium — meaningful integration/hardening value | GNU Debugger |
| 61 | **modemmanager** | TBD | TBD | TBD | High | 66 | Medium — meaningful integration/hardening value | D-Bus-activated daemon for mobile broadband modem management |
| 62 | **cloud-init** | TBD | TBD | TBD | High | 65 | Medium — meaningful integration/hardening value | Cloud instance initialization and configuration tool |
| 63 | **console-setup** | TBD | TBD | TBD | High | 65 | Medium — meaningful integration/hardening value | Console font and keyboard layout configuration |
| 64 | **debconf** | TBD | TBD | TBD | High | 65 | Medium — meaningful integration/hardening value | Debian configuration management system |
| 65 | **debhelper** | TBD | TBD | TBD | High | 65 | Medium — meaningful integration/hardening value | Helper programs for debian/rules build scripts |
| 66 | **debootstrap** | TBD | TBD | TBD | High | 65 | Medium — meaningful integration/hardening value | Bootstrap a basic Debian/Ubuntu system into a directory |
| 67 | **groff** | TBD | TBD | TBD | High | 65 | Medium — meaningful integration/hardening value | GNU troff document formatting system |
| 68 | **btrfs-progs** | TBD | TBD | TBD | High | 64 | Medium — meaningful integration/hardening value | Btrfs filesystem utilities |
| 69 | **cifs-utils** | TBD | TBD | TBD | High | 64 | Medium — meaningful integration/hardening value | Utilities for mounting and managing CIFS/SMB shares |
| 70 | **dosfstools** | TBD | TBD | TBD | High | 64 | Medium — meaningful integration/hardening value | FAT/VFAT filesystem creation and checking tools |
| 71 | **fuse** | TBD | TBD | TBD | High | 64 | Medium — meaningful integration/hardening value | Filesystem in Userspace (FUSE 2.x) |
| 72 | **fuse3** | TBD | TBD | TBD | High | 64 | Medium — meaningful integration/hardening value | Filesystem in Userspace (FUSE 3.x) |
| 73 | **efivar** | TBD | TBD | TBD | High | 63 | Medium — meaningful integration/hardening value | Tools for managing UEFI firmware variables |
| 74 | **gnu-efi** | TBD | TBD | TBD | High | 63 | Medium — meaningful integration/hardening value | Library for building UEFI applications with GNU toolchain |
| 75 | **gvfs** | TBD | TBD | TBD | High | 63 | Medium — meaningful integration/hardening value | GNOME Virtual File System (userspace backends) |
| 76 | **udisks2** | TBD | TBD | TBD | High | 63 | Medium — meaningful integration/hardening value | D-Bus interface for disk management (storage daemon) |
| 77 | **cargo** | TBD | TBD | TBD | High | 62 | Medium — meaningful integration/hardening value | Rust package manager and build system |
| 78 | **emacs** | TBD | TBD | TBD | High | 62 | Medium — meaningful integration/hardening value | GNU Emacs extensible text editor |
| 79 | **erlang** | TBD | TBD | TBD | High | 62 | Medium — meaningful integration/hardening value | Erlang/OTP programming language and runtime |
| 80 | **ffmpeg** | TBD | TBD | TBD | High | 62 | Medium — meaningful integration/hardening value | Multimedia framework for audio/video encoding, decoding, and streaming |
| 81 | **java-common** | TBD | TBD | TBD | High | 62 | Medium — meaningful integration/hardening value | Base infrastructure for Java packages in Debian |
| 82 | **rubygems** | TBD | TBD | TBD | High | 62 | Medium — meaningful integration/hardening value | Ruby package management framework |
| 83 | **firefox** | TBD | TBD | TBD | High | 61 | Medium — meaningful integration/hardening value | Mozilla Firefox web browser |
| 84 | **gst-plugins-base1.0** | TBD | TBD | TBD | High | 61 | Medium — meaningful integration/hardening value | GStreamer essential base plugins |
| 85 | **gstreamer1.0** | TBD | TBD | TBD | High | 61 | Medium — meaningful integration/hardening value | GStreamer multimedia framework core |
| 86 | **poppler** | TBD | TBD | TBD | High | 61 | Medium — meaningful integration/hardening value | PDF rendering library |
| 87 | **webkit2gtk** | TBD | TBD | TBD | High | 61 | Medium — meaningful integration/hardening value | WebKitGTK web content engine (used by GNOME apps) |
| 88 | **json-glib** | TBD | TBD | TBD | High | 60 | Medium — meaningful integration/hardening value | GLib-based JSON parser/generator library |
| 89 | **libsoup2.4** | TBD | TBD | TBD | High | 60 | Medium — meaningful integration/hardening value | GNOME HTTP client/server library (v2) |
| 90 | **libsoup3** | TBD | TBD | TBD | High | 60 | Medium — meaningful integration/hardening value | GNOME HTTP client/server library (v3) |
| 91 | **doxygen** | TBD | TBD | TBD | Moderate | 59 | Medium — meaningful integration/hardening value | Source code documentation generator |
| 92 | **graphviz** | TBD | TBD | TBD | Moderate | 59 | Medium — meaningful integration/hardening value | Graph visualization software (dot, neato, fdp) |
| 93 | **pango1.0** | TBD | TBD | TBD | Moderate | 59 | Medium — meaningful integration/hardening value | Text layout and rendering library (internationalized) |
| 94 | **gdk-pixbuf** | TBD | TBD | TBD | Moderate | 58 | Medium — meaningful integration/hardening value | GDK image loading and manipulation library |
| 95 | **gobject-introspection** | TBD | TBD | TBD | Moderate | 58 | Medium — meaningful integration/hardening value | GObject type introspection data generator |
| 96 | **gtk+2.0** | TBD | TBD | TBD | Moderate | 58 | Medium — meaningful integration/hardening value | GTK+ 2.0 graphical toolkit library |
| 97 | **gtk+3.0** | TBD | TBD | TBD | Moderate | 58 | Medium — meaningful integration/hardening value | GTK+ 3.0 graphical toolkit library |
| 98 | **gtk4** | TBD | TBD | TBD | Moderate | 58 | Medium — meaningful integration/hardening value | GTK 4.0 graphical toolkit library |
| 99 | **at-spi2-core** | 2011 | GNOME Project | 15 | Moderate | 57 | Medium — meaningful integration/hardening value | Assistive Technology Service Provider Interface (accessibility) |
| 100 | **atk1.0** | 2001 | GNOME Project | 25 | Moderate | 57 | Medium — meaningful integration/hardening value | ATK accessibility toolkit library |
| 101 | **libnotify** | TBD | TBD | TBD | Moderate | 57 | Medium — meaningful integration/hardening value | Desktop notification library (freedesktop.org) |
| 102 | **librsvg** | TBD | TBD | TBD | Moderate | 57 | Medium — meaningful integration/hardening value | SVG rendering library using Cairo |
| 103 | **libsecret** | TBD | TBD | TBD | Moderate | 57 | Medium — meaningful integration/hardening value | GNOME library for accessing the Secret Service API |
| 104 | **gcr** | TBD | TBD | TBD | Moderate | 56 | Medium — meaningful integration/hardening value | GNOME crypto and certificate library (GnuPG UI) |
| 105 | **glib-networking** | TBD | TBD | TBD | Moderate | 56 | Medium — meaningful integration/hardening value | GIO networking modules (TLS support via GnuTLS) |
| 106 | **libblockdev** | TBD | TBD | TBD | Moderate | 56 | Medium — meaningful integration/hardening value | Library for manipulating block devices |
| 107 | **libgpg-error** | TBD | TBD | TBD | Moderate | 56 | Medium — meaningful integration/hardening value | GnuPG error code library |
| 108 | **libgudev** | TBD | TBD | TBD | Moderate | 56 | Medium — meaningful integration/hardening value | GLib wrapper for libudev |
| 109 | **libgusb** | TBD | TBD | TBD | Moderate | 56 | Medium — meaningful integration/hardening value | GLib wrapper for libusb1 |
| 110 | **alsa-driver** | 1998 | ALSA project | 28 | Moderate | 55 | Medium — meaningful integration/hardening value | Advanced Linux Sound Architecture (ALSA) kernel driver sources |
| 111 | **alsa-utils** | 1998 | ALSA project | 28 | Moderate | 55 | Medium — meaningful integration/hardening value | ALSA sound utilities (amixer, aplay, arecord, etc.) |
| 112 | **colord** | TBD | TBD | TBD | Moderate | 55 | Medium — meaningful integration/hardening value | System service for managing color profiles |
| 113 | **db-defaults** | TBD | TBD | TBD | Moderate | 55 | Medium — meaningful integration/hardening value | Default Berkeley DB version selection |
| 114 | **db5.3** | TBD | TBD | TBD | Moderate | 55 | Medium — meaningful integration/hardening value | Berkeley DB 5.3 — embedded key-value database library |
| 115 | **evolution-data-server** | TBD | TBD | TBD | Moderate | 55 | Medium — meaningful integration/hardening value | GNOME backend for contacts, calendar, and mail |
| 116 | **gnome-control-center** | TBD | TBD | TBD | Moderate | 55 | Medium — meaningful integration/hardening value | GNOME system settings panel |
| 117 | **gnome-online-accounts** | TBD | TBD | TBD | Moderate | 55 | Medium — meaningful integration/hardening value | GNOME single sign-on for cloud services |
| 118 | **gnome-session** | TBD | TBD | TBD | Moderate | 55 | Medium — meaningful integration/hardening value | GNOME Session Manager |
| 119 | **libical3** | TBD | TBD | TBD | Moderate | 55 | Medium — meaningful integration/hardening value | iCalendar protocol implementation library |
| 120 | **mysql-defaults** | TBD | TBD | TBD | Moderate | 55 | Medium — meaningful integration/hardening value | Default MySQL server/client version selection |
| 121 | **wine** | TBD | TBD | TBD | Moderate | 55 | Medium — meaningful integration/hardening value | Windows compatibility layer (runs Windows applications on Linux) |
| 122 | **cyrus-sasl2** | TBD | TBD | TBD | Moderate | 54 | Medium — meaningful integration/hardening value | Cyrus Simple Authentication and Security Layer library |
| 123 | **etckeeper** | TBD | TBD | TBD | Moderate | 54 | Medium — meaningful integration/hardening value | Store /etc configuration in version control (git/hg/bzr) |
| 124 | **flac** | TBD | TBD | TBD | Moderate | 54 | Medium — meaningful integration/hardening value | Free Lossless Audio Codec encoder/decoder |
| 125 | **ipxe** | TBD | TBD | TBD | Moderate | 54 | Medium — meaningful integration/hardening value | PXE network boot firmware |
| 126 | **freerdp2** | TBD | TBD | TBD | Moderate | 53 | Medium — meaningful integration/hardening value | Free implementation of the Remote Desktop Protocol (RDP) |
| 127 | **freetds** | TBD | TBD | TBD | Moderate | 53 | Medium — meaningful integration/hardening value | Free implementation of TDS protocol (MS SQL/Sybase client) |
| 128 | **alsa-topology-conf** | TBD | TBD | TBD | Moderate | 52 | Medium — meaningful integration/hardening value | ALSA topology configuration files |
| 129 | **alsa-ucm-conf** | TBD | TBD | TBD | Moderate | 52 | Medium — meaningful integration/hardening value | ALSA Use Case Manager configuration files |
| 130 | **calibre** | TBD | TBD | TBD | Moderate | 52 | Medium — meaningful integration/hardening value | E-book library management and conversion tool |
| 131 | **catch2** | TBD | TBD | TBD | Moderate | 52 | Medium — meaningful integration/hardening value | Modern C++ test framework (header-only) |
| 132 | **firebird3.0** | TBD | TBD | TBD | Moderate | 52 | Medium — meaningful integration/hardening value | Firebird relational database server |
| 133 | **fop** | TBD | TBD | TBD | Moderate | 52 | Medium — meaningful integration/hardening value | Apache FOP — XSL-FO print formatter (PDF/PS output) |
| 134 | **gedit** | TBD | TBD | TBD | Moderate | 52 | Medium — meaningful integration/hardening value | GNOME text editor |
| 135 | **glade** | TBD | TBD | TBD | Moderate | 52 | Medium — meaningful integration/hardening value | GTK+ User Interface Builder |
| 136 | **googletest** | TBD | TBD | TBD | Moderate | 52 | Medium — meaningful integration/hardening value | Google C++ testing and mocking framework (gtest/gmock) |
| 137 | **lyx** | TBD | TBD | TBD | Moderate | 52 | Medium — meaningful integration/hardening value | Document processor — LaTeX frontend (WYSIWYM) |
| 138 | **ant** | 2000 | Apache Software Foundation | 26 | Moderate | 51 | Medium — meaningful integration/hardening value | Apache Ant — Java-based build tool |
| 139 | **check** | TBD | TBD | TBD | Moderate | 51 | Medium — meaningful integration/hardening value | Unit testing framework for C |
| 140 | **cmocka** | TBD | TBD | TBD | Moderate | 51 | Medium — meaningful integration/hardening value | Lightweight C unit testing framework with mock support |
| 141 | **cxxtest** | TBD | TBD | TBD | Moderate | 51 | Medium — meaningful integration/hardening value | Lightweight C++ unit testing framework |
| 142 | **gradle** | TBD | TBD | TBD | Moderate | 51 | Medium — meaningful integration/hardening value | Gradle build automation system (Groovy/Kotlin DSL) |
| 143 | **groovy** | TBD | TBD | TBD | Moderate | 51 | Medium — meaningful integration/hardening value | Agile dynamic language for the Java platform |
| 144 | **aspectj** | TBD | TBD | TBD | Moderate | 50 | Medium — meaningful integration/hardening value | Aspect-oriented programming extension for Java |
| 145 | **brotli** | TBD | TBD | TBD | Moderate | 50 | Medium — meaningful integration/hardening value | Lossless compression algorithm and tools (used in HTTP) |
| 146 | **ca-certificates-java** | TBD | TBD | TBD | Moderate | 50 | Medium — meaningful integration/hardening value | CA certificates for Java (JKS keystore) |
| 147 | **derby** | TBD | TBD | TBD | Moderate | 50 | Medium — meaningful integration/hardening value | Apache Derby — Java relational database engine |
| 148 | **dns-root-data** | TBD | TBD | TBD | Moderate | 50 | Medium — meaningful integration/hardening value | DNS root server data (hints and trust anchors) |
| 149 | **gdisk** | TBD | TBD | TBD | Moderate | 50 | Medium — meaningful integration/hardening value | GPT disk partitioning tool (gdisk, sgdisk, cgdisk) |
| 150 | **aspell** | 1998 | GNU Project | 28 | Moderate | 49 | Medium — meaningful integration/hardening value | GNU Aspell spell-checking library and tool |
| 151 | **enchant-2** | TBD | TBD | TBD | Moderate | 49 | Medium — meaningful integration/hardening value | Generic spell checking library wrapper |
| 152 | **gspell** | TBD | TBD | TBD | Moderate | 49 | Medium — meaningful integration/hardening value | GNOME spell-checking library (GtkTextView integration) |
| 153 | **hunspell** | TBD | TBD | TBD | Moderate | 49 | Medium — meaningful integration/hardening value | Spell checker and morphological analyzer |
| 154 | **aspell-en** | TBD | TBD | TBD | Moderate | 48 | Medium — meaningful integration/hardening value | English dictionary for GNU Aspell |
| 155 | **augeas** | TBD | TBD | TBD | Moderate | 48 | Medium — meaningful integration/hardening value | Configuration file editing tool using lenses |
| 156 | **dictionaries-common** | TBD | TBD | TBD | Moderate | 48 | Medium — meaningful integration/hardening value | Common infrastructure for spelling dictionaries |
| 157 | **gengetopt** | TBD | TBD | TBD | Moderate | 48 | Medium — meaningful integration/hardening value | Generates C code to parse command-line options via getopt_long |
| 158 | **gperf** | TBD | TBD | TBD | Moderate | 48 | Medium — meaningful integration/hardening value | GNU perfect hash function generator |
| 159 | **help2man** | TBD | TBD | TBD | Moderate | 48 | Medium — meaningful integration/hardening value | Generate man pages from --help output |
| 160 | **libcaca** | TBD | TBD | TBD | Moderate | 47 | Medium — meaningful integration/hardening value | Colour ASCII Art library (render images as text) |
| 161 | **libcanberra** | TBD | TBD | TBD | Moderate | 47 | Medium — meaningful integration/hardening value | Desktop event sound library (XDG sound theme) |
| 162 | **libdazzle** | TBD | TBD | TBD | Moderate | 47 | Medium — meaningful integration/hardening value | GNOME companion library for GLib and Gtk+ |
| 163 | **libnice** | TBD | TBD | TBD | Moderate | 47 | Medium — meaningful integration/hardening value | ICE (Interactive Connectivity Establishment) library |
| 164 | **libpeas** | TBD | TBD | TBD | Moderate | 47 | Medium — meaningful integration/hardening value | GObject-based plugin engine library |
| 165 | **libgdata** | TBD | TBD | TBD | Moderate | 46 | Medium — meaningful integration/hardening value | GLib library for Google Data Protocol (GData) |
| 166 | **libgtop2** | TBD | TBD | TBD | Moderate | 46 | Medium — meaningful integration/hardening value | System monitoring library (CPU, memory, processes) |
| 167 | **libgweather** | TBD | TBD | TBD | Moderate | 46 | Medium — meaningful integration/hardening value | GNOME weather information access library |
| 168 | **dbus-broker** | TBD | TBD | TBD | Moderate | 45 | Medium — meaningful integration/hardening value | High-performance D-Bus message broker |
| 169 | **dconf** | TBD | TBD | TBD | Moderate | 45 | Medium — meaningful integration/hardening value | Low-level configuration system for GNOME (GSettings backend) |
| 170 | **gnulib** | TBD | TBD | TBD | Moderate | 45 | Medium — meaningful integration/hardening value | GNU portability library (source-level library of C modules) |
| 171 | **libcloudproviders** | TBD | TBD | TBD | Moderate | 45 | Medium — meaningful integration/hardening value | Cloud storage provider API library for desktop |
| 172 | **libeatmydata** | TBD | TBD | TBD | Moderate | 45 | Medium — meaningful integration/hardening value | Library to disable fsync (speed up tests/builds) |
| 173 | **libmanette** | TBD | TBD | TBD | Moderate | 45 | Medium — meaningful integration/hardening value | Simple GObject game controller library |
| 174 | **librest** | TBD | TBD | TBD | Moderate | 45 | Medium — meaningful integration/hardening value | REST web service access library (GLib-based) |
| 175 | **libwnck3** | TBD | TBD | TBD | Moderate | 45 | Medium — meaningful integration/hardening value | Window Navigator Construction Kit library |
| 176 | **gssdp** | TBD | TBD | TBD | Moderate | 44 | Low — integrate as-is; improve only with cause | GLib-based SSDP (Simple Service Discovery Protocol) library |
| 177 | **gupnp** | TBD | TBD | TBD | Moderate | 44 | Low — integrate as-is; improve only with cause | GLib-based UPnP framework |
| 178 | **libffado** | TBD | TBD | TBD | Moderate | 44 | Low — integrate as-is; improve only with cause | FireWire audio device driver library |
| 179 | **libmbim** | TBD | TBD | TBD | Moderate | 44 | Low — integrate as-is; improve only with cause | MBIM protocol library (mobile broadband modems) |
| 180 | **libqb** | TBD | TBD | TBD | Moderate | 44 | Low — integrate as-is; improve only with cause | IPC library for high-performance cluster services |
| 181 | **libqmi** | TBD | TBD | TBD | Moderate | 44 | Low — integrate as-is; improve only with cause | QMI protocol library (Qualcomm modem interface) |
| 182 | **geocode-glib** | TBD | TBD | TBD | Moderate | 43 | Low — integrate as-is; improve only with cause | GNOME geocoding library (GLib-based) |
| 183 | **gtk-doc** | TBD | TBD | TBD | Moderate | 43 | Low — integrate as-is; improve only with cause | GTK documentation generation tool (API reference) |
| 184 | **gtksourceview4** | TBD | TBD | TBD | Moderate | 43 | Low — integrate as-is; improve only with cause | Source code editing widget with syntax highlighting |
| 185 | **gtkspell3** | TBD | TBD | TBD | Moderate | 43 | Low — integrate as-is; improve only with cause | Spell-checking addon for GTK's GtkTextView |
| 186 | **gupnp-igd** | TBD | TBD | TBD | Moderate | 43 | Low — integrate as-is; improve only with cause | GLib-based UPnP IGD (Internet Gateway Device) library |
| 187 | **blt** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | BLT extension library for Tcl/Tk (graphs, charts) |
| 188 | **expect** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | Tool for automating interactive programs (Tcl-based) |
| 189 | **gjs** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | GNOME JavaScript bindings (SpiderMonkey-based) |
| 190 | **guile-2.2** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | GNU Guile Scheme interpreter version 2.2 |
| 191 | **guile-3.0** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | GNU Guile Scheme interpreter version 3.0 |
| 192 | **espeak** | TBD | TBD | TBD | Moderate | 41 | Low — integrate as-is; improve only with cause | Multi-lingual software speech synthesizer |
| 193 | **espeak-ng** | TBD | TBD | TBD | Moderate | 41 | Low — integrate as-is; improve only with cause | eSpeak NG — enhanced multi-lingual speech synthesizer |
| 194 | **flite** | TBD | TBD | TBD | Moderate | 41 | Low — integrate as-is; improve only with cause | Lightweight speech synthesis engine (Festival Lite) |
| 195 | **fluidsynth** | TBD | TBD | TBD | Moderate | 41 | Low — integrate as-is; improve only with cause | Real-time software MIDI synthesizer (SoundFont) |
| 196 | **ibus** | TBD | TBD | TBD | Moderate | 41 | Low — integrate as-is; improve only with cause | Intelligent Input Bus — multilingual input framework |
| 197 | **presage** | TBD | TBD | TBD | Moderate | 41 | Low — integrate as-is; improve only with cause | Intelligent predictive text input system |
| 198 | **bash-completion** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | Programmable command-line completion for Bash |
| 199 | **cracklib2** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | Password strength checking library |
| 200 | **fcitx** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | Flexible Input Method Framework (CJK input) |
| 201 | **fcitx5-chinese-addons** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | Chinese input method addons for Fcitx5 |
| 202 | **glibc-tools** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | GNU C Library auxiliary tools |
| 203 | **grub2-unsigned** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | GRUB2 bootloader (unsigned, for non-secure-boot) |
| 204 | **gnome-themes-extra** | TBD | TBD | TBD | Moderate | 39 | Low — integrate as-is; improve only with cause | Extra GNOME themes (Adwaita dark, HighContrast) |
| 205 | **gnome-weather** | TBD | TBD | TBD | Moderate | 39 | Low — integrate as-is; improve only with cause | GNOME weather application |
| 206 | **gnome-common** | TBD | TBD | TBD | Moderate | 38 | Low — integrate as-is; improve only with cause | Common GNOME build infrastructure (deprecated macros) |
| 207 | **gnome-pkg-tools** | TBD | TBD | TBD | Moderate | 38 | Low — integrate as-is; improve only with cause | Tools for GNOME package maintenance in Debian |
| 208 | **gnome-user-docs** | TBD | TBD | TBD | Moderate | 38 | Low — integrate as-is; improve only with cause | GNOME desktop user documentation |
| 209 | **gnome-icon-theme** | TBD | TBD | TBD | Moderate | 37 | Low — integrate as-is; improve only with cause | GNOME icon theme (legacy, superseded by Adwaita) |
| 210 | **gnome-shell-extension-appindicator** | TBD | TBD | TBD | Moderate | 37 | Low — integrate as-is; improve only with cause | AppIndicator/KStatusNotifierItem support for GNOME Shell |
| 211 | **gnome-shell-extension-desktop-icons-ng** | TBD | TBD | TBD | Moderate | 37 | Low — integrate as-is; improve only with cause | Desktop icons extension for GNOME Shell |
| 212 | **gnome-shell-extension-ubuntu-dock** | TBD | TBD | TBD | Moderate | 37 | Low — integrate as-is; improve only with cause | Ubuntu dock extension for GNOME Shell |
| 213 | **gsettings-desktop-schemas** | TBD | TBD | TBD | Moderate | 37 | Low — integrate as-is; improve only with cause | GSettings desktop-wide application schemas |
| 214 | **adwaita-icon-theme** | 2011 | GNOME Project | 15 | Moderate | 36 | Low — integrate as-is; improve only with cause | Default GNOME icon theme |
| 215 | **gsettings-ubuntu-touch-schemas** | TBD | TBD | TBD | Moderate | 36 | Low — integrate as-is; improve only with cause | GSettings schemas for Ubuntu Touch |
| 216 | **hicolor-icon-theme** | TBD | TBD | TBD | Moderate | 36 | Low — integrate as-is; improve only with cause | Default fallback icon theme (FreeDesktop standard) |
| 217 | **humanity-icon-theme** | TBD | TBD | TBD | Moderate | 36 | Low — integrate as-is; improve only with cause | Ubuntu Humanity icon theme |
| 218 | **breeze** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | KDE Plasma Breeze visual style and window decorations |
| 219 | **breeze-icons** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | KDE Breeze icon theme |
| 220 | **budgie-desktop** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | Budgie desktop environment |
| 221 | **cdebconf** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | Debian configuration management system (C implementation) |
| 222 | **dmidecode** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | DMI/SMBIOS hardware information decoder |
| 223 | **gunicorn** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | Python WSGI HTTP server for UNIX |
| 224 | **ubuntu-drivers-common** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | Detect and install Ubuntu driver packages |
| 225 | **budgie-artwork** | TBD | TBD | TBD | Moderate | 34 | Low — integrate as-is; improve only with cause | Artwork and theming for Budgie desktop |
| 226 | **budgie-desktop-environment** | TBD | TBD | TBD | Moderate | 34 | Low — integrate as-is; improve only with cause | Metapackage for complete Budgie desktop installation |
| 227 | **budgie-extras** | TBD | TBD | TBD | Moderate | 34 | Low — integrate as-is; improve only with cause | Additional applets and plugins for Budgie desktop |
| 228 | **budgie-welcome** | TBD | TBD | TBD | Moderate | 34 | Low — integrate as-is; improve only with cause | Welcome application for Ubuntu Budgie |
| 229 | **cinnamon-desktop** | TBD | TBD | TBD | Moderate | 34 | Low — integrate as-is; improve only with cause | Cinnamon desktop environment libraries |
| 230 | **catfish** | TBD | TBD | TBD | Moderate | 33 | Low — integrate as-is; improve only with cause | File search utility for Xfce desktop |
| 231 | **cinnamon-translations** | TBD | TBD | TBD | Moderate | 33 | Low — integrate as-is; improve only with cause | Translation files for the Cinnamon desktop |
| 232 | **elementary-xfce** | TBD | TBD | TBD | Moderate | 33 | Low — integrate as-is; improve only with cause | Elementary icon theme variant for Xfce |
| 233 | **libxfce4ui** | TBD | TBD | TBD | Moderate | 33 | Low — integrate as-is; improve only with cause | Xfce GUI convenience library |
| 234 | **libxfce4util** | TBD | TBD | TBD | Moderate | 33 | Low — integrate as-is; improve only with cause | Xfce utility library |
| 235 | **xfconf** | TBD | TBD | TBD | Moderate | 33 | Low — integrate as-is; improve only with cause | Xfce configuration management system |
| 236 | **arc-theme** | TBD | TBD | TBD | Moderate | 32 | Low — integrate as-is; improve only with cause | Flat GTK theme with transparent elements |
| 237 | **arctica-greeter** | TBD | TBD | TBD | Moderate | 32 | Low — integrate as-is; improve only with cause | Arctica project's LightDM greeter |
| 238 | **greybird-gtk-theme** | TBD | TBD | TBD | Moderate | 32 | Low — integrate as-is; improve only with cause | Greybird GTK theme for Xfce desktop |
| 239 | **desktop-base** | TBD | TBD | TBD | Moderate | 31 | Low — integrate as-is; improve only with cause | Common desktop base files and artwork |
| 240 | **desktop-file-utils** | TBD | TBD | TBD | Moderate | 31 | Low — integrate as-is; improve only with cause | Utilities for .desktop file validation and database |
| 241 | **dmz-cursor-theme** | TBD | TBD | TBD | Moderate | 31 | Low — integrate as-is; improve only with cause | DMZ style cursor theme |
| 242 | **fltk1.3** | TBD | TBD | TBD | Moderate | 31 | Low — integrate as-is; improve only with cause | Fast Light Toolkit — cross-platform C++ GUI library |
| 243 | **freeglut** | TBD | TBD | TBD | Moderate | 31 | Low — integrate as-is; improve only with cause | Free OpenGL Utility Toolkit (GLUT reimplementation) |
| 244 | **amavisd-new** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Interface between MTA and content checkers (antivirus/antispam) |
| 245 | **bsdmainutils** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Collection of small BSD utilities (cal, column, hexdump, etc.) |
| 246 | **clutter-1.0** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | OpenGL-based interactive canvas library |
| 247 | **cogl** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Low-level OpenGL abstraction library (Clutter backend) |
| 248 | **glibc-doc-reference** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | GNU C Library reference manual |
| 249 | **glslang** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Khronos GLSL/SPIR-V reference compiler and validator |
| 250 | **graphene** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Thin layer of types for graphic libraries (vectors, matrices) |
| 251 | **devscripts** | TBD | TBD | TBD | Low | 29 | Low — integrate as-is; improve only with cause | Debian developer scripts collection |
| 252 | **dh-autoreconf** | TBD | TBD | TBD | Low | 29 | Low — integrate as-is; improve only with cause | Debhelper add-on to run autoreconf during build |
| 253 | **dh-python** | TBD | TBD | TBD | Low | 29 | Low — integrate as-is; improve only with cause | Debhelper add-on for Python packages |
| 254 | **dh-exec** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | Debhelper scripts for executing commands during build |
| 255 | **dh-golang** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | Debhelper add-on for Go packages |
| 256 | **dh-make** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | Tool for creating Debian package skeleton from source |
| 257 | **autodep8** | TBD | TBD | TBD | Low | 27 | Low — integrate as-is; improve only with cause | Generates automatic DEP-8 test control files |
| 258 | **autopkgtest** | TBD | TBD | TBD | Low | 27 | Low — integrate as-is; improve only with cause | Automatic testing for Debian packages |
| 259 | **cdbs** | TBD | TBD | TBD | Low | 27 | Low — integrate as-is; improve only with cause | Common Debian Build System — helper scripts for debian/rules |
| 260 | **dh-buildinfo** | TBD | TBD | TBD | Low | 27 | Low — integrate as-is; improve only with cause | Debhelper add-on to record build information |
| 261 | **dh-di** | TBD | TBD | TBD | Low | 27 | Low — integrate as-is; improve only with cause | Debhelper add-on for Debian Installer components |
| 262 | **dh-elpa** | TBD | TBD | TBD | Low | 27 | Low — integrate as-is; improve only with cause | Debhelper add-on for Emacs Lisp packages |
| 263 | **dh-fortran-mod** | TBD | TBD | TBD | Low | 27 | Low — integrate as-is; improve only with cause | Debhelper add-on for Fortran module files |
| 264 | **dh-linktree** | TBD | TBD | TBD | Low | 27 | Low — integrate as-is; improve only with cause | Debhelper add-on for creating symlink trees |
| 265 | **dh-lua** | TBD | TBD | TBD | Low | 27 | Low — integrate as-is; improve only with cause | Debhelper add-on for Lua packages |
| 266 | **dh-r** | TBD | TBD | TBD | Low | 27 | Low — integrate as-is; improve only with cause | Debhelper add-on for R packages |
| 267 | **dh-runit** | TBD | TBD | TBD | Low | 27 | Low — integrate as-is; improve only with cause | Debhelper add-on for runit service integration |
| 268 | **dh-vim-addon** | TBD | TBD | TBD | Low | 27 | Low — integrate as-is; improve only with cause | Debhelper add-on for Vim addons |
| 269 | **gem2deb** | TBD | TBD | TBD | Low | 27 | Low — integrate as-is; improve only with cause | Debian packaging tool for Ruby gems |
| 270 | **dpkg-awk** | TBD | TBD | TBD | Low | 26 | Low — integrate as-is; improve only with cause | AWK script for parsing dpkg status file |
| 271 | **dpkg-cross** | TBD | TBD | TBD | Low | 26 | Low — integrate as-is; improve only with cause | Tools for cross-compiling Debian packages |
| 272 | **dpkg-repack** | TBD | TBD | TBD | Low | 26 | Low — integrate as-is; improve only with cause | Recreate .deb from installed package |
| 273 | **germinate** | TBD | TBD | TBD | Low | 26 | Low — integrate as-is; improve only with cause | Seed-based package list generator for Ubuntu |
| 274 | **git-buildpackage** | TBD | TBD | TBD | Low | 26 | Low — integrate as-is; improve only with cause | Suite to help with Debian packages in Git repositories |
| 275 | **pkgbinarymangler** | TBD | TBD | TBD | Low | 26 | Low — integrate as-is; improve only with cause | Strips translation and compresses docs in Launchpad builds |
| 276 | **strip-nondeterminism** | TBD | TBD | TBD | Low | 26 | Low — integrate as-is; improve only with cause | Tool for stripping non-deterministic data from builds |
| 277 | **cd-boot-images-amd64** | TBD | TBD | TBD | Low | 25 | Low — integrate as-is; improve only with cause | Boot images for amd64 CD/DVD installation media |
| 278 | **cdrkit** | TBD | TBD | TBD | Low | 25 | Low — integrate as-is; improve only with cause | CD/DVD recording tools (genisoimage, wodim, icedax) |
| 279 | **corosync** | TBD | TBD | TBD | Low | 25 | Low — integrate as-is; improve only with cause | Cluster communication and membership framework |
| 280 | **dmraid** | TBD | TBD | TBD | Low | 25 | Low — integrate as-is; improve only with cause | Device-Mapper software RAID tool |
| 281 | **dpkg-source-gitarchive** | TBD | TBD | TBD | Low | 25 | Low — integrate as-is; improve only with cause | dpkg-source backend using git archive |
| 282 | **dput** | TBD | TBD | TBD | Low | 25 | Low — integrate as-is; improve only with cause | Debian package upload tool |
| 283 | **dupload** | TBD | TBD | TBD | Low | 25 | Low — integrate as-is; improve only with cause | Debian package upload tool (alternative to dput) |
| 284 | **eclipse-debian-helper** | TBD | TBD | TBD | Low | 25 | Low — integrate as-is; improve only with cause | Helper tools for packaging Eclipse plugins |
| 285 | **extra-cmake-modules** | TBD | TBD | TBD | Low | 25 | Low — integrate as-is; improve only with cause | Extra CMake modules for KDE Frameworks |
| 286 | **gradle-debian-helper** | TBD | TBD | TBD | Low | 25 | Low — integrate as-is; improve only with cause | Helper tools for building Gradle projects in Debian |
| 287 | **gui-ufw** | TBD | TBD | TBD | Low | 25 | Low — integrate as-is; improve only with cause | Graphical user interface for UFW (Uncomplicated Firewall) |
| 288 | **session-migration** | TBD | TBD | TBD | Low | 25 | Low — integrate as-is; improve only with cause | Tool for migrating user session settings on upgrade |
| 289 | **bandit** | TBD | TBD | TBD | Low | 24 | Low — integrate as-is; improve only with cause | Security linter for Python source code |
| 290 | **black** | TBD | TBD | TBD | Low | 24 | Low — integrate as-is; improve only with cause | Uncompromising Python code formatter |
| 291 | **cd-boot-images-arm64** | TBD | TBD | TBD | Low | 24 | Low — integrate as-is; improve only with cause | Boot images for arm64 CD/DVD installation media |
| 292 | **cython** | TBD | TBD | TBD | Low | 24 | Low — integrate as-is; improve only with cause | C-extension compiler for Python (Python to C translator) |
| 293 | **python-docutils** | TBD | TBD | TBD | Low | 24 | Low — integrate as-is; improve only with cause | Documentation utilities for Python (reStructuredText) |
| 294 | **python-flake8** | TBD | TBD | TBD | Low | 24 | Low — integrate as-is; improve only with cause | Python source code linter (PEP 8, pyflakes, mccabe) |
| 295 | **coffeescript** | TBD | TBD | TBD | Low | 23 | Low — integrate as-is; improve only with cause | CoffeeScript to JavaScript compiler |
| 296 | **eslint** | TBD | TBD | TBD | Low | 23 | Low — integrate as-is; improve only with cause | Pluggable JavaScript/TypeScript linting utility |
| 297 | **grunt** | TBD | TBD | TBD | Low | 23 | Low — integrate as-is; improve only with cause | JavaScript task runner |
| 298 | **node-chai** | TBD | TBD | TBD | Low | 23 | Low — integrate as-is; improve only with cause | BDD/TDD assertion library for Node.js |
| 299 | **node-clean-css** | TBD | TBD | TBD | Low | 23 | Low — integrate as-is; improve only with cause | Fast and efficient CSS optimizer for Node.js |
| 300 | **node-gulp** | TBD | TBD | TBD | Low | 23 | Low — integrate as-is; improve only with cause | Streaming build system for Node.js |
| 301 | **node-handlebars** | TBD | TBD | TBD | Low | 23 | Low — integrate as-is; improve only with cause | Minimal templating engine for JavaScript |
| 302 | **asciidoc** | 2002 | Stuart Rackham / community | 24 | Low | 22 | Low — integrate as-is; improve only with cause | Text-based document generation tool (AsciiDoc markup) |
| 303 | **asciidoctor** | TBD | TBD | TBD | Low | 22 | Low — integrate as-is; improve only with cause | Ruby-based AsciiDoc processor and publishing toolchain |
| 304 | **babel-minify** | TBD | TBD | TBD | Low | 22 | Low — integrate as-is; improve only with cause | ES6+ aware JavaScript minifier based on Babel |
| 305 | **breathe** | TBD | TBD | TBD | Low | 22 | Low — integrate as-is; improve only with cause | Bridge between Doxygen and Sphinx documentation systems |
| 306 | **cd-boot-images-ppc64el** | TBD | TBD | TBD | Low | 22 | Low — integrate as-is; improve only with cause | Boot images for ppc64el CD/DVD installation media |
| 307 | **closure-compiler** | TBD | TBD | TBD | Low | 22 | Low — integrate as-is; improve only with cause | Google Closure Compiler — JavaScript optimizer |
| 308 | **cssmin** | TBD | TBD | TBD | Low | 22 | Low — integrate as-is; improve only with cause | CSS minification library for Python |
| 309 | **docbook** | TBD | TBD | TBD | Low | 22 | Low — integrate as-is; improve only with cause | Standard SGML/XML document format for technical documentation |
| 310 | **docbook-xml** | TBD | TBD | TBD | Low | 22 | Low — integrate as-is; improve only with cause | DocBook XML document type definitions |
| 311 | **docbook-xsl** | TBD | TBD | TBD | Low | 22 | Low — integrate as-is; improve only with cause | XSL stylesheets for DocBook XML transformation |
| 312 | **highlight.js** | TBD | TBD | TBD | Low | 22 | Low — integrate as-is; improve only with cause | JavaScript/CSS syntax highlighter for web pages |
| 313 | **mathjax** | TBD | TBD | TBD | Low | 22 | Low — integrate as-is; improve only with cause | JavaScript engine for rendering LaTeX/MathML in browsers |
| 314 | **twitter-bootstrap3** | TBD | TBD | TBD | Low | 22 | Low — integrate as-is; improve only with cause | Twitter Bootstrap 3 HTML/CSS/JS framework |
| 315 | **biber** | TBD | TBD | TBD | Low | 21 | Low — integrate as-is; improve only with cause | Bibliography processor for BibLaTeX |
| 316 | **dblatex** | TBD | TBD | TBD | Low | 21 | Low — integrate as-is; improve only with cause | DocBook to LaTeX/ConTeXt/PDF publishing toolchain |
| 317 | **docbook-dsssl** | TBD | TBD | TBD | Low | 21 | Low — integrate as-is; improve only with cause | DSSSL stylesheets for DocBook |
| 318 | **docbook-to-man** | TBD | TBD | TBD | Low | 21 | Low — integrate as-is; improve only with cause | Convert DocBook SGML to man page format |
| 319 | **docbook-utils** | TBD | TBD | TBD | Low | 21 | Low — integrate as-is; improve only with cause | DocBook document conversion utilities |
| 320 | **docbook2x** | TBD | TBD | TBD | Low | 21 | Low — integrate as-is; improve only with cause | Convert DocBook to man pages and Texinfo |
| 321 | **docbook5-xml** | TBD | TBD | TBD | Low | 21 | Low — integrate as-is; improve only with cause | DocBook 5 XML document type definition |
| 322 | **bcache-tools** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | Tools for managing bcache block layer caching |
| 323 | **bison-doc** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | Documentation for GNU Bison |
| 324 | **cd-boot-images-riscv64** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | Boot images for riscv64 CD/DVD installation media |
| 325 | **cluster-glue** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | Cluster resource manager support libraries |
| 326 | **feynmf** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | LaTeX package for drawing Feynman diagrams |
| 327 | **finalrd** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | Final system shutdown resource deallocator |
| 328 | **foomatic-db** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | OpenPrinting printer support database |
| 329 | **gdl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | GNOME Docking Library — dockable widget framework |
| 330 | **gi-docgen** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | Documentation generator for GObject-Introspection projects |
| 331 | **gnu-standards** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | GNU coding and maintainer standards documentation |
| 332 | **gnuplot** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | Command-line interactive plotting program |
| 333 | **graphicsmagick** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | Image processing tools (ImageMagick fork, stable API) |
| 334 | **gyp** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | Generate Your Projects — meta-build system (used by Chromium/Node) |
| 335 | **lmodern** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | Latin Modern scalable fonts (TeX default fonts, OpenType) |
| 336 | **snapd-glib** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | GLib library for communicating with snapd |
| 337 | **tex-gyre** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | TeX Gyre font collection (enhanced URW fonts for TeX) |
| 338 | **fontforge** | TBD | TBD | TBD | Low | 19 | Low — integrate as-is; improve only with cause | Font editor for creating and modifying fonts (OTF, TTF, etc.) |
| 339 | **fontmake** | TBD | TBD | TBD | Low | 19 | Low — integrate as-is; improve only with cause | Compile font sources to binary (UFO/Glyphs to OTF/TTF) |
| 340 | **fonttools** | TBD | TBD | TBD | Low | 19 | Low — integrate as-is; improve only with cause | Python library for manipulating font files (TTX/TTF/OTF) |
| 341 | **frei0r** | TBD | TBD | TBD | Low | 19 | Low — integrate as-is; improve only with cause | Minimalistic plugin API for video effects |
| 342 | **gimp-data-extras** | TBD | TBD | TBD | Low | 19 | Low — integrate as-is; improve only with cause | Extra brushes, palettes, and gradients for GIMP |
| 343 | **glyphsinfo** | TBD | TBD | TBD | Low | 19 | Low — integrate as-is; improve only with cause | Glyphs.app glyph metadata (names, categories, Unicode) |
| 344 | **gst-libav1.0** | TBD | TBD | TBD | Low | 19 | Low — integrate as-is; improve only with cause | GStreamer FFmpeg/Libav codec plugin |
| 345 | **gst-plugins-bad1.0** | TBD | TBD | TBD | Low | 19 | Low — integrate as-is; improve only with cause | GStreamer plugins of questionable quality (experimental) |
| 346 | **gst-plugins-good1.0** | TBD | TBD | TBD | Low | 19 | Low — integrate as-is; improve only with cause | GStreamer good-quality plugins under LGPL |
| 347 | **gst-plugins-ugly1.0** | TBD | TBD | TBD | Low | 19 | Low — integrate as-is; improve only with cause | GStreamer plugins with distribution issues (patent-encumbered) |
| 348 | **alembic** | TBD | TBD | TBD | Low | 18 | Low — integrate as-is; improve only with cause | Database migration tool for SQLAlchemy (Python) |
| 349 | **aodh** | TBD | TBD | TBD | Low | 18 | Low — integrate as-is; improve only with cause | OpenStack alarming service |
| 350 | **barbican** | TBD | TBD | TBD | Low | 18 | Low — integrate as-is; improve only with cause | OpenStack key management service |
| 351 | **ceilometer** | TBD | TBD | TBD | Low | 18 | Low — integrate as-is; improve only with cause | OpenStack telemetry data collection service |
| 352 | **cinder** | TBD | TBD | TBD | Low | 18 | Low — integrate as-is; improve only with cause | OpenStack block storage service |
| 353 | **designate** | TBD | TBD | TBD | Low | 18 | Low — integrate as-is; improve only with cause | OpenStack DNS-as-a-Service |
| 354 | **glance** | TBD | TBD | TBD | Low | 18 | Low — integrate as-is; improve only with cause | OpenStack image service |
| 355 | **heat** | TBD | TBD | TBD | Low | 18 | Low — integrate as-is; improve only with cause | OpenStack orchestration service (HOT templates) |
| 356 | **cloud-initramfs-tools** | TBD | TBD | TBD | Low | 17 | Low — integrate as-is; improve only with cause | Initramfs tools for cloud instances |
| 357 | **cloud-utils** | TBD | TBD | TBD | Low | 17 | Low — integrate as-is; improve only with cause | Cloud instance utilities (growpart, cloud-localds, etc.) |
| 358 | **ec2-hibinit-agent** | TBD | TBD | TBD | Low | 17 | Low — integrate as-is; improve only with cause | AWS EC2 hibernation initialization agent |
| 359 | **ec2-instance-connect** | TBD | TBD | TBD | Low | 17 | Low — integrate as-is; improve only with cause | AWS EC2 Instance Connect SSH key delivery |
| 360 | **gce-compute-image-packages** | TBD | TBD | TBD | Low | 17 | Low — integrate as-is; improve only with cause | Google Compute Engine guest environment packages |
| 361 | **heat-dashboard** | TBD | TBD | TBD | Low | 17 | Low — integrate as-is; improve only with cause | OpenStack Heat Horizon dashboard plugin |
| 362 | **hibagent** | TBD | TBD | TBD | Low | 17 | Low — integrate as-is; improve only with cause | AWS EC2 hibernation agent |
| 363 | **autoconf-archive** | TBD | TBD | TBD | Low | 16 | Low — integrate as-is; improve only with cause | Collection of reusable Autoconf macros |
| 364 | **autoconf2.13** | TBD | TBD | TBD | Low | 16 | Low — integrate as-is; improve only with cause | GNU Autoconf version 2.13 (legacy compatibility) |
| 365 | **autoconf2.69** | TBD | TBD | TBD | Low | 16 | Low — integrate as-is; improve only with cause | GNU Autoconf version 2.69 (legacy compatibility) |
| 366 | **automake1.11** | TBD | TBD | TBD | Low | 16 | Low — integrate as-is; improve only with cause | GNU Automake version 1.11 (legacy compatibility) |
| 367 | **calamares-settings-ubuntu** | TBD | TBD | TBD | Low | 16 | Low — integrate as-is; improve only with cause | Ubuntu-specific settings for Calamares installer |
| 368 | **curtin** | TBD | TBD | TBD | Low | 16 | Low — integrate as-is; improve only with cause | Ubuntu disk image installer (cloud/server provisioning) |
| 369 | **akonadi** | TBD | TBD | TBD | Low | 15 | Low — integrate as-is; improve only with cause | PIM storage service for KDE applications |
| 370 | **autoconf-dickey** | TBD | TBD | TBD | Low | 15 | Low — integrate as-is; improve only with cause | Thomas Dickey's variant of GNU Autoconf |
| 371 | **autotools-dev** | TBD | TBD | TBD | Low | 15 | Low — integrate as-is; improve only with cause | Infrastructure for updating config.{guess,sub} files |
| 372 | **awstats** | TBD | TBD | TBD | Low | 15 | Low — integrate as-is; improve only with cause | Advanced web server log analyzer and statistics generator |
| 373 | **binutils-mingw-w64** | TBD | TBD | TBD | Low | 15 | Low — integrate as-is; improve only with cause | Cross-binutils for MinGW-w64 Windows targets |
| 374 | **branding-ubuntu** | TBD | TBD | TBD | Low | 15 | Low — integrate as-is; improve only with cause | Ubuntu branding assets and configuration |
| 375 | **d-shlibs** | TBD | TBD | TBD | Low | 15 | Low — integrate as-is; improve only with cause | Shared library dependencies calculation helper |
| 376 | **eglexternalplatform** | TBD | TBD | TBD | Low | 15 | Low — integrate as-is; improve only with cause | EGL External Platform interface headers |
| 377 | **emacsen-common** | TBD | TBD | TBD | Low | 15 | Low — integrate as-is; improve only with cause | Common infrastructure for Emacs variant packages |
| 378 | **esmtp** | TBD | TBD | TBD | Low | 15 | Low — integrate as-is; improve only with cause | Relay-only MTA using libESMTP (lightweight mail sender) |
| 379 | **faad2** | TBD | TBD | TBD | Low | 15 | Low — integrate as-is; improve only with cause | Freeware Advanced Audio Decoder (AAC/HE-AAC/MP4) |
| 380 | **fastjar** | TBD | TBD | TBD | Low | 15 | Low — integrate as-is; improve only with cause | Fast Java archive (jar) creation tool |
| 381 | **flit** | TBD | TBD | TBD | Low | 15 | Low — integrate as-is; improve only with cause | Simple Python packaging tool (PEP 517 compliant) |
| 382 | **gcab** | TBD | TBD | TBD | Low | 15 | Low — integrate as-is; improve only with cause | Microsoft Cabinet archive tool (GLib-based) |
| 383 | **gcc-11-cross** | TBD | TBD | TBD | Low | 15 | Low — integrate as-is; improve only with cause | GCC 11 cross-compiler packages |
| 384 | **gcc-11-cross-ports** | TBD | TBD | TBD | Low | 15 | Low — integrate as-is; improve only with cause | GCC 11 cross-compiler for architecture ports |
| 385 | **gcc-12-cross** | TBD | TBD | TBD | Low | 15 | Low — integrate as-is; improve only with cause | GCC 12 cross-compiler packages |
| 386 | **gcc-12-cross-ports** | TBD | TBD | TBD | Low | 15 | Low — integrate as-is; improve only with cause | GCC 12 cross-compiler for architecture ports |
| 387 | **gcc-defaults-ports** | TBD | TBD | TBD | Low | 15 | Low — integrate as-is; improve only with cause | Default GCC version for architecture ports |
| 388 | **gcc-mingw-w64** | TBD | TBD | TBD | Low | 15 | Low — integrate as-is; improve only with cause | GCC cross-compiler for Windows (MinGW-w64) |
| 389 | **gdebi** | TBD | TBD | TBD | Low | 15 | Low — integrate as-is; improve only with cause | Simple tool for installing local .deb packages |
| 390 | **gsfonts** | TBD | TBD | TBD | Low | 15 | Low — integrate as-is; improve only with cause | URW Type 1 fonts (Ghostscript standard fonts) |
| 391 | **heimdal** | TBD | TBD | TBD | Low | 15 | Low — integrate as-is; improve only with cause | Heimdal Kerberos 5 implementation |
| 392 | **html2text** | TBD | TBD | TBD | Low | 15 | Low — integrate as-is; improve only with cause | Advanced HTML-to-text converter |
| 393 | **htmldoc** | TBD | TBD | TBD | Low | 15 | Low — integrate as-is; improve only with cause | HTML and Markdown to PDF/PostScript converter |
| 394 | **llvm-defaults** | TBD | TBD | TBD | Low | 15 | Low — integrate as-is; improve only with cause | Default LLVM version selection |
| 395 | **umockdev** | TBD | TBD | TBD | Low | 15 | Low — integrate as-is; improve only with cause | Mock hardware devices for testing (udev/sysfs/ioctl) |
| 396 | **antlr** | TBD | TBD | TBD | Low | 14 | Minimal — cosmetic/niche; leave to upstream | ANother Tool for Language Recognition — parser generator (v2) |
| 397 | **antlr3** | 1989 | Terence Parr / ANTLR project | 37 | Low | 14 | Minimal — cosmetic/niche; leave to upstream | ANTLR parser generator version 3 |
| 398 | **antlr4** | 1989 | Terence Parr / ANTLR project | 37 | Low | 14 | Minimal — cosmetic/niche; leave to upstream | ANTLR parser generator version 4 |
| 399 | **bnd** | TBD | TBD | TBD | Low | 14 | Minimal — cosmetic/niche; leave to upstream | OSGi bundle tool for Java |
| 400 | **bsh** | TBD | TBD | TBD | Low | 14 | Minimal — cosmetic/niche; leave to upstream | BeanShell — lightweight Java scripting language |
| 401 | **cup** | TBD | TBD | TBD | Low | 14 | Minimal — cosmetic/niche; leave to upstream | LALR parser generator for Java (CUP) |
| 402 | **dietlibc** | TBD | TBD | TBD | Low | 14 | Minimal — cosmetic/niche; leave to upstream | Lightweight C library optimized for small static binaries |
| 403 | **gnustep-make** | TBD | TBD | TBD | Low | 14 | Minimal — cosmetic/niche; leave to upstream | GNUstep build system (Makefiles) |
| 404 | **prelink** | TBD | TBD | TBD | Low | 14 | Minimal — cosmetic/niche; leave to upstream | ELF prelinking utility (speeds up dynamic linking) |
| 405 | **ant-contrib** | TBD | TBD | TBD | Low | 13 | Minimal — cosmetic/niche; leave to upstream | Additional tasks and types for Apache Ant |
| 406 | **cli-common** | TBD | TBD | TBD | Low | 13 | Minimal — cosmetic/niche; leave to upstream | Common infrastructure for CLI (.NET/Mono) packages |
| 407 | **gradle-plugin-protobuf** | TBD | TBD | TBD | Low | 13 | Minimal — cosmetic/niche; leave to upstream | Gradle plugin for Google Protocol Buffers |
| 408 | **gradle-propdeps-plugin** | TBD | TBD | TBD | Low | 13 | Minimal — cosmetic/niche; leave to upstream | Gradle plugin for optional/provided dependency scopes |
| 409 | **gtk-sharp2** | TBD | TBD | TBD | Low | 13 | Minimal — cosmetic/niche; leave to upstream | C#/Mono bindings for GTK+ 2.0 |
| 410 | **xsp** | TBD | TBD | TBD | Low | 13 | Minimal — cosmetic/niche; leave to upstream | Mono/ASP.NET XSP web server |
| 411 | **analitza** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | KDE mathematical expression analysis library |
| 412 | **ayatana-settings** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Settings manager for Ayatana desktop indicators |
| 413 | **caja-admin** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | MATE file manager extension for admin operations |
| 414 | **deja-dup-caja** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Deja Dup backup integration for MATE Caja file manager |
| 415 | **eximdoc4** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Documentation for the Exim 4 MTA |
| 416 | **fig2dev** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Xfig figure to various output formats converter |
| 417 | **grub-legacy-ec2** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Legacy GRUB configuration for EC2 instances |
| 418 | **gsfonts-x11** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | X11 font configuration for URW Ghostscript fonts |
| 419 | **gtk2-engines** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | GTK+ 2.0 theme engines (Clearlooks, Crux, Industrial, etc.) |
| 420 | **gtk2-engines-murrine** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Murrine GTK2 theme engine (Cairo-based) |
| 421 | **gtk2-engines-oxygen** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Oxygen (KDE) theme engine for GTK2 applications |
| 422 | **gtkmm-documentation** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | C++ bindings for GTK+ documentation |
| 423 | **tnftp** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Enhanced FTP client (NetBSD ftp) |
| 424 | **bc** | TBD | TBD | TBD | Low | 11 | Minimal — cosmetic/niche; leave to upstream | GNU arbitrary-precision calculator language |
| 425 | **breezy** | TBD | TBD | TBD | Low | 11 | Minimal — cosmetic/niche; leave to upstream | Distributed version control system (Bazaar fork) |
| 426 | **busybox** | TBD | TBD | TBD | Low | 11 | Minimal — cosmetic/niche; leave to upstream | Tiny utilities for embedded Linux systems |
| 427 | **byobu** | TBD | TBD | TBD | Low | 11 | Minimal — cosmetic/niche; leave to upstream | Text-based window manager and terminal multiplexer enhancement |
| 428 | **bzr** | TBD | TBD | TBD | Low | 11 | Minimal — cosmetic/niche; leave to upstream | Bazaar distributed version control system |
| 429 | **cscope** | TBD | TBD | TBD | Low | 11 | Minimal — cosmetic/niche; leave to upstream | Interactive source code browsing tool for C |
| 430 | **cvs** | TBD | TBD | TBD | Low | 11 | Minimal — cosmetic/niche; leave to upstream | Concurrent Versions System — legacy version control |
| 431 | **cvsps** | TBD | TBD | TBD | Low | 11 | Minimal — cosmetic/niche; leave to upstream | Generates patchsets from CVS repository logs |
| 432 | **gist** | TBD | TBD | TBD | Low | 11 | Minimal — cosmetic/niche; leave to upstream | Upload code snippets to GitHub Gist |
| 433 | **antiword** | TBD | TBD | TBD | Low | 10 | Minimal — cosmetic/niche; leave to upstream | Converts Microsoft Word documents to plain text or PostScript |
| 434 | **ayatana-webmail** | TBD | TBD | TBD | Low | 10 | Minimal — cosmetic/niche; leave to upstream | Ayatana webmail notifications indicator |
| 435 | **bats** | TBD | TBD | TBD | Low | 10 | Minimal — cosmetic/niche; leave to upstream | Bash Automated Testing System |
| 436 | **bubblewrap** | TBD | TBD | TBD | Low | 10 | Minimal — cosmetic/niche; leave to upstream | Unprivileged sandboxing tool for Linux |
| 437 | **caja-mediainfo** | TBD | TBD | TBD | Low | 10 | Minimal — cosmetic/niche; leave to upstream | MediaInfo extension for MATE Caja file manager |
| 438 | **caja-rename** | TBD | TBD | TBD | Low | 10 | Minimal — cosmetic/niche; leave to upstream | Batch rename extension for MATE Caja file manager |
| 439 | **checkpolicy** | TBD | TBD | TBD | Low | 10 | Minimal — cosmetic/niche; leave to upstream | SELinux policy compiler |
| 440 | **checksecurity** | TBD | TBD | TBD | Low | 10 | Minimal — cosmetic/niche; leave to upstream | Basic system security auditing scripts |
| 441 | **chrpath** | TBD | TBD | TBD | Low | 10 | Minimal — cosmetic/niche; leave to upstream | Tool to modify the rpath/runpath of ELF binaries |
| 442 | **cmdreader** | TBD | TBD | TBD | Low | 10 | Minimal — cosmetic/niche; leave to upstream | Command reader utility for configuration parsing |
| 443 | **cmdtest** | TBD | TBD | TBD | Low | 10 | Minimal — cosmetic/niche; leave to upstream | Command-line testing tool using scenarios |
| 444 | **cucumber** | TBD | TBD | TBD | Low | 10 | Minimal — cosmetic/niche; leave to upstream | BDD (Behavior-Driven Development) testing framework for Ruby |
| 445 | **darts** | TBD | TBD | TBD | Low | 10 | Minimal — cosmetic/niche; leave to upstream | Double-Array Trie System — fast dictionary lookup |
| 446 | **datefudge** | TBD | TBD | TBD | Low | 10 | Minimal — cosmetic/niche; leave to upstream | Fake system date for testing purposes |
| 447 | **debugedit** | TBD | TBD | TBD | Low | 10 | Minimal — cosmetic/niche; leave to upstream | Tool for editing debug info in ELF binaries |
| 448 | **dejagnu** | TBD | TBD | TBD | Low | 10 | Minimal — cosmetic/niche; leave to upstream | GNU software testing framework |
| 449 | **dist** | TBD | TBD | TBD | Low | 10 | Minimal — cosmetic/niche; leave to upstream | Tools for developing distributed software (metaconfig) |
| 450 | **dwz** | TBD | TBD | TBD | Low | 10 | Minimal — cosmetic/niche; leave to upstream | DWARF debug information optimization tool |
| 451 | **execnet** | TBD | TBD | TBD | Low | 10 | Minimal — cosmetic/niche; leave to upstream | Python library for distributed program execution via channels |
| 452 | **fakechroot** | TBD | TBD | TBD | Low | 10 | Minimal — cosmetic/niche; leave to upstream | Fake chroot environment without root privileges |
| 453 | **fakeroot** | TBD | TBD | TBD | Low | 10 | Minimal — cosmetic/niche; leave to upstream | Simulate root privileges for file manipulation |
| 454 | **faketime** | TBD | TBD | TBD | Low | 10 | Minimal — cosmetic/niche; leave to upstream | Library for faking system time for testing |
| 455 | **gsfonts-other** | TBD | TBD | TBD | Low | 10 | Minimal — cosmetic/niche; leave to upstream | Additional URW fonts beyond the standard 35 |
| 456 | **mallard-ducktype** | TBD | TBD | TBD | Low | 10 | Minimal — cosmetic/niche; leave to upstream | Ducktype parser for Mallard documentation format |
| 457 | **apport** | TBD | TBD | TBD | Minimal | 9 | Minimal — cosmetic/niche; leave to upstream | Automatic crash report generation and handling |
| 458 | **apport-symptoms** | TBD | TBD | TBD | Minimal | 9 | Minimal — cosmetic/niche; leave to upstream | Symptom scripts for Apport crash reporting |
| 459 | **appstream** | 2012 | freedesktop.org | 14 | Minimal | 9 | Minimal — cosmetic/niche; leave to upstream | Software component metadata management library |
| 460 | **appstream-glib** | TBD | TBD | TBD | Minimal | 9 | Minimal — cosmetic/niche; leave to upstream | GLib library for reading and writing AppStream metadata |
| 461 | **apt-clone** | TBD | TBD | TBD | Minimal | 9 | Minimal — cosmetic/niche; leave to upstream | Script to create state bundles for apt-based systems |
| 462 | **apt-file** | TBD | TBD | TBD | Minimal | 9 | Minimal — cosmetic/niche; leave to upstream | Search for files within Debian/Ubuntu packages |
| 463 | **apt-listchanges** | TBD | TBD | TBD | Minimal | 9 | Minimal — cosmetic/niche; leave to upstream | Show changelog entries between package versions |
| 464 | **aptdaemon** | TBD | TBD | TBD | Minimal | 9 | Minimal — cosmetic/niche; leave to upstream | DBus-based APT transaction daemon |
| 465 | **caspar** | TBD | TBD | TBD | Minimal | 9 | Minimal — cosmetic/niche; leave to upstream | Framework for maintaining /etc configuration files |
| 466 | **cme** | TBD | TBD | TBD | Minimal | 9 | Minimal — cosmetic/niche; leave to upstream | Configuration Model Editor — edit configuration with schemas |
| 467 | **coderay** | TBD | TBD | TBD | Minimal | 9 | Minimal — cosmetic/niche; leave to upstream | Ruby syntax highlighting library |
| 468 | **command-not-found** | TBD | TBD | TBD | Minimal | 9 | Minimal — cosmetic/niche; leave to upstream | Suggests package installation for missing commands |
| 469 | **debian-goodies** | TBD | TBD | TBD | Minimal | 9 | Minimal — cosmetic/niche; leave to upstream | Small useful utilities for Debian systems |
| 470 | **debian-keyring** | TBD | TBD | TBD | Minimal | 9 | Minimal — cosmetic/niche; leave to upstream | GnuPG keyrings of Debian developers and maintainers |
| 471 | **debiandoc-sgml** | TBD | TBD | TBD | Minimal | 9 | Minimal — cosmetic/niche; leave to upstream | DebianDoc SGML documentation format tools |
| 472 | **debianutils** | TBD | TBD | TBD | Minimal | 9 | Minimal — cosmetic/niche; leave to upstream | Miscellaneous Debian-specific utilities |
| 473 | **dhelp** | TBD | TBD | TBD | Minimal | 9 | Minimal — cosmetic/niche; leave to upstream | Online help browser for Debian documentation |
| 474 | **distro-info** | TBD | TBD | TBD | Minimal | 9 | Minimal — cosmetic/niche; leave to upstream | Distribution information query tool |
| 475 | **distro-info-data** | TBD | TBD | TBD | Minimal | 9 | Minimal — cosmetic/niche; leave to upstream | Distribution release date database |
| 476 | **doc-base** | TBD | TBD | TBD | Minimal | 9 | Minimal — cosmetic/niche; leave to upstream | Debian documentation registration and browsing system |
| 477 | **equivs** | TBD | TBD | TBD | Minimal | 9 | Minimal — cosmetic/niche; leave to upstream | Circumvent Debian package dependencies |
| 478 | **friendly-recovery** | TBD | TBD | TBD | Minimal | 9 | Minimal — cosmetic/niche; leave to upstream | User-friendly recovery mode for Ubuntu |
| 479 | **advancecomp** | TBD | TBD | TBD | Minimal | 8 | Minimal — cosmetic/niche; leave to upstream | Collection of recompression utilities for PNG, MNG, ZIP, and GZ files |
| 480 | **apt-xapian-index** | TBD | TBD | TBD | Minimal | 8 | Minimal — cosmetic/niche; leave to upstream | Xapian-based full-text search index for APT |
| 481 | **autogen** | TBD | TBD | TBD | Minimal | 8 | Minimal — cosmetic/niche; leave to upstream | Automated text and program generation tool |
| 482 | **blends** | TBD | TBD | TBD | Minimal | 8 | Minimal — cosmetic/niche; leave to upstream | Debian Pure Blends common infrastructure |
| 483 | **create-resources** | TBD | TBD | TBD | Minimal | 8 | Minimal — cosmetic/niche; leave to upstream | Helper for creating system resources during package builds |
| 484 | **dctrl-tools** | TBD | TBD | TBD | Minimal | 8 | Minimal — cosmetic/niche; leave to upstream | Tools for querying Debian package control file information |
| 485 | **diffstat** | TBD | TBD | TBD | Minimal | 8 | Minimal — cosmetic/niche; leave to upstream | Statistics from diff output |
| 486 | **discodos** | TBD | TBD | TBD | Minimal | 8 | Minimal — cosmetic/niche; leave to upstream | DJ tool for tracking vinyl records and mixes |
| 487 | **doxyqml** | TBD | TBD | TBD | Minimal | 8 | Minimal — cosmetic/niche; leave to upstream | Doxygen input filter for QML files |
| 488 | **faba-icon-theme** | TBD | TBD | TBD | Minimal | 8 | Minimal — cosmetic/niche; leave to upstream | Faba modern icon theme |
| 489 | **freepats** | TBD | TBD | TBD | Minimal | 8 | Minimal — cosmetic/niche; leave to upstream | Free patch set for MIDI software synthesizers |
| 490 | **gamemode** | TBD | TBD | TBD | Minimal | 8 | Minimal — cosmetic/niche; leave to upstream | Feral Interactive GameMode — optimize Linux for gaming |
| 491 | **gcovr** | TBD | TBD | TBD | Minimal | 8 | Minimal — cosmetic/niche; leave to upstream | Generate code coverage reports from gcov data (Python) |
| 492 | **grub2-themes-ubuntustudio** | TBD | TBD | TBD | Minimal | 8 | Minimal — cosmetic/niche; leave to upstream | GRUB2 theme for Ubuntu Studio |
| 493 | **hfst-ospell** | TBD | TBD | TBD | Minimal | 8 | Minimal — cosmetic/niche; leave to upstream | Helsinki Finite-State Technology spell-checking library |
| 494 | **libreoffice-dictionaries** | TBD | TBD | TBD | Minimal | 8 | Minimal — cosmetic/niche; leave to upstream | Spell-check dictionaries for LibreOffice |
| 495 | **scowl** | TBD | TBD | TBD | Minimal | 8 | Minimal — cosmetic/niche; leave to upstream | Spell Checker Oriented Word Lists |
| 496 | **tk-html3** | TBD | TBD | TBD | Minimal | 8 | Minimal — cosmetic/niche; leave to upstream | HTML widget for Tcl/Tk |
| 497 | **uhttpmock** | TBD | TBD | TBD | Minimal | 8 | Minimal — cosmetic/niche; leave to upstream | HTTP web service mocking library |
| 498 | **aspell-he** | TBD | TBD | TBD | Minimal | 7 | Minimal — cosmetic/niche; leave to upstream | Hebrew dictionary for GNU Aspell |
| 499 | **culmus** | TBD | TBD | TBD | Minimal | 7 | Minimal — cosmetic/niche; leave to upstream | Hebrew TrueType fonts collection |
| 500 | **dutch** | TBD | TBD | TBD | Minimal | 7 | Minimal — cosmetic/niche; leave to upstream | Dutch dictionary (wordlist) |
| 501 | **hspell** | TBD | TBD | TBD | Minimal | 7 | Minimal — cosmetic/niche; leave to upstream | Hebrew spell checker |
| 502 | **hunspell-ar** | TBD | TBD | TBD | Minimal | 7 | Minimal — cosmetic/niche; leave to upstream | Arabic dictionary for Hunspell |
| 503 | **hunspell-be** | TBD | TBD | TBD | Minimal | 7 | Minimal — cosmetic/niche; leave to upstream | Belarusian dictionary for Hunspell |
| 504 | **hunspell-bo** | TBD | TBD | TBD | Minimal | 7 | Minimal — cosmetic/niche; leave to upstream | Classical Tibetan dictionary for Hunspell |
| 505 | **hunspell-br** | TBD | TBD | TBD | Minimal | 7 | Minimal — cosmetic/niche; leave to upstream | Breton dictionary for Hunspell |
| 506 | **hunspell-ca** | TBD | TBD | TBD | Minimal | 7 | Minimal — cosmetic/niche; leave to upstream | Catalan dictionary for Hunspell |
| 507 | **hunspell-dict-ko** | TBD | TBD | TBD | Minimal | 7 | Minimal — cosmetic/niche; leave to upstream | Korean dictionary for Hunspell |
| 508 | **hunspell-dz** | TBD | TBD | TBD | Minimal | 7 | Minimal — cosmetic/niche; leave to upstream | Dzongkha dictionary for Hunspell |
| 509 | **hunspell-fr** | TBD | TBD | TBD | Minimal | 7 | Minimal — cosmetic/niche; leave to upstream | French dictionary for Hunspell |
| 510 | **hunspell-kk** | TBD | TBD | TBD | Minimal | 7 | Minimal — cosmetic/niche; leave to upstream | Kazakh dictionary for Hunspell |
| 511 | **hunspell-lv** | TBD | TBD | TBD | Minimal | 7 | Minimal — cosmetic/niche; leave to upstream | Latvian dictionary for Hunspell |
| 512 | **hunspell-ml** | TBD | TBD | TBD | Minimal | 7 | Minimal — cosmetic/niche; leave to upstream | Malayalam dictionary for Hunspell |
| 513 | **igerman98** | TBD | TBD | TBD | Minimal | 7 | Minimal — cosmetic/niche; leave to upstream | German dictionary for ispell/hunspell |
| 514 | **aglfn** | TBD | TBD | TBD | Minimal | 6 | Minimal — cosmetic/niche; leave to upstream | Adobe Glyph List For New Fonts — maps glyph names to Unicode values |
| 515 | **dict-foldoc** | TBD | TBD | TBD | Minimal | 6 | Minimal — cosmetic/niche; leave to upstream | Free On-Line Dictionary of Computing (FOLDOC) for dictd |
| 516 | **dict-gcide** | TBD | TBD | TBD | Minimal | 6 | Minimal — cosmetic/niche; leave to upstream | GNU Collaborative International Dictionary of English |
| 517 | **dict-jargon** | TBD | TBD | TBD | Minimal | 6 | Minimal — cosmetic/niche; leave to upstream | Jargon File — hacker slang dictionary for dictd |
| 518 | **fonts-dejavu** | TBD | TBD | TBD | Minimal | 6 | Minimal — cosmetic/niche; leave to upstream | DejaVu font family (extended Unicode coverage) |
| 519 | **fonts-liberation** | TBD | TBD | TBD | Minimal | 6 | Minimal — cosmetic/niche; leave to upstream | Liberation fonts (metrically compatible with Arial, Times, Courier) |
| 520 | **fonts-liberation2** | TBD | TBD | TBD | Minimal | 6 | Minimal — cosmetic/niche; leave to upstream | Liberation fonts version 2 |
| 521 | **fonts-ubuntu** | TBD | TBD | TBD | Minimal | 6 | Minimal — cosmetic/niche; leave to upstream | Ubuntu font family |
| 522 | **uzbek-wordlist** | TBD | TBD | TBD | Minimal | 6 | Minimal — cosmetic/niche; leave to upstream | Uzbek language word list |
| 523 | **xuxen-eu-spell** | TBD | TBD | TBD | Minimal | 6 | Minimal — cosmetic/niche; leave to upstream | Basque (Euskara) spell-checking dictionary |
| 524 | **adium-theme-ubuntu** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Ubuntu theme for the Adium chat client |
| 525 | **fnt** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Font manager for Linux (downloads and installs fonts) |
| 526 | **folder-color** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Change folder icon color in Nautilus file manager |
| 527 | **folder-color-caja** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Change folder icon color in MATE Caja file manager |
| 528 | **folder-color-common** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Common files for folder-color extensions |
| 529 | **fonts-cantarell** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME default UI font (Cantarell) |
| 530 | **fonts-font-awesome** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Font Awesome iconic font |
| 531 | **fonts-freefont** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNU FreeFont — large Unicode coverage font family |
| 532 | **fonts-inconsolata** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Inconsolata monospace programming font |
| 533 | **fonts-inter** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Inter variable font family for UI and text |
| 534 | **fonts-lato** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Lato sans-serif font family |
| 535 | **fonts-nanum** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Nanum Korean font family (Myeongjo, Gothic, Pen) |
| 536 | **fonts-open-sans** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Open Sans sans-serif font family by Google |
| 537 | **fonts-roboto** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Google Roboto font family (Android default) |
| 538 | **fonts-urw-base35** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | URW base 35 PostScript Type 1 fonts (modern) |
| 539 | **freetable** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Perl script for generating HTML tables from flat data |
| 540 | **unifont** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNU Unifont — complete Unicode BMP bitmap font |
| 541 | **xfonts-scalable-nonfree** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Scalable non-free X11 fonts |
| 542 | **fonts-android** | TBD | TBD | TBD | Minimal | 4 | Minimal — cosmetic/niche; leave to upstream | Android platform fonts (Roboto, Noto) |
| 543 | **fonts-arphic-ukai** | TBD | TBD | TBD | Minimal | 4 | Minimal — cosmetic/niche; leave to upstream | AR PL UKai Chinese Unicode TrueType font (Kai style) |
| 544 | **fonts-arphic-uming** | TBD | TBD | TBD | Minimal | 4 | Minimal — cosmetic/niche; leave to upstream | AR PL UMing Chinese Unicode TrueType font (Ming style) |
| 545 | **fonts-beng** | TBD | TBD | TBD | Minimal | 4 | Minimal — cosmetic/niche; leave to upstream | Bengali metapackage font collection |
| 546 | **fonts-deva** | TBD | TBD | TBD | Minimal | 4 | Minimal — cosmetic/niche; leave to upstream | Devanagari metapackage font collection |
| 547 | **fonts-ebgaramond** | TBD | TBD | TBD | Minimal | 4 | Minimal — cosmetic/niche; leave to upstream | EB Garamond revival typeface |
| 548 | **fonts-gujr** | TBD | TBD | TBD | Minimal | 4 | Minimal — cosmetic/niche; leave to upstream | Gujarati metapackage font collection |
| 549 | **fonts-guru** | TBD | TBD | TBD | Minimal | 4 | Minimal — cosmetic/niche; leave to upstream | Gurmukhi metapackage font collection |
| 550 | **fonts-indic** | TBD | TBD | TBD | Minimal | 4 | Minimal — cosmetic/niche; leave to upstream | Metapackage for Indic language fonts |
| 551 | **fonts-khmeros** | TBD | TBD | TBD | Minimal | 4 | Minimal — cosmetic/niche; leave to upstream | Khmer Unicode fonts for Cambodia |
| 552 | **fonts-knda** | TBD | TBD | TBD | Minimal | 4 | Minimal — cosmetic/niche; leave to upstream | Kannada metapackage font collection |
| 553 | **fonts-lao** | TBD | TBD | TBD | Minimal | 4 | Minimal — cosmetic/niche; leave to upstream | TrueType fonts for Lao language |
| 554 | **fonts-linuxlibertine** | TBD | TBD | TBD | Minimal | 4 | Minimal — cosmetic/niche; leave to upstream | Linux Libertine serif and biolinum sans-serif fonts |
| 555 | **fonts-mlym** | TBD | TBD | TBD | Minimal | 4 | Minimal — cosmetic/niche; leave to upstream | Malayalam metapackage font collection |
| 556 | **fonts-orya** | TBD | TBD | TBD | Minimal | 4 | Minimal — cosmetic/niche; leave to upstream | Oriya metapackage font collection |
| 557 | **fonts-roboto-slab** | TBD | TBD | TBD | Minimal | 4 | Minimal — cosmetic/niche; leave to upstream | Roboto Slab serif font family |
| 558 | **fonts-stix** | TBD | TBD | TBD | Minimal | 4 | Minimal — cosmetic/niche; leave to upstream | STIX scientific and technical publishing fonts |
| 559 | **fonts-taml** | TBD | TBD | TBD | Minimal | 4 | Minimal — cosmetic/niche; leave to upstream | Tamil metapackage font collection |
| 560 | **fonts-telu** | TBD | TBD | TBD | Minimal | 4 | Minimal — cosmetic/niche; leave to upstream | Telugu metapackage font collection |
| 561 | **fonts-tibetan-machine** | TBD | TBD | TBD | Minimal | 4 | Minimal — cosmetic/niche; leave to upstream | Tibetan Machine Uni OpenType font |
| 562 | **fonts-tlwg** | TBD | TBD | TBD | Minimal | 4 | Minimal — cosmetic/niche; leave to upstream | Thai Linux Working Group font collection |
| 563 | **fonts-vlgothic** | TBD | TBD | TBD | Minimal | 4 | Minimal — cosmetic/niche; leave to upstream | VL Gothic Japanese font |
| 564 | **ttf-ancient-fonts** | TBD | TBD | TBD | Minimal | 4 | Minimal — cosmetic/niche; leave to upstream | Unicode fonts for ancient scripts (Aegean, Egyptian, etc.) |
| 565 | **vera** | TBD | TBD | TBD | Minimal | 4 | Minimal — cosmetic/niche; leave to upstream | Vera TrueType font family (Bitstream Vera) |
| 566 | **bf-utf** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | Unicode-based braille font |
| 567 | **comic-neue** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | Casual handwriting-style font (Comic Sans alternative) |
| 568 | **fonts-adf** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | Arkandis Digital Foundry font collection |
| 569 | **fonts-aenigma** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | Collection of 465 freeware TrueType fonts by Brian Kent |
| 570 | **fonts-agave** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | Monospaced programming font |
| 571 | **fonts-alee** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | Free Hangul (Korean) TrueType fonts by A Lee |
| 572 | **fonts-arabeyes** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | Arabeyes free Arabic TrueType fonts |
| 573 | **fonts-beng-extra** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | Extra Bengali fonts |
| 574 | **fonts-bpg-georgian** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | BPG Georgian Unicode fonts |
| 575 | **fonts-cabin** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | Cabin humanist sans-serif font family |
| 576 | **fonts-comfortaa** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | Rounded geometric sans-serif display font |
| 577 | **fonts-crosextra-caladea** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | Chrome OS extra Caladea serif font (Cambria metric-compatible) |
| 578 | **fonts-crosextra-carlito** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | Chrome OS extra Carlito sans-serif font (Calibri metric-compatible) |
| 579 | **fonts-deva-extra** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | Extra Devanagari script fonts |
| 580 | **fonts-farsiweb** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | FarsiWeb free Persian/Farsi fonts |
| 581 | **fonts-go** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | Go programming language fonts |
| 582 | **fonts-hosny-amiri** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | Amiri Arabic Naskh font by Khaled Hosny |
| 583 | **fonts-jsmath** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | jsMath mathematical symbol fonts |
| 584 | **fonts-kacst** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | KACST free TrueType Arabic fonts |
| 585 | **fonts-kacst-one** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | KACST One TrueType Arabic fonts |
| 586 | **fonts-lklug-sinhala** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | LKLUG Sinhala Unicode font |
| 587 | **fonts-lohit-beng-assamese** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | Lohit Assamese font |
| 588 | **fonts-lohit-beng-bengali** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | Lohit Bengali font |
| 589 | **fonts-lohit-deva** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | Lohit Devanagari font |
| 590 | **fonts-lohit-gujr** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | Lohit Gujarati font |
| 591 | **fonts-lohit-guru** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | Lohit Gurmukhi font |
| 592 | **fonts-lohit-knda** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | Lohit Kannada font |
| 593 | **fonts-lohit-mlym** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | Lohit Malayalam font |
| 594 | **fonts-lohit-orya** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | Lohit Oriya font |
| 595 | **fonts-lohit-taml** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | Lohit Tamil font |
| 596 | **fonts-lohit-taml-classical** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | Lohit Tamil Classical font |
| 597 | **fonts-lohit-telu** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | Lohit Telugu font |
| 598 | **fonts-ocr-a** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | OCR-A optical character recognition font |
| 599 | **fonts-ocr-b** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | OCR-B optical character recognition font |
| 600 | **fonts-opendyslexic** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | Font designed to increase readability for dyslexic readers |
| 601 | **fonts-sil-abyssinica** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | SIL Abyssinica Ethiopic script font |
| 602 | **fonts-sil-andika** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | SIL Andika font for literacy and beginning readers |
| 603 | **fonts-sil-charis** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | SIL Charis serif font for multilingual publishing |
| 604 | **fonts-sil-doulos** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | SIL Doulos serif font (IPA phonetics) |
| 605 | **fonts-sil-gentium** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | SIL Gentium international serif font |
| 606 | **fonts-sil-gentium-basic** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | SIL Gentium Basic simplified font |
| 607 | **fonts-sil-gentiumplus** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | SIL Gentium Plus extended serif font |
| 608 | **fonts-sil-padauk** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | SIL Padauk Myanmar/Burmese font |
| 609 | **fonts-sil-scheherazade** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | SIL Scheherazade Arabic font |
| 610 | **fonts-smc** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | Malayalam fonts by Swathanthra Malayalam Computing |
| 611 | **fonts-tiresias** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | Tiresias fonts designed for visually impaired readers |
| 612 | **fonts-ubuntu-title** | TBD | TBD | TBD | Minimal | 3 | Minimal — cosmetic/niche; leave to upstream | Ubuntu Title decorative font |
| 613 | **dkg-handwriting** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | Handwriting font by Daniel Kahn Gillmor |
| 614 | **fonts-atarismall** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | Small Atari-style pixel font |
| 615 | **fonts-breip** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | Informal handwriting-style font |
| 616 | **fonts-dustin** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | Collection of dustismo TrueType fonts |
| 617 | **fonts-ecolier-court** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | Cursive handwriting font for French schoolchildren |
| 618 | **fonts-ecolier-lignes-court** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | Cursive handwriting font with guide lines |
| 619 | **fonts-fanwood** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | Fanwood serif font (Fairfield revival) |
| 620 | **fonts-gargi** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | OpenType Devanagari font |
| 621 | **fonts-georgewilliams** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | George Williams' Caslon, Caliban, and Cupola fonts |
| 622 | **fonts-gfs-artemisia** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | GFS Artemisia Greek font |
| 623 | **fonts-gfs-baskerville** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | GFS Baskerville Greek font |
| 624 | **fonts-gfs-didot** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | GFS Didot Greek font |
| 625 | **fonts-gfs-neohellenic** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | GFS Neohellenic Greek sans-serif font |
| 626 | **fonts-goudybookletter** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | Goudy Bookletter 1911 serif font revival |
| 627 | **fonts-gubbi** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | Gubbi Kannada font |
| 628 | **fonts-gujr-extra** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | Extra Gujarati script fonts |
| 629 | **fonts-guru-extra** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | Extra Gurmukhi script fonts |
| 630 | **fonts-humor-sans** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | Humor Sans handwriting-style font (XKCD-like) |
| 631 | **fonts-junicode** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | Junicode medieval Unicode font |
| 632 | **fonts-jura** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | Jura serif font family |
| 633 | **fonts-kalapi** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | Kalapi Gujarati Unicode font |
| 634 | **fonts-larabie** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | Larabie decorative TrueType fonts |
| 635 | **fonts-league-spartan** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | League Spartan bold geometric sans-serif font |
| 636 | **fonts-lobstertwo** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | Lobster Two script/display font |
| 637 | **fonts-nafees** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | Nafees Pakistani Urdu fonts |
| 638 | **fonts-nakula** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | Nakula Devanagari font |
| 639 | **fonts-navilu** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | Navilu Kannada font |
| 640 | **fonts-oflb-asana-math** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | Asana Math OpenType mathematical symbol font |
| 641 | **fonts-orya-extra** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | Extra Oriya script fonts |
| 642 | **fonts-osifont** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | ISO 3098-compliant technical lettering font |
| 643 | **fonts-quicksand** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | Quicksand sans-serif display font |
| 644 | **fonts-sahadeva** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | Sahadeva Devanagari font |
| 645 | **fonts-samyak** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | Samyak TrueType fonts for Indian languages |
| 646 | **fonts-sarai** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | Sarai Devanagari Unicode font |
| 647 | **fonts-sil-ezra** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | SIL Ezra Biblical Hebrew font |
| 648 | **fonts-sil-gentiumplus-compact** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | SIL Gentium Plus Compact (smaller line spacing) |
| 649 | **fonts-sil-nuosusil** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | SIL Nuosu Yi script font |
| 650 | **fonts-smc-anjalioldlipi** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | SMC Anjali Old Lipi Malayalam font |
| 651 | **fonts-smc-chilanka** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | SMC Chilanka handwriting Malayalam font |
| 652 | **fonts-smc-dyuthi** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | SMC Dyuthi Malayalam font |
| 653 | **fonts-smc-gayathri** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | SMC Gayathri Malayalam font |
| 654 | **fonts-smc-keraleeyam** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | SMC Keraleeyam traditional Malayalam font |
| 655 | **fonts-smc-manjari** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | SMC Manjari Malayalam sans-serif font |
| 656 | **fonts-smc-meera** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | SMC Meera Malayalam font |
| 657 | **fonts-smc-rachana** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | SMC Rachana Malayalam traditional font |
| 658 | **fonts-smc-raghumalayalamsans** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | SMC Raghu Malayalam Sans font |
| 659 | **fonts-smc-suruma** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | SMC Suruma Malayalam font |
| 660 | **fonts-smc-uroob** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | SMC Uroob Malayalam font |
| 661 | **fonts-telu-extra** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | Extra Telugu script fonts |
| 662 | **fonts-teluguvijayam** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | Telugu Vijayam decorative font |
| 663 | **fonts-tuffy** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | Tuffy sans-serif font family |
| 664 | **fonts-ukij-uyghur** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | UKIJ Uyghur Arabic-script fonts |
| 665 | **fonts-yrsa-rasa** | TBD | TBD | TBD | Minimal | 2 | Minimal — cosmetic/niche; leave to upstream | Yrsa and Rasa Latin/Gujarati font pair |
| 666 | **fonts-f500** | TBD | TBD | TBD | Minimal | 1 | Minimal — cosmetic/niche; leave to upstream | F500 pixel font |
| 667 | **fonts-gfs-complutum** | TBD | TBD | TBD | Minimal | 1 | Minimal — cosmetic/niche; leave to upstream | GFS Complutum Greek font |
| 668 | **fonts-gfs-olga** | TBD | TBD | TBD | Minimal | 1 | Minimal — cosmetic/niche; leave to upstream | GFS Olga Greek cursive font |
| 669 | **fonts-gfs-porson** | TBD | TBD | TBD | Minimal | 1 | Minimal — cosmetic/niche; leave to upstream | GFS Porson Greek font |
| 670 | **fonts-gfs-solomos** | TBD | TBD | TBD | Minimal | 1 | Minimal — cosmetic/niche; leave to upstream | GFS Solomos Greek decorative font |
| 671 | **fonts-isabella** | TBD | TBD | TBD | Minimal | 1 | Minimal — cosmetic/niche; leave to upstream | Isabella decorative blackletter font |
| 672 | **fonts-lindenhill** | TBD | TBD | TBD | Minimal | 1 | Minimal — cosmetic/niche; leave to upstream | Linden Hill digital revival of Frederic Goudy's Deepdene |
| 673 | **fonts-linex** | TBD | TBD | TBD | Minimal | 1 | Minimal — cosmetic/niche; leave to upstream | LinEx fonts from Extremadura's Linux distribution |
| 674 | **fonts-manchufont** | TBD | TBD | TBD | Minimal | 1 | Minimal — cosmetic/niche; leave to upstream | Manchu script TrueType font |
| 675 | **fonts-oflb-euterpe** | TBD | TBD | TBD | Minimal | 1 | Minimal — cosmetic/niche; leave to upstream | Euterpe musical notation font |
| 676 | **fonts-okolaks** | TBD | TBD | TBD | Minimal | 1 | Minimal — cosmetic/niche; leave to upstream | Okolaks display font family |
| 677 | **fonts-pagul** | TBD | TBD | TBD | Minimal | 1 | Minimal — cosmetic/niche; leave to upstream | Pagul Saurashtri script font |
| 678 | **fonts-radisnoir** | TBD | TBD | TBD | Minimal | 1 | Minimal — cosmetic/niche; leave to upstream | RadisNoir decorative font |
| 679 | **fonts-smc-karumbi** | TBD | TBD | TBD | Minimal | 1 | Minimal — cosmetic/niche; leave to upstream | SMC Karumbi Malayalam decorative font |
| 680 | **fonts-staypuft** | TBD | TBD | TBD | Minimal | 1 | Minimal — cosmetic/niche; leave to upstream | Stay-Puft rounded sans-serif display font |
| 681 | **fonts-tomsontalks** | TBD | TBD | TBD | Minimal | 1 | Minimal — cosmetic/niche; leave to upstream | Tomson Talks handwriting font |

---

*8-column matrix generated from the existing ranked `README.md` (0–83 scores) and `DESCRIPTORS.md` (descriptions). Years developed / software house filled only where reliably known, else `TBD`; age of expertise derived from the start year. Relative value and Improve are bands derived from the importance score. Max Rupplin — MEARVK LLC — 2026.*
