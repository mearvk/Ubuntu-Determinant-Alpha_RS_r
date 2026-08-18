all: example1 example2 example3

LOADLIBES += $(shell pkg-config libconfig --libs)
CFLAGS += -Wall
CFLAGS += -O2
