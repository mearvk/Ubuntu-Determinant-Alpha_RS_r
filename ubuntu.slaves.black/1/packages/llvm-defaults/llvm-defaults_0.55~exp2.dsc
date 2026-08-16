-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (native)
Source: llvm-defaults
Binary: llvm, llvm-runtime, llvm-dev, libllvm-ocaml-dev, clang, clang-tools, clang-tidy, clangd, clang-format, libclang-cpp-dev, libclang1, libclang-dev, liblldb-dev, lldb, lld, python3-clang, python3-lldb, libomp-dev, libomp5, libc++1, libc++-dev, libc++abi1, libc++abi-dev
Architecture: any
Version: 0.55~exp2
Maintainer: LLVM Packaging Team <pkg-llvm-team@lists.alioth.debian.org>
Uploaders: Matthias Klose <doko@debian.org>, Sylvestre Ledru <sylvestre@debian.org>, Gianfranco Costamagna <locutusofborg@debian.org>
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/pkg-llvm-team/llvm-defaults/
Vcs-Git: https://salsa.debian.org/pkg-llvm-team/llvm-defaults.git -b snapshot
Build-Depends: debhelper-compat (= 13), dpkg-dev (>= 1.13.9), lsb-release, m4
Package-List:
 clang deb devel optional arch=any
 clang-format deb devel optional arch=any
 clang-tidy deb devel optional arch=any
 clang-tools deb devel optional arch=any
 clangd deb devel optional arch=any
 libc++-dev deb libdevel optional arch=any
 libc++1 deb libs optional arch=any
 libc++abi-dev deb libdevel optional arch=any
 libc++abi1 deb libs optional arch=any
 libclang-cpp-dev deb libdevel optional arch=any
 libclang-dev deb libdevel optional arch=any
 libclang1 deb libs optional arch=any
 liblldb-dev deb libdevel optional arch=any
 libllvm-ocaml-dev deb ocaml optional arch=amd64,arm64,armhf
 libomp-dev deb libdevel optional arch=amd64,arm64,armhf,i386,mips64el,ppc64el,ppc64
 libomp5 deb libs optional arch=amd64,arm64,armhf,i386,mips64el,ppc64el,ppc64
 lld deb devel optional arch=any
 lldb deb devel optional arch=any
 llvm deb devel optional arch=any
 llvm-dev deb devel optional arch=any
 llvm-runtime deb devel optional arch=any
 python3-clang deb python optional arch=any
 python3-lldb deb python optional arch=any
Checksums-Sha1:
 0ccd6df8b2ca04b995cb6a9f72ef4c51642404db 13432 llvm-defaults_0.55~exp2.tar.xz
Checksums-Sha256:
 8f4c38bc7b20c27c6c1c69f26ad42e33cc0b136f0323d34443978d6ce5d75d06 13432 llvm-defaults_0.55~exp2.tar.xz
Files:
 22e412a3fee620f8d3b14890b6eedbc6 13432 llvm-defaults_0.55~exp2.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkpeKbhleSSGCX3/w808JdE6fXdkFAmJHZfYACgkQ808JdE6f
Xdn4KRAA1lrjzmFI89Z7INdeEs1J/4UEFVihVH77H6agV4cKyqG47ABuzKcJiMfC
i+aBmADbql5zXh4WAAZmxSzxeFNTRTIfb342B2BarOF2jmL0f0l4cacFNTU6lngW
uBuEiFZDDv1zfzaNqE4eIYNvj7iHERMqM3rJEBk1095LsEvbc7CGDCnI+ykDsba3
F6TxODga8Ja6oKu+L022Z6xJi/bPIw6kCZ7YWodckjF0pjJmHBDXD55CACl/nIP/
aUYFKqSpg+0DFqSPgdv2jLN+FR53pl2uELWD4Uuhro4+6iDAW0TJFL+xrx7OpMtk
H54qBjm41TuVWj4MtT7FVEYcAW1HD6oMQS8SfLnz8OL6Oqt8DdJwjjNT6BnCtcZx
RQTBvQ+PTF9NTUGgPLBNFF2Ihd7MmN5jlNaFARP2vAlRsc1vXYgOQEUY33cTbn/d
/UJfR3QShAO1RUXE197o8hVY4mMzz3+aI5uKmnj/pID/Y09oN39XTr4IP1WVsXVY
51byALjWbSjeY492Dl2O2ObEytqxHx9G8uiGlMGT3ta1zjzfmGbkQQSprcRXhdVb
VqAakuB4mPPlG+hQeXmqGcdAweU4HsUYJWGTSMNMUOpTnSgDEHBTSErQw2Xu18IU
N6dbeT8ItETht1zRam5H4QXc+lak5Eftkp2iI2+4SkvT6/ebv3s=
=GGuO
-----END PGP SIGNATURE-----
