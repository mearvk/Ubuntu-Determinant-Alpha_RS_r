# -*- makefile-gmake -*-
# Configuration variables describing the GNUstep paths

GS_USE_FHS 	:= yes

GS_MAKE_DIR	:= /usr/share/GNUstep/Makefiles

include /usr/share/GNUstep/Makefiles/filesystem.make
export GNUSTEP_MAKEFILES := $(GS_MAKE_DIR)
export GNUSTEP_INSTALLATION_DOMAIN := SYSTEM

# Optimization is handled automatically by debhelper but
# gnustep-make's debug=yes adds -DDEBUG -fno-omit-frame-pointer.
ifndef optim
ifneq (,$(findstring noopt,$(DEB_BUILD_OPTIONS)))
optim := debug=yes
endif
endif

# Support for "terse" in DEB_BUILD_OPTIONS (Policy §4.9.1).
ifndef verbose
ifeq (,$(findstring terse,$(DEB_BUILD_OPTIONS)))
verbose := messages=yes
endif
endif
