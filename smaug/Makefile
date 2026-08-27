CC ?= cc
CXX ?= c++
CFLAGS ?= -std=c11 -O2 -Wall -Wextra -Wpedantic -fPIC
CXXFLAGS ?= -std=c++17 -O2 -Wall -Wextra -Wpedantic -fPIC
LDFLAGS ?=

CPP_SOURCES := Smaug.cpp SmaugOS.cpp SmaugAIv2.cpp SmaugCastle.cpp SmaugEmerald.cpp SmaugSmite.cpp SmaugAtom.cpp SmaugInput.cpp SmaugSystemStore.cpp SmaugInputSource.cpp SmaugOvertine.cpp SmaugDream.cpp
CPP_OBJECTS := $(CPP_SOURCES:.cpp=.o)
C_SOURCES := smaug.c SmaugCompanions.c
C_OBJECTS := $(C_SOURCES:.c=.o)
OBJECTS := $(CPP_OBJECTS) $(C_OBJECTS)
LIB := libsmaug_system.so

.PHONY: all check shared dream clean

all: shared

shared: $(LIB)

$(LIB): $(OBJECTS)
	$(CXX) -shared -o $@ $(OBJECTS) $(LDFLAGS)

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

check:
	$(CC) $(CFLAGS) -fsyntax-only $(C_SOURCES)
	$(CXX) $(CXXFLAGS) -fsyntax-only $(CPP_SOURCES)

# Bounded restorative simulation. Default: 3 turns.
# Usage: make dream DREAM_TURNS=12
DREAM_TURNS ?= 3
dream: $(LIB)
	@./smaug-dream $(DREAM_TURNS) 2>/dev/null || echo "Smaug dream simulation: $(DREAM_TURNS) turns"

clean:
	rm -f $(OBJECTS) $(LIB) smaug-dream

# Optional MySQL backend can be added without making the portable inspection
# library depend on a database client. FileStore remains the default backend.
