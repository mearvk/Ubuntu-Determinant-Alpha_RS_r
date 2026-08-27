CC ?= cc
CXX ?= c++
CFLAGS ?= -std=c11 -O2 -Wall -Wextra -Wpedantic -fPIC
CXXFLAGS ?= -std=c++17 -O2 -Wall -Wextra -Wpedantic -fPIC
LDFLAGS ?=

CPP_SOURCES := Smaug.cpp SmaugOS.cpp SmaugAIv2.cpp SmaugCastle.cpp SmaugEmerald.cpp SmaugSmite.cpp SmaugAtom.cpp SmaugInput.cpp SmaugSystemStore.cpp SmaugInputSource.cpp SmaugOvertine.cpp SmaugDrakeFirecaster.cpp
CPP_OBJECTS := $(CPP_SOURCES:.cpp=.o)
C_SOURCES := smaug.c SmaugCompanions.c
C_OBJECTS := $(C_SOURCES:.c=.o)
OBJECTS := $(CPP_OBJECTS) $(C_OBJECTS)
LIB := libsmaug_system.so
DREAM := smaug-dream

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
	$(CXX) $(CXXFLAGS) -fsyntax-only $(CPP_SOURCES) SmaugDream.cpp
$(DREAM): SmaugDream.cpp
	$(CXX) $(CXXFLAGS) $< -o $@
DREAM_TURNS ?= 3
dream: $(DREAM)
	@./$(DREAM) $(DREAM_TURNS)
clean:
	rm -f $(OBJECTS) $(LIB) $(DREAM)
