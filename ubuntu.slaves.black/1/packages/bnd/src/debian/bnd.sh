#!/bin/sh

# Include the wrappers utility script
. /usr/lib/java-wrappers/java-wrappers.sh

find_java_runtime java8

# Define our classpath
find_jars bnd

# Run bnd
run_java aQute.bnd.main.bnd $extra_args "$@"

