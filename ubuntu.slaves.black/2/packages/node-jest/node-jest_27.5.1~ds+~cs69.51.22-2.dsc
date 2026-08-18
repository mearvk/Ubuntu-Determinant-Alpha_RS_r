-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: node-jest
Binary: jest, node-jest-worker, node-jest-debbundle
Architecture: all
Version: 27.5.1~ds+~cs69.51.22-2
Maintainer: Debian Javascript Maintainers <pkg-javascript-devel@lists.alioth.debian.org>
Uploaders: Pirate Praveen <praveen@debian.org>, Yadd <yadd@debian.org>
Homepage: https://jestjs.io
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/js-team/node-jest
Vcs-Git: https://salsa.debian.org/js-team/node-jest.git
Testsuite: autopkgtest-pkg-nodejs
Build-Depends: chai, debhelper-compat (= 13), dh-sequence-nodejs (>= 0.9.84~), help2man, jq, node-async-done, node-ansi-escapes, node-ansi-regex, node-ansi-styles, node-anymatch (>= 3.1.2), node-babel-core (>= 7.8.3), node-babel-preset-react (>= 7), node-babel-register (>= 7), node-babel-traverse (>= 7), node-babel7, node-braces, node-browserify-lite, node-browserslist, node-bundt, node-camelcase, node-chalk, node-chokidar, node-ci-info, node-co, node-color-name, node-convert-source-map, node-cosmiconfig, node-crypto-browserify <!nocheck>, node-csstype, node-deepmerge, node-detect-newline, node-emittery, node-execa, node-exit, node-fast-json-stable-stringify (>= 2.1), node-flow-remove-types <!nocheck>, node-glob, node-glob-stream, node-graceful-fs, node-is-generator-fn, node-istanbul, node-jsdom, node-json-stable-stringify, node-leven, node-make-error, node-merge-stream, node-micromatch, node-minimatch, node-minimist, node-mkdirp <!nocheck>, node-normalize-package-data, node-parse-json, node-prompts <!nocheck>, node-prop-types, node-react, node-read-pkg, node-read-pkg-up, node-resolve, node-resolve-cwd <!nocheck>, node-resolve-from, node-rimraf, node-rollup-plugin-babel, node-rollup-plugin-commonjs, node-rollup-plugin-json, node-rollup-plugin-node-resolve, node-rollup-plugin-typescript, node-sane <!nocheck>, node-semver, node-sinon, node-slash, node-source-map, node-source-map-support, node-stack-utils, node-strip-ansi <!nocheck>, node-strip-bom, node-strip-json-comments <!nocheck>, node-supports-color, node-tough-cookie, node-types-gulp, node-types-node, node-types-mocha, node-types-vinyl-fs, node-types-undertaker, node-types-undertaker-registry, node-typescript (>= 4.4.4~), node-v8-to-istanbul (>= 8~), node-vinyl, node-write-file-atomic, node-yargs, node-yargs-parser, rollup (>= 2~), ts-node, webpack
Package-List:
 jest deb javascript optional arch=all
 node-jest-debbundle deb javascript optional arch=all
 node-jest-worker deb javascript optional arch=all
