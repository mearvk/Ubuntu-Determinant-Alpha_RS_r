#include <sys/stat.h>
#include <stdio.h>
#include <errno.h>

int main()
{
  const char *fn1 = "/__dietlibc__/__doesnt__/__exist__";
  const char *fn2 = "/";
  struct stat st;
  int r;

  r = stat(fn1, &st);
  if (r == 0) {
    fprintf(stderr, "error: stat(\"%s\") was successful.\n", fn1);
    return 1;
  }
  if (errno != ENOENT) {
    fprintf(stderr, "error: stat(\"%s\") didn't set errno == ENOENT, got %m instead\n", fn1);
    return 1;
  }

  r = stat(fn2, &st);
  if (r < 0) {
    fprintf(stderr, "error: stat(\"%s\") didn't succeed: %m\n", fn2);
    return 1;
  }

  if (!S_ISDIR(st.st_mode)) {
    fprintf(stderr, "error: stat(\"%s\") doesn't seem to think it's a directory\n", fn2);
    return 1;
  }

  return 0;
}
