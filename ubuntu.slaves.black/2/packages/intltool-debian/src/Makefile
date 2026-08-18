
prefix  = /usr/local
DESTDIR	=

all:
	@chmod a+x intltool-bin/intltool-*

clean:
	@:

test:
	prove --verbose t/*.t

install:
	@[ -d $(DESTDIR)$(prefix)/share/intltool-debian ] || mkdir -p $(DESTDIR)$(prefix)/share/intltool-debian
	install -m 0755 intltool-bin/intltool-* $(DESTDIR)$(prefix)/share/intltool-debian

deb:
	fakeroot debian/rules clean
	dh_clean
	dpkg-buildpackage -rfakeroot -I.git -I.gitignore