Checksums-Sha1:
 5e2b6b2574330b67f817f5c7cfb6e85e67ea4b49 2576 node-jest_27.5.1~ds+~cs69.51.22.orig-astral-regex.tar.xz
 8afa646c9ae53bb545541ab3113cae36671de509 8924 node-jest_27.5.1~ds+~cs69.51.22.orig-babel-preset-moxy.tar.xz
 8e0cbe207c3fd77bb11c1b586c3d4a1dce733c9a 13760 node-jest_27.5.1~ds+~cs69.51.22.orig-bcoe-v8-coverage.tar.xz
 c01d296fc675c1ce8d287b568bf779c731954f98 73360 node-jest_27.5.1~ds+~cs69.51.22.orig-char-regex.tar.xz
 a0e4be87447b0fbbff5e646ff66569823d25e0ca 706016 node-jest_27.5.1~ds+~cs69.51.22.orig-cjs-module-lexer.tar.xz
 02ccc761367f640c85ddd6af3cd50f20cf94ba38 80316 node-jest_27.5.1~ds+~cs69.51.22.orig-collect-v8-coverage.tar.xz
 11cbf4a6973450c2fa9f857f8b1a09bde615d197 28260 node-jest_27.5.1~ds+~cs69.51.22.orig-dedent.tar.xz
 88600ea30f521ddff2d7f1bb696d1e30d2861c54 4108 node-jest_27.5.1~ds+~cs69.51.22.orig-import-local.tar.xz
 cac1dbcbb8d0ad1587473faba79d075aaa9c17b2 4212 node-jest_27.5.1~ds+~cs69.51.22.orig-is-ci.tar.xz
 655f1e36acf609197dd365c9166218f55bc7bd68 2716 node-jest_27.5.1~ds+~cs69.51.22.orig-jest-pnp-resolver.tar.xz
 efcf7f9b6371cce9641c366f926f9b57880c62c3 44296 node-jest_27.5.1~ds+~cs69.51.22.orig-jest-snapshot-serializer-raw.tar.xz
 07409215ce108491fb8436c56344fd352e35c773 2400 node-jest_27.5.1~ds+~cs69.51.22.orig-jest-tobetype.tar.xz
 cba1031de7df1d2a20fb2b56d2c8118865951f24 3388 node-jest_27.5.1~ds+~cs69.51.22.orig-natural-compare-lite.tar.xz
 c42e771b1660e92a8f522268df3ff605d7900f01 2428 node-jest_27.5.1~ds+~cs69.51.22.orig-natural-compare.tar.xz
 36d624b358ee6ca2777e0340d162cabc8100ee65 3556 node-jest_27.5.1~ds+~cs69.51.22.orig-p-each-series.tar.xz
 e088939885580af45ce9644d025b5c82aa9549b3 3408 node-jest_27.5.1~ds+~cs69.51.22.orig-p-reduce.tar.xz
 237b04507b6e01cd4f7edd0496c94478e7608983 1380 node-jest_27.5.1~ds+~cs69.51.22.orig-repl.tar.xz
 450860fc07de67f72b7f0891eef1ca8c82d1485d 9076 node-jest_27.5.1~ds+~cs69.51.22.orig-resolveexports.tar.xz
 d1f22873c7a70b87735e671923dfd54d60cbdf8e 2992 node-jest_27.5.1~ds+~cs69.51.22.orig-string-length.tar.xz
 e3bc32cb4fa7f42fcc85c325d1af714c963d01ad 4204 node-jest_27.5.1~ds+~cs69.51.22.orig-supports-hyperlinks.tar.xz
 96c31ca192f14f397b9ad2275023a35b0c384d51 403476 node-jest_27.5.1~ds+~cs69.51.22.orig-terminal-link.tar.xz
 96fcbff0842c571f78768ce02f01095790425b95 8640 node-jest_27.5.1~ds+~cs69.51.22.orig-throat.tar.xz
 fb866606c9a6588577262c64fc119be32bbce18a 1528 node-jest_27.5.1~ds+~cs69.51.22.orig-types-dedent.tar.xz
 8430ac219c0d5496face037b1d1c02a15b5ac4a1 1568 node-jest_27.5.1~ds+~cs69.51.22.orig-types-is-ci.tar.xz
 2fbfd713f64d0575442b539f692f0d3ce098bf8b 1576 node-jest_27.5.1~ds+~cs69.51.22.orig-types-natural-compare.tar.xz
 638af350fdfe569e9cdb2acdb391c476402d53a9 14952 node-jest_27.5.1~ds+~cs69.51.22.orig-typesjest.tar.xz
 cbcb11424fa93457b4fa8d02b4f25d6da232edb2 9399388 node-jest_27.5.1~ds+~cs69.51.22.orig.tar.xz
 b88a3f1a615903583c858ae63e588e68eab2be5f 56520 node-jest_27.5.1~ds+~cs69.51.22-2.debian.tar.xz
