# Determine the original CFLAGS dietlibc would want to use on
# this architecture.
include Makefile

print_orig_dietlibc_cflags:
	@echo $(CFLAGS)
