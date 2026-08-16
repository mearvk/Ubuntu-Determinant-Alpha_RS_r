-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: gunicorn
Binary: gunicorn, gunicorn-examples, python3-gunicorn
Architecture: all
Version: 20.1.0-2
Maintainer: Debian Python Team <team+python@tracker.debian.org>
Uploaders:  Chris Lamb <lamby@debian.org>,
Homepage: https://gunicorn.org/
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/python-team/packages/gunicorn
Vcs-Git: https://salsa.debian.org/python-team/packages/gunicorn.git
Testsuite: autopkgtest
Testsuite-Triggers: curl, procps
Build-Depends: debhelper-compat (= 13), dh-python, python3-all, python3-setuptools
Package-List:
 gunicorn deb httpd optional arch=all
 gunicorn-examples deb httpd optional arch=all
 python3-gunicorn deb python optional arch=all
Checksums-Sha1:
 ec287804a49b42f64da265edfbe0507118a99f2f 354960 gunicorn_20.1.0.orig.tar.gz
 5f2d355c975b1396d999391308e52c9d727f294d 12468 gunicorn_20.1.0-2.debian.tar.xz
Checksums-Sha256:
 fa92b983e5c8d36b87ddc737d7bdd06936afd420bd6439b7b351f05ce982975e 354960 gunicorn_20.1.0.orig.tar.gz
 e3f22bc4d3b9574689cc4fad068b16278dfe6e2fdcbfba422cc2ea294be33060 12468 gunicorn_20.1.0-2.debian.tar.xz
Files:
 ac6254576d53c2ede3456561af3f0549 354960 gunicorn_20.1.0.orig.tar.gz
 cb797fe1f31fe078c0b77754692b48a3 12468 gunicorn_20.1.0-2.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwv5L0nHBObhsUz5GHpU+J9QxHlgFAmGBd04ACgkQHpU+J9Qx
HljkOQ/8CSjF+WBk1yjgiSExPK2TV0Pda+oy55I+xqrmpsdt7H2lsODEdlt/2j7z
Vew0EE64O2AI7tsc7LtIip4/kuE3m8e2gFQpKZv7Z5DDyPs7p/wh47a3ahK/tfdn
kw8mJrjDB0e+VmODk5p/yYqcvndde6BSVII1chTD7l3ju5MhhpNkBhdqqFBryhub
sbshYaekZtWR2CRZzD22jMb9rYmW5omJHrD9laIQ/bXnUxnaG4Y5hf8qzIQWlVkY
ASyywHfkIUn0TkMzionhFsUjhB87Cpapyo6OfUoQ9INuBr+9ykxTOnCTpMLFYUnV
Lqobm/J4r4VshoLMNTibp3MREt4NY+TwtMJKLsjWUqbP7zeMrwlUK/gOOp2+1nQ8
W1eG1Io2jzSFrDvpYubbfxE6o4/CIpdgJsXZY92hIPH/z/TKk6J2rSv/pc6cd7Vx
IKFCEnQx0KZEvkEzJLv9wvCmAa/ZSOjgBBlz5VBa5cl24HeLStaMvwE8eeBYYrIj
x5UD077aScuLCxXfuLcLITKJ2XI8tf/xz/rQPXuUp5h5/2OkngVoctm0fu7XisP7
gEswFKvQmuy37NqwhQdEcfkCudcmbz6sbMkZcippqASiyPjSoA7RI25TVKzasSdU
i+M+SlvdN5SArjwryBrb9WIKUCo9S2eDqaTuAsG0V+8eOP5XEEc=
=atPX
-----END PGP SIGNATURE-----
