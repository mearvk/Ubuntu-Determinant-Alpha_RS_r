-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: node-gulp
Binary: gulp
Architecture: all
Version: 4.0.2+~cs54.26.36-5
Maintainer: Debian Javascript Maintainers <pkg-javascript-devel@lists.alioth.debian.org>
Uploaders: Pirate Praveen <praveen@debian.org>
Homepage: https://gulpjs.com
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/js-team/node-gulp
Vcs-Git: https://salsa.debian.org/js-team/node-gulp.git
Testsuite: autopkgtest, autopkgtest-pkg-nodejs
Testsuite-Triggers: @builddeps@
Build-Depends: debhelper-compat (= 13), dh-sequence-nodejs, mocha <!nocheck>, node-ansi-colors <!nocheck>, node-anymatch <!nocheck>, node-archy <!nocheck>, node-arr-flatten <!nocheck>, node-array-each <!nocheck>, node-array-slice <!nocheck>, node-chokidar <!nocheck>, node-concat-stream <!nocheck>, node-define-properties <!nocheck>, node-end-of-stream <!nocheck>, node-es6-iterator <!nocheck>, node-es6-symbol <!nocheck>, node-es6-weak-map <!nocheck>, node-expand-tilde <!nocheck>, node-fancy-log <!nocheck>, node-fast-levenshtein <!nocheck>, node-findup-sync <!nocheck>, node-fined <!nocheck>, node-for-own <!nocheck>, node-get-value <!nocheck>, node-gulplog <!nocheck>, node-has <!nocheck>, node-interpret <!nocheck>, node-is-generator-function <!nocheck>, node-is-negated-glob <!nocheck>, node-is-number <!nocheck>, node-is-plain-object <!nocheck>, node-is-regex <!nocheck>, node-is-unc-path <!nocheck>, node-is-windows <!nocheck>, node-isobject <!nocheck>, node-kind-of <!nocheck>, node-liftoff <!nocheck>, node-make-iterator <!nocheck>, node-marked-man <!nocheck>, node-micromatch <!nocheck>, node-minimist <!nocheck>, node-mkdirp (>= 1) <!nocheck>, node-normalize-path <!nocheck>, node-object-inspect <!nocheck>, node-once <!nocheck>, node-parse-node-version <!nocheck>, node-pretty-hrtime <!nocheck>, node-process-nextick-args <!nocheck>, node-remove-trailing-separator <!nocheck>, node-resolve <!nocheck>, node-rimraf <!nocheck>, node-stack-trace <!nocheck>, node-tmatch <!nocheck>, node-v8flags <!nocheck>, node-vinyl-fs <!nocheck>, node-yargs <!nocheck>, node-fs-extra <!nocheck>, node-semver <!nocheck>
Package-List:
 gulp deb javascript optional arch=all
