-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: cargo
Binary: cargo, cargo-doc
Architecture: any all
Version: 0.67.1+ds0ubuntu0.libgit2-0ubuntu0.22.04.2
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Luca Bruno <lucab@debian.org>, Angus Lees <gus@debian.org>, Ximin Luo <infinity0@debian.org>, Vasudev Kamath <vasudev@copyninja.info>
Homepage: https://crates.io/
Standards-Version: 4.2.1
Vcs-Browser: https://git.launchpad.net/~canonical-foundations/ubuntu/+source/cargo
Vcs-Git: https://git.launchpad.net/~canonical-foundations/ubuntu/+source/cargo
Testsuite: autopkgtest
Testsuite-Triggers: @builddeps@
Build-Depends: debhelper (>= 12~), dpkg-dev (>= 1.17.14), cargo:native (>= 0.56.0), rustc:native (>= 1.63), libstd-rust-dev (>= 1.63), pkg-config, bash-completion, python3:native, libcurl4-gnutls-dev | libcurl4-openssl-dev, libssh2-1-dev, libssl-dev, zlib1g-dev, zlib1g-dev:native, git <!nocheck>
Package-List:
 cargo deb devel optional arch=any
 cargo-doc deb doc optional arch=all profile=!nodoc
Checksums-Sha1:
 a1b39651f5254577daf5b27651b225c32b47b860 7557688 cargo_0.67.1+ds0ubuntu0.libgit2.orig-vendor.tar.xz
 bb78a8e09b210c1d1676354e294a0c48d2ded10c 2248897 cargo_0.67.1+ds0ubuntu0.libgit2.orig.tar.gz
 e8cec586580fc3d554701c514ec7da3c614d070c 44836 cargo_0.67.1+ds0ubuntu0.libgit2-0ubuntu0.22.04.2.debian.tar.xz
Checksums-Sha256:
 741b3c750049c1eb22deef0bee0b08fd0cd6ebd967a5f2e2de4c1d1ae0bbb933 7557688 cargo_0.67.1+ds0ubuntu0.libgit2.orig-vendor.tar.xz
 deb8605e7306e883fb4470a1ff7ad9a6e7af59b6ddaaf142ed5bd7fb4be9f5e6 2248897 cargo_0.67.1+ds0ubuntu0.libgit2.orig.tar.gz
 d4039aae6ad11a8d2b889ad66dfd4950654c1f77ee33002ae1443ec3699a3c15 44836 cargo_0.67.1+ds0ubuntu0.libgit2-0ubuntu0.22.04.2.debian.tar.xz
Files:
 6a7276ecfe530402449ac6d74fa969b5 7557688 cargo_0.67.1+ds0ubuntu0.libgit2.orig-vendor.tar.xz
 80686559bb6142ddb5a6956901331fa1 2248897 cargo_0.67.1+ds0ubuntu0.libgit2.orig.tar.gz
 426260335f5e268b049c200e8cad1bbc 44836 cargo_0.67.1+ds0ubuntu0.libgit2-0ubuntu0.22.04.2.debian.tar.xz
