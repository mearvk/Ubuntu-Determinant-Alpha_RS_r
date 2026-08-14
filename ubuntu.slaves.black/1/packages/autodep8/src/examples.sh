set -e

autodep8=$(readlink -f $(dirname $0)/autodep8)
mkdir -p tmp/doc
echo
grep -v '^#' examples.in | \
while read pkgtype pkg; do
  (cd tmp/doc && apt-get source "$pkg") >> tmp/doc/${pkg}.log
  echo "## $pkgtype ($pkg)"
  echo
  (cd $(dirname tmp/doc/"$pkg"*/debian) && rm -rf debian/tests && $autodep8) | sed -e 's/^/    /'
  echo
done
