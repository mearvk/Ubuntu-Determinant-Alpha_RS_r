# Overview

The files found in this directory are used by
* [t/model_tests.t](../model_tests.t)
* [Config::Model::Tester](https://metacpan.org/pod/Config::Model::Tester)

The tests are implemented in '*-test-conf.pl':

* dpkg-control-test-conf.pl : test debian/control model (Dpkg::Control model)
* dpkg-copyright-test-conf.pl : test debian/copyright (Dpkg::Copyright model)
* dpkg-patches-test-conf.pl : test debian/patches directory (Dpkg::Patches model)
* dpkg-patch-test-conf.pl: test individual patch file (e.g. debian/patch/xxx) (Dpkg::Path model)
* dpkg-test-conf.pl: test all dpkg files and their consistency (Dpkg model)

Each test has test data in *-examples directory:

* dpkg-control-examples
* dpkg-copyright-examples
* dpkg-patches-examples
* dpkg-patch-examples
* dpkg-examples

Some example directories contain only files:

* dpkg-control-examples: each file is a debian/control test file
* dpkg-copyright-examples: each file is a debian/copyright test file
* dpkg-patch-examples: each file is a test DEP-3 patch file

Other example directories contain another directory:

* dpkg-patches-examples: each directory contains a set of patches with the series files
* dpkg-examples: each directory contain most files of a debian source package (without the source)

Each test files contains test cases (a.k.a. `subtests`) that matches
the content of the examples file (e.g. `t0` `autopkgtest` ..).
[Config::Model::Tester](https://metacpan.org/pod/Config::Model::Tester)
provides details on the test description provided in `*-test-conf.pl` files.

To run all tests, you can either do:

* `perl -Ilib t/model_tests.t`
* `prove -lv t/model_tests.t`

You can run one test at a time:

* `perl -Ilib t/model_tests.t dpkg`
* `prove -lv t/model_tests.t :: dpkg`

You can run one subtest at a time:

* `perl -Ilib t/model_tests.t dpkg libversion`
* `prove -lv t/model_tests.t :: dpkg libversion`

The subtest parameter is interpreted as a pattern so you can run
several subtests at a time:

* `perl -Ilib t/model_tests.t dpkg pan-copyright`

Which runs `pan-copyright-upgrade-update`, `pan-copyright-from-scratch`
and `pan-copyright-upgrade-update-more` subtests.

The `perl -Ilib t/model_tests.t` command also accepts options:

* `--trace`: show more information on the data read from the tests files (e.g. `perl -Ilib t/model_tests.t dpkg libversion --trace`)
* `--error`: provide a stack trace in case of error detected by the model
* `--log`: enable logs (either [default logs](https://github.com/dod38fr/config-model/blob/master/lib/Config/Model/log4perl.conf) or from `~/.log4config-model`). See also [Logging doc](https://metacpan.org/pod/Config::Model#Logging)

