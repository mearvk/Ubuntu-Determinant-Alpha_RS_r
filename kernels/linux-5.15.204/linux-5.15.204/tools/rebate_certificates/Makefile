# SPDX-License-Identifier: GPL-2.0
CC := gcc
CFLAGS := -Wall -Wextra -O2
TARGET := rebate_certificates
.PHONY: all clean install
all: $(TARGET)
$(TARGET): rebate_certificates.c
	$(CC) $(CFLAGS) -o $@ $<
install: $(TARGET)
	install -d $(DESTDIR)/usr/local/bin
	install -m 755 $(TARGET) $(DESTDIR)/usr/local/bin/
clean:
	rm -f $(TARGET)
