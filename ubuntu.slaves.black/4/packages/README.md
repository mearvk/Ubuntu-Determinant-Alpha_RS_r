# Packages — Ranked by Importance (8-Column Matrix)

## Homomorphic Ego Concentration

Each package is projected onto a perceivable scale of **0 to 83**:

- **83** = Perfectly standard. Foundational to computing itself.
- **0** = Perfectly non-relevant to standard. Decorative, niche, ornamental.

The *homomorphic ego concentration* is a structure-preserving map from the
space of all software packages to a single scalar representing how essential
a package is to the concept of "software standard next to man the sage."

Disc 4 holds the system-services "l–r" slice: crypto/security libraries
(OpenSSL, OpenSSH, seccomp, SELinux), X11 client libraries, networking and
storage tooling, build/ISO tooling, OpenStack services, plus many Perl modules,
language dictionaries, and OEM enablement meta-packages.

## Column definitions

1. **Rank** — position in the disc-4 importance ordering (1 = most important).
2. **Software** — source package name (Ubuntu 22.04.3, disc 4).
3. **Years developed** — first public release year of the upstream project, where reliably known; else `TBD`.
4. **Software house** — upstream steward/organization, where reliably known; else `TBD`.
5. **Age of expertise** — 2026 − first release year, where known; else `TBD`.
6. **Relative value** — band from the score: Foundational (≥75), High (60–74), Moderate (30–59), Low (10–29), Minimal (<10).
7. **Importance (0–83)** — homomorphic-ego-concentration score (created for disc 4, same model as discs 1–3).
8. **Improve** — importance of improving/integrating the package, derived (with reason).
9. **Description** — concise factual description.

> Honesty note: disc 4 had no prior ranked README/DESCRIPTORS, so scores and
> descriptions here are newly created using the same model as discs 1–3. Years
> developed / Software house are filled only where genuinely known; the rest are
> `TBD` rather than guessed.

**Total packages: 219**

