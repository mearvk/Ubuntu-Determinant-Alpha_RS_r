#!/bin/sh
##
## update.sh, written by Sergey B Kirpichev <skirpichev@gmail.com>
##
## Update AWStats data for all configs, awstats.*.conf (Debian specific)
##

set -e

DEFAULT=/etc/default/awstats
AWSTATS=/usr/lib/cgi-bin/awstats.pl
ERRFILE=`mktemp --tmpdir awstats.XXXXXXXXXX`

trap 'rm -f $ERRFILE' INT QUIT TERM EXIT

[ -f $AWSTATS ] || exit 1

# Set defaults.
AWSTATS_NICE=10
[ ! -r "$DEFAULT" ] || . "$DEFAULT"

# For compatibility: handle empty AWSTATS_ENABLE_CRONTABS as "yes":
[ "${AWSTATS_ENABLE_CRONTABS:-yes}" = "yes" ] || exit 0

cd /etc/awstats

for c in `/bin/ls -1 awstats.*.conf 2>/dev/null | \
          /bin/sed 's/^awstats\.\(.*\)\.conf/\1/'` \
         `[ -f /etc/awstats/awstats.conf ] && echo awstats`
do
  if ! nice -n $AWSTATS_NICE $AWSTATS \
	  -config=$c \
	  -update >$ERRFILE 2>&1
  then
    echo "Error while processing" \
         "/etc/awstats/awstats$(test $c != awstats && echo .$c).conf" >&2
    cat $ERRFILE >&2 # an error occurred
  fi
done
