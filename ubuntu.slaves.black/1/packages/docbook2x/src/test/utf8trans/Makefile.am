include $(top_srcdir)/docbuild.mk

EXTRA_DIST = $(TEST_IN) $(TEST_OUT)

TEST_IN = basic.txt UTF-8-test.txt long.txt
TEST_OUT = basic.txt.out UTF-8-test.txt.out long.txt.out
TEST_T = basic.txt.t UTF-8-test.txt.t long.txt.t

CLEANFILES=$(TEST_T)

.PHONY: check clean

check: $(TEST_T)
clean:
	rm -f $(TEST_T)

approve:
	for f in $(TEST_IN) ; do \
		$(utf8trans) $(top_srcdir)/charmaps/roff.charmap "$$f" > "$${f}.out"; \
	done

%.txt.t: %.txt
	$(utf8trans) $(top_srcdir)/charmaps/roff.charmap $< > $@
	diff -u $(srcdir)/$*.txt.out $@ 

