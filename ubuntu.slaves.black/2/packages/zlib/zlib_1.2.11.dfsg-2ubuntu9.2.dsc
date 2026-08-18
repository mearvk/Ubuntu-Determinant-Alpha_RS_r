-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: zlib
Binary: zlib1g, zlib1g-dev, zlib1g-udeb, lib64z1, lib64z1-dev, lib32z1, lib32z1-dev, libn32z1, libn32z1-dev, libx32z1, libx32z1-dev
Architecture: any
Version: 1:1.2.11.dfsg-2ubuntu9.2
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Homepage: http://zlib.net/
Standards-Version: 3.9.8
Build-Depends: debhelper (>= 8.1.3~), gcc-multilib [amd64 i386 kfreebsd-amd64 mips mipsel powerpc ppc64 s390 sparc s390x mipsn32 mipsn32el mipsr6 mipsr6el mipsn32r6 mipsn32r6el mips64 mips64el mips64r6 mips64r6el x32] <!nobiarch>, dpkg-dev (>= 1.16.1)
Package-List:
 lib32z1 deb libs optional arch=amd64,ppc64,kfreebsd-amd64,s390x profile=!nobiarch
 lib32z1-dev deb libdevel optional arch=amd64,ppc64,kfreebsd-amd64,s390x profile=!nobiarch
 lib64z1 deb libs optional arch=sparc,s390,i386,powerpc,mips,mipsel,mipsn32,mipsn32el,mipsr6,mipsr6el,mipsn32r6,mipsn32r6el,x32 profile=!nobiarch
 lib64z1-dev deb libdevel optional arch=sparc,s390,i386,powerpc,mips,mipsel,mipsn32,mipsn32el,mipsr6,mipsr6el,mipsn32r6,mipsn32r6el,x32 profile=!nobiarch
 libn32z1 deb libs optional arch=mips,mipsel profile=!nobiarch
 libn32z1-dev deb libdevel optional arch=mips,mipsel profile=!nobiarch
 libx32z1 deb libs optional arch=amd64,i386
 libx32z1-dev deb libdevel optional arch=amd64,i386
 zlib1g deb libs required arch=any
 zlib1g-dev deb libdevel optional arch=any
 zlib1g-udeb udeb debian-installer optional arch=any
Checksums-Sha1:
 1b7f6963ccfb7262a6c9d88894d3a30ff2bf2e23 370248 zlib_1.2.11.dfsg.orig.tar.gz
 924c41d76c623adaeed8a552de9347ae4263c6f4 60140 zlib_1.2.11.dfsg-2ubuntu9.2.debian.tar.xz
Checksums-Sha256:
 80c481411a4fe8463aeb8270149a0e80bb9eaf7da44132b6e16f2b5af01bc899 370248 zlib_1.2.11.dfsg.orig.tar.gz
 5678d0b3d1e609297e5a3dedfcb3474bab1cafe82c0c29aec2cef01e49a88d39 60140 zlib_1.2.11.dfsg-2ubuntu9.2.debian.tar.xz
Files:
 2950b229ed4a5e556ad6581580e4ab2c 370248 zlib_1.2.11.dfsg.orig.tar.gz
 3a124bc1f4ec6c897562c5186cdbd772 60140 zlib_1.2.11.dfsg-2ubuntu9.2.debian.tar.xz
Original-Maintainer: Mark Brown <broonie@debian.org>

-----BEGIN PGP SIGNATURE-----

iQFRBAEBCgA7FiEEYrygdx1GDec9TV8EZ0GeRcM5nt0FAmNJ14cdHHJvZHJpZ28u
emFpZGVuQGNhbm9uaWNhbC5jb20ACgkQZ0GeRcM5nt2Mdwf/fDgCBJpUN+9WmmWc
s8J+0NjJ1cF5R5RotlzfbdMTA9AH7KDdJDafw0cooREIEodtoUFGRU4VyP6G16pm
whOx4wk45lPv5nKm3xO03aumJzpwJGs4+egAyPnJYfypcUA8RjMM+hbtUa0W1gye
9PVpuBvjHfIOxsoff3iNM0HKliPH0/9hdNxAeoBL85laupZzIy20sNYGNl6O+PAH
51hCthJdZt8T4QEXYaY3ZNs2AGAl8TpMwemBHcFnSSFlKV+gHVIVJ2BaNkRd1tGR
g1DCQvgxKi0BprSdyrsU5fpsVF1FTCUDcuuEfbYTsBU55u7P5+YB4ArxgqBKfj80
uj1Sdg==
=44hU
-----END PGP SIGNATURE-----
