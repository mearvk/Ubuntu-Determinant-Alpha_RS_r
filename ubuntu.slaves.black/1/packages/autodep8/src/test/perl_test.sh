. $(dirname $0)/helper.sh

test_Testsuite_autopkgtest_pkg_perl() {
  has debian/control 'Testsuite: autopkgtest-pkg-perl'
  check_run autodep8
}

test_XS_Testsuite_autopkgtest_pkg_perl() {
  has debian/control 'XS-Testsuite: autopkgtest-pkg-perl'
  check_run autodep8
}

test_perl_Makefile_PL() {
  has_dir t
  has Makefile.PL
  check_run autodep8
}

test_perl_Build_PL() {
  has_dir t
  has Build.PL
  check_run autodep8
}

test_perl_test_pl() {
  has test.pl
  has Build.PL
  check_run autodep8
}

test_perl_recommends() {
  has debian/control 'Source: perl-foo
Testsuite: autopkgtest-pkg-perl

Package: perl-foo-1
Recommends: perl-bar

Package: perl-foo-2
Recommends: perl-baz'
  check_run autodep8
  assertTrue 'No Recommends in control' 'grep ^Restrictions: stdout | grep --quiet needs-recommends'
}

. shunit2
