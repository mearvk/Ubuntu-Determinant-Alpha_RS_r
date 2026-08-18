-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: readline
Binary: libreadline8, lib64readline8, readline-common, libreadline-dev, lib64readline-dev, rlfe, lib32readline8, lib32readline-dev, readline-doc
Architecture: any all
Version: 8.1.2-1
Maintainer: Matthias Klose <doko@debian.org>
Standards-Version: 4.5.1
Build-Depends: debhelper (>= 11), libncurses-dev, lib32ncurses-dev [amd64 ppc64], lib64ncurses-dev [i386 powerpc sparc s390], mawk | awk, texinfo, gcc-multilib [amd64 i386 kfreebsd-amd64 powerpc ppc64 s390 sparc]
Package-List:
 lib32readline-dev deb libdevel optional arch=amd64,ppc64
 lib32readline8 deb libs optional arch=amd64,ppc64
 lib64readline-dev deb libdevel optional arch=i386,powerpc,s390,sparc
 lib64readline8 deb libs optional arch=i386,powerpc,s390,sparc
 libreadline-dev deb libdevel optional arch=any
 libreadline8 deb libs optional arch=any
 readline-common deb utils optional arch=all
 readline-doc deb doc optional arch=all
 rlfe deb utils optional arch=any profile=!cross
Checksums-Sha1:
 8a05ad0d0ad67e18c383f1b2cf6a23bcbd46f87a 2993073 readline_8.1.2.orig.tar.gz
 a365093734fa5c6af4011439afe84c0f21283fdd 29292 readline_8.1.2-1.debian.tar.xz
Checksums-Sha256:
 7589a2381a8419e68654a47623ce7dfcb756815c8fee726b98f90bf668af7bc6 2993073 readline_8.1.2.orig.tar.gz
 0c39840fbed2abd3f93083d75c974e39855fd41aa6df5fa1be06d147e86071ca 29292 readline_8.1.2-1.debian.tar.xz
Files:
 12819fa739a78a6172400f399ab34f81 2993073 readline_8.1.2.orig.tar.gz
 4dffaaaa0ef5368c2fb31a8f3893b3bd 29292 readline_8.1.2-1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQJEBAEBCAAuFiEE1WVxuIqLuvFAv2PWvX6qYHePpvUFAmHXH1AQHGRva29AZGVi
aWFuLm9yZwAKCRC9fqpgd4+m9ZzrEACjwk5dS9f8v8PIWui2m7S0ARwPQKbycVp1
vf3nKKGAsytjv0gwCYH9r1r0C+c9iZdGOOk0xqFZfndJ+C0NNBPQQROX49qSuePs
rKsTAx2rCW88//S2i7foaNNE1ILeO0KZ1vaVdW2Ee2wKQmOiipKE0v9cIG13buiH
KqXVfbIjuukyRQqfRN9Rssk6XpFAy30dtM2wB9ip0cR4I3XCC47cu6wEBLMvaRC7
izAWgk1nh2kG+8kW56bg2ofttDJkjhyjrJ2cHBPMLPaxjcJBkokTQ9HRVes7VFRK
fVtAVhxfyLtk2H4Ke3kj+r6YlLI7O6IsqbXRVJblqzB4KLjDE+ffVetd9EqjcaME
75cpNlqrS4Z6gEMBFHqZtQa5Z8O8nmbq8we7m0gCsnph98vs88wI/xkJZv2vuk6H
N7451fjxlMe6fk3M30RL4C2FRoq1vTxOSR9FxL7O3IEJjKyNuQ72GshHkmvEqIv2
xr2QlXPE4W4EvWamtPuJ+5ky1cpwzkPdb1YDKhSU8ss7k2Ibr6vvzhbhx/iHYXeD
HYzKu6E1XQzuJfJfrFluv+2vqa6oyiOccyMqGbhWzXAU2fLvjYZtxS0caBwNvJUf
/+iW3zMNa++GrVynTa81azImSz+VZdLuTnrywStFmQOXMPurQk0VIlUff0oyH979
Z+EbX9zKxw==
=4p9N
-----END PGP SIGNATURE-----
