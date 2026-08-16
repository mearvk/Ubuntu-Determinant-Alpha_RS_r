PACKAGE=friendly-recovery
top_srcdir = ..

all: friendly-recovery.pot update-po update-mo 

friendly-recovery.pot: POTFILES.in
	xgettext --files-from=./POTFILES.in --lang shell --output $(PACKAGE).pot

update-mo: $(patsubst %.po,%.mo,$(wildcard *.po))

%.mo : %.po
	mkdir -p $(top_srcdir)/usr/share/locale/$(subst .po,,$<)/LC_MESSAGES/ 
	msgfmt $< -o $(top_srcdir)/usr/share/locale/$(subst .po,,$<)/LC_MESSAGES/$(PACKAGE).mo 

update-po: 
	for f in *.po; do \
		msgmerge -o $$f $$f friendly-recovery.pot; \
	done
