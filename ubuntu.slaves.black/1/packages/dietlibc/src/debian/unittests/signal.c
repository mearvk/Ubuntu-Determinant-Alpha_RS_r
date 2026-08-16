#include <signal.h>
#include <unistd.h>
#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <time.h>

/*
 * This test is designed to make sure that signal handlers work as
 * expected. We need to make sure they are run when required, so we
 * register a SIGCHLD handler and fork off a process that immediately
 * terminates. The signal handler sets a flag that is checked from the
 * main function to verify that the handler was run properly. This
 * should catch cases where the signal return trampoline misbehaves in
 * some way or another, which has happened before.
 */

volatile int had_sigchld = 0;

void handle_sigchld(int signum)
{
  had_sigchld = 1;
}

int main()
{
  struct sigaction action;
  int r;
  pid_t pid, w;

  memset(&action, 0, sizeof(action));
  action.sa_handler = &handle_sigchld;
  r = sigaction(SIGCHLD, &action, NULL);
  if (r < 0) {
    perror("sigaction");
    return 1;
  }

  pid = fork();
  if (pid < 0) {
    perror("fork");
    return 2;
  }

  if (pid == 0)
    return 0;

  w = waitpid(pid, &r, 0);
  if (w == -1) {
    perror("waitpid");
    return 3;
  }

  if (!WIFEXITED(r)) {
    fputs("waitpid: child process didn't exit normally\n", stderr);
    return 4;
  }
  if (WEXITSTATUS(r)) {
    fputs("waitpid: child process didn't exit normally\n", stderr);
    return 5;
  }

  if (!had_sigchld) {
    struct timespec req;
    req.tv_sec = 0;
    req.tv_nsec = 100 * 1000 * 1000;
    nanosleep(&req, NULL);
    if (!had_sigchld) {
      fputs("SIGCHLD handler apparently not run (?)\n", stderr);
      return 6;
    }
  }

  return 0;
}