Checksums-Sha256:
 99d1ac16901cbc18e140d5fd41352b086392055f00c0f370b9c420998ace29ce 2576 node-jest_27.5.1~ds+~cs69.51.22.orig-astral-regex.tar.xz
 fb35b2557844a1900187e66ae649fd9150f9ab49f8698fa0885b272f95c19092 8924 node-jest_27.5.1~ds+~cs69.51.22.orig-babel-preset-moxy.tar.xz
 9f255bf24436cd12ae1d860a49028c561dc5cb1cea8df26e9dc2885f650dcd19 13760 node-jest_27.5.1~ds+~cs69.51.22.orig-bcoe-v8-coverage.tar.xz
 bfc0517713216ea9192b7468ecfc05e2eb3cddb95f5a1ec3d2c31f5b5be83f04 73360 node-jest_27.5.1~ds+~cs69.51.22.orig-char-regex.tar.xz
 8f172d30eb27afb650734f179be7fb98f3277ab3b43cdb905097ac87d636bfc6 706016 node-jest_27.5.1~ds+~cs69.51.22.orig-cjs-module-lexer.tar.xz
 cad417853cab5f9c5442db3954f66e7714626fd58d65e72be3e79ada841ee892 80316 node-jest_27.5.1~ds+~cs69.51.22.orig-collect-v8-coverage.tar.xz
 cf5e12ca894ceebf19ff1ead1161eca1168d43f8adb43daf61a432ce4ba06efc 28260 node-jest_27.5.1~ds+~cs69.51.22.orig-dedent.tar.xz
 791971b7c7ef5ebb4879cc945b28b6897e62cca87f41c5bd756ec258f5925cf7 4108 node-jest_27.5.1~ds+~cs69.51.22.orig-import-local.tar.xz
 c3c3456ed1bf2a748f53ee38aaa070961ebb97708c7f5ff46e008b2d35253f3d 4212 node-jest_27.5.1~ds+~cs69.51.22.orig-is-ci.tar.xz
 cff09b25cd56cf01b534f62a5241b34caa21481174d0a9c7d3b8f239abfdf3f1 2716 node-jest_27.5.1~ds+~cs69.51.22.orig-jest-pnp-resolver.tar.xz
 c1c97676fc0060b2eba93bef5d993315c20bdcdb834ef1edfbf5aefb5fa35b73 44296 node-jest_27.5.1~ds+~cs69.51.22.orig-jest-snapshot-serializer-raw.tar.xz
 8252aad41a73bf32ce73c519013788c3d35779685384be399b127294011aebc4 2400 node-jest_27.5.1~ds+~cs69.51.22.orig-jest-tobetype.tar.xz
 4b01bfb7e574b647cb9523f70e579d23b2cbb16fd923d856219908e35b40ce47 3388 node-jest_27.5.1~ds+~cs69.51.22.orig-natural-compare-lite.tar.xz
 e181d0f7da79010f2d348595d8e92be66422cba41dad300a50864d5aaf244a9b 2428 node-jest_27.5.1~ds+~cs69.51.22.orig-natural-compare.tar.xz
 abffe656efbb7bd12c61b13ada88b9afc881b06af50cbb257529cf763c3bb68d 3556 node-jest_27.5.1~ds+~cs69.51.22.orig-p-each-series.tar.xz
 4973d124bf28c012c12c479523152d8bcdfd5f2e20c254ce45fce35c1c1d9b82 3408 node-jest_27.5.1~ds+~cs69.51.22.orig-p-reduce.tar.xz
 a45b487287065cf5a6c83efb84ab9b3584e83e92ec14b2ba27353808e200e430 1380 node-jest_27.5.1~ds+~cs69.51.22.orig-repl.tar.xz
 ff3795d8bafacdbc596a3cf00db340301c93e69a67723dd552d0e893f2272032 9076 node-jest_27.5.1~ds+~cs69.51.22.orig-resolveexports.tar.xz
 e671f54808bcc8715caf774423fed33d6913acc508d37284d5c7d33f228dbc55 2992 node-jest_27.5.1~ds+~cs69.51.22.orig-string-length.tar.xz
 88b89112d478a25582c5a7261cf9b0a299387de4145a489d9ac19cc06c7d622e 4204 node-jest_27.5.1~ds+~cs69.51.22.orig-supports-hyperlinks.tar.xz
 4d95b6bc254443a204f9cc994287baea0edb2e24abfe10df001b9348384218c7 403476 node-jest_27.5.1~ds+~cs69.51.22.orig-terminal-link.tar.xz
 132e8153329506bafc68de95774571eb44d981a5d7d8e32182d84b209be32766 8640 node-jest_27.5.1~ds+~cs69.51.22.orig-throat.tar.xz
 5ae401afb1dda6a4288242caafc81e51efa6a335129820bac0eb7ec0fe59854a 1528 node-jest_27.5.1~ds+~cs69.51.22.orig-types-dedent.tar.xz
 6f50fa246d23750a70cf4d01fad4cb048a9ec9d599afd121e896875e82cc353f 1568 node-jest_27.5.1~ds+~cs69.51.22.orig-types-is-ci.tar.xz
 04638c832f516b154a61e4a6cd5078da976e9c17d170f884b719a09414976eaf 1576 node-jest_27.5.1~ds+~cs69.51.22.orig-types-natural-compare.tar.xz
 987e11b88971c35a2a91af6094aca227f22187bd0556c56db76131dc5c15fa33 14952 node-jest_27.5.1~ds+~cs69.51.22.orig-typesjest.tar.xz
 33a81bcfc68a50a503bd324bb99c4ca79263501d84bb08670fd2fcee5b5d67c4 9399388 node-jest_27.5.1~ds+~cs69.51.22.orig.tar.xz
 89a597b6ed897a67cc1ae093a38287b4bc5e91918134ffc4218b01983d710d7c 56520 node-jest_27.5.1~ds+~cs69.51.22-2.debian.tar.xz
