#!/bin/sh

JAVA_HOME=/usr/local/java5
CLASSPATH=../build:.
PROPERTIES=../../bcarter.prp
RUN="${JAVA_HOME}/bin/java -cp ${CLASSPATH} -Djcifs.properties=${PROPERTIES}"

$RUN GetGroupMemberSids smb://xp1.busico.local/ S-1-5-32-545
