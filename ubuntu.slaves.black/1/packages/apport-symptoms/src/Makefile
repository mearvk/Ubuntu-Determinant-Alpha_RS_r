default:
	@echo Nothing to do

install:
	install -d $(DESTDIR)/usr/share/apport/symptoms
	install -m 644 symptoms/*.py $(DESTDIR)/usr/share/apport/symptoms

.PHONY: default install clean
