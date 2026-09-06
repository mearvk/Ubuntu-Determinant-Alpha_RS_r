# Packages — Ranked by Importance (8-Column Matrix)

## Homomorphic Ego Concentration

Each package is projected onto a perceivable scale of **0 to 83**:

- **83** = Perfectly standard. Foundational to computing itself.
- **0** = Perfectly non-relevant to standard. Decorative, niche, ornamental.

The *homomorphic ego concentration* is a structure-preserving map from the
space of all software packages to a single scalar representing how essential
a package is to the concept of "software standard next to man the sage."

Disc 3 holds the runtime/desktop "p–q" slice of the archive: language runtimes
(Perl, Python), the Qt5 toolkit, audio/video/imaging libraries, HPC messaging,
and many Perl-module and Java/Maven build components. Foundational runtimes and
security/runtime libraries concentrate high; niche language-binding modules
dissolve toward the low end.

## Column definitions

1. **Rank** — position in the disc-3 importance ordering (1 = most important).
2. **Software** — source package name (Ubuntu 22.04.3, disc 3).
3. **Years developed** — first public release year of the upstream project, where
   reliably known; otherwise `TBD` (assembled offline; per-package dates not
   verified here).
4. **Software house** — upstream steward/organization, where reliably known; else `TBD`.
5. **Age of expertise** — 2026 − first release year, where known; otherwise `TBD`.
6. **Relative value** — band from the score: Foundational (≥75), High (60–74),
   Moderate (30–59), Low (10–29), Minimal (<10).
7. **Importance (0–83)** — homomorphic-ego-concentration score (created for disc 3
   using the same model as discs 1–2).
8. **Improve** — importance of improving/integrating the package, derived (with reason).
9. **Description** — concise factual description.

> Honesty note: disc 3 had no prior ranked README/DESCRIPTORS, so scores and
> descriptions here are newly created using the same model as discs 1–2.
> **Years developed** and **Software house** are filled only where genuinely
> known; the rest are `TBD` rather than guessed. Perl-module rows use a generic
> derived description where a specific one was not written.

**Total packages: 160**

| Rank | Software | Years developed | Software house | Age of expertise | Relative value | Importance (0–83) | Improve | Description |
|-----:|---------|-----------------|----------------|-----------------:|----------------|:-----------------:|---------|-------------|

