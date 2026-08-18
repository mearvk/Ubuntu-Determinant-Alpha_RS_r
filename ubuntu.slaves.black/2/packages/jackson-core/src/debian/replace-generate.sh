#!/bin/sh

# Simple replacement for mavan-replacer-plugin

set -e

TARGET=$1; shift

TEMPLATE=$TARGET.in

get_attr() {
    < pom.xml xmlstarlet sel \
        -N pom=http://maven.apache.org/POM/4.0.0 \
        -T -t -v $1
}

package=$(dirname $TARGET | sed -e 's,.*src/main/java/\(.*\)$,\1,' | tr / .)
projectversion=$(get_attr '/pom:project/pom:version')
projectgroupid=$(get_attr '/pom:project/pom:groupId')
projectartifactid=$(get_attr '/pom:project/pom:artifactId')

sed \
    -e "s,@package@,$package,g" \
    -e "s,@projectversion@,$projectversion,g" \
    -e "s,@projectgroupid@,$projectgroupid,g" \
    -e "s,@projectartifactid@,$projectartifactid,g" \
    < $TEMPLATE > $TARGET.t

if grep -i '@[a-z]*@' $TARGET.t >&2; then
    echo 'Not all tags were
    replaced' >&2 exit 1
fi

mv $TARGET.t $TARGET
