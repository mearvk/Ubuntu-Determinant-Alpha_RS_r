read_config() {
  packagetype="${1}"
  config="debian/tests/autopkgtest-pkg-${packagetype}.conf"
  [ ! -f "${config}" ] && return

  tmpfile="$(mktemp)"
  sed -e '
    /^\s*#/d;                   # remove comment lines
    /^\s*$/d;                   # remove empty lines
    { :a /\\$/N; s/\\\n//; ta } # fold lines ending with backslash into next
  ' "${config}" > "${tmpfile}"
  while read line; do
    conf="$(echo "$line" | sed -e 's/\s*=\s*/=/')" # remove spaces around first =
    if echo "${conf}" | grep -q '^[a-zA-Z_][a-zA-Z_0-9]*='; then
      export "pkg_${packagetype}_${conf}"
      echo "$conf"
    else
      echo "W: ${config}: invalid configuration line: ${line} (ignored)" >&2
    fi
  done < "${tmpfile}"
  rm -f "${tmpfile}"
}
