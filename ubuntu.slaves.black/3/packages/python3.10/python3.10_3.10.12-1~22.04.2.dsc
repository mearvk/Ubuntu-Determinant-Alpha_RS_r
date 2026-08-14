-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: python3.10
Binary: python3.10, python3.10-venv, libpython3.10-stdlib, python3.10-minimal, python3.10-nopie, libpython3.10-minimal, libpython3.10, python3.10-examples, python3.10-dev, libpython3.10-dev, libpython3.10-testsuite, idle-python3.10, python3.10-doc, python3.10-dbg, libpython3.10-dbg, python3.10-full
Architecture: any all
Version: 3.10.12-1~22.04.2
Maintainer: Matthias Klose <doko@debian.org>
Standards-Version: 4.6.2
Vcs-Browser: https://salsa.debian.org/cpython-team/python3/tree/python3.10
Vcs-Git: https://salsa.debian.org/cpython-team/python3.git -b python3.10
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, python3-pip, python3-setuptools, python3-wheel-whl, shunit2, virtualenv
Build-Depends: debhelper (>= 11), dpkg-dev (>= 1.17.11), quilt, autoconf, lsb-release, sharutils, libreadline-dev | libeditreadline-dev, libncursesw5-dev (>= 5.3), zlib1g-dev, libbz2-dev, liblzma-dev, libgdbm-dev, libdb-dev, tk-dev, blt-dev (>= 2.4z), libssl-dev, libexpat1-dev, libmpdec-dev (>= 2.5.1~), libbluetooth-dev [linux-any] <!pkg.python3.10.nobluetooth>, locales-all, libsqlite3-dev, libffi-dev (>= 3.0.5) [!or1k !avr32], libgpm2 [linux-any], media-types | mime-support, netbase, bzip2, time, python3:any, python3.10:any <cross>, net-tools, xvfb <!nocheck>, xauth <!nocheck>, systemtap-sdt-dev, valgrind [!riscv64]
Build-Depends-Indep: python3-sphinx, python3-docs-theme, texinfo
Package-List:
 idle-python3.10 deb python optional arch=all
 libpython3.10 deb libs optional arch=any
 libpython3.10-dbg deb debug optional arch=any
 libpython3.10-dev deb libdevel optional arch=any
 libpython3.10-minimal deb python optional arch=any
 libpython3.10-stdlib deb python optional arch=any
 libpython3.10-testsuite deb libdevel optional arch=all
 python3.10 deb python optional arch=any
 python3.10-dbg deb debug optional arch=any
 python3.10-dev deb python optional arch=any
 python3.10-doc deb doc optional arch=all
 python3.10-examples deb python optional arch=all
 python3.10-full deb python optional arch=any
 python3.10-minimal deb python optional arch=any
 python3.10-nopie deb python optional arch=any
 python3.10-venv deb python optional arch=any
Checksums-Sha1:
 85e043a6cd30835bdf95e3db2d1b4b15e142d067 19654836 python3.10_3.10.12.orig.tar.xz
 46ca6facf5fce1ff34e3d51adb75955da244e458 218484 python3.10_3.10.12-1~22.04.2.debian.tar.xz
Checksums-Sha256:
 afb74bf19130e7a47d10312c8f5e784f24e0527981eab68e20546cfb865830b8 19654836 python3.10_3.10.12.orig.tar.xz
 4c19cf9f70e9710254e8f9fb5e8b2c0a0561265996d4278778e53f2520af5296 218484 python3.10_3.10.12-1~22.04.2.debian.tar.xz
Files:
 49b0342476b984e106d308c25d657f12 19654836 python3.10_3.10.12.orig.tar.xz
 8223771ee103c1caac1b350d4fdb3668 218484 python3.10_3.10.12-1~22.04.2.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQJEBAEBCAAuFiEE1WVxuIqLuvFAv2PWvX6qYHePpvUFAmSFW08QHGRva29AdWJ1
bnR1LmNvbQAKCRC9fqpgd4+m9QJ7D/99/YkwhkuXiKiHMWonBzJgYNwpj0IZLIrL
aTmkPLUd6vRB7PM4EkSEfCfOo6CuT8tmzGbXGg4KaQ+uOR9bEj597zPRcyuDvGgo
sp0kbSEBM21QnLFwjBp28u5ijSgPrYMUWCJlvFdT4ENZMhz3YFKvvVOSyKGFkTrY
cZAw0K2jKzvCxGcKWn/+LgyDXsILLfjcmGA8f1NMTkBdiewMW4sLaTlqni/7Qy1M
VxS11UK0iQSZR3InWef0SIowi8l9XPApb61Ib0OjSd2bSS+Y0ZxxSTXD+sCl7eLK
3zSsd8/9VLV3iJBlmi+f+kzJGFiM6BorJhB7wTq3bv8d6UWbxLd4WNDhz57XUrXq
Dd7ev7AALQ5LUfJ9KQpF2O22VxX++QNMb8BOLwFORXeYxrGNkwXQiajhg0R0PuoX
wH6Q1OipR4Ol1RmenaVUOwXyhVo6V2Xz7Z2CO3eqLWWFNVIqLHKhynZITe94Bncc
tr43LOO1bYQcPlX6DH9v8119FK/bye5XeyMGLuaWuKV2yshiqvPw9xuN0CY6UEdg
5glq0XkivUeEf6a4AkdYprwZ0gqexYO3DKmdu5DpLutMSle/+cqfjC4RVyDiLUeq
ANujAVsDV8cHn8k6RIg/Pc6ArXAsdGcLxRRNNztCi9RK++Nk+m0RdqXYJMRy5biI
tBZTyCQ1AQ==
=FRZa
-----END PGP SIGNATURE-----
