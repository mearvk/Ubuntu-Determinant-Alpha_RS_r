-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: libproxy
Binary: libproxy1v5, libproxy1-plugin-gsettings, libproxy1-plugin-kconfig, libproxy1-plugin-networkmanager, libproxy1-plugin-webkit, libproxy-dev, libproxy-tools, python3-libproxy
Architecture: any all
Version: 0.4.17-2
Maintainer: Debian GNOME Maintainers <pkg-gnome-maintainers@lists.alioth.debian.org>
Uploaders: Iain Lane <laney@debian.org>, Jeremy Bicha <jbicha@debian.org>, Laurent Bigonville <bigon@debian.org>
Homepage: https://libproxy.github.io/libproxy/
Standards-Version: 4.5.1
Vcs-Browser: https://salsa.debian.org/gnome-team/libproxy
Vcs-Git: https://salsa.debian.org/gnome-team/libproxy.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, pkg-config, python3-all
Build-Depends: debhelper-compat (= 13), dh-sequence-gnome, dh-sequence-python3, netbase <!nocheck>, cmake, zlib1g-dev, libnm-dev [linux-any], libdbus-1-dev, libkf5config-bin <!nocheck !stage1>, libwebkit2gtk-4.0-dev <!nocheck !stage1>, libjavascriptcoregtk-4.0-dev <!stage1>, libglib2.0-dev (>= 2.26) <!stage1>, libxmu-dev <!nocheck !stage1>
Build-Depends-Indep: python3-all
Package-List:
 libproxy-dev deb libdevel optional arch=any
 libproxy-tools deb utils optional arch=any
 libproxy1-plugin-gsettings deb libs optional arch=any profile=!stage1
 libproxy1-plugin-kconfig deb libs optional arch=any profile=!stage1
 libproxy1-plugin-networkmanager deb libs optional arch=linux-any
 libproxy1-plugin-webkit deb libs optional arch=any profile=!stage1
 libproxy1v5 deb libs optional arch=any
 python3-libproxy deb python optional arch=all
Checksums-Sha1:
 cded2be341aa15bb1dc4ba574c0687e2ba8d59b2 95542 libproxy_0.4.17.orig.tar.gz
 166f1cf3c02b92fcdea0cb585880f287bc13b5f6 13652 libproxy_0.4.17-2.debian.tar.xz
Checksums-Sha256:
 88c624711412665515e2800a7e564aabb5b3ee781b9820eca9168035b0de60a9 95542 libproxy_0.4.17.orig.tar.gz
 9c6272e672d675ee8ca71ed95147956a9db125914671658910a629811aeee611 13652 libproxy_0.4.17-2.debian.tar.xz
Files:
 74af4aa1e7920f3b6117203d55a9c524 95542 libproxy_0.4.17.orig.tar.gz
 9a0e043426ae2862a0b6edd0bc0c8e0e 13652 libproxy_0.4.17-2.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEETQvhLw5HdtiqzpaW5mx3Wuv+bH0FAmI9+XoACgkQ5mx3Wuv+
bH1KEA//TywO+G05kZkUhq0DjlIGQiQ/zXxY8NznC4FtC6ngeD+zo71FcLbJ6iRt
0YpIxs0u4LJwGc02CUl8xf++O4XAOeZk6C5vIYFPkMLCQSdeLXICyHgmGBM1Nfw/
KrhKRjerjxkGE0dfiZj9q09YIvzmzatWymCLGnOlmcD4xvi1IcTEs5OUwvQtmywu
fuQX648oVNJvvpC6AvS26hfVIwBry+W+8bhI0Al4ztybKpK7/qjTwu/52zIDQ4Gt
5navMw64nTQgQ5bUWfxE+qe7qdSD7qFDnVVVS2BwpBtW8cLbYYylmGJZHzYqHHCA
mACuro5/eSMHsAR5ktdpn//A9ILQLSb7x3qQriuZ43q0j3EaZHAQhtFpqXhwWyqr
1bD0a+y7m+j23hlVOB4nQK5psHBc0BNWmW/B0Qww790zotwvXKU2TUgffP85d4Tx
rvtJWWmM0+GSL6Kr7gFacH+pw5LD5ggkZtvHYiHWzWa+Z9JDISwzVLf7YzA/4bqo
akLNwMroCAhzL3C1xpHUBezmeWo2e55XmQOuJUVhsZ5BdIhOcysi+67/4KbJrXdN
XEQlEiNMh3eJAbGCbJOt7Jv0gcuIfNpr6fJLEKh4zOPLfC0kly4Ou+r1R6cmkA2c
HeKsioJo3C7bkTvAVaVA9xsw4KjKReiDUYqSZAbvHuGQtAI/Akc=
=2gIL
-----END PGP SIGNATURE-----
