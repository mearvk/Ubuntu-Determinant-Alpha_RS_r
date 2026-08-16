-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: webkit2gtk
Binary: libjavascriptcoregtk-4.0-bin, libwebkit2gtk-4.0-doc, webkit2gtk-driver, libjavascriptcoregtk-4.0-18, libjavascriptcoregtk-4.0-dev, gir1.2-javascriptcoregtk-4.0, libwebkit2gtk-4.0-37, libwebkit2gtk-4.0-dev, gir1.2-webkit2-4.0, libjavascriptcoregtk-4.1-0, libjavascriptcoregtk-4.1-dev, gir1.2-javascriptcoregtk-4.1, libwebkit2gtk-4.1-0, libwebkit2gtk-4.1-dev, gir1.2-webkit2-4.1, libjavascriptcoregtk-6.0-1, libjavascriptcoregtk-6.0-dev, gir1.2-javascriptcoregtk-6.0, libwebkitgtk-6.0-4, libwebkitgtk-6.0-dev, gir1.2-webkit-6.0
Architecture: any all
Version: 2.40.4-0ubuntu0.22.04.1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Gustavo Noronha Silva <kov@debian.org>, Emilio Pozuelo Monfort <pochu@debian.org>, Alberto Garcia <berto@igalia.com>
Homepage: https://webkitgtk.org/
Standards-Version: 4.6.2
Vcs-Browser: https://salsa.debian.org/webkit-team/webkit
Vcs-Git: https://salsa.debian.org/webkit-team/webkit.git
Build-Depends: debhelper-compat (= 12), ccache [!i386 !m68k], bubblewrap (>= 0.3.1) [!alpha !ia64 !m68k !sh4 !sparc64 !hurd-any !kfreebsd-any], xdg-dbus-proxy [!alpha !ia64 !m68k !sh4 !sparc64 !hurd-any !kfreebsd-any], libseccomp-dev [!alpha !ia64 !m68k !sh4 !sparc64 !hurd-any !kfreebsd-any], cmake (>= 3.10), jdupes, libglib2.0-dev (>= 2.44.0), libharfbuzz-dev (>= 0.9.18), libcairo2-dev (>= 1.14.0), libfontconfig-dev, libfreetype-dev, libicu-dev, libgcrypt20-dev (>= 1.7.0), libhyphen-dev, liblcms2-dev, libmanette-0.2-dev (>= 0.2.4) [linux-any], libxslt1-dev (>= 1.1.7), libxml2-dev (>= 2.8), libsoup2.4-dev, libsoup-3.0-dev, libgtk-3-dev, libgtk-4-dev, libsqlite3-dev (>= 3.0), libsystemd-dev [linux-any], libgudev-1.0-dev [linux-any], libwoff-dev (>= 1.0.2), libwpebackend-fdo-1.0-dev [linux-any], gperf, bison, flex, ruby:native, unifdef, libjpeg-dev, libopenjp2-7-dev (>= 2.2.0), libpng-dev, libtasn1-6-dev, libwebp-dev, libxt-dev, libgstreamer1.0-dev (>= 1.14.0), libgstreamer-plugins-base1.0-dev (>= 1.14.0), libgstreamer-plugins-bad1.0-dev (>= 1.20.0), libenchant-2-dev, libsecret-1-dev, gobject-introspection (>= 1.32.0), libgirepository1.0-dev (>= 0.9.12-4), ninja-build, libegl-dev, libgl-dev, libgles-dev
Build-Depends-Indep: gi-docgen, libglib2.0-doc, libgtk-3-doc, libsoup2.4-doc
Package-List:
 gir1.2-javascriptcoregtk-4.0 deb introspection optional arch=any
 gir1.2-javascriptcoregtk-4.1 deb introspection optional arch=any
 gir1.2-javascriptcoregtk-6.0 deb introspection optional arch=any
 gir1.2-webkit-6.0 deb introspection optional arch=any
 gir1.2-webkit2-4.0 deb introspection optional arch=any
 gir1.2-webkit2-4.1 deb introspection optional arch=any
 libjavascriptcoregtk-4.0-18 deb libs optional arch=any
 libjavascriptcoregtk-4.0-bin deb interpreters optional arch=any
 libjavascriptcoregtk-4.0-dev deb libdevel optional arch=any
 libjavascriptcoregtk-4.1-0 deb libs optional arch=any
 libjavascriptcoregtk-4.1-dev deb libdevel optional arch=any
 libjavascriptcoregtk-6.0-1 deb libs optional arch=any
 libjavascriptcoregtk-6.0-dev deb libdevel optional arch=any
 libwebkit2gtk-4.0-37 deb libs optional arch=any
 libwebkit2gtk-4.0-dev deb libdevel optional arch=any
 libwebkit2gtk-4.0-doc deb doc optional arch=all profile=!nodoc
 libwebkit2gtk-4.1-0 deb libs optional arch=any
 libwebkit2gtk-4.1-dev deb libdevel optional arch=any
 libwebkitgtk-6.0-4 deb libs optional arch=any
 libwebkitgtk-6.0-dev deb libdevel optional arch=any
 webkit2gtk-driver deb web optional arch=any