Files:
 0c82601527ddc88a1cd9f3f8cc999635 2576 node-jest_27.5.1~ds+~cs69.51.22.orig-astral-regex.tar.xz
 ccc53919cbdc0c2b362a109b13cd98a0 8924 node-jest_27.5.1~ds+~cs69.51.22.orig-babel-preset-moxy.tar.xz
 9014f1e3f4a43415be3c13c57e52055a 13760 node-jest_27.5.1~ds+~cs69.51.22.orig-bcoe-v8-coverage.tar.xz
 1c7567fe28c1074540d8d8f1082adeb6 73360 node-jest_27.5.1~ds+~cs69.51.22.orig-char-regex.tar.xz
 2670223dba8e1c10fe0533604f392da8 706016 node-jest_27.5.1~ds+~cs69.51.22.orig-cjs-module-lexer.tar.xz
 775dfa18d2519508197a5da3958cc13b 80316 node-jest_27.5.1~ds+~cs69.51.22.orig-collect-v8-coverage.tar.xz
 e1c2d3ce39104de3aff936213bc9aa65 28260 node-jest_27.5.1~ds+~cs69.51.22.orig-dedent.tar.xz
 8001463ca1a37f58b3eba8bc9158cefe 4108 node-jest_27.5.1~ds+~cs69.51.22.orig-import-local.tar.xz
 eb1fcf55648d8a37dab52061cf579dc5 4212 node-jest_27.5.1~ds+~cs69.51.22.orig-is-ci.tar.xz
 f9b51f677b925bc3e766c8192bdf84f6 2716 node-jest_27.5.1~ds+~cs69.51.22.orig-jest-pnp-resolver.tar.xz
 6acbe75c302726b9a85022a57c5eb06e 44296 node-jest_27.5.1~ds+~cs69.51.22.orig-jest-snapshot-serializer-raw.tar.xz
 cf607777a0908238bce194eeb14b2151 2400 node-jest_27.5.1~ds+~cs69.51.22.orig-jest-tobetype.tar.xz
 1526f705d71855a82a3bbbb33f4e9485 3388 node-jest_27.5.1~ds+~cs69.51.22.orig-natural-compare-lite.tar.xz
 714acdc99563c75fe60a3279d87d27d0 2428 node-jest_27.5.1~ds+~cs69.51.22.orig-natural-compare.tar.xz
 bacb97a740b4bd223f1a8b189b7f406b 3556 node-jest_27.5.1~ds+~cs69.51.22.orig-p-each-series.tar.xz
 f89348b50cb288402dbd5ef19397ef85 3408 node-jest_27.5.1~ds+~cs69.51.22.orig-p-reduce.tar.xz
 591622ea92a55617d32410375fbdad7b 1380 node-jest_27.5.1~ds+~cs69.51.22.orig-repl.tar.xz
 8f8032e08530f5abb45929c99fb73d05 9076 node-jest_27.5.1~ds+~cs69.51.22.orig-resolveexports.tar.xz
 54186aff9e64d9b0cd94c7d8a016e402 2992 node-jest_27.5.1~ds+~cs69.51.22.orig-string-length.tar.xz
 0e9182d58ac8b8be1be6951faa4762c5 4204 node-jest_27.5.1~ds+~cs69.51.22.orig-supports-hyperlinks.tar.xz
 3d30ddacc3bc8d4cf133e7d9a8dd980c 403476 node-jest_27.5.1~ds+~cs69.51.22.orig-terminal-link.tar.xz
 dd8e9d659ef62c62097f97424b25e013 8640 node-jest_27.5.1~ds+~cs69.51.22.orig-throat.tar.xz
 0bea0afc6d55511df47b39a07f758d7f 1528 node-jest_27.5.1~ds+~cs69.51.22.orig-types-dedent.tar.xz
 675d3d2f4a8f39b83ba987409036b9a6 1568 node-jest_27.5.1~ds+~cs69.51.22.orig-types-is-ci.tar.xz
 6a9baa5b0945723d6f08c2f16b84e4b2 1576 node-jest_27.5.1~ds+~cs69.51.22.orig-types-natural-compare.tar.xz
 7aa8692774079a7b4837a0d1a317db3c 14952 node-jest_27.5.1~ds+~cs69.51.22.orig-typesjest.tar.xz
 d967e5295f93fb0a1fab48517b2328c0 9399388 node-jest_27.5.1~ds+~cs69.51.22.orig.tar.xz
 aff2d03f75ce99fd58f1c8d00cf7f3ee 56520 node-jest_27.5.1~ds+~cs69.51.22-2.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEAN/li4tVV3nRAF7J9tdMp8mZ7ukFAmIIwoQACgkQ9tdMp8mZ
