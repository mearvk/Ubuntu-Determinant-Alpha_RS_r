CXX ?= c++
CXXFLAGS ?= -std=c++17 -O2 -Wall -Wextra -Wpedantic
LDFLAGS ?=

TARGET := smaug-check
SOURCES := Smaug.cpp SmaugOS.cpp SmaugAIv2.cpp SmaugCastle.cpp SmaugEmerald.cpp SmaugSmite.cpp SmaugAtom.cpp SmaugInput.cpp SmaugSystemStore.cpp
OBJECTS := $(SOURCES:.cpp=.o)

.PHONY: all check clean

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CXX) $(CXXFLAGS) $(LDFLAGS) -o $@ $(OBJECTS)

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Compile-only quality gate: does not require linking or external AI/database libs.
check:
	$(CXX) $(CXXFLAGS) -fsyntax-only $(SOURCES)

clean:
	rm -f $(OBJECTS) $(TARGET)

# Optional future database backend:
# SMAUG_MYSQL_CXXFLAGS and SMAUG_MYSQL_LDFLAGS can be supplied by a local
# MySQL connector package. The default build intentionally has no database
# dependency and uses FileStore for inspectable local field output.
