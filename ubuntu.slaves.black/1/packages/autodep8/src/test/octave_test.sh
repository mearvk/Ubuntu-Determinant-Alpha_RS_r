. $(dirname $0)/helper.sh

test_Testsuite_autopkgtest_pkg_octave() {
  has debian/control 'Testsuite: autopkgtest-pkg-octave'
  check_run autodep8
}

test_XS_Testsuite_autopkgtest_pkg_octave() {
  has debian/control 'XS-Testsuite: autopkgtest-pkg-octave'
  check_run autodep8
}

test_support_octave_detect() {
  has_dir inst
  has debian/control 'Source: octave-foo'
  has DESCRIPTION 'Name: Foo'
  check_run autodep8
}

test_no_description_file() {
  has_dir inst
  has debian/control 'Source: octave-foo'
  run autodep8
  assertEquals 1 "$exitstatus"
  assertEquals "" "$(cat stdout stderr)"
}

test_no_octave_prefix_in_source_name() {
  has_dir inst
  has debian/control 'Source: foo'
  has DESCRIPTION 'Name: Foo'
  run autodep8
  assertEquals 1 "$exitstatus"
  assertEquals "" "$(cat stdout stderr)"
}

test_no_inst_directory() {
  has debian/control 'Source: octave-foo'
  has DESCRIPTION 'Name: Foo'
  run autodep8
  assertEquals 1 "$exitstatus"
  assertEquals "" "$(cat stdout stderr)"
}

test_build_depends() {
  has_dir inst
  has debian/control 'Source: octave-foo
Build-Depends: debhelper, dh-octave, octave-bar'
  has DESCRIPTION 'Name: Foo'
  check_run autodep8
  assertTrue 'No octave-bar in Depends' 'grep ^Depends: stdout | grep --quiet octave-bar'
  assertFalse 'dh-octave in Depends' 'grep ^Depends: stdout | grep --quiet dh-octave,'
  assertFalse 'debhelper in Depends' 'grep ^Depends: stdout | grep --quiet debhelper'
}

. shunit2
