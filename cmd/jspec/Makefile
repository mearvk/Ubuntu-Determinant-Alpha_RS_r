.PHONY: all clean

CC ?= cc
CFLAGS ?= -O2 -pipe -Wall -Wextra -Wpedantic

all: cmd.alpha

cmd.alpha: alpha.c
	$(CC) $(CFLAGS) -o $@ alpha.c
	chmod 0755 $@

clean:
	rm -f cmd.alpha

# Install as a native executable with the JSpec .alpha identity.
install: cmd.alpha
	install -Dm755 cmd.alpha $(DESTDIR)/usr/lib/jspec/cmd.alpha
