-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: ipywidgets
Binary: python3-ipywidgets, python-ipywidgets-doc, jupyter-nbextension-jupyter-js-widgets, python3-widgetsnbextension
Architecture: all
Version: 6.0.0-9
Maintainer: Debian Python Team <team+python@tracker.debian.org>
Uploaders: Gordon Ball <gordon@chronitis.net>, Ximin Luo <infinity0@debian.org>
Homepage: https://github.com/jupyter-widgets/ipywidgets
Standards-Version: 4.5.1
Vcs-Browser: https://salsa.debian.org/python-team/packages/ipywidgets
Vcs-Git: https://salsa.debian.org/python-team/packages/ipywidgets.git
Testsuite: autopkgtest, autopkgtest-pkg-python
Testsuite-Triggers: python3-ipykernel, python3-ipython, python3-nose, python3-pytest
Build-Depends: debhelper-compat (= 13), dh-python, pkg-js-tools, fonts-font-awesome, libjs-mathjax, libjs-sizzle, node-ajv, node-css-loader, node-file-loader, node-url-loader, node-expect.js, node-recast, node-process, node-requirejs, node-sinon, node-style-loader, node-jquery, node-jquery-ui, node-backbone, node-d3-format, node-es6-promise, node-semver, node-typescript, node-underscore, python3-all, python3-setuptools, python3-ipython, python3-ipykernel, python3-jsonschema, python3-pytest, python3-recommonmark, python3-nose, python3-sphinx, python3-sphinx-rtd-theme, python3-traitlets, webpack
Package-List:
 jupyter-nbextension-jupyter-js-widgets deb python optional arch=all
 python-ipywidgets-doc deb doc optional arch=all
 python3-ipywidgets deb python optional arch=all
 python3-widgetsnbextension deb python optional arch=all
Checksums-Sha1:
 92dd590dfa61bc912850e5fbba5d994292815c23 929535 ipywidgets_6.0.0.orig.tar.gz
 3de5615c62aee3127d254d07d9cbe3c0476cc5bb 136976 ipywidgets_6.0.0-9.debian.tar.xz
Checksums-Sha256:
 81b625ca68d1e6756d78c78756a320ea49e48912484f7c92ac499c66d844a8e8 929535 ipywidgets_6.0.0.orig.tar.gz
 5f0d5709e22907fdceb4375862dc1e3d715719efac09e0b0ce9ee4c492baba32 136976 ipywidgets_6.0.0-9.debian.tar.xz
Files:
 3082b6760be8c566d88bdf1c9fd94063 929535 ipywidgets_6.0.0.orig.tar.gz
 5e873d48cb4b8eca5888f6489ca37f9f 136976 ipywidgets_6.0.0-9.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEJeP/LX9Gnb59DU5Qr8/sjmac4cIFAmIDizsACgkQr8/sjmac
4cJ9Ig//R5X9d774QmFVadrqSlnn/+qVcyZLDp8N2Q1cS2bFQDaH61yLi9chsW3z
8bpv7aS4zficWwoMBcId5wAxwtHwLV3sexTTecuWsf+EGbM0d1H53yCYlOSavhDk
LTroMEXPo2FOHzu04e2en2Ct7RloIAHkDk9blkvVhjURTshFTGwcOFy981FVgrCb
Mw18TC0NuLvs1YRP+PSnnVH6DdAMH5olYbnfhl7d3Grj06GWJUvN/d7Tv0Zi1nIV
PH+x3bk758fzbEec92Gh+CNLmQk8MZ0byx/IPR7KtiIhKHaDwEeBoA6Apmlf0f2q
BqGXUd/x9WP9WWBnCUA/K5YlZA7UvhvzrW5A9q6iXGRfD00vujDC/zGMgzq3IZDE
MFww8xdL2o+3zu/SyCiNi21zmwTMH+n6amWnUeQP+eBKNFEgZSj7GEJYtLhS8ZJP
ylJFBAVgPzN2q8TUySsbU3PUsLwOOJif3Y7/T/dHSoUL1PBF23c+7jAmI7WmSbv3
4GIh/YCCHQttkNZPpiK8h62IWGsp8k/EoNApHuoc46ZQ9514rysTx03Mk+VxU7x6
3Ua9LmdVj4h6ZAnPbwnFsaYXF70iPQIDInTDxtXNxdBQxbUVj1Q37m+owhLUAAgZ
yPA7WTsbgFNasOdJi6fgo9CIo039n1cRKQiqIgEyfTSOPS7d6sQ=
=ouxz
-----END PGP SIGNATURE-----
