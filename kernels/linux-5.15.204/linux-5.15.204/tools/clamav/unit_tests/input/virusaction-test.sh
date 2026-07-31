#!/bin/sh
if test ! "$(basename "$CLAM_VIRUSEVENT_FILENAME")" = "clam.exe"; then
	echo "VirusEvent incorrect: $CLAM_VIRUSEVENT_FILENAME" >"$1/test-clamd.log"
	exit 1
fi
if test ! "x$CLAM_VIRUSEVENT_VIRUSNAME" = "xClamAV-Test-File.UNOFFICIAL"; then
	echo "VirusName incorrect: $CLAM_VIRUSEVENT_VIRUSNAME" >"$1/test-clamd.log"
	exit 2
fi
if test ! "x$2" = "xVirus found: The virus name format character has been disabled due to security concerns, use the 'CLAM_VIRUSEVENT_VIRUSNAME' environment variable instead."; then
	echo "VirusName argument incorrect: $2" >"$1/test-clamd.log"
	exit 3
fi
echo "Virus found: $CLAM_VIRUSEVENT_VIRUSNAME" >"$1/test-clamd.log"
