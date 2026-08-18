# Makefile for keymapper stuff
#

GENPY := ${addsuffix .py, ${basename ${wildcard *.g}, .g}}

all: $(GENPY)

%.py: %.g
	yapps2 $<

clean:
	rm -f $(GENPY)
