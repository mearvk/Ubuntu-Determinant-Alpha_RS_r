# Makefile for munch and unmunch

TARGETS=munch unmunch hunmunch hununmunch

all: $(TARGETS)

clean:
	rm -f $(TARGETS)

munch: munch.c munch.h
	gcc -O2 -o $@ munch.c

unmunch: unmunch.c unmunch.h
	gcc -O2 -o $@ unmunch.c

hunmunch: hunmunch.c hunmunch.h
	gcc -O2 -o $@ hunmunch.c

hununmunch: hununmunch.c hununmunch.h
	gcc -O2 -o $@ hununmunch.c

