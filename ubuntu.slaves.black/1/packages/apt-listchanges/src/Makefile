include common.mk
all::

install:: all
	# modules
	install -d $(DESTDIR)/usr/share/apt-listchanges
	install -m 644 apt-listchanges/*.py $(DESTDIR)/usr/share/apt-listchanges
	install -m 644 apt-listchanges/*.ui $(DESTDIR)/usr/share/apt-listchanges
	# config
	install -d $(DESTDIR)/etc/apt/apt.conf.d
	install -m 644 debian/apt.conf $(DESTDIR)/etc/apt/apt.conf.d/20listchanges
	# exe
	install -d $(DESTDIR)/usr/bin
	install -m 755 apt-listchanges.py $(DESTDIR)/usr/bin/apt-listchanges

clean::
	rm -rf __pycache__  */__pycache__

test::
	# This will check for syntax errors
	python3 -mcompileall apt-listchanges.py apt-listchanges/*.py debian/*.py

all install clean update-po::
	$(MAKE) -C po $@
ifeq (,$(filter nodoc,$(DEB_BUILD_OPTIONS)))
	$(MAKE) -C doc $@
endif
