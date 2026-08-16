#include <sys/time.h>
#include <sys/types.h>
#include <sys/select.h>
#include <unistd.h>
#include <string.h>
#include <stdio.h>

int main() {
  fd_set f;
  struct timespec ts;
  FD_ZERO(&f);
  ts.tv_sec=2; ts.tv_nsec=0;
  if (pselect(1,&f,0,0,&ts,NULL)==-1) {
    perror("pselect");
    return 1;
  }
  return 0;
}
