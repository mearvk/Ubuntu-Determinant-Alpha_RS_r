-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: multipath-tools
Binary: multipath-tools, kpartx, kpartx-boot, multipath-tools-boot, multipath-udeb, kpartx-udeb
Architecture: linux-any all
Version: 0.8.8-1ubuntu1.22.04.1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Guido Günther <agx@sigxcpu.org>, Ritesh Raj Sarraf <rrs@debian.org>, Chris Hofstaedtler <zeha@debian.org>
Homepage: http://christophe.varoqui.free.fr/
Standards-Version: 3.9.8
Vcs-Browser: https://salsa.debian.org/linux-blocks-team/multipath-tools
Vcs-Git: https://salsa.debian.org/linux-blocks-team/multipath-tools.git
Testsuite: autopkgtest
Testsuite-Triggers: fio, gdisk, lsscsi, open-iscsi, qemu-utils, tgt
Build-Depends: debhelper-compat (= 9), po-debconf, libdevmapper-dev, libreadline-dev, libaio-dev, libudev-dev, libsystemd-dev, systemd, liburcu-dev, pkg-config, libjson-c-dev
Package-List:
 kpartx deb admin optional arch=linux-any
 kpartx-boot deb admin optional arch=all
 kpartx-udeb udeb debian-installer optional arch=linux-any
 multipath-tools deb admin optional arch=linux-any
 multipath-tools-boot deb admin optional arch=all
 multipath-udeb udeb debian-installer optional arch=linux-any
Checksums-Sha1:
 8f9cb0520ba44b505bb8b2a15f3d8a6381f85225 527412 multipath-tools_0.8.8.orig.tar.gz
 c603fd8e426d8b5c1d79f48c0379e9770d6c820d 59968 multipath-tools_0.8.8-1ubuntu1.22.04.1.debian.tar.xz
Checksums-Sha256:
 ff45ddb18a1effbfbe5712f513dd3b7146c68141091fc1c2489af8d6197026ef 527412 multipath-tools_0.8.8.orig.tar.gz
 df2863851c1ba02e0636013b5d29ef9008956274d1d7f594bbe3c950fea8f4f8 59968 multipath-tools_0.8.8-1ubuntu1.22.04.1.debian.tar.xz
Files:
 57fa8b8c38802ed5d69c01155cad8d31 527412 multipath-tools_0.8.8.orig.tar.gz
 963c625a72f24646fb63fdc96fb202df 59968 multipath-tools_0.8.8-1ubuntu1.22.04.1.debian.tar.xz
Original-Maintainer: Debian DM Multipath Team <team+linux-blocks@tracker.debian.org>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEUMSg3c8x5FLOsZtRZWnYVadEvpMFAmNgMyIACgkQZWnYVadE
vpNw/w/5AfBFw69LcP3h7B6S26wWgzdlHWF+dahzpbbxMVjwD6ALldIQ9bHy5RcK
wK4bYg3NZbXmARi5AbnJkQ1O8eEdmWok9lNwBeLJA300Rh+t5Q6ccz8ilypFJgNw
RXlW7w+adcEjpxY0cAl/EqTTJL++x1PyDQcOMEzBY+PjG3fPTjHz9U9gToXs4D9Z
Shdp7LD80elZrpoSpjTCUqJ+SL0oC6R4jPhArDMSg8eXrqgutt+1+kKX7hUTYv56
wVcxlffgKXKwk61wjAJsbtShatwGT1lVmqF57NtDhbMNsoPNmX0gLkZ1x1AIkErm
H40+0GH9ncC0AUgn0yx5PyaPpklNF0VyGZ5lu9wL69v185xxSiMKlYHBKlH71E6R
BTOj2svACUQg9JNwBi9xq53tMCJ/DGk5o6mzJR17YIxaLgXPNwyPW8SnlhMLC4iw
3AKASe95ejG4O0qGSwFBUGBBPubsCn65nZyl+J/fvYlwxPjrMSMUE6KCc2VY2HbC
Anax7EMKqU3D90WjsDVI57cBAA3oq78AmG29JeDnhpsI4x3c11c7R25PZuxkVw1j
sJngqy9U/oq5fkU2wAtqTj7YT4NsHHb0vpcZ6wlzaz2ukRr9inINVmePsBIcaMA+
Yg0sTTKqISPUg1anWpEGcoywWHhOEn1q+ZewKPtQhfpWqa69v6Q=
=6KQN
-----END PGP SIGNATURE-----
