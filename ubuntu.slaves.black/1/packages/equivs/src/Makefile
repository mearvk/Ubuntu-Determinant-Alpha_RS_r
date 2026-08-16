MANPAGES := equivs-control.1 equivs-build.1
BUILD_DATE = $(shell LC_ALL=C date -u +'%d %b %Y' -d "@$(SOURCE_DATE_EPOCH)")

%.1: %.pod
	pod2man -s 1 -r "$(BUILD_DATE)" -c "Debian" -d ' ' $< > $@

all: $(MANPAGES)

clean:
	rm -f $(MANPAGES)