Checksums-Sha1:
 a9e7c34dab4ba3f840ab2c2a03f0083717a9e354 39957 node-gulp_4.0.2+~cs54.26.36.orig-arr-filter.tar.gz
 2c669f73a3c05d101e8962e43fddd9b870312047 11322 node-gulp_4.0.2+~cs54.26.36.orig-arr-map.tar.gz
 1e155814cff35db5832b2abd9dced9703a67af3e 3018 node-gulp_4.0.2+~cs54.26.36.orig-array-initial.tar.gz
 e141d8a43909837991963008589a84ef7c407379 2599269 node-gulp_4.0.2+~cs54.26.36.orig-array-last.tar.gz
 2879016fb52a2d7fed7765bb1c492c725a2e84ad 8159 node-gulp_4.0.2+~cs54.26.36.orig-array-sort.tar.gz
 9efd02f2f4df5225dc59ac7b90a878cc7be244fc 9568 node-gulp_4.0.2+~cs54.26.36.orig-async-done.tar.gz
 c77f47a84670f6ace6a714e13b8044c3b0683616 3376 node-gulp_4.0.2+~cs54.26.36.orig-async-settle.tar.gz
 c08907d10ce6df709eabeab72166919c711fef48 6585 node-gulp_4.0.2+~cs54.26.36.orig-bach.tar.gz
 565724cf205d43793aeea941598c7071cb3a3628 5049 node-gulp_4.0.2+~cs54.26.36.orig-collection-map.tar.gz
 1e0555b25e9fe2566eb7173db142e4c2d257ac21 22679 node-gulp_4.0.2+~cs54.26.36.orig-copy-props.tar.gz
 f1eb6392b1e78969fe2b189cd8ee82923a7eee4c 7244 node-gulp_4.0.2+~cs54.26.36.orig-default-compare.tar.gz
 c18ae74e8e80e61cc651a6a568d6fc16e4568ce1 4208 node-gulp_4.0.2+~cs54.26.36.orig-default-resolution.tar.gz
 da2ec4237c22d8a1500802e5373d6a44ca5aa92f 16200 node-gulp_4.0.2+~cs54.26.36.orig-each-props.tar.gz
 4bfd84ed078bef33e6d1b8e8b28224fafe858630 2184 node-gulp_4.0.2+~cs54.26.36.orig-eslint-config-gulp.tar.gz
 326f54fab534d6bbcbb15b249861efdff90590ca 7090 node-gulp_4.0.2+~cs54.26.36.orig-glob-watcher.tar.gz
 abd69cf1abdc9e3f97184e0aad5c45ffe5073753 16800 node-gulp_4.0.2+~cs54.26.36.orig-gulp-cli.tar.gz
 1f435fc74a65284d0eb5f8760eb43574ed3beb89 5921 node-gulp_4.0.2+~cs54.26.36.orig-is-absolute.tar.gz
 0f7f9028bc2fd2392ed141a597cede163e043598 5016 node-gulp_4.0.2+~cs54.26.36.orig-is-relative.tar.gz
 c923544cc26b7a240e49182926285dc035e36b41 19592 node-gulp_4.0.2+~cs54.26.36.orig-just-debounce.tar.gz
 90b91bd4b090a943f9e488609302cb2b28477c7d 4193 node-gulp_4.0.2+~cs54.26.36.orig-last-run.tar.gz
 a16cd1424ffb9416fe0de2a2b07e7e9d60803feb 4308 node-gulp_4.0.2+~cs54.26.36.orig-matchdep.tar.gz
 59a8a8cc820177bf52a8e57bad9ec56b4580e188 4232 node-gulp_4.0.2+~cs54.26.36.orig-mute-stdout.tar.gz
 5fdb27302fa67ef29cf99c42363428802d698a0f 5871 node-gulp_4.0.2+~cs54.26.36.orig-now-and-later.tar.gz
 d3e361697bb2f603ff8498e3e7cb16434ecfed06 2782 node-gulp_4.0.2+~cs54.26.36.orig-object-reduce.tar.gz
 953d14ac3da87e9aa7410ca69335b9bf64f1da6a 3633 node-gulp_4.0.2+~cs54.26.36.orig-replace-homedir.tar.gz
 dcf912f605b89225095226397e9f9c7388d8bcaa 3571 node-gulp_4.0.2+~cs54.26.36.orig-semver-greatest-satisfied-range.tar.gz
 925dc2db5333db4a33145b26386f6fa2b64fa727 2057 node-gulp_4.0.2+~cs54.26.36.orig-stream-exhaust.tar.gz
 029bb4e0a7ca678b74b50d5ded9ed9c00b265948 8638 node-gulp_4.0.2+~cs54.26.36.orig-sver-compat.tar.gz
 a3cbdffe788e3a3bef3d5aae2416331b0d78010d 2766 node-gulp_4.0.2+~cs54.26.36.orig-types-gulp.tar.gz
 073e56fa28bd4496a752c6042c46ec42029b89a8 2014 node-gulp_4.0.2+~cs54.26.36.orig-types-undertaker-registry.tar.gz
 accde2df2545242342ff625e26068d20fe8c694a 2849 node-gulp_4.0.2+~cs54.26.36.orig-types-undertaker.tar.gz
 173a937021918cb008a3c070e4ba57097ce76e0a 4636 node-gulp_4.0.2+~cs54.26.36.orig-undertaker-registry.tar.gz
 e3b1e51f4c6421f7bdaaf0ec53b0ab9e48a70e7f 14623 node-gulp_4.0.2+~cs54.26.36.orig-undertaker.tar.gz
 e0b044b27d3c9dce33e499cffecc790dec27c58c 261773 node-gulp_4.0.2+~cs54.26.36.orig.tar.gz
 c6d6bc8a97bb8358252efd4b50ba78ce20611a03 40580 node-gulp_4.0.2+~cs54.26.36-5.debian.tar.xz
