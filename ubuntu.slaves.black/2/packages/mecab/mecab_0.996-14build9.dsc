-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: mecab
Binary: mecab, mecab-utils, libmecab2, libmecab-dev, libmecab-perl, python3-mecab, ruby-mecab, libmecab-java, libmecab-jni
Architecture: any all
Version: 0.996-14build9
Maintainer: Natural Language Processing (Japanese) <team+pkg-nlp-ja@tracker.debian.org>
Uploaders: Taku YASUI <tach@debian.org>, TSUCHIYA Masatoshi <tsuchiya@namazu.org>, Hideki Yamane <henrich@debian.org>,
Homepage: https://taku910.github.io/mecab/
Standards-Version: 4.5.0
Vcs-Browser: https://salsa.debian.org/nlp-ja-team/mecab
Vcs-Git: https://salsa.debian.org/nlp-ja-team/mecab.git
Testsuite: autopkgtest
Testsuite-Triggers: mecab-jumandic
Build-Depends: debhelper-compat (= 13), perl:native, perl-xs-dev, chrpath, dh-python, python3-all-dev, python3-setuptools, gem2deb, default-jdk, swig
Package-List:
 libmecab-dev deb libdevel optional arch=any
 libmecab-java deb java optional arch=all
 libmecab-jni deb java optional arch=any
 libmecab-perl deb perl optional arch=any
 libmecab2 deb libs optional arch=any
 mecab deb misc optional arch=any
 mecab-utils deb misc optional arch=any
 python3-mecab deb python optional arch=any
 ruby-mecab deb ruby optional arch=any
Checksums-Sha1:
 15baca0983a61c1a49cffd4a919463a0a39ef127 1398663 mecab_0.996.orig.tar.gz
 896767dd76e78f925296c3eb75b4c84370f9e09d 12996 mecab_0.996-14build9.debian.tar.xz
Checksums-Sha256:
 e073325783135b72e666145c781bb48fada583d5224fb2490fb6c1403ba69c59 1398663 mecab_0.996.orig.tar.gz
 468f1fc7874e7e43ea9d29406a9fc2a5fdf8fd1919ed22ea5db2baebac8d2f2b 12996 mecab_0.996-14build9.debian.tar.xz
Files:
 7603f8975cea2496d88ed62545ba973f 1398663 mecab_0.996.orig.tar.gz
 9f4369a1bbe24adc15ef58aa494e85e3 12996 mecab_0.996-14build9.debian.tar.xz
Ruby-Versions: all

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEJeP/LX9Gnb59DU5Qr8/sjmac4cIFAmIzjAwACgkQr8/sjmac
4cJ2shAAvEBadKaWarrnLeafRVwvQz/+Kb4j2jOKKwLFvoDNf6FkVcurUUumY2Yk
rjqsm9RmOgb34/jI+AmMMzMx/27oF2CVomEJumkimtZ2vdhXN6GEfxu6LDRLIUow
jf8OqTUY6euWw07SA3s3CDgiILxiBHak0+HiWiESo3OxKVUakKUL/RlZ8Km03asf
2120WV8QvXZeTyiSMjKyhtuq460oBrzan4y81/nymJRARqF/wJB/TJ/gPZyiwyYG
gXSvCY9hTNmgIxGIP9DJM/HrXJoamofxi4z5ds01l1na8/YEeZdQMGvz/epmZnQy
goIbcKdZGAWvC15i/RgRFoFRNJx4/A2DmtdERiQJdmWcyeygjzgJlDaID9bq5ODV
QByw/2LpBc5riiuaPMq4o3tl7Zaa0qmJJaroE6heLcluTasFSTGKzj8qi7hPfxWa
Ic63HofEExC+6uLLVAkPSRhVUhiT3lTvUSrKd3q95AqsCtC4KQ36de3UGPBec1U9
iRdWfTtZ9v9H+2qPeAFYOo95aj94r/hEAWmBk7HvWsQajBw02R5/I0oFLXMsjyFS
MROYnndgHQ6fNNZDI3wMrkbKf9ZgMu4uA/Ajlvj0Lu3ZvfTTbLq2B7m4Id/puZY2
tRg4op0nMOVNvSnJipi1QgKin3bSH9Rlql5+xMyzyYE1rhajH4w=
=50i8
-----END PGP SIGNATURE-----
