s/@@ARCH@@/any/g
s/@@PACKAGE@@/gobjc++/g
s/@@LANGUAGE@@/Objective-C++/g
s/@@DEPENDS32P@@/gobjc-mingw-w64-i686-posix (= ${binary:Version})/g
s/@@DEPENDS32W@@/gobjc-mingw-w64-i686-win32 (= ${binary:Version})/g
s/@@DEPENDS64P@@/gobjc-mingw-w64-x86-64-posix (= ${binary:Version})/g
s/@@DEPENDS64W@@/gobjc-mingw-w64-x86-64-win32 (= ${binary:Version})/g
s/@@RECOMMENDS@@//g
s/@@REPLACES32@@/gobjc++-mingw-w64-i686 (<< ${threadsplit:Version})/g
s/@@REPLACES64@@/gobjc++-mingw-w64-x86-64 (<< ${threadsplit:Version})/g
s/@@CONFLICTS32@@//g
s/@@CONFLICTS64@@//g
s/@@BREAKS32@@/gobjc++-mingw-w64-i686 (<< ${threadsplit:Version})/g
s/@@BREAKS64@@/gobjc++-mingw-w64-x86-64 (<< ${threadsplit:Version})/g
