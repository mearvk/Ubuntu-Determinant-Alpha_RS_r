OBJ=en.1 fr.1 pl.1
TESTS=testsuite/test01.html testsuite/test02.html testsuite/test03.html testsuite/test04.html \
    testsuite/test05.html testsuite/test06.html testsuite/test07.html testsuite/test08.html \
    testsuite/test09.html testsuite/test10.html

%.1: %.pod
	ln -sf $< freetable.pod && pod2man --center='Freetable' --utf8 freetable.pod >$@
	rm -f freetable.pod

all: $(OBJ)

clean:
	rm -f $(OBJ) $(TESTS)

tests: $(TESTS)

testsuite/%.html: testsuite/%.in ./freetable
	./freetable <$< >$@
testsuite/test07.html: testsuite/test07.in ./freetable
	./freetable -l -m <$< >$@
testsuite/test08.html: testsuite/test08.in ./freetable
	./freetable -l -m <$< >$@
testsuite/test10.html: testsuite/test10.in ./freetable
	./freetable -l <$< >$@
