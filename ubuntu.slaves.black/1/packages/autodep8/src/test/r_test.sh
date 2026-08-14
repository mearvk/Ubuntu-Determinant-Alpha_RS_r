. $(dirname $0)/helper.sh

test_detect_r() {
  has 'debian/control' 'Source: r-cran-foo'
  has 'DESCRIPTION' 'Package: FOO'
  check_run autodep8
}

test_upstream_name_from_description() {
  has 'debian/control' 'Source: r-cran-foo'
  has 'DESCRIPTION' 'Package: FOO'
  check_run autodep8
}

test_should_not_try_on_other_package_types_starting_with_r() {
  has 'debian/control' 'Testsuite: autopkgtest-pkg-rrrrrrr'
  run autodep8
  assertEquals 1 "$exitstatus"
  assertEquals "" "$(cat stdout stderr)"
}

test_r_recommends() {
  has 'DESCRIPTION' 'Package: FOO
Suggests: brew'
  has debian/control 'Source: r-foo
Testsuite: autopkgtest-pkg-r'
  check_run autodep8
  assertTrue 'No r-cran-brew in Depends' 'grep ^Depends: stdout | grep --quiet r-cran-brew'
}

. shunit2
