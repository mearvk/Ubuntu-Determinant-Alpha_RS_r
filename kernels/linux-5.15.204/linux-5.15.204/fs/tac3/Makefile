# SPDX-License-Identifier: GPL-2.0

# --- Kernel module (kbuild) ------------------------------------------------
# Builds the mountable TAC3 filesystem from tac3.c. This is the authoritative
# artifact; kbuild ignores the C++ port below.
obj-$(CONFIG_TAC3)	+= tac3.o

# --- Userspace C++ port (portable engine) ---------------------------------
# tac3.cpp/tac3.hpp are a standalone C++ equivalent of the wear/pressure/health
# engine (Tables 1/2/3), for simulation/testing/tooling. They do NOT build under
# kbuild; build them explicitly with a host compiler:
#
#   make -f Makefile tac3-cpp
#
# This section is guarded so it is inert during a kernel build (KERNELRELEASE is
# set by kbuild) and only active when invoked directly as a plain Makefile.
ifndef KERNELRELEASE
CXX      ?= c++
CXXFLAGS ?= -std=c++17 -O2 -Wall -Wextra -Wpedantic

.PHONY: tac3-cpp cpp-clean
tac3-cpp: tac3_cpp.o

# Object-only target (the port is a library; there is no standalone main here).
tac3_cpp.o: tac3.cpp tac3.hpp
	$(CXX) $(CXXFLAGS) -c tac3.cpp -o tac3_cpp.o

cpp-clean:
	rm -f tac3_cpp.o
endif
