#!/bin/sh
exit 0
set -e

# a package with runit integration
RSERVICE=ssh
RPACKAGE=openssh-server

is_enabled () {
	[ -h /etc/runit/runsvdir/default/"$RSERVICE" ]
}

is_disabled () {
	[ -h /etc/runit/runsvdir/default/."$RSERVICE" ]
}

fake_purge_files () {
	# log files
	mkdir -p /var/log/runit/"$RSERVICE"
	touch /var/log/runit/"$RSERVICE"/current
	touch /var/log/runit/"$RSERVICE"/lock
	# supervise files
	mkdir -p /run/runit/supervise/"$RSERVICE"
	for file in control ok lock pid stat status ; do
		touch /run/runit/supervise/"$RSERVICE"/"$file"
	done
}

# make sure there is no runit or "$RPACKAGE" installed
apt-get -y purge "$RPACKAGE" runit

if [ -e /etc/runit/runsvdir/default/"$RSERVICE" ] ; then
	echo " purge of runit service failed"
	exit 1
fi

# install the package: check that install doen't fail because of runit-helper code
apt-get -y install "$RPACKAGE" 

# should be enabled in default rundirectory
echo "TEST: is enabled"
if is_enabled ; then
	echo "PASS: service is enabled"
else 
	echo "FAILED: service is not enabled"
	exit 1
fi

# policy layer test (simulate a sysadmin preference)
echo "TEST: disabling the service"
mv /etc/runit/runsvdir/default/"$RSERVICE" /etc/runit/runsvdir/default/."$RSERVICE"

# remove the package (no purge): also test failure of runit-helper code during remove
apt-get -y remove "$RPACKAGE"

# keep local admin preference after removal
if is_disabled ; then
	echo "PASS: local sysadmin preference preserved after removal - service disabled"
elif is_enabled ; then
	echo "FAILED: service should be disabled"
	exit 1
else
	echo "FAILED: local sysadmin preference not recorded"
	exit 1
fi

# install again (was not purged)
apt-get -y install "$RPACKAGE"

# check that local admin preferece (disabled) is preserved
echo "TEST: preserving local admin preferences after reinstall - service disabled"
if is_disabled ; then
	echo "PASS: local sysadmin preference preserved after remove-install"
elif is_enabled ; then
	echo "FAILED: service should be disabled after remove-install"
	exit 1
else
	echo "FAILED: local sysadmin preference not recorded after remove-install"
	exit 1
fi

# purge test
fake_purge_files
apt-get -y purge "$RPACKAGE"
echo "TEST: purge test"
#should be no link at all here
if is_enabled || is_disabled ; then
	echo "FAILED: all links should be gone after purge"
	exit 1
else
	echo "PASS: all link deleted after purge"
fi
# check for clenup of log service
if [ -d /var/log/runit/"$RSERVICE" ] ; then
	echo "FAILED: log directory is still there after purge"
	exit 1
else
	echo "PASS: log directory deleted after purge"
fi

echo "OK: All test PASSED"
exit 0
