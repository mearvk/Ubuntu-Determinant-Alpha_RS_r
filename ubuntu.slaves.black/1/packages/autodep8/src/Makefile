PREFIX ?= /usr/local
install_support = $(filter-out install-common install-autodep8lib.sh,$(patsubst support/%, install-%, $(wildcard support/*)))

all: autodep8.1

autodep8.1: autodep8.pod
	pod2man --verbose --name autodep8 -c '' -r '' --utf8 $< $@ || ($(RM) $@; false)

autodep8.pod: README.md examples.md
	(sed -e '/examples.md/ r examples.md' README.md | sed -e '/examples.md/d; /```/,/```/ s/^/    /; /```/d; s/^##/=head2/; s/^#/=head1/; s/\*\*\([^\*]*\)\*\*/B<\1>/g; s/\*\([^\*]*\)\*/I<\1>/g' > $@) || ($(RM) $@; false)

update-examples:
	sh examples.sh > examples.md

install: $(install_support)
	install -m 644 support/common $(DESTDIR)/$(PREFIX)/share/autodep8/support
	install -m 644 support/autodep8lib.sh $(DESTDIR)/$(PREFIX)/share/autodep8/support
	install -d $(DESTDIR)/$(PREFIX)/bin
	install -m 755 autodep8 $(DESTDIR)/$(PREFIX)/bin
	install -d $(DESTDIR)/$(PREFIX)/share/man/man1
	install -m 644 autodep8.1 $(DESTDIR)/$(PREFIX)/share/man/man1/

$(install_support): install-%: support/%
	install -d $(DESTDIR)/$(PREFIX)/share/autodep8/$<
	install -m 755 $^/* $(DESTDIR)/$(PREFIX)/share/autodep8/$<

.PHONY: test
test:
	./test/run.sh test/*_test.sh

check: test

clean:
	$(RM) autodep8.pod autodep8.1
