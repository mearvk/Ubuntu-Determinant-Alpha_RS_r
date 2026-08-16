# Package to generate fake dependency (and links) for libraries provided by
# cross-compilers. Built with equivs-build --arch <HOST arch>. 
# e.g. equivs-build --arch armhf libstdc++6-dev
Section: misc
Priority: optional
Standards-Version: 3.6.2

Package: libstdc++6-dev
Source: gcc-4.7
Version: 4.7.2-22
Architecture: any
Maintainer: Wookey <wookey@wookware.org>
Multi-Arch: same
Description: Virtual package to satisfy build dependencies for arm64
 The current toolchain contains the required libraries, but as -cross
 packages. This suffices until things are fully multiarched.
Links:  /usr/lib/gcc-cross/arm-linux-gnueabihf/4.7/libstdc++.so /usr/lib/arm-linux-gnueabihf/libstc++.so
