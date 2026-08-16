#include "syscalls.h"
#if defined(__NR_socketcall) && !defined(__NR_accept4)

#include <linuxnet.h>

extern int socketcall(int callno,long* args);

int __libc_accept4(int a, void * addr, void * addr2, int flags);

int __libc_accept4(int a, void * addr, void * addr2, int flags) {
  long args[] = { a, (long) addr, (long) addr2, flags };
  return socketcall(SYS_ACCEPT4, args);
}

int accept4(int a, void * addr, void * addr2, int flags) __attribute__((weak,alias("__libc_accept4")));

#endif
