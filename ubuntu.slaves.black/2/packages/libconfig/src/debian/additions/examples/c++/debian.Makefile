all: example1 example2 example3 example4

LOADLIBES += $(shell pkg-config libconfig++ --libs)
CXXFLAGS += -Wall
CXXFLAGS += -O2
