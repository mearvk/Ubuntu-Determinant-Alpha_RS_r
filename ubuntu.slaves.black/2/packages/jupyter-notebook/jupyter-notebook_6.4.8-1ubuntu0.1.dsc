-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: jupyter-notebook
Binary: python3-notebook, python-notebook-doc, jupyter-notebook
Architecture: all
Version: 6.4.8-1ubuntu0.1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Gordon Ball <gordon@chronitis.net>, Jerome Benoit <calculus@rezozer.net>
Homepage: https://github.com/jupyter/notebook
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/python-team/packages/jupyter-notebook
Vcs-Git: https://salsa.debian.org/python-team/packages/jupyter-notebook.git
Testsuite: autopkgtest, autopkgtest-pkg-python
Testsuite-Triggers: python3-pytest, python3-requests, python3-requests-unixsocket
Build-Depends: debhelper-compat (= 13), dh-python, pkg-js-tools, python3-all, python3-setuptools, python3-argon2, python3-requests <!nocheck>, python3-requests-unixsocket <!nocheck>, python3-ipython <!nocheck>, python3-jupyter-core (>= 4.6.1) <!nocheck>, python3-jupyter-client (>= 5.3.4) <!nocheck>, python3-tornado (>= 6.1) <!nocheck>, python3-nbformat (>= 4.4) <!nocheck>, python3-nbconvert (>= 5) <!nocheck>, python3-nest-asyncio (>= 1.5) <!nocheck>, python3-ipykernel <!nocheck>, python3-prometheus-client <!nocheck>, python3-pytest <!nocheck>, python3-terminado (>= 0.8.3) <!nocheck>, python3-entrypoints <!nocheck>, python3-send2trash (>= 1.8) <!nocheck>, python3-zmq <!nocheck>, python3-sphinx <!nodoc>, python3-sphinx-rtd-theme <!nodoc>, python3-nbsphinx <!nodoc>, libjs-backbone (>= 1.2), libjs-bootstrap (>= 3.3), libjs-bootstrap-tour (>= 0.9), libjs-codemirror (>= 5.56), libjs-es6-promise (>= 1.0), fonts-font-awesome (>= 4.2), libjs-jed (>= 1.1.1), libjs-jquery (>= 3.5), libjs-jquery-ui (>= 1.12), libjs-marked (>= 4.0.9~), libjs-mathjax (>= 2.5), libjs-moment (>= 2.8.4), libjs-requirejs (>= 2.1), libjs-requirejs-text, libjs-text-encoding (>= 0.1), libjs-underscore (>= 1.5), libjs-jquery-typeahead (>= 2.0), libjs-xterm (>= 3.8.1-3~), nodejs, node-less (>= 1.5), node-source-map, node-requirejs (>= 2.3), node-react (>= 16.13), node-po2json (>= 0.4.5-2~), node-fbjs, node-loose-envify, node-object-assign, node-htmlparser2, node-deepmerge, node-escape-string-regexp, node-is-plain-object, node-postcss, node-lumino, node-typescript, node-babel-loader, webpack, pandoc
Package-List:
 jupyter-notebook deb science optional arch=all
 python-notebook-doc deb doc optional arch=all profile=!nodoc
 python3-notebook deb python optional arch=all
Checksums-Sha1:
 3023aa6a64b81506857c2a87f9bbe48ae1076365 8498893 jupyter-notebook_6.4.8.orig.tar.gz
 d4dded7001a3db3eb0d32bf0d21350f06a19b654 54284 jupyter-notebook_6.4.8-1ubuntu0.1.debian.tar.xz
Checksums-Sha256:
 571b71460bf121623372f10aa8e048a6b3bd3e51510c508c4df109cf6ac9d293 8498893 jupyter-notebook_6.4.8.orig.tar.gz
 268b41622b5f47fb551cbd8f3a6cced132c2d5bdeb97eddfa61de4f020e3e774 54284 jupyter-notebook_6.4.8-1ubuntu0.1.debian.tar.xz
Files:
 416839de38977b544948f141b01b3b4b 8498893 jupyter-notebook_6.4.8.orig.tar.gz
 9edf09fe204e534b1f1b66bbc3a10b15 54284 jupyter-notebook_6.4.8-1ubuntu0.1.debian.tar.xz
Original-Maintainer: Debian Python Team <team+python@tracker.debian.org>

-----BEGIN PGP SIGNATURE-----

iQHSBAEBCgA8FiEEs16801xnF7wK3rCK7Ic6ztRocjwFAmMMmo8eHG5pc2hpdC5t
YWppdGhpYUBjYW5vbmljYWwuY29tAAoJEOyHOs7UaHI8pjgL/3RqXAYZLMolDMEL
Cvwyf3lKq8wH3++Rn6263Rv8VitLD6YRIAqCo4qGmfKeeuMdF9pxUGsJw2Jn/OFp
qRyLCCSSvB6g+bShhZEnAIvhaVzg84lFvQIRjug1TGCy9PIPqEF91pfKJxk1fdvL
H9dWbgUemo2PZthXo2Heo7l7GldODMfHZu+dr/ZObNiNhTbgC5W7qwXsgbVN6Z3F
Z6yQTVjoEVYmwfd5Ce7fmvY7YcMQzzRfAiEkZ6AojzuGOB7V/2bPQIgGx7aJewYZ
gmdHzeYjH5y0Tsqix/AEelkJF8gGf8dogYMa/vrGHJH+ms5yTs5d4z9pC9Wkl20L
3nugbAUNd6/sNCe8eEnRLWBAC2dLfMsokhr4DdfIapBN+ZUFoVxq1s5Ib99SOI8B
RHoavHX8SBsytb+joYUIvzD4Vbr7R1VJhuNgxYHCVRZhba7JsiI0X3QH8RcSupW2
IM1X6FRolKZyf/szyb24AGBOzUsB3VLqWy4dtXxUFBIo84YcWQ==
=Qsnk
-----END PGP SIGNATURE-----
