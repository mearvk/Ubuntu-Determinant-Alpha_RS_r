-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: gnome-online-accounts
Binary: gnome-online-accounts, libgoa-1.0-0b, libgoa-1.0-dev, libgoa-backend-1.0-1, libgoa-backend-1.0-dev, libgoa-1.0-common, libgoa-1.0-doc, gir1.2-goa-1.0
Architecture: any all
Version: 3.44.0-1ubuntu1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Jeremy Bicha <jbicha@ubuntu.com>, Laurent Bigonville <bigon@debian.org>, Michael Biebl <biebl@debian.org>
Homepage: https://wiki.gnome.org/Projects/GnomeOnlineAccounts
Standards-Version: 4.5.1
Vcs-Browser: https://salsa.debian.org/gnome-team/gnome-online-accounts/tree/ubuntu/master
Vcs-Git: https://salsa.debian.org/gnome-team/gnome-online-accounts.git -b ubuntu/master
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, dbus, python3-gi, xauth, xvfb
Build-Depends: debhelper-compat (= 13), autoconf-archive, dh-sequence-gir, dh-sequence-gnome, gtk-doc-tools, libgcr-3-dev, libgirepository1.0-dev (>= 0.9.3), libglib2.0-dev (>= 2.52), libgtk-3-dev (>= 3.19.12) [!ia64 !kfreebsd-amd64 !kfreebsd-i386], libjson-glib-dev [!ia64 !kfreebsd-amd64 !kfreebsd-i386], libkrb5-dev, librest-dev [!ia64 !kfreebsd-amd64 !kfreebsd-i386], libsecret-1-dev [!ia64 !kfreebsd-amd64 !kfreebsd-i386], libsnapd-glib-dev (>= 1.43), libsoup2.4-dev (>= 2.42) [!ia64 !kfreebsd-amd64 !kfreebsd-i386], libjavascriptcoregtk-4.0-dev [!ia64 !kfreebsd-amd64 !kfreebsd-i386], libwebkit2gtk-4.0-dev (>= 2.26) [!ia64 !kfreebsd-amd64 !kfreebsd-i386], valac
Build-Depends-Indep: libglib2.0-doc <!nodoc>, libgtk-3-doc <!nodoc>
Package-List:
 gir1.2-goa-1.0 deb introspection optional arch=any
 gnome-online-accounts deb gnome optional arch=alpha,amd64,arm64,armel,armhf,hppa,hurd-i386,i386,m68k,mips64el,mipsel,powerpc,ppc64,ppc64el,riscv64,s390x,sh4,sparc64,x32
 libgoa-1.0-0b deb libs optional arch=any
 libgoa-1.0-common deb libs optional arch=all
 libgoa-1.0-dev deb libdevel optional arch=any
 libgoa-1.0-doc deb doc optional arch=all profile=!nodoc
 libgoa-backend-1.0-1 deb libs optional arch=alpha,amd64,arm64,armel,armhf,hppa,hurd-i386,i386,m68k,mips64el,mipsel,powerpc,ppc64,ppc64el,riscv64,s390x,sh4,sparc64,x32
 libgoa-backend-1.0-dev deb libdevel optional arch=alpha,amd64,arm64,armel,armhf,hppa,hurd-i386,i386,m68k,mips64el,mipsel,powerpc,ppc64,ppc64el,riscv64,s390x,sh4,sparc64,x32
Checksums-Sha1:
 0c88729399a35486eda1031113404d6409063914 859564 gnome-online-accounts_3.44.0.orig.tar.xz
 14a08a9739bdc57be86d28462052104e2f87b9c8 29180 gnome-online-accounts_3.44.0-1ubuntu1.debian.tar.xz
Checksums-Sha256:
 381d5d4106f435b6f87786aa049be784774e15996adcc02789807afc87ea7342 859564 gnome-online-accounts_3.44.0.orig.tar.xz
 86bb50f5b974359d8258a6899a0b1d9bb0622de11b5a98d1b0d319be0902efeb 29180 gnome-online-accounts_3.44.0-1ubuntu1.debian.tar.xz
Files:
 ae928c27456d3a3f911d964c28d10754 859564 gnome-online-accounts_3.44.0.orig.tar.xz
 8601c64d3e9095821e5b4ffb1560936b 29180 gnome-online-accounts_3.44.0-1ubuntu1.debian.tar.xz
Debian-Vcs-Browser: https://salsa.debian.org/gnome-team/gnome-online-accounts
Debian-Vcs-Git: https://salsa.debian.org/gnome-team/gnome-online-accounts.git
Original-Maintainer: Debian GNOME Maintainers <pkg-gnome-maintainers@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEETQvhLw5HdtiqzpaW5mx3Wuv+bH0FAmJEeSoACgkQ5mx3Wuv+
bH3w5A/8CVwRfRPouGoMxaXH9RnbvloZf+LSos8t7a0x2Be+ipg4ZgEazs2cjeR3
sTCLU6hXgJdRNLiJaKyQoRM5JXmbW3XQN73kM/fXKjxzViWevIM/b9U2EZ9HC8ew
tFyAB8v6ea8Jma7t+mM130HNnpJddM3Ejau/B7W6RSgLtocU8OFBxffPL6G2Vd/N
b3+yUo1MSWL227bz7HV9xf/2cLiUUqxiP+LMkkfb+S+W+xw/PXCYzb3aC0UB8tGN
2hXNi8u2u+9j/2mwT5LEgahTvRW/uyRV3yp4HG8L8JgJH2E6XDtETaqAZ3uVIerI
vNY+pe74mHQY29bNDfxKkDS9WFns4AEZmUErGPCoKPwz40ykG0flpUn7zSA6guw6
ov0swUAidFlUn594njSGQqUOp+HG0GbMcREpR6wr5vzzjcA0K/th+8yRs74ZkdV8
Wh4R6QLO/0ARxHDtKsTjZVHPkxSIffj7PEX8jDtkqaqZlQpOkZrLXNnGu6j+GpVX
ABwa32YLfzBfa51Uo9HFjuYTphUJx8LMz09CAO+u2OWPH87CsPhs8dd2Wz9nqj4n
ntOGMsV0rJ/Rta1iNFgay3KD6Av+C0sd74KzzvfEq186SOjRH6OA3G6/mp8U9HlS
hEXEQHFVQD7HZtRMaBuVBWCGl7xetbTu0YQkVQc3pKNx9uJiL7g=
=hQkb
-----END PGP SIGNATURE-----
