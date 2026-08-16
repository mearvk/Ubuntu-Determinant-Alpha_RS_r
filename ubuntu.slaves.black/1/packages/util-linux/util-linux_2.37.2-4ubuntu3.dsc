-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: util-linux
Binary: util-linux, util-linux-locales, mount, bsdutils, bsdextrautils, fdisk, fdisk-udeb, libblkid1, libblkid1-udeb, libblkid-dev, libfdisk1, libfdisk1-udeb, libfdisk-dev, libmount1, libmount1-udeb, libmount-dev, libsmartcols1, libsmartcols1-udeb, libsmartcols-dev, libuuid1, uuid-runtime, libuuid1-udeb, uuid-dev, util-linux-udeb, rfkill, eject, eject-udeb
Architecture: any all
Version: 2.37.2-4ubuntu3
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Chris Hofstaedtler <zeha@debian.org>
Homepage: https://www.kernel.org/pub/linux/utils/util-linux/
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/debian/util-linux
Vcs-Git: https://salsa.debian.org/debian/util-linux.git
Testsuite: autopkgtest
Testsuite-Triggers: bash, bc, bsdmainutils, build-essential, dpkg, grep, pkg-config
Build-Depends: asciidoctor, bc <!stage1 !nocheck>, bison, debhelper-compat (= 13), dh-exec, gettext, libaudit-dev, libcap-ng-dev [linux-any] <!stage1>, libcryptsetup-dev [linux-any] <!pkg.util-linux.noverity>, libncurses5-dev, libncursesw5-dev, libpam0g-dev <!stage1>, libreadline-dev, libselinux1-dev [linux-any], libsystemd-dev [linux-any] <!stage1>, libtool, libudev-dev [linux-any] <!stage1>, netbase <!stage1 !nocheck>, pkg-config, po-debconf, socat <!stage1 !nocheck>, systemd [linux-any] <!stage1>, zlib1g-dev
Build-Conflicts: libedit-dev
Package-List:
 bsdextrautils deb utils optional arch=any profile=!stage1
 bsdutils deb utils required arch=any profile=!stage1 essential=yes
 eject deb utils optional arch=linux-any
 eject-udeb udeb debian-installer optional arch=linux-any profile=!noudeb
 fdisk deb utils important arch=any profile=!stage1
 fdisk-udeb udeb debian-installer optional arch=hurd-any,linux-any profile=!stage1,!noudeb
 libblkid-dev deb libdevel optional arch=any
 libblkid1 deb libs optional arch=any
 libblkid1-udeb udeb debian-installer optional arch=any profile=!noudeb
 libfdisk-dev deb libdevel optional arch=any
 libfdisk1 deb libs optional arch=any
 libfdisk1-udeb udeb debian-installer optional arch=any profile=!noudeb
 libmount-dev deb libdevel optional arch=linux-any
 libmount1 deb libs optional arch=any
 libmount1-udeb udeb debian-installer optional arch=linux-any profile=!noudeb
 libsmartcols-dev deb libdevel optional arch=any
 libsmartcols1 deb libs optional arch=any
 libsmartcols1-udeb udeb debian-installer optional arch=any profile=!noudeb
 libuuid1 deb libs optional arch=any
 libuuid1-udeb udeb debian-installer optional arch=any profile=!noudeb
 mount deb admin required arch=linux-any profile=!stage1
 rfkill deb utils optional arch=linux-any profile=!stage1
 util-linux deb utils required arch=any profile=!stage1 essential=yes
 util-linux-locales deb localization optional arch=all profile=!stage1
 util-linux-udeb udeb debian-installer optional arch=any profile=!stage1,!noudeb
 uuid-dev deb libdevel optional arch=any
 uuid-runtime deb utils optional arch=any profile=!stage1
Checksums-Sha1:
 4e85e2f533ef0fe79a4505695453a91f25e87605 5621624 util-linux_2.37.2.orig.tar.xz
 cebb2b9df6f546fb89ae5b7c9ee910a414debeca 107608 util-linux_2.37.2-4ubuntu3.debian.tar.xz
Checksums-Sha256:
 6a0764c1aae7fb607ef8a6dd2c0f6c47d5e5fd27aa08820abaad9ec14e28e9d9 5621624 util-linux_2.37.2.orig.tar.xz
 32a90e1c58d352ec9619d92b12676797d222196115b737fb522c33ee99d89a9f 107608 util-linux_2.37.2-4ubuntu3.debian.tar.xz
Files:
 d659bf7cd417d93dc609872f6334b019 5621624 util-linux_2.37.2.orig.tar.xz
 a607b39602813a2dd445f363bbc5bd36 107608 util-linux_2.37.2-4ubuntu3.debian.tar.xz
Original-Maintainer: util-linux packagers <util-linux@packages.debian.org>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEiiBE+E9xaoW3f/djEd9ClMyjmJMFAmIS78oACgkQEd9ClMyj
mJPGsg//aHjxsezZr9LQf/ouBmVuKlockBv6cf/QgwEsUBatFi9krmesmli4zUwA
UKETerpMi2S6w7AxjZ8srCB2lZ+0U5dB1CkdHf+ROFnHYgznO/ctmSmsHgn4ctlW
cL4AZKznOJ4EUaX0xgpF6nDSMo2sQEUSdGXB8QL/1qu4dw3fRU+v3s0qEPNTvdn/
/YU03vO6WUkLjA+J/efv2mNFm9sejyqaJDJ0ZZJJKaxWQaiqg2b82JKAZfy6qu/e
zGTOqENRhfuKv79D+DfIDEuuo5cORU2tIPjgw5vB2+f+arzhfE6lGboM2yY/r/zb
I5yXjCWWbASM59QsrdN5dRTgZQZCZh+j324i6Qzp8ad1O8XEcwFjnLvhUhXZfw33
L8hRglLhEEZt/3LHxTWRY/xmR4+0/P3tAC2gvNTKrkXl2kQIZxeA6qQ/7AOaHlcR
Xba6HFFX+aXgxMQFNdKJ+b4uBTqR7htBmZzfkYiYslDg1jivIlaJyJl/CkOCTSCV
2CSTKPIwAtdsqL5gq/AbXhLL8QFwKTYkha8wJReEbBuRWXiOdJZb+Ga4E3gNsw1Z
qzPQnrHwZD4Du6GUsn5hJwmwKSVH9s0ZPW7/YBFLrldGPNE+UnjlayqQMBVhGkk0
PKddDHg4KGn3j5/zm7qNk1gdKSHbC9rmmzx4YPs85CnpkBmnT6k=
=kLNV
-----END PGP SIGNATURE-----