| 1 | **perl** | 1987 | Larry Wall / Perl community | 39 | High | 72 | High — foundational; changes need strong evidence and review | Perl language interpreter and core runtime |
| 2 | **python3.11** | 1991 | Python Software Foundation | 35 | High | 72 | High — foundational; changes need strong evidence and review | Python 3.11 language interpreter and runtime |
| 3 | **pam** | 1996 | Linux-PAM project | 30 | High | 70 | High — foundational; changes need strong evidence and review | Pluggable Authentication Modules — system auth framework |
| 4 | **python3.10** | 1991 | Python Software Foundation | 35 | High | 70 | High — foundational; changes need strong evidence and review | Python 3.10 language interpreter and runtime |
| 5 | **procps** | 1992 | procps-ng project | 34 | High | 66 | Medium — meaningful integration/hardening value | Process/system utilities (ps, top, free, sysctl) |
| 6 | **python-defaults** | 1991 | Python Software Foundation | 35 | High | 66 | Medium — meaningful integration/hardening value | Default Python version selection for the system |
| 7 | **pcre2** | 2015 | PCRE project (Philip Hazel) | 11 | High | 62 | Medium — meaningful integration/hardening value | Perl-Compatible Regular Expressions v2 library |
| 8 | **libpng1.6** | 1996 | PNG Development Group | 30 | High | 60 | Medium — meaningful integration/hardening value | PNG image reference library |
| 9 | **parted** | 1999 | GNU Project | 27 | High | 60 | Medium — meaningful integration/hardening value | GNU Parted disk partition editor/library |
| 10 | **protobuf** | 2008 | Google | 18 | High | 60 | Medium — meaningful integration/hardening value | Google Protocol Buffers — data serialization |
| 11 | **libpcap** | 1994 | The Tcpdump Group | 32 | Moderate | 58 | Medium — meaningful integration/hardening value | Packet capture library (tcpdump/libpcap) |
| 12 | **openmpi** | 2004 | Open MPI project | 22 | Moderate | 58 | Medium — meaningful integration/hardening value | Open MPI — Message Passing Interface for HPC |
| 13 | **pcre3** | 1997 | PCRE project (Philip Hazel) | 29 | Moderate | 58 | Medium — meaningful integration/hardening value | Perl-Compatible Regular Expressions (legacy PCRE) library |
| 14 | **pipewire** | 2017 | Wim Taymans / Red Hat | 9 | Moderate | 58 | Medium — meaningful integration/hardening value | Multimedia server for audio/video streams |
| 15 | **pixman** | 2008 | freedesktop.org | 18 | Moderate | 58 | Medium — meaningful integration/hardening value | Low-level pixel manipulation library (used by cairo/X) |
| 16 | **qtbase-opensource-src** | TBD | TBD | TBD | Moderate | 58 | Medium — meaningful integration/hardening value | Qt5 base module (core, GUI, widgets, network) |
| 17 | **pulseaudio** | 2004 | PulseAudio project | 22 | Moderate | 56 | Medium — meaningful integration/hardening value | PulseAudio sound server |
| 18 | **openjfx** | 2011 | Oracle / OpenJDK community | 15 | Moderate | 55 | Medium — meaningful integration/hardening value | OpenJFX — JavaFX runtime and UI toolkit |
| 19 | **p11-kit** | 2011 | freedesktop.org | 15 | Moderate | 55 | Medium — meaningful integration/hardening value | PKCS#11 module loading/coordination for crypto tokens |
| 20 | **opus** | 2012 | Xiph.Org / IETF | 14 | Moderate | 52 | Medium — meaningful integration/hardening value | Opus interactive audio codec |
| 21 | **pciutils** | 1997 | Martin Mares | 29 | Moderate | 52 | Medium — meaningful integration/hardening value | PCI device utilities and library (lspci) |
| 22 | **libpwquality** | 2011 | libpwquality project | 15 | Moderate | 50 | Medium — meaningful integration/hardening value | Password quality checking library |
| 23 | **popt** | 1998 | Red Hat | 28 | Moderate | 50 | Medium — meaningful integration/hardening value | Command-line option parsing library |
| 24 | **libpciaccess** | 2007 | X.Org Foundation | 19 | Moderate | 48 | Medium — meaningful integration/hardening value | PCI access abstraction library (X.Org) |
| 25 | **openexr** | 1999 | Industrial Light & Magic | 27 | Moderate | 48 | Medium — meaningful integration/hardening value | OpenEXR high-dynamic-range image format |
| 26 | **libogg** | 1994 | Xiph.Org Foundation | 32 | Moderate | 46 | Medium — meaningful integration/hardening value | Ogg bitstream container library |
| 27 | **pcsc-lite** | 1999 | MUSCLE project | 27 | Moderate | 46 | Medium — meaningful integration/hardening value | PC/SC smart card daemon and library |
| 28 | **qtdeclarative-opensource-src** | TBD | TBD | TBD | Moderate | 46 | Medium — meaningful integration/hardening value | Qt5 Declarative (QML/Quick) |
| 29 | **unixodbc** | 1999 | unixODBC project | 27 | Moderate | 46 | Medium — meaningful integration/hardening value | ODBC driver manager for Unix |
| 30 | **libonig** | 2002 | K. Kosako | 24 | Moderate | 44 | Low — integrate as-is; improve only with cause | Oniguruma regular expression library |
| 31 | **libpipeline** | 2011 | Colin Watson / man-db | 15 | Moderate | 44 | Low — integrate as-is; improve only with cause | Library for safely running subprocess pipelines |
| 32 | **openjpeg2** | 2007 | OpenJPEG project | 19 | Moderate | 44 | Low — integrate as-is; improve only with cause | OpenJPEG — JPEG 2000 codec library |
| 33 | **protobuf-c** | 2008 | protobuf-c project | 18 | Moderate | 44 | Low — integrate as-is; improve only with cause | C bindings/runtime for Protocol Buffers |
| 34 | **libpsl** | 2014 | libpsl project | 12 | Moderate | 42 | Low — integrate as-is; improve only with cause | Public Suffix List library |
| 35 | **openal-soft** | 2008 | OpenAL Soft project | 18 | Moderate | 42 | Low — integrate as-is; improve only with cause | Software implementation of the OpenAL 3D audio API |
| 36 | **egl-wayland** | 2016 | NVIDIA | 10 | Moderate | 40 | Low — integrate as-is; improve only with cause | EGL external platform library for Wayland |
| 37 | **libplacebo** | 2017 | libplacebo project | 9 | Moderate | 40 | Low — integrate as-is; improve only with cause | GPU video/image rendering library |
| 38 | **libproxy** | 2006 | libproxy project | 20 | Moderate | 40 | Low — integrate as-is; improve only with cause | Automatic proxy configuration library |
| 39 | **openipmi** | 2004 | OpenIPMI project | 22 | Moderate | 40 | Low — integrate as-is; improve only with cause | IPMI (Intelligent Platform Management Interface) library |
| 40 | **orc** | 2009 | GStreamer project | 17 | Moderate | 40 | Low — integrate as-is; improve only with cause | Oil Runtime Compiler (SIMD array operations) |
| 41 | **pangomm** | 2002 | GNOME Project | 24 | Moderate | 40 | Low — integrate as-is; improve only with cause | C++ bindings for Pango text layout |
| 42 | **pmix** | 2015 | PMIx community | 11 | Moderate | 40 | Low — integrate as-is; improve only with cause | Process Management Interface for Exascale (HPC) |
| 43 | **qttools-opensource-src** | TBD | TBD | TBD | Moderate | 40 | Low — integrate as-is; improve only with cause | Qt5 developer tools (Designer, Linguist, etc.) |
| 44 | **portaudio19** | 1999 | PortAudio project | 27 | Moderate | 38 | Low — integrate as-is; improve only with cause | PortAudio cross-platform audio I/O library |
| 45 | **qtmultimedia-opensource-src** | TBD | TBD | TBD | Moderate | 38 | Low — integrate as-is; improve only with cause | Qt5 multimedia (audio/video/camera) |
| 46 | **libopenmpt** | 2013 | OpenMPT project | 13 | Moderate | 36 | Low — integrate as-is; improve only with cause | Library for decoding tracker music modules |
| 47 | **libplist** | 2008 | libimobiledevice project | 18 | Moderate | 36 | Low — integrate as-is; improve only with cause | Apple property list (plist) library |
| 48 | **qtsvg-opensource-src** | TBD | TBD | TBD | Moderate | 36 | Low — integrate as-is; improve only with cause | Qt5 SVG rendering module |
| 49 | **openhpi** | 2004 | OpenHPI project | 22 | Moderate | 34 | Low — integrate as-is; improve only with cause | Hardware Platform Interface implementation |
| 50 | **potrace** | 2001 | Peter Selinger | 25 | Moderate | 34 | Low — integrate as-is; improve only with cause | Bitmap-to-vector tracing library/tool |
| 51 | **kwallet-pam** | 2014 | KDE | 12 | Moderate | 30 | Low — integrate as-is; improve only with cause | PAM module to unlock KWallet at login |
| 52 | **libpfm4** | 2009 | perfmon2 project | 17 | Moderate | 30 | Low — integrate as-is; improve only with cause | Performance monitoring events library |
| 53 | **libpthread-stubs** | 2009 | X.Org Foundation | 17 | Moderate | 30 | Low — integrate as-is; improve only with cause | Weak pthread symbol stubs for portability |
| 54 | **opencc** | 2010 | OpenCC project | 16 | Moderate | 30 | Low — integrate as-is; improve only with cause | Open Chinese Convert (simplified/traditional) |
| 55 | **opencore-amr** | 2009 | OpenCORE project | 17 | Moderate | 30 | Low — integrate as-is; improve only with cause | AMR speech codec library |
| 56 | **qtconnectivity-opensource-src** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Qt5 Bluetooth/NFC connectivity |
| 57 | **qtlocation-opensource-src** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Qt5 location/positioning/maps |
| 58 | **qtserialport-opensource-src** | TBD | TBD | TBD | Moderate | 30 | Low — integrate as-is; improve only with cause | Qt5 serial port access |
| 59 | **libpaper** | 1996 | Debian Project | 30 | Low | 28 | Low — integrate as-is; improve only with cause | Paper size configuration library |
| 60 | **pcaudiolib** | 2016 | pcaudiolib project | 10 | Low | 28 | Low — integrate as-is; improve only with cause | Portable C audio output library |
| 61 | **picocli** | 2017 | Remko Popma | 9 | Low | 28 | Low — integrate as-is; improve only with cause | Java command-line parser framework |
| 62 | **qtwebchannel-opensource-src** | TBD | TBD | TBD | Low | 28 | Low — integrate as-is; improve only with cause | Qt5 web/JS <-> C++ bridge |
| 63 | **infinipath-psm** | 2010 | QLogic/Intel | 16 | Low | 26 | Low — integrate as-is; improve only with cause | InfiniPath PSM messaging library for HPC fabrics |
| 64 | **liboauth** | 2008 | liboauth project | 18 | Low | 26 | Low — integrate as-is; improve only with cause | C library implementing OAuth signing |
| 65 | **libpgm** | 2006 | OpenPGM project | 20 | Low | 26 | Low — integrate as-is; improve only with cause | PGM reliable multicast library |
| 66 | **protozero** | 2016 | Mapbox | 10 | Low | 26 | Low — integrate as-is; improve only with cause | Minimal C++ protocol buffers decoder/encoder |
| 67 | **qdbm** | 2000 | Mikio Hirabayashi | 26 | Low | 26 | Low — integrate as-is; improve only with cause | Quick Database Manager — embedded DB library |
| 68 | **qtremoteobjects-everywhere-src** | TBD | TBD | TBD | Low | 26 | Low — integrate as-is; improve only with cause | Qt5 remote objects (inter-process) |
| 69 | **qtsensors-opensource-src** | TBD | TBD | TBD | Low | 26 | Low — integrate as-is; improve only with cause | Qt5 sensors framework |
| 70 | **libomxil-bellagio** | 2007 | STMicroelectronics | 19 | Low | 24 | Low — integrate as-is; improve only with cause | Bellagio OpenMAX IL multimedia integration layer |
| 71 | **libopenmpt-modplug** | 2013 | OpenMPT project | 13 | Low | 24 | Low — integrate as-is; improve only with cause | ModPlug-compatible shim over libopenmpt |
| 72 | **libpgjava** | 1997 | PostgreSQL Global Development Group | 29 | Low | 24 | Low — integrate as-is; improve only with cause | PostgreSQL JDBC driver (Java) |
| 73 | **openjade** | 1999 | OpenJade project | 27 | Low | 24 | Low — integrate as-is; improve only with cause | OpenJade DSSSL engine (SGML/DSSSL) |
| 74 | **opensp** | 1994 | James Clark / OpenJade | 32 | Low | 24 | Low — integrate as-is; improve only with cause | OpenSP SGML/XML parsing tools |
| 75 | **plexus-utils2** | TBD | TBD | TBD | Low | 24 | Low — integrate as-is; improve only with cause | Plexus general-purpose utilities (Java build infra) |
| 76 | **qtspeech-opensource-src** | TBD | TBD | TBD | Low | 24 | Low — integrate as-is; improve only with cause | Qt5 text-to-speech |
| 77 | **objenesis** | 2006 | Objenesis project | 20 | Low | 22 | Low — integrate as-is; improve only with cause | Java library to instantiate objects without constructors |
| 78 | **ognl** | 2000 | OGNL project | 26 | Low | 22 | Low — integrate as-is; improve only with cause | Object-Graph Navigation Language (Java EL) |
| 79 | **plexus-archiver** | TBD | TBD | TBD | Low | 22 | Low — integrate as-is; improve only with cause | Plexus archive (zip/tar) handling |
| 80 | **plexus-classworlds** | TBD | TBD | TBD | Low | 22 | Low — integrate as-is; improve only with cause | Plexus classloader framework |
| 81 | **plexus-containers** | TBD | TBD | TBD | Low | 22 | Low — integrate as-is; improve only with cause | Plexus IoC container components |
| 82 | **liboggz** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | TBD |
| 83 | **osgi-core** | 2000 | OSGi Alliance | 26 | Low | 20 | Low — integrate as-is; improve only with cause | OSGi core framework API |
| 84 | **parboiled** | 2009 | parboiled project | 17 | Low | 20 | Low — integrate as-is; improve only with cause | Java PEG parser library |
| 85 | **plexus-compiler** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | Plexus compiler abstraction |
| 86 | **plexus-io** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | Plexus I/O components |
| 87 | **polyglot-maven** | 2010 | Sonatype | 16 | Low | 20 | Low — integrate as-is; improve only with cause | Polyglot Maven — non-XML build descriptors |
| 88 | **python2.7** | TBD | TBD | TBD | Low | 20 | Low — integrate as-is; improve only with cause | TBD |
| 89 | **libofa** | 2006 | MusicIP | 20 | Low | 18 | Low — integrate as-is; improve only with cause | Open Fingerprint Architecture audio fingerprinting |
| 90 | **libpcre++** | 2003 | pcre++ project | 23 | Low | 18 | Low — integrate as-is; improve only with cause | C++ wrapper around PCRE |
| 91 | **openjpa** | 2006 | Apache Software Foundation | 20 | Low | 18 | Low — integrate as-is; improve only with cause | Apache OpenJPA — Java persistence implementation |
| 92 | **opentest4j** | 2016 | JUnit team | 10 | Low | 18 | Low — integrate as-is; improve only with cause | Open Test Alliance assertion/exception model (Java) |
| 93 | **pegdown** | 2010 | pegdown project | 16 | Low | 18 | Low — integrate as-is; improve only with cause | Java Markdown processor (parboiled-based) |
| 94 | **plexus-cipher** | TBD | TBD | TBD | Low | 18 | Low — integrate as-is; improve only with cause | Plexus encryption helper |
| 95 | **plexus-interpolation** | TBD | TBD | TBD | Low | 18 | Low — integrate as-is; improve only with cause | Plexus string interpolation |
| 96 | **plexus-sec-dispatcher** | TBD | TBD | TBD | Low | 18 | Low — integrate as-is; improve only with cause | Plexus security dispatcher |
| 97 | **protobuf-java-format** | 2010 | protobuf-java-format project | 16 | Low | 18 | Low — integrate as-is; improve only with cause | JSON/XML formatters for protobuf Java |
| 98 | **oscache** | 2004 | OpenSymphony | 22 | Low | 16 | Low — integrate as-is; improve only with cause | OpenSymphony Java caching library (legacy) |
| 99 | **osgi-compendium** | 2000 | OSGi Alliance | 26 | Low | 16 | Low — integrate as-is; improve only with cause | OSGi compendium services API |
| 100 | **pam-wrapper** | 2015 | Samba team | 11 | Low | 16 | Low — integrate as-is; improve only with cause | Test wrapper for PAM in test suites |
| 101 | **plexus-build-api** | TBD | TBD | TBD | Low | 16 | Low — integrate as-is; improve only with cause | Plexus incremental build API |
| 102 | **plexus-languages** | TBD | TBD | TBD | Low | 16 | Low — integrate as-is; improve only with cause | Plexus language/module support |
| 103 | **plexus-resources** | TBD | TBD | TBD | Low | 16 | Low — integrate as-is; improve only with cause | Plexus resource handling |
| 104 | **properties-maven-plugin** | 2009 | Mojohaus | 17 | Low | 16 | Low — integrate as-is; improve only with cause | Maven plugin for reading/writing properties |
| 105 | **qdox** | 2002 | QDox project | 24 | Low | 16 | Low — integrate as-is; improve only with cause | Java source parser for javadoc-style metadata |
| 106 | **qdox2** | 2002 | QDox project | 24 | Low | 16 | Low — integrate as-is; improve only with cause | QDox 2.x Java source parser |
| 107 | **osgi-annotation** | 2000 | OSGi Alliance | 26 | Low | 14 | Minimal — cosmetic/niche; leave to upstream | OSGi annotations API |
| 108 | **plexus-cli** | TBD | TBD | TBD | Low | 14 | Minimal — cosmetic/niche; leave to upstream | Plexus command-line helper |
| 109 | **plexus-i18n** | TBD | TBD | TBD | Low | 14 | Minimal — cosmetic/niche; leave to upstream | Plexus internationalization |
| 110 | **plexus-interactivity-api** | TBD | TBD | TBD | Low | 14 | Minimal — cosmetic/niche; leave to upstream | Plexus interactive-prompt API |
| 111 | **plexus-velocity** | TBD | TBD | TBD | Low | 14 | Minimal — cosmetic/niche; leave to upstream | Plexus Velocity template integration |
| 112 | **portlet-api-2.0-spec** | 2008 | JBoss/JCP | 18 | Low | 14 | Minimal — cosmetic/niche; leave to upstream | Java Portlet 2.0 API spec jar |
| 113 | **libobject-accessor-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: object accessor |
| 114 | **libobject-id-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: object id |
| 115 | **libole-storage-lite-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: ole storage lite |
| 116 | **liboro-java** | 2000 | Apache Software Foundation | 26 | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Apache ORO Java regular-expression library (legacy) |
| 117 | **libpackage-stash-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: package stash |
| 118 | **libpackage-variant-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: package variant |
| 119 | **libpar-dist-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: par dist |
| 120 | **libparallel-forkmanager-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: parallel forkmanager |
| 121 | **libparams-classify-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: params classify |
| 122 | **libparams-util-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: params util |
| 123 | **libparams-validationcompiler-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: params validationcompiler |
| 124 | **libparanamer-java** | 2006 | paranamer project | 20 | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Paranamer — access method parameter names (Java) |
| 125 | **libparse-debcontrol-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: parse debcontrol |
| 126 | **libparse-recdescent-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: parse recdescent |
| 127 | **libparse-yapp-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: parse yapp |
| 128 | **libpath-class-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: path class |
| 129 | **libpath-iterator-rule-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: path iterator rule |
| 130 | **libpath-tiny-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: path tiny |
| 131 | **libpdf-api2-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: pdf api2 |
| 132 | **libpdfrenderer-java** | 2007 | PDFRenderer project | 19 | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Java PDF rendering library |
| 133 | **libpegex-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: pegex |
| 134 | **libperl-critic-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: perl critic |
| 135 | **libperl-minimumversion-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: perl minimumversion |
| 136 | **libperl4-corelibs-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: perl4 cores |
| 137 | **libperl6-export-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: perl6 export |
| 138 | **libperl6-slurp-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: perl6 slurp |
| 139 | **libperlio-gzip-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: perlio gzip |
| 140 | **libphp-serialization-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: php serialization |
| 141 | **libpod-constants-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: pod constants |
| 142 | **libpod-coverage-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: pod coverage |
| 143 | **libpod-markdown-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: pod markdown |
| 144 | **libpod-parser-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: pod parser |
| 145 | **libpod-pom-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: pod pom |
| 146 | **libpod-pom-view-restructured-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: pod pom view restructured |
| 147 | **libpod-readme-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: pod readme |
| 148 | **libpod-spell-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: pod spell |
| 149 | **libppi-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: ppi |
| 150 | **libppix-quotelike-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: ppix quotelike |
| 151 | **libppix-regexp-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: ppix regexp |
| 152 | **libppix-utilities-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: ppix utilities |
| 153 | **libppix-utils-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: ppix utils |
| 154 | **libprefork-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: prefork |
| 155 | **libprobe-perl-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: probe perl |
| 156 | **libproc-waitstat-perl** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Perl module: proc waitstat |
| 157 | **libproxool-java** | 2003 | Proxool project | 23 | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Proxool JDBC connection pool (Java) |
| 158 | **osgi-foundation-ee** | 2000 | OSGi Alliance | 26 | Low | 12 | Minimal — cosmetic/niche; leave to upstream | OSGi execution-environment definitions |
| 159 | **plexus-ant-factory** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Plexus Ant component factory |
| 160 | **plexus-bsh-factory** | TBD | TBD | TBD | Low | 12 | Minimal — cosmetic/niche; leave to upstream | Plexus BeanShell component factory |

---

*Disc-3 ranked 8-column matrix, created from the 160 real disc-3 packages using the same 0–83 homomorphic-ego model as discs 1–2. Years developed / software house filled only where reliably known, else `TBD`. Max Rupplin — MEARVK LLC — 2026.*
