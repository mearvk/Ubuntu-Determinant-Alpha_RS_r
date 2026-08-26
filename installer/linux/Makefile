.PHONY: all clean install uninstall install-user-bin install-user-runnables install-usr-bin install-usr-runnables install-deck-bin install-deck-runnables update-path

CC ?= cc
CFLAGS ?= -std=c11 -O2 -Wall -Wextra -Wpedantic
TARGET := desktop_install_probe
SRC := desktop_install_probe.c

USER_ROOT ?= /user
USR_ROOT ?= /usr
DECK_ROOT ?= /deck
INSTALL_CHOICE ?= user-bin

USER_BIN := $(USER_ROOT)/bin
USER_RUNNABLES := $(USER_ROOT)/runnables
USR_BIN := $(USR_ROOT)/bin
USR_RUNNABLES := $(USR_ROOT)/runnables
DECK_BIN := $(DECK_ROOT)/bin
DECK_RUNNABLES := $(DECK_ROOT)/runnables

all: $(TARGET)

$(TARGET): $(SRC) desktop_install_probe.h
	$(CC) $(CFLAGS) -o $@ $(SRC)

install: $(TARGET)
	@case "$(INSTALL_CHOICE)" in \
		user-bin) $(MAKE) install-user-bin ;; \
		user-runnables) $(MAKE) install-user-runnables ;; \
		*) echo "Usage: make install [INSTALL_CHOICE=user-bin|user-runnables]" >&2; exit 2 ;; \
	esac

install-user-bin: $(TARGET)
	install -d $(USER_BIN)
	install -m 0755 $(TARGET) $(USER_BIN)/$(TARGET)
	@$(MAKE) update-path DIR=$(USER_BIN)

install-user-runnables: $(TARGET)
	install -d $(USER_RUNNABLES)
	install -m 0755 $(TARGET) $(USER_RUNNABLES)/$(TARGET)
	@$(MAKE) update-path DIR=$(USER_RUNNABLES)

install-usr-bin: $(TARGET)
	install -d $(USR_BIN)
	install -m 0755 $(TARGET) $(USR_BIN)/$(TARGET)

install-usr-runnables: $(TARGET)
	install -d $(USR_RUNNABLES)
	install -m 0755 $(TARGET) $(USR_RUNNABLES)/$(TARGET)

install-deck-bin: $(TARGET)
	install -d $(DECK_BIN)
	install -m 0755 $(TARGET) $(DECK_BIN)/$(TARGET)

install-deck-runnables: $(TARGET)
	install -d $(DECK_RUNNABLES)
	install -m 0755 $(TARGET) $(DECK_RUNNABLES)/$(TARGET)

update-path:
	@if [ -n "$(DIR)" ] && [ -n "$$HOME" ]; then \
		profile="$$HOME/.profile"; \
		path_line='export PATH="$(DIR):$$PATH"'; \
		if ! grep -Fq '$(DIR)' "$$profile" 2>/dev/null; then \
			echo '' >> "$$profile"; \
			echo '# Ubuntu Determinant installer path' >> "$$profile"; \
			echo "$$path_line" >> "$$profile"; \
			echo "[ok] added $(DIR) to $$profile"; \
		else \
			echo "[ok] $(DIR) is already in $$profile"; \
		fi; \
	fi

clean:
	rm -f $(TARGET)

uninstall:
	rm -f $(USER_BIN)/$(TARGET) $(USER_RUNNABLES)/$(TARGET) \
	      $(USR_BIN)/$(TARGET) $(USR_RUNNABLES)/$(TARGET) \
	      $(DECK_BIN)/$(TARGET) $(DECK_RUNNABLES)/$(TARGET)
