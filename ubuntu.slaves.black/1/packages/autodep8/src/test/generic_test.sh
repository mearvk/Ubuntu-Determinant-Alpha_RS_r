. $(dirname $0)/helper.sh

test_no_detection() {
  run autodep8
  assertEquals 1 "$exitstatus"
}

test_append_to_control() {
  has debian/tests/control '# BEFORE'
  run autodep8
  assertEquals 0 "$exitstatus"
  assertTrue 'output prepended to contents of debian/tests/control' "grep '^# BEFORE' stdout"
  assertTrue 'empty line after contents of debian/tests/control' "grep '^\$' stdout"
}

test_append_to_control_autodep8() {
  has debian/tests/control.autodep8 '# BEFORE'
  run autodep8
  assertEquals 0 "$exitstatus"
  assertTrue 'output prepended to contents of debian/tests/control.autodep8' "grep '^# BEFORE' stdout"
  assertTrue 'empty line after contents of debian/tests/control.autodep8' "grep '^\$' stdout"
}

test_append_to_control_autodep8_with_no_trailing_newline() {
  has debian/control 'Testsuite: autopkgtest-pkg-ruby'
  has debian/tests/control.autodep8
  printf "Test: foo" > debian/tests/control.autodep8 # no trailing newline!
  run autodep8
  stanzas="$(grep-dctrl -c -F Test,Test-Command '' stdout)"
  assertEquals "expected 2 test stanzas, found $stanzas" 2 "$stanzas"
}

. shunit2
