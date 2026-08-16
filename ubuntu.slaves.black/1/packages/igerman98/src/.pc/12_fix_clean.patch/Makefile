# Makefile for the dictionary igerman98
#
# Author: Bjoern Jacke <bjoern@j3e.de>
#
# Copyright: GNU GPLv2 and GPLv3

# we need want out own executables first:
export PATH := .:bin:$(PATH)
LANGS=de_DE de_AT de_CH
LANGS2=$(LANGS) de_all
DATE=`date +%Y%m%d`
VERSION=`cat VERSION`
VERSION_EXTRA=$(shell find . -name "VERSION.*" -print | while read i ; do echo -n "+"; head -1 "$$i" | tr -d "\n" ; done)
# the build string makes the reproducible builds impossible. And builddate isn't really that much needed:
# VERSION_STRING=$(VERSION)$(VERSION_EXTRA) (build $(DATE))
VERSION_STRING=$(VERSION)$(VERSION_EXTRA)

all:
	@echo "A default make target doesn't exist. You might want to use one of those:"
	@echo "  make hunspell/de_DE.dic hunspell/de_DE.aff (or de_AT or de_CH)"
	@echo "  make myspell/de_DE.dic myspell/de_DE.aff (or de_AT or de_CH)"
	@echo "  make ispell/de_DE.aff ispell/de_DE.hash (or de_AT, de_CH ...)"
	@echo "  make aspell/de_DE.rws (or de_AT, de_CH ...)"
	@echo "  make ligature/rmligs"
	@echo "  make isowordlist-de_DE (or de_AT, de_CH ...)"
	@echo "Did I forget an important one ?-)"



#MYLANG = $(shell echo -n $@ | sed "s/^.*_\(de_.*$$\)/\1/")
MYLANG = $(shell echo $@ | sed "s/^.*[_/]\(de_[a-zA-Z]*\).*/\1/")

# FIND_OPTS can be used to exclude directories from being used, like:
# FIND_OPTS = ! -name "*-a-*"

define WORDS_define_template

WORDS_$(1) = $$(shell $$(FIND) ./dicts/ -name "*$(1)*.txt" ! -name "*compound*" $$(FIND_OPTS) -print)

WORDS_COMP_$(1) = $$(shell $$(FIND) ./dicts/ -name "compound*$(1)*.txt" $$(FIND_OPTS) -print)

## alle ohne "*-x*"
WORDS_CAPMAIN_SMALL_$(1)	= $$(shell $$(FIND) ./dicts/ -name "*$(1)*.txt" ! -name "*-x*" ! -name "*compound*" $$(FIND_OPTS) -print)

## alle "*-xx*"
WORDS_CAPMAIN_PLUS_$(1)	= $$(shell $$(FIND) ./dicts/ -name "*$(1)*.txt" -name "*-xx*" ! -name "*compound*" $$(FIND_OPTS) -print)

## alle "*-x*" ohne "*-xx*"
WORDS_NOCAPMAIN_$(1)	= $$(shell $$(FIND) ./dicts/ -name "*$(1)*.txt" -name "*-x*" ! -name "*-xx*" ! -name "*compound*" $(FIND_OPTS) -print)

WORDS_BLACKLISTS_$(1) = $$(shell $$(FIND) ./dicts/ -name "blacklist*$(1)*" $(FIND_OPTS) -print)

endef
$(foreach langcode,$(LANGS2),$(eval $(call WORDS_define_template,$(langcode))))

