. $(dirname $0)/helper.sh

test_python_detect_source_python() {
  has 'debian/control' 'Source: python-foo\n\nPackage:python-foo'
  check_run autodep8
  assertFalse 'creates no test for python2' 'test -s stdout'
}

test_python_detect_source_py3() {
  has 'debian/control' 'Source: python-foo\n\nPackage:python3-foo'
  check_run autodep8
  assertTrue 'get upstream name' 'grep --quiet "import foo;" stdout'
  assertTrue 'have py3 test' 'grep --quiet "py3versions" stdout'
}

test_python_unusual_name_py3() {
  has 'debian/control' 'Source: python-foo\n\nPackage:python3-foo'
  has 'debian/tests/pkg-python/import-name' '# no capital letters in package names\nFoo\n'
  check_run autodep8
  assertTrue 'get upstream name' 'grep --quiet "import Foo;" stdout'
  assertFalse 'not using wrong name' 'grep --quiet "import foo;" stdout'
  assertTrue 'have py3 test' 'grep --quiet "py3versions" stdout'
  assertTrue 'grep "W:.*deprecated" stderr'
}

test_python_unusual_name_py3_via_config() {
  has 'debian/control' 'Source: python-foo\n\nPackage:python3-foo'
  has 'debian/tests/autopkgtest-pkg-python.conf' 'import_name = Foo'
  check_run autodep8
  assertTrue 'get upstream name' 'grep --quiet "import Foo;" stdout'
  assertFalse 'not using wrong name' 'grep --quiet "import foo;" stdout'
  assertTrue 'have py3 test' 'grep --quiet "py3versions" stdout'
}

test_python_underscore_py3() {
  has 'debian/control' 'Source: python-foo-bar\n\nPackage:python3-foo-bar'
  check_run autodep8
  assertTrue 'get upstream name' 'grep --quiet "import foo_bar;" stdout'
  assertFalse 'not using wrong name' 'grep --quiet "import foo;" stdout'
  assertTrue 'have py3 test' 'grep --quiet "py3versions" stdout'
}

# PyPy is only Python 2 compatible for now.
test_python_detect_source_pypy() {
  has 'debian/control' 'Source: python-foo\n\nPackage:pypy-foo'
  check_run autodep8
  assertTrue 'get upstream name' 'grep --quiet "import foo;" stdout'
  assertTrue 'have pypy test' 'grep --quiet "pypy -c" stdout'
  assertFalse 'dont have py3 test' 'grep --quiet "py3versions" stdout'
}

test_python_detect_binary_py3() {
  has 'debian/control' 'Source: foo\n\nPackage: python3-foo'
  check_run autodep8
  assertTrue 'get upstream name' 'grep --quiet "import foo;" stdout'
  assertTrue 'have py3 test' 'grep --quiet "py3versions" stdout'
}

test_python_detect_binary_pypy() {
  has 'debian/control' 'Source: foo\n\nPackage: pypy-foo'
  check_run autodep8
  assertTrue 'get upstream name' 'grep --quiet "import foo;" stdout'
  assertFalse 'dont have py3 test' 'grep --quiet "py3versions" stdout'
  assertTrue 'have pypy test' 'grep --quiet "pypy -c" stdout'
}

test_python_detect_binary_all() {
  has 'debian/control' 'Source: foo\n\nPackage: python-foo\n\nPackage: python3-foo\n\nPackage: pypy-foo'
  check_run autodep8
  assertTrue 'get upstream name' 'grep --quiet "import foo;" stdout'
  assertTrue 'have py3 test' 'grep --quiet "py3versions" stdout'
  assertTrue 'have pypy test' 'grep --quiet "pypy -c" stdout'
}

test_python_ignore_doc_py3() {
  has 'debian/control' 'Source: foo\n\nPackage: python3-foo-doc\n\nPackage: python3-foo'
  check_run autodep8
  assertTrue 'get upstream name' 'grep --quiet "import foo;" stdout'
  assertTrue 'have py3 test' 'grep --quiet "py3versions" stdout'
}

test_python_ignore_doc_pypy() {
  has 'debian/control' 'Source: foo\n\nPackage: pypy-foo-doc\n\nPackage: pypy-foo'
  check_run autodep8
  assertTrue 'get upstream name' 'grep --quiet "import foo;" stdout'
  assertFalse 'dont have py3 test' 'grep --quiet "py3versions" stdout'
  assertTrue 'have pypy test' 'grep --quiet "pypy -c" stdout'
}

test_python_ignore_common_package() {
  has 'debian/control' 'Source: python-foo\n\nPackage: python-foo-common\n\nPackage: python3-foo'
  check_run autodep8
  assertTrue 'get upstream name' 'grep --quiet "import foo;" stdout'
  assertTrue 'have py3 test' 'grep --quiet "py3versions" stdout'
}

test_Testsuite_autopkgtest_pkg_python() {
  has debian/control "Testsuite: autopkgtest-pkg-python"
  check_run autodep8
}

test_XS_Testsuite_autopkgtest_pkg_python() {
  has debian/control 'XS-Testsuite: autopkgtest-pkg-python'
  check_run autodep8
}

test_python3_dev_only_d() {
  has 'debian/control' 'Source: python-foo\nBuild-Depends: python3-dev\n\nPackage:python3-foo'
  check_run autodep8
  assertTrue 'get upstream name' 'grep --quiet "import foo;" stdout'
  assertTrue 'test current python3' 'grep --quiet "py3versions -d" stdout'
  assertFalse 'dont test other python3' 'grep --quiet "pyversions -r" stdout'
}

. shunit2
