# Packages — Ranked by Importance (8-Column Matrix)

## Homomorphic Ego Concentration

Each package is projected onto a perceivable scale of **0 to 83**:

- **83** = Perfectly standard. Foundational to computing itself.
- **0** = Perfectly non-relevant to standard. Decorative, niche, ornamental.

The *homomorphic ego concentration* is a structure-preserving map from the
space of all software packages to a single scalar representing how essential
a package is to the concept of "software standard next to man the sage."

## Column definitions

1. **Rank** — position in the disc-2 importance ordering (1 = most important).
2. **Software** — source package name (Ubuntu 22.04.3, disc 2).
3. **Years developed** — first public release year of the upstream project, where
   reliably known; otherwise `TBD` (assembled offline; per-package dates not
   verified here).
4. **Software house** — upstream steward/organization, where reliably known; else `TBD`.
5. **Age of expertise** — 2026 − first release year, where known; otherwise `TBD`.
6. **Relative value** — band from the score: Foundational (≥75), High (60–74),
   Moderate (30–59), Low (10–29), Minimal (<10).
7. **Importance (0–83)** — existing homomorphic-ego-concentration score, verbatim.
8. **Improve** — importance of improving/integrating the package, derived (with reason).
9. **Description** — from `DESCRIPTORS.md` (verbatim).

> Honesty note: **Years developed** and **Software house** are filled only where
> genuinely known; the majority are `TBD` rather than guessed. Descriptions and
> 0–83 scores are carried over from the existing `DESCRIPTORS.md` and the prior
> ranked `README.md`; they were not regenerated.

**Total packages: 1494**

