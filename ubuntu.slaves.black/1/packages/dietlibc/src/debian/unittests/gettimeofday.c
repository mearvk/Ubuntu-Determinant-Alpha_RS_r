#include <sys/time.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>

/*
 * This test is designed to detect if the structure layout of
 * gettimeofday matches the kernel's layout. First we initialize an
 * empty struct with 0xff, and then run call gettimeofday. We check
 * that the padding around the struct wasn't influenced by the kernel
 * call, and we check that tv_sec and tv_usec are reasonable. As we
 * set the entire structure to 0xff, this should cause an error.
 */

/* Sanity check for the time stamp, we expect them to be in this range.
 * We stick to the 32bit range to avoid the Y2038 issue. Once we come
 * closer to that, 32bit time_t have hopefully died out and we can use
 * something like Y2200 or so. (Assuming this code is still relevant
 * at that point.) */
const time_t y2000_utc =  946684800;
const time_t y2038_utc = 2145916800;

int main()
{
  struct {
    char pad_before[16];
    struct timeval tv;
    char pad_after[16];
  } p;
  char expected_padding[16];
  int r;

  memset(&p, 0xff, sizeof(p));
  memset(expected_padding, 0xff, sizeof(expected_padding));

  r = gettimeofday(&p.tv, NULL);
  if (r < 0) {
    perror("gettimeofday");
    return 1;
  }

  if (p.tv.tv_sec < y2000_utc || p.tv.tv_sec > y2038_utc) {
    fprintf(stderr, "tv.tv_sec = %lld not in range (Y2000, Y2038)\n", (long long)p.tv.tv_sec);
    return 2;
  }
  if (p.tv.tv_usec < 0 || p.tv.tv_usec >= 1000000) {
    fprintf(stderr, "tv.tv_usec = %ld not in range (0, 999999)\n", (long)p.tv.tv_usec);
    return 2;
  }
  if (memcmp(p.pad_before, expected_padding, 16) != 0) {
    fprintf(stderr, "padding before was modified by syscall\n");
    return 3;
  }
  if (memcmp(p.pad_after, expected_padding, 16) != 0) {
    fprintf(stderr, "padding after was modified by syscall\n");
    return 4;
  }

  return 0;
}
