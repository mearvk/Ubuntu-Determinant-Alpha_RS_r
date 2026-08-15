#
# Makefile
#

all:
	python3 certdata2pem.py

clean:
	-rm -f *.crt

install:
	for p in *.crt; do \
	 install -m 644 $$p $(CERTSDIR)/$$p ; \
	done

update:
	wget -Ocertdata.txt https://hg.mozilla.org/releases/mozilla-release/raw-file/default/security/nss/lib/ckfw/builtins/certdata.txt
	wget -Onssckbi.h https://hg.mozilla.org/releases/mozilla-release/raw-file/default/security/nss/lib/ckfw/builtins/nssckbi.h
	false
