# Makefile for dhelp project

# Copyright (C) 2005 Esteban Manchado Velázquez <zoso@debian.org>
# Copyright (C) 2012 Georgios M. Zarkadas <gz@member.fsf.org>

# This file is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the
# Free Software Foundation; either version 2, or (at your option) any
# later version.

# This file is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied warranty
# of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this file; see the file COPYING.  If not, write to the Free
# Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.

PACKAGE := dhelp
VERSION = $(shell dpkg-parsechangelog | egrep Version: | sed 's/Version: //')

# We rely on caller to have set proper values for PREFIX, DESTDIR.

PREFIX_  = $(if $(PREFIX),$(PREFIX),/usr/local)
DESTDIR_ = $(DESTDIR)/$(PREFIX_)

bindir   = $(DESTDIR_)/bin
sbindir  = $(DESTDIR_)/sbin
cgidir   = $(DESTDIR_)/lib/cgi-bin
confdir  = $(DESTDIR)/etc
sharedir = $(DESTDIR_)/share/$(PACKAGE)
docdir   = $(DESTDIR_)/share/doc/$(PACKAGE)

# The caller should define VENDOR_RUBY to use the new location for ruby
# libraries from squeeze and onwards; OLD_VENDOR_RUBY for wheezy and onwards.
# Undefine it to backport the package to previous Debian releases.

ifdef VENDOR_RUBY
rubydir = $(DESTDIR_)/lib/ruby/vendor_ruby/
else
  ifdef OLD_VENDOR_RUBY
rubydir = $(DESTDIR_)/lib/ruby/vendor_ruby/1.8
  else
rubydir = $(DESTDIR_)/lib/ruby/1.8
  endif
endif

# Templates and Perl-related variables 

RHTML_TEMPLATES = templates/*.rhtml
TMPL_TEMPLATES = templates/*.tmpl
PERL_I18N_PROGRAMS = src/dsearch


.PHONY: install all clean test updatepo po-file
.PHONY: install-bin install-lib install-shared
.PHONY: install-doc install-conf install-po

# Nothing to be done for all since we do not need to compile anything.
all:

# Note that since dhelp is inherently a debian-specific package, we currently
# delegate the caller (debian/rules) to install manpages, examples and common
# files.
install: install-bin install-lib install-shared install-doc install-conf install-po

## Executable files
install-bin:
	install -D src/dhelp   $(bindir)/dhelp
	# Update $version variable in dhelp
	sed -i 's/__VERSION__/$(VERSION)/' $(bindir)/dhelp
	install -D src/dsearch $(cgidir)/dsearch
	install -D src/dhelp_fetcher.rb $(cgidir)/dhelp_fetcher
	install -D src/dhelp_parse.rb   $(sbindir)/dhelp_parse
	# Update PREFIX variable in dhelp_parse.rb
	sed -i 's|^PREFIX = .*|PREFIX = "$(PREFIX_)"|' $(sbindir)/dhelp_parse
	chmod a+x $(sbindir)/dhelp_parse

## Ruby libraries
install-lib:
	install --directory $(rubydir)/dhelp/exporter
	install --mode=644  lib/*.rb $(rubydir)
	install --mode=644  lib/dhelp/exporter/*.rb $(rubydir)/dhelp/exporter

## Shared files (web server configuration, scripts, page templates)
install-shared:
	install --directory $(sharedir)/config $(sharedir)/scripts $(sharedir)/templates
	install --mode=644  config/* $(sharedir)/config
	install   scripts/* $(sharedir)/scripts
	install --mode=644  templates/* $(sharedir)/templates

# CSS stuff and documents
install-doc:
	install --directory $(docdir)/css
	install --mode=644  doc/css/* $(docdir)/css

## Our and web servers configuration under /etc
install-conf:
	install -D --mode=644 config/dhelp.conf-sample $(confdir)/dhelp.conf
	install -D --mode=644 config/apache-dhelp-2.2.conf $(confdir)/apache2/conf.d/dhelp.conf
	install -D --mode=644 config/apache-dhelp.conf $(confdir)/apache2/conf-available/dhelp.conf
	install -D --mode=644 config/lighttpd-dhelp.conf $(confdir)/lighttpd/conf-available/95-dhelp.conf

## Translations
install-po:
	for i in po/*.po; do \
	    langdir=share/locale/`basename $$i .po`/LC_MESSAGES; \
	    mkdir -p $(DESTDIR_)/$$langdir; \
	    rmsgfmt -o $(DESTDIR_)/$$langdir/dhelp.mo $$i; \
	done

# Nothing to be done for clean since we do not need to compile anything.
# This is to suppress the (ignored anyway) dpkg error from the build log. 
clean:

# Note that we use a specific ruby version. This line 
# must change in sync with $(rubydir) definition, above.
test:
	RUBYLIB=lib:test ruby1.8 -w test/ts_dhelp.rb

updatepo: po/*.po

reportpo:
	podebconf-report-po --call --withtranslators --languageteam --podir po/

po/dhelp.pot: $(RHTML_TEMPLATES) $(TMPL_TEMPLATES) $(PERL_I18N_PROGRAMS)
	rgettext $(RHTML_TEMPLATES) >po/dhelp.pot
	xgettext --language=c --keyword=t --join-existing -o po/dhelp.pot $(TMPL_TEMPLATES)
	xgettext --language=perl --keyword=_ --join-existing -o po/dhelp.pot $(PERL_I18N_PROGRAMS)

po/%.po: po-file
	msgmerge $@ po/dhelp.pot > $@.tmp
	mv -f $@.tmp $@

