# Native policy build entry point for the Ubuntu Determinant Git tree.
#
# Compiles the native C and C++ policy companions without altering Git's
# ordinary command implementations. Integration into builtin commands remains
# a separate step so standard Git behavior is preserved until explicitly wired.

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

.PHONY: all native-policy clean

all: native-policy

native-policy: $(C_OBJECTS) $(CPP_OBJECTS)
	@echo "Native policy sources compiled: add, commit, push, merge, rebase, restage, autocheck, moral"

$(BUILD_DIR):
	@mkdir -p $@

$(BUILD_DIR)/c-%.o: $(GIT_SRC)/%.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) $(COMMON_CPPFLAGS) -c $< -o $@

$(BUILD_DIR)/cpp-%.o: $(GIT_SRC)/%.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) $(COMMON_CPPFLAGS) -c $< -o $@

clean:
	$(RM) $(C_OBJECTS) $(CPP_OBJECTS)
	rmdir $(BUILD_DIR) 2>/dev/null || :
