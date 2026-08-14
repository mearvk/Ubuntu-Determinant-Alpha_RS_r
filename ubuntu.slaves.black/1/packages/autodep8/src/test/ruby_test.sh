. $(dirname $0)/helper.sh

test_Testsuite_autopkgtest_pkg_ruby() {
  has debian/control 'Testsuite: autopkgtest-pkg-ruby'
  check_run autodep8
}

test_XS_Testsuite_autopkgtest_pkg_ruby() {
  has debian/control 'XS-Testsuite: autopkgtest-pkg-ruby'
  check_run autodep8
}

test_ruby_rake() {
  has debian/ruby-tests.rake
  check_run autodep8
}

test_ruby_testrb() {
  has debian/ruby-tests.rb
  check_run autodep8
}

test_ruby_test_files() {
  has debian/ruby-test-files.yaml
  check_run autodep8
}

test_ruby_no_debhelper() {
  has debian/ruby-tests.rake
  has debian/control "Build-Depends: debhelper, gem2deb, rake"
  check_run autodep8
  assertFalse "test does must not depend on debhelper\n$(grep Depends: stdout)\n" "grep -q Depends:.*debhelper stdout"
}

test_ruby_no_gem2deb() {
  has debian/ruby-tests.rake
  has debian/control "Build-Depends: debhelper, gem2deb, rake"
  check_run autodep8
  assertFalse "test does must not depend on gemdeb\n$(grep Depends: stdout)\n" "grep -q 'Depends:.*gem2deb(\s\|,)' stdout"
}

test_ruby_gem2deb_test_runner() {
  has debian/ruby-tests.rb
  check_run autodep8
  assertTrue "test depends on gem2deb-test-runner\n$(grep Depends: stdout)\n" 'grep Depends:.*gem2deb-test-runner stdout'
}

debian_control_with_comments='
Build-Depends: debhelper,
               gem2deb,
#              foo,
               bar,
'
test_ruby_removes_comments() {
  has debian/ruby-tests.rb
  echo "$debian_control_with_comments" > debian/control
  check_run autodep8
  assertFalse "should remove comments from Build-Depends" "grep '^Depends:.*#' stdout"
}

test_ruby_build_profiles() {
  has debian/ruby-tests.rb
  echo "Build-Depends: foo <!nocheck>, bar" > debian/control
  check_run autodep8
  assertFalse "should remove build profiles" "grep nocheck stdout"
}

. shunit2
