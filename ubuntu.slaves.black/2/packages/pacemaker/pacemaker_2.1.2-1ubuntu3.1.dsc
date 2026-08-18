-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: pacemaker
Binary: pacemaker-common, pacemaker-resource-agents, pacemaker, pacemaker-cli-utils, pacemaker-remote, pacemaker-doc, libcib27, libcrmcluster29, libcrmcommon34, libcrmservice28, liblrmd28, libpacemaker1, libpe-rules26, libpe-status28, libstonithd26, pacemaker-dev
Architecture: any all
Version: 2.1.2-1ubuntu3.1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders:  Ferenc Wágner <wferi@debian.org>, Adrian Vondendriesch <adrian.vondendriesch@credativ.de>,
Homepage: https://www.clusterlabs.org/
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/ha-team/pacemaker
Vcs-Git: https://salsa.debian.org/ha-team/pacemaker.git
Testsuite: autopkgtest
Testsuite-Triggers: pkg-config
Build-Depends: cluster-glue-dev, debhelper-compat (= 12), dh-exec, dh-python, docbook-xsl, help2man, libbz2-dev, libcfg-dev (>= 1.99), libcmap-dev (>= 1.99), libcpg-dev (>= 1.99), libdbus-1-dev, libglib2.0-dev, libgnutls28-dev, libltdl-dev, libncurses-dev, libpam0g-dev, libqb-dev (>= 0.17.1), libquorum-dev (>= 1.99), libxml2-dev, libxml2-utils, libxslt1-dev, pkg-config, python3, python3-sphinx, systemd [linux-any], uuid-dev, xsltproc
Build-Depends-Indep: asciidoc, doxygen, graphviz, inkscape
Package-List:
 libcib27 deb libs optional arch=any
 libcrmcluster29 deb libs optional arch=any
 libcrmcommon34 deb libs optional arch=any
 libcrmservice28 deb libs optional arch=any
 liblrmd28 deb libs optional arch=any
 libpacemaker1 deb libs optional arch=any
 libpe-rules26 deb libs optional arch=any
 libpe-status28 deb libs optional arch=any
 libstonithd26 deb libs optional arch=any
 pacemaker deb admin optional arch=any
 pacemaker-cli-utils deb admin optional arch=any
 pacemaker-common deb admin optional arch=all
 pacemaker-dev deb libdevel optional arch=any
 pacemaker-doc deb doc optional arch=all
 pacemaker-remote deb admin optional arch=any
 pacemaker-resource-agents deb admin optional arch=all
Checksums-Sha1:
 efcb0be9d1cbe986c914c42bb6d2a71ad6da5f4a 5092065 pacemaker_2.1.2.orig.tar.gz
 22d6d65f0a574e2e357bfde27e97c4ec78b98660 52632 pacemaker_2.1.2-1ubuntu3.1.debian.tar.xz
Checksums-Sha256:
 6f12d3ffe60152fd416df8dc4ead34c16f33dcf8e4f8db7e88dab7c64815f5ed 5092065 pacemaker_2.1.2.orig.tar.gz
 d6b5dc07b42b7acfd31a52ed25e02472725846085a70af792e61e2615f7f582f 52632 pacemaker_2.1.2-1ubuntu3.1.debian.tar.xz
Files:
 cb3b626704346897140bfc77f1ebb20a 5092065 pacemaker_2.1.2.orig.tar.gz
 8ad886867cd9b1847dce2cb213faa60f 52632 pacemaker_2.1.2-1ubuntu3.1.debian.tar.xz
Original-Maintainer: Debian HA Maintainers <debian-ha-maintainers@alioth-lists.debian.net>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEktYY9mjyL47YC+71uj4pM4KAskIFAmQuhDMACgkQuj4pM4KA
skK3jg/8CLyPKcevX/3yHpFz+Qlf1WjCJAb5LGaE82Wvfj0CShXXg4jOKT/7660c
SobJVXLAmeJ7o8MyAtEeUjmIyqGHmYUBzjH5BP8TCdfE7+EV1CTLx7x4M1QaEpYW
Fz51/EHXjTlCJTO32lipuFvP5XxzOMCNRzFo6/8pfidETo+gmtT/r1qFVDf5Tzj4
WzF+roFY40LqUhHgFWc02BYoodhMM4GTjfsruDGn8ECHgR9kR2WTyUJ0m4bwfOxQ
B6H5j93cLn8uXar0cs8k5uPyCJnfwdZctFnwO4ifk2XGvpK7DuWS5jIwJ0w/xMyJ
8GhSdKqbVjs0HlR9TQhXhJoRjtnhDi3UvlVq412MrQ6ariYjzDfcJNMEL7pZ/qwQ
vSYbCtRpbePzsEqafaGUwRPaHVTC38ti2X+GXXsPTwlEH7bFAWGOZaeDbnr0gQiF
7TP3wTI3yvAJgEXvD3UCj0FDoQOeSw6NkbbJ2O6Qxe/xQo9Kv6W5oCy+0Ke2fWUI
wqKo5KszGRkag2aFfA7XQMgbYvL4dUnhMkzHyUgjQcVtsDMSqo1gDXtWfKjmzkzc
j5Hyz1ge8pgHb2kqdf9iXjWcXgmCL+YzZGRUz0njsIsO1E4rxW6qNJoZAt5U98oh
oB/no2+ZN0s4meLxEw6wwAnUD7h9DHpernyuvjdd9A2AKsHStvw=
=OdeT
-----END PGP SIGNATURE-----
