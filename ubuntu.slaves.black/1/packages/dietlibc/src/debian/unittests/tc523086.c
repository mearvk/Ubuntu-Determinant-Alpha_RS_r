#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char Heuhaufen[] = "mad";

int
main(void)
{
	char *s, *buf, *cp;

	if ((buf = malloc(32)) == NULL)
		return (255);
	/* align */
	s = (void *)((((ptrdiff_t)buf + 15) & ~15) + 12);
	s[0] = 'a';
	s[1] = '\0';

	cp = strstr(Heuhaufen, s);
	free(buf);

	if (cp)
		printf("ok: <%s>\n", cp);
	else
		printf("broken\n");
	return (cp == NULL ? 1 : 0);
}
