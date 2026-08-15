installdir:=install -d -m 755
installbin:=install -m 755

all:


check:
	bash -n d-shlibmove
	bash -n d-devlibdeps
	shellcheck d-shlibmove
	shellcheck d-devlibdeps

test-build:
	mkdir TESTS
	( cd TESTS; \
	for PKG in dancer-xml dlisp libdshconfig libgtkdatabox ; do \
	( mkdir $$PKG ; cd $$PKG ; apt-get source $$PKG; cd */ ; /usr/bin/debuild -us -uc ; debc; ) ; \
	done ) 2>&1 | tee tests.log

install:
	$(installdir) $(DESTDIR)/usr/bin/
	$(installbin) d-shlibmove $(DESTDIR)/usr/bin/d-shlibmove
	$(installbin) d-devlibdeps $(DESTDIR)/usr/bin/d-devlibdeps

clean:
	-rm -f *~
	-rm -rf TESTS


