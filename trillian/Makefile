.PHONY: all configure build clean install uninstall profile

PREFIX ?= $(HOME)/.local
BUILD ?= build-linux
SRC := dino

all: build

configure:
	@command -v meson >/dev/null 2>&1 || { echo 'ERROR: meson is required.' >&2; exit 2; }
	@command -v ninja >/dev/null 2>&1 || { echo 'ERROR: ninja is required.' >&2; exit 2; }
	meson setup $(BUILD) $(SRC) --buildtype=debugoptimized --warnlevel=3

build: configure
	meson compile -C $(BUILD)

install: build
	meson install -C $(BUILD) --destdir $(DESTDIR) --prefix $(PREFIX)

profile: build
	@echo 'Trillian/Dino local development build complete.'
	@echo 'Build directory: $(BUILD)'
	@echo 'No privileged system installation is performed by this target.'

clean:
	rm -rf $(BUILD)

uninstall:
	@echo 'No automatic uninstall is provided; use the installation manifest/package manager for installed files.'
