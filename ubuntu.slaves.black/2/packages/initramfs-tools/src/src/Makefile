PKG_CONFIG = pkg-config
UDEV_CFLAGS = $(shell $(PKG_CONFIG) --cflags libudev)
UDEV_LIBS = $(shell $(PKG_CONFIG) --libs libudev)

CC = gcc
CFLAGS = -g -Wall -O2 $(UDEV_CFLAGS)
LDFLAGS =


.PHONY: all
all: wait-for-root gcc_s1-stub

wait-for-root: wait-for-root.o
	$(CC) $(LDFLAGS) -o $@ $< $(UDEV_LIBS)

gcc_s1-stub:
	gcc -Wl,--no-as-needed -shared -l:libpthread.so.0 -l:libgcc_s.so.1 -o $@

.PHONY: clean
clean:
	rm -f wait-for-root.o wait-for-root gcc_s1-stub core *~
