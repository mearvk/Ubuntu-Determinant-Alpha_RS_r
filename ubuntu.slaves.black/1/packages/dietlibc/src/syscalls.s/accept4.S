#include "syscalls.h"

#ifdef __NR_accept4
syscall_weak(accept4,accept4,__libc_accept4)
#endif
