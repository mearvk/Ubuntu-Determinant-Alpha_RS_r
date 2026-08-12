# ubuntu.slaves.black — Ubuntu Source Package Slave Repository

Slave package directory containing the Ubuntu 22.04.3 LTS **source** ISOs, split into multi-part chunks for Git-compatible storage and distribution.

These are **not** installable binary `.deb` packages. They contain Debian source packages (`.dsc` + `.orig.tar.*` + `.debian.tar.*`) — the raw source code used to build the binaries that `apt install` fetches. They exist for GPL compliance: any recipient of the binary OS distribution has full access to the corresponding source.

**Total Size:** ~12 GB  
**Format:** ISO 9660 CD-ROM filesystem data (split via `split`)  
**Source:** Ubuntu 22.04.3 LTS Source Discs 1–4  
**Chunk Size:** ~21 MB per file (Git LFS friendly)

---

## `/1` — Source Disc 1 (Core System & Desktop)

| Property | Value |
|----------|-------|
| ISO Label | `Ubuntu 22.04.3 LTS Source 1` |
| Files | 221 chunks (`ubuntu_1_aa` → `ubuntu_1_im`) |
| Total Size | 4.4 GB |

Notable source packages on this disc:

- **Core:** apt, bash, coreutils, cron, bzip2, base-files, base-passwd, busybox
- **Compiler/Build:** gcc-12, binutils, bison, cmake, autoconf, automake, build-essential
- **Security:** apparmor, audit, ca-certificates, checksecurity, cryptsetup, gnupg2
- **Networking:** apache2, avahi, bind9, cloud-init, corosync, iproute2, iptables
- **Desktop:** adwaita-icon-theme, at-spi2-core, atk1.0, clutter-1.0, colord, gnome-shell extensions
- **Fonts:** freetype, fontforge, fonts-cantarell, fonts-lohit-*, fonts-sil-*, fonts-indic
- **Media:** gst-plugins-base1.0, gst-plugins-good1.0, alsa-driver, alsa-utils
- **Languages:** hunspell-*, aspell, aspell-en, culmus
- **OpenStack:** cinder, ceilometer, aodh, barbican, keystone, glance
- **Browsers:** firefox, webkit2gtk, chromium-browser (source)
- **Editors/Office:** emacs, libreoffice-dictionaries
- **Toolchain:** llvm-toolchain-14, perl, python3-defaults

---

## `/2` — Source Disc 2 (Libraries, Language Packs & Infrastructure)

| Property | Value |
|----------|-------|
| ISO Label | `Ubuntu 22.04.3 LTS Source 2` |
| Files | 221 chunks (`ubuntu_2_aa` → `ubuntu_2_im`) |
| Total Size | 4.5 GB |

Notable source packages on this disc:

- **Core Libraries:** glib2.0, cairo, icu, pcre2, pcre3, gmp, fribidi, pixman, popt, json-c
- **Graphics/Audio:** giflib, gdk-pixbuf-xlib, lame, fftw3, jackd2, cdparanoia
- **GTK Stack:** gtkmm3.0, glibmm2.4, cairomm, pangomm, atkmm1.6, clutter-gtk
- **Crypto/Auth:** krb5, argon2, keyutils, kerberos-configs, gpgme1.0
- **Networking:** c-ares, iproute2, iptables
- **Boot/Init:** initramfs-tools, init-system-helpers, klibc, kmod
- **Build Infra:** boost1.74, abseil, apr, apr-util, cross-toolchain-base
- **Hardware:** pciutils, intel-processor-trace, babeltrace
- **Hyphenation:** hyphen, hyphen-indic, hyphen-ru
- **Input:** ibus-table, ibus-table-chinese, im-config
- **Language Packs:** language-pack-af, language-pack-am (and hundreds more)
- **Document:** djvulibre, ijs, jbig2dec, jbigkit, openjpeg2
- **Java:** javascript-common, jeepney
- **OpenStack:** keystone (continued)

---

## `/3` — Source Disc 3 (GPU Drivers, Audio, Java/Maven, Python)

| Property | Value |
|----------|-------|
| ISO Label | `Ubuntu 22.04.3 LTS Source 3` |
| Files | 62 chunks (`ubuntu_3_aa` → `ubuntu_3_cj`) |
| Total Size | 1.3 GB |

Notable source packages on this disc:

- **GPU/Restricted:** nvidia-graphics-drivers-510/515/525/535 (server & desktop)
- **Audio/Media:** pulseaudio, pipewire, opus, orc, portaudio19, opencore-amr, openal-soft
- **System:** pam, procps, parted, pcsc-lite, p11-kit
- **Graphics:** egl-wayland, openexr, pixman, potrace
- **Text/i18n:** opencc, perl (continued), python3.10
- **Networking:** unixodbc, openmpi, pmix
- **Java/Maven:** openjfx, openjpa, opentest4j, plexus-* (archiver, classworlds, compiler, containers, interpolation, io, languages, utils2, velocity), polyglot-maven, parboiled, pegdown, picocli, osgi-*
- **Security:** pam-wrapper
- **Document:** opensp, openjade
- **Infrastructure:** openipmi, openhpi, infinipath-psm

---

## `/4` — Source Disc 4 (Kernel, Dictionaries, OpenStack, System Tools)

