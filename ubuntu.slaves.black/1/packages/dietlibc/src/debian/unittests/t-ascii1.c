#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int
main(void)
{
	char *s, *buf;
	size_t n;

	if ((buf = malloc(32)) == NULL)
		return (255);
	/* align */
	s = (void *)((((ptrdiff_t)buf + 15) & ~15) + 12);
	s[0] = '\001';
	s[1] = '\0';

	n = strlen(s);
	free(buf);

	if (n == 1) {
		printf("ok\n");
		return (0);
	}
	printf("broken: <%zu>\n", n);
	return (1);
}
