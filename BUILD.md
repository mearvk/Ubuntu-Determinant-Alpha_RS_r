# BUILD.md — Ubuntu Determinant Alpha RS

## Galactic Cherry Marvell Edition 98

**Kernel:** Linux 5.15.204  
**Userland:** Ubuntu Base 24.04.4 (Noble Numbat)  
**Architecture:** x86_64 (amd64)

---

## Quick Start (Full Build from Scratch)

```bash
make kernel-defconfig
make all
make rootfs-full
make iso
```

This produces `build/galactic-cherry-98.iso` — a bootable hybrid ISO for CD/DVD/USB/UEFI.

---

## Prerequisites

Install all build dependencies on a Debian/Ubuntu host:

```bash
sudo apt install -y \
    gcc make flex bison bc libelf-dev libssl-dev \
    meson ninja-build pkg-config \
    autoconf automake libtool \
    cmake g++ rustc cargo libjson-c-dev libncurses-dev \
    fakeroot cpio gzip \
    xorriso squashfs-tools grub-pc-bin grub-efi-amd64-bin mtools \
    wget
```

| Component | Requires |
|-----------|----------|
| Kernel | gcc, make, flex, bison, libelf-dev, bc, libssl-dev |
| X11 | meson, ninja-build, pkg-config, gcc |
| Cronie | autoconf, automake, libtool |
| ClamAV | cmake, rustc, cargo, libssl-dev, libjson-c-dev |
| MySQL | cmake, g++, libssl-dev, libncurses-dev |
| OpenJDK 28 | wget (download) or boot JDK 26/27 (source build) |
| Wine | git, libfreetype-dev, libfontconfig-dev, libvulkan-dev, libgstreamer1.0-dev, mingw-w64 |
| Rootfs | fakeroot, cpio, gzip |
| ISO | xorriso, squashfs-tools, grub-pc-bin, grub-efi-amd64-bin, mtools |
| chkrootkit | gcc (cc) |
| rkhunter | (no compilation — shell-based) |

---

## Build Order

The build proceeds in a strict dependency order. The `make rootfs-full` target handles this automatically, but the sequence is documented here for reference.

### Phase 1: Kernel Configuration

```bash
make kernel-defconfig
```

Applies the Galactic Cherry defconfig with all custom extensions enabled:

- CONFIG_EPMP=m (Extended Port Multiplexing Protocol)
- CONFIG_HPM=m (Heuristic Port Monitor)
- CONFIG_SECURITY_EPERM=m (Extended Permission Classes)
- CONFIG_USB_SWAP=m (USB Dynamic RAM Expansion)
- CONFIG_USB_FAST_DMA=m (USB Hardware-Direct DMA)
- CONFIG_NEGAMANE=m (Immutable Filesystem Brand)

Additional kernel-resident modules: USER_KO, WHITE_ETHICS, CPUBOOST.

For interactive configuration:

```bash
make kernel-menuconfig
```

### Phase 2: Kernel Compilation

```bash
make kernel
```

Compiles the Linux 5.15.204 kernel with all extensions using all available CPU cores.

**Output:** `kernels/linux-5.15.204/linux-5.15.204/arch/x86/boot/bzImage`

### Phase 3: Userland

```bash
make userland
```

Builds all user-space components in parallel:

1. **X11** — X.Org Server 21.1.24 + libraries (dependency-ordered)
2. **Wallpapers** — 9 Galactic Cherry SVG wallpapers
3. **Core Tools** — sudo_gate, chat, nnet, negamane, accounts

### Phase 4: Extended Tools

```bash
make tools-all
```

Builds all extended tools (longer compilation times):

| Order | Target | Build System | Description |
|-------|--------|-------------|-------------|
| 1 | tools (core) | make | sudo_gate, chat, nnet, negamane, accounts |
| 2 | tools-cronie | autotools | Cron daemon with callback extension |
| 3 | tools-clamav | cmake | Protected antivirus (Memory Grain 3) |
| 4 | tools-mysql | cmake | Protected database + package registry |
| 5 | tools-ai | make/cmake | Dave — system intelligence (llama.cpp) |
| 6 | tools-chkrootkit | make | Rootkit detection (C helpers) |
| 7 | tools-rkhunter | (none) | Rootkit Hunter (shell-based, install only) |

### Phase 5: OpenJDK 28

```bash
make java
```

Downloads the prebuilt OpenJDK 28 EA binary (~227 MB). Alternatively, build from included source:

