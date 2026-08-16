define \n


endef

PREFIX ?= /usr
VENDOR ?= $(shell dpkg-vendor --query Vendor | tr '[:upper:]' '[:lower:]')

CPPFLAGS = $(shell dpkg-buildflags --get CPPFLAGS)
CFLAGS = $(shell dpkg-buildflags --get CFLAGS)
CFLAGS += -Wall -Wextra -g -O2 -std=gnu99
LDFLAGS = $(shell dpkg-buildflags --get LDFLAGS)

build: debian-distro-info ubuntu-distro-info

%-distro-info: %-distro-info.c distro-info-util.*
	$(CC) $(CPPFLAGS) $(CFLAGS) $(LDFLAGS) -o $@ $<

install: debian-distro-info ubuntu-distro-info
	install -d $(DESTDIR)$(PREFIX)/bin
	install -m 755 $^ $(DESTDIR)$(PREFIX)/bin
	ln -s $(VENDOR)-distro-info $(DESTDIR)$(PREFIX)/bin/distro-info
	install -d $(DESTDIR)$(PREFIX)/share/man/man1
	install -m 644 $(wildcard doc/*.1) $(DESTDIR)$(PREFIX)/share/man/man1
	install -d $(DESTDIR)$(PREFIX)/share/perl5/Debian
	install -m 644 $(wildcard perl/Debian/*.pm) $(DESTDIR)$(PREFIX)/share/perl5/Debian
	cd python && python3 setup.py install --root="$(DESTDIR)" --no-compile --install-layout=deb

test: test-commandline test-perl test-python

test-commandline: debian-distro-info ubuntu-distro-info
	./test-debian-distro-info
	./test-ubuntu-distro-info

test-perl:
	cd perl && ./test.pl

test-python:
	$(foreach python,$(shell py3versions -r),cd python && $(python) setup.py test$(\n))

clean:
	rm -rf debian-distro-info ubuntu-distro-info python/build python/*.egg-info python/.pylint.d
	find python -name '*.pyc' -delete

.PHONY: build clean install test test-commandline test-perl test-python