Original-Maintainer: Rust Maintainers <pkg-rust-maintainers@alioth-lists.debian.net>
Original-Vcs-Browser: https://salsa.debian.org/rust-team/cargo
Original-Vcs-Git: https://salsa.debian.org/rust-team/cargo.git
Vendored-Sources-Rust: adler@1.0.2, aho-corasick@0.7.20, anyhow@1.0.68, arrayvec@0.5.2, atty@0.2.14, autocfg@1.1.0, base64@0.13.1, bitflags@1.3.2, bitmaps@2.1.0, block-buffer@0.10.3, bstr@1.1.0, bytes@1.4.0, bytesize@1.1.0, cc@1.0.79, cfg-if@1.0.0, clap@4.0.15, clap_lex@0.3.1, combine@4.6.6, commoncrypto-sys@0.2.0, commoncrypto@0.2.0, concolor-query@0.0.5, concolor@0.0.8, content_inspector@0.2.4, core-foundation-sys@0.8.3, core-foundation@0.9.3, cpufeatures@0.2.5, crc32fast@1.3.2, crypto-common@0.1.6, crypto-hash@0.3.4, curl-sys@0.4.59+curl-7.86.0, curl@0.4.44, digest@0.10.6, dunce@1.0.3, either@1.8.1, env_logger@0.7.1, env_logger@0.9.3, fastrand@1.8.0, filetime@0.2.19, flate2@1.0.25, fnv@1.0.7, foreign-types-shared@0.1.1, foreign-types@0.3.2, form_urlencoded@1.1.0, fwdansi@1.1.0, generic-array@0.14.6, git2-curl@0.17.0, git2@0.16.1, glob@0.3.1, globset@0.4.10, hashbrown@0.12.3, hex@0.4.3, hmac@0.12.1, home@0.5.4, humantime@1.3.0, humantime@2.1.0, idna@0.3.0, ignore@0.4.20, im-rc@15.1.0, indexmap@1.9.2, itertools@0.10.5, itoa@1.0.5, jobserver@0.1.25, kstring@2.0.0, lazy_static@1.4.0, lazycell@1.3.0, libc@0.2.139, libgit2-sys@0.14.2+1.5.1, libnghttp2-sys@0.1.7+1.45.0, libssh2-sys@0.2.23, libz-sys@1.1.8, log@0.4.17, memchr@2.5.0, miniz_oxide@0.6.2, miow@0.3.7, normalize-line-endings@0.3.0, num-traits@0.2.15, once_cell@1.17.0, opener@0.5.2, openssl-macros@0.1.0, openssl-probe@0.1.5, openssl-sys@0.9.80, openssl@0.10.45, ordered-float@2.10.0, os_info@3.6.0, os_str_bytes@6.4.1, pathdiff@0.2.1, percent-encoding@2.2.0, pkg-config@0.3.26, pretty_env_logger@0.4.0, proc-macro2@1.0.50, quick-error@1.2.3, quote@1.0.23, rand_core@0.6.4, rand_xoshiro@0.6.0, redox_syscall@0.2.16, regex-automata@0.1.10, regex-syntax@0.6.28, regex@1.7.1, remove_dir_all@0.5.3, rustc-workspace-hack@1.0.0, rustfix@0.6.1, ryu@1.0.12, same-file@1.0.6, schannel@0.1.19, semver@1.0.16, serde-value@0.7.0, serde@1.0.152, serde_derive@1.0.152, serde_ignored@0.1.7, serde_json@1.0.91, sha1@0.10.5, shell-escape@0.1.5, similar@2.2.1, sized-chunks@0.6.5, snapbox-macros@0.3.1, snapbox@0.3.3, socket2@0.4.7, static_assertions@1.1.0, strip-ansi-escapes@0.1.1, strsim@0.10.0, subtle@2.4.1, syn@1.0.107, tar@0.4.38, tempfile@3.3.0, termcolor@1.2.0, thread_local@1.1.4, tinyvec@1.6.0, tinyvec_macros@0.1.0, toml_datetime@0.5.1, toml_edit@0.15.0, typenum@1.16.0, unicode-bidi@0.3.10, unicode-ident@1.0.6, unicode-normalization@0.1.22, unicode-width@0.1.10, unicode-xid@0.2.4, url@2.3.1, utf8parse@0.2.0, vcpkg@0.2.15, version_check@0.9.4, vte@0.10.1, vte_generate_state_changes@0.1.1, walkdir@2.3.2, winapi-i686-pc-windows-gnu@0.4.0, winapi-util@0.1.5, winapi-x86_64-pc-windows-gnu@0.4.0, winapi@0.3.9, yansi@0.5.1

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE6x/rcKrl3aOwzUVJI9HORTRBlDcFAmQJDZMACgkQI9HORTRB
lDfBVQ/9EPxYbniBG2NG0iM5uEznfdQSbD2j/HHcBpEKkP0wFhwk4mvz26Jqz7Vg
BGKAu0i3IRCRs+xrRp3rewnAaBQwFxorpKBLdCsHREacuqdmR8aXdtlurfe95ses
XL20xnmyLUOkDO4hOpA1DG07e0t0aYyWByGB3VfgIY7rHYA0ZT5P8sTRGV7dmXYM
SUvN6qqBP60QDMUrmzIyTijy7hT+R+mh8YwPV3f3rFkU4hRKY8pHZtFtNCx+9nW2
nL86k8+C3jhii99hp1NTzAq8Rs4CYIwvsN4K4bJRDVHA+vFC0RowxI406YIAFrsz
Sr0XvUkZyg1lxJ2dyE9CXVV7nNhBycsHoQtf8U9CLS7WgzLpFSszwc+L0I4DpOsy
Rm2PiePANIwaYZHeKFjSNxiNL+PP+rCf0J0CrVVFg8gIYWwI7tlP5omAi7AXjp3A
FDx5JlFkGRVpD7VEPLm1bvluo++yG3qVLUDs+BwFq//tem+dkZsuWh7732m22Dw8
PxSmUTq9EwdH4D8BFzeGHGr+k1tKDQf2CPB3uSWDrdr2835oWQ2GK5hRWNTjXlMf
W9QPqNdZk0vAU2E+XeFgS0Yzu2bD2bM/ADAL2kgsVyED8uD7Nxm65BfGZhxTaZgu
Ig8rG0DLO4Z2hkS0z5UzTisTG3eWwIIW1nBn7skRNygE0Brbcsg=
=4fXA
-----END PGP SIGNATURE-----
