#!/bin/sh
##
## buildstatic.sh, written by Sergey B Kirpichev <skirpichev@gmail.com>
##
## Build all static html reports from AWStats data (Debian specific)
##

set -e

DEFAULT=/etc/default/awstats
AWSTATS=/usr/lib/cgi-bin/awstats.pl
BUILDSTATICPAGES=/usr/share/awstats/tools/awstats_buildstaticpages.pl
ERRFILE=`mktemp --tmpdir awstats.XXXXXXXXXX`
YEAR=`date +%Y`
MONTH=`date +%m`

trap 'rm -f $ERRFILE' INT QUIT TERM EXIT

[ -f $AWSTATS -a -f $BUILDSTATICPAGES ] || exit 1

# Set default
AWSTATS_NICE=10
AWSTATS_ENABLE_BUILDSTATICPAGES="yes"
AWSTATS_LANG="en"
[ ! -r "$DEFAULT" ] || . "$DEFAULT"

# For compatibility: handle empty AWSTATS_ENABLE_CRONTABS as "yes":
[ "${AWSTATS_ENABLE_CRONTABS:-yes}" = "yes" -a \
  "$AWSTATS_ENABLE_BUILDSTATICPAGES" = "yes" ] || exit 0

cd /etc/awstats

for c in `/bin/ls -1 awstats.*.conf 2>/dev/null | \
          /bin/sed 's/^awstats\.\(.*\)\.conf/\1/'` \
         `[ -f /etc/awstats/awstats.conf ] && echo awstats`
do
  mkdir -p /var/cache/awstats/$c/$YEAR/$MONTH/

  if ! nice -n $AWSTATS_NICE $BUILDSTATICPAGES \
    -config=$c \
	-year=$YEAR \
	-month=$MONTH \
	-lang=$AWSTATS_LANG \
	-staticlinksext=${AWSTATS_LANG}.html \
	-dir=/var/cache/awstats/$c/$YEAR/$MONTH/ >$ERRFILE 2>&1
  then
    cat $ERRFILE >&2 # an error occurred
  else
    ln -fs /var/cache/awstats/$c/$YEAR/$MONTH/awstats.$c.$AWSTATS_LANG.html \
        /var/cache/awstats/$c/$YEAR/$MONTH/index.$AWSTATS_LANG.html
  fi
done
