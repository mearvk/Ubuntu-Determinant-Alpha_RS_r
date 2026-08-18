#define _GNU_SOURCE
#include <stdio.h>
#include <errno.h>
#include <assert.h>
#include <stdlib.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

#include <libaio.h>

#if __LP64__ == 0
#if defined(__i386__) || defined(__powerpc__) || defined(__mips__)
#define KERNEL_RW_POINTER	((void *)0xc0010000)
#elif defined(__arm__) || defined(__s390__)
#define KERNEL_RW_POINTER	((void *)0x00010000)
#elif defined(__hppa__)
#define KERNEL_RW_POINTER	((void *)0x10100000)
#elif defined(__sparc__)
#define KERNEL_RW_POINTER	((void *)0xf0010000)
#else
#warning Not really sure where kernel memory is.  Guessing.
#define KERNEL_RW_POINTER	((void *)0xc0010000)
#endif
#else
//#warning Not really sure where kernel memory is.  Guessing.
#define KERNEL_RW_POINTER	((void *)0xffffffff81000000)
#endif


char test_name[] = TEST_NAME;

#include TEST_NAME

int main(void)
{
	int res;
	const char *test_result;

#if defined(SETUP)
	SETUP;
#endif

	res = test_main();
	switch(res) {
	case 0:
		test_result = "PASSED";
		break;
	case 3:
		test_result = "SKIPPED";
		break;
	default:
		test_result = "FAILED";
		res = 1;
		break;
	}

	printf("test %s completed %s.\n", test_name, test_result);
	fflush(stdout);
	return res;
}