```bash
make -C userland/java build-from-source BOOT_JDK=/usr/lib/jvm/jdk-27
```

### Phase 5b: Wine (Windows Compatibility Layer)

```bash
make wine
```

Performs a shallow git clone (`--depth 1`) of the official Wine repository from `https://gitlab.winehq.org/wine/wine.git` at tag `wine-9.0`, then compiles a 64-bit Wine with MinGW PE support. The shallow clone keeps only the single tagged commit, minimizing disk usage (~250 MB) while providing the full compilable source tree.

**Individual steps:**

```bash
make wine-fetch    # Shallow-clone Wine repo (--depth 1, tag wine-9.0)
make wine-build    # Configure and compile (64-bit, out-of-tree build)
make wine-install  # Install into rootfs
```

**Alternative — binary install from WineHQ APT repository:**

```bash
make wine-binary   # Stages APT-based install (requires network in chroot/first boot)
```

**Configuration variables:**

| Variable | Default | Description |
|----------|---------|-------------|
| `WINE_VERSION` | `9.0` | Wine version to build |
| `WINE_TAG` | `wine-9.0` | Git tag to checkout |
| `WINE_GIT_URL` | `https://gitlab.winehq.org/wine/wine.git` | Source repository |

**Output:** `userland/wine/build64/` → installs to `build/rootfs/usr/local/`

### Phase 6: Root Filesystem Assembly

```bash
make rootfs
```

Extracts Ubuntu Base 24.04.4 (29 MB) into `build/rootfs/`.

### Phase 7: Installation into Rootfs

```bash
make kernel-install
make x11-install
make wallpapers-install
make java-install
make tools-all-install
```

Installs all compiled components into the `build/rootfs/` tree.

### Phase 8: Boot Components

```bash
make initramfs
make grub
```

Generates the initramfs image and GRUB bootloader configuration.

### Phase 9: ISO Image

```bash
make iso
```

Produces the final bootable ISO: `build/galactic-cherry-98.iso`

---

## Directory Layout

```
.
├── Makefile                          # Top-level orchestrator
├── BUILD.md                          # This file
├── README.md                         # System documentation
│
├── kernels/
│   └── linux-5.15.204/
│       └── linux-5.15.204/           # Full kernel source tree
│           ├── arch/x86/boot/bzImage # Compiled kernel image
│           ├── net/ipv4/epmp.c       # EPMP module
│           ├── net/ipv4/hpm.c        # Heuristic Port Monitor
│           ├── security/eperm/       # Extended Permission Classes
│           ├── drivers/usb/storage/  # USB swap + DMA modules
│           ├── fs/negamane/          # Immutable filesystem brand
│           ├── kernel/user_ko.c      # Per-user kernel objects
│           ├── kernel/white_ethics.c # White Ethics module
│           ├── kernel/cpuboost.c     # CPU Boost designation
│           └── tools/               # Userspace tools
│               ├── sudo_gate/       # Graded privilege system
│               ├── chat/            # Terminal chat
│               ├── nnet/            # Identity query tool
│               ├── negamane/        # Immutability CLI
│               ├── accounts/        # Account provisioning
│               ├── cronie/          # Cron with callbacks
│               ├── clamav/          # Protected antivirus
│               ├── mysql/           # Protected database
│               ├── ai/              # Dave (system intelligence)
│               │   ├── llama.cpp/   # Inference engine
│               │   ├── library/     # 75 books (.lib)
│               │   ├── dave_capabilities.json
│               │   ├── dave_external_awareness.json
│               │   └── dave_schema.sql
│               ├── chkrootkit/      # Rootkit detection
│               └── rkhunter/        # Rootkit Hunter
│
├── userland/
│   ├── Makefile                     # Userland orchestrator
│   ├── ubuntu-base-24.04.4-base-amd64.tar.gz  # Base rootfs (29 MB)
│   ├── SHA256SUMS                   # Checksum verification
│   ├── x11/                         # X.Org Server + libraries
│   │   ├── Makefile                 # Dependency-ordered build
│   │   ├── xorgproto-2024.1.tar.xz
│   │   ├── xtrans-1.5.0.tar.xz
│   │   ├── libxcb-1.17.0.tar.xz
│   │   ├── libX11-1.8.13.tar.xz
│   │   ├── libXext-1.3.6.tar.xz
│   │   ├── libXrender-0.9.11.tar.xz
│   │   ├── xorg-server-21.1.24.tar.xz
│   │   ├── xinit-1.4.2.tar.xz
│   │   ├── twm-1.0.12.tar.xz
│   │   ├── xterm-394.tgz
│   │   ├── humanity-icon-theme_0.6.16.tar.xz
│   │   └── adwaita-icon-theme-46.2.tar.xz
│   ├── wallpapers/                  # 9 SVG wallpapers
│   ├── wine/                        # Wine (shallow git clone from gitlab.winehq.org)
│   │   ├── .git/                    # Shallow clone metadata (depth=1)
│   │   ├── configure               # Autotools configure (entry point for build)
│   │   ├── build64/                 # 64-bit out-of-tree build output
│   │   └── build32/                 # 32-bit WoW64 build (if multiarch)
│   └── java/                        # OpenJDK 28
│       ├── Makefile
│       ├── fetch-openjdk.sh         # Download script
│       └── openjdk-28-src/          # Full JDK source (451 MB)
│
├── scripts/
│   ├── gen-initramfs.sh             # Phase 8a: initramfs generation
│   ├── gen-grub-cfg.sh              # Phase 8b: GRUB config generation
│   └── gen-iso.sh                   # Phase 9: bootable ISO creation
│
└── build/                           # Build output (generated)
    ├── rootfs/                      # Assembled root filesystem
    │   ├── boot/
    │   │   ├── vmlinuz-5.15.204
    │   │   ├── System.map-5.15.204
    │   │   ├── initramfs.img
    │   │   └── grub/grub.cfg
    │   ├── usr/
    │   ├── etc/
    │   └── ...
    ├── initramfs.img
    └── galactic-cherry-98.iso       # Final bootable ISO
```

