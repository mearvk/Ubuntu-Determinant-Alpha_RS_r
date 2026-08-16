s/@@ARCH@@/any/g
s/@@PACKAGE@@/gcc/g
s/@@LANGUAGE@@/C/g
s/@@DEPENDS32P@@/binutils-mingw-w64-i686 (>= 2.30~), mingw-w64-i686-dev, gcc-mingw-w64-i686-posix-runtime (= ${binary:Version}), gcc-mingw-w64-base (= ${binary:Version})/g
s/@@DEPENDS32W@@/binutils-mingw-w64-i686 (>= 2.30~), mingw-w64-i686-dev, gcc-mingw-w64-i686-win32-runtime (= ${binary:Version}), gcc-mingw-w64-base (= ${binary:Version})/g
s/@@DEPENDS64P@@/binutils-mingw-w64-x86-64 (>= 2.30~), mingw-w64-x86-64-dev, gcc-mingw-w64-x86-64-posix-runtime (= ${binary:Version}), gcc-mingw-w64-base (= ${binary:Version})/g
s/@@DEPENDS64W@@/binutils-mingw-w64-x86-64 (>= 2.30~), mingw-w64-x86-64-dev, gcc-mingw-w64-x86-64-win32-runtime (= ${binary:Version}), gcc-mingw-w64-base (= ${binary:Version})/g
s/@@RECOMMENDS@@//g
s/@@REPLACES32@@/gcc-mingw-w64 (<< ${firstsplit:Version}), gcc-mingw-w64-bootstrap, gcc-mingw-w64-i686 (<< ${threadsplit:Version})/g
s/@@REPLACES64@@/gcc-mingw-w64 (<< ${firstsplit:Version}), gcc-mingw-w64-bootstrap, gcc-mingw-w64-x86-64 (<< ${threadsplit:Version})/g
s/@@CONFLICTS32@@/gcc-mingw-w64-bootstrap/g
s/@@CONFLICTS64@@/gcc-mingw-w64-bootstrap/g
s/@@BREAKS32@@/gcc-mingw-w64 (<< ${firstsplit:Version}), gcc-mingw-w64-i686 (<< ${threadsplit:Version})/g
s/@@BREAKS64@@/gcc-mingw-w64 (<< ${firstsplit:Version}), gcc-mingw-w64-x86-64 (<< ${threadsplit:Version})/g
