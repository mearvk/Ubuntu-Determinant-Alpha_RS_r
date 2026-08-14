test_updated_examples() {
  for pkgtype in $(ls --ignore=common --ignore=autodep8lib.sh -1 support/); do
    assertTrue "missing example for $pkgtype in examples.md; update examples.in and run \`make update-examples\`" "grep '^## $pkgtype' examples.md"
  done
}

. shunit2
