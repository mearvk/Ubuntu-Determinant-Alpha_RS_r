.PHONY: all clean install

CC ?= cc
CXX ?= c++
CFLAGS ?= -O2 -pipe -Wall -Wextra -Wpedantic
CXXFLAGS ?= -O2 -pipe -Wall -Wextra -Wpedantic -std=c++17

RUNNER_C = jspec-runner.c
RUNNER_H = jspec-runner.h
RUNNER_CPP = jspec-runner.cpp
RUNNER = jspec-runner
ALPHA = cmd.alpha

all: $(ALPHA) $(RUNNER)

$(ALPHA): alpha.c
	$(CC) $(CFLAGS) -o $@ alpha.c
	chmod 0755 $@

$(RUNNER): $(RUNNER_C) $(RUNNER_H)
	$(CC) $(CFLAGS) -DJSPEC_RUNNER_STANDALONE -o $@ $(RUNNER_C)
	chmod 0755 $@

jspec-runner-cpp.o: $(RUNNER_CPP) $(RUNNER_H)
	$(CXX) $(CXXFLAGS) -c -o $@ $(RUNNER_CPP)

clean:
	rm -f $(ALPHA) $(RUNNER) jspec-runner-cpp.o

install: $(ALPHA) $(RUNNER)
	install -Dm755 $(ALPHA) $(DESTDIR)/usr/lib/jspec/$(ALPHA)
	install -Dm755 $(RUNNER) $(DESTDIR)/usr/local/lib/jspec/$(RUNNER)
	install -Dm644 jspec.desktop $(DESTDIR)/usr/share/applications/jspec.desktop

# The desktop launcher calls jspec-runner. The runner owns the final
# native Linux handoff; presentation and policy stay above this boundary.
