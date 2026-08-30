. $(dirname $0)/helper.sh

test_Testsuite_autopkgtest_pkg_dkms() {
  has debian/control 'Testsuite: autopkgtest-pkg-dkms'
  check_run autodep8
}

test_XS_Testsuite_autopkgtest_pkg_dkms() {
  has debian/control 'XS-Testsuite: autopkgtest-pkg-dkms'
  check_run autodep8
}

test_detect_dkms_depends() {
  has 'debian/control' 'Depends: dkms'
  check_run autodep8
}

test_detect_dkms_builddepends() {
  has 'debian/control' 'Build-Depends: dkms'
  check_run autodep8
}

test_detect_dkms_builddepends_indep() {
  has 'debian/control' 'Build-Depends-Indep: dkms'
  check_run autodep8
}

test_detect_dkms_packagename() {
  has 'debian/control' 'Package: foo-dkms'
  check_run autodep8
}

test_dkms_depends_dkms() {
  has 'debian/control' "Depends: dkms"
  check_run autodep8
  assertFalse "test does must depend on dkms\n$(grep Depends: stdout)\n" "grep -q Depends:.*depends stdout"
}

. shunit2
