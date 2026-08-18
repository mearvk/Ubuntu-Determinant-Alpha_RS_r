-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: libfido2
Binary: libfido2-1, libfido2-dev, libfido2-doc, fido2-tools
Architecture: any all
Version: 1.10.0-1
Maintainer: Debian Authentication Maintainers <pkg-auth-maintainers@lists.alioth.debian.org>
Uploaders: Colin Watson <cjwatson@debian.org>, nicoo <nicoo@debian.org>
Homepage: https://developers.yubico.com/libfido2/
Standards-Version: 4.5.0
Vcs-Browser: https://salsa.debian.org/auth-team/libfido2
Vcs-Git: https://salsa.debian.org/auth-team/libfido2.git
Build-Depends: debhelper-compat (= 12), pkg-config, cmake (>= 3.14), mandoc, libcbor-dev, libssl-dev, libudev-dev, zlib1g-dev
Package-List:
 fido2-tools deb utils optional arch=any
 libfido2-1 deb libs optional arch=any
 libfido2-dev deb libdevel optional arch=any
 libfido2-doc deb doc optional arch=all
Checksums-Sha1:
 94ae43facf5ed1269c5c2ec5a056bed23ebe4749 591372 libfido2_1.10.0.orig.tar.gz
 5c404c7e9f92c20db03a20df87647a2011cb95f5 833 libfido2_1.10.0.orig.tar.gz.asc
 c7fe2d5bfe374e2afd09a99be82c5cdfcde6b49b 52432 libfido2_1.10.0-1.debian.tar.xz
Checksums-Sha256:
 526efd3d56af706c05d09f3d21f18ee3b0b15ac0c1f5c5da1acbc27c2730b99b 591372 libfido2_1.10.0.orig.tar.gz
 cb37e6950164449ca7034c2f926c133ff2a9d2731540c34f6b53ff551a983ca8 833 libfido2_1.10.0.orig.tar.gz.asc
 99ecd71741e1157b1e35cf133d2a9f1292978d28075708568c3922e0077a398c 52432 libfido2_1.10.0-1.debian.tar.xz
Files:
 12cfd0bca3f79f49d3eee3f4429423ac 591372 libfido2_1.10.0.orig.tar.gz
 677ad7197cf89d7b445a843dbe6b4461 833 libfido2_1.10.0.orig.tar.gz.asc
 ac51f20c408f8f2aa74c229e0c1e364e 52432 libfido2_1.10.0-1.debian.tar.xz
Dgit: b40b5078c481527fc923afb1b09898e85919f319 debian archive/debian/1.10.0-1 https://git.dgit.debian.org/libfido2

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEErApP8SYRtvzPAcEROTWH2X2GUAsFAmHpccAACgkQOTWH2X2G
UAuRLw//dP5c3ZGPPfsIpZU98YLBwI7lm/ZHw342SYBk2gPYxmA9m0pU7nrUmUgW
NjdOKnaDkCI656yx1+o+Zaf+AH+xrgbFh7gThL4TIC6TnyQ51ZzvkG/M27J6ResT
us6niCt7SttNjR6a3JkG2NNZeKjP+7bihxmZ2u7BCTGVg7SsY53qR8uovPfwX96m
m/zClfUU+7x48pe4IoK3jV9XJOjs/aTZA6sVwTIMextZDNB9ypTkjPLVp1a6pwmv
QIQaSVL+hsEk86pQ/gt+ER3u7aFD9kSjgk6X5RrJAI5l7ijoXzydzBKjBeVirBDm
KaDBYPTBQo4hD65dBVFBxhOkdy/xo0bbMfZDxgw8tR3R0yVhM8F5hucsPgapquP3
2NbrQhIHwZQwsQB72a8Gbw0jT/g7DjUzS0puUM7aJR1OslsthWQ8mPV/sJSMmL96
whUPrV9kaZwT51SuwP+SllOFpQjAqAfw0KHPH9MUJ6ZYg07xPofCqpybGqtrA/K1
AcyqrUbYv7UBKLmMwLkDB5yg0zMh/xwAMxeJ+O/rmnRjw1hBKrhfKBPeZugTDPPj
krxg0zzlQA3ZFl0Rh40wImrxFaeYtWDzqDyPDf5XdsLKoS96tOhbjMmnll4aEUuw
xAbu/0PMhhbUPWQlsC7ZLRtH0i+aBU4TdnjhOH6rPKq/qfsDocg=
=RlQ5
-----END PGP SIGNATURE-----
