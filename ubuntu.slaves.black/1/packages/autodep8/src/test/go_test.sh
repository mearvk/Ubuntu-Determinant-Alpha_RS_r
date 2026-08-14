. $(dirname $0)/helper.sh

test_Testsuite_autopkgtest_pkg_go() {
  has debian/control 'Testsuite: autopkgtest-pkg-go'
  check_run autodep8
}

test_XS_Testsuite_autopkgtest_pkg_go() {
  has debian/control 'XS-Testsuite: autopkgtest-pkg-go'
  check_run autodep8
}

test_detect_bdepends_golang_go() {
  has 'debian/control' 'Build-Depends: golang-go'
  check_run autodep8
}

test_detect_bdepends_golang_any() {
  has 'debian/control' 'Build-Depends: golang-any'
  check_run autodep8
}

test_detect_bdepends_complex() {
  has 'debian/control' \
      'Build-Depends: golang-any (>= 2:1.4) || golang-go (>= 2:1.4)'
  check_run autodep8
}

test_detect_bdepends_nomatch() {
  has 'debian/control' 'Build-Depends: golang-goNOPE'
  run autodep8
  assertEquals 1 "$exitstatus"
  assertEquals "" "$(cat stdout stderr)"
}

test_detect_depends_golang_go() {
  has 'debian/control' 'Depends: golang-go'
  check_run autodep8
}

test_detect_depends_golang_any() {
  has 'debian/control' 'Depends: golang-any'
  check_run autodep8
}

test_detect_bdependsi_golang_go() {
  has 'debian/control' 'Build-Depends-Indep: golang-go'
  check_run autodep8
}

test_detect_bdependsi_golang_any() {
  has 'debian/control' 'Build-Depends-Indep: golang-any'
  check_run autodep8
}

. shunit2
