#include <sys/types.h>
#include <sys/wait.h>

pid_t __libc_waitpid(pid_t pid, int * wait_stat, int flags);
pid_t __libc_waitpid(pid_t pid, int * wait_stat, int flags) {
  return wait4(pid, wait_stat, flags, 0);
}

pid_t waitpid(pid_t pid, int * wait_stat, int flags)
__attribute__((weak,alias("__libc_waitpid")));