---

## Scripts Reference

### `scripts/gen-initramfs.sh`

**Purpose:** Generates the boot initramfs image with custom module loading.

```
Usage: scripts/gen-initramfs.sh <kernel_dir> <rootfs_dir> <output_path>
```

- Copies busybox (from rootfs or host) into a temporary initramfs tree
- Includes kernel modules for custom extensions (EPMP, HPM, etc.)
- Creates init script that mounts root and loads modules
- Compresses with cpio+gzip into `build/initramfs.img`

### `scripts/gen-grub-cfg.sh`

**Purpose:** Generates GRUB bootloader configuration.

```
Usage: scripts/gen-grub-cfg.sh <rootfs_dir> [root_uuid]
```

- Writes `build/rootfs/boot/grub/grub.cfg`
- Configures kernel command line for Linux 5.15.204
- Sets up graphical terminal with Galactic Cherry theme
- Timeout: 5 seconds

### `scripts/gen-iso.sh`

**Purpose:** Produces a hybrid bootable ISO image.

```
Usage: scripts/gen-iso.sh <rootfs_dir> <output_iso>
```

- Creates El Torito boot image (CD/DVD)
- Adds isohybrid MBR (USB boot)
- Includes UEFI boot support
- Requires: xorriso, grub-mkrescue, grub-pc-bin, grub-efi-amd64-bin, mtools
- Output: `build/galactic-cherry-98.iso`

### `userland/java/fetch-openjdk.sh`

**Purpose:** Downloads and optionally installs OpenJDK 28 EA.

```
Usage: fetch-openjdk.sh <dest_dir> [install_dir]
```

- Downloads from `download.java.net` (~227 MB)
- Verifies SHA-256 checksum
- If install_dir provided: extracts, symlinks binaries, sets JAVA_HOME

### `scripts/install-wine.sh`

**Purpose:** Shallow-clones, builds, and installs Wine into the rootfs.

```
Usage: scripts/install-wine.sh <rootfs_dir> [--clone-only|--binary] [--version X.Y] [--tag TAG]
```

**Modes:**

| Mode | Flag | Description |
|------|------|-------------|
| Source build | (default) | Shallow clone, compile, and install |
| Clone only | `--clone-only` | Shallow clone the repo without building |
| Binary | `--binary` | Install from WineHQ APT repository (chroot or first-boot) |

**Features:**

- Shallow git clone from `gitlab.winehq.org` (`--depth 1 --branch wine-9.0`)
- Builds 64-bit Wine with MinGW PE (WoW64 32-bit if multiarch available)
- Installs Wine Mono (`.NET` replacement) and Wine Gecko (IE replacement)
- Configures `/etc/profile.d/wine.sh` environment
- Registers `.exe` binfmt for direct execution
- Creates `.desktop` files for Wine Configuration and File Manager
- Adds MIME type associations for `.exe` and `.msi` files
- Binary mode stages a first-boot systemd service if chroot unavailable

