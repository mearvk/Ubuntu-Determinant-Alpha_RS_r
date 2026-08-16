PREFIX ?= /usr
VENDOR ?= $(shell dpkg-vendor --query Vendor | tr '[:upper:]' '[:lower:]')

build: debian-distro-info ubuntu-distro-info

%-distro-info: %-distro-info.in distro-info-util.sh
	sed -e '/^\. .*distro-info-util.sh\"$$/r distro-info-util.sh' $< | \
		sed -e '/^##/d;/^\. .*distro-info-util.sh\"$$/d' | \
		python3 -c 'import re,sys;print(re.sub("(?<=\n)#BEGIN \w*#\n(.|\n)*?\n#END \w*#\n", "", re.sub("(?<=\n)#(BEGIN|END) $*#\n", "", sys.stdin.read())), end="")' > $@
	chmod +x $@

install: debian-distro-info ubuntu-distro-info
	install -d $(DESTDIR)$(PREFIX)/bin
	install -m 755 $^ $(DESTDIR)$(PREFIX)/bin
	ln -s $(VENDOR)-distro-info $(DESTDIR)$(PREFIX)/bin/distro-info

clean:
	rm -f debian-distro-info ubuntu-distro-info

.PHONY: build clean install
