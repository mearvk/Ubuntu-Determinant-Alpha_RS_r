-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: node-terser
Binary: node-terser, libjs-terser, uglifyjs.terser
Architecture: all
Version: 4.1.2-10
Maintainer: Debian Javascript Maintainers <pkg-javascript-devel@lists.alioth.debian.org>
Uploaders:  Jonas Smedegaard <dr@jones.dk>,
Homepage: https://terser.org/
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/js-team/node-terser
Vcs-Git: https://salsa.debian.org/js-team/node-terser.git
Testsuite: autopkgtest
Testsuite-Triggers: libtest-command-simple-perl, node-domino, node-source-map, nodejs, perl
Build-Depends: brotli, cmark-gfm <!nodoc>, debhelper-compat (= 12), help2man <!nodoc>, mocha <!nocheck>, node-acorn, node-commander (>= 7), node-escodegen <!nocheck>, node-semver <!nocheck>, node-source-map, pigz, rollup (>= 0.61.0)
Package-List:
 libjs-terser deb javascript optional arch=all
 node-terser deb javascript optional arch=all
 uglifyjs.terser deb javascript optional arch=all
Checksums-Sha1:
 0d510d9843143f359cda404e36c06441208f39ee 537041 node-terser_4.1.2.orig.tar.gz
 ccf82f30eb850862c3b1059577d1bf29a4f556dd 10308 node-terser_4.1.2-10.debian.tar.xz
Checksums-Sha256:
 c75c90204c3381fbc55bf4a58a234f7668f3e76c0fa67dcffdec32828dd33728 537041 node-terser_4.1.2.orig.tar.gz
 40fdf55be15fae42de97b80f3f53a94548cb154792098889ebd5504f9b3c4fff 10308 node-terser_4.1.2-10.debian.tar.xz
Files:
 362862258b2ae8cd5120336c5877a28d 537041 node-terser_4.1.2.orig.tar.gz
 13c306b8e73cf49f67e08d77bbc467a1 10308 node-terser_4.1.2-10.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEn+Ppw2aRpp/1PMaELHwxRsGgASEFAmH/+LgACgkQLHwxRsGg
ASEUOBAAmIX80Ucaodv4C+BWJCk8zy95Ae3k4Jo1R3PxuoF8F8/4DqnKprcMi19a
ioeH6DSAs46/hC6Zweg6T0VkUAZO92rXCtrvD4noUjvZvMaE6FYQbygAfMqS4ATE
N3fcyVnXc8ioub4HiWeVQ5pAQxqEpzpW7q1fnHaIjOVPDJVWdRpq95PQSCNNUb2x
LtU5tn1vwm4J2w6ams7cPKhrzeaWksQhiqW4jlCavTZ7QfObpgy7/Om3D1oFCLZZ
niRjIjSYQLNa9u/KNlg8vYIkwjbCIqyid4+xhFLbYXqgY4Wrscu3hOVY2rvdsgLj
R7xfeRhYMZcROv/X10nVd+0T5oVU4MDeP975I851tr79Wnm4yh3OD7WypU9rShFX
4qVZ7tnsV0/wNB09IgYJt/BFv2gSN/hNJyTtYVUPWpD/6KELe2SaqGqJuP6NtDuV
NYnxhV0IhxM6ToTCqyzKVFZ6AZnUO8CvPteh6+0U4kVqIqBnDofeP12RVHUeYTPE
wqhCFaUWdWro2TH0csg4kToEEceBOO324u4IXF2302QJ1ZLBntqPrczMFqSzErcp
kaZc32jf9QxNRgZlQkkMbK22VgMFQgfRCyXpxoQynOoL167XiOxsFlVFI2PPoxES
OexJE8Bgbu/Ie8xnXa2voZ+eVSly0SC9HvrIy3TLbr04R0gywYA=
=dyk1
-----END PGP SIGNATURE-----
