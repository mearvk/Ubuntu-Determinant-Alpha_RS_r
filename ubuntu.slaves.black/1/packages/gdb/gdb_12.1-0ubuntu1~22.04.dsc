-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: gdb
Binary: gdb, gdb-multiarch, gdbserver, gdb-source, gdb-doc
Architecture: any all
Version: 12.1-0ubuntu1~22.04
Maintainer: Héctor Orón Martínez <zumbi@debian.org>
Uploaders: Riku Voipio <riku.voipio@linaro.org>, Sergio Durigan Junior <sergiodj@debian.org>
Homepage: https://www.gnu.org/s/gdb/
Standards-Version: 4.5.1
Vcs-Browser: https://salsa.debian.org/gdb-team/gdb
Vcs-Git: https://salsa.debian.org/gdb-team/gdb.git
Build-Depends: debhelper (>= 10), lsb-release, xz-utils, autoconf, libtool, gettext, bison, dejagnu, flex, procps, gobjc, mig [hurd-any], libutil-freebsd-dev [kfreebsd-any], texinfo (>= 4.7-2.2), texlive-base <!nodoc>, libexpat1-dev, libncurses5-dev, libreadline-dev, zlib1g-dev, liblzma-dev, libbabeltrace-dev, libipt-dev [amd64 i386 x32], libsource-highlight-dev [!i386], libxxhash-dev, libmpfr-dev, pkg-config, python3-dev, libkvm-dev [kfreebsd-any], libunwind-dev [ia64], libdebuginfod-dev [linux-any], libc6-dbg [armhf]
Package-List:
 gdb deb devel optional arch=any
 gdb-doc deb doc optional arch=all
 gdb-multiarch deb devel optional arch=any
 gdb-source deb devel optional arch=all
 gdbserver deb devel optional arch=amd64,armel,armhf,arm64,i386,ia64,m32r,m68k,mips,mipsel,mips64el,powerpc,powerpcspe,ppc64,ppc64el,riscv64,s390,s390x,x32
Checksums-Sha1:
 2edabd9f5766b84889b07b366b4438e93e994005 22470332 gdb_12.1.orig.tar.xz
 bcdcb4b90bf26205f7d915b689df50a95b0c27d7 49452 gdb_12.1-0ubuntu1~22.04.debian.tar.xz
Checksums-Sha256:
 0e1793bf8f2b54d53f46dea84ccfd446f48f81b297b28c4f7fc017b818d69fed 22470332 gdb_12.1.orig.tar.xz
 7c527dd003f89c87b0ba1f103348a026c6cd8fe68a47ca258bc1cf37b7a57e6b 49452 gdb_12.1-0ubuntu1~22.04.debian.tar.xz
Files:
 759a1b8d2b4d403367dd0e14fa04643d 22470332 gdb_12.1.orig.tar.xz
 08bbe15c67b763a96174241e4c883600 49452 gdb_12.1-0ubuntu1~22.04.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQJEBAEBCAAuFiEE1WVxuIqLuvFAv2PWvX6qYHePpvUFAmJxaLEQHGRva29AdWJ1
bnR1LmNvbQAKCRC9fqpgd4+m9VNeD/4nEELpmNr1FWPKSy80AHZqS/hzHz6PKpzP
p8DZcjK1rZfBx2q9WlHQNpYVvXCANakKRAqoNBCWKRcNGvFkfO1JSgaBR44fsYh7
lPAQTZA6+G/AglA0oifsPCs4CTZMQSlwIK0/Qtcr3BAgFUxOtnwyWziE8zOPlaKi
GrOHs+aP9Z7kODcERq2v/0P1vRj8Yon68bAHoxECY+IKwFA67qajtJrE0I3PBLLf
d8zVBOFZMm8mbvNaCEtOlXqHfmBoljsAKIfUx+d27B1ApVwBKKggzKcdcYhJVE08
2V2lJGrqz0trOhCR5nxhZUTxLySfImE2hDqqXZHDoBE8XFW6N3Fv3jZXvzQtH1f0
zRIEdwSxTC9u3M8uiY0TT1f7UtrRJ7reIe3Ei29vSWKQtgNeWaSCHvSVCSQvFz5H
cMfVA+GZw60QvQaTDAAZlONeWwnH4JOKejhCy0ro5N+WcBS9gQJ2AKTljz3fuNa0
S6abiq+L4OgJg1iItiXy/O6/KEzOYbT3Ne0ro2lfixR0tDAz5f49KxPQbi/yDa1w
1/z6b7vjfMXc+PYQoLlKKlyrTuFJEDWld4j1H2t4AMb6/UmLVtfBjJdU0sUR5mgL
0TCuaGjttR0FGTcFt1ECIA6scvw3TML/bZUO/w56SVs49clGN8GFqh7xfg6D2oRt
l+Ay3nbZcw==
=nbJf
-----END PGP SIGNATURE-----
