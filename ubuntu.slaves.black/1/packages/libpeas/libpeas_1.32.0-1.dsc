-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: libpeas
Binary: libpeas-1.0-0, libpeas-dev, libpeas-doc, libpeas-common, gir1.2-peas-1.0
Architecture: any all
Version: 1.32.0-1
Maintainer: Debian GNOME Maintainers <pkg-gnome-maintainers@lists.alioth.debian.org>
Uploaders: Emilio Pozuelo Monfort <pochu@debian.org>, Iain Lane <laney@debian.org>, Jeremy Bicha <jbicha@ubuntu.com>, Laurent Bigonville <bigon@debian.org>, Michael Biebl <biebl@debian.org>, Sjoerd Simons <sjoerd@debian.org>
Homepage: https://wiki.gnome.org/Projects/Libpeas
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/gnome-team/libpeas
Vcs-Git: https://salsa.debian.org/gnome-team/libpeas.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, pkg-config, python3, python3-gi
Build-Depends: adwaita-icon-theme <!nocheck>, debhelper-compat (= 13), dh-sequence-gir, dh-sequence-gnome, gi-docgen, libgirepository1.0-dev (>= 1.39.0), libgirepository1.0-doc <!nodoc>, libgladeui-dev, libglib2.0-dev (>= 2.38.0), libglib2.0-doc <!nodoc>, libgtk-3-dev (>= 3.0.0), libgtk-3-doc <!nodoc>, meson (>= 0.50), python-gi-dev (>= 3.7.2), python3-dev (>= 3.2.0), python3-gi (>= 3.7.2), xauth <!nocheck>, xvfb <!nocheck>
Package-List:
 gir1.2-peas-1.0 deb introspection optional arch=any
 libpeas-1.0-0 deb libs optional arch=any
 libpeas-common deb libs optional arch=all
 libpeas-dev deb libdevel optional arch=any
 libpeas-doc deb doc optional arch=any profile=!nodoc
Checksums-Sha1:
 c49693b8a82c6dd286bf44d70ad254b25ec308f2 193572 libpeas_1.32.0.orig.tar.xz
 4d027acecaf454bf200d6a1cb3f2a0b48525b3b2 10528 libpeas_1.32.0-1.debian.tar.xz
Checksums-Sha256:
 d625520fa02e8977029b246ae439bc218968965f1e82d612208b713f1dcc3d0e 193572 libpeas_1.32.0.orig.tar.xz
 b045067a61daa4e9f78847b3a14fe93ce677b6f7ceda02077203c23b2e257713 10528 libpeas_1.32.0-1.debian.tar.xz
Files:
 ea067e520d1b19606dbe47d20c625b8f 193572 libpeas_1.32.0.orig.tar.xz
 da3a39eb3568279bc07542c65a1a0f37 10528 libpeas_1.32.0-1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEETQvhLw5HdtiqzpaW5mx3Wuv+bH0FAmI4l5YACgkQ5mx3Wuv+
bH26/w//e1ngc0Bslo/fbexbG5p/wrfoKJJc1wYDun87ZhhJwGZJwVRR8v+NnRbz
gju4nAqNRazn+5WV3SAE0Ad/5nw/RPIdIHerzlV6Xa90BvaL436jveuKuPMWlwbl
xcBVHnzQxa08vjE0ld0t+Ppl6F6SnOLhj72YnkHJjXMd+LVRt9wIW9R4OMwKaffI
ciheVxzcgxj/VC2bgI49iuNVimzXrlnqDTihn6DbNVxD8+awF3bs8n51Sw0OlnN4
7V1ax83I5v00E8nMCF565E90icEjE0D7y+m0w8cd85xciK1Bwk6MadGnRNMgNfyI
NG2EoqdizcneWrPGmpIlikIVixbCRjpgXe0A8zsBynYav7EjnHb+tVHgsGWLGjky
9jVynNgq5zfHmXFbSc2JMQh9b/zDzK6yxyHSmLqfh/FZhurHX7V4X1Io1WQfcOxQ
a4B0ipG/MDrGffv7ry9Ghcpgug7MPzVvp0jKxm7AZzXkA+9SMB6gyvBDUrV9fqHV
spbEYpC7xVdeGtFd9rS62o8G8TKFeKYkDXq9VuDjrpBgM5MTs8TEU6AesNcWChkL
dDvFd7+b4Aum01Xm9Wm7diFDepeG4NIpU2PhTjD5DnN/+N0+v6OiwNUek8HZcWdA
eFeygtT0YkqJARAQaaiIKJndLKLnp1WhGbwD5voRsmaz5C81WEY=
=hfE6
-----END PGP SIGNATURE-----
