#!/bin/bash --


set -e
_DIR=`pwd`
. ../jh_lib.sh.in

[ "$JAVA_HOME" ] || JAVA_HOME="/usr/lib/jvm/default-java"

JAR="$JAVA_HOME/bin/jar"
if [ ! -x "$JAR" -a -x "/usr/bin/jar" ] ; then
    JAR="/usr/bin/jar"
fi

if readlink "$JAR" | grep -q "fastjar$" ; then
    echo "fastjar produces different results than we expect." >&2
    echo "Skipping test" >&2
    exit 0
fi

run_jh_manifest()
{
    cd ..
    echo "Running: perl -I./lib ./jh_manifest \"$@\""
    perl -I./lib ./jh_manifest "$@"
    cd "$_DIR"
}

# checkmanifest <source> <correct result> [parameters...]
checkmanifest()
{
	error=0
	source=$1
	verify=$2
	shift
	shift
	touch foo
	"$JAR" cfm test.jar $source foo
	run_jh_manifest "$@" "$_DIR/test.jar"
	"$JAR" xf test.jar META-INF/MANIFEST.MF
	if ! diff -u $verify META-INF/MANIFEST.MF > test.diff; then
		error=1
		echo "ERROR: difference detected:"
		cat test.diff
		echo
		echo "Source:"
		cat $source
		echo
		echo "Parameters:"
		echo "$@"
		echo
		echo "Desired:"
		cat $verify
		echo
		echo "Actual:"
		cat META-INF/MANIFEST.MF
	fi
	rm -rf META-INF
	rm test.jar test.diff foo
	return $error
}

#checkextract <source> <key> <value>
checkextract()
{
	LINE="`extractline "$1" "$2"`"

	if [ "$LINE" != "$3" ]; then
		echo "Failed to extract $2 from $1"
		echo "Desired: $3"
		echo "Actual: $LINE"
	fi
}

#checkarch input output
checkarch()
{
	OUT="`../java-arch.sh "$1"`"
	if ! [ "$OUT" = "$2" ]; then
		echo "Failed converting arch $1"
		echo "Desired $2"
		echo "Actual $OUT"
		return 1
	fi
	return 0
}

# checkarches inputfile output file
checkarches ()
{
	i=1
	RET=0
	for a in `cat "$1"`; do
		if ! checkarch "$a" "`head -n$i "$2" | tail -n1`" ; then
			RET=1
		fi
		i=$(( $i + 1 ))
	done
	if [ "$RET" != "0" ] ; then
		echo "TEST FAILED"
	fi
	exit $RET
}

checkmanifest sample sample
checkmanifest long-in long-out
checkmanifest onelong-in onelong-out
checkmanifest sample long-out2 --classpath="/usr/share/java/hexdump.jar /usr/share/java/hexdump.jar /usr/share/java/hexdump.jar /usr/share/java/hexdump.jar /usr/share/java/hexdump.jar /usr/share/java/hexdump.jar /usr/share/java/hexdump.jar /usr/share/java/hexdump.jar /usr/share/java/hexdump.jar /usr/share/java/hexdump.jar /usr/share/java/hexdump.jar /usr/share/java/hexdump.jar /usr/share/java/hexdump.jar /usr/share/java/hexdump.jar /usr/share/java/hexdump.jar /usr/share/java/hexdump.jar /usr/share/java/hexdump.jar"
checkmanifest sample onelong-out2 --classpath=/usr/share/java/usr/share/java/usr/share/java/usr/share/java/usr/share/java/usr/share/java/usr/share/java/usr/share/java/usr/share/java/usr/share/java/usr/share/java/usr/share/java/usr/share/java/usr/share/java/usr/share/java/usr/share/java/usr/share/java/usr/share/java/hexdump.jar

checkextract onelong-out2 Class-Path /usr/share/java/usr/share/java/usr/share/java/usr/share/java/usr/share/java/usr/share/java/usr/share/java/usr/share/java/usr/share/java/usr/share/java/usr/share/java/usr/share/java/usr/share/java/usr/share/java/usr/share/java/usr/share/java/usr/share/java/usr/share/java/hexdump.jar
checkextract long-out2 Class-Path "/usr/share/java/hexdump.jar /usr/share/java/hexdump.jar /usr/share/java/hexdump.jar /usr/share/java/hexdump.jar /usr/share/java/hexdump.jar /usr/share/java/hexdump.jar /usr/share/java/hexdump.jar /usr/share/java/hexdump.jar /usr/share/java/hexdump.jar /usr/share/java/hexdump.jar /usr/share/java/hexdump.jar /usr/share/java/hexdump.jar /usr/share/java/hexdump.jar /usr/share/java/hexdump.jar /usr/share/java/hexdump.jar /usr/share/java/hexdump.jar /usr/share/java/hexdump.jar"

checkarches archs-in archs-out

