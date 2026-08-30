#! /bin/bash

CONFDIR=/etc/awstats
DATADIR=/var/lib/awstats
PROGRAM=/usr/lib/cgi-bin/awstats.pl

if [ `id -u` != 0 ]; then
    exit 1
fi

set -e

cd $DATADIR
OLDSTATS=`date -I`
if mkdir $OLDSTATS 2> /dev/null; then
    mv *.txt *.bak $OLDSTATS
fi
rm -f *.txt *.bak

TMPLOG=`mktemp --tmpdir access.log.XXXXXXXX`
TMPCRON=$CONFDIR/awstats.cron
CRONORIG=/etc/cron.d/awstats
CONFORIG=$CONFDIR/conf.orig
CONFFILE=$CONFDIR/awstats.conf

trap 'rm $TMPLOG; mv -f $CONFORIG $CONFFILE; mv -f $TMPCRON $CRONORIG; /etc/init.d/cron reload' EXIT

mv -f $CONFFILE $CONFORIG
cat $CONFORIG |
  sed "\|/var/log/apache2/access.log|s||$TMPLOG|" > $CONFFILE
mv -f $CRONORIG $TMPCRON
/etc/init.d/cron reload

ls -rt /var/log/apache2/access.log* |
  while read file
    do zcat -f $file > $TMPLOG
    echo Processing ${file}...
    sudo -u www-data $PROGRAM -config=awstats
  done
rm -f $DATADIR/*.bak
