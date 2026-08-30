. $(dirname $0)/helper.sh

generators=$(ls -1 ${AUTODEP8_SUPPORT_DIR}/*/generate)

test_extra_depends() {
  for f in $generators; do
    pkgtype=$(basename $(dirname "$f"))
    assertTrue "$pkgtype should support extra_depends" "grep 'Depends:.*\${pkg_${pkgtype}_extra_depends:-}' $f"
  done
}

test_extra_restrictions() {
  for f in $generators; do
    pkgtype=$(basename $(dirname "$f"))
    assertTrue "$pkgtype should support extra_restrictions" "grep 'Restrictions:.*\${pkg_${pkgtype}_extra_restrictions:-}' $f"
  done
}

. shunit2
