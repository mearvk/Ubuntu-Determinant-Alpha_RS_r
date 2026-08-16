-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (native)
Source: gem2deb
Binary: gem2deb, gem2deb-test-runner
Architecture: any
Version: 1.8
Maintainer: Debian Ruby Team <pkg-ruby-extras-maintainers@lists.alioth.debian.org>
Uploaders: Lucas Nussbaum <lucas@debian.org>, Antonio Terceiro <terceiro@debian.org>, Gunnar Wolf <gwolf@debian.org>, Cédric Boutillier <boutil@debian.org>, Christian Hofstaedtler <zeha@debian.org>, Georg Faerber <georg@debian.org>, Lucas Kanashiro <kanashiro@debian.org>
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/ruby-team/gem2deb
Vcs-Git: https://salsa.debian.org/ruby-team/gem2deb.git
Testsuite: autopkgtest
Testsuite-Triggers: @builddeps@, autopkgtest, build-essential, fakeroot, faketime, locales-all, moreutils, reprotest
Build-Depends: dctrl-tools <!nocheck>, debhelper-compat (= 13), devscripts <!nocheck>, dpkg-dev (>= 1.17.14), python3-debian <!nocheck>, rake <!nocheck>, ruby (>= 1:2.1.0.3~), ruby-all-dev (>= 1:2.5), ruby-mocha <!nocheck>, ruby-rspec <!nocheck>, ruby-shoulda-context <!nocheck>, ruby-test-unit <!nocheck>
Package-List:
 gem2deb deb ruby optional arch=any
 gem2deb-test-runner deb ruby optional arch=any
Checksums-Sha1:
 8ef5802479adbcab3eeba73947adf0faf3744c8c 72136 gem2deb_1.8.tar.xz
Checksums-Sha256:
 375b2761d88241525ecd702e96eb029d0cc5128117f03e23db9b5f319d547ddb 72136 gem2deb_1.8.tar.xz
Files:
 53d2d922a0bc6780730b019323410a89 72136 gem2deb_1.8.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEst7mYDbECCn80PEM/A2xu81GC94FAmGuK9MACgkQ/A2xu81G
C94VwQ/9HS+EuTZrTudoPAA/U+gLnYjG8VE4ApZn7JpF9vRJFGyafJnPQSi76s0D
DZY2PugDLy8HkWwf1E3VgLPmhdYLTfkWZYAAoAfmYmojHND8g1C4PjmD4E6W/gez
tNT0Zbp1GdlwJou4E3T7DDFkypb4SWq0Lr5z+WxUxxzcRXnK0Jy2BktCDBgbGQQd
ynpDrhQcSpWqN6EajJbQYRIu6HG3UYSmppoDpW2O2dQVB5oJAnsZf2ed5iCRLzxP
3/8TWqtRhGy+6GK+nFHv8xlwNHS5TAtkbMhlrdKrs7jV027czFrsOP6kYtGSF1qd
hv5b+VxlwcXje1EsRq7ghrYQzNGWayCN6O82wu9DRWe5nj71rJjzW0dn6yk7ReA4
TI9OA0HEKiSGytC1vB3ORlSV3l9WE3e0bGYJgvyGr1H4VRFCp8Md05i/4VZmPYa9
Yv/cYq4RsHcmU2zZW0RXvgspFrUzF/LxHRUfh/VHpzTanNMOuy2WEDYjyFSjRjRJ
eY6uJhmW7frSYcHdtVyC0/hy2nw9M5o7CvIXPGInIk+QCYDZ2eR02x3DCOHfjBLP
gRD3uA+TS++03LpgSfTzQMLgbzZzxEFF4dhpUvT/63uMqZ6nly1t8Qb+lBPviWGx
NNbwZdQC/FpbANefFJwpB/AONIupMB+JAgqqkBuAuX3kKL4lrpA=
=b1uo
-----END PGP SIGNATURE-----
