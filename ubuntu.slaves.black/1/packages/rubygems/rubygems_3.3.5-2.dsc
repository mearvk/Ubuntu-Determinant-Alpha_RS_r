-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: rubygems
Binary: ruby-rubygems, ruby-bundler, bundler
Architecture: all
Version: 3.3.5-2
Maintainer: Debian Ruby Team <pkg-ruby-extras-maintainers@lists.alioth.debian.org>
Uploaders: Lucas Kanashiro <kanashiro@debian.org>
Homepage: https://rubygems.org
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/ruby-team/rubygems
Vcs-Git: https://salsa.debian.org/ruby-team/rubygems.git
Testsuite: autopkgtest, autopkgtest-pkg-ruby
Testsuite-Triggers: @builddeps@, build-essential, libxml2-dev, libz-dev
Build-Depends: debhelper-compat (= 13), gem2deb (>= 1), rake, ruby, ruby-dev, ruby-webrick (>= 1.7.0)
Package-List:
 bundler deb ruby optional arch=all
 ruby-bundler deb ruby optional arch=all
 ruby-rubygems deb ruby optional arch=all
Checksums-Sha1:
 839f6b6a363c55882ab8c6fc2cdaafd6854d978c 12927122 rubygems_3.3.5.orig.tar.gz
 8aff788970c187ae9c46c3b469be0ee355d46b9f 8392 rubygems_3.3.5-2.debian.tar.xz
Checksums-Sha256:
 594e40b446753dfa0489f3b8e55abc14c91b516f58c52ca45bb66a1f6cf3ccf5 12927122 rubygems_3.3.5.orig.tar.gz
 588806ea43fce71c7b3b68a3ad042d3d6a96077268a672f09fa2dc14dd97eba6 8392 rubygems_3.3.5-2.debian.tar.xz
Files:
 066de471c3686ef6755c626308dd6cf4 12927122 rubygems_3.3.5.orig.tar.gz
 d0988192883e3c3faa4a5ddeb85ad477 8392 rubygems_3.3.5-2.debian.tar.xz
Ruby-Versions: all

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEst7mYDbECCn80PEM/A2xu81GC94FAmH0FRIACgkQ/A2xu81G
C952YA//exvuwGSPCEa6oqkD/RnZDLKmUn8DM59AhDMBYq2C7Vgx1xjk5L0At5gp
LbjPFNnoc5ehgG97t/gUerZpIUkMAKSA5YfdBG6hDfJzQfQLGUtETKhcV/wjeixw
k+QrKDQTL2fpaOAelOPZh9Rt5W21C+cmZs+Vf849vD3pnwdShGWOZjMnLlIgCvjl
/HggO3vH+JAkKOUwnWxB+lpLjiA2OGmnTpmLeTtRiWItnMisS8UPCNf919Q9QoiK
WigYw7XbjLnzoDG6DXuF5y/07B1PPbbW6JTYl6BS0nD/gQWinUy56Uc4Wvdc0p73
oM59/SC64XtrxnfHjUi65HViZLwyLODLFC/0SkQJ3BL3VlFlEDeCq22N9mBgl3GW
ZnqGaBtxozjS5QIfLQJw6tqcw6Irh7R9CpQYG1MYyZqp7Y8YI5i/+T1F5x4Pl03W
ew/Y25vtPG3nZ9PfQjjdikfxNB4MFwVMRvTyyQ6h+JeLAVMTKXtOQoaeF2/uFKTF
igYH/cE3a8MilQWqCZZX/Ms3/aWtBk1hV4GfSzuT509haycMUkhhm/wrWHLjQ90b
MKcRvZPFlEOUGIu1d8Tiq5PSh8YiAhgxnqTFt5cr46pkMItrbdGYYk4Xuhmwunwe
rhPXFjDGca0+LPBYAn4gmFuVTZR0xzV9q+Oy8Q419WIKdxOMFDM=
=haQ+
-----END PGP SIGNATURE-----
