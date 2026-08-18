INCDIR=/usr/include
LIBDIR=/usr/lib
DATADIR=/usr/share/dumbtts

RELEASE = 3.1
LIB_NAME = libdumbtts.so
LIB_VERSION = 0
LIBTAG = $(LIB_VERSION).$(RELEASE)

INSTALL = /usr/bin/install
LN_SF = /bin/ln -sf
MKDIR = mkdir -p
C = gcc
PIC =
ARCH = $(shell uname -m)

ifeq "$(ARCH)" "x86_64"
	PIC = -fPIC
endif

SRCS = libdumbtts.c libdumbtts.h libdumbtts_re.c libdumbtts_dic.c local.h
OBJS = libdumbtts.o

all: $(LIB_NAME)
	mv $(LIB_NAME) $(LIB_NAME).$(LIBTAG)

$(OBJS): $(SRCS)
	$(C) $(PIC) -o $(OBJS) -c -Wall libdumbtts.c

$(LIB_NAME): $(OBJS)
	$(C) $(PIC) -shared -Wl,-soname,$(LIB_NAME).$(LIB_VERSION) -o $@ $(OBJS)

clean:
	rm -f *.o *.a *~ $(LIB_NAME).$(LIBTAG) ../conf/*~
	
install: all
	# Create directories
	rm -rf $(DESTDIR)$(DATADIR)
	$(MKDIR) $(DESTDIR)$(LIBDIR)
	$(MKDIR) $(DESTDIR)$(INCDIR)
	$(MKDIR) $(DESTDIR)$(DATADIR)
	# Install shared library
	$(INSTALL) -m 755 $(LIB_NAME).$(LIBTAG) $(DESTDIR)$(LIBDIR)
	$(LN_SF) $(LIB_NAME).$(LIBTAG) $(DESTDIR)$(LIBDIR)/$(LIB_NAME).$(LIB_VERSION)
	$(LN_SF) $(LIB_NAME).$(LIB_VERSION) $(DESTDIR)$(LIBDIR)/$(LIB_NAME)
	# Install development headers
	$(INSTALL) -pm 644 libdumbtts.h $(DESTDIR)$(INCDIR)
	# Install data files
	cp -prf ../conf/* $(DESTDIR)$(DATADIR)

