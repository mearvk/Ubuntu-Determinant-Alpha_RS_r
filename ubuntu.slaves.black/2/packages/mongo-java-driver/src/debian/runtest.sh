#!/bin/sh
set -e

cleanup() {
	echo "Cleanup"
	if [ -x $PIDFILE ]
	then
		 /bin/kill `cat $(PIDFILE)`
	fi
	rm -rf $MONGOHOME
	exit $RET_VAL
}


#if lsof -i:27017
if [ -x /bin/ss ]; then
	if ss -a sport = :27017 | grep 127.0.0.1:27017
	then
	   echo "ERROR: Cannot start mongod, port 27017 is not free."
	   exit 1 
	fi
else
	echo "ERROR: ss not found!"
	exit 1
fi

trap cleanup EXIT

RET_VAL=1	#Return an error if execution is interrupted before the end.
MONGOHOME=`pwd`/driver-core/build/mongo
PIDFILE=$MONGOHOME/mongod.pid


	mkdir -p $MONGOHOME
        if [ -x /usr/bin/mongod ]; then
          mongod --dbpath $MONGOHOME --noprealloc --nojournal --quiet --fork --logpath $MONGOHOME/mongod.log --pidfilepath $PIDFILE --setParameter enableTestCommands=1;
          sleep 10;
	else
	  echo "ERROR: Mongod not found!"
	  exit 1
        fi
#	dh_auto_build -- check
        dh_auto_build -- check -x :bson:checkstyleMain -x :bson:checkstyleTest  -x driver:checkstyleMain -x driver:checkstyleTest -x driver-core:compileTestGroovy -x driver:compileTestGroovy -x driver-async:checkstyleMain -x driver-async:checkstyleTest -x driver-async:compileTestGroovy -x driver-core:checkstyleMain -x driver-core:checkstyleTest
	RET_VAL=$?
        echo "Test returned $RET_VAL"