Checksums-Sha256:
 193228243ecf334f4d6047e95ce93a43e620995ff96056572ab9b6eacbd55b95 39957 node-gulp_4.0.2+~cs54.26.36.orig-arr-filter.tar.gz
 5782b5ac2e72fed5cd10a68d4ff6b07348b8475ff091d1e3f31856905dd151b6 11322 node-gulp_4.0.2+~cs54.26.36.orig-arr-map.tar.gz
 08468a8c589f2c7c3d5c45f79fcee8025dffedf24c84a1b76e6e0881b68002c1 3018 node-gulp_4.0.2+~cs54.26.36.orig-array-initial.tar.gz
 9a7144dd2f95d2755a110e63bbb0792f7ed270c72cf251d0c1ec8add12e22128 2599269 node-gulp_4.0.2+~cs54.26.36.orig-array-last.tar.gz
 d932e8c65d96d0b5dd055d43abf03e66b287294693eb603b6f918f573968358b 8159 node-gulp_4.0.2+~cs54.26.36.orig-array-sort.tar.gz
 70b4a1e4039f3e68d70d063ab282d19c974aa77b71bb1ded0b5de6222b9188ee 9568 node-gulp_4.0.2+~cs54.26.36.orig-async-done.tar.gz
 0ddc499df6288012e8fa16f491431c364164e2ff77f70b74426e33777df3b2e1 3376 node-gulp_4.0.2+~cs54.26.36.orig-async-settle.tar.gz
 263091bd718f3134e09a12615bfa29a30dcb34809502d086453aaa910436527b 6585 node-gulp_4.0.2+~cs54.26.36.orig-bach.tar.gz
 58ba1ecb6f41498a8490d4f117cf1891a42da91c0b5236582f7869daa46c3294 5049 node-gulp_4.0.2+~cs54.26.36.orig-collection-map.tar.gz
 6048aec3e7c7c4e9ea78cea4837032059f390a3209099ff5e3e16375e7d7ade9 22679 node-gulp_4.0.2+~cs54.26.36.orig-copy-props.tar.gz
 ca3995fff4eafabd804e84ae9aba9e8977df5d3ee8090ed9b6756b54ff251a50 7244 node-gulp_4.0.2+~cs54.26.36.orig-default-compare.tar.gz
 a1e70095f8db57135084e3d92d23bef4cfa41a7b300d7a2b9b469f635add2409 4208 node-gulp_4.0.2+~cs54.26.36.orig-default-resolution.tar.gz
 c2653e33617e5f1abac463c4999653a8f5cb5468c4e6e44e269425d1931cc757 16200 node-gulp_4.0.2+~cs54.26.36.orig-each-props.tar.gz
 0b29d3efc3bb5ee18bbe77bdbc8f841909ff4d6d06a8f8c9c397b6f5e1ac667c 2184 node-gulp_4.0.2+~cs54.26.36.orig-eslint-config-gulp.tar.gz
 23a549ddf379853a2d19d0c19cad9caa4b49d0cd7bec219297ecbc22ca52a13d 7090 node-gulp_4.0.2+~cs54.26.36.orig-glob-watcher.tar.gz
 b1f68ea795f46c978cb0ca68e134b431ec9f15e5b5fa03c8a8f38ed378289bbe 16800 node-gulp_4.0.2+~cs54.26.36.orig-gulp-cli.tar.gz
 bfea730dc95d3ed671144d7054e90ecd47684b866f9079b1bb788745ed345374 5921 node-gulp_4.0.2+~cs54.26.36.orig-is-absolute.tar.gz
 d19ced368e2fb4015a03ab83ba3c858c89f3fdd0a4ee04ac3a7d6fe9891dc73b 5016 node-gulp_4.0.2+~cs54.26.36.orig-is-relative.tar.gz
 a42a85e82a78c570b6c2ee8f77f8774312bc476b2a10550df16826e489483577 19592 node-gulp_4.0.2+~cs54.26.36.orig-just-debounce.tar.gz
 cdfcbec947eca35ff16820140bb4b3d35e999c1620db516daa34b256cbd78f58 4193 node-gulp_4.0.2+~cs54.26.36.orig-last-run.tar.gz
 e02b584949722e4aa550eafff811ea857a56ddbfdcfda3df6004c48f2b224f39 4308 node-gulp_4.0.2+~cs54.26.36.orig-matchdep.tar.gz
 0a429fc8951f37e8787297dbe80c2b32863906dd62ac91a51b1b30fd7e762215 4232 node-gulp_4.0.2+~cs54.26.36.orig-mute-stdout.tar.gz
 7a2a9c802c441534a4a8cbf4ff623b38e4d97296afd16d3643ef165feb13a852 5871 node-gulp_4.0.2+~cs54.26.36.orig-now-and-later.tar.gz
 6d8f00dd42d42dbc51ccff6cc0fac93f31734fbed8751d32bd585e481f6b4090 2782 node-gulp_4.0.2+~cs54.26.36.orig-object-reduce.tar.gz
 874fd113acc2ef539df1c87b01a620c284d93a92ac61e31de69c2dac9599cc17 3633 node-gulp_4.0.2+~cs54.26.36.orig-replace-homedir.tar.gz
 faef32eec2637e5c4dddf1d626f3fe52d254a581ed8abef6f67f26567eefda51 3571 node-gulp_4.0.2+~cs54.26.36.orig-semver-greatest-satisfied-range.tar.gz
 90a244e66157aab6ed7fd0cff1330ed5f0c6b2e204ed0a3269ced3bb20b65b23 2057 node-gulp_4.0.2+~cs54.26.36.orig-stream-exhaust.tar.gz
 cb3a9a79dfb4ac1a1b3731b2d787c526a17e78fdd7f301259ac7d6b77aac18f0 8638 node-gulp_4.0.2+~cs54.26.36.orig-sver-compat.tar.gz
 84131b3eccddeaeb2629811fc5fc9b392742fd3b2e8364c35704b643ed2c998e 2766 node-gulp_4.0.2+~cs54.26.36.orig-types-gulp.tar.gz
 b753e421fbd5a170be4d16a737896abe8ee066c9562077fcf64c91f03577dd6c 2014 node-gulp_4.0.2+~cs54.26.36.orig-types-undertaker-registry.tar.gz
 e05f7539b6b2c5cff4c4d1612bd0c683c3dec5456a69faf6933ffbfbc5972f0d 2849 node-gulp_4.0.2+~cs54.26.36.orig-types-undertaker.tar.gz
 8226de21adf6f3208bc679d8aff991e511af7e59685fd0f86845a2c0cf588177 4636 node-gulp_4.0.2+~cs54.26.36.orig-undertaker-registry.tar.gz
 7a02ecdad5f3b6299cfe17a6d0a42c8fdeb6b35c8d8e172c13f1ced69f7e601c 14623 node-gulp_4.0.2+~cs54.26.36.orig-undertaker.tar.gz
 5dd3519e6a59282652e70920f8967250120929e2420e3539b27306fcf205b03c 261773 node-gulp_4.0.2+~cs54.26.36.orig.tar.gz
 a524212671ceb2c8d92cd062b54edf52496cd189610dece1afa8995dbc2b8b2d 40580 node-gulp_4.0.2+~cs54.26.36-5.debian.tar.xz
