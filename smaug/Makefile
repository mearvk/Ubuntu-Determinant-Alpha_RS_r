CC ?= cc
CXX ?= c++
CFLAGS ?= -std=c11 -O2 -Wall -Wextra -Wpedantic -fPIC
CXXFLAGS ?= -std=c++17 -O2 -Wall -Wextra -Wpedantic -fPIC
LDFLAGS ?=

CPP_SOURCES := Smaug.cpp SmaugOS.cpp SmaugAIv2.cpp SmaugCastle.cpp SmaugEmerald.cpp SmaugSmite.cpp SmaugAtom.cpp SmaugInput.cpp SmaugSystemStore.cpp
CPP_OBJECTS := $(CPP_SOURCES:.cpp=.o)
C_OBJECTS := smaug.o
OBJECTS := $(CPP_OBJECTS) $(C_OBJECTS)
LIB := libsmaug_system.so

.PHONY: all check shared clean

all: shared

shared: $(LIB)

$(LIB): $(OBJECTS)
	$(CXX) -shared -o $@ $(OBJECTS) $(LDFLAGS)

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

smaug.o: smaug.c Smaug.h
	$(CC) $(CFLAGS) -c $< -o $@

# Quality gate: compile every translation unit without linking or loading a model.
check:
	$(CC) $(CFLAGS) -fsyntax-only smaug.c
	$(CXX) $(CXXFLAGS) -fsyntax-only $(CPP_SOURCES)

clean:
	rm -f $(OBJECTS) $(LIB)

# Optional MySQL backend can be supplied later without making the portable
# inspection library depend on a database client. FileStore remains the
# default inspectable backend.