7um5Ig/+I3x3Yf8xfAZZx8FMoSIQWKjBT0INqA5GfKxx+QjcYovYoDN3aQtWs4YN
Q13PvaepYXlMmufTqgC1BU4Yq93DMl51r11lVO8V2nzVt07A8qEtcZJ7pN77cHY3
yyGSa+wwKbQT4HaE6xF1WRhYl10qcqg5dTIm3EsQMudxPBJW9qbWGB59YENQ3Ano
8j1UJ8NAI/KkEyPlBeFCDBa6EMdx/ziAN0hTyKLUKhPoX01qNBKY01RwpmsCwKgg
9hQ5fUQu6n55PlABkydKOz1J64+xg2zOn2N3t7CToSG2QZwIwkKjU5IYqz3QaCFQ
FpaLj4DrtfgPiwDb1johKmqqzTwnDDqEfNL3Kiev9BW7nph9gyt0PSowlNy5SLN5
hp984CtuLKff/lSvzHVrJs5KUDgUGJToTMAINcCS4l1woeIZ5PluQ59uJidg7zL+
rLm7lolbsXPQ58JaLs5lpvW5lDEjC1AACTJ1njd3CmDFzUhMv5zzwlwzFd7DMUyf
KDL+6HJn1iVPvdbiChwDV4LRXwPMBHb/W82c2U2hk/hLcysooIp6OokzTpIwgQ1w
uAV5y/lPmD6W736t6jtDGoswlAB1VbJy+Jfi5O7lZ9pNy/TliKaU+s5KCRcSNY4z
JiTF6ttUAsOYhE6oBMvTK2ZUh3AxdFKSRrgxjwWbBdrhJbV2RfQ=
=vGFk
-----END PGP SIGNATURE-----
