. $(dirname $0)/helper.sh

test_detect_nodejs() {
  has 'debian/control' 'Source: node-foo'
  check_run autodep8
}

test_nodejs_upstream_name_from_package_json() {
  has 'debian/control' 'Source: node-foo'
  has 'package.json' '{"name": "bar"}'
  check_run autodep8
  assertTrue 'pkg-js-autopkgtest' 'grep --quiet pkg-js-autopkgtest stdout'
  assertFalse 'does not include node- prefix' 'grep --quiet node-foo stdout'
}

test_nodejs_upstream_name_from_source_package() {
  has 'debian/control' 'Source: node-foo'
  check_run autodep8
  assertTrue 'pkg-js-autopkgtest' 'grep --quiet pkg-js-autopkgtest stdout'
  assertFalse 'does not include node- prefix' 'grep --quiet node-foo stdout'
}

test_nodejs_upstream_name_from_binary_package() {
  has 'debian/control' "Source: foo\n\nPackage: node-foo"
  check_run autodep8
  assertTrue 'pkg-js-autopkgtest' 'grep --quiet pkg-js-autopkgtest stdout'
  assertFalse 'does not include node- prefix' 'grep --quiet node-foo stdout'
}

test_Testsuite_autopkgtest_pkg_nodejs() {
  has debian/control "Testsuite: autopkgtest-pkg-nodejs"
  has 'package.json' '{"name": "foo"}'
  check_run autodep8
  assertTrue 'pkg-js-autopkgtest' 'grep --quiet pkg-js-autopkgtest stdout'
  assertFalse 'does not include node- prefix' 'grep --quiet node-foo stdout'
}

test_XS_Testsuite_autopkgtest_pkg_nodejs() {
  has debian/control 'XS-Testsuite: autopkgtest-pkg-nodejs'
  has 'package.json' '{"name": "foo"}'
  check_run autodep8
  assertTrue 'pkg-js-autopkgtest' 'grep --quiet pkg-js-autopkgtest stdout'
  assertFalse 'does not include node- prefix' 'grep --quiet node-foo stdout'
}

. shunit2
