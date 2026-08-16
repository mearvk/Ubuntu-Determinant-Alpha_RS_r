-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: erlang
Binary: erlang-base, erlang-asn1, erlang-common-test, erlang-crypto, erlang-debugger, erlang-dialyzer, erlang-diameter, erlang-doc, erlang-edoc, erlang-eldap, erlang-erl-docgen, erlang-et, erlang-eunit, erlang-ftp, erlang-inets, erlang-manpages, erlang-megaco, erlang-mnesia, erlang-observer, erlang-odbc, erlang-os-mon, erlang-parsetools, erlang-public-key, erlang-reltool, erlang-runtime-tools, erlang-snmp, erlang-ssh, erlang-ssl, erlang-syntax-tools, erlang-tftp, erlang-tools, erlang-wx, erlang-xmerl, erlang-dev, erlang-src, erlang-examples, erlang-jinterface, erlang-mode, erlang-nox, erlang-x11, erlang
Architecture: any all
Version: 1:24.2.1+dfsg-1ubuntu0.1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Sergei Golovan <sgolovan@debian.org>
Homepage: http://www.erlang.org/
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/erlang-team/packages/erlang
Vcs-Git: https://salsa.debian.org/erlang-team/packages/erlang.git
Build-Depends: debhelper (>= 10.0.0), autoconf (>= 2.71), openssl, libssl-dev, m4, libncurses5-dev, unixodbc-dev, bison, flex, ed, zlib1g-dev, libwxgtk3.0-gtk3-dev, libwxgtk-webview3.0-gtk3-dev, libx11-dev, dctrl-tools, xsltproc, libgl1-mesa-dev | libgl-dev, libglu1-mesa-dev | libglu-dev, libsctp-dev [linux-any], libsystemd-dev [linux-any], erlang-base:native <cross>
Build-Depends-Indep: libxml2-utils, fop, default-jdk | sun-java6-jdk
Build-Conflicts: autoconf2.13, libwxgtk2.4-dev, libwxgtk2.6-dev, libwxgtk2.8-dev
Package-List:
 erlang deb interpreters optional arch=all
 erlang-asn1 deb interpreters optional arch=any
 erlang-base deb interpreters optional arch=any
 erlang-common-test deb interpreters optional arch=any
 erlang-crypto deb interpreters optional arch=any
 erlang-debugger deb interpreters optional arch=any
 erlang-dev deb interpreters optional arch=any
 erlang-dialyzer deb interpreters optional arch=any
 erlang-diameter deb interpreters optional arch=any
 erlang-doc deb doc optional arch=all
 erlang-edoc deb interpreters optional arch=any
 erlang-eldap deb interpreters optional arch=any
 erlang-erl-docgen deb interpreters optional arch=any
 erlang-et deb interpreters optional arch=any
 erlang-eunit deb interpreters optional arch=any
 erlang-examples deb interpreters optional arch=all
 erlang-ftp deb interpreters optional arch=any
 erlang-inets deb interpreters optional arch=any
 erlang-jinterface deb interpreters optional arch=all
 erlang-manpages deb doc optional arch=all
 erlang-megaco deb interpreters optional arch=any
 erlang-mnesia deb interpreters optional arch=any
 erlang-mode deb interpreters optional arch=all
 erlang-nox deb interpreters optional arch=all
 erlang-observer deb interpreters optional arch=any
 erlang-odbc deb interpreters optional arch=any
 erlang-os-mon deb interpreters optional arch=any
 erlang-parsetools deb interpreters optional arch=any
 erlang-public-key deb interpreters optional arch=any
 erlang-reltool deb interpreters optional arch=any
 erlang-runtime-tools deb interpreters optional arch=any
 erlang-snmp deb interpreters optional arch=any
 erlang-src deb interpreters optional arch=all
 erlang-ssh deb interpreters optional arch=any
 erlang-ssl deb interpreters optional arch=any
 erlang-syntax-tools deb interpreters optional arch=any
 erlang-tftp deb interpreters optional arch=any
 erlang-tools deb interpreters optional arch=any
 erlang-wx deb interpreters optional arch=any
 erlang-x11 deb interpreters optional arch=all
 erlang-xmerl deb interpreters optional arch=any
Checksums-Sha1:
 96fb2774fb98917ee1bfaa0f10308480134e0411 47244736 erlang_24.2.1+dfsg.orig.tar.xz
 7a5f111f1d838b54c532e96b9128357d79f45a60 65832 erlang_24.2.1+dfsg-1ubuntu0.1.debian.tar.xz
Checksums-Sha256:
 68b6d4c549050bd3a524a7d6dba24fdda2ccf0b912944feabcb67561557f7594 47244736 erlang_24.2.1+dfsg.orig.tar.xz
 bd325ebd3d6259de96d57c148181efd0adcc83dc878e18fcd00bbc06039b7c25 65832 erlang_24.2.1+dfsg-1ubuntu0.1.debian.tar.xz
Files:
 9fb012ed598426b39205b162ffbda94e 47244736 erlang_24.2.1+dfsg.orig.tar.xz
 2b40eb86568d1d7993183efd5ecf749a 65832 erlang_24.2.1+dfsg-1ubuntu0.1.debian.tar.xz
Original-Maintainer: Debian Erlang Packagers <pkg-erlang-devel@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iQFOBAEBCgA4FiEEiOlTC8vdwgBRe16w9JjS2d59rZwFAmRI+j0aHGFsZXgubXVy
cmF5QGNhbm9uaWNhbC5jb20ACgkQ9JjS2d59rZxQVQf+KoGKJ0vV7DA4RKCqdYIT
8haqBE1v4tEkBq/R18NMcOAz8TAOIzk5w6rhibf4mneWLEWaze0H6gAcgJ7dzrLK
XMH0b3vQ48xXMAMmYt+PLnK6nroSszz4N+qbjX1lwJhaQ+EtHGEIzKWIpAiW4Orn
j+yRW7Euz0dHQb7+SlMaSCTgonAtSI1n8genO/MuqARL1bDltmCZOkPceo9socn6
p9xElTLM26LBT4Y+TpQbuv9fWprfSxDNxRZDGny42z/qQGJuQlmwkO46CZPTYk/W
JEleiMzPHQecEyy5Q+5/s2ck79mgOkx+jsB5wuV0RjCLmBIRKG0PLT4IbTikYYqO
ag==
=QygK
-----END PGP SIGNATURE-----
