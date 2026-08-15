-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: cmake
Binary: cmake, cmake-data, cmake-curses-gui, cmake-qt-gui, cmake-doc
Architecture: any all
Version: 3.22.1-1ubuntu1.22.04.1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Lisandro Damián Nicanor Pérez Meyer <lisandro@debian.org>, Felix Geyer <fgeyer@debian.org>, Timo Röhling <roehling@debian.org>
Homepage: https://cmake.org/
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/cmake-team/cmake
Vcs-Git: https://salsa.debian.org/cmake-team/cmake.git
Testsuite: autopkgtest
Testsuite-Triggers: @builddeps@, bison, cvs, default-jdk, doxygen, flex, gettext, git, hspell, icoutils, imagemagick, libarchive-dev, libarmadillo-dev, libasound2-dev, libboost-dev, libbz2-dev, libcups2-dev, libcurl4-openssl-dev, libexpat1-dev, libfreetype6-dev, libgif-dev, libgnutls28-dev, libgtk2.0-dev, liblzma-dev, libmagick++-dev, libmagickcore-dev, libmagickwand-dev, libopenscenegraph-dev, libphysfs-dev, libprotobuf-dev, libtiff5-dev, libxml2-dev, libxslt1-dev, mercurial, ninja-build, perl, pkg-config, protobuf-compiler, python3-dev, ruby-dev, subversion, swig, zlib1g-dev
Build-Depends: debhelper-compat (= 13), cmake <cross>, freebsd-glue [kfreebsd-any], libarchive-dev (>= 3.3.3) <!pkg.cmake.bootstrap>, libcurl4-openssl-dev <!pkg.cmake.bootstrap> | libcurl-ssl-dev <!pkg.cmake.bootstrap>, libexpat1-dev <!pkg.cmake.bootstrap>, libjsoncpp-dev <!pkg.cmake.bootstrap>, libncurses5-dev <!pkg.cmake.bootstrap !pkg.cmake.nogui>, librhash-dev <!pkg.cmake.bootstrap>, libssl-dev <pkg.cmake.bootstrap>, libuv1-dev (>= 1.10) <!pkg.cmake.bootstrap>, procps [!hurd-any], python3-sphinx:native, python3-sphinxcontrib.qthelp:native, qtbase5-dev <!pkg.cmake.bootstrap !pkg.cmake.nogui>, zlib1g-dev <!pkg.cmake.bootstrap>
Build-Depends-Indep: dh-elpa, dh-sequence-sphinxdoc
Package-List:
 cmake deb devel optional arch=any
 cmake-curses-gui deb devel optional arch=any profile=!pkg.cmake.bootstrap,!pkg.cmake.nogui
 cmake-data deb devel optional arch=all
 cmake-doc deb doc optional arch=all profile=!pkg.cmake.bootstrap
 cmake-qt-gui deb devel optional arch=any profile=!pkg.cmake.bootstrap,!pkg.cmake.nogui
Checksums-Sha1:
 71861ee1c487edf05061ab5f7dc4f13a74bfbcdb 9778031 cmake_3.22.1.orig.tar.gz
 05efc530d4a7719b22837266ad01d0e171d33a81 34440 cmake_3.22.1-1ubuntu1.22.04.1.debian.tar.xz
Checksums-Sha256:
 0e998229549d7b3f368703d20e248e7ee1f853910d42704aa87918c213ea82c0 9778031 cmake_3.22.1.orig.tar.gz
 b1eeead82e3b30b9e4f027bfba717ffc5703270e9e21c3a5f9d1c9a512eb4475 34440 cmake_3.22.1-1ubuntu1.22.04.1.debian.tar.xz
Files:
 83802be08c114bb34729300206488321 9778031 cmake_3.22.1.orig.tar.gz
 ded7ebc9f6ac5b923a03db59841ba4c1 34440 cmake_3.22.1-1ubuntu1.22.04.1.debian.tar.xz
Original-Maintainer: Debian CMake Team <pkg-cmake-team@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkpeKbhleSSGCX3/w808JdE6fXdkFAmL8ySQACgkQ808JdE6f
XdlV2w/6A05JTK7+vtnwdFxb0H5IHRTmRgRuEGK4IkUeNOcT2FodopHgZLVeZA7F
rTiRMyT27PqeYb8setKXTKYLvrq4l15i+oGEYVXtxRnN6AhOpBQIxZDT9F4g4sG8
IBE57SNYhkYfq3XATlSu1sjhcwzIa1cM7SP9uQqLqF02xCxIe7zEdy0dZDAE2YUo
VJapeeyRJ6AH1EVp3XpuoU6hvaANvCluTm8T2bAFRHii0bJ4kFbj/CWTNsxsfpEK
dROY+kBlCi31AvmW94qQIiXE8ePiZRHN5QUHNkWkWivK1Ebz6XonEvZZ6NDnRuuE
34GqkEpWXdfPATFRAdjpoDn8dMivr3h+cjUWS1XMumCU+6vYhckaJ6BdgLIqdw/r
gIyja04AhYus5uMj29/Z1sw+tbzJ3sPCAyhM8dKTEAh9Z1uSbjZkeZqdFfxZ6IPv
R17HJkpJc0i2zNfiWhmLslJu6U2RLVq1dA8mJUiXRK9bsV/3kcCZA1cxrBeqQ6sE
AbStkC44BlVQSbemmVeXbgMcRP8IhfdRAhdL0tDFY8PE86WlY8ApOTZrQAFQsQbG
gyMXryKQsSjPfyLi22do+bkmD0T/EHQfpuB/zl4cb5GkcxDPP3WihroFtXSvVuk6
4BaMcpX7mExusi7AdqL3SvV6EIc2KDG9UK2n1EJjHD/CkYYmRnE=
=xaCW
-----END PGP SIGNATURE-----
