-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: e2fsprogs
Binary: fuse2fs, logsave, e2fsck-static, e2fsprogs-l10n, libcom-err2, comerr-dev, libss2, ss-dev, e2fsprogs-udeb, libext2fs2, libext2fs-dev, e2fsprogs
Architecture: any all
Version: 1.46.5-2ubuntu1.1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Homepage: http://e2fsprogs.sourceforge.net
Standards-Version: 4.6.0
Vcs-Browser: https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
Vcs-Git: https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git -b debian/master
Testsuite: autopkgtest
Testsuite-Triggers: fuse3
Build-Depends: gettext, texinfo, pkg-config, libfuse-dev [linux-any kfreebsd-any] <!pkg.e2fsprogs.no-fuse2fs>, debhelper-compat (= 12), dh-exec, libblkid-dev, uuid-dev, m4, udev [linux-any], systemd [linux-any], cron [linux-any]
Package-List:
 comerr-dev deb libdevel optional arch=any
 e2fsck-static deb admin optional arch=any profile=!pkg.e2fsprogs.no-static
 e2fsprogs deb admin required arch=any
 e2fsprogs-l10n deb localization optional arch=all
 e2fsprogs-udeb udeb debian-installer optional arch=any profile=!noudeb
 fuse2fs deb admin optional arch=linux-any,kfreebsd-any profile=!pkg.e2fsprogs.no-fuse2fs
 libcom-err2 deb libs optional arch=any
 libext2fs-dev deb libdevel optional arch=any
 libext2fs2 deb libs optional arch=any
 libss2 deb libs optional arch=any
 logsave deb admin optional arch=any
 ss-dev deb libdevel optional arch=any
Checksums-Sha1:
 5eb29684be3d0b1b4379afb1e0631fd4cca7ae0e 9530158 e2fsprogs_1.46.5.orig.tar.gz
 fe5bb09669451d775a4e1c09408e669d468e090b 488 e2fsprogs_1.46.5.orig.tar.gz.asc
 9ce9bd72ee44d2d26e52b2591f0a15a62c2a44fe 85972 e2fsprogs_1.46.5-2ubuntu1.1.debian.tar.xz
Checksums-Sha256:
 b7430d1e6b7b5817ce8e36d7c8c7c3249b3051d0808a96ffd6e5c398e4e2fbb9 9530158 e2fsprogs_1.46.5.orig.tar.gz
 b1e248ed73d4d67ac0cf7760e780e0a5cd2db85bbb9a5dcc235538b596128916 488 e2fsprogs_1.46.5.orig.tar.gz.asc
 9b4357c7700766c109d4573707e7c251727e269a73d5cc58b62b6632fbac0c38 85972 e2fsprogs_1.46.5-2ubuntu1.1.debian.tar.xz
Files:
 3da91854c960ad8a819b48b2a404eb43 9530158 e2fsprogs_1.46.5.orig.tar.gz
 56db20f3239234854c3dcbc864dcfeaf 488 e2fsprogs_1.46.5.orig.tar.gz.asc
 fed3e33745ec59b1bab0a7180aaecd62 85972 e2fsprogs_1.46.5-2ubuntu1.1.debian.tar.xz
Original-Maintainer: Theodore Y. Ts'o <tytso@mit.edu>

-----BEGIN PGP SIGNATURE-----

iQJNBAEBCgA3FiEELTsQ/oZuJMqL99Qt1guDyQUTvU8FAmKZeTcZHG1hcmsuZXNs
ZXJAY2Fub25pY2FsLmNvbQAKCRDWC4PJBRO9T7m2D/4zKjD+M1LIRM67EEwRxup+
6fYCJGdzbvZABh6SZlLSRGhJvIJCXQDFNGQAPZhZKJQhdyXsflGVdrxBjF1vBvDg
TLTHJ/Ge3xAei5WPr5Gxl9H4/IZDs44K4kd5UTaNLMSY8UfN0UiS9YBVnsCsG36p
Aa/+ETcrmcfUe54pfYKH20pphK9f1W4ZxDa44iJbsOPweOHEzsU6YBYv5W4+FXwc
XpO0fbsmIxLSXtUGz1wFI8ZjxBDNN+e+jIX4MadhFLcNZ5NYYY34q/FerfR5WrXd
JP8aQN20ReEJRX8oBTXBCclQD4ElNIOT8iqOVjZQYAJSEzl7jqR1cA7aoOGBB9Ww
f1x284JAZCLgpaMQLz7SIjFNVpTNNUNwE0f0NagTzzOlKC7mv3LGhi2oz/t/3Z3e
XodcFOI3RDNp6g6GebmicQI+zApeCeShRe+gk75vxFWs+k2UzQ8AjqS7H7JaFPVU
fiqSQEN/hXckWw+shhb1L44tiLdAAyUbaWAGF8P2Aoi2UDxHeIkGx/QbVa9TwwZ4
Lg70S5rgT60sKqDN5tm5s3Gr6eU3CeJwK6fQIqz1dOorAMMwby8LTamrgXKANac1
Df1vzsMKT7HPZxPiAkBq6b8sr+qoT7kV+iyrCHLJfXE6lPWR2MsYjHqcG4u3sLcH
yZS3h78SeB9WvcbvqTsNvA==
=Q3zV
-----END PGP SIGNATURE-----