| Rank | Software | Years developed | Software house | Age of expertise | Relative value | Importance (0–83) | Improve | Description |
|-----:|---------|-----------------|----------------|-----------------:|----------------|:-----------------:|---------|-------------|
| 1 | **cairo** | 2003 | cairographics.org / freedesktop.org | 23 | Foundational | 80 | High — foundational; changes need strong evidence and review | 2D vector graphics library (used by GTK+) |
| 2 | **glib2.0** | 1998 | GNOME Project | 28 | Foundational | 80 | High — foundational; changes need strong evidence and review | GLib core utility library (low-level C library for GNOME) |
| 3 | **systemd** | 2010 | systemd project (Red Hat origin) | 16 | Foundational | 80 | High — foundational; changes need strong evidence and review | System and service manager for Linux |
| 4 | **libffi** | 1996 | libffi project / GCC | 30 | Foundational | 78 | High — foundational; changes need strong evidence and review | Foreign function interface library |
| 5 | **ncurses** | 1993 | GNU Project | 33 | Foundational | 78 | High — foundational; changes need strong evidence and review | Terminal handling library (ncurses) |
| 6 | **readline** | 1989 | GNU Project | 37 | Foundational | 78 | High — foundational; changes need strong evidence and review | GNU Readline library for command-line editing |
| 7 | **xz-utils** | 2009 | Tukaani Project | 17 | Foundational | 78 | High — foundational; changes need strong evidence and review | XZ compression utilities (lzma) |
| 8 | **zlib** | 1995 | Jean-loup Gailly & Mark Adler | 31 | Foundational | 78 | High — foundational; changes need strong evidence and review | Compression library (deflate/inflate) |
| 9 | **icu** | 1999 | Unicode Consortium / IBM | 27 | Foundational | 75 | High — foundational; changes need strong evidence and review | International Components for Unicode (C/C++ library) |
| 10 | **init-system-helpers** | 2013 | Debian Project | 13 | Foundational | 75 | High — foundational; changes need strong evidence and review | Helpers for init system integration (systemd/sysvinit) |
| 11 | **initramfs-tools** | 2005 | Debian/Ubuntu | 21 | Foundational | 75 | High — foundational; changes need strong evidence and review | Tools for generating initramfs images |
| 12 | **iproute2** | 1999 | Linux community (Alexey Kuznetsov) | 27 | Foundational | 75 | High — foundational; changes need strong evidence and review | Linux networking utilities (ip, ss, tc, bridge) |
| 13 | **iptables** | 1998 | Netfilter project | 28 | Foundational | 75 | High — foundational; changes need strong evidence and review | Linux kernel packet filtering administration tools |
| 14 | **kmod** | 2011 | Linux kernel community | 15 | Foundational | 75 | High — foundational; changes need strong evidence and review | Linux kernel module tools (modprobe, lsmod, etc.) |
| 15 | **krb5** | 1993 | MIT | 33 | Foundational | 75 | High — foundational; changes need strong evidence and review | MIT Kerberos 5 authentication library |
| 16 | **openldap** | 1998 | OpenLDAP Foundation | 28 | Foundational | 75 | High — foundational; changes need strong evidence and review | OpenLDAP directory service |
| 17 | **gmp** | 1991 | GNU Project | 35 | High | 72 | High — foundational; changes need strong evidence and review | GNU Multiple Precision Arithmetic Library |
| 18 | **isl** | TBD | TBD | TBD | High | 72 | High — foundational; changes need strong evidence and review | Integer Set Library (polyhedral optimization) |
| 19 | **libarchive** | TBD | TBD | TBD | High | 72 | High — foundational; changes need strong evidence and review | Multi-format archive and compression library |
| 20 | **libdrm** | TBD | TBD | TBD | High | 72 | High — foundational; changes need strong evidence and review | Direct Rendering Manager library (GPU access) |
| 21 | **libgcrypt20** | 1998 | GnuPG Project / g10 Code | 28 | High | 72 | High — foundational; changes need strong evidence and review | GNU cryptographic library (libgcrypt) |
| 22 | **libtool** | TBD | TBD | TBD | High | 72 | High — foundational; changes need strong evidence and review | GNU Libtool — generic library support script |
| 23 | **libxcrypt** | TBD | TBD | TBD | High | 72 | High — foundational; changes need strong evidence and review | Extended crypt library for DES/MD5/SHA password hashing |
| 24 | **mesa** | 1993 | Mesa 3D / freedesktop.org | 33 | High | 72 | High — foundational; changes need strong evidence and review | OpenGL/Vulkan open-source graphics drivers |
| 25 | **mpclib3** | TBD | TBD | TBD | High | 72 | High — foundational; changes need strong evidence and review | — |
| 26 | **mpfr4** | TBD | TBD | TBD | High | 72 | High — foundational; changes need strong evidence and review | — |
| 27 | **nettle** | TBD | TBD | TBD | High | 72 | High — foundational; changes need strong evidence and review | Low-level cryptographic library (used by GnuTLS) |
| 28 | **less** | TBD | TBD | TBD | High | 70 | High — foundational; changes need strong evidence and review | Terminal pager (less is more) |
| 29 | **libcap-ng** | TBD | TBD | TBD | High | 70 | High — foundational; changes need strong evidence and review | POSIX capabilities library (alternate, lightweight) |
| 30 | **libcap2** | TBD | TBD | TBD | High | 70 | High — foundational; changes need strong evidence and review | POSIX capabilities library |
| 31 | **libepoxy** | TBD | TBD | TBD | High | 70 | High — foundational; changes need strong evidence and review | OpenGL function pointer management library |
| 32 | **libev** | TBD | TBD | TBD | High | 70 | High — foundational; changes need strong evidence and review | High-performance event loop library |
| 33 | **libevdev** | TBD | TBD | TBD | High | 70 | High — foundational; changes need strong evidence and review | Linux input event device wrapper library |
| 34 | **libevent** | TBD | TBD | TBD | High | 70 | High — foundational; changes need strong evidence and review | Event notification library (async I/O) |
| 35 | **libinput** | TBD | TBD | TBD | High | 70 | High — foundational; changes need strong evidence and review | Input device handling library (Wayland/X11) |
| 36 | **libnl3** | TBD | TBD | TBD | High | 70 | High — foundational; changes need strong evidence and review | Netlink protocol library suite |
| 37 | **lz4** | TBD | TBD | TBD | High | 70 | High — foundational; changes need strong evidence and review | Extremely fast compression algorithm |
| 38 | **lzo2** | TBD | TBD | TBD | High | 70 | High — foundational; changes need strong evidence and review | LZO real-time data compression library |
| 39 | **nghttp2** | 2012 | nghttp2 project | 14 | High | 70 | High — foundational; changes need strong evidence and review | HTTP/2 C library and tools |
| 40 | **nspr** | TBD | TBD | TBD | High | 70 | High — foundational; changes need strong evidence and review | Netscape Portable Runtime library |
| 41 | **nfs-utils** | TBD | TBD | TBD | High | 68 | Medium — meaningful integration/hardening value | NFS client and server utilities |
| 42 | **php-defaults** | TBD | TBD | TBD | High | 68 | Medium — meaningful integration/hardening value | Default PHP version selection |
| 43 | **php8.1** | TBD | TBD | TBD | High | 68 | Medium — meaningful integration/hardening value | PHP 8.1 scripting language interpreter |
| 44 | **postgresql-14** | TBD | TBD | TBD | High | 68 | Medium — meaningful integration/hardening value | PostgreSQL 14 object-relational database |
| 45 | **samba** | TBD | TBD | TBD | High | 68 | Medium — meaningful integration/hardening value | SMB/CIFS file/print/AD server |
| 46 | **sssd** | TBD | TBD | TBD | High | 68 | Medium — meaningful integration/hardening value | System Security Services Daemon (LDAP/Kerberos/AD) |
| 47 | **bouncycastle** | TBD | TBD | TBD | High | 65 | Medium — meaningful integration/hardening value | Bouncy Castle Java cryptography APIs |
| 48 | **guava-libraries** | TBD | TBD | TBD | High | 65 | Medium — meaningful integration/hardening value | Google Guava core Java libraries |
| 49 | **jackson-annotations** | TBD | TBD | TBD | High | 65 | Medium — meaningful integration/hardening value | Jackson JSON annotations for Java |
| 50 | **jackson-core** | TBD | TBD | TBD | High | 65 | Medium — meaningful integration/hardening value | Jackson JSON core streaming parser/generator |
| 51 | **jackson-databind** | TBD | TBD | TBD | High | 65 | Medium — meaningful integration/hardening value | Jackson JSON data-binding (POJO to/from JSON) |
| 52 | **maven** | 2004 | Apache Software Foundation | 22 | High | 65 | Medium — meaningful integration/hardening value | — |
| 53 | **abseil** | TBD | TBD | TBD | High | 63 | Medium — meaningful integration/hardening value | Google Abseil C++ common libraries |
| 54 | **argon2** | TBD | TBD | TBD | High | 63 | Medium — meaningful integration/hardening value | Argon2 password hashing library |
| 55 | **boost-defaults** | TBD | TBD | TBD | High | 63 | Medium — meaningful integration/hardening value | Default Boost C++ library version selection |
| 56 | **c-ares** | TBD | TBD | TBD | High | 63 | Medium — meaningful integration/hardening value | Asynchronous DNS resolver C library |
| 57 | **double-conversion** | TBD | TBD | TBD | High | 63 | Medium — meaningful integration/hardening value | Binary-decimal and decimal-binary conversion library |
| 58 | **eigen3** | TBD | TBD | TBD | High | 63 | Medium — meaningful integration/hardening value | Eigen C++ template library for linear algebra |
| 59 | **fftw3** | TBD | TBD | TBD | High | 63 | Medium — meaningful integration/hardening value | FFTW — Fastest Fourier Transform in the West (C library) |
| 60 | **fmtlib** | TBD | TBD | TBD | High | 63 | Medium — meaningful integration/hardening value | fmt — modern C++ formatting library |
| 61 | **gsl** | TBD | TBD | TBD | High | 63 | Medium — meaningful integration/hardening value | GNU Scientific Library (numerical computing) |
| 62 | **imagemagick** | TBD | TBD | TBD | High | 62 | Medium — meaningful integration/hardening value | Image manipulation suite (convert, identify, mogrify) |
| 63 | **inkscape** | TBD | TBD | TBD | High | 62 | Medium — meaningful integration/hardening value | Professional vector graphics editor |
| 64 | **sphinx** | TBD | TBD | TBD | High | 62 | Medium — meaningful integration/hardening value | Sphinx documentation generator for Python projects |
| 65 | **texinfo** | TBD | TBD | TBD | High | 62 | Medium — meaningful integration/hardening value | GNU documentation system (info format) |
| 66 | **texlive-bin** | TBD | TBD | TBD | High | 62 | Medium — meaningful integration/hardening value | TeX Live binary executables |
| 67 | **alsa-lib** | TBD | TBD | TBD | High | 60 | Medium — meaningful integration/hardening value | ALSA sound library (libasound) |
| 68 | **alsa-plugins** | TBD | TBD | TBD | High | 60 | Medium — meaningful integration/hardening value | ALSA plugin collection (PulseAudio, Jack, etc.) |
| 69 | **aom** | TBD | TBD | TBD | High | 60 | Medium — meaningful integration/hardening value | Alliance for Open Media AV1 codec library |
| 70 | **dav1d** | TBD | TBD | TBD | High | 60 | Medium — meaningful integration/hardening value | Fast AV1 video decoder (VideoLAN) |
| 71 | **fribidi** | TBD | TBD | TBD | High | 60 | Medium — meaningful integration/hardening value | GNU FriBidi — Unicode bidirectional text library |
| 72 | **libass** | TBD | TBD | TBD | High | 60 | Medium — meaningful integration/hardening value | — |
| 73 | **asm** | TBD | TBD | TBD | Moderate | 58 | Medium — meaningful integration/hardening value | Java bytecode manipulation framework (ASM) |
| 74 | **byte-buddy** | TBD | TBD | TBD | Moderate | 58 | Medium — meaningful integration/hardening value | Java bytecode generation and manipulation library |
| 75 | **cglib** | TBD | TBD | TBD | Moderate | 58 | Medium — meaningful integration/hardening value | Code Generation Library for Java (bytecode proxies) |
| 76 | **ecj** | TBD | TBD | TBD | Moderate | 58 | Medium — meaningful integration/hardening value | Eclipse Compiler for Java (standalone) |
| 77 | **guice** | TBD | TBD | TBD | Moderate | 58 | Medium — meaningful integration/hardening value | Google Guice lightweight dependency injection |
| 78 | **icu4j** | TBD | TBD | TBD | Moderate | 58 | Medium — meaningful integration/hardening value | International Components for Unicode for Java |
| 79 | **junit** | TBD | TBD | TBD | Moderate | 58 | Medium — meaningful integration/hardening value | — |
| 80 | **junit4** | TBD | TBD | TBD | Moderate | 58 | Medium — meaningful integration/hardening value | — |
| 81 | **junit5** | TBD | TBD | TBD | Moderate | 58 | Medium — meaningful integration/hardening value | — |
| 82 | **mockito** | TBD | TBD | TBD | Moderate | 58 | Medium — meaningful integration/hardening value | — |
| 83 | **dlm** | TBD | TBD | TBD | Moderate | 55 | Medium — meaningful integration/hardening value | Distributed Lock Manager for clustered storage |
| 84 | **httpcomponents-asyncclient** | TBD | TBD | TBD | Moderate | 55 | Medium — meaningful integration/hardening value | Apache HttpAsyncClient for Java |
| 85 | **httpcomponents-client** | TBD | TBD | TBD | Moderate | 55 | Medium — meaningful integration/hardening value | Apache HttpClient 4 for Java |
| 86 | **httpcomponents-core** | TBD | TBD | TBD | Moderate | 55 | Medium — meaningful integration/hardening value | Apache HttpCore for Java |
| 87 | **intel-gmmlib** | TBD | TBD | TBD | Moderate | 55 | Medium — meaningful integration/hardening value | Intel Graphics Memory Management Library |
| 88 | **intel-gpu-tools** | TBD | TBD | TBD | Moderate | 55 | Medium — meaningful integration/hardening value | Intel GPU debugging and testing tools |
| 89 | **intel-media-driver** | TBD | TBD | TBD | Moderate | 55 | Medium — meaningful integration/hardening value | Intel Media Driver for VAAPI (hardware video) |
| 90 | **intel-processor-trace** | TBD | TBD | TBD | Moderate | 55 | Medium — meaningful integration/hardening value | Intel Processor Trace decoding library |
| 91 | **intel-vaapi-driver** | TBD | TBD | TBD | Moderate | 55 | Medium — meaningful integration/hardening value | Intel VA-API user-mode driver (video acceleration) |
| 92 | **jackson-dataformat-smile** | TBD | TBD | TBD | Moderate | 55 | Medium — meaningful integration/hardening value | Jackson Smile binary JSON format |
| 93 | **jackson-dataformat-xml** | TBD | TBD | TBD | Moderate | 55 | Medium — meaningful integration/hardening value | Jackson XML data format module |
| 94 | **jackson-dataformat-yaml** | TBD | TBD | TBD | Moderate | 55 | Medium — meaningful integration/hardening value | Jackson YAML data format module |
| 95 | **jackson-module-jaxb-annotations** | TBD | TBD | TBD | Moderate | 55 | Medium — meaningful integration/hardening value | Jackson module for JAXB annotations |
| 96 | **ldb** | TBD | TBD | TBD | Moderate | 55 | Medium — meaningful integration/hardening value | — |
| 97 | **multipath-tools** | TBD | TBD | TBD | Moderate | 55 | Medium — meaningful integration/hardening value | — |
| 98 | **pacemaker** | TBD | TBD | TBD | Moderate | 55 | Medium — meaningful integration/hardening value | — |
| 99 | **commons-beanutils** | TBD | TBD | TBD | Moderate | 50 | Medium — meaningful integration/hardening value | Apache Commons BeanUtils (Java reflection utilities) |
| 100 | **commons-configuration** | TBD | TBD | TBD | Moderate | 50 | Medium — meaningful integration/hardening value | Apache Commons Configuration (config file handling) |
| 101 | **commons-csv** | TBD | TBD | TBD | Moderate | 50 | Medium — meaningful integration/hardening value | Apache Commons CSV parser for Java |
| 102 | **commons-exec** | TBD | TBD | TBD | Moderate | 50 | Medium — meaningful integration/hardening value | Apache Commons Exec (external process execution) |
| 103 | **commons-httpclient** | TBD | TBD | TBD | Moderate | 50 | Medium — meaningful integration/hardening value | Apache Commons HttpClient (legacy HTTP library) |
| 104 | **commons-io** | TBD | TBD | TBD | Moderate | 50 | Medium — meaningful integration/hardening value | Apache Commons IO utilities for Java |
| 105 | **commons-jci** | TBD | TBD | TBD | Moderate | 50 | Medium — meaningful integration/hardening value | Apache Commons Java Compiler Interface |
| 106 | **commons-math3** | TBD | TBD | TBD | Moderate | 50 | Medium — meaningful integration/hardening value | Apache Commons Math library (statistics, linear algebra) |
| 107 | **commons-parent** | TBD | TBD | TBD | Moderate | 50 | Medium — meaningful integration/hardening value | Apache Commons parent POM |
| 108 | **commons-pool** | TBD | TBD | TBD | Moderate | 50 | Medium — meaningful integration/hardening value | Apache Commons Pool (object pooling for Java) |
| 109 | **commons-pool2** | TBD | TBD | TBD | Moderate | 50 | Medium — meaningful integration/hardening value | Apache Commons Pool 2 (object pooling) |
| 110 | **commons-vfs** | TBD | TBD | TBD | Moderate | 50 | Medium — meaningful integration/hardening value | Apache Commons Virtual File System for Java |
| 111 | **eclipse-emf** | TBD | TBD | TBD | Moderate | 45 | Medium — meaningful integration/hardening value | Eclipse Modeling Framework |
| 112 | **eclipse-jdt-core** | TBD | TBD | TBD | Moderate | 45 | Medium — meaningful integration/hardening value | Eclipse Java Development Tools core |
| 113 | **eclipse-jdt-debug** | TBD | TBD | TBD | Moderate | 45 | Medium — meaningful integration/hardening value | Eclipse JDT debugger |
| 114 | **eclipse-jdt-ui** | TBD | TBD | TBD | Moderate | 45 | Medium — meaningful integration/hardening value | Eclipse JDT user interface |
| 115 | **eclipse-platform-debug** | TBD | TBD | TBD | Moderate | 45 | Medium — meaningful integration/hardening value | Eclipse platform debug framework |
| 116 | **eclipse-platform-resources** | TBD | TBD | TBD | Moderate | 45 | Medium — meaningful integration/hardening value | Eclipse platform resource management |
| 117 | **eclipse-platform-runtime** | TBD | TBD | TBD | Moderate | 45 | Medium — meaningful integration/hardening value | Eclipse platform runtime |
| 118 | **eclipse-platform-team** | TBD | TBD | TBD | Moderate | 45 | Medium — meaningful integration/hardening value | Eclipse platform team/version control |
| 119 | **eclipse-platform-text** | TBD | TBD | TBD | Moderate | 45 | Medium — meaningful integration/hardening value | Eclipse platform text editing framework |
| 120 | **eclipse-platform-ua** | TBD | TBD | TBD | Moderate | 45 | Medium — meaningful integration/hardening value | Eclipse platform user assistance |
| 121 | **eclipse-platform-ui** | TBD | TBD | TBD | Moderate | 45 | Medium — meaningful integration/hardening value | Eclipse platform UI framework |
| 122 | **equinox-bundles** | TBD | TBD | TBD | Moderate | 45 | Medium — meaningful integration/hardening value | Eclipse Equinox OSGi bundles |
| 123 | **equinox-framework** | TBD | TBD | TBD | Moderate | 45 | Medium — meaningful integration/hardening value | Eclipse Equinox OSGi framework implementation |
| 124 | **equinox-p2** | TBD | TBD | TBD | Moderate | 45 | Medium — meaningful integration/hardening value | Eclipse Equinox p2 provisioning system |
| 125 | **maven-antrun-plugin** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | Apache Maven antrun plugin |
| 126 | **maven-archiver** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | Apache Maven archiver component |
| 127 | **maven-artifact-transfer** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | Apache Maven artifact-transfer component |
| 128 | **maven-assembly-plugin** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | Apache Maven assembly plugin |
| 129 | **maven-bundle-plugin** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | Apache Maven bundle plugin |
| 130 | **maven-clean-plugin** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | Apache Maven clean plugin |
| 131 | **maven-common-artifact-filters** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | Apache Maven common-artifact-filters component |
| 132 | **maven-compiler-plugin** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | Apache Maven compiler plugin |
| 133 | **maven-dependency-analyzer** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | Apache Maven dependency-analyzer component |
| 134 | **maven-dependency-plugin** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | Apache Maven dependency plugin |
| 135 | **maven-dependency-tree** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | Apache Maven dependency-tree component |
| 136 | **maven-deploy-plugin** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | Apache Maven deploy plugin |
| 137 | **maven-doxia-tools** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | Apache Maven doxia-tools component |
| 138 | **maven-enforcer** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | Apache Maven enforcer component |
| 139 | **maven-file-management** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | Apache Maven file-management component |
| 140 | **maven-filtering** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | Apache Maven filtering component |
| 141 | **maven-install-plugin** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | Apache Maven install plugin |
| 142 | **maven-invoker** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | Apache Maven invoker component |
| 143 | **maven-invoker-plugin** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | Apache Maven invoker plugin |
| 144 | **maven-jar-plugin** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | Apache Maven jar plugin |
| 145 | **maven-javadoc-plugin** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | Apache Maven javadoc plugin |
| 146 | **maven-jaxb2-plugin** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | Apache Maven jaxb2 plugin |
| 147 | **maven-mapping** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | Apache Maven mapping component |
| 148 | **maven-parent** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | Apache Maven parent component |
| 149 | **maven-plugin-testing** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | Apache Maven plugin-testing component |
| 150 | **maven-plugin-tools** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | Apache Maven plugin-tools component |
| 151 | **maven-processor-plugin** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | Apache Maven processor plugin |
| 152 | **maven-reporting-api** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | Apache Maven reporting-api component |
| 153 | **maven-reporting-exec** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | Apache Maven reporting-exec component |
| 154 | **maven-reporting-impl** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | Apache Maven reporting-impl component |
| 155 | **maven-repository-builder** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | Apache Maven repository-builder component |
| 156 | **maven-resolver** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | Apache Maven resolver component |
| 157 | **maven-resources-plugin** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | Apache Maven resources plugin |
| 158 | **maven-scm** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | Apache Maven scm component |
| 159 | **maven-script-interpreter** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | Apache Maven script-interpreter component |
| 160 | **maven-shade-plugin** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | Apache Maven shade plugin |
| 161 | **maven-shared-incremental** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | Apache Maven shared-incremental component |
| 162 | **maven-shared-io** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | Apache Maven shared-io component |
| 163 | **maven-shared-utils** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | Apache Maven shared-utils component |
| 164 | **maven-site-plugin** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | Apache Maven site plugin |
| 165 | **maven-source-plugin** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | Apache Maven source plugin |
| 166 | **maven-war-plugin** | TBD | TBD | TBD | Moderate | 42 | Low — integrate as-is; improve only with cause | Apache Maven war plugin |
| 167 | **felix-bundlerepository** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | Apache Felix OSGi Bundle Repository |
| 168 | **felix-framework** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | Apache Felix OSGi framework implementation |
| 169 | **felix-gogo-runtime** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | Apache Felix Gogo shell runtime |
| 170 | **felix-osgi-obr** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | Apache Felix OSGi OBR service |
| 171 | **felix-resolver** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | Apache Felix OSGi resolver |
| 172 | **felix-shell** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | Apache Felix shell service |
| 173 | **felix-utils** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | Apache Felix utility classes |
| 174 | **libaio** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 175 | **libao** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 176 | **libassuan** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 177 | **libasyncns** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 178 | **libatasmart** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 179 | **libatomic-ops** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 180 | **libavc1394** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 181 | **libbluray** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 182 | **libbpf** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 183 | **libbs2b** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 184 | **libbsd** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 185 | **libbytesize** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 186 | **libcapi20-3** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 187 | **libcbor** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 188 | **libcddb** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 189 | **libcdio** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 190 | **libcdio-paranoia** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 191 | **libcdr** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 192 | **libconfig** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 193 | **libconfuse** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 194 | **libcue** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 195 | **libdaemon** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 196 | **libdatrie** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 197 | **libdc1394** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 198 | **libdca** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 199 | **libde265** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 200 | **libdebian-installer** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 201 | **libdecor-0** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 202 | **libdeflate** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 203 | **libdumbtts** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 204 | **libdv** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 205 | **libdvbpsi** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 206 | **libdvdnav** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 207 | **libdvdread** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 208 | **libebml** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 209 | **libedit** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 210 | **libexif** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | EXIF metadata parsing library |
| 211 | **libexttextcat** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 212 | **libfcgi** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 213 | **libfido2** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 214 | **libfontenc** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 215 | **libftdi1** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 216 | **libgc** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 217 | **libgd2** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 218 | **libgig** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 219 | **libglu** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 220 | **libglvnd** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 221 | **libgphoto2** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 222 | **libgsm** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 223 | **libheif** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 224 | **libiberty** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 225 | **libice** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 226 | **libid3tag** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 227 | **libidn** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 228 | **libidn2** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 229 | **libiec61883** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 230 | **libieee1284** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 231 | **libimobiledevice** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 232 | **libinih** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 233 | **libinstpatch** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 234 | **libiptcdata** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 235 | **libjpeg-turbo** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 236 | **libjpeg8-empty** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 237 | **libjs-jquery-hotkeys** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 238 | **libjs-jquery-isonscreen** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 239 | **libjs-jquery-timeago** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 240 | **libjs-qunit** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 241 | **libjs-requirejs-text** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 242 | **libjsoncpp** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 243 | **libkate** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 244 | **libkdegames** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 245 | **libkeduvocdocument** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 246 | **libksba** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 247 | **libldac** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 248 | **liblo** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 249 | **liblockfile** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 250 | **liblqr** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 251 | **libmad** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 252 | **libmatroska** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 253 | **libmaxminddb** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 254 | **libmd** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 255 | **libmediainfo** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 256 | **libmicrohttpd** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 257 | **libmms** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 258 | **libmnl** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 259 | **libmodplug** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 260 | **libmpc** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 261 | **libmtp** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 262 | **libndp** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 263 | **libnetfilter-conntrack** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 264 | **libnfnetlink** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 265 | **libnfs** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 266 | **libnftnl** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 267 | **libnsl** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 268 | **libnss-nis** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 269 | **libnss-nisplus** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 270 | **libphonenumber** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | — |
| 271 | **geronimo-annotation-1.3-spec** | TBD | TBD | TBD | Moderate | 38 | Low — integrate as-is; improve only with cause | — |
| 272 | **geronimo-commonj-spec** | TBD | TBD | TBD | Moderate | 38 | Low — integrate as-is; improve only with cause | — |
| 273 | **geronimo-concurrent-1.0-spec** | TBD | TBD | TBD | Moderate | 38 | Low — integrate as-is; improve only with cause | — |
| 274 | **geronimo-ejb-3.2-spec** | TBD | TBD | TBD | Moderate | 38 | Low — integrate as-is; improve only with cause | — |
| 275 | **geronimo-interceptor-3.0-spec** | TBD | TBD | TBD | Moderate | 38 | Low — integrate as-is; improve only with cause | — |
| 276 | **geronimo-j2ee-connector-1.5-spec** | TBD | TBD | TBD | Moderate | 38 | Low — integrate as-is; improve only with cause | — |
| 277 | **geronimo-jacc-1.1-spec** | TBD | TBD | TBD | Moderate | 38 | Low — integrate as-is; improve only with cause | — |
| 278 | **geronimo-jcache-1.0-spec** | TBD | TBD | TBD | Moderate | 38 | Low — integrate as-is; improve only with cause | — |
| 279 | **geronimo-jms-1.1-spec** | TBD | TBD | TBD | Moderate | 38 | Low — integrate as-is; improve only with cause | — |
| 280 | **geronimo-jpa-2.0-spec** | TBD | TBD | TBD | Moderate | 38 | Low — integrate as-is; improve only with cause | — |
| 281 | **geronimo-jta-1.2-spec** | TBD | TBD | TBD | Moderate | 38 | Low — integrate as-is; improve only with cause | — |
| 282 | **geronimo-osgi-support** | TBD | TBD | TBD | Moderate | 38 | Low — integrate as-is; improve only with cause | — |
| 283 | **geronimo-validation-1.0-spec** | TBD | TBD | TBD | Moderate | 38 | Low — integrate as-is; improve only with cause | — |
| 284 | **geronimo-validation-1.1-spec** | TBD | TBD | TBD | Moderate | 38 | Low — integrate as-is; improve only with cause | — |
| 285 | **jboss-bridger** | TBD | TBD | TBD | Moderate | 38 | Low — integrate as-is; improve only with cause | — |
| 286 | **jboss-jdeparser2** | TBD | TBD | TBD | Moderate | 38 | Low — integrate as-is; improve only with cause | — |
| 287 | **jboss-logging** | TBD | TBD | TBD | Moderate | 38 | Low — integrate as-is; improve only with cause | — |
| 288 | **jboss-logging-tools** | TBD | TBD | TBD | Moderate | 38 | Low — integrate as-is; improve only with cause | — |
| 289 | **jboss-logmanager** | TBD | TBD | TBD | Moderate | 38 | Low — integrate as-is; improve only with cause | — |
| 290 | **jboss-modules** | TBD | TBD | TBD | Moderate | 38 | Low — integrate as-is; improve only with cause | — |
| 291 | **jnr-constants** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 292 | **jnr-enxio** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 293 | **jnr-ffi** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 294 | **jnr-netdb** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 295 | **jnr-posix** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 296 | **jnr-unixsocket** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 297 | **jnr-x86asm** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 298 | **libandroid-json-org-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 299 | **libaopalliance-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 300 | **libbsf-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 301 | **libbtm-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 302 | **libcommons-cli-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 303 | **libcommons-codec-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 304 | **libcommons-collections3-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 305 | **libcommons-collections4-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 306 | **libcommons-compress-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 307 | **libcommons-dbcp-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 308 | **libcommons-digester-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 309 | **libcommons-discovery-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 310 | **libcommons-fileupload-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 311 | **libcommons-jexl2-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 312 | **libcommons-jxpath-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 313 | **libcommons-lang-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 314 | **libcommons-lang3-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 315 | **libcommons-logging-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 316 | **libcommons-net-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 317 | **libcommons-validator-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 318 | **libfreemarker-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 319 | **libgoogle-gson-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 320 | **libgpars-groovy-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 321 | **libhamcrest-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 322 | **libhibernate-commons-annotations-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 323 | **libhibernate-validator-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 324 | **libhibernate-validator4-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 325 | **libhibernate3-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 326 | **libitext-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 327 | **libitext1-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 328 | **libjackson-json-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 329 | **libjamon-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 330 | **libjavaewah-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 331 | **libjaxen-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 332 | **libjaxp1.3-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 333 | **libjcip-annotations-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 334 | **libjdepend-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 335 | **libjdo-api-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 336 | **libjdom1-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 337 | **libjdom2-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 338 | **libjettison-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 339 | **libjgroups-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 340 | **libjibx1.2-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 341 | **libjna-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 342 | **libjoda-time-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 343 | **libjsonp-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 344 | **libjsr166y-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 345 | **libjsr305-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 346 | **libjtype-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 347 | **libjuniversalchardet-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 348 | **libkryo-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 349 | **libminlog-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 350 | **libnative-platform-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 351 | **libpdfbox-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 352 | **libpdfbox2-java** | TBD | TBD | TBD | Moderate | 35 | Low — integrate as-is; improve only with cause | — |
| 353 | **a52dec** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | ATSC A/52 (AC-3) audio decoder library |
| 354 | **aalib** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | ASCII art graphics library |
| 355 | **akonadi-calendar** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Akonadi calendar integration library (KDE PIM) |
| 356 | **akonadi-contacts** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Akonadi contacts integration library (KDE PIM) |
| 357 | **akonadi-mime** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Akonadi MIME handling library (KDE PIM) |
| 358 | **akonadi-notes** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Akonadi notes handling library (KDE PIM) |
| 359 | **animal-sniffer** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Java API compatibility checker |
| 360 | **ann** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Approximate Nearest Neighbor searching library |
| 361 | **antlr-maven-plugin** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | ANTLR Maven integration plugin |
| 362 | **apache-log4j1.2** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Apache Log4j 1.2 Java logging framework (legacy) |
| 363 | **apache-log4j2** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Apache Log4j 2 Java logging framework |
| 364 | **apache-pom** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Apache Software Foundation parent POM |
| 365 | **apiguardian** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | API Guardian annotation library for Java |
| 366 | **apr** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Apache Portable Runtime library |
| 367 | **apr-util** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Apache Portable Runtime utility library |
| 368 | **args4j** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Java command-line argument parser |
| 369 | **aribb24** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | ARIB B24 character set decoding library |
| 370 | **asmtools** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | OpenJDK class file assembler/disassembler tools |
| 371 | **assertj-core** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | AssertJ fluent assertions library for Java |
| 372 | **at-spi2-atk** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | AT-SPI2 ATK bridge (accessibility) |
| 373 | **atinject-jsr330** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | JSR-330 Dependency Injection for Java |
| 374 | **atkmm1.6** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | C++ bindings for ATK accessibility toolkit |
| 375 | **avalon-framework** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Apache Avalon component framework |
| 376 | **axis** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Apache Axis SOAP web services engine |
| 377 | **babeltrace** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Trace read/write library (CTF format, LTTng) |
| 378 | **backbone** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Backbone.js MVC JavaScript framework |
| 379 | **batik** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Apache Batik SVG toolkit for Java |
| 380 | **bcel** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Byte Code Engineering Library for Java |
| 381 | **bindex** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | OSGi Bundle Index tool |
| 382 | **bluez-qt** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Qt wrapper for BlueZ Bluetooth stack |
| 383 | **build-helper-maven-plugin** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Maven Build Helper plugin (extra build lifecycle) |
| 384 | **c3p0** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | JDBC connection pooling library for Java |
| 385 | **cairomm** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | C++ bindings for Cairo graphics library |
| 386 | **carrotsearch-hppc** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | High Performance Primitive Collections for Java |
| 387 | **carrotsearch-randomizedtesting** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Randomized testing framework for Java |
| 388 | **castor** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Castor XML/Java data binding framework |
| 389 | **cdi-api** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Contexts and Dependency Injection API for Java |
| 390 | **cdparanoia** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Audio CD reading utility with error correction |
| 391 | **cecil** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Mono.Cecil — .NET assembly inspection library |
| 392 | **chromaprint** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Audio fingerprinting library (AcoustID) |
| 393 | **classmate** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Java type resolution library (generics/annotations) |
| 394 | **classycle** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Java class dependency analyzer |
| 395 | **clutter-gtk** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | GTK+ integration library for Clutter |
| 396 | **clutter-imcontext** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Input method context for Clutter |
| 397 | **codemirror-js** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | CodeMirror — in-browser code editor (JavaScript) |
| 398 | **codenarc** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | CodeNarc Groovy source code analyzer |
| 399 | **compress-lzf** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | LZF compression codec for Java |
| 400 | **conversant-disruptor** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Conversant Disruptor — lock-free Java ring buffer |
| 401 | **cppunit** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | C++ unit testing framework |
| 402 | **cross-toolchain-base** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Cross-compilation toolchain base packages |
| 403 | **cross-toolchain-base-ports** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Cross-compilation toolchain for architecture ports |
| 404 | **cunit** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | C unit testing framework (CUnit) |
| 405 | **curvesapi** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Java curves and math API |
| 406 | **d3** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | D3.js data-driven documents visualization library |
| 407 | **d3-format** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | D3 number formatting module |
| 408 | **dbus-c++** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | C++ bindings for D-Bus IPC |
| 409 | **dbus-glib** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | GLib bindings for D-Bus |
| 410 | **dd-plist** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Java library for Apple property list parsing |
| 411 | **dh-make-perl** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Create Debian packages from Perl modules |
| 412 | **ding-libs** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | SSSD utility libraries (INI, path, ref_array) |
| 413 | **disruptor** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | LMAX Disruptor — high-performance inter-thread messaging |
| 414 | **djvulibre** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | DjVu document format library and tools |
| 415 | **dnprogs** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | DECnet protocol utilities |
| 416 | **dom4j** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | XML framework for Java (DOM, SAX, XPath) |
| 417 | **dotconf** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Simple C configuration file parser |
| 418 | **doxia** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Apache Doxia content generation framework |
| 419 | **doxia-sitetools** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Apache Doxia site generation tools |
| 420 | **dropwizard-metrics** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Dropwizard Metrics — JVM application metrics library |
| 421 | **dtd-parser** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | SAX-based DTD parser for Java |
| 422 | **easymock** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | EasyMock — Java mock object framework |
| 423 | **eclipselink** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | EclipseLink JPA/ORM implementation |
| 424 | **eclipselink-jpa-2.1-spec** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | JPA 2.1 specification (EclipseLink) |
| 425 | **ehcache** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Ehcache — Java caching library |
| 426 | **el-api** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Expression Language API for Java (JSP/JSF) |
| 427 | **excalibur-logger** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Avalon Excalibur logging components |
| 428 | **excalibur-logkit** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Avalon Excalibur LogKit |
| 429 | **exec-maven-plugin** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Maven Exec plugin (execute programs from Maven) |
| 430 | **exempi** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | XMP metadata library (Exempi) |
| 431 | **explorercanvas** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Canvas element support for older IE browsers |
| 432 | **fastinfoset** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Fast Infoset binary XML encoding for Java |
| 433 | **faudio** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | FAudio — XAudio2 reimplementation for Wine |
| 434 | **fest-assert** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | FEST Assert — fluent assertions for Java (legacy) |
| 435 | **fest-test** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | FEST test support utilities |
| 436 | **fest-util** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | FEST utility classes |
| 437 | **ffms2** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | FFmpegSource — frame-accurate video/audio indexer |
| 438 | **findbugs** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | FindBugs static analysis tool for Java |
| 439 | **flot** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Flot — JavaScript plotting library for jQuery |
| 440 | **game-music-emu** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Video game music file emulation library |
| 441 | **ganymed-ssh2** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Ganymed SSH-2 Java implementation |
| 442 | **gcc-10-cross** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | GCC 10 cross-compiler packages |
| 443 | **gdbm** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | GNU dbm database library |
| 444 | **gdk-pixbuf-xlib** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | GDK-Pixbuf Xlib integration (legacy) |
| 445 | **giflib** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | GIF image format library |
| 446 | **glibmm2.4** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | C++ bindings for GLib |
| 447 | **glm** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | OpenGL Mathematics C++ header-only library |
| 448 | **gmetrics** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | GMetrics Groovy source code metrics |
| 449 | **gpac** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | GPAC multimedia framework (MP4Box, DASH) |
| 450 | **gpgme1.0** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | GnuPG Made Easy — high-level crypto API |
| 451 | **gpm** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | General Purpose Mouse daemon for Linux consoles |
| 452 | **graphite2** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | SIL Graphite smart font rendering engine |
| 453 | **gtkmm2.4** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | C++ bindings for GTK+ 2.0 |
| 454 | **gtkmm3.0** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | C++ bindings for GTK+ 3.0 |
| 455 | **gts** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | GNU Triangulated Surface library |
| 456 | **h2database** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | H2 Java SQL database engine |
| 457 | **hawtjni** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | HawtJNI — JNI code generator |
| 458 | **hesiod** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Hesiod name service library (DNS-based) |
| 459 | **hessian** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Hessian binary web service protocol |
| 460 | **hikaricp** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | HikariCP — high-performance JDBC connection pool |
| 461 | **hsqldb** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | HyperSQL Java database engine |
| 462 | **hsqldb1.8.0** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | HyperSQL database version 1.8.0 (legacy) |
| 463 | **httpunit** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | HttpUnit — web application testing framework |
| 464 | **hwloc** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Hardware Locality — portable abstraction of hardware topology |
| 465 | **hyphen** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Hyphenation library (used by LibreOffice) |
| 466 | **hyphen-indic** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Hyphenation patterns for Indic languages |
| 467 | **hyphen-ru** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Russian hyphenation patterns |
| 468 | **ibus-table** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | IBus table-based input method engine |
| 469 | **ibus-table-chinese** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | IBus table-based Chinese input methods |
| 470 | **icc-profiles-free** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Free ICC color profiles |
| 471 | **icon-naming-utils** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Icon naming specification utility scripts |
| 472 | **icoutils** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Extract/create Windows icon/cursor files |
| 473 | **ieee-data** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | IEEE OUI and IAB assignment data |
| 474 | **ijs** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | IJS raster image transport protocol library |
| 475 | **im-config** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Input method configuration framework |
| 476 | **imlib2** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Image loading and rendering library |
| 477 | **indent** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | GNU indent — C source code reformatter |
| 478 | **inetutils** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | GNU network utilities (ftp, telnet, ping, etc.) |
| 479 | **iniparser** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | INI file parsing library for C |
| 480 | **intellij-annotations** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | JetBrains IntelliJ IDEA annotations library |
| 481 | **intltool** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Internationalization tools for XML/desktop files |
| 482 | **intltool-debian** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Debian-specific intltool integration |
| 483 | **inxi** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Full-featured system information script |
| 484 | **io-stringy** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Perl IO::Stringy modules (in-memory I/O) |
| 485 | **ionit** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | IO initialization daemon |
| 486 | **ipxe-qemu-256k-compat** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | iPXE network boot ROMs for QEMU (256K compat) |
| 487 | **ipython** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Enhanced interactive Python shell |
| 488 | **ipywidgets** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Interactive widgets for Jupyter notebooks |
| 489 | **iso-codes** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | ISO language/country/currency code lists |
| 490 | **isorelax** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | ISO RELAX verifier interface for Java |
| 491 | **isort** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Python import sorting utility |
| 492 | **ispell** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Interactive spell checking program |
| 493 | **istack-commons** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | iStack Commons utility library for Java |
| 494 | **itstool** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | ITS-based XML translation tool |
| 495 | **ivy** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Apache Ivy dependency manager for Java |
| 496 | **ivy-debian-helper** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Debian helper for Apache Ivy builds |
| 497 | **ivyplusplus** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | IvyPlusPlus build utility for Ivy projects |
| 498 | **jack-audio-connection-kit** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | JACK low-latency audio server |
| 499 | **jackd2** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | JACK Audio Connection Kit (version 2, D-Bus) |
| 500 | **jackrabbit** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Apache Jackrabbit JCR content repository |
| 501 | **janino** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Janino — lightweight Java compiler |
| 502 | **jansi** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Jansi — ANSI escape sequence support for Java |
| 503 | **jansi-native** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Jansi native terminal support library |
| 504 | **jansson** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | C library for encoding/decoding JSON |
| 505 | **jargs** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Java command-line option parsing library |
| 506 | **jarjar** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Jar Jar Links — Java package shader |
| 507 | **jarjar-maven-plugin** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Jar Jar Links Maven plugin |
| 508 | **jatl** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Java Anti-Template Language (HTML generation) |
| 509 | **java-comment-preprocessor** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Java source preprocessor (conditional compilation) |
| 510 | **java-wrappers** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Shell wrappers for Java programs |
| 511 | **javabeans-activation-framework** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | JavaBeans Activation Framework (JAF) |
| 512 | **javacc** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Java Compiler Compiler (parser generator) |
| 513 | **javacc-maven-plugin** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | JavaCC Maven plugin |
| 514 | **javacc4** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | JavaCC version 4 parser generator |
| 515 | **javahelp2** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | JavaHelp 2 online help system |
| 516 | **javamail** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | JavaMail API implementation |
| 517 | **javascript-common** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Common infrastructure for JavaScript packages |
| 518 | **javassist** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Java bytecode manipulation library |
| 519 | **javatools** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Java package helper tools for Debian |
| 520 | **jaxb** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Jakarta XML Binding (JAXB) implementation |
| 521 | **jaxb-api** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | JAXB API for Java XML binding |
| 522 | **jaxrpc-api** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | JAX-RPC API for Java web services |
| 523 | **jaxrs-api** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | JAX-RS API for Java RESTful web services |
| 524 | **jaxws-api** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | JAX-WS API for Java SOAP web services |
| 525 | **jayway-jsonpath** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Jayway JsonPath — JSON query library for Java |
| 526 | **jbig2dec** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | JBIG2 image decoder library |
| 527 | **jbigkit** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | JBIG1 lossless image compression library |
| 528 | **jcifs** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 529 | **jcommander** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 530 | **jcsp** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 531 | **jctools** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 532 | **jdependency** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 533 | **jdupes** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 534 | **jeepney** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 535 | **jemalloc** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 536 | **jengelman-shadow** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 537 | **jeromq** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 538 | **jetty9** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 539 | **jexcelapi** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 540 | **jffi** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 541 | **jflex** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 542 | **jformatstring** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 543 | **jgit** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 544 | **jlex** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 545 | **jline** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 546 | **jline2** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 547 | **jline3** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 548 | **jmock** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 549 | **jmock2** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 550 | **joda-convert** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 551 | **joptsimple** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 552 | **jq** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 553 | **jquery-goodies** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 554 | **jquery-tablesorter** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 555 | **jquery-throttle-debounce** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 556 | **jquery-typeahead.js** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 557 | **jqueryui** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 558 | **jsch** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 559 | **jsch-agent-proxy** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 560 | **json-c** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 561 | **json-simple** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 562 | **json-smart** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 563 | **jsoup** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 564 | **jsp-api** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 565 | **jtb** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 566 | **jtharness** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 567 | **jtidy** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 568 | **jtreg6** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 569 | **jts** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 570 | **junixsocket** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 571 | **jupyter-core** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 572 | **jupyter-notebook** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 573 | **jws-api** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 574 | **jxrlib** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 575 | **jython** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 576 | **jzlib** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 577 | **k3b** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 578 | **kernel-wedge** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 579 | **ladspa-sdk** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 580 | **lame** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 581 | **language-selector** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 582 | **laptop-detect** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 583 | **latex2html** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 584 | **latexmk** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 585 | **lcms2** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 586 | **lcov** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 587 | **ldp-docbook-stylesheets** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 588 | **leptonlib** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 589 | **libkf5calendarsupport** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | KDE Frameworks 5 library (calendarsupport) |
| 590 | **libkf5eventviews** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | KDE Frameworks 5 library (eventviews) |
| 591 | **libkf5grantleetheme** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | KDE Frameworks 5 library (grantleetheme) |
| 592 | **libkf5gravatar** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | KDE Frameworks 5 library (gravatar) |
| 593 | **libkf5kipi** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | KDE Frameworks 5 library (kipi) |
| 594 | **libkf5kmahjongg** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | KDE Frameworks 5 library (kmahjongg) |
| 595 | **libkf5libkdepim** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | KDE Frameworks 5 library (libkdepim) |
| 596 | **libkf5libkleo** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | KDE Frameworks 5 library (libkleo) |
| 597 | **libkf5mailimporter** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | KDE Frameworks 5 library (mailimporter) |
| 598 | **libkf5pimcommon** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | KDE Frameworks 5 library (pimcommon) |
| 599 | **libkf5sane** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | KDE Frameworks 5 library (sane) |
| 600 | **lightcouch** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 601 | **lilv** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 602 | **linux-atm** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 603 | **lirc** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 604 | **lmdb** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Lightning Memory-Mapped Database (fast key-value store) |
| 605 | **logback** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 606 | **lombok** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 607 | **lombok-patcher** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 608 | **lowdown** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 609 | **lua5.1** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Lua 5.1 scripting language |
| 610 | **lua5.2** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Lua 5.2 scripting language |
| 611 | **lua5.3** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Lua 5.3 scripting language |
| 612 | **lua5.4** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Lua 5.4 scripting language |
| 613 | **luajit** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Just-In-Time compiler for Lua |
| 614 | **lucene4.10** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 615 | **mail-spf-perl** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 616 | **mariadb-connector-java** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 617 | **marisa** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 618 | **mate-desktop** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 619 | **md4c** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 620 | **mdds** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 621 | **mecab** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 622 | **mhash** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 623 | **mjpegtools** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 624 | **modello** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 625 | **modello-maven-plugin** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 626 | **modemmanager-qt** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 627 | **modernizr** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 628 | **mojarra** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 629 | **mojo-executor** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 630 | **mongo-java-driver** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 631 | **morfologik-stemming** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 632 | **mpdecimal** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 633 | **mpeg2dec** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 634 | **mpg123** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 635 | **msv** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 636 | **mtdev** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 637 | **multiverse-core** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 638 | **munge** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 639 | **munge-maven-plugin** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 640 | **mustache-java** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 641 | **mvel** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 642 | **mxml** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 643 | **nas** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 644 | **ndctl** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 645 | **nekohtml** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 646 | **net-luminis-build-plugin** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 647 | **net-snmp** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 648 | **netpbm-free** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 649 | **netty** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 650 | **netty-tcnative** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 651 | **newt** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Not Erik's Windowing Toolkit — text-mode UI library |
| 652 | **norm** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 653 | **npth** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 654 | **nss-mdns** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | NSS module for mDNS hostname resolution |
| 655 | **nss-wrapper** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 656 | **nuget** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 657 | **numactl** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | NUMA (Non-Uniform Memory Access) policy tools |
| 658 | **nunit** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 659 | **nv-codec-headers** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 660 | **openoffice.org-hyphenation** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 661 | **openoffice.org-hyphenation-pl** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 662 | **pkg-kde-tools** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 663 | **popper.js** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 664 | **prettify.js** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 665 | **psl.js** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 666 | **pupnp-1.8** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 667 | **python-jsbeautifier** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 668 | **requirejs** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 669 | **rickshaw** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 670 | **ruby-kramdown** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 671 | **sax.js** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 672 | **sisu-mojos** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 673 | **sizzle** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 674 | **subunit** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 675 | **syslinux** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 676 | **twitter-bootstrap4** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 677 | **uglifyjs** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 678 | **underscore** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 679 | **uw-imap** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 680 | **v4l-utils** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 681 | **xmlextras** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | — |
| 682 | **kajongg** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 683 | **kalarmcal** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 684 | **kapidox** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 685 | **kauth** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 686 | **kbookmarks** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 687 | **kcmutils** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 688 | **kcodecs** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 689 | **kcompletion** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 690 | **kconfig** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 691 | **kconfigwidgets** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 692 | **kcontacts** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 693 | **kcoreaddons** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 694 | **kdav** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 695 | **kde-dev-scripts** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 696 | **kdeedu-data** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 697 | **kdelibs4support** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 698 | **kdeplasma-addons** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 699 | **kdesignerplugin** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 700 | **kdnssd-kf5** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 701 | **kerberos-configs** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 702 | **keymapper** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 703 | **keystone** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 704 | **keyutils** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 705 | **kf5-messagelib** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 706 | **kholidays** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 707 | **khronos-api** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 708 | **ki18n** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 709 | **kidentitymanagement** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 710 | **kimap** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 711 | **kitemviews** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 712 | **kitinerary** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 713 | **kjobwidgets** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 714 | **kjsembed** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 715 | **klibc** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 716 | **kmediaplayer** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 717 | **kmime** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 718 | **knopflerfish-osgi** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 719 | **knotifications** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 720 | **knotifyconfig** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 721 | **kontactinterface** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 722 | **kparts** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 723 | **kpeople** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 724 | **kpimtextedit** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 725 | **kpty** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 726 | **kronosnet** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 727 | **ksyntax-highlighting** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 728 | **ktexteditor** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 729 | **ktextwidgets** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 730 | **ktnef** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 731 | **ktp-common-internals** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 732 | **kubuntu-settings** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 733 | **kubuntu-wallpapers** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 734 | **kubuntu-web-shortcuts** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 735 | **kunitconversion** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 736 | **kwayland** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 737 | **kwidgetsaddons** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 738 | **kwindowsystem** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 739 | **kxml2** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 740 | **kxmlrpcclient** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | — |
| 741 | **node-async** | TBD | TBD | TBD | Low | 25 | Low — integrate as-is; improve only with cause | — |
| 742 | **node-bootstrap-tour** | TBD | TBD | TBD | Low | 25 | Low — integrate as-is; improve only with cause | — |
| 743 | **node-debug** | TBD | TBD | TBD | Low | 25 | Low — integrate as-is; improve only with cause | — |
| 744 | **node-es6-promise** | TBD | TBD | TBD | Low | 25 | Low — integrate as-is; improve only with cause | — |
| 745 | **node-events** | TBD | TBD | TBD | Low | 25 | Low — integrate as-is; improve only with cause | — |
| 746 | **node-inherits** | TBD | TBD | TBD | Low | 25 | Low — integrate as-is; improve only with cause | — |
| 747 | **node-is-typedarray** | TBD | TBD | TBD | Low | 25 | Low — integrate as-is; improve only with cause | — |
| 748 | **node-jed** | TBD | TBD | TBD | Low | 25 | Low — integrate as-is; improve only with cause | — |
| 749 | **node-jest** | TBD | TBD | TBD | Low | 25 | Low — integrate as-is; improve only with cause | — |
| 750 | **node-jison** | TBD | TBD | TBD | Low | 25 | Low — integrate as-is; improve only with cause | — |
| 751 | **node-jquery** | TBD | TBD | TBD | Low | 25 | Low — integrate as-is; improve only with cause | — |
| 752 | **node-jquery-mousewheel** | TBD | TBD | TBD | Low | 25 | Low — integrate as-is; improve only with cause | — |
| 753 | **node-lunr** | TBD | TBD | TBD | Low | 25 | Low — integrate as-is; improve only with cause | — |
| 754 | **node-marked** | TBD | TBD | TBD | Low | 25 | Low — integrate as-is; improve only with cause | — |
| 755 | **node-moment** | TBD | TBD | TBD | Low | 25 | Low — integrate as-is; improve only with cause | — |
| 756 | **node-regenerate** | TBD | TBD | TBD | Low | 25 | Low — integrate as-is; improve only with cause | — |
| 757 | **node-source-map** | TBD | TBD | TBD | Low | 25 | Low — integrate as-is; improve only with cause | — |
| 758 | **node-sprintf-js** | TBD | TBD | TBD | Low | 25 | Low — integrate as-is; improve only with cause | — |
| 759 | **node-terser** | TBD | TBD | TBD | Low | 25 | Low — integrate as-is; improve only with cause | — |
| 760 | **node-text-encoding** | TBD | TBD | TBD | Low | 25 | Low — integrate as-is; improve only with cause | — |
| 761 | **node-typedarray-to-buffer** | TBD | TBD | TBD | Low | 25 | Low — integrate as-is; improve only with cause | — |
| 762 | **node-util** | TBD | TBD | TBD | Low | 25 | Low — integrate as-is; improve only with cause | — |
| 763 | **node-xterm** | TBD | TBD | TBD | Low | 25 | Low — integrate as-is; improve only with cause | — |
| 764 | **libalgorithm-c3-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 765 | **libalgorithm-diff-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 766 | **libalgorithm-merge-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 767 | **libaliased-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 768 | **libany-moose-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 769 | **libany-uri-escape-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 770 | **libapp-cmd-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 771 | **libapp-fatpacker-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 772 | **libarchive-cpio-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 773 | **libarchive-zip-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 774 | **libarray-intspan-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 775 | **libarray-unique-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 776 | **libarray-utils-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 777 | **libauthen-sasl-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 778 | **libb-cow-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 779 | **libb-hooks-endofscope-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 780 | **libb-hooks-op-check-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 781 | **libb-keywords-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 782 | **libboolean-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 783 | **libbsd-resource-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 784 | **libbusiness-isbn-data-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 785 | **libbusiness-isbn-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 786 | **libbusiness-ismn-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 787 | **libbusiness-issn-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 788 | **libcapture-tiny-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 789 | **libcarp-always-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 790 | **libcarp-assert-more-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 791 | **libcarp-assert-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 792 | **libcarp-clan-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 793 | **libcgi-fast-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 794 | **libcgi-pm-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 795 | **libchart-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 796 | **libclass-accessor-chained-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 797 | **libclass-accessor-grouped-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 798 | **libclass-accessor-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 799 | **libclass-c3-componentised-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 800 | **libclass-c3-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 801 | **libclass-data-inheritable-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 802 | **libclass-dbi-abstractsearch-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 803 | **libclass-dbi-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 804 | **libclass-insideout-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 805 | **libclass-inspector-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 806 | **libclass-isa-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 807 | **libclass-load-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 808 | **libclass-makemethods-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 809 | **libclass-method-modifiers-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 810 | **libclass-singleton-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 811 | **libclass-tiny-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 812 | **libclass-trigger-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 813 | **libclass-unload-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 814 | **libclass-xsaccessor-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 815 | **libclone-choose-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 816 | **libclone-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 817 | **libclone-pp-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 818 | **libcode-tidyall-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 819 | **libcode-tidyall-plugin-sortlines-naturally-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 820 | **libconfig-any-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 821 | **libconfig-auto-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 822 | **libconfig-autoconf-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 823 | **libconfig-general-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 824 | **libconfig-ini-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 825 | **libconfig-inifiles-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 826 | **libconfig-model-approx-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | Config::Model Perl module (approx) |
| 827 | **libconfig-model-backend-yaml-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | Config::Model Perl module (backend-yaml) |
| 828 | **libconfig-model-dpkg-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | Config::Model Perl module (dpkg) |
| 829 | **libconfig-model-itself-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | Config::Model Perl module (itself) |
| 830 | **libconfig-model-lcdproc-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | Config::Model Perl module (lcdproc) |
| 831 | **libconfig-model-openssh-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | Config::Model Perl module (openssh) |
| 832 | **libconfig-model-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | Config::Model Perl module (perl) |
| 833 | **libconfig-model-systemd-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | Config::Model Perl module (systemd) |
| 834 | **libconfig-model-tester-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | Config::Model Perl module (tester) |
| 835 | **libconfig-model-tkui-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | Config::Model Perl module (tkui) |
| 836 | **libconfig-tiny-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 837 | **libconst-fast-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 838 | **libcontext-preserve-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 839 | **libcontextual-return-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 840 | **libconvert-asn1-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 841 | **libconvert-binhex-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 842 | **libconvert-tnef-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 843 | **libcpan-changes-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 844 | **libcpan-meta-check-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 845 | **libcrypt-cbc-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 846 | **libcrypt-des-ede3-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 847 | **libcrypt-pbkdf2-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 848 | **libcrypt-rc4-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 849 | **libdata-compare-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 850 | **libdata-dpath-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 851 | **libdata-dump-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 852 | **libdata-dumper-concise-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 853 | **libdata-optlist-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 854 | **libdata-page-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 855 | **libdata-perl-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 856 | **libdata-printer-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 857 | **libdata-section-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 858 | **libdata-serializer-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 859 | **libdata-uniqid-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 860 | **libdata-validate-domain-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 861 | **libdata-validate-ip-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 862 | **libdata-validate-uri-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 863 | **libdata-visitor-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 864 | **libdate-calc-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 865 | **libdate-manip-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 866 | **libdatetime-calendar-julian-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 867 | **libdatetime-format-builder-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 868 | **libdatetime-format-iso8601-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 869 | **libdatetime-format-mail-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 870 | **libdatetime-format-mysql-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 871 | **libdatetime-format-pg-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 872 | **libdatetime-format-rfc3339-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 873 | **libdatetime-format-sqlite-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 874 | **libdatetime-format-strptime-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 875 | **libdatetime-locale-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 876 | **libdatetime-timezone-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 877 | **libdbd-csv-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 878 | **libdbd-sqlite3-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 879 | **libdbi-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 880 | **libdbix-class-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 881 | **libdbix-contextualfetch-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 882 | **libdebian-copyright-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 883 | **libdevel-argnames-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 884 | **libdevel-callchecker-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 885 | **libdevel-checkbin-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 886 | **libdevel-checklib-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 887 | **libdevel-cycle-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 888 | **libdevel-globaldestruction-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 889 | **libdevel-hide-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 890 | **libdevel-stacktrace-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 891 | **libdevel-symdump-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 892 | **libdigest-bubblebabble-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 893 | **libdigest-hmac-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 894 | **libdigest-perl-md5-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 895 | **libdist-checkconflicts-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 896 | **libdpkg-parse-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 897 | **libdynaloader-functions-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 898 | **libemail-date-format-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 899 | **libencode-locale-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 900 | **libenv-sanctify-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 901 | **liberror-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 902 | **libeval-closure-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 903 | **libexception-class-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 904 | **libexpect-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 905 | **libexporter-lite-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 906 | **libexporter-tiny-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 907 | **libextutils-config-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 908 | **libextutils-depends-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 909 | **libextutils-hascompiler-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 910 | **libextutils-helpers-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 911 | **libextutils-installpaths-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 912 | **libextutils-libbuilder-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 913 | **libextutils-pkgconfig-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 914 | **libfile-basedir-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 915 | **libfile-chdir-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 916 | **libfile-copy-recursive-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 917 | **libfile-desktopentry-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 918 | **libfile-dircompare-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 919 | **libfile-dirlist-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 920 | **libfile-find-rule-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 921 | **libfile-find-rule-perl-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 922 | **libfile-homedir-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 923 | **libfile-libmagic-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 924 | **libfile-listing-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 925 | **libfile-mimeinfo-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 926 | **libfile-pushd-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 927 | **libfile-remove-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 928 | **libfile-sharedir-install-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 929 | **libfile-sharedir-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 930 | **libfile-slurp-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 931 | **libfile-slurper-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 932 | **libfile-touch-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 933 | **libfile-type-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 934 | **libfile-which-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 935 | **libfile-zglob-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 936 | **libfont-afm-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 937 | **libfont-ttf-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 938 | **libfreezethaw-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 939 | **libgd-barcode-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 940 | **libgd-graph-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 941 | **libgd-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 942 | **libgd-text-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 943 | **libgetopt-argvfile-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 944 | **libgetopt-long-descriptive-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 945 | **libgit-wrapper-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 946 | **libgitlab-api-v4-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 947 | **libglib-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 948 | **libgraph-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 949 | **libgraphviz-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 950 | **libgtk3-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 951 | **libhash-defhash-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 952 | **libhash-fieldhash-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 953 | **libhash-flatten-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 954 | **libhash-merge-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 955 | **libheap-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 956 | **libhook-lexwrap-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 957 | **libhtml-clean-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 958 | **libhtml-entities-numbered-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 959 | **libhtml-form-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 960 | **libhtml-format-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 961 | **libhtml-html5-entities-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 962 | **libhtml-lint-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 963 | **libhtml-parser-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 964 | **libhtml-tagset-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 965 | **libhtml-template-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 966 | **libhtml-tree-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 967 | **libhttp-cookies-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 968 | **libhttp-daemon-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 969 | **libhttp-date-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 970 | **libhttp-message-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 971 | **libhttp-negotiate-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 972 | **libhttp-server-simple-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 973 | **libhttp-tiny-multipart-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 974 | **libima-dbi-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 975 | **libimage-exiftool-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 976 | **libimage-size-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 977 | **libimport-into-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 978 | **libimporter-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 979 | **libinline-c-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 980 | **libinline-files-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 981 | **libinline-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 982 | **libintl-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 983 | **libio-captureoutput-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 984 | **libio-html-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 985 | **libio-interactive-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 986 | **libio-multiplex-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 987 | **libio-prompt-tiny-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 988 | **libio-prompter-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 989 | **libio-pty-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 990 | **libio-socket-inet6-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 991 | **libio-socket-socks-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 992 | **libio-socket-ssl-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 993 | **libio-string-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 994 | **libio-stty-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 995 | **libio-tiecombine-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 996 | **libipc-run-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 997 | **libipc-run3-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 998 | **libipc-shareable-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 999 | **libipc-sharedcache-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1000 | **libipc-signal-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1001 | **libipc-system-simple-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1002 | **libiterator-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1003 | **libiterator-util-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1004 | **libjson-any-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1005 | **libjson-maybexs-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1006 | **libjson-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1007 | **liblib-relative-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1008 | **liblingua-en-inflect-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1009 | **liblingua-translit-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1010 | **liblist-allutils-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1011 | **liblist-compare-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1012 | **liblist-moreutils-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1013 | **liblist-moreutils-xs-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1014 | **liblist-someutils-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1015 | **liblist-utilsby-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1016 | **liblocale-gettext-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1017 | **liblog-any-adapter-screen-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1018 | **liblog-any-adapter-tap-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1019 | **liblog-any-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1020 | **liblog-dispatch-filerotate-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1021 | **liblog-dispatch-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1022 | **liblog-log4perl-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1023 | **liblog-trace-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1024 | **liblwp-mediatypes-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1025 | **liblwp-protocol-https-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1026 | **libmail-authenticationresults-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1027 | **libmail-dkim-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1028 | **libmail-sendmail-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1029 | **libmailtools-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1030 | **libmatch-simple-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1031 | **libmath-base-convert-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1032 | **libmath-base36-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1033 | **libmath-base85-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1034 | **libmath-round-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1035 | **libmce-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1036 | **libmime-charset-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1037 | **libmime-lite-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1038 | **libmime-tools-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1039 | **libmime-types-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1040 | **libmixin-linewise-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1041 | **libmodule-build-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1042 | **libmodule-build-tiny-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1043 | **libmodule-depends-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1044 | **libmodule-find-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1045 | **libmodule-implementation-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1046 | **libmodule-install-authortests-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1047 | **libmodule-install-extratests-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1048 | **libmodule-install-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1049 | **libmodule-pluggable-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1050 | **libmodule-runtime-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1051 | **libmodule-scandeps-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1052 | **libmodule-signature-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1053 | **libmojo-server-fastcgi-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1054 | **libmojolicious-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1055 | **libmoo-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1056 | **libmoose-autobox-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1057 | **libmoosex-configfromfile-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | MooseX Perl extension (moosex-configfromfile) |
| 1058 | **libmoosex-getopt-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | MooseX Perl extension (moosex-getopt) |
| 1059 | **libmoosex-role-parameterized-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | MooseX Perl extension (moosex-role-parameterized) |
| 1060 | **libmoosex-simpleconfig-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | MooseX Perl extension (moosex-simpleconfig) |
| 1061 | **libmoosex-strictconstructor-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | MooseX Perl extension (moosex-strictconstructor) |
| 1062 | **libmoosex-types-common-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | MooseX Perl extension (moosex-types-common) |
| 1063 | **libmoosex-types-json-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | MooseX Perl extension (moosex-types-json) |
| 1064 | **libmoosex-types-loadableclass-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | MooseX Perl extension (moosex-types-loadableclass) |
| 1065 | **libmoosex-types-path-class-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | MooseX Perl extension (moosex-types-path-class) |
| 1066 | **libmoosex-types-path-tiny-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | MooseX Perl extension (moosex-types-path-tiny) |
| 1067 | **libmoosex-types-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | MooseX Perl extension (moosex-types) |
| 1068 | **libmoosex-types-stringlike-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | MooseX Perl extension (moosex-types-stringlike) |
| 1069 | **libmoox-aliases-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | MooX Perl extension (moox-aliases) |
| 1070 | **libmoox-handlesvia-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | MooX Perl extension (moox-handlesvia) |
| 1071 | **libmoox-struct-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | MooX Perl extension (moox-struct) |
| 1072 | **libmoox-types-mooselike-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | MooX Perl extension (moox-types-mooselike) |
| 1073 | **libmousex-nativetraits-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | MouseX Perl extension (mousex-nativetraits) |
| 1074 | **libmousex-strictconstructor-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | MouseX Perl extension (mousex-strictconstructor) |
| 1075 | **libmousex-types-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | MouseX Perl extension (mousex-types) |
| 1076 | **libmro-compat-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1077 | **libnamespace-autoclean-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1078 | **libnamespace-clean-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1079 | **libnet-cidr-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1080 | **libnet-dns-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1081 | **libnet-dns-resolver-mock-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1082 | **libnet-dns-resolver-programmable-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1083 | **libnet-domain-tld-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1084 | **libnet-http-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1085 | **libnet-ip-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1086 | **libnet-ipv6addr-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1087 | **libnet-ldap-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1088 | **libnet-netmask-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1089 | **libnet-server-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1090 | **libnet-smtp-ssl-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1091 | **libnet-snmp-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1092 | **libnet-ssleay-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1093 | **libnet-xwhois-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1094 | **libnumber-compare-perl** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | — |
| 1095 | **language-pack-af** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for af |
| 1096 | **language-pack-af-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for af |
| 1097 | **language-pack-am** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for am |
| 1098 | **language-pack-am-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for am |
| 1099 | **language-pack-an** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for an |
| 1100 | **language-pack-an-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for an |
| 1101 | **language-pack-ar** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for ar |
| 1102 | **language-pack-ar-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for ar |
| 1103 | **language-pack-as** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for as |
| 1104 | **language-pack-as-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for as |
| 1105 | **language-pack-ast** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for ast |
| 1106 | **language-pack-ast-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for ast |
| 1107 | **language-pack-az** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for az |
| 1108 | **language-pack-az-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for az |
| 1109 | **language-pack-be** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for be |
| 1110 | **language-pack-be-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for be |
| 1111 | **language-pack-bg** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for bg |
| 1112 | **language-pack-bg-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for bg |
| 1113 | **language-pack-bn** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for bn |
| 1114 | **language-pack-bn-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for bn |
| 1115 | **language-pack-br** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for br |
| 1116 | **language-pack-br-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for br |
| 1117 | **language-pack-bs** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for bs |
| 1118 | **language-pack-bs-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for bs |
| 1119 | **language-pack-ca** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for ca |
| 1120 | **language-pack-ca-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for ca |
| 1121 | **language-pack-ckb** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for ckb |
| 1122 | **language-pack-ckb-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for ckb |
| 1123 | **language-pack-crh** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for crh |
| 1124 | **language-pack-crh-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for crh |
| 1125 | **language-pack-cs** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for cs |
| 1126 | **language-pack-cs-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for cs |
| 1127 | **language-pack-cy** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for cy |
| 1128 | **language-pack-cy-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for cy |
| 1129 | **language-pack-da** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for da |
| 1130 | **language-pack-da-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for da |
| 1131 | **language-pack-de** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for de |
| 1132 | **language-pack-de-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for de |
| 1133 | **language-pack-dz** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for dz |
| 1134 | **language-pack-dz-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for dz |
| 1135 | **language-pack-el** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for el |
| 1136 | **language-pack-el-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for el |
| 1137 | **language-pack-en** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for en |
| 1138 | **language-pack-en-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for en |
| 1139 | **language-pack-eo** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for eo |
| 1140 | **language-pack-eo-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for eo |
| 1141 | **language-pack-es** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for es |
| 1142 | **language-pack-es-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for es |
| 1143 | **language-pack-et** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for et |
| 1144 | **language-pack-et-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for et |
| 1145 | **language-pack-eu** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for eu |
| 1146 | **language-pack-eu-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for eu |
| 1147 | **language-pack-fa** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for fa |
| 1148 | **language-pack-fa-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for fa |
| 1149 | **language-pack-fi** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for fi |
| 1150 | **language-pack-fi-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for fi |
| 1151 | **language-pack-fr** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for fr |
| 1152 | **language-pack-fr-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for fr |
| 1153 | **language-pack-fur** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for fur |
| 1154 | **language-pack-fur-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for fur |
| 1155 | **language-pack-ga** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for ga |
| 1156 | **language-pack-ga-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for ga |
| 1157 | **language-pack-gd** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for gd |
| 1158 | **language-pack-gd-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for gd |
| 1159 | **language-pack-gl** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for gl |
| 1160 | **language-pack-gl-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for gl |
| 1161 | **language-pack-gnome-af** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for af |
| 1162 | **language-pack-gnome-af-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for af (base) |
| 1163 | **language-pack-gnome-am** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for am |
| 1164 | **language-pack-gnome-am-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for am (base) |
| 1165 | **language-pack-gnome-an** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for an |
| 1166 | **language-pack-gnome-an-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for an (base) |
| 1167 | **language-pack-gnome-ar** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for ar |
| 1168 | **language-pack-gnome-ar-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for ar (base) |
| 1169 | **language-pack-gnome-as** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for as |
| 1170 | **language-pack-gnome-as-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for as (base) |
| 1171 | **language-pack-gnome-ast** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for ast |
| 1172 | **language-pack-gnome-ast-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for ast (base) |
| 1173 | **language-pack-gnome-az** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for az |
| 1174 | **language-pack-gnome-az-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for az (base) |
| 1175 | **language-pack-gnome-be** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for be |
| 1176 | **language-pack-gnome-be-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for be (base) |
| 1177 | **language-pack-gnome-bg** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for bg |
| 1178 | **language-pack-gnome-bg-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for bg (base) |
| 1179 | **language-pack-gnome-bn** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for bn |
| 1180 | **language-pack-gnome-bn-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for bn (base) |
| 1181 | **language-pack-gnome-br** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for br |
| 1182 | **language-pack-gnome-br-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for br (base) |
| 1183 | **language-pack-gnome-bs** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for bs |
| 1184 | **language-pack-gnome-bs-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for bs (base) |
| 1185 | **language-pack-gnome-ca** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for ca |
| 1186 | **language-pack-gnome-ca-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for ca (base) |
| 1187 | **language-pack-gnome-ckb** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for ckb |
| 1188 | **language-pack-gnome-ckb-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for ckb (base) |
| 1189 | **language-pack-gnome-crh** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for crh |
| 1190 | **language-pack-gnome-crh-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for crh (base) |
| 1191 | **language-pack-gnome-cs** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for cs |
| 1192 | **language-pack-gnome-cs-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for cs (base) |
| 1193 | **language-pack-gnome-cy** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for cy |
| 1194 | **language-pack-gnome-cy-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for cy (base) |
| 1195 | **language-pack-gnome-da** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for da |
| 1196 | **language-pack-gnome-da-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for da (base) |
| 1197 | **language-pack-gnome-de** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for de |
| 1198 | **language-pack-gnome-de-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for de (base) |
| 1199 | **language-pack-gnome-dz** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for dz |
| 1200 | **language-pack-gnome-dz-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for dz (base) |
| 1201 | **language-pack-gnome-el** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for el |
| 1202 | **language-pack-gnome-el-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for el (base) |
| 1203 | **language-pack-gnome-en** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for en |
| 1204 | **language-pack-gnome-en-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for en (base) |
| 1205 | **language-pack-gnome-eo** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for eo |
| 1206 | **language-pack-gnome-eo-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for eo (base) |
| 1207 | **language-pack-gnome-es** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for es |
| 1208 | **language-pack-gnome-es-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for es (base) |
| 1209 | **language-pack-gnome-et** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for et |
| 1210 | **language-pack-gnome-et-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for et (base) |
| 1211 | **language-pack-gnome-eu** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for eu |
| 1212 | **language-pack-gnome-eu-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for eu (base) |
| 1213 | **language-pack-gnome-fa** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for fa |
| 1214 | **language-pack-gnome-fa-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for fa (base) |
| 1215 | **language-pack-gnome-fi** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for fi |
| 1216 | **language-pack-gnome-fi-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for fi (base) |
| 1217 | **language-pack-gnome-fr** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for fr |
| 1218 | **language-pack-gnome-fr-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for fr (base) |
| 1219 | **language-pack-gnome-fur** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for fur |
| 1220 | **language-pack-gnome-fur-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for fur (base) |
| 1221 | **language-pack-gnome-ga** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for ga |
| 1222 | **language-pack-gnome-ga-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for ga (base) |
| 1223 | **language-pack-gnome-gd** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for gd |
| 1224 | **language-pack-gnome-gd-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for gd (base) |
| 1225 | **language-pack-gnome-gl** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for gl |
| 1226 | **language-pack-gnome-gl-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for gl (base) |
| 1227 | **language-pack-gnome-gu** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for gu |
| 1228 | **language-pack-gnome-gu-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for gu (base) |
| 1229 | **language-pack-gnome-he** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for he |
| 1230 | **language-pack-gnome-he-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for he (base) |
| 1231 | **language-pack-gnome-hi** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for hi |
| 1232 | **language-pack-gnome-hi-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for hi (base) |
| 1233 | **language-pack-gnome-hr** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for hr |
| 1234 | **language-pack-gnome-hr-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for hr (base) |
| 1235 | **language-pack-gnome-hu** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for hu |
| 1236 | **language-pack-gnome-hu-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for hu (base) |
| 1237 | **language-pack-gnome-ia** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for ia |
| 1238 | **language-pack-gnome-ia-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for ia (base) |
| 1239 | **language-pack-gnome-id** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for id |
| 1240 | **language-pack-gnome-id-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for id (base) |
| 1241 | **language-pack-gnome-is** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for is |
| 1242 | **language-pack-gnome-is-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for is (base) |
| 1243 | **language-pack-gnome-it** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for it |
| 1244 | **language-pack-gnome-it-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for it (base) |
| 1245 | **language-pack-gnome-ja** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for ja |
| 1246 | **language-pack-gnome-ja-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for ja (base) |
| 1247 | **language-pack-gnome-ka** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for ka |
| 1248 | **language-pack-gnome-ka-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for ka (base) |
| 1249 | **language-pack-gnome-kab** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for kab |
| 1250 | **language-pack-gnome-kab-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for kab (base) |
| 1251 | **language-pack-gnome-kk** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for kk |
| 1252 | **language-pack-gnome-kk-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for kk (base) |
| 1253 | **language-pack-gnome-km** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for km |
| 1254 | **language-pack-gnome-km-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for km (base) |
| 1255 | **language-pack-gnome-kn** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for kn |
| 1256 | **language-pack-gnome-kn-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for kn (base) |
| 1257 | **language-pack-gnome-ko** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for ko |
| 1258 | **language-pack-gnome-ko-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for ko (base) |
| 1259 | **language-pack-gnome-ku** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for ku |
| 1260 | **language-pack-gnome-ku-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for ku (base) |
| 1261 | **language-pack-gnome-lt** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for lt |
| 1262 | **language-pack-gnome-lt-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for lt (base) |
| 1263 | **language-pack-gnome-lv** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for lv |
| 1264 | **language-pack-gnome-lv-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for lv (base) |
| 1265 | **language-pack-gnome-mk** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for mk |
| 1266 | **language-pack-gnome-mk-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for mk (base) |
| 1267 | **language-pack-gnome-ml** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for ml |
| 1268 | **language-pack-gnome-ml-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for ml (base) |
| 1269 | **language-pack-gnome-mr** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for mr |
| 1270 | **language-pack-gnome-mr-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for mr (base) |
| 1271 | **language-pack-gnome-ms** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for ms |
| 1272 | **language-pack-gnome-ms-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for ms (base) |
| 1273 | **language-pack-gnome-my** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for my |
| 1274 | **language-pack-gnome-my-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for my (base) |
| 1275 | **language-pack-gnome-nb** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for nb |
| 1276 | **language-pack-gnome-nb-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for nb (base) |
| 1277 | **language-pack-gnome-nds** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for nds |
| 1278 | **language-pack-gnome-nds-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for nds (base) |
| 1279 | **language-pack-gnome-ne** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for ne |
| 1280 | **language-pack-gnome-ne-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for ne (base) |
| 1281 | **language-pack-gnome-nl** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for nl |
| 1282 | **language-pack-gnome-nl-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for nl (base) |
| 1283 | **language-pack-gnome-nn** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for nn |
| 1284 | **language-pack-gnome-nn-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for nn (base) |
| 1285 | **language-pack-gnome-oc** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for oc |
| 1286 | **language-pack-gnome-oc-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for oc (base) |
| 1287 | **language-pack-gnome-or** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for or |
| 1288 | **language-pack-gnome-or-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for or (base) |
| 1289 | **language-pack-gnome-pa** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for pa |
| 1290 | **language-pack-gnome-pa-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for pa (base) |
| 1291 | **language-pack-gnome-pl** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for pl |
| 1292 | **language-pack-gnome-pl-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for pl (base) |
| 1293 | **language-pack-gnome-pt** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for pt |
| 1294 | **language-pack-gnome-pt-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for pt (base) |
| 1295 | **language-pack-gnome-ro** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for ro |
| 1296 | **language-pack-gnome-ro-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for ro (base) |
| 1297 | **language-pack-gnome-ru** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for ru |
| 1298 | **language-pack-gnome-ru-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for ru (base) |
| 1299 | **language-pack-gnome-si** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for si |
| 1300 | **language-pack-gnome-si-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for si (base) |
| 1301 | **language-pack-gnome-sk** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for sk |
| 1302 | **language-pack-gnome-sk-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for sk (base) |
| 1303 | **language-pack-gnome-sl** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for sl |
| 1304 | **language-pack-gnome-sl-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for sl (base) |
| 1305 | **language-pack-gnome-sq** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for sq |
| 1306 | **language-pack-gnome-sq-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for sq (base) |
| 1307 | **language-pack-gnome-sr** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for sr |
| 1308 | **language-pack-gnome-sr-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for sr (base) |
| 1309 | **language-pack-gnome-sv** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for sv |
| 1310 | **language-pack-gnome-sv-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for sv (base) |
| 1311 | **language-pack-gnome-szl** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for szl |
| 1312 | **language-pack-gnome-szl-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for szl (base) |
| 1313 | **language-pack-gnome-ta** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for ta |
| 1314 | **language-pack-gnome-ta-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for ta (base) |
| 1315 | **language-pack-gnome-te** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for te |
| 1316 | **language-pack-gnome-te-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for te (base) |
| 1317 | **language-pack-gnome-tg** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for tg |
| 1318 | **language-pack-gnome-tg-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for tg (base) |
| 1319 | **language-pack-gnome-th** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for th |
| 1320 | **language-pack-gnome-th-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for th (base) |
| 1321 | **language-pack-gnome-tr** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for tr |
| 1322 | **language-pack-gnome-tr-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for tr (base) |
| 1323 | **language-pack-gnome-ug** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for ug |
| 1324 | **language-pack-gnome-ug-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for ug (base) |
| 1325 | **language-pack-gnome-uk** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for uk |
| 1326 | **language-pack-gnome-uk-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for uk (base) |
| 1327 | **language-pack-gnome-vi** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for vi |
| 1328 | **language-pack-gnome-vi-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for vi (base) |
| 1329 | **language-pack-gnome-xh** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for xh |
| 1330 | **language-pack-gnome-xh-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for xh (base) |
| 1331 | **language-pack-gnome-zh-hans** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for zh-hans |
| 1332 | **language-pack-gnome-zh-hans-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for zh-hans (base) |
| 1333 | **language-pack-gnome-zh-hant** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for zh-hant |
| 1334 | **language-pack-gnome-zh-hant-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | GNOME translation pack for zh-hant (base) |
| 1335 | **language-pack-gu** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for gu |
| 1336 | **language-pack-gu-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for gu |
| 1337 | **language-pack-he** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for he |
| 1338 | **language-pack-he-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for he |
| 1339 | **language-pack-hi** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for hi |
| 1340 | **language-pack-hi-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for hi |
| 1341 | **language-pack-hr** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for hr |
| 1342 | **language-pack-hr-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for hr |
| 1343 | **language-pack-hu** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for hu |
| 1344 | **language-pack-hu-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for hu |
| 1345 | **language-pack-ia** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for ia |
| 1346 | **language-pack-ia-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for ia |
| 1347 | **language-pack-id** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for id |
| 1348 | **language-pack-id-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for id |
| 1349 | **language-pack-is** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for is |
| 1350 | **language-pack-is-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for is |
| 1351 | **language-pack-it** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for it |
| 1352 | **language-pack-it-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for it |
| 1353 | **language-pack-ja** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for ja |
| 1354 | **language-pack-ja-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for ja |
| 1355 | **language-pack-ka** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for ka |
| 1356 | **language-pack-ka-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for ka |
| 1357 | **language-pack-kab** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for kab |
| 1358 | **language-pack-kab-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for kab |
| 1359 | **language-pack-kde-ar** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for ar |
| 1360 | **language-pack-kde-bg** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for bg |
| 1361 | **language-pack-kde-bs** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for bs |
| 1362 | **language-pack-kde-ca** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for ca |
| 1363 | **language-pack-kde-cs** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for cs |
| 1364 | **language-pack-kde-da** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for da |
| 1365 | **language-pack-kde-de** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for de |
| 1366 | **language-pack-kde-el** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for el |
| 1367 | **language-pack-kde-en** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for en |
| 1368 | **language-pack-kde-es** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for es |
| 1369 | **language-pack-kde-et** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for et |
| 1370 | **language-pack-kde-eu** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for eu |
| 1371 | **language-pack-kde-fa** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for fa |
| 1372 | **language-pack-kde-fi** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for fi |
| 1373 | **language-pack-kde-fr** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for fr |
| 1374 | **language-pack-kde-ga** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for ga |
| 1375 | **language-pack-kde-gl** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for gl |
| 1376 | **language-pack-kde-he** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for he |
| 1377 | **language-pack-kde-hi** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for hi |
| 1378 | **language-pack-kde-hr** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for hr |
| 1379 | **language-pack-kde-hu** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for hu |
| 1380 | **language-pack-kde-ia** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for ia |
| 1381 | **language-pack-kde-id** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for id |
| 1382 | **language-pack-kde-is** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for is |
| 1383 | **language-pack-kde-it** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for it |
| 1384 | **language-pack-kde-ja** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for ja |
| 1385 | **language-pack-kde-kk** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for kk |
| 1386 | **language-pack-kde-km** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for km |
| 1387 | **language-pack-kde-ko** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for ko |
| 1388 | **language-pack-kde-lt** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for lt |
| 1389 | **language-pack-kde-lv** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for lv |
| 1390 | **language-pack-kde-mr** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for mr |
| 1391 | **language-pack-kde-nb** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for nb |
| 1392 | **language-pack-kde-nds** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for nds |
| 1393 | **language-pack-kde-nl** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for nl |
| 1394 | **language-pack-kde-nn** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for nn |
| 1395 | **language-pack-kde-pa** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for pa |
| 1396 | **language-pack-kde-pl** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for pl |
| 1397 | **language-pack-kde-pt** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for pt |
| 1398 | **language-pack-kde-ro** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for ro |
| 1399 | **language-pack-kde-ru** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for ru |
| 1400 | **language-pack-kde-si** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for si |
| 1401 | **language-pack-kde-sk** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for sk |
| 1402 | **language-pack-kde-sl** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for sl |
| 1403 | **language-pack-kde-sr** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for sr |
| 1404 | **language-pack-kde-sv** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for sv |
| 1405 | **language-pack-kde-tg** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for tg |
| 1406 | **language-pack-kde-th** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for th |
| 1407 | **language-pack-kde-tr** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for tr |
| 1408 | **language-pack-kde-ug** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for ug |
| 1409 | **language-pack-kde-uk** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for uk |
| 1410 | **language-pack-kde-vi** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | KDE translation pack for vi |
| 1411 | **language-pack-kk** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for kk |
| 1412 | **language-pack-kk-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for kk |
| 1413 | **language-pack-km** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for km |
| 1414 | **language-pack-km-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for km |
| 1415 | **language-pack-kn** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for kn |
| 1416 | **language-pack-kn-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for kn |
| 1417 | **language-pack-ko** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for ko |
| 1418 | **language-pack-ko-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for ko |
| 1419 | **language-pack-ku** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for ku |
| 1420 | **language-pack-ku-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for ku |
| 1421 | **language-pack-lt** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for lt |
| 1422 | **language-pack-lt-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for lt |
| 1423 | **language-pack-lv** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for lv |
| 1424 | **language-pack-lv-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for lv |
| 1425 | **language-pack-mk** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for mk |
| 1426 | **language-pack-mk-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for mk |
| 1427 | **language-pack-ml** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for ml |
| 1428 | **language-pack-ml-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for ml |
| 1429 | **language-pack-mr** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for mr |
| 1430 | **language-pack-mr-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for mr |
| 1431 | **language-pack-ms** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for ms |
| 1432 | **language-pack-ms-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for ms |
| 1433 | **language-pack-my** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for my |
| 1434 | **language-pack-my-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for my |
| 1435 | **language-pack-nb** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for nb |
| 1436 | **language-pack-nb-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for nb |
| 1437 | **language-pack-nds** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for nds |
| 1438 | **language-pack-nds-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for nds |
| 1439 | **language-pack-ne** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for ne |
| 1440 | **language-pack-ne-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for ne |
| 1441 | **language-pack-nl** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for nl |
| 1442 | **language-pack-nl-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for nl |
| 1443 | **language-pack-nn** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for nn |
| 1444 | **language-pack-nn-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for nn |
| 1445 | **language-pack-oc** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for oc |
| 1446 | **language-pack-oc-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for oc |
| 1447 | **language-pack-or** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for or |
| 1448 | **language-pack-or-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for or |
| 1449 | **language-pack-pa** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for pa |
| 1450 | **language-pack-pa-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for pa |
| 1451 | **language-pack-pl** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for pl |
| 1452 | **language-pack-pl-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for pl |
| 1453 | **language-pack-pt** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for pt |
| 1454 | **language-pack-pt-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for pt |
| 1455 | **language-pack-ro** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for ro |
| 1456 | **language-pack-ro-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for ro |
| 1457 | **language-pack-ru** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for ru |
| 1458 | **language-pack-ru-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for ru |
| 1459 | **language-pack-si** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for si |
| 1460 | **language-pack-si-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for si |
| 1461 | **language-pack-sk** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for sk |
| 1462 | **language-pack-sk-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for sk |
| 1463 | **language-pack-sl** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for sl |
| 1464 | **language-pack-sl-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for sl |
| 1465 | **language-pack-sq** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for sq |
| 1466 | **language-pack-sq-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for sq |
| 1467 | **language-pack-sr** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for sr |
| 1468 | **language-pack-sr-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for sr |
| 1469 | **language-pack-sv** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for sv |
| 1470 | **language-pack-sv-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for sv |
| 1471 | **language-pack-szl** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for szl |
| 1472 | **language-pack-szl-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for szl |
| 1473 | **language-pack-ta** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for ta |
| 1474 | **language-pack-ta-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for ta |
| 1475 | **language-pack-te** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for te |
| 1476 | **language-pack-te-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for te |
| 1477 | **language-pack-tg** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for tg |
| 1478 | **language-pack-tg-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for tg |
| 1479 | **language-pack-th** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for th |
| 1480 | **language-pack-th-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for th |
| 1481 | **language-pack-tr** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for tr |
| 1482 | **language-pack-tr-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for tr |
| 1483 | **language-pack-ug** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for ug |
| 1484 | **language-pack-ug-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for ug |
| 1485 | **language-pack-uk** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for uk |
| 1486 | **language-pack-uk-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for uk |
| 1487 | **language-pack-vi** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for vi |
| 1488 | **language-pack-vi-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for vi |
| 1489 | **language-pack-xh** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for xh |
| 1490 | **language-pack-xh-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for xh |
| 1491 | **language-pack-zh-hans** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for zh-hans |
| 1492 | **language-pack-zh-hans-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for zh-hans |
| 1493 | **language-pack-zh-hant** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Translation updates for zh-hant |
| 1494 | **language-pack-zh-hant-base** | TBD | TBD | TBD | Minimal | 5 | Minimal — cosmetic/niche; leave to upstream | Base translation data for zh-hant |

---

*8-column matrix generated from the existing ranked `README.md` (0–83 scores) and `DESCRIPTORS.md` (descriptions). Years developed / software house filled only where reliably known, else `TBD`; age of expertise derived from the start year. Relative value and Improve are bands derived from the importance score. Max Rupplin — MEARVK LLC — 2026.*
