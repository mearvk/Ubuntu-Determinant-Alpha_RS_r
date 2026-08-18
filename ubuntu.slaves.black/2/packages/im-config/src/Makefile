PROGRAM	=	im-config
ifeq ($(wildcard debian/changelog),)
VERSION = VCS-$(shell date -u  +%Y%m%d%H%M)
else
VERSION = $(shell dpkg-parsechangelog --format dpkg|\
		sed -ne '/^Version/s/Version: *//p')
endif

FILES = \
	im-config_wayland.sh \
	70im-config_launch \
	im-config \
	im-launch \
	share/im-config.common \
	share/xinputrc.common.in \
	$(wildcard data/*.rc) \
	$(wildcard data/*.conf)

PRETESTS = $(addsuffix .pretest, $(FILES))

TESTS = $(addsuffix .test, $(FILES))

# escape  with \#
LANGS = $(shell grep -v '^\#' po/LINGUAS)
POTFILESIN = $(shell grep -v '^\#' po/POTFILES.in)

all: share/xinputrc.common im-config.desktop mo

share/xinputrc.common: share/xinputrc.common.in
	sed -e "s/@@VERSION@@/$(VERSION)/" <$< >$@

im-config.desktop: im-config.desktop.in
	msgfmt --desktop --template=$< -d po -o $@

pot: po/$(PROGRAM).pot

po/$(PROGRAM).pot: FORCE
	xgettext -o $@ --language=Shell $(POTFILESIN)
	xgettext --join-existing -o $@ im-config.desktop.in

po/%.po: po/$(PROGRAM).pot
	msgmerge -U $@ $<

po/locale/%/LC_MESSAGES/$(PROGRAM).mo: po/%.po
	mkdir -p po/locale/$*/LC_MESSAGES
	msgfmt -o $@ $<

# run test on all script first
%.pretest: %
	@/bin/sh -n $< ; echo $$? > $@

# stop if error was found
%.test: %.pretest
	@[ `cat $<` = "0" ]
	-touch $@

test:
	# check if any syntax check resulted in error
	@$(MAKE) $(PRETESTS)
	@$(MAKE) $(TESTS)
	-rm -f $(TESTS)
	-rm -f $(PRETESTS)

mo:	$(addsuffix /LC_MESSAGES/$(PROGRAM).mo, $(addprefix po/locale/, $(LANGS)))

po:	$(addsuffix .po, $(addprefix po/, $(LANGS)))

foo:
	echo "$(addsuffix /LC_MESSAGES/$(PROGRAM).mo, $(addprefix po/locale/, $(LANGS)))"
	echo "-----"
	echo "$(addsuffix .po, $(addprefix po/, $(LANGS)))"

clean:
	-rm -f share/xinputrc.common
	-rm -f default/im-config
	-rm -f im-config.desktop
	rm -rf po/locale
	rm -f  po/*.po~ po/*.mo
	-rm -f $(PRETESTS)
	-rm -f $(TESTS)

distclean: clean

# Use this target on devel branch source
package:
	debmake -t -y -zx -b':sh' -i sbuild

update:
	touch -t 200001010000 po/*.po
	$(MAKE) po
	$(MAKE) clean

.PHONY: all pot distclean clean mo update po test FORCE