| Rank | Software | Years developed | Software house | Age of expertise | Relative value | Importance (0–83) | Improve | Description |
|-----:|---------|-----------------|----------------|-----------------:|----------------|:-----------------:|---------|-------------|
| 1 | **openssl** | 1998 | OpenSSL Project | 28 | High | 72 | High — foundational; changes need strong evidence and review | OpenSSL — TLS/crypto toolkit and library |
| 2 | **openssh** | 1999 | OpenBSD project | 27 | High | 70 | High — foundational; changes need strong evidence and review | OpenSSH — secure shell client/server |
| 3 | **make-dfsg** | 1988 | GNU Project | 38 | High | 68 | Medium — meaningful integration/hardening value | GNU Make build automation tool |
| 4 | **libseccomp** | 2012 | libseccomp project | 14 | High | 66 | Medium — meaningful integration/hardening value | Seccomp BPF syscall-filtering library — sandboxing |
| 5 | **libx11** | 1987 | X.Org Foundation | 39 | High | 66 | Medium — meaningful integration/hardening value | Core X11 client library (libX11) |
| 6 | **libxml2** | 1999 | GNOME Project | 27 | High | 66 | Medium — meaningful integration/hardening value | GNOME XML parsing/toolkit library |
| 7 | **libselinux** | 2001 | NSA / SELinux project | 25 | High | 64 | Medium — meaningful integration/hardening value | SELinux runtime library |
| 8 | **libzstd** | 2016 | Facebook / Meta | 10 | High | 62 | Medium — meaningful integration/hardening value | Zstandard fast compression library |
| 9 | **libsodium** | 2013 | libsodium project | 13 | High | 60 | Medium — meaningful integration/hardening value | Modern easy-to-use crypto library |
| 10 | **libxcb** | 2001 | X.Org Foundation | 25 | High | 60 | Medium — meaningful integration/hardening value | X protocol C-language Binding |
| 11 | **m4** | 1991 | GNU Project | 35 | High | 60 | Medium — meaningful integration/hardening value | GNU M4 macro processor |
| 12 | **libssh** | 2003 | libssh project | 23 | Moderate | 58 | Medium — meaningful integration/hardening value | SSH protocol client/server C library |
| 13 | **libtasn1-6** | 2002 | GNU Project | 24 | Moderate | 58 | Medium — meaningful integration/hardening value | ASN.1 parsing library (used by GnuTLS) |
| 14 | **linux-meta** | 2005 | Ubuntu | 21 | Moderate | 58 | Medium — meaningful integration/hardening value | Meta-packages selecting the Ubuntu kernel |
| 15 | **man-db** | 1994 | man-db project | 32 | Moderate | 58 | Medium — meaningful integration/hardening value | Manual page database and viewer |
| 16 | **mawk** | 1991 | Mike Brennan / Thomas Dickey | 35 | Moderate | 58 | Medium — meaningful integration/hardening value | AWK interpreter (mawk) |
| 17 | **netbase** | 1995 | Debian Project | 31 | Moderate | 58 | Medium — meaningful integration/hardening value | Basic TCP/IP networking system configuration |
| 18 | **libsdl2** | 2013 | SDL project | 13 | Moderate | 56 | Medium — meaningful integration/hardening value | Simple DirectMedia Layer 2 — multimedia/input/graphics |
| 19 | **libsemanage** | 2004 | SELinux project | 22 | Moderate | 56 | Medium — meaningful integration/hardening value | SELinux policy management library |
| 20 | **libsepol** | 2004 | SELinux project | 22 | Moderate | 56 | Medium — meaningful integration/hardening value | SELinux binary policy library |
| 21 | **libuv1** | 2011 | libuv project / Node.js | 15 | Moderate | 56 | Medium — meaningful integration/hardening value | Asynchronous I/O event-loop library (libuv) |
| 22 | **libxkbcommon** | 2012 | freedesktop.org | 14 | Moderate | 56 | Medium — meaningful integration/hardening value | Keyboard keymap handling library (XKB) |
| 23 | **libxslt** | 2001 | GNOME Project | 25 | Moderate | 56 | Medium — meaningful integration/hardening value | XSLT processing library (libxml2 companion) |
| 24 | **linux-base** | 2009 | Debian/Ubuntu | 17 | Moderate | 56 | Medium — meaningful integration/hardening value | Base system for the Linux kernel packages |
| 25 | **mdadm** | 2001 | Neil Brown / community | 25 | Moderate | 56 | Medium — meaningful integration/hardening value | Linux software RAID administration |
| 26 | **net-tools** | 1992 | net-tools project | 34 | Moderate | 56 | Medium — meaningful integration/hardening value | Classic networking tools (ifconfig, netstat, route) |
| 27 | **libtirpc** | 2007 | Linux community | 19 | Moderate | 54 | Medium — meaningful integration/hardening value | Transport-independent RPC library |
| 28 | **libusb-1.0** | 2001 | libusb project | 25 | Moderate | 54 | Medium — meaningful integration/hardening value | USB device access library |
| 29 | **lsof** | 1994 | Vic Abell | 32 | Moderate | 54 | Medium — meaningful integration/hardening value | List open files utility |
| 30 | **libunistring** | 2009 | GNU Project | 17 | Moderate | 52 | Medium — meaningful integration/hardening value | Unicode string manipulation library |
| 31 | **libunwind** | 2003 | libunwind project | 23 | Moderate | 52 | Medium — meaningful integration/hardening value | Stack unwinding library |
| 32 | **libvpx** | 2010 | Google / WebM | 16 | Moderate | 50 | Medium — meaningful integration/hardening value | VP8/VP9 video codec library |
| 33 | **libwebp** | 2010 | Google | 16 | Moderate | 50 | Medium — meaningful integration/hardening value | WebP image codec library |
| 34 | **libyaml** | 2006 | pyyaml/libyaml project | 20 | Moderate | 50 | Medium — meaningful integration/hardening value | YAML 1.1 parser/emitter C library (libyaml) |
| 35 | **netcat-openbsd** | 1996 | OpenBSD project | 30 | Moderate | 50 | Medium — meaningful integration/hardening value | OpenBSD netcat — TCP/IP swiss-army knife |
| 36 | **openvswitch** | 2009 | Open vSwitch / Linux Foundation | 17 | Moderate | 50 | Medium — meaningful integration/hardening value | Open vSwitch — multilayer virtual switch |
| 37 | **libsndfile** | 1999 | libsndfile project | 27 | Moderate | 48 | Medium — meaningful integration/hardening value | Library for reading/writing sampled sound files |
| 38 | **liburcu** | 2009 | EfficiOS / LTTng | 17 | Moderate | 48 | Medium — meaningful integration/hardening value | Userspace RCU library |
| 39 | **libvorbis** | 2000 | Xiph.Org Foundation | 26 | Moderate | 48 | Medium — meaningful integration/hardening value | Ogg Vorbis audio codec library |
| 40 | **lintian** | 1998 | Debian Project | 28 | Moderate | 48 | Medium — meaningful integration/hardening value | Debian package quality/policy checker |
| 41 | **livecd-rootfs** | 2006 | Ubuntu | 20 | Moderate | 48 | Medium — meaningful integration/hardening value | Ubuntu live/installer root filesystem build tooling |
| 42 | **orca** | 2006 | GNOME Project | 20 | Moderate | 48 | Medium — meaningful integration/hardening value | GNOME screen reader (accessibility) |
| 43 | **live-build** | 2006 | Debian Live project | 20 | Moderate | 46 | Medium — meaningful integration/hardening value | Tooling to build live/installer images |
| 44 | **lm-sensors** | 1998 | lm-sensors project | 28 | Moderate | 46 | Medium — meaningful integration/hardening value | Hardware health monitoring (temps/fans/voltages) |
| 45 | **libtheora** | 2004 | Xiph.Org Foundation | 22 | Moderate | 44 | Low — integrate as-is; improve only with cause | Theora video codec library |
| 46 | **libusb** | 2000 | libusb project | 26 | Moderate | 44 | Low — integrate as-is; improve only with cause | USB device access library (legacy 0.1 API) |
| 47 | **lsb** | 2001 | Linux Foundation | 25 | Moderate | 44 | Low — integrate as-is; improve only with cause | Linux Standard Base support |
| 48 | **needrestart** | 2013 | needrestart project | 13 | Moderate | 44 | Low — integrate as-is; improve only with cause | Detect services needing restart after upgrades |
| 49 | **plocate** | 2020 | Steinar H. Gunderson | 6 | Moderate | 44 | Low — integrate as-is; improve only with cause | Fast file locate/updatedb replacement |
| 50 | **libraw** | 2008 | LibRaw project | 18 | Moderate | 42 | Low — integrate as-is; improve only with cause | RAW camera image decoding library |
| 51 | **nova** | 2010 | OpenStack | 16 | Moderate | 42 | Low — integrate as-is; improve only with cause | OpenStack Nova compute service |
| 52 | **nut** | 1998 | Network UPS Tools project | 28 | Moderate | 42 | Low — integrate as-is; improve only with cause | Network UPS Tools — UPS monitoring |
| 53 | **libsamplerate** | 2002 | libsndfile project | 24 | Moderate | 40 | Low — integrate as-is; improve only with cause | Sample-rate conversion library |
| 54 | **libvdpau** | 2008 | NVIDIA | 18 | Moderate | 40 | Low — integrate as-is; improve only with cause | Video Decode and Presentation API for Unix |
| 55 | **libwacom** | 2011 | freedesktop.org | 15 | Moderate | 40 | Low — integrate as-is; improve only with cause | Wacom tablet description/access library |
| 56 | **libwww-perl** | 1995 | libwww-perl (LWP) project | 31 | Moderate | 40 | Low — integrate as-is; improve only with cause | LWP — the World-Wide Web library for Perl |
| 57 | **manpages** | 1993 | Linux man-pages project | 33 | Moderate | 40 | Low — integrate as-is; improve only with cause | Linux man-pages (sections 1-8) |
| 58 | **media-types** | 1996 | Debian Project | 30 | Moderate | 40 | Low — integrate as-is; improve only with cause | System MIME type registry (/etc/mime.types) |
| 59 | **networkd-dispatcher** | 2016 | networkd-dispatcher project | 10 | Moderate | 40 | Low — integrate as-is; improve only with cause | Dispatcher for systemd-networkd events |
| 60 | **neutron** | 2012 | OpenStack | 14 | Moderate | 40 | Low — integrate as-is; improve only with cause | OpenStack Neutron networking service |
| 61 | **opensbi** | 2018 | RISC-V / Western Digital | 8 | Moderate | 40 | Low — integrate as-is; improve only with cause | RISC-V Open Supervisor Binary Interface firmware |
| 62 | **librabbitmq** | 2009 | RabbitMQ / Pivotal | 17 | Moderate | 38 | Low — integrate as-is; improve only with cause | RabbitMQ AMQP client C library |
| 63 | **libthai** | 2001 | libthai project | 25 | Moderate | 38 | Low — integrate as-is; improve only with cause | Thai language support library |
| 64 | **libutempter** | 2001 | Red Hat / Altlinux | 25 | Moderate | 38 | Low — integrate as-is; improve only with cause | utmp/wtmp login-record helper library |
| 65 | **libvncserver** | 2001 | LibVNCServer project | 25 | Moderate | 38 | Low — integrate as-is; improve only with cause | VNC server/client C library |
| 66 | **libxml-libxml-perl** | 2001 | Perl XML community | 25 | Moderate | 38 | Low — integrate as-is; improve only with cause | Perl binding for libxml2 |
| 67 | **mime-support** | 1996 | Debian Project | 30 | Moderate | 36 | Low — integrate as-is; improve only with cause | MIME type associations (legacy) |
| 68 | **libraw1394** | 2000 | Linux1394 project | 26 | Moderate | 34 | Low — integrate as-is; improve only with cause | IEEE 1394 (FireWire) access library |
| 69 | **libsigc++-2.0** | 2002 | libsigc++ project | 24 | Moderate | 34 | Low — integrate as-is; improve only with cause | Type-safe C++ callback/signal library |
| 70 | **libsm** | 1993 | X.Org Foundation | 33 | Moderate | 34 | Low — integrate as-is; improve only with cause | X11 Session Management library |
| 71 | **libtommath** | 2003 | libtom project | 23 | Moderate | 34 | Low — integrate as-is; improve only with cause | Portable multiple-precision integer library |
| 72 | **libverto** | 2011 | Red Hat | 15 | Moderate | 34 | Low — integrate as-is; improve only with cause | Event-loop abstraction library |
| 73 | **libxau** | TBD | TBD | TBD | Moderate | 34 | Low — integrate as-is; improve only with cause | X11 client/extension library |
| 74 | **libxaw** | TBD | TBD | TBD | Moderate | 34 | Low — integrate as-is; improve only with cause | X11 client/extension library |
| 75 | **libxcomposite** | TBD | TBD | TBD | Moderate | 34 | Low — integrate as-is; improve only with cause | X11 client/extension library |
| 76 | **libxcursor** | TBD | TBD | TBD | Moderate | 34 | Low — integrate as-is; improve only with cause | X11 client/extension library |
| 77 | **libxcvt** | TBD | TBD | TBD | Moderate | 34 | Low — integrate as-is; improve only with cause | X11 client/extension library |
| 78 | **libxdamage** | TBD | TBD | TBD | Moderate | 34 | Low — integrate as-is; improve only with cause | X11 client/extension library |
| 79 | **libxdmcp** | TBD | TBD | TBD | Moderate | 34 | Low — integrate as-is; improve only with cause | X11 client/extension library |
| 80 | **libxext** | TBD | TBD | TBD | Moderate | 34 | Low — integrate as-is; improve only with cause | X11 client/extension library |
| 81 | **libxfixes** | TBD | TBD | TBD | Moderate | 34 | Low — integrate as-is; improve only with cause | X11 client/extension library |
| 82 | **libxfont** | TBD | TBD | TBD | Moderate | 34 | Low — integrate as-is; improve only with cause | X11 client/extension library |
| 83 | **libxi** | TBD | TBD | TBD | Moderate | 34 | Low — integrate as-is; improve only with cause | X11 client/extension library |
| 84 | **libxinerama** | TBD | TBD | TBD | Moderate | 34 | Low — integrate as-is; improve only with cause | X11 client/extension library |
| 85 | **libxkbfile** | TBD | TBD | TBD | Moderate | 34 | Low — integrate as-is; improve only with cause | X11 client/extension library |
| 86 | **libxml++2.6** | TBD | TBD | TBD | Moderate | 34 | Low — integrate as-is; improve only with cause | X11 client/extension library |
| 87 | **libxml-parser-perl** | 1998 | Perl XML community | 28 | Moderate | 34 | Low — integrate as-is; improve only with cause | Perl XML::Parser (expat-based) |
| 88 | **libxmu** | TBD | TBD | TBD | Moderate | 34 | Low — integrate as-is; improve only with cause | X11 client/extension library |
| 89 | **libxpm** | TBD | TBD | TBD | Moderate | 34 | Low — integrate as-is; improve only with cause | X11 client/extension library |
| 90 | **libxrandr** | TBD | TBD | TBD | Moderate | 34 | Low — integrate as-is; improve only with cause | X11 client/extension library |
| 91 | **libxrender** | TBD | TBD | TBD | Moderate | 34 | Low — integrate as-is; improve only with cause | X11 client/extension library |
| 92 | **libxres** | TBD | TBD | TBD | Moderate | 34 | Low — integrate as-is; improve only with cause | X11 client/extension library |
| 93 | **libxshmfence** | TBD | TBD | TBD | Moderate | 34 | Low — integrate as-is; improve only with cause | X11 client/extension library |
| 94 | **libxss** | TBD | TBD | TBD | Moderate | 34 | Low — integrate as-is; improve only with cause | X11 client/extension library |
| 95 | **libxt** | TBD | TBD | TBD | Moderate | 34 | Low — integrate as-is; improve only with cause | X11 client/extension library |
| 96 | **libxtst** | TBD | TBD | TBD | Moderate | 34 | Low — integrate as-is; improve only with cause | X11 client/extension library |
| 97 | **libxv** | TBD | TBD | TBD | Moderate | 34 | Low — integrate as-is; improve only with cause | X11 client/extension library |
| 98 | **libxvmc** | TBD | TBD | TBD | Moderate | 34 | Low — integrate as-is; improve only with cause | X11 client/extension library |
| 99 | **libxxf86dga** | TBD | TBD | TBD | Moderate | 34 | Low — integrate as-is; improve only with cause | X11 client/extension library |
| 100 | **libxxf86vm** | TBD | TBD | TBD | Moderate | 34 | Low — integrate as-is; improve only with cause | X11 client/extension library |
| 101 | **lksctp-tools** | 2001 | LKSCTP project | 25 | Moderate | 34 | Low — integrate as-is; improve only with cause | SCTP protocol tools and library |
| 102 | **mailcap** | 1996 | Debian Project | 30 | Moderate | 34 | Low — integrate as-is; improve only with cause | Mailcap MIME handler configuration |
| 103 | **nvidia-settings** | 2004 | NVIDIA | 22 | Moderate | 34 | Low — integrate as-is; improve only with cause | NVIDIA GPU settings control panel |
| 104 | **raptor2** | 2000 | Dave Beckett / Redland | 26 | Moderate | 34 | Low — integrate as-is; improve only with cause | RDF parsing/serializing library (Redland) |
| 105 | **libshout** | 2001 | Xiph.Org Foundation | 25 | Moderate | 30 | Low — integrate as-is; improve only with cause | Library for sending audio to Icecast servers |
| 106 | **libsigsegv** | 2002 | GNU / libsigsegv | 24 | Moderate | 30 | Low — integrate as-is; improve only with cause | Library for handling page faults in user mode |
| 107 | **libsoxr** | 2013 | SoX project | 13 | Moderate | 30 | Low — integrate as-is; improve only with cause | SoX resampler library |
| 108 | **libu2f-host** | 2015 | Yubico | 11 | Moderate | 30 | Low — integrate as-is; improve only with cause | U2F host-side communication library |
| 109 | **lockfile-progs** | 1999 | Debian Project | 27 | Moderate | 30 | Low — integrate as-is; improve only with cause | Lockfile manipulation programs |
| 110 | **logcheck** | 1996 | logcheck project | 30 | Moderate | 30 | Low — integrate as-is; improve only with cause | Log-analysis and anomaly-mailing tool |
| 111 | **logwatch** | 1999 | Logwatch project | 27 | Moderate | 30 | Low — integrate as-is; improve only with cause | Log summarization/reporting tool |
| 112 | **mobile-broadband-provider-info** | 2008 | GNOME/freedesktop | 18 | Moderate | 30 | Low — integrate as-is; improve only with cause | Database of mobile broadband providers |
| 113 | **nvidia-prime** | 2013 | NVIDIA / Ubuntu | 13 | Moderate | 30 | Low — integrate as-is; improve only with cause | NVIDIA/Intel GPU switching (PRIME) |
| 114 | **optipng** | 2001 | optipng project | 25 | Moderate | 30 | Low — integrate as-is; improve only with cause | PNG optimizer |
| 115 | **python-os-brick** | 2015 | OpenStack | 11 | Moderate | 30 | Low — integrate as-is; improve only with cause | OpenStack library for block-storage attach/detach |
| 116 | **rasqal** | 2003 | Dave Beckett / Redland | 23 | Moderate | 30 | Low — integrate as-is; improve only with cause | RDF query library (Redland) |
| 117 | **libspectre** | 2008 | freedesktop.org | 18 | Low | 28 | Low — integrate as-is; improve only with cause | Small PostScript rendering library |
| 118 | **libusbmuxd** | 2009 | libimobiledevice project | 17 | Low | 28 | Low — integrate as-is; improve only with cause | USB multiplexer library for Apple devices |
| 119 | **libwpe** | 2016 | Igalia / WPE | 10 | Low | 26 | Low — integrate as-is; improve only with cause | WPE WebKit platform abstraction library |
| 120 | **libstatgrab** | 2000 | libstatgrab project | 26 | Low | 24 | Low — integrate as-is; improve only with cause | System statistics gathering library |
| 121 | **libteam** | TBD | TBD | TBD | Low | 24 | Low — integrate as-is; improve only with cause | TBD |
| 122 | **lxd-agent-loader** | 2018 | Canonical / LXD | 8 | Low | 24 | Low — integrate as-is; improve only with cause | Loader for the LXD guest agent |
| 123 | **lxd-installer** | 2020 | Canonical / LXD | 6 | Low | 24 | Low — integrate as-is; improve only with cause | LXD installation shim |
| 124 | **neutron-vpnaas** | 2014 | OpenStack | 12 | Low | 24 | Low — integrate as-is; improve only with cause | OpenStack Neutron VPN-as-a-Service |
| 125 | **horizon** | TBD | TBD | TBD | Low | 22 | Low — integrate as-is; improve only with cause | TBD |
| 126 | **librevenge** | 2013 | Document Liberation Project | 13 | Low | 22 | Low — integrate as-is; improve only with cause | Base library for document import filters |
| 127 | **libvisio** | 2011 | Document Liberation Project | 15 | Low | 22 | Low — integrate as-is; improve only with cause | Microsoft Visio import library |
| 128 | **libvisual** | 2004 | libvisual project | 22 | Low | 22 | Low — integrate as-is; improve only with cause | Audio visualization framework library |
| 129 | **libwmf** | 1998 | libwmf project | 28 | Low | 22 | Low — integrate as-is; improve only with cause | Windows Metafile (WMF) rendering library |
| 130 | **libwpd** | 2004 | Document Liberation Project | 22 | Low | 22 | Low — integrate as-is; improve only with cause | WordPerfect document import library |
| 131 | **licensecheck** | TBD | TBD | TBD | Low | 22 | Low — integrate as-is; improve only with cause | TBD |
| 132 | **masakari** | 2016 | OpenStack | 10 | Low | 22 | Low — integrate as-is; improve only with cause | OpenStack Masakari instance high-availability |
| 133 | **mecab-ipadic** | 2005 | MeCab project | 21 | Low | 22 | Low — integrate as-is; improve only with cause | IPADIC dictionary for MeCab Japanese tokenizer |
| 134 | **libtextwrap** | 2003 | Debian Project | 23 | Low | 20 | Low — integrate as-is; improve only with cause | Text-wrapping library with i18n support |
| 135 | **libvoikko** | 2006 | Voikko project | 20 | Low | 20 | Low — integrate as-is; improve only with cause | Finnish spell-check/grammar library |
| 136 | **libwpg** | 2006 | Document Liberation Project | 20 | Low | 20 | Low — integrate as-is; improve only with cause | WordPerfect Graphics import library |
| 137 | **masakari-monitors** | 2016 | OpenStack | 10 | Low | 20 | Low — integrate as-is; improve only with cause | Monitors for OpenStack Masakari |
| 138 | **lto-disabled-list** | 2020 | Debian Project | 6 | Low | 16 | Low — integrate as-is; improve only with cause | List of packages with LTO disabled (build metadata) |
| 139 | **mime-construct** | 2002 | Debian Project | 24 | Low | 16 | Low — integrate as-is; improve only with cause | Construct/send MIME messages from the shell |
| 140 | **miscfiles** | 1993 | GNU Project | 33 | Low | 16 | Low — integrate as-is; improve only with cause | Miscellaneous data files (word lists, etc.) |
| 141 | **make-doc-non-dfsg** | 1988 | GNU Project | 38 | Low | 14 | Minimal — cosmetic/niche; leave to upstream | Non-DFSG documentation for GNU Make |
| 142 | **libreadonly-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: readonly |
| 143 | **libref-util-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: ref util |
| 144 | **libregexp-pattern-license-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: regexp pattern license |
| 145 | **libregexp-pattern-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: regexp pattern |
| 146 | **librole-tiny-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: role tiny |
| 147 | **libset-intspan-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: set intspan |
| 148 | **libsort-naturally-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: sort naturally |
| 149 | **libsort-versions-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: sort versions |
| 150 | **libstrictures-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: strictures |
| 151 | **libstring-copyright-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: string copyright |
| 152 | **libstring-escape-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: string escape |
| 153 | **libstring-shellquote-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: string shellquote |
| 154 | **libsub-exporter-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: sub exporter |
| 155 | **libsub-exporter-progressive-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: sub exporter progressive |
| 156 | **libsub-identify-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: sub identify |
| 157 | **libsub-install-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: sub install |
| 158 | **libsub-name-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: sub name |
| 159 | **libsub-override-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: sub override |
| 160 | **libsub-quote-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: sub quote |
| 161 | **libsys-hostname-long-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: sys hostname long |
| 162 | **libtext-charwidth-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: text charwidth |
| 163 | **libtext-glob-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: text glob |
| 164 | **libtext-iconv-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: text iconv |
| 165 | **libtext-wrapi18n-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: text wrapi18n |
| 166 | **libtie-ixhash-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: tie ixhash |
| 167 | **libtime-duration-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: time duration |
| 168 | **libtimedate-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: timedate |
| 169 | **libtry-tiny-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: try tiny |
| 170 | **libtype-tiny-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: type tiny |
| 171 | **libtypes-serialiser-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: types serialiser |
| 172 | **liburi-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: uri |
| 173 | **libvariable-magic-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: variable magic |
| 174 | **libwant-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: want |
| 175 | **libwww-robotrules-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: www robotrules |
| 176 | **libx11-protocol-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: x11 protocol |
| 177 | **libxml-namespacesupport-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: xml namespacesupport |
| 178 | **libxml-sax-base-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: xml sax base |
| 179 | **libxml-sax-expat-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: xml sax expat |
| 180 | **libxml-sax-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: xml sax |
| 181 | **libxml-simple-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: xml simple |
| 182 | **libxml-twig-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: xml twig |
| 183 | **libxml-xpathengine-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: xml xpathengine |
| 184 | **libyaml-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: yaml |
| 185 | **libyaml-tiny-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: yaml tiny |
| 186 | **openthesaurus** | 2004 | OpenThesaurus | 22 | Low | 12 | Minimal — cosmetic/niche; leave to upstream | German thesaurus data |
| 187 | **bgoffice** | TBD | TBD | TBD | Low | 10 | Minimal — cosmetic/niche; leave to upstream | Bulgarian office/dictionary data |
| 188 | **dict-nr** | TBD | TBD | TBD | Minimal | 8 | Minimal — cosmetic/niche; leave to upstream | Dictionary data (nr) |
| 189 | **dict-ns** | TBD | TBD | TBD | Minimal | 8 | Minimal — cosmetic/niche; leave to upstream | Dictionary data (ns) |
| 190 | **dict-ss** | TBD | TBD | TBD | Minimal | 8 | Minimal — cosmetic/niche; leave to upstream | Dictionary data (ss) |
| 191 | **dict-st** | TBD | TBD | TBD | Minimal | 8 | Minimal — cosmetic/niche; leave to upstream | Dictionary data (st) |
| 192 | **dict-tn** | TBD | TBD | TBD | Minimal | 8 | Minimal — cosmetic/niche; leave to upstream | Dictionary data (tn) |
| 193 | **dict-ts** | TBD | TBD | TBD | Minimal | 8 | Minimal — cosmetic/niche; leave to upstream | Dictionary data (ts) |
| 194 | **dict-ve** | TBD | TBD | TBD | Minimal | 8 | Minimal — cosmetic/niche; leave to upstream | Dictionary data (ve) |
| 195 | **dict-xh** | TBD | TBD | TBD | Minimal | 8 | Minimal — cosmetic/niche; leave to upstream | Dictionary data (xh) |
| 196 | **dict-zu** | TBD | TBD | TBD | Minimal | 8 | Minimal — cosmetic/niche; leave to upstream | Dictionary data (zu) |
| 197 | **eo-spell** | TBD | TBD | TBD | Minimal | 8 | Minimal — cosmetic/niche; leave to upstream | Esperanto spell-check dictionary |
| 198 | **iirish** | TBD | TBD | TBD | Minimal | 8 | Minimal — cosmetic/niche; leave to upstream | TBD |
| 199 | **imanx** | TBD | TBD | TBD | Minimal | 8 | Minimal — cosmetic/niche; leave to upstream | TBD |
| 200 | **ispell-et** | TBD | TBD | TBD | Minimal | 8 | Minimal — cosmetic/niche; leave to upstream | Ispell dictionary (et) |
| 201 | **ispell-fo** | TBD | TBD | TBD | Minimal | 8 | Minimal — cosmetic/niche; leave to upstream | Ispell dictionary (fo) |
| 202 | **ispell-uk** | TBD | TBD | TBD | Minimal | 8 | Minimal — cosmetic/niche; leave to upstream | Ispell dictionary (uk) |
| 203 | **myspell-fa** | TBD | TBD | TBD | Minimal | 8 | Minimal — cosmetic/niche; leave to upstream | MySpell dictionary (fa) |
| 204 | **myspell-hy** | TBD | TBD | TBD | Minimal | 8 | Minimal — cosmetic/niche; leave to upstream | MySpell dictionary (hy) |
| 205 | **norwegian** | TBD | TBD | TBD | Minimal | 8 | Minimal — cosmetic/niche; leave to upstream | Norwegian spelling dictionaries |
| 206 | **openoffice.org-en-au** | TBD | TBD | TBD | Minimal | 8 | Minimal — cosmetic/niche; leave to upstream | Australian English dictionary for office suites |
| 207 | **openoffice.org-thesaurus-pl** | TBD | TBD | TBD | Minimal | 8 | Minimal — cosmetic/niche; leave to upstream | Polish thesaurus for OpenOffice/LibreOffice |
| 208 | **oem-qemu-meta** | TBD | TBD | TBD | Minimal | 6 | Minimal — cosmetic/niche; leave to upstream | Ubuntu OEM enablement meta-package (hardware-specific) |
| 209 | **oem-somerville-tentacool-meta** | TBD | TBD | TBD | Minimal | 6 | Minimal — cosmetic/niche; leave to upstream | Ubuntu OEM enablement meta-package (hardware-specific) |
| 210 | **oem-somerville-tentacool-rpl-meta** | TBD | TBD | TBD | Minimal | 6 | Minimal — cosmetic/niche; leave to upstream | Ubuntu OEM enablement meta-package (hardware-specific) |
| 211 | **oem-sutton-balin-meta** | TBD | TBD | TBD | Minimal | 6 | Minimal — cosmetic/niche; leave to upstream | Ubuntu OEM enablement meta-package (hardware-specific) |
| 212 | **oem-sutton-balint-meta** | TBD | TBD | TBD | Minimal | 6 | Minimal — cosmetic/niche; leave to upstream | Ubuntu OEM enablement meta-package (hardware-specific) |
| 213 | **oem-sutton-bambina-meta** | TBD | TBD | TBD | Minimal | 6 | Minimal — cosmetic/niche; leave to upstream | Ubuntu OEM enablement meta-package (hardware-specific) |
| 214 | **oem-sutton-banagher-meta** | TBD | TBD | TBD | Minimal | 6 | Minimal — cosmetic/niche; leave to upstream | Ubuntu OEM enablement meta-package (hardware-specific) |
| 215 | **oem-sutton-cailean-meta** | TBD | TBD | TBD | Minimal | 6 | Minimal — cosmetic/niche; leave to upstream | Ubuntu OEM enablement meta-package (hardware-specific) |
| 216 | **oem-sutton-cailyn-meta** | TBD | TBD | TBD | Minimal | 6 | Minimal — cosmetic/niche; leave to upstream | Ubuntu OEM enablement meta-package (hardware-specific) |
| 217 | **oem-sutton-cais-meta** | TBD | TBD | TBD | Minimal | 6 | Minimal — cosmetic/niche; leave to upstream | Ubuntu OEM enablement meta-package (hardware-specific) |
| 218 | **oem-sutton-cappy-meta** | TBD | TBD | TBD | Minimal | 6 | Minimal — cosmetic/niche; leave to upstream | Ubuntu OEM enablement meta-package (hardware-specific) |
| 219 | **oem-sutton-caressa-meta** | TBD | TBD | TBD | Minimal | 6 | Minimal — cosmetic/niche; leave to upstream | Ubuntu OEM enablement meta-package (hardware-specific) |

---

*Disc-4 ranked 8-column matrix, created from the 219 real disc-4 packages using the same 0–83 homomorphic-ego model as discs 1–3. Years developed / software house filled only where reliably known, else `TBD`. Max Rupplin — MEARVK LLC — 2026.*
