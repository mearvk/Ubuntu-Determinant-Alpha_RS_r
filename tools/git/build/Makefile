# Native policy build entry point for the Ubuntu Determinant Git tree.
#
# This build file compiles the new C and C++ policy companions without
# altering Git's ordinary command implementations. It is intentionally
# separate from the upstream Git Makefile until the policies are wired into
# builtin/add.c, builtin/commit.c, and builtin/rebase.c.

SHELL = /bin/sh

GIT_SRC := ../git
BUILD_DIR := .native-policy

CC ?= cc
CXX ?= c++
CFLAGS ?= -O2
CXXFLAGS ?= -O2
CPPFLAGS ?=

COMMON_CPPFLAGS := -I$(GIT_SRC) $(CPPFLAGS)

C_SOURCES := \
	$(GIT_SRC)/add-budget.c \
	$(GIT_SRC)/commit-budget.c \
	$(GIT_SRC)/rebase-metadoc.c

CPP_SOURCES := \
	$(GIT_SRC)/add-budget.cpp \
	$(GIT_SRC)/commit-budget.cpp \
	$(GIT_SRC)/rebase-metadoc.cpp

C_OBJECTS := $(patsubst $(GIT_SRC)/%.c,$(BUILD_DIR)/c-%.o,$(C_SOURCES))
CPP_OBJECTS := $(patsubst $(GIT_SRC)/%.cpp,$(BUILD_DIR)/cpp-%.o,$(CPP_SOURCES))

.PHONY: all native-policy clean

all: native-policy

native-policy: $(C_OBJECTS) $(CPP_OBJECTS)
	@echo "Native policy sources compiled: add, commit, rebase"

$(BUILD_DIR):
	@mkdir -p $@

$(BUILD_DIR)/c-%.o: $(GIT_SRC)/%.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) $(COMMON_CPPFLAGS) -c $< -o $@

$(BUILD_DIR)/cpp-%.o: $(GIT_SRC)/%.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) $(COMMON_CPPFLAGS) -c $< -o $@

clean:
	$(RM) $(C_OBJECTS) $(CPP_OBJECTS)
	rmdir $(BUILD_DIR) 2>/dev/null || :
