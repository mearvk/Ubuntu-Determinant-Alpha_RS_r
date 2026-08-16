-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: git
Binary: git, git-man, git-doc, git-cvs, git-svn, git-mediawiki, git-email, git-daemon-run, git-daemon-sysvinit, git-gui, gitk, gitweb, git-all
Architecture: any all
Version: 1:2.34.1-1ubuntu1.9
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Anders Kaseorg <andersk@mit.edu>
Homepage: https://git-scm.com/
Standards-Version: 4.3.0.1
Vcs-Browser: https://repo.or.cz/w/git/debian.git/
Vcs-Git: https://repo.or.cz/r/git/debian.git/
Build-Depends: libz-dev, gettext, libpcre2-dev | libpcre3-dev, libcurl4-gnutls-dev, libexpat1-dev, subversion [!i386], libsvn-perl [!i386], libyaml-perl, tcl, python3, libhttp-date-perl | libtime-parsedate-perl, libcgi-pm-perl, liberror-perl, libmailtools-perl, cvs, cvsps, libdbd-sqlite3-perl, unzip, libio-pty-perl, debhelper-compat (= 10), dh-exec (>= 0.7), dh-apache2, dpkg-dev (>= 1.16.2~)
Build-Depends-Indep: asciidoc (>= 8.6.10), xmlto, docbook-xsl
Package-List:
 git deb vcs optional arch=any
 git-all deb vcs optional arch=all
 git-cvs deb vcs optional arch=all
 git-daemon-run deb vcs optional arch=all
 git-daemon-sysvinit deb vcs optional arch=all
 git-doc deb doc optional arch=all
 git-email deb vcs optional arch=all
 git-gui deb vcs optional arch=all
 git-man deb doc optional arch=all
 git-mediawiki deb vcs optional arch=all
 git-svn deb vcs optional arch=all
 gitk deb vcs optional arch=all
 gitweb deb vcs optional arch=all
Checksums-Sha1:
 190208c4978572852c236c20588a6553182e4b86 6623760 git_2.34.1.orig.tar.xz
 2f7552ae99cc23f1f15c8e9a0fddedae2f6d24fe 757920 git_2.34.1-1ubuntu1.9.debian.tar.xz
Checksums-Sha256:
 3a0755dd1cfab71a24dd96df3498c29cd0acd13b04f3d08bf933e81286db802c 6623760 git_2.34.1.orig.tar.xz
 a2989e171269a71d955876eecc51e0f0b37c98a45db4f092c93b6ebac64768af 757920 git_2.34.1-1ubuntu1.9.debian.tar.xz
Files:
 f442dade3c73ea39473f6700b3e04dcd 6623760 git_2.34.1.orig.tar.xz
 244eaeec42afbd87d15d10705fe6867d 757920 git_2.34.1-1ubuntu1.9.debian.tar.xz
Original-Maintainer: Jonathan Nieder <jrnieder@gmail.com>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEf+ebRFcoyOoAQoOeRbznW4QLH2kFAmRI/N4ACgkQRbznW4QL
H2meSA//Y/8iFCKx6x2jqREMnQef7ym8sbVyrhTwj0yL30ibJq1XuOmPwe2dSQ5c
CWDoHeV/5+2vLb4I/M3E7zhbs7/bXHhdZ4BuZCdfC/61M5ENeC/6qfizwD/ccbTv
m4vRMskvR4b8IrK8dCkTRa2wW2o2ba/P4lQuKhhB9DA8/ZYJj9mNjONKlN91x26Z
sI6uGPbGuyxWcA8n7dco8WYKkhIDdmNzOl58QKgsfPISHjPeKFXUiDGqln2WwQzY
DdqnpLgxJBgVzsDE+SK+u9MYwryBMOpv4Vt7v8Z2iwufnBR787Idtx/f0hLDcewb
hcfrWrrEW+hfaLqbHh+BhREITgNumaggD/y08uiEoGKm+NlemD6KFX/RGWzylHUB
2CroEFEFwDwNz0YuQOCO3i+HfwxVSvi7QL7QUZ6Cnk6TMVm8PC9Vu1oTZ9J80DuB
5iHqpvL0myRuYasvqKc3YdWMbMpxw6td0O97oU0duHwQWad8pLV8pTIAmHCBQ6j1
lgcCAaKCeu9CyfHyjeZWK8BrqF+VQXwe3LDaOMI9RbmzFrenqnYRwoXDMvos59RB
Dkk94aRUP2RnHC3kr9Rmws908KBO4bzNjRGpJGJUyA1mtB/pQQ9pEPfSRg0KAoj2
UNfuBLtXzpfuVinRjHdjiMeWAO7JP7qg8O+HsJpmTEqthLAsBAQ=
=m0uj
-----END PGP SIGNATURE-----
