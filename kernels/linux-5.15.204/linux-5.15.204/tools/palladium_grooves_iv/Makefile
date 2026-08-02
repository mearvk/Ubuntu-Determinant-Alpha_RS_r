# SPDX-License-Identifier: GPL-2.0
CC      := gcc
CFLAGS  := -Wall -Wextra -O2 $(WARN_CFLAGS)
TARGET  := palladium_grooves_iv
SRCS    := palladium_grooves_iv.c

.PHONY: all clean install
all: $(TARGET)
$(TARGET): $(SRCS)
	$(CC) $(CFLAGS) -o $@ $^
install: $(TARGET)
	install -d $(DESTDIR)/usr/local/bin
	install -m 755 $(TARGET) $(DESTDIR)/usr/local/bin/
clean:
	rm -f $(TARGET)