Files:
 683c37d599eb6af48112b62fc8d5d131 39957 node-gulp_4.0.2+~cs54.26.36.orig-arr-filter.tar.gz
 a33b08ff76d5984a20c575ac14e20727 11322 node-gulp_4.0.2+~cs54.26.36.orig-arr-map.tar.gz
 903ac41c3b62696447f056e91431d09d 3018 node-gulp_4.0.2+~cs54.26.36.orig-array-initial.tar.gz
 158a4b33419194595b77508aea174374 2599269 node-gulp_4.0.2+~cs54.26.36.orig-array-last.tar.gz
 aa38ab155d1bcbd59cac04585f0f6c46 8159 node-gulp_4.0.2+~cs54.26.36.orig-array-sort.tar.gz
 469ebd05c56a36ed91386b1578c2d5be 9568 node-gulp_4.0.2+~cs54.26.36.orig-async-done.tar.gz
 6f3bd2938a351f1e49b70750829c734f 3376 node-gulp_4.0.2+~cs54.26.36.orig-async-settle.tar.gz
 704983c02767b7e62d2479b88d185d4c 6585 node-gulp_4.0.2+~cs54.26.36.orig-bach.tar.gz
 729a1c5c121c13deda85fd69d82b1a10 5049 node-gulp_4.0.2+~cs54.26.36.orig-collection-map.tar.gz
 dd0367d152614814492816b3e8f3ecd0 22679 node-gulp_4.0.2+~cs54.26.36.orig-copy-props.tar.gz
 dc2f4bceef17ca1e2bd83425250a8bc9 7244 node-gulp_4.0.2+~cs54.26.36.orig-default-compare.tar.gz
 fa7c6169156078e104a979363e407296 4208 node-gulp_4.0.2+~cs54.26.36.orig-default-resolution.tar.gz
 8f4246131e40dc3640e2068a27e0dc41 16200 node-gulp_4.0.2+~cs54.26.36.orig-each-props.tar.gz
 ec4b5a96aaeb2da751db0a50cd3c929b 2184 node-gulp_4.0.2+~cs54.26.36.orig-eslint-config-gulp.tar.gz
 28f651ee6b7406bf2ea0aab57d034780 7090 node-gulp_4.0.2+~cs54.26.36.orig-glob-watcher.tar.gz
 1ee91d660de33a10f5d270a596feb683 16800 node-gulp_4.0.2+~cs54.26.36.orig-gulp-cli.tar.gz
 52206f154114c9ae7e41fb1cfa31cb2e 5921 node-gulp_4.0.2+~cs54.26.36.orig-is-absolute.tar.gz
 6937e611f76c49ddacc77c54df08d368 5016 node-gulp_4.0.2+~cs54.26.36.orig-is-relative.tar.gz
 5b2f70c74d1a52923ca32d1dedde14e7 19592 node-gulp_4.0.2+~cs54.26.36.orig-just-debounce.tar.gz
 f2088efbb65f90e74dcf7b4831455205 4193 node-gulp_4.0.2+~cs54.26.36.orig-last-run.tar.gz
 39e669221a96e42814813a6836b126ad 4308 node-gulp_4.0.2+~cs54.26.36.orig-matchdep.tar.gz
 4491b5b935a095e2773f5c537169ddac 4232 node-gulp_4.0.2+~cs54.26.36.orig-mute-stdout.tar.gz
 676fbe6fd792f471ab06702fb338e4b0 5871 node-gulp_4.0.2+~cs54.26.36.orig-now-and-later.tar.gz
 82fb139761b02dcc4c8ad5f65754642f 2782 node-gulp_4.0.2+~cs54.26.36.orig-object-reduce.tar.gz
 55f5704f16718b481501eee3f5e4eb93 3633 node-gulp_4.0.2+~cs54.26.36.orig-replace-homedir.tar.gz
 75453fce2160ba34679c802e0d95efc2 3571 node-gulp_4.0.2+~cs54.26.36.orig-semver-greatest-satisfied-range.tar.gz
 fc506656e5612b741ec6f463f325c537 2057 node-gulp_4.0.2+~cs54.26.36.orig-stream-exhaust.tar.gz
 995ba611e705284e9ca191fac88366b6 8638 node-gulp_4.0.2+~cs54.26.36.orig-sver-compat.tar.gz
 a468f5250ee8f25a6b82fa22089f94f4 2766 node-gulp_4.0.2+~cs54.26.36.orig-types-gulp.tar.gz
 3b9edda2dac7e3ef4584d86db5760bca 2014 node-gulp_4.0.2+~cs54.26.36.orig-types-undertaker-registry.tar.gz
 b848314ff8abd5f192b8ab5d9a23ec64 2849 node-gulp_4.0.2+~cs54.26.36.orig-types-undertaker.tar.gz
 d9c5f49bde95d894400fc78cf5760f98 4636 node-gulp_4.0.2+~cs54.26.36.orig-undertaker-registry.tar.gz
 482ec0dff6f9f074523cc372c833f5d2 14623 node-gulp_4.0.2+~cs54.26.36.orig-undertaker.tar.gz
 f05b40574ab7f58941976747156b0c32 261773 node-gulp_4.0.2+~cs54.26.36.orig.tar.gz
 f3f9211a6673bd1ad31516b2e1958862 40580 node-gulp_4.0.2+~cs54.26.36-5.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEAN/li4tVV3nRAF7J9tdMp8mZ7ukFAmHgNioACgkQ9tdMp8mZ
