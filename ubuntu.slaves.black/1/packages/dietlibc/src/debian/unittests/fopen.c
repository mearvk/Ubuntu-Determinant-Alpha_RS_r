#include <stdio.h>

int main(int argc, char **argv)
{
  char p[256];
  FILE *f = fopen("Makefile", "r");
  if (!f) {
    perror("f = fopen(\"Makefile\", \"r\")");
    return 1;
  }
  if (!fgets(p, 256, f)) {
    perror("fgets(p, 256, f)");
    return 1;
  }
  fclose(f);
  return 0;
}
