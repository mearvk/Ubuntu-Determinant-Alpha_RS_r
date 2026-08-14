. $(dirname $0)/helper.sh
. "${AUTODEP8_SUPPORT_DIR}/autodep8lib.sh"

run_read_config() {
  has debian/tests/autopkgtest-pkg-ruby.conf "$@"
  check_run read_config ruby
}

assertInvalidConfig() {
  assertEquals "W: debian/tests/autopkgtest-pkg-ruby.conf: invalid configuration line: ${1} (ignored)" "$(cat stderr)"
}

test_no_config() {
  check_run read_config ruby
  assertEquals "" "$(cat stdout)"
  assertEquals "" "$(cat stderr)"
}

test_read_config_valid() {
  run_read_config 'foo=bar'
  assertEquals "foo=bar" "$(cat stdout)"
}

test_read_config_invalid_single_word() {
  run_read_config 'foo'
  assertEquals "" "$(cat stdout)"
  assertInvalidConfig foo
}

test_read_config_invalid_no_assignment() {
  run_read_config 'foo bar'
  assertEquals "" "$(cat stdout)"
  assertInvalidConfig 'foo bar'
}

test_read_config_invalid_variable() {
  run_read_config 'foo bar=baz'
  assertEquals "" "$(cat stdout)"
  assertInvalidConfig 'foo bar=baz'
}

test_read_config_invalid_variable_an_whitespace() {
  run_read_config 'foo bar = baz'
  assertEquals "" "$(cat stdout)"
  assertInvalidConfig 'foo bar = baz'
}

test_read_config_invalid_command_injection() {
  run_read_config '/bin/sh -c "poweroff"'
  assertEquals "" "$(cat stdout)"
  assertInvalidConfig '/bin/sh -c "poweroff"'
}

test_read_config_remove_comments() {
  run_read_config '# comment\nfoo=bar\n# more comments'
  assertEquals "foo=bar" "$(cat stdout)"
  assertEquals "" "$(cat stderr)"
}

test_read_config_multiline() {
  run_read_config 'foo=bar \\\nbaz'
  assertEquals "foo=bar baz" "$(cat stdout)"
}

test_read_config_remove_whitespace_around_equals() {
  run_read_config 'foo = bar'
  assertEquals 'foo=bar' "$(cat stdout)"
}

test_read_config_remove_whitespace_multiple_equals() {
  run_read_config 'foo = bar = baz'
  assertEquals 'foo=bar = baz' "$(cat stdout)"
}

test_read_config_exports_variables() {
  run_read_config 'foo=bar'
  assertEquals "bar" "${pkg_ruby_foo}"
}

. shunit2
