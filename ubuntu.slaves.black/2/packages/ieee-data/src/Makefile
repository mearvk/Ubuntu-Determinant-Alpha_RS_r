# Copyright © 2013 Filippo Giunchedi <filippo@debian.org>
# Copyright © 2014-2018 Luciano Bello <luciano@debian.org>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar.
# See the LICENSE file for more details.

FILES := iab.*  mam.*  oui.*  oui36.* .lastupdate

sharedir=/usr/share/ieee-data
vardir=/var/lib/ieee-data
sbindir=/usr/sbin
mandir=/usr/share/man

all:

install: $(FILES)
	install -D -m644 $? $(DESTDIR)/$(sharedir)/
	install -D -m644 update-ieee-data.8 $(DESTDIR)/$(mandir)/man8/update-ieee-data.8
	install -D -m755 update-ieee-data $(DESTDIR)/$(sbindir)/update-ieee-data

update:
	BASEDIR=. RUN_PARSERS=0 ./update-ieee-data -f

.PHONY: update install
