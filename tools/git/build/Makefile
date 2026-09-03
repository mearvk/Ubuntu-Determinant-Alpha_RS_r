# Native policy build entry point for the Ubuntu Determinant Git tree.
#
# This build file compiles the C and C++ policy companions together, performs
# a header/source consistency check, and optionally links a standalone policy
# object archive. It does not alter Git's ordinary command implementations.
# Command registration remains a separate integration step.

SHELL = /bin/sh

GIT_SRC := ../git
BUILD_DIR := .native-policy
LIB := $(BUILD_DIR)/libgit-native-policy.a

CC ?= cc
CXX ?= c++
AR ?= ar
RANLIB ?= ranlib
CFLAGS ?= -O2
CXXFLAGS ?= -O2
CPPFLAGS ?=
ARFLAGS ?= rcs

COMMON_CPPFLAGS := -I$(GIT_SRC) $(CPPFLAGS)

C_SOURCES := \
	$(GIT_SRC)/add-budget.c \
	$(GIT_SRC)/commit-budget.c \
	$(GIT_SRC)/rebase-metadoc.c \
	$(GIT_SRC)/merge-metadoc.c \
	$(GIT_SRC)/operation-logic.c \
	$(GIT_SRC)/restage.c \
	$(GIT_SRC)/autocheck.c \
	$(GIT_SRC)/moral.c

CPP_SOURCES := \
	$(GIT_SRC)/add-budget.cpp \
	$(GIT_SRC)/commit-budget.cpp \
	$(GIT_SRC)/rebase-metadoc.cpp \
	$(GIT_SRC)/operation-logic.cpp \
	$(GIT_SRC)/restage.cpp \
	$(GIT_SRC)/autocheck.cpp \
	$(GIT_SRC)/moral.cpp

C_OBJECTS := $(patsubst $(GIT_SRC)/%.c,$(BUILD_DIR)/c-%.o,$(C_SOURCES))
CPP_OBJECTS := $(patsubst $(GIT_SRC)/%.cpp,$(BUILD_DIR)/cpp-%.o,$(CPP_SOURCES))
OBJECTS := $(C_OBJECTS) $(CPP_OBJECTS)

.PHONY: all native-policy archive check clean

all: native-policy archive

native-policy: $(OBJECTS)
	@echo "Native policy sources compiled: add, commit, push, merge, rebase, restage, autocheck, moral"

archive: $(LIB)

$(LIB): $(OBJECTS) | $(BUILD_DIR)
	$(AR) $(ARFLAGS) $@ $(OBJECTS)
	$(RANLIB) $@

$(BUILD_DIR):
	@mkdir -p $@

$(BUILD_DIR)/c-%.o: $(GIT_SRC)/%.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) $(COMMON_CPPFLAGS) -c $< -o $@

$(BUILD_DIR)/cpp-%.o: $(GIT_SRC)/%.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) $(COMMON_CPPFLAGS) -c $< -o $@

check: native-policy
	@for header in add-budget.h commit-budget.h rebase-metadoc.h merge-metadoc.h operation-logic.h restage.h autocheck.h moral.h; do \
		test -f $(GIT_SRC)/$$header || { echo "missing header: $$header"; exit 1; }; \
	done
	@echo "Native policy source/header set is complete."

clean:
	$(RM) $(OBJECTS) $(LIB)
	rmdir $(BUILD_DIR) 2>/dev/null || :
