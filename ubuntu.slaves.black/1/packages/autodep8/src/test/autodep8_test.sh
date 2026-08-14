. $(dirname $0)/helper.sh

test_not_a_debian_package() {
  rm -rf debian
  run autodep8
  assertNotEquals 0 $exitstatus
  assertTrue '"E: not inside a Debian source package" message not given' 'grep "E: not inside a Debian source package" stderr'
}

. shunit2
