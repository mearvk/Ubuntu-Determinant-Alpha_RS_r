-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (native)
Source: initramfs-tools
Binary: initramfs-tools, initramfs-tools-core, initramfs-tools-bin
Architecture: any all
Version: 0.140ubuntu13.2
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Michael Prokop <mika@debian.org>, Ben Hutchings <benh@debian.org>
Standards-Version: 4.1.5
Vcs-Browser: https://git.launchpad.net/~ubuntu-kernel/ubuntu/+source/initramfs-tools/
Vcs-Git: git://git.launchpad.net/~ubuntu-kernel/ubuntu/+source/initramfs-tools
Testsuite: autopkgtest
Testsuite-Triggers: busybox, busybox-initramfs, curl, genext2fs, isc-dhcp-client, klibc-utils, linux-image-amd64, linux-image-generic, lsb-release, netplan.io, parted, python3, qemu-system, qemu-system-x86, shellcheck
Build-Depends: debhelper-compat (= 12), bash-completion, shellcheck [!i386] <!nocheck>, pkg-config, libudev-dev, netplan.io [!i386] <!nocheck>
Package-List:
 initramfs-tools deb utils optional arch=all
 initramfs-tools-bin deb utils optional arch=any
 initramfs-tools-core deb utils optional arch=all
Checksums-Sha1:
 e1c737c384879bb65c3301d4b3bbe00b001db770 134772 initramfs-tools_0.140ubuntu13.2.tar.xz
Checksums-Sha256:
 e9f56fcf111ef2acd727dbed69f4100f1bc946864510956f7b0465f109399de3 134772 initramfs-tools_0.140ubuntu13.2.tar.xz
Files:
 39d844c79134d2bef3385abfab2dde3e 134772 initramfs-tools_0.140ubuntu13.2.tar.xz
Original-Maintainer: Debian kernel team <debian-kernel@lists.debian.org>

-----BEGIN PGP SIGNATURE-----

iQGzBAEBCgAdFiEELia6gbrGuCtTbip9+b5w1tgxniEFAmSJqI4ACgkQ+b5w1tgx
niGLowv/eErjat8ABAmN1AkAKxDxtO5JtbQ38ZzsjzjGovNwquknZkt2J7aEUOwX
fOsG4g7IwbfDCWWHwPSrcx5ZoDImWixMRehZj9ar7sfc9pdny60z37gEZ2k6/vV4
pnGcPlc3CPqpLpmKTdTa7Dl4SN1lADU0tFpi4e7b6T4Wu4Q+ivaBKkFuA26Y2cA4
rTCdS0h3Sy72zUYtnVCE9bO1oqJNfZsj0Zs4/0bLn4pJJ0MaFsGt9tKdtMLBGZPG
E/IEFwx9I8dxTS5Eojecb/KQikKF6t2nv2fmAIyv1ieE9QQvCvh8R4ir58ZGAOAQ
IQipsdH/vfOjTcbDssO5FzjM16HWyz4OB5dE2FIplGqiutPYnI3Uha2v38mgIZKC
mNkpABuP9MY+pxxME6nxEl1LI7rzQG0o6Jln30eUR6s1b+IiI6CycL00cNCrqwa2
FOh/u/U128icSa2rpX0H8ptKaHWf/Byws1LkY1vITiRcRA9sOqQD89HcEsa1iXZ8
/Npgx6hl
=7UMN
-----END PGP SIGNATURE-----