ISPELLIBDIR = $$($(ISPELL) -vv |grep "LIBDIR" |$(SED) "s/.*\=//" |tr -d \")
DESTDIR =
# make might have to be GNU make,
# please report problems with other make versions to me.
MAKE = make
FIND = find
SORT = sort
TAR = tar
SED = sed
NL = nl
CP = cp
# some incarnations of "wc -l" print out leading whitespace, let's use sed:
WCL = $(SED) -n '$$='

# the following is to remove temp files during build. Set it
# to rm if disk space is an issue during build time:
RM_OR_NOT = @\#
#RM_OR_NOT = rm

#ZIP = zip
#ZIP_OPTS = -j -r -9 -X
ZIP = 7z
ZIP_OPTS = a -tzip -mx=9
BUILDHASH = buildhash

ISPELL = ispell
HUNSPELL_BIN = hunspell
# Hunspell starting with 1.1.9 (?) uses automatic charset transcoding,
# we need to make sure we use latin1:
HUNSPELL = $(HUNSPELL_BIN) `$(HUNSPELL_BIN) -h 2>&1 | grep -q "hunspell \\-i" && echo "-i latin1"`


SQ = sq
UNSQ = unsq
#   if for some reason you don't have Ispell's unsq use my Perl sq/unsq
#  and put it into a directory known by your PATH variable!
#UNSQ = unsq.pl

ASPELL = aspell

# if you don't have ispell around, you may change this to aspell:
AFFIX_EXPANDER = ispell

ifeq ($(AFFIX_EXPANDER),ispell)
AFFIX_EXPAND_PREREQ = ispell/$(1)_null.hash ispell/$(1)_null.aff
AFFIX_EXPAND_COMMAND = $(ISPELL) -d./ispell/$(1)_null -e
MUNCH_PFX = munch.
else
AFFIX_EXPAND_PREREQ = aspell/$(1).dat aspell/$(1)_affix.dat
AFFIX_EXPAND_COMMAND = ( $(SED) -f ./bin/dic2iso | $(ASPELL) --encoding=iso8859-1 --lang=$(1) --local-data-dir=./aspell expand )
MUNCH_PFX =
endif

vpath %.txt ./dicts  ./hunspell ./myspell
.SUFFIXES: .txt .dic
.PHONY: clean pack unpack sort help dist hunspell-all
SUBDIRS = testdir

# to let `sort' behave right: setting LC_ALL ist not enough, because
# UTF-8 locales won't get overwritten by that, we also need to reset LANG!
# That's strange and might have been a bug which is fixed in the meantime.
# Otherwise locale depending sorting, grepping etc. which is slow as hell
# (like for de_DE) would be used, we don't need that anyway. See
# http://mail.nl.linux.org/linux-utf8/2003-11/msg00041.html

LANG=C
LC_ALL=C
LC_COLLATE=C


#$(addprefix dicts/,$(WORTE)): unpack
#	echo x
#	test -e $@ || (echo Wortliste $@ nicht vorhanden ; exit 1)



###
## Ispell stuff:
###

ispell/de_AT.aff ispell/de_DE.aff: ispell/de_DE.aff.in
	$(CP) ispell/de_DE.aff.in $@

ispell/de_CH.aff: ispell/de_DE.aff.in
	$(SED) "/swiss-del/d" ispell/de_DE.aff.in |$(SED) "/swiss-convert/s/sS/SS/g" |$(SED) '/\#swiss-only/s/^\#//' |$(SED) '/stringchar/!s/sS//g' > $@


define LANG_ispell_dict_template

ispell/$(1).hash: ispell/$(1).aff all.words.munch.$(1).tmp
	$(BUILDHASH) all.words.munch.$(1).tmp ./ispell/$(1).aff $$@

all.words.$(1).tmp: $$(WORDS_$(1)) $$(WORDS_de_all) dicts/abkuerzpunkt.txt
	$(SED) "s/qq//g;s/\.//;s/\-.*//" dicts/abkuerzpunkt.txt $$(WORDS_$(1)) $$(WORDS_de_all) \
	| (test -e ./bin/conv_dict_$(1) && ./bin/conv_dict_$(1) || cat) \
	| grep -v "\/.*d" | grep -v "##" | $(SED) "s/#.*//" | ./bin/myspellfixprefix.pl | $(SORT) -u > $$@

all.words.munch.$(1).tmp: all.words.$(1).tmp ispell/$(1).aff
	./bin/test-working-grep.sh
	@# the munched way to overcome "Hash table overflowed by xxxx words" error:
	munchlist -l ./ispell/$(1).aff all.words.$(1).tmp > $$@
	@# the unmunched way:
	@#$(CP) all.words.$(1).tmp $$@

ispell/$(1)_null.hash: ispell/$(1)_null.aff
	test -e all.words.placebo.tmp || echo a > all.words.placebo.tmp
	$(BUILDHASH) all.words.placebo.tmp ispell/$(1)_null.aff $$@

isowordlist-$(1): $(AFFIX_EXPAND_PREREQ) all.words.$(MUNCH_PFX)$(1).tmp
	$(AFFIX_EXPAND_COMMAND) < all.words.$(MUNCH_PFX)$(1).tmp |tr ' ' '\n' |$(SED) -f ./bin/dic2iso | $(SORT) -u > $$@

endef
$(foreach langcode,$(LANGS),$(eval $(call LANG_ispell_dict_template,$(langcode))))




###
## old Aspell stuff, new aspell/ stuff support for aspell 0.60 later down...
###
#
#help.hash: german.aff all.words2 .copyright
#	$(BUILDHASH) all.words2 ./german.aff $@
#
#all.words2:
#	cd dicts; sed s/qq//g $(WORTE) | $(SORT) -u > ../$@
#
#aspell: help.hash
#	#cat all.words2 dicts/abkuerzpunkt.txt |$(ISPELL) -e -d./help |sed -f ./bin/dic2iso |sort -u |$(ASPELL) --lang=german create master ./german
#	sed "s/\.//g" all.words2 dicts/abkuerzpunkt.txt |$(ISPELL) -e -d./help |sed -f ./bin/dic2iso | $(SORT) -u |$(ASPELL) --lang=german create master ./german
#
#swiss-aspell: swiss
#	cat all.words.swiss |$(ISPELL) -e -d./swiss |sed -f ./bin/dic2iso | $(SORT) -u |$(ASPELL) --lang=swiss create master ./swiss
#



define LANG_myspell_template

aspell/$(1)_affix.dat: myspell/$(1).aff
	$(CP) myspell/$(1).aff $$@

aspell/$(1).multi: aspell/de_all.multi.in
	$(SED) "s/LANG_REPLACE/$(1)/g" < aspell/de_all.multi.in > $$@

aspell/$(1).alias: aspell/de_all.alias.in
	$(SED) "s/LANG_REPLACE/$(1)/g" < aspell/de_all.alias.in > $$@

aspell/$(1).dat: aspell/de_all.dat.in
	$(SED) "s/LANG_REPLACE/$(1)/g" < aspell/de_all.dat.in > $$@

aspell/$(1).rws: myspell/$(1).dic aspell/$(1)_affix.dat aspell/$(1).multi aspell/$(1).dat aspell/$(1).alias
	# the warnings about skipped words should be ignorable...
	$(ASPELL) --lang=$(1) --dict-dir=./aspell/ --local-data-dir=./aspell/ create master $(1).rws < myspell/$(1).dic

myspell/$(1).dic: $$(WORDS_$(1)) $$(WORDS_de_all) dicts/abkuerzpunkt.txt
	./bin/test-working-grep.sh
	cat $$(WORDS_$(1)) $$(WORDS_de_all) dicts/abkuerzpunkt.txt \
		| (test -e ./bin/conv_dict_$(1) && ./bin/conv_dict_$(1) || cat) \
		| ./bin/myspell-generic-process.sh  > $$@.tmp
	$$(WCL) < $$@.tmp > $$@
	cat myspell/de_all.dic.header | $(SED) "s/AFF_VERSION_REPLACE/$(VERSION_STRING)/;s/LANG_REPLACE/$(1)/" >> $$@
	$(SED) -f ./bin/dic2iso < $$@.tmp >> $$@
	$(RM_OR_NOT) $$@.tmp

endef
$(foreach langcode,$(LANGS) liglist,$(eval $(call LANG_myspell_template,$(langcode))))



define LANG_aff_template

myspell/$(1).aff: myspell/de_all.aff.in myspell/de_all.aff.header
	cat myspell/de_all.aff.header myspell/de_all.aff.in | $(SED) "s/AFF_VERSION_REPLACE/$(VERSION_STRING)/;s/LANG_REPLACE/$(1)/" > $$@

hunspell/$(1).aff: hunspell/de_all.aff.hunspell_additions myspell/de_all.aff.in hunspell/de_all.aff.header
	cat hunspell/de_all.aff.header myspell/de_all.aff.in hunspell/de_all.aff.hunspell_additions | $(SED) "s/AFF_VERSION_REPLACE/$(VERSION_STRING)/;s/LANG_REPLACE/$(1)/" > $$@

ispell/$(1)_null.aff: ispell/$(1).aff
	$(CP) ispell/$(1).aff $$@

endef
$(foreach langcode,$(LANGS) liglist,$(eval $(call LANG_aff_template,$(langcode))))


define LANGS2_hunspell_dicts_template

HUNSPELL_DICTS_BASE_$(1) = hunspell-capmain-small_$(1).tmp hunspell-compdic_$(1).tmp hunspell-end-compdic_$(1).tmp hunspell-middle-compdic_$(1).tmp hunspell-end-compdic_$(1).tmp

#HUNSPELL_DICTS_BASE_$(1) = hunspell-capmain-small_$(1).tmp hunspell-compdic_$(1).tmp hunspell-end-compdic_$(1).tmp hunspell-middle-compdic_$(1).tmp hunspell-end-compdic_$(1).tmp hunspell-capmain-small_de_all.tmp hunspell-compdic_de_all.tmp hunspell-end-compdic_de_all.tmp hunspell-middle-compdic_de_all.tmp hunspell-middle-compdic_de_all.tmp hunspell-end-compdic_de_all.tmp

hunspell-capmain-small_$(1).tmp: $$(WORDS_CAPMAIN_SMALL_$(1))
	# limited dictionary without any *-x* files used to sort out all known words from -xx files
	rm -f $$@.tmp
	echo $$(WORDS_CAPMAIN_SMALL_$(1)) | xargs cat >> $$@.tmp
	./bin/hunspell-capmain $$@.tmp > $$@
	$(RM_OR_NOT) $$@.tmp


hunspell-nocapmain_$(1).tmp: $$(WORDS_NOCAPMAIN_$(1)) $$(WORDS_NOCAPMAIN_de_all)
	# limited dictionary of all -x (but not -xx) files
	rm -f $$@.tmp
	#find dicts/ -name "*x*.txt" ! -name "*-xx*" -print | xargs cat >> $@.tmp
	echo $$(WORDS_NOCAPMAIN_$(1)) $$(WORDS_NOCAPMAIN_de_all) | xargs cat >> $$@.tmp
	###TODO??? ./bin/dic2iso < $$@.tmp > $$@
	mv $$@.tmp $$@

hunspell-middle-compdic_$(1).tmp: dicts/middle-compound.txt
	# more TODO here ?
	$(SED) "s:$$$$:/hkem:;s:/\(.*\)/:/\1:"	< dicts/middle-compound.txt	>  $$@

hunspell-end-compdic_$(1).tmp: dicts/end-compound.txt
	# more TODO here ?
	$(SED) "s:$$$$:/oz:;s:/\(.*\)/:/\1:"		< dicts/end-compound.txt	>  $$@

hunspell-compdic_$(1).tmp: $$(WORDS_COMP_$(1)) $$(WORDS_COMP_de_all)
	# sed hack to add "/"to lines which don't have one yet:
	# sed "/^[^\/]*$$/s/$$/\//"
	echo DEBUG: WORDS_COMP_$(1) :: $$(WORDS_COMP_$(1)) :::
	echo DEBUG: WORDS_COMP_de_all :: $$(WORDS_COMP_de_all) :::
	echo $$(WORDS_COMP_$(1)) $$(WORDS_COMP_de_all) | xargs $(SED) "/^[^\/]*$$$$/s/$$$$/\// ; s/$$$$/hij/"	>  $$@
	echo >> $$@
	#	more TODO here ? (added myspellfixprefix...)
	cat $$(WORDS_COMP_$(1)) $$(WORDS_COMP_de_all) \
		| ./bin/myspellfixprefix.pl \
		| ./bin/lcfirst.pl \
		| $(SED) "/^[^\/]*$$$$/s/$$$$/\//;s/$$$$/hke/"			>> $$@
	echo >> $$@

endef
$(foreach langcode,$(LANGS2),$(eval $(call LANGS2_hunspell_dicts_template,$(langcode))))

define LANG_hunspell_template

HUNSPELL_DICTS_ALL_$(1) = $$(HUNSPELL_DICTS_BASE_$(1)) hunspell-capmain-plus_$(1).tmp hunspell-nocapmain_$(1).tmp dicts/abkuerzpunkt.txt hunspell-blacklist_$(1).tmp \
	$$(HUNSPELL_DICTS_BASE_de_all)

hunspell-blacklist_$(1).tmp: $$(WORDS_BLACKLISTS_$(1)) $$(WORDS_BLACKLISTS_de_all)
	# sed hack to merge /f/g to /fg : sed "s:/\(.*\)/:/\1:"
	cat $$(WORDS_BLACKLISTS_$(1)) $$(WORDS_BLACKLISTS_de_all) >$$@

hunspell-capmain-plus_$(1).tmp: $(AFFIX_EXPAND_PREREQ) hunspell/$(1)_small.dic hunspell/$(1)_small.aff $$(WORDS_CAPMAIN_PLUS_$(1)) $$(WORDS_CAPMAIN_PLUS_de_all)
	echo DEBUG: WORDS_CAPMAIN_PLUS_$(1) :: $$(WORDS_CAPMAIN_PLUS_$(1)) :::
	echo DEBUG: WORDS_CAPMAIN_PLUS_de_all :: $$(WORDS_CAPMAIN_PLUS_de_all) :::
	# limited dictionary of *-xx* files containing compounds not generated by capmain-small
	rm -f $$@.unfiltered-list0.tmp
	#find dicts/ -name "*-xx*.txt" -print | xargs cat >> $$@.unfiltered-list.tmp
	echo $$(WORDS_CAPMAIN_PLUS_$(1)) $$(WORDS_CAPMAIN_PLUS_de_all) | xargs cat >> $$@.unfiltered-list0.tmp
	./bin/myspellfixprefix.pl < $$@.unfiltered-list0.tmp | (test -e ./bin/conv_dict_$(1) && ./bin/conv_dict_$(1) || cat) | grep -v '^$$$$' > $$@.unfiltered-list.tmp
	cat $$@.unfiltered-list.tmp | $(AFFIX_EXPAND_COMMAND) > $$@.unfiltered-list-expanded.tmp
	$(SED) -f ./bin/dic2iso < $$@.unfiltered-list-expanded.tmp |$(SED) "s/qq//g" | $(NL) | $(HUNSPELL) -d hunspell/$(1)_small -L > $$@.unknown.tmp
	$(SED) "s/^ *\([0-9]*\)\t.*$$$$/\1/" $$@.unknown.tmp > $$@.list-unknown-lines.tmp
	./bin/extractlines.pl $$@.list-unknown-lines.tmp $$@.unfiltered-list.tmp > $$@.tmp
	./bin/hunspell-capmain $$@.tmp | $(SED) -f ./bin/iso2dic > $$@
	$(RM_OR_NOT) $$@.unfiltered-list0.tmp $$@.unfiltered-list.tmp $$@.unfiltered-list-expanded.tmp $$@.unknown.tmp $$@.list-unknown-lines.tmp $$@.tmp


hunspell/$(1)_small.dic: $$(HUNSPELL_DICTS_BASE_$(1)) $$(HUNSPELL_DICTS_BASE_de_all) myspell/de_all.dic.header
	echo $$(HUNSPELL_DICTS_BASE_$(1))
	echo $$(HUNSPELL_DICTS_BASE_de_all)
	cat $$(HUNSPELL_DICTS_BASE_$(1)) $$(HUNSPELL_DICTS_BASE_de_all) \
		| (test -e ./bin/conv_dict_$(1) && ./bin/conv_dict_$(1) || cat) \
		| ./bin/hunspell-generic-process.sh \
		> $$@.tmp
	$$(WCL) < $$@.tmp > $$@
	cat myspell/de_all.dic.header | \
		$(SED) "s/AFF_VERSION_REPLACE/$(VERSION_STRING)/;s/LANG_REPLACE/$(1)/;s/Myspell/Hunspell/" >> $$@
	$(SED) -f ./bin/dic2iso < $$@.tmp >> $$@
	$(RM_OR_NOT) $$@.tmp

hunspell/$(1)_small.aff: hunspell/$(1).aff
	$(CP) hunspell/$(1).aff $$@

hunspell/$(1).dic: $$(HUNSPELL_DICTS_ALL_$(1)) $$(HUNSPELL_DICTS_ALL_de_all) myspell/de_all.dic.header
	./bin/test-working-grep.sh
	echo a $$(HUNSPELL_DICTS_ALL_$(1))
	echo b $$(HUNSPELL_DICTS_ALL_de_all)
	cat $$(HUNSPELL_DICTS_ALL_$(1)) $$(HUNSPELL_DICTS_ALL_de_all) \
		| (test -e ./bin/conv_dict_$(1) && ./bin/conv_dict_$(1) || cat) \
		| ./bin/hunspell-generic-process.sh	\
		| ./bin/hunspell-optimize-roothelper.pl	\
		> $$@.tmp
	$$(WCL) < $$@.tmp > $$@
	cat myspell/de_all.dic.header | $(SED) "s/AFF_VERSION_REPLACE/$$(VERSION_STRING)/;s/LANG_REPLACE/$(1)/;s/Myspell/Hunspell/" >> $$@
	$(SED) -f ./bin/dic2iso < $$@.tmp >> $$@
	$(RM_OR_NOT) $$@.tmp



endef
$(foreach langcode,$(LANGS),$(eval $(call LANG_hunspell_template,$(langcode))))

hunspell-all: hunspell/de_DE.aff hunspell/de_DE.dic hunspell/de_AT.aff hunspell/de_AT.dic hunspell/de_CH.aff hunspell/de_CH.dic

# -x dictionaries should not be compounded via capmain
# -xx dictionaries should be "cleaned up" before being compounded via capmain


myspell-zip: myspell/de_DE.aff myspell/de_DE.dic myspell/de_AT.aff myspell/de_AT.dic myspell/de_CH.aff myspell/de_CH.dic
	echo "$(VERSION_STRING)" > myspell/VERSION
	VERSION=`cat VERSION` ; cd myspell; \
	for lang in $(LANGS) ; do \
		rm -f $$lang-$$VERSION.zip ; \
		$(ZIP) $(ZIP_OPTS) $$lang-$$VERSION.zip -i@$$lang.zip.files ; \
	done

mozilla-xpi: hunspell-all mozilla/install.rdf.in
	export VER=$(VERSION) ; \
	rm -fr mozilla/*.tmp ; \
	for lang in DE AT CH ; do \
		mkdir mozilla/de-$$lang.tmp && mkdir mozilla/de-$$lang.tmp/dictionaries ; \
		$(SED) "s/ADDON_LANG_REPLACE/$$lang/g;s/ADDON_VERSION_REPLACE/$$VER/g" mozilla/install.rdf.in > mozilla/de-$$lang.tmp/install.rdf ; \
		$(CP) hunspell/de_$$lang.aff mozilla/de-$$lang.tmp/dictionaries/de-$$lang.aff ; \
		$(CP) hunspell/de_$$lang.dic mozilla/de-$$lang.tmp/dictionaries/de-$$lang.dic ; \
		rm -f mozilla/de-$$lang-$$VER.xpi ; \
		(cd mozilla/de-$$lang.tmp ; $(ZIP) $(ZIP_OPTS) ../de-$$lang-$$VER.xpi . ); \
	done

hunspell-zip: hunspell-all
	echo "$(VERSION_STRING)" > hunspell/VERSION
	VERSION=`cat VERSION` ; cd hunspell; \
	for lang in $(LANGS) ; do \
		rm -f $$lang-$$VERSION.zip ; \
		$(ZIP) $(ZIP_OPTS) $$lang-$$VERSION.zip -i@$$lang.zip.files ; \
	done

huntest: hunspell/hunspell-test.txt
	# huntest fails with "BREAK -" but that is needed for US-Wirtschaft etc.
	# so this is the lesser evil. No perfect solution found so far...
	cat hunspell/hunspell-test.txt |$(HUNSPELL) -L -d hunspell/de_DE > $@.tmp 2>&1
	@if `grep -q "^0 " $@.tmp`;then echo "Huntest NICHT bestanden:"; cat $@.tmp; exit 1;fi
	@if ! test "`$$(WCL) < $@.tmp`" = "`tail -n 1 $@.tmp | cut -f1 -d:`";then echo "Huntest NICHT bestanden (Zu viele als korrekt erkannte Wˆrter):"; cat $@.tmp; exit 1;fi


###
## ligature stuff:
###

define liglist_template

ispell/liglist.aff: ispell/de_DE.aff.in
	$(SED) '/\#qqq/s/^\#//g;/\#nnn/d' ispell/de_DE.aff.in > $$@

ispell/liglist_null.hash: ispell/liglist_null.aff
	test -e all.words.placebo.tmp || echo a > all.words.placebo.tmp
	$(BUILDHASH) all.words.placebo.tmp ispell/$(1)_null.aff $$@

all.words.liglist.tmp: $(foreach langcode,$(LANGS2),$(WORDS_$(langcode)))
	$(SED) "s/\.//" $(foreach langcode,$(LANGS2),$(WORDS_$(langcode))) | \
	grep -v "\/.*d" | grep -v "##" | $(SED) "s/#.*//" | \
	$(SORT) -u > $$@


liglist.tmp: $(AFFIX_EXPAND_PREREQ) all.words.liglist.tmp
	cat ligature/oldspell.liglist all.words.liglist.tmp \
	| $(AFFIX_EXPAND_COMMAND)			\
	| tr \  '\n'					\
	| grep qq					\
	| $(SORT) -u					\
	| $(SED) 's/fqqf/f\|f/g;s/fqql/f\|l/g;s/fqqi/f\|i/g'	\
	| grep \|					\
	| $(SED) s/qq//g				\
	| $(SED) -f ./bin/dic2iso			\
	| tr A-Z a-z					\
	| $(SORT) -u					\
	> $$@

ligature/rmligs: liglist.tmp ligature/rmligs.skel
	cat ligature/rmligs.skel liglist.tmp > $$@
	chmod 755 $$@

endef
$(eval $(call liglist_template,liglist))




###
## misc stuff:
###

clean:
	rm -f all.words* igerman98*.tar.bz2 isowordlist* MD5sums SHA256sums
	#sort liglist.aff  MD5sums myspell/*.dic de_DE.zip de_CH.zip myspell/VERSION *.tmp
	rm -f ispell/*.aff ispell/*.hash
	rm -f myspell/*.dic  myspell/*.aff  myspell/*.zip myspell/VERSION
	rm -f hunspell/*.dic hunspell/*.aff hunspell/*.zip hunspell/VERSION
	rm -f ligature/liglist.* ligature/rmligs
	rm -f mozilla/*.xpi
	$(FIND) aspell/ -type f ! -name "*.in" -print |xargs rm -fr
	$(FIND) . -name "*tmp*" -print |xargs rm -fr

sort:
	@if grep [‰ˆ¸ƒ÷‹ﬂ] dicts/*.txt ;then echo "!!! illegal ISO-8859-1 characters in dictionary files !!!";exit 1;fi
	@if LC_ALL=de_DE.UTF-8 grep [`echo -n "‰ˆ¸ƒ÷‹ﬂ"|iconv -f iso8859-1 -t utf-8`] dicts/*.txt ;then echo "!!! illegal UTF-8 characters in dictionary files !!!";exit 1;fi
	@if grep -q -v "/.*d" dicts/blacklist* ; then echo "missing d in blacklist?" ; exit 1 ; fi
	$(FIND) ./dicts/ -name "*.txt" -print -o -name "blacklist*" -print | while read i; do $(SORT) -u -o "$$i" "$$i"; done

pack: sort
	exit 1
	rm -f unpack
	cd dicts; $(FIND) . -name "*.txt" -print |while read i; do test -e $$i.sq && exit 1; $(SQ) < $$i > $$i.sq && rm $$i; done

unpack:
	exit 1
	cd dicts; $(FIND) . -name "*.sq" -print | while read i; do test -e `basename $$i .sq` && exit 1; $(UNSQ) < $$i > `basename $$i .sq` && rm $$i; done
	touch unpack

dist: sort clean
	echo $(DATE) > VERSION
	$(FIND) . -xtype f ! -name ".*" -a ! -name grep -print | xargs sha256sum | gpg --clearsign > .SHA256sums
	mv .SHA256sums SHA256sums
	ls > .files
	echo igerman98-`cat VERSION` > .name
	mkdir `cat .name`
	mv `cat .files` `cat .name`
	$(TAR) cvf - --exclude "grep" * | bzip2 -9 > `cat .name`.tar.bz2
	mv `cat .name`/* .
	rmdir `cat .name`





###########################
### TEST TRASH follows: ###
###########################

help_test:
	grep "^[[:alpha:]\-]*:"  Makefile | cut -d " " -f 1

test0:
	export BLA=FOO

LIST_FOO = eins zwei drei

eins:

#zwei: $($(WORTE_NEU))
# $(addprefix dicts/,$(WORTE))
zwei: $(WORDS_GENERIC)
	echo $(WORDS_GENERIC)
	touch zwei

drei:
	echo $(WORDS_NOCAPMAIN)
	$(RM_OR_NOT) bla

test1: test0 $(LIST_FOO) testdir/de_DE.dic
	echo $$BLA
	echo $(LIST_FOO)

#FOO_de_DE FOO_de_AT FOO_de_CH FOO_de_all: WORDS_$(subst FOO_,,$@)
#FOO_de_DE FOO_de_AT FOO_de_CH FOO_de_all : MYLANG=$(subst FOO_,,$@)
#FOO_de_DE FOO_de_AT FOO_de_CH FOO_de_all : MYLANG=$(shell echo $@ |sed s/.*_\(de_.*\)/\1/)
#FOO_de_DE FOO_de_AT FOO_de_CH FOO_de_all : MYLANG=$(shell echo $@|sed "s/^.*_\(de_.*$$\)/\1/")
#FOO_de_DE FOO_de_AT FOO_de_CH FOO_de_all: $(FOO_%: WORDS_%)
FOO_de_DE FOO_de_AT FOO_de_CH FOO_de_all: $(WORDS_$(MYLANG)) $(HUNSPELL_DICTS_BASE_$(MYLANG))
	#set MYLANG=$(subst FOO_,,$@)
	echo target: $@
	echo MYLANG: $(MYLANG)
	#echo $(WORDS_$(subst FOO_,,$@))
	echo $(WORDS_$(MYLANG))
	echo $<

WORDS_de_aa = $(WORDS_shell)
WORDS_de_bb = $(WORDS_shell)

SUB_de_aa SUB_de_bb: $(WORDS_$(MYLANG))
	@echo SUB says WORDS is: $(MYLANG)
	@echo SUB says lang is: $(lang)

define MYDEF
$(1): lang_def=hallo
endef

test2_de_aa test2_de_bb: lang=$(MYLANG)
#test2_de_aa: SUB_
#test2_de_aa test2_de_bb: $$(SUB_$(MYLANG))
test2_de_aa test2_de_bb: $(eval $(call MYDEF,$(@)))
	#$(subst LANG,$(lang),SUB_LANG)
	@echo MYLANG: $(MYLANG)
	@echo lang: $(lang)
	@echo lang_def: $(lang_def)
	@echo I think WORDS is: $(WORDS_$(MYLANG))

TESTLANGS=de_aa de_bb de_DE

define LANG_testtemplate
$(1): $$($(1)_OBJS) $$($(1)_LIBS:%=-l%)
	echo aa
test3_$(1): SUB_$(1)
	@echo MYLANG: $(MYLANG)
	@echo I think WORDS is: $(WORDS_$(MYLANG))
	@echo I think I am $$@

ALL_OBJS   += $$($(1)_OBJS)
endef

$(foreach langcode,$(TESTLANGS),$(eval $(call LANG_testtemplate,$(langcode))))
