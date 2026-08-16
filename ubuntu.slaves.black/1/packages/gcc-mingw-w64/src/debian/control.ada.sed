s/@@ARCH@@/@@GNAT_ARCHES@@/g
s/@@PACKAGE@@/gnat/g
s/@@LANGUAGE@@/Ada/g
s/@@DEPENDS32P@@/gcc-mingw-w64-i686-posix (= ${binary:Version})/g
s/@@DEPENDS32W@@/gcc-mingw-w64-i686-win32 (= ${binary:Version})/g
s/@@DEPENDS64P@@/gcc-mingw-w64-x86-64-posix (= ${binary:Version})/g
s/@@DEPENDS64W@@/gcc-mingw-w64-x86-64-win32 (= ${binary:Version})/g
s/@@RECOMMENDS@@//g
s/@@REPLACES32@@/gcc-mingw-w64 (<< ${firstsplit:Version}), gnat-mingw-w64-i686 (<< ${threadsplit:Version})/g
s/@@REPLACES64@@/gcc-mingw-w64 (<< ${firstsplit:Version}), gnat-mingw-w64-x86-64 (<< ${threadsplit:Version})/g
s/@@CONFLICTS32@@//g
s/@@CONFLICTS64@@//g
s/@@BREAKS32@@/gcc-mingw-w64 (<< ${firstsplit:Version}), gnat-mingw-w64-i686 (<< ${threadsplit:Version})/g
s/@@BREAKS64@@/gcc-mingw-w64 (<< ${firstsplit:Version}), gnat-mingw-w64-x86-64 (<< ${threadsplit:Version})/g
