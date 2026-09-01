# SPDX-License-Identifier: GPL-2.0
#
# muntutils — source trimmer and size/stats reporter (C11 + C++17)
#

CC       = gcc
CXX      = g++
CFLAGS   = -Wall -Wextra -O2 -std=c11
CXXFLAGS = -Wall -Wextra -O2 -std=c++17
PREFIX   = /usr/local
BINDIR   = $(PREFIX)/bin

C_OBJS   = muntutils_fs.o
CXX_OBJS = muntutils_trim.o main.o
OBJS     = $(C_OBJS) $(CXX_OBJS)

.PHONY: all install uninstall clean

all: muntutils

muntutils: $(OBJS)
	$(CXX) $(CXXFLAGS) -o $@ $(OBJS)

muntutils_fs.o: muntutils_fs.c muntutils_fs.h
	$(CC) $(CFLAGS) -c $< -o $@

muntutils_trim.o: muntutils_trim.cpp muntutils_trim.hpp muntutils_fs.h
	$(CXX) $(CXXFLAGS) -c $< -o $@

main.o: main.cpp muntutils_trim.hpp muntutils_fs.h
	$(CXX) $(CXXFLAGS) -c $< -o $@

install: muntutils
	install -m 755 muntutils $(DESTDIR)$(BINDIR)/muntutils

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/muntutils

clean:
	rm -f muntutils $(OBJS)
