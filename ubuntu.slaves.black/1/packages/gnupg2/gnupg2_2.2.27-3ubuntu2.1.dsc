-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: gnupg2
Binary: gpgconf, gnupg-agent, gpg-agent, gpg-wks-server, gpg-wks-client, scdaemon, gpgsm, gpg, gnupg, gnupg2, gpgv, gpgv2, dirmngr, gpgv-udeb, gpgv-static, gpgv-win32, gnupg-l10n, gnupg-utils
Architecture: any all
Version: 2.2.27-3ubuntu2.1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders:  Eric Dorland <eric@debian.org>, Daniel Kahn Gillmor <dkg@fifthhorseman.net>, Christoph Biedl <debian.axhn@manchmal.in-ulm.de>,
Homepage: https://www.gnupg.org/
Standards-Version: 4.5.1
Vcs-Browser: https://salsa.debian.org/debian/gnupg2
Vcs-Git: https://salsa.debian.org/debian/gnupg2.git -b debian/main
Testsuite: autopkgtest
Testsuite-Triggers: debian-archive-keyring, gnupg1
Build-Depends: automake, autopoint, debhelper-compat (= 13), file, gettext, ghostscript, gpgrt-tools, imagemagick, libassuan-dev (>= 2.5.0), libbz2-dev, libcurl4-gnutls-dev, libgcrypt20-dev (>= 1.8.0), libgnutls28-dev (>= 3.0), libgpg-error-dev (>= 1.35), libksba-dev (>= 1.3.5), libldap2-dev, libnpth0-dev (>= 1.2), libreadline-dev, libsqlite3-dev, libusb-1.0-0-dev [!hurd-any], openssh-client <!nocheck>, pkg-config, texinfo, transfig, zlib1g-dev | libz-dev
Build-Depends-Indep: binutils-multiarch [!amd64 !i386], libassuan-mingw-w64-dev (>= 2.5.0), libgcrypt-mingw-w64-dev (>= 1.8.0), libgpg-error-mingw-w64-dev (>= 1.26-2~), libksba-mingw-w64-dev (>= 1.3.5), libnpth-mingw-w64-dev (>= 1.2), libz-mingw-w64-dev, mingw-w64
Package-List:
 dirmngr deb utils optional arch=any
 gnupg deb utils optional arch=all
 gnupg-agent deb oldlibs optional arch=all
 gnupg-l10n deb localization optional arch=all
 gnupg-utils deb utils optional arch=any
 gnupg2 deb oldlibs optional arch=all
 gpg deb utils optional arch=any
 gpg-agent deb utils optional arch=any
 gpg-wks-client deb utils optional arch=any
 gpg-wks-server deb utils optional arch=any
 gpgconf deb utils optional arch=any
 gpgsm deb utils optional arch=any
 gpgv deb utils important arch=any
 gpgv-static deb utils optional arch=any
 gpgv-udeb udeb debian-installer optional arch=any
 gpgv-win32 deb utils optional arch=all
 gpgv2 deb oldlibs optional arch=all
 scdaemon deb utils optional arch=any
Checksums-Sha1:
 d928d4bd0808ffb8fe20d1161501401d5d389458 7191555 gnupg2_2.2.27.orig.tar.bz2
 074c5b25470d9fb804f83b3bbeaa9ec26c05db72 66676 gnupg2_2.2.27-3ubuntu2.1.debian.tar.xz
Checksums-Sha256:
 34e60009014ea16402069136e0a5f63d9b65f90096244975db5cea74b3d02399 7191555 gnupg2_2.2.27.orig.tar.bz2
 acaa8b274a90385aa14ce794f972cf4a57fd4696b543b22d8ffc654d2359fd4f 66676 gnupg2_2.2.27-3ubuntu2.1.debian.tar.xz
Files:
 a9c002b5356103c97412955a1956ae0c 7191555 gnupg2_2.2.27.orig.tar.bz2
 ef779f315b40b87f1898fb9678af87c9 66676 gnupg2_2.2.27-3ubuntu2.1.debian.tar.xz
Original-Maintainer: Debian GnuPG Maintainers <pkg-gnupg-maint@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEUMSg3c8x5FLOsZtRZWnYVadEvpMFAmLDJ5YACgkQZWnYVadE
vpOCYQ//Wf6Lk9ErAFdE9GHYCQj/ovq8Ncwhvrc8EgSEuqme5iLJsxKTNbSOtKAq
5QPRS2lcqMYOuCrLFrM0Frm4zcpCCoyek42/zhe/gO31p8HcPZ3QhXCELqsfKaZo
mME8LdcgBZ/Q6elPqeoz2jaf87BfQJzafigqMoCgeAD5QwJehfIiqjEhSys5mZxb
D45r4CTyYLNT7drhV63abon7tTvad1wzK6UmTsrlFzpAAYsTpPzPDlRhDSg/1oml
uOUE69zgIOCcr+W0V/aAavf6PcyOdD3QeKl6Jcit4h4MZ+lYJvlFVaVuA5Cgw9NT
KZYup1fp3mKDsRU6JmO7aRrlJFDJzfY58IXPYbTFCqwewh+u1snUyIfER2ybWFEJ
YJ13yimRrLiXyDCgFyHcDPxxm7Lyab1Fhpyg2cuUWghrMBgEf0fCf7oYdAwTc4eA
mhExp3ybvjF/uwOSE2alcO+LkOgnqgK0XZ0dydZNGv4DxvGcGk0mk+pS69mdw0cL
EkTC9+kd9SRvPEr7g3LbbdVEK8otXTbeHEdwdl/iYclnMy8qnZbBG6YFTzq+TXPp
72Fpb1YTe6ApTPaTuzYBnpSFqFrNVDuSOwHeJ+H5KI0QWArfa2eE3PnQS9jIR7bi
tDtSJtA5kC3959c4yWcdExBXCndeCs7rS5d5tYj7Fa3TABjmZKE=
=vRhL
-----END PGP SIGNATURE-----
