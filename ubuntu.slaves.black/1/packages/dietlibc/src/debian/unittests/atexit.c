#include <stdlib.h>
#include <unistd.h>

void e(void) { _exit(0); }
int main()
{
  atexit(e);
  return 1;
}
