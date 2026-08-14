#!/bin/sh
set -e

# git remote add libpfm4 https://git.code.sf.net/p/perfmon2/libpfm4

commit=${1:-libpfm4/master}

upsver=$(git describe --tags ${commit})
upsver=${upsver%-*-*}
upsver=${upsver%+git*}
gitver=$(git describe --match ${upsver} --tags ${commit})
gitver=${gitver#v}
tagver=${gitver%%-*}
gitver=${gitver#${tagver}-}
snapver=${tagver}+git${gitver}
prefix=libpfm-${snapver}
tarxzball=${prefix}.tar.xz
tag=v${snapver}

git archive --format=tar --prefix=${prefix}/ ${commit} | xz -9 > ${tarxzball}

echo "Exported to ${tarxzball}"

git tag ${tag} ${commit}

echo "Tagged as ${tag}"
