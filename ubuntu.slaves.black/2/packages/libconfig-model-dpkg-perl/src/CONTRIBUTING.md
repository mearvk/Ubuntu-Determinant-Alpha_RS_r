# How to contribute #

## Ask questions ##

Yes, asking a question is a form of contribution that helps the author
to improve documentation.

This package is used a lot by Debian Perl team, so you can ask
question on
[debian-perl mailing list](mailto:debian-perl@lists.debian.org) or on `#debian-perl` (IRC)

## Log a bug ##

Please report issue on Debian BTS: run `reportbug libconfig-model-dpkg-perl`

## Source code structure ##

This package delivers 2 main tools:

* a `scan-copyrights` command which parse a source files for copyright and license information and provides `Files` section of a `debian/copyright` file. 
* The Dpkg plugin for `cme`

The main parts of this package are:
* `scan-copyright` files:
** `bin/scan-copyright`
** `lib/Dpkg/Copyright/Scanner.pm`: library used by `scan-copyrights`. This class coalesces the information found by `licensecheck` and provides a set of `Files` entries that can be copied in `debian/copyright`
* Model of the package files:
** `lib/Config/Model/application.d`: declares the applications that `cme` can configure with this package 
** `lib/Config/Model/models/**.pl`: the models of the package files. These files can be modified with `cme meta edit` command. Their structure can be viewed with `cme meta gen-dot` and `dot -Tps model.dot > model.ps`
** `lib/Config/Model/models/**.pod`: the doc of the above models. Can be re-generated with `cme gen_class_pod`
* Specialized class to perform tasks not done by `Config::Model`:
** `lib/Config/Model/Dpkg/Copyright.pm`: class that merges the result of `Dpkg::Copyright::Scanner` in the existing `debian/copyright`. Not for the faint of heart.
** `lib/Config/Model/Dpkg/Dependency.pm`: class that parses and validates and fix the dependency fields of `debian/control`. Dependency specification and its validation rules are quite complex. This class is rather hairy.
* The backends: classes used to read and write package files when the backends provided by libconfig-model-perl are not enough
** `lib/Config/Model/Backend/DpkgSyntax.pm`: helper functions to read and write files based on `debian/control` syntax.
** `lib/Config/Model/Backend/Dpkg/Copyright.pm`: R/W backend for `debian/copyright`
** `lib/Config/Model/Backend/Dpkg/Patch.pm`: R/W backend for debian patch headers
** `lib/Config/Model/Backend/Dpkg/Control.pm`: R/W backend for `debian/control`
** `lib/Config/Model/Backend/Dpkg.pm`: R/W backend for some simple package files (like `compat`)
* Non-regression tests:
** `t`: test files. Run the tests with `prove -l t`
** `t/model_tests.d` model test based on [Config::Model::Tester](http://search.cpan.org/dist/Config-Model-Tester/lib/Config/Model/Tester.pm). Use `prove -l t/model_test.t` command to run only model tests.

## Edit source code from git ##

You can clone the repo from Salsa:

* run `git clone https://salsa.debian.org/perl-team/modules/packages/libconfig-model-dpkg-perl.git`
* edit files
* run `prove -l t` to run non-regression tests
* run `gbp buildpackage` to build the package

## Edit source code from Debian source package  ##

You can also prepare a patch using Debian source package:

For instance:

* download and unpack `apt-get source libconfig-model-dpkg-perl`
* jump in `cd libconfig-model-dpkg-perl-2.xxx`
* useful to create a patch later: `git init`
* commit all files: `git add -A ; git commit -m"committed all"`
* edit files
* run `prove -l t` to run non-regression tests
* run `git diff` and send the output on [debian-perl mailing list](mailto:debian-perl@lists.debian.org)


