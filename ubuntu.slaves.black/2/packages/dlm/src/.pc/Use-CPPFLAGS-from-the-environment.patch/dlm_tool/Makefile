DESTDIR=
PREFIX=/usr
BINDIR=$(PREFIX)/sbin
MANDIR=$(PREFIX)/share/man

BIN_TARGET = dlm_tool
MAN_TARGET = dlm_tool.8

BIN_SOURCE = main.c

CFLAGS += -D_GNU_SOURCE -O2 -ggdb \
	-Wall -Wformat -Wformat-security -Wmissing-prototypes -Wnested-externs \
	-Wpointer-arith -Wextra -Wshadow -Wcast-align -Wwrite-strings \
	-Waggregate-return -Wstrict-prototypes -Winline -Wredundant-decls \
	-Wno-sign-compare -Wno-unused-parameter -Wp,-D_FORTIFY_SOURCE=2 \
	-fexceptions -fasynchronous-unwind-tables -fdiagnostics-show-option \
	-Wp,-D_GLIBCXX_ASSERTIONS -fstack-protector-strong \
	-fstack-clash-protection -Wl,-z,now

CFLAGS += -fPIE -DPIE
CFLAGS += -I../include -I../libdlm -I../dlm_controld

LDFLAGS += -Wl,-z,relro -Wl,-z,defs -pie
LDFLAGS += -L../libdlm -L../dlm_controld
LDFLAGS += -lpthread -ldlm -ldlmcontrol

all: $(BIN_TARGET)

$(BIN_TARGET): $(BIN_SOURCE)
	$(CC) $(BIN_SOURCE) $(CFLAGS) $(LDFLAGS) -o $@

clean:
	rm -f *.o *.so *.so.* $(BIN_TARGET)


INSTALL=$(shell which install)

.PHONY: install
install: all
	$(INSTALL) -d $(DESTDIR)/$(BINDIR)
	$(INSTALL) -d $(DESTDIR)/$(MANDIR)/man8
	$(INSTALL) -c -m 755 $(BIN_TARGET) $(DESTDIR)/$(BINDIR)
	$(INSTALL) -m 644 $(MAN_TARGET) $(DESTDIR)/$(MANDIR)/man8/