---

## Individual Build Targets

### Kernel Targets

| Target | Description |
|--------|-------------|
| `make kernel` | Build kernel with all extensions |
| `make kernel-defconfig` | Apply Galactic Cherry defconfig |
| `make kernel-menuconfig` | Interactive kernel configuration |
| `make kernel-modules` | Build modules only |
| `make kernel-install` | Install kernel + modules to rootfs |

### Userland Targets

| Target | Description |
|--------|-------------|
| `make userland` | Build X11 + wallpapers + core tools |
| `make x11` | Build X.Org Server 21.1.24 + libraries |
| `make wallpapers` | Prepare desktop wallpapers |
| `make java` | Fetch OpenJDK 28 binary |

### Wine Targets

| Target | Description |
|--------|-------------|
| `make wine` | Shallow-clone and build Wine from source (64-bit) |
| `make wine-fetch` | Shallow-clone Wine repo only (`--depth 1`) |
| `make wine-build` | Build Wine (requires source cloned first) |
| `make wine-install` | Install Wine into rootfs |
| `make wine-binary` | Install Wine from WineHQ APT repository |
| `make wine-clean` | Remove Wine build directories |
| `make wine-distclean` | Remove entire Wine shallow clone |

### Tool Targets

| Target | Description |
|--------|-------------|
| `make tools` | Build core tools (sudo_gate, chat, nnet, negamane) |
| `make tools-all` | Build ALL tools (core + cronie + clamav + mysql + dave + chkrootkit + rkhunter) |
| `make tools-cronie` | Build cronie (autotools) |
| `make tools-clamav` | Build ClamAV (cmake) |
| `make tools-mysql` | Build MySQL (cmake) |
| `make tools-ai` | Build Dave / llama.cpp |
| `make tools-chkrootkit` | Build chkrootkit (C helpers) |
| `make tools-rkhunter` | Prepare rkhunter (no compilation) |

### Assembly Targets

| Target | Description |
|--------|-------------|
| `make rootfs` | Extract Ubuntu Base into build/rootfs/ |
| `make rootfs-full` | Full system assembly (everything) |
| `make initramfs` | Generate initramfs image |
| `make grub` | Generate GRUB configuration |
| `make iso` | Generate bootable ISO |

### Clean Targets

| Target | Description |
|--------|-------------|
| `make clean` | Remove build/ directory, clean kernel and X11 |
| `make distclean` | Deep clean: kernel distclean, remove cmake/autotools build dirs |

---

## X11 Build Order (Dependency Chain)

The X11 Makefile in `userland/x11/` builds components in strict dependency order:

```
1. xorgproto-2024.1      (protocol headers, no dependencies)
2. xtrans-1.5.0          (transport abstraction, depends on: xorgproto)
3. libxcb-1.17.0         (X C Bindings, depends on: xorgproto)
4. libX11-1.8.13         (core X11 library, depends on: libxcb, xtrans)
5. libXext-1.3.6         (X11 extensions, depends on: libX11)
6. libXrender-0.9.11     (render extension, depends on: libXext)
7. xorg-server-21.1.24   (X server, depends on: libXrender)
8. xinit-1.4.2           (startx, depends on: libX11)
9. twm-1.0.12            (window manager, depends on: libXext)
10. xterm-394            (terminal emulator, depends on: libX11)
11. Humanity icons       (install only, no build)
12. Adwaita icons        (meson build, depends on: xorgproto)
```

All libraries are built into a local sysroot (`userland/x11/_build/sysroot/`) using `PKG_CONFIG_PATH` to find dependencies without requiring system installation.

---

## Build Output

After `make rootfs-full`:

