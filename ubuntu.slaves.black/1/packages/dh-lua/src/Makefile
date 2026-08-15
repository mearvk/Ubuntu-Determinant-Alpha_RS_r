# Copyright: © 2012 Enrico Tassi <gareuselesinge@debian.org>
# License: MIT/X

DH_LUA_HOME=usr/share/dh-lua/
DH_HOME=usr/share/perl5/Debian/Debhelper/
POLICY_VERSION=$(shell dpkg-parsechangelog | grep '^Version: ' | cut -d : -f 2)

all build: man/dh_lua.1 man/lua-any.1
	$(MAKE) -C doc/
       
clean:
	$(MAKE) -C doc/ clean

test:

install:
	mkdir -p $(DESTDIR)/$(DH_LUA_HOME)/template/
	mkdir -p $(DESTDIR)/$(DH_LUA_HOME)/make/
	mkdir -p $(DESTDIR)/$(DH_LUA_HOME)/test/5.1/
	mkdir -p $(DESTDIR)/$(DH_LUA_HOME)/test/5.2/
	mkdir -p $(DESTDIR)/$(DH_LUA_HOME)/test/5.3/
	mkdir -p $(DESTDIR)/$(DH_LUA_HOME)/test/5.4/
	mkdir -p $(DESTDIR)/$(DH_HOME)/Buildsystem/
	mkdir -p $(DESTDIR)/$(DH_HOME)/Sequence/
	mkdir -p $(DESTDIR)/usr/bin/
	mkdir -p $(DESTDIR)/usr/share/doc/dh-lua/
	cp bin/* $(DESTDIR)/usr/bin/
	cp template/* $(DESTDIR)/$(DH_LUA_HOME)/template/
	cp make/* $(DESTDIR)/$(DH_LUA_HOME)/make/
	cp test/5.1/* $(DESTDIR)/$(DH_LUA_HOME)/test/5.1/
	cp test/5.2/* $(DESTDIR)/$(DH_LUA_HOME)/test/5.2/
	cp test/5.3/* $(DESTDIR)/$(DH_LUA_HOME)/test/5.3/
	cp test/5.4/* $(DESTDIR)/$(DH_LUA_HOME)/test/5.4/
	cp debhelper7/buildsystem/* $(DESTDIR)/$(DH_HOME)/Buildsystem/
	cp debhelper7/sequence/* $(DESTDIR)/$(DH_HOME)/Sequence/
	cat doc/policy.txt | sed 's/@@V@@/$(POLICY_VERSION)/' \
		> $(DESTDIR)/usr/share/doc/dh-lua/policy.txt

man/dh_lua.1: bin/dh_lua
	pod2man -c "dh_lua" -r "dh_lua" bin/dh_lua man/dh_lua.1

man/lua-any.1: man/lua-any.1.txt
	txt2man -d "`dpkg-parsechangelog -S date`"\
		-v "" -r "lua-any" -t "lua-any 1" \
		$< > $@

upload: all
	scp doc/html/* alioth.debian.org:pkg-lua/
