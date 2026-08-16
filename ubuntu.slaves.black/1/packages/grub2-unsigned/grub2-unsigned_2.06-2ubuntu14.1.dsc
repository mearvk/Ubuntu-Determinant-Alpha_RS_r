-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: grub2-unsigned
Binary: grub-efi-amd64, grub-efi-arm64, grub-efi-amd64-bin, grub-efi-arm64-bin, grub-efi-amd64-dbg, grub-efi-arm64-dbg
Architecture: any-amd64 any-arm64 i386 kopensolaris-i386
Version: 2.06-2ubuntu14.1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Felix Zielcke <fzielcke@z-51.de>, Jordi Mallach <jordi@debian.org>, Colin Watson <cjwatson@debian.org>, Steve McIntyre <93sam@debian.org>
Homepage: https://www.gnu.org/software/grub/
Standards-Version: 3.9.6
Vcs-Browser: https://git.launchpad.net/~ubuntu-core-dev/grub/+git/ubuntu
Vcs-Git: https://git.launchpad.net/~ubuntu-core-dev/grub/+git/ubuntu
Build-Depends: debhelper-compat (= 10), patchutils, python3, flex, bison, po-debconf, help2man, texinfo, gcc-10, gcc-10-multilib [i386 kopensolaris-i386 any-amd64 any-ppc64 any-sparc], xfonts-unifont, libfreetype6-dev, gettext, libdevmapper-dev [linux-any], libgeom-dev (>= 8.2+ds1-1~) [kfreebsd-any] | libgeom-dev (<< 8.2) [kfreebsd-any], libsdl1.2-dev [!hurd-any], xorriso [!i386], qemu-system [kfreebsd-i386 kopensolaris-i386 any-amd64], cpio [i386 kopensolaris-i386 amd64 x32], parted [!hurd-any], libfuse3-dev [linux-any kfreebsd-any], fonts-dejavu-core, liblzma-dev, liblzo2-dev, dosfstools [any-amd64 any-arm64], squashfs-tools [any-amd64 any-arm64], wamerican, libparted-dev [any-powerpc any-ppc64 any-ppc64el], pkg-config, bash-completion, libefiboot-dev [i386 amd64 ia64 x32 armel armhf arm64 riscv64], libefivar-dev [i386 amd64 ia64 x32 armel armhf arm64 riscv64]
Build-Conflicts: autoconf2.13, libnvpair-dev, libzfs-dev
Package-List:
 grub-efi-amd64 deb admin optional arch=i386,kopensolaris-i386,any-amd64
 grub-efi-amd64-bin deb admin optional arch=i386,kopensolaris-i386,any-amd64
 grub-efi-amd64-dbg deb debug optional arch=i386,kopensolaris-i386,any-amd64
 grub-efi-arm64 deb admin optional arch=any-arm64
 grub-efi-arm64-bin deb admin optional arch=any-arm64
 grub-efi-arm64-dbg deb debug optional arch=any-arm64
Checksums-Sha1:
 c9f93f1e195ec7a5a21d36a13b469788c0b29f0f 6581924 grub2-unsigned_2.06.orig.tar.xz
 ae8712d58d4b0b7f029523756ad3935d927dbb64 1215528 grub2-unsigned_2.06-2ubuntu14.1.debian.tar.xz
Checksums-Sha256:
 b79ea44af91b93d17cd3fe80bdae6ed43770678a9a5ae192ccea803ebb657ee1 6581924 grub2-unsigned_2.06.orig.tar.xz
 eeafc06c73a6c1632a9f58312968233c2c268e299579aecec03a8f014ce64b72 1215528 grub2-unsigned_2.06-2ubuntu14.1.debian.tar.xz
Files:
 cf0fd928b1e5479c8108ee52cb114363 6581924 grub2-unsigned_2.06.orig.tar.xz
 d3d21abddb44ac6656251a4b14007588 1215528 grub2-unsigned_2.06-2ubuntu14.1.debian.tar.xz
Original-Maintainer: GRUB Maintainers <pkg-grub-devel@alioth-lists.debian.net>

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCgAtFiEET7WIqEwt3nmnTHeHb6RY3R2wP3EFAmPXoqIPHGpha0BkZWJp
YW4ub3JnAAoJEG+kWN0dsD9xgNwP/jjbEdyzvD1g4+kT0xGT6zysZH68U34j1m9h
t6rbGEp66a5jL4BVR7Yajvkq5yWB8x2uCE8drLTfOYdgMbR4lO9wc1CuvK3RdFBT
dCzgtIJu40vs3Y++KqLwG7zroHxfjJjIBJvwjydsMGmH8q22Iy1HMqAB46lR4fch
OgxsWruV5l7jg+qpFX/8dMqJ8aJ/Ht6oDBaVcCk9OdAKXSzkUQyN64D1XAvVoZox
rB23OYZddNv5frzBU+EaD5N690uF9sQ18B20AJ7iTfpmhrGK330QLFZ3lqm6dNaD
5SweNdfH+iH5acL5Tkhvc84o6/4YGBWyXuqeg4Tiy6n4PdWBabJNiCx0DSuWT15s
RC/abYiFY1posGtYExnxds3q7txqH+4nHo7ZvAoG9JvOljLf0sFrqjjeJo3jqYsu
BH/4YbE4uSO2h02KVwITqsRYgzKKlUCN5L5IlcXjZWOa3okZ37DCh8xwt+eWTLSv
HXO4H1ncA0rquhVjS/Z6NRnkUfg+bnNtxt3Ehh7qCSTu1ThP0V2xKAV8loPWTIiw
Pg3iG9LH5mZBPWwFHFXv7UZRofWqcp7Pj/JM5oSrHtlo1d4Nl5nb9KVMrt61Ccwy
andZgvLAhj9I+6Pd+bBTZY3zYxFpLiUivUpVxb8h6kRqJTV5Nbv+2aNwBaqpgj8V
4pyTobnq
=EFls
-----END PGP SIGNATURE-----