| Property | Value |
|----------|-------|
| ISO Label | `Ubuntu 22.04.3 LTS Source 4` |
| Files | 71 chunks (`ubuntu_4_aa` → `ubuntu_4_cs`) |
| Total Size | 1.4 GB |

Notable source packages on this disc:

- **Linux Kernel:** linux, linux-aws, linux-azure, linux-ibm, linux-intel-iotg, linux-kvm, linux-lowlatency, linux-oracle, linux-riscv, linux-meta, linux-oem-5.17, linux-allwinner-5.17, linux-starfive-5.17
- **Dictionaries/Spell:** dict-nr, dict-ns, dict-ss, dict-st, dict-tn, dict-ts, dict-ve, dict-xh, dict-zu, iirish, imanx, ispell-et, ispell-fo, ispell-uk, myspell-fa, myspell-hy, norwegian, eo-spell, bgoffice
- **OpenStack:** nova, neutron, neutron-vpnaas, horizon, masakari, masakari-monitors
- **System Tools:** lintian, licensecheck, lsb, lsof, logcheck, logwatch, man-db, manpages, mawk, mdadm, m4, make-dfsg, needrestart
- **Networking:** netbase, netcat-openbsd, net-tools, networkd-dispatcher, nut
- **Hardware:** lm-sensors, lksctp-tools, mobile-broadband-provider-info
- **NVIDIA:** nvidia-prime, nvidia-settings
- **Packaging:** live-build, livecd-rootfs, lxd-agent-loader, lxd-installer, media-types
- **Build:** lockfile-progs, lto-disabled-list

---

## `/5` — Terminator (End Marker)

| Property | Value |
|----------|-------|
| Files | 1 (`quit.git`) |
| Content | `a_ k.Quit if your ahead` |
| Purpose | Signals end of the source disc set |

---

## `/jars` — MySQL Connector/J

| File | Size | Description |
|------|------|-------------|
| `mysql-connector-j-9.7.0.tar.gz` | 4.6 MB | MySQL Connector/J 9.7.0 source archive |
| `mysql-connector-j_9.7.0-1ubuntu25.10_all.deb` | 2.5 MB | MySQL Connector/J 9.7.0 Debian package (binary) |

Used by the Secure JVM MySQL Bridge and NitroWebExpress application server.

---

## Scripts

Scripts for reassembly and source extraction are located in `ubuntu.slaves.black/` and symlinked into `scripts/`.

### Reassembly Scripts

| Script | Purpose |
|--------|---------|
| `reassemble-source-iso-1.sh` | Reassemble Source Disc 1 (core, compilers, desktop) |
| `reassemble-source-iso-2.sh` | Reassemble Source Disc 2 (libraries, language packs) |
| `reassemble-source-iso-3.sh` | Reassemble Source Disc 3 (GPU drivers, audio, Java) |
| `reassemble-source-iso-4.sh` | Reassemble Source Disc 4 (kernel, dictionaries, OpenStack) |
| `reassemble-source-all.sh` | Reassemble all 4 discs (optionally extract pool) |
| `extract-source-packages.sh` | Extract individual or all source packages for development |

### Usage

```bash
cd ubuntu.slaves.black

# Reassemble a single disc
./reassemble-source-iso-1.sh                    # → ubuntu-22.04.3-source-1.iso
./reassemble-source-iso-4.sh /tmp/isos          # → /tmp/isos/ubuntu-22.04.3-source-4.iso

# Reassemble all discs at once
./reassemble-source-all.sh

# Reassemble all + extract into a unified pool directory
./reassemble-source-all.sh --extract-pool ./dev-sources

# Extract a specific package for development
./extract-source-packages.sh --package linux ./kernel-src
./extract-source-packages.sh --package gcc-12 ./gcc-build

# Search available packages
./extract-source-packages.sh --search "python*"

# List all available source packages
./extract-source-packages.sh --list
```

### Manual Reassembly

```bash
cd ubuntu.slaves.black

# Reassemble each source disc by hand
cat 1/ubuntu_1_* > ubuntu-22.04.3-source-1.iso
cat 2/ubuntu_2_* > ubuntu-22.04.3-source-2.iso
cat 3/ubuntu_3_* > ubuntu-22.04.3-source-3.iso
cat 4/ubuntu_4_* > ubuntu-22.04.3-source-4.iso

# Verify
file ubuntu-22.04.3-source-1.iso
# → ISO 9660 CD-ROM filesystem data 'Ubuntu 22.04.3 LTS Source 1'

# Mount and browse
sudo mount -o loop,ro ubuntu-22.04.3-source-1.iso /mnt
ls /mnt/pool/main/
sudo umount /mnt
```

---

## Purpose

These ISOs provide **GPL/copyleft compliance** for the Ubuntu Determinant Alpha RS distribution. They contain the complete source code (as Debian source packages) for all packages shipped in Ubuntu 22.04.3 LTS (Jammy Jellyfish), ensuring any recipient of the binary distribution has access to the corresponding source as required by the GPL, LGPL, and other copyleft licenses.

The files are split into ~21 MB chunks to comply with Git hosting file size limits while keeping the full source available within the repository.

---

## License

Ubuntu source packages retain their original upstream licenses (GPL-2.0, GPL-3.0, LGPL-2.1, MIT, BSD, Apache-2.0, etc. as applicable per package).
