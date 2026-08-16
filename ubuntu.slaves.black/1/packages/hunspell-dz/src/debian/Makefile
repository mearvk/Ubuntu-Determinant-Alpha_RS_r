DEBIAN_FILES = changelog copyright rules watch compat hunspell-dz.info-hunspell hunspell-dz.links source control hunspell-dz.install

ORIG_FILES = ../dz.dic ../dz.aff ../CHANGELOG.md

VERSION = 0.1.0

all: deb

orig: $(DEBIAN_FILES) $(ORIG_FILES)
	@echo "Making orig.tar.gz archive..."
	@mkdir -p hunspell-dz && cp $(ORIG_FILES) hunspell-dz
	@tar czf hunspell-dz_$(VERSION).orig.tar.gz hunspell-dz

deb: orig
	@echo "Making .deb package..."
	@mkdir -p hunspell-dz/debian
	@cp -R $(DEBIAN_FILES) hunspell-dz/debian
	@cd hunspell-dz && dpkg-buildpackage

clean:
	@rm -rf *.deb *.xz *.gz *.dsc *.changes *.upload
