PREFIX ?= /usr
VENDOR ?= $(shell dpkg-vendor --query Vendor | tr '[:upper:]' '[:lower:]')
GHC_FLAGS := -Wall -O2

build: debian-distro-info ubuntu-distro-info

debian-distro-info: DebianDistroInfo.hs DistroInfo.hs
	ghc $(GHC_FLAGS) -o $@ --make -main-is DebianDistroInfo $<

test-distro-info: TestDistroInfo.hs DistroInfo.hs
	ghc $(GHC_FLAGS) -o $@ --make -main-is TestDistroInfo $<

ubuntu-distro-info: UbuntuDistroInfo.hs DistroInfo.hs
	ghc $(GHC_FLAGS) -o $@ --make -main-is UbuntuDistroInfo $<

install: debian-distro-info ubuntu-distro-info
	install -d $(DESTDIR)$(PREFIX)/bin
	install -m 755 $^ $(DESTDIR)$(PREFIX)/bin
	ln -s $(VENDOR)-distro-info $(DESTDIR)$(PREFIX)/bin/distro-info

test: test-distro-info
	./test-distro-info

clean:
	rm -f *-distro-info *.hi *.o

.PHONY: build clean install test
