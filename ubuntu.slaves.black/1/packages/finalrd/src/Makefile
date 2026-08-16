all:

check:
	dash -n *.sh

install-ratelimit:
	mkdir -p $(DESTDIR)/usr/lib/systemd/journald.conf.d
	cp finalrd-ratelimit.conf $(DESTDIR)/usr/lib/systemd/journald.conf.d/

install:
	mkdir -p $(DESTDIR)/lib/systemd/system
	mkdir -p $(DESTDIR)/usr/share/finalrd
	mkdir -p $(DESTDIR)/usr/share/man/man1/
	mkdir -p $(DESTDIR)/usr/bin/
	mkdir -p $(DESTDIR)/usr/lib/finalrd/
	cp finalrd-static.conf $(DESTDIR)/usr/lib/finalrd/
	cp finalrd.sh $(DESTDIR)/usr/bin/finalrd
	cp *.service $(DESTDIR)/lib/systemd/system/
	pod2man -u -c finalrd -r 'finalrd 2' -d '' finalrd.pod | gzip -9 > $(DESTDIR)/usr/share/man/man1/finalrd.1.gz

.PHONY: all check install