Checksums-Sha1:
 aa59fc3d09fd4c4dca1036fbd053478cea9a1e34 40065340 webkit2gtk_2.40.4.orig.tar.xz
 0c24146182a83aa3eff348e38677fc59bdcebb69 195 webkit2gtk_2.40.4.orig.tar.xz.asc
 9044d1134be09235f4325c87ff0596887d9fd1fe 80648 webkit2gtk_2.40.4-0ubuntu0.22.04.1.debian.tar.xz
Checksums-Sha256:
 8d163379297a2f7f51b455127f99836d9fe1572289f77b630ff3d63a2cb06dac 40065340 webkit2gtk_2.40.4.orig.tar.xz
 f56b22537a2c22c85e85e9932c80434c3fffcbc0a466d03f523a0b9e77e79b3e 195 webkit2gtk_2.40.4.orig.tar.xz.asc
 97f39cb8ea3fdeee69372e8580d5c302d9f0675a366835048f6eef4b5efb4e6b 80648 webkit2gtk_2.40.4-0ubuntu0.22.04.1.debian.tar.xz
Files:
 cca3e9f0605dad0a4fa0a7d12c09eed5 40065340 webkit2gtk_2.40.4.orig.tar.xz
 49cf39f61b1b7f07de911d7bfc69f7f9 195 webkit2gtk_2.40.4.orig.tar.xz.asc
 e534b676d633b71a29249751eb18282f 80648 webkit2gtk_2.40.4-0ubuntu0.22.04.1.debian.tar.xz
Original-Maintainer: Debian WebKit Maintainers <pkg-webkit-maintainers@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEUMSg3c8x5FLOsZtRZWnYVadEvpMFAmS9dVIACgkQZWnYVadE
vpN8qQ//bWRXSkZWtRVsSQQhq5d8+WmiV7j0IBWX/gxMaueVvDKqkPVfYats7ti2
eUtY64tfd92v/Z18+f4v5BBs+8tlujBElCWjRPQ+yp+hoIoSAXMYjH29LUp3Y4aI
TwUiHcxo6Dr2c7HNWZkcF3QAOfn1lZ3i9koOxeI8KNgkSOxaeM1w3zpozjobX273
P9Ev/kBSK4KQMJlEnWNYKRdk3E4TF7IemvThIZJOCARfuA7PjqzSAUVvOM7aCsMn
02Xl1MdEIK6W/fhbJkmT5nNsQUY7o1GWOLB2Sr85C3ZCRxpU7NaEwM70mlVQFf4g
/P4ca+T+dc8/XI9rMoN/cPEav/UykRQlmZ+Tq8kZFJXwreDaV3BelFp6n/BERS/U
H5ZADEPvw82x5MOzzQ5534gKZNvB08l0ecmvw463pmEAoeUCRVJQuTJMfNoxhQbH
76RHoWtH23IRarffzAVQ6fSZdQL9vAN259jz7nBJvXIO8ckkb0TyrcY7AiEzE+oh
BARKvnJnhReVFlEJ7xisxNwnDxAUSV5ObJgCVqgyjRpFVZs9e0GiCkEEvfSb0+44
UF0hLZQouieMU2uzur78+UQwg3C1jcIeeONxFpKta1zff1CiIhHGDmj2H//gockq
PcnO4iTirdjx5zZfVGdCJJDe0t85wEA5SyZ2Hy0BAfVOWlNL/vY=
=mTHf
-----END PGP SIGNATURE-----
