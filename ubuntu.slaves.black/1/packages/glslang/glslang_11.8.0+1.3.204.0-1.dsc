-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.0
Source: glslang
Binary: glslang-tools, glslang-dev
Architecture: any
Version: 11.8.0+1.3.204.0-1
Maintainer: Debian X Strike Force <debian-x@lists.debian.org>
Uploaders: Timo Aaltonen <tjaalton@debian.org>
Homepage: https://github.com/KhronosGroup/glslang
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/xorg-team/vulkan/glslang
Vcs-Git: https://salsa.debian.org/xorg-team/vulkan/glslang.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, pkg-config
Build-Depends: debhelper-compat (= 13), cmake, pkg-config, python3:native, quilt, spirv-headers, spirv-tools (>= 2022.1+1.3.204.0)
Package-List:
 glslang-dev deb libdevel optional arch=any
 glslang-tools deb libdevel optional arch=any
Checksums-Sha1:
 516a846758bc2028e540c5e17d67e88ecc90e19b 3376826 glslang_11.8.0+1.3.204.0.orig.tar.gz
 4bcbf8d5135e5c7593dcfedfd1e1f4a9418b88f6 14111 glslang_11.8.0+1.3.204.0-1.diff.gz
Checksums-Sha256:
 34ba407fdc5305aad3f5acb8295fd31604ed3a9abb7edd9b4cf6363bbe0fca96 3376826 glslang_11.8.0+1.3.204.0.orig.tar.gz
 b4aa9a565d07cf0fe1aa063204a57a352e52962ed169ca1d71187fbfc71e2371 14111 glslang_11.8.0+1.3.204.0-1.diff.gz
Files:
 0d63ecd9f0fb722624fea0049c43e618 3376826 glslang_11.8.0+1.3.204.0.orig.tar.gz
 acc9e0e766c64a1d3e3af9ad68c66a3f 14111 glslang_11.8.0+1.3.204.0-1.diff.gz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEdS3ifE3rFwGbS2Yjy3AxZaiJhNwFAmIM+AQACgkQy3AxZaiJ
hNxdNA//Sb9ZFtyFQcvdg9ZQBSCmgIXE0Mxh9o9xa1LsXG3XBHr4alD0JODLjeXC
xnEAylVLrQYstBcougi9PKH2r3Q6IkF09Egp2CzFupAHM4g0ffOIOJmnk6TAELfP
W/M1wZzR9RUJf/83dh3fPTsiuxRGlQ0iz9BqiUWaKNPTYO5cEj0JKrvKwYIHpbUy
kUOuhg4VDaDtA2nm2i1EZNc1yK6fYG73kZ30YtITEaC/WtbwnFMkAHZSKmWrHEd6
eSB78RZwZjju89nBN6Hl/IponeQGjVy8vmTOn6b/5rrmnwjHY9rbtc2j01i2Wjvp
vGwrrjFdqq0+OAy50NUsyS5knujaCRdwleMlex6An665Fr2jLyoEmrzP/7eonTLK
AaiQGgiuAxXGUsy50GYW+m0N2A244me5rL77pAUWTQzjdjtJJLEZ1yr3b1DeWHAW
VYgZWy21GdN7LhiltZ8jV84DmMQsFzfh6gQ7BcDIXB75hSb4qGp4mrUqoGB7PV5Y
KqgVAJANZZTFtQy1khTfJ7FRCjkSBBTT3lyjcJgSL7WUzeAbuRCwbTHAHP8cm3BN
x+TFYqx7YoapsTtcvXO0OR+S//9G0UnwRPGbKNNf22w9rqqR0eX3q+aEH/Ba75Qk
tUGl9h47imJJTUnfopUGWR9cf9KFkKnXWMkyL4xB5BvGZ5ap3OM=
=1jMz
-----END PGP SIGNATURE-----