```
build/rootfs/
├── boot/
│   ├── vmlinuz-5.15.204          # Kernel image
│   ├── System.map-5.15.204       # Kernel symbol map
│   ├── initramfs.img             # Init RAM filesystem
│   └── grub/grub.cfg             # GRUB configuration
├── usr/
│   ├── bin/                      # User binaries (java, javac, chat, nnet, pkg-info, ...)
│   ├── sbin/                     # System binaries (install scripts)
│   ├── lib/
│   │   ├── jvm/jdk-28/           # OpenJDK 28
│   │   ├── dave/                 # Dave AI (capabilities, schema, 75 books)
│   │   └── modules/5.15.204/     # Kernel modules
│   └── share/
│       ├── icons/                # Humanity + Adwaita
│       ├── backgrounds/          # 9 Galactic Cherry wallpapers
│       └── man/                  # Manual pages
├── usr/local/
│   ├── bin/
│   │   ├── wine                  # Wine launcher (64-bit)
│   │   ├── wine64                # Wine 64-bit explicit
│   │   ├── wineserver            # Wine server process
│   │   ├── winecfg              # Wine configuration GUI
│   │   ├── wineboot            # Wine prefix initialization
│   │   ├── regedit             # Windows registry editor
│   │   ├── msiexec             # MSI installer
│   │   └── winepath            # Path conversion utility
│   ├── sbin/chkrootkit           # Rootkit detection
│   ├── bin/rkhunter              # Rootkit Hunter
│   ├── lib/wine/                 # Wine libraries and DLLs
│   └── lib/
│       ├── chkrootkit/           # chkrootkit helpers
│       └── rkhunter/scripts/     # rkhunter scripts
├── etc/
│   ├── rkhunter/rkhunter.conf    # rkhunter configuration
│   ├── mysql/                    # MySQL configuration
│   ├── profile.d/java.sh         # JAVA_HOME
│   ├── profile.d/wine.sh         # Wine environment (WINEARCH, WINEPREFIX)
│   └── apt/apt.conf.d/           # APT MySQL hook
├── var/
│   ├── lib/mysql/                # MySQL data directory
│   ├── lib/rkhunter/db/          # rkhunter databases
│   ├── lib/chat/                 # Chat message store
│   └── lib/nnet/                 # nnet identity spaces
└── lib/modules/5.15.204/         # Installed kernel modules
```

After `make iso`:

```
build/galactic-cherry-98.iso      # Bootable hybrid ISO (CD/USB/UEFI)
```

---

## Troubleshooting

### Kernel build fails

```bash
# Ensure all kernel build deps are installed:
sudo apt install gcc make flex bison bc libelf-dev libssl-dev

# Clean and retry:
make distclean
make kernel-defconfig
make kernel
```

### X11 build fails with pkg-config errors

The X11 build uses a local sysroot. If components fail to find dependencies, clean and rebuild:

```bash
make -C userland/x11 clean
make x11
```

### OpenJDK download fails

The fetch script requires network access. Verify connectivity and retry:

```bash
make -C userland/java clean
make java
```

Or build from included source (requires boot JDK 26 or 27):

```bash
make -C userland/java build-from-source BOOT_JDK=/path/to/jdk-27
```

### ClamAV build requires Rust

ClamAV's `libclamav_rust` component needs the Rust toolchain:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env
make tools-clamav
```

### Wine build fails

Wine requires several development libraries. Install all dependencies:

```bash
sudo apt install -y \
    git \
    libfreetype-dev libfontconfig-dev libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev libvulkan-dev libsdl2-dev \
    libpulse-dev libasound2-dev libcups2-dev libdbus-1-dev \
    libgnutls28-dev libusb-1.0-0-dev libunwind-dev \
    libgphoto2-dev liblcms2-dev libldap2-dev libsane-dev libpcap-dev \
    mingw-w64 gettext

# Clean and retry:
make wine-clean
make wine
```

**Wine clone fails:**

The source is shallow-cloned from `gitlab.winehq.org`. Verify network connectivity:

```bash
git ls-remote --tags https://gitlab.winehq.org/wine/wine.git wine-9.0
make wine-fetch
```

If the tag does not exist, override with a valid tag:

```bash
make wine-fetch WINE_TAG=wine-9.0.2
```

**Alternative — use binary install (no compilation required):**

```bash
make wine-binary
```

This stages a first-boot installer that pulls Wine from the WineHQ APT repository.

**32-bit (WoW64) build requires multiarch:**

```bash
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install -y gcc-multilib g++-multilib libfreetype-dev:i386 libgnutls28-dev:i386
```

**Remove and re-clone Wine source:**

```bash
make wine-distclean   # Removes entire shallow clone
make wine-fetch       # Fresh shallow clone
```

---

## Copyright

Copyright (C) 2026 MEARVK LLC  
Author: Maximilian Eric Alexander Rupplin von Keffikon