7um0VQ//ccgJwYmytuQ1RoNm+hqETNWDrR9t5XU/EWlDrP+FBO/BST5Pt6KQmm6L
WxneGpYdazN4yl3U12WoE6Q2/FFOKTDHJMXGlFCqbkHa1/d8vQzNEMHRIxl9Jjx2
TKOZuBssC4TNlPPhp/EKDY7uipaxP0QhTJBnERSm6hRZiNW+M2rtE8u5GrfSuwm2
vVSG/ajc0s3m8et+g9BOoZTqw2DyLXqtzcurlHDIb6Q54tWpbQpDbPVIH0/w6hvX
QIGyL4VF7XLYh6M6OIb+/BrIbJ7nOhkFwu0WTa2qyv/lK3mgylRqbmXWNLXVVIm3
iGldgAR0DeUFAadGnkHqN2ci+O6goqBznb5eOzMO20phP+3ohvfqbqp2PmsL3vBn
K2b/OdFTeuQ5B4sQte+SFcJCNbyj5+TP+Jbt+gvUTxQuubKgkaErV3Uq53ZX0kqI
BoOrLWA/B7MWBpgbyFIdtYXkXlQALMY2VDWub4fq6DpSjjsBU5dpLkmuUf/ks6UJ
3s5ZMemA68S+A+tax2AxO/XPYPepBvKFIt7xOgne98QifbNHKaNMPl4iOtZKvbJ5
Lct1dFUD8BJLCJWjCpFU/b6Ys5tLf1Md2d1g32QQUXXzUI7mCoCqAZ22ZfjwgyJX
8u9xM0GBqlAaVfUqKoeBhj05Dppqlf8CPY7voT1198znp8yoZ20=
=2w/6
-----END PGP SIGNATURE-----
