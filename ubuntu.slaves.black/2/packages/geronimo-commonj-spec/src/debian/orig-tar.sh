#!/bin/sh 

set -e

version=`dpkg-parsechangelog | grep '^Version:' | cut -f 2 -d ' ' | sed 's/-[^-]*$$//'`
upstream_version=`echo ${version} | sed 's/-[0-9]\+$//'`
echo "version ${upstream_version}"
package=`dpkg-parsechangelog | sed -n 's/^Source: //p'`
upstream_package=`echo "${package}" | sed 's/commonj-spec/spec-commonj/'`
tarball="${package}_${upstream_version}.orig.tar.gz"
dir="${package}-${version}.orig"
version_url="$(echo $upstream_version | sed 's/\./_/g')"
repo="http://svn.apache.org/repos/asf/geronimo/specs/tags/${version_url}/${upstream_package}/"

LC_ALL=C TZ=UTC svn export "${repo}" "${dir}"
GZIP=--best tar --numeric --group 0 --owner 0 -c -v -z -f "${tarball}" "${dir}"

rm -rf "${dir}"
