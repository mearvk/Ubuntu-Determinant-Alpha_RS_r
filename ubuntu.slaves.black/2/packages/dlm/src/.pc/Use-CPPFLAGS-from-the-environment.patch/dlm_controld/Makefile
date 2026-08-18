DESTDIR=
PREFIX=/usr
LIBNUM=/lib64
BINDIR=$(PREFIX)/sbin
LIBDIR=$(PREFIX)/$(LIBNUM)
HDRDIR=$(PREFIX)/include 
MANDIR=$(PREFIX)/share/man
PKGDIR=$(LIBDIR)/pkgconfig

USE_SD_NOTIFY=yes

BIN_TARGET = dlm_controld

LIB_NAME = libdlmcontrol
LIB_MAJOR = 3
LIB_MINOR = 2
LIB_SO = $(LIB_NAME).so
LIB_SMAJOR = $(LIB_SO).$(LIB_MAJOR)
LIB_TARGET = $(LIB_SO).$(LIB_MAJOR).$(LIB_MINOR)
LIB_PC = $(LIB_NAME).pc
LIB_PCIN = $(LIB_NAME).pc.in

BIN_SOURCE = action.c \
             cpg.c \
             daemon_cpg.c \
             helper.c \
             crc.c \
             fence_config.c \
             fence.c \
             main.c \
             plock.c \
             config.c \
             member.c \
             logging.c \
             rbtree.c \
             node_config.c
LIB_SOURCE = lib.c

CFLAGS += -D_GNU_SOURCE -O2 -ggdb \
	-Wall -Wformat -Wformat-security -Wmissing-prototypes -Wnested-externs \
	-Wpointer-arith -Wextra -Wshadow -Wcast-align -Wwrite-strings \
	-Waggregate-return -Wstrict-prototypes -Winline -Wredundant-decls \
	-Wno-sign-compare -Wno-unused-parameter -Wp,-D_FORTIFY_SOURCE=2 \
	-fexceptions -fasynchronous-unwind-tables -fdiagnostics-show-option \
	-Wp,-D_GLIBCXX_ASSERTIONS -fstack-protector-strong \
	-fstack-clash-protection -Wl,-z,now

BIN_CFLAGS += $(CFLAGS) -fPIE -DPIE
BIN_CFLAGS += -I../include -I../libdlm
LIB_CFLAGS += $(CFLAGS) -fPIC

BIN_LDFLAGS += $(LDFLAGS) -Wl,-z,relro -Wl,-z,defs -pie
BIN_LDFLAGS += -lpthread -lrt -lcpg -lcmap -lcfg -lquorum -luuid
LIB_LDFLAGS += $(LDFLAGS) -Wl,-z,relro -Wl,-z,defs -pie

PKG_CONFIG ?= pkg-config
ifeq ($(USE_SD_NOTIFY),yes)
	BIN_CFLAGS += $(shell $(PKG_CONFIG) --cflags libsystemd) \
		      -DUSE_SD_NOTIFY
	BIN_LDFLAGS += $(shell $(PKG_CONFIG) --libs libsystemd)
endif

ifeq (, $(shell $(PKG_CONFIG) --libs "libquorum >= 3.1.0"))
	 $(error "Requires libquorum at least version 3.1.0")
endif

all: $(LIB_TARGET) $(BIN_TARGET) $(LIB_PC)

$(BIN_TARGET): $(BIN_SOURCE)
	$(CC) $(BIN_SOURCE) $(BIN_CFLAGS) $(BIN_LDFLAGS) -o $@ -L.

$(LIB_TARGET): $(LIB_SOURCE)
	$(CC) $^ $(LIB_CFLAGS) $(LIB_LDFLAGS) -shared -o $@ -Wl,-soname=$(LIB_SMAJOR)
	ln -sf $(LIB_TARGET) $(LIB_SO)
	ln -sf $(LIB_TARGET) $(LIB_SMAJOR)

$(LIB_PC): $(LIB_PCIN)
	cat $(LIB_PCIN) | sed -e 's#@PREFIX@#$(PREFIX)#g;s#@LIBDIR@#$(LIBDIR)#g' > $@

clean:
	rm -f *.o *.so *.so.* $(BIN_TARGET) $(LIB_TARGET) *.pc


INSTALL=$(shell which install)

.PHONY: install
install: all
	$(INSTALL) -d $(DESTDIR)/$(BINDIR)
	$(INSTALL) -d $(DESTDIR)/$(LIBDIR)
	$(INSTALL) -d $(DESTDIR)/$(HDRDIR)
	$(INSTALL) -d $(DESTDIR)/$(MANDIR)/man8
	$(INSTALL) -d $(DESTDIR)/$(MANDIR)/man5
	$(INSTALL) -d $(DESTDIR)/$(PKGDIR)
	$(INSTALL) -m 755 $(BIN_TARGET) $(DESTDIR)/$(BINDIR)
	$(INSTALL) -m 755 $(LIB_TARGET) $(DESTDIR)/$(LIBDIR)
	cp -a $(LIB_SO) $(DESTDIR)/$(LIBDIR)
	cp -a $(LIB_SMAJOR) $(DESTDIR)/$(LIBDIR)
	$(INSTALL) -m 644 $(LIB_PC) $(DESTDIR)/$(PKGDIR)
	$(INSTALL) -m 644 libdlmcontrol.h $(DESTDIR)/$(HDRDIR)
	$(INSTALL) -m 644 dlm_controld.8 $(DESTDIR)/$(MANDIR)/man8/
	$(INSTALL) -m 644 dlm.conf.5 $(DESTDIR)/$(MANDIR)/man5/

