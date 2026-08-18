#  Description: Use make as buildsystem instead of Gradle to
#  avoid a circular dependencies between gradle and native-platform.
#  This is very minimalistic Makefile so it will only work for
#  Debian use case for now.
#  Author: Damien Raude-Morvan <drazzib@debian.org>
#  Adapted for Fedora by: gil cattaneo <puntogil@libero.it>
include /usr/share/dpkg/architecture.mk

JAVA_HOME ?= /usr/lib/jvm/default-java
JAVA_TARGET_VERSION = 1.7
JAVA_SOURCE_VERSION = 1.7
BUILD_DIR = debian/out

CPPFLAGS += -Isrc/shared/headers \
            -I/usr/include \
            -I$(BUILD_DIR) \
            -I$(JAVA_HOME)/include \
            -I$(JAVA_HOME)/include/linux
ifeq ($(DEB_HOST_ARCH_OS),linux)
  CPPFLAGS += -D_FILE_OFFSET_BITS=64
endif

MAIN_CXX_SRC = $(shell find src/main/cpp -name "*.cpp" -print) \
               $(shell find src/shared/cpp -name "*.cpp" -print)
CURSES_CXX_SRC = $(shell find src/curses/cpp -name "*.cpp" -print) \
                 $(shell find src/shared/cpp -name "*.cpp" -print)
JAVA_SRC = $(shell find src/main/java -name "*.java" -print) \
           debian/additionalSrc/PosixFile.java
JAVA_WITH_INTERNAL_SRC = $(shell find src/main/java -name "*.java" -print)

.PHONY: clean javadoc build

build: $(BUILD_DIR)/libnative-platform.so $(BUILD_DIR)/libnative-platform-curses.so $(BUILD_DIR)/native-platform.jar javadoc

$(BUILD_DIR)/libnative-platform.so: $(MAIN_CXX_SRC) $(BUILD_DIR)/classes/%.class
	$(CXX) -shared $(CXXFLAGS) $(CPPFLAGS) $(LDFLAGS) -o $@ $(MAIN_CXX_SRC)

$(BUILD_DIR)/libnative-platform-curses.so: $(CURSES_CXX_SRC) $(BUILD_DIR)/classes/%.class
	# "-l*" options must be put at the end, thus fixing symbol errors in Ubuntu.
	$(CXX) -shared $(CXXFLAGS) $(CPPFLAGS) $(LDFLAGS) -o $@ $(CURSES_CXX_SRC) -lcurses

$(BUILD_DIR)/classes/%.class: $(JAVA_SRC)
	mkdir --parents $(BUILD_DIR)/classes
	javac -source $(JAVA_TARGET_VERSION) -target $(JAVA_SOURCE_VERSION) -encoding UTF-8 -d $(BUILD_DIR)/classes -h $(BUILD_DIR) $(JAVA_SRC)
	cat $(BUILD_DIR)/net*.h > $(BUILD_DIR)/native.h

javadoc: $(JAVA_WITH_INTERNAL_SRC)
	mkdir --parents $(BUILD_DIR)/javadoc
	javadoc -d $(BUILD_DIR)/javadoc -link file:///usr/share/doc/default-jdk/api $^

$(BUILD_DIR)/native-platform.jar: $(BUILD_DIR)/classes/%.class
	jar cf $@ -C $(BUILD_DIR)/classes .

clean:
	$(RM) -r $(BUILD_DIR)/javadoc $(BUILD_DIR)/classes
	$(RM) $(BUILD_DIR)/*.jar $(BUILD_DIR)/*.so $(BUILD_DIR)/native.h
