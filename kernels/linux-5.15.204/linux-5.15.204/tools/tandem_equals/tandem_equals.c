// SPDX-License-Identifier: GPL-2.0
/*
 * tandem_equals - Userspace interface for TandemEquals saimptom resolution
 *
 * Communicates with the kernel module via /proc/tandem_equals/ to help
 * users resolve outward dilemmas through the 42x42 choice matrix.
 *
 * In ~12 answers, the user's overconfidence is measured and the unkind
 * mono mind is flattened to reveal stereo choices and province wisdoms.
 *
 * Copyright (C) 2026 MEARVK LLC
 * Author: Maximilian Eric Alexander Rupplin von Keffikon
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

#define TE_PROC_STATUS   "/proc/tandem_equals/status"
#define TE_PROC_RESOLVE  "/proc/tandem_equals/resolve"
#define TE_PROC_RESULT   "/proc/tandem_equals/result"
#define TE_PROC_DOMAINS  "/proc/tandem_equals/domains"

static int cat_file(const char *path)
{
	FILE *f;
	char buf[4096];

	f = fopen(path, "r");
	if (!f) {
		fprintf(stderr, "tandem_equals: Cannot read %s: %s\n",
			path, strerror(errno));
		fprintf(stderr, "  (Is the tandem_equals kernel module loaded?)\n");
		return -1;
	}
	while (fgets(buf, sizeof(buf), f))
		fputs(buf, stdout);
	fclose(f);
	return 0;
}

static int write_proc(const char *path, const char *data)
{
	FILE *f;

	f = fopen(path, "w");
	if (!f) {
		fprintf(stderr, "tandem_equals: Cannot write %s: %s\n",
			path, strerror(errno));
		return -1;
	}
	fputs(data, f);
	fclose(f);
	return 0;
}


static void usage(const char *prog)
{
	printf("TandemEquals — Outward Dilemma Resolution via Saimptom\n\n");
	printf("A saimptom is merely a choice but not both ends obvious.\n");
	printf("In ~12 answers you regain stereo mind and see real choices.\n\n");
	printf("Usage:\n");
	printf("  %s --domain <name>     Begin with a choice domain\n", prog);
	printf("  %s --answer <value>    Provide answer (-1000 to 1000)\n", prog);
	printf("  %s --resolve           Force resolution now\n", prog);
	printf("  %s --result            Show choice + equal noise\n", prog);
	printf("  %s --status            Show current state\n", prog);
	printf("  %s --domains           List available domains\n", prog);
	printf("  %s --help              Show this help\n\n", prog);
	printf("Workflow:\n");
	printf("  1. Select domain:  %s --domain career\n", prog);
	printf("  2. Give answers:   %s --answer 300  (repeat 12x)\n", prog);
	printf("  3. Read result:    %s --result\n\n", prog);
	printf("Answer values:\n");
	printf("  +1000  = fully lean one direction\n");
	printf("  -1000  = fully lean the other direction\n");
	printf("      0  = genuine uncertainty (healthy stereo)\n\n");
	printf("After 12 answers, TandemEquals measures overconfidence,\n");
	printf("flattens the unkind mono mind, and reveals:\n");
	printf("  CHOICE = resolved direction\n");
	printf("  EQUAL NOISE = honest remaining ambiguity\n");
	printf("  PROVINCE WISDOM = your contextual truth\n");
}

int main(int argc, char *argv[])
{
	char cmd[128];

	if (argc < 2) {
		usage(argv[0]);
		return 1;
	}

	if (strcmp(argv[1], "--help") == 0 || strcmp(argv[1], "-h") == 0) {
		usage(argv[0]);
		return 0;
	}

	if (strcmp(argv[1], "--status") == 0)
		return cat_file(TE_PROC_STATUS);

	if (strcmp(argv[1], "--result") == 0)
		return cat_file(TE_PROC_RESULT);

	if (strcmp(argv[1], "--domains") == 0)
		return cat_file(TE_PROC_DOMAINS);

	if (strcmp(argv[1], "--domain") == 0) {
		if (argc < 3) {
			fprintf(stderr, "Usage: %s --domain <name>\n", argv[0]);
			return 1;
		}
		if (write_proc(TE_PROC_RESOLVE, argv[2]) != 0)
			return 1;
		printf("TandemEquals: Domain '%s' loaded.\n", argv[2]);
		printf("Now provide 12 answers: %s --answer <value>\n", argv[0]);
		printf("Values from -1000 (one end) to +1000 (other end).\n");
		printf("Zero = genuine uncertainty.\n");
		return 0;
	}

	if (strcmp(argv[1], "--answer") == 0) {
		if (argc < 3) {
			fprintf(stderr, "Usage: %s --answer <value>\n", argv[0]);
			return 1;
		}
		snprintf(cmd, sizeof(cmd), "answer %s", argv[2]);
		if (write_proc(TE_PROC_RESOLVE, cmd) != 0)
			return 1;
		printf("TandemEquals: Answer recorded.\n");
		/* Show brief status */
		return cat_file(TE_PROC_STATUS);
	}

	if (strcmp(argv[1], "--resolve") == 0) {
		if (write_proc(TE_PROC_RESOLVE, "resolve") != 0)
			return 1;
		printf("TandemEquals: Resolution computed.\n\n");
		return cat_file(TE_PROC_RESULT);
	}

	fprintf(stderr, "Unknown option: %s\n", argv[1]);
	fprintf(stderr, "Try: %s --help\n", argv[0]);
	return 1;
}
