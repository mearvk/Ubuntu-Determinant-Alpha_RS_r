#include <string.h>
#include <errno.h>

int main()
{
  errno = ENOENT;
  return strcmp(strerror(errno), "No such file or directory") == 0 ? 0 : 1;
}
