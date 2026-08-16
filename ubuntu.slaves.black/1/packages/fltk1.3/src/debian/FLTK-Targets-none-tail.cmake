
# Don't enforce the existence of fluid when asked to skip it.
# (See https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=855040.)
if(FLTK_SKIP_FLUID)
  list(REMOVE_ITEM _IMPORT_CHECK_TARGETS fluid)
endif()
