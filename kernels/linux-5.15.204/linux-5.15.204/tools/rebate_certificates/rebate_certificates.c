// SPDX-License-Identifier: GPL-2.0
/* rebate_certificates - Userspace tool for RebateCertificates VIII
 * Copyright (C) 2026 MEARVK LLC */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

#define RC_PROC_STATUS "/proc/rebate_certificates/status"
#define RC_PROC_FEED   "/proc/rebate_certificates/feed"

static int cat_file(const char *p) {
	FILE *f; char b[4096];
	f = fopen(p, "r");
	if (!f) { fprintf(stderr, "rc8: Cannot read %s: %s\n", p, strerror(errno)); return -1; }
	while (fgets(b, sizeof(b), f)) fputs(b, stdout);
	fclose(f); return 0;
}
static int write_proc(const char *p, const char *d) {
	FILE *f;
	f = fopen(p, "w");
	if (!f) { fprintf(stderr, "rc8: Cannot write %s: %s\n", p, strerror(errno)); return -1; }
	fputs(d, f); fclose(f); return 0;
}
static void usage(const char *prog) {
	printf("RebateCertificates VIII (TM)\n");
	printf("Longs as Unnecessaries | Moral Equations | Save Me\n\n");
	printf("Usage:\n");
	printf("  %s --feed-te <choice> <noise> <overconf>\n", prog);
	printf("  %s --feed-pg3 <score>\n", prog);
	printf("  %s --feed-pg4 <fwd_score> <ready> <replacements>\n", prog);
	printf("  %s --scan          Run full scan + moral check + rebate\n", prog);
	printf("  %s --status        Show results and certificates\n", prog);
	printf("  %s --help\n\n", prog);
	printf("Cost model: 2.25x standard lifetime INT. No reciprocation.\n");
	printf("Durham NC 3.42 norm (342 units/day species cap).\n");
	printf("Natural patterns only (adult intelligence floor).\n");
	printf("Save Me: activated when unnecessary longs are rebated.\n");
}
int main(int argc, char *argv[]) {
	char cmd[256];
	if (argc < 2) { usage(argv[0]); return 1; }
	if (strcmp(argv[1], "--help") == 0) { usage(argv[0]); return 0; }
	if (strcmp(argv[1], "--status") == 0) return cat_file(RC_PROC_STATUS);
	if (strcmp(argv[1], "--feed-te") == 0 && argc >= 5) {
		snprintf(cmd, sizeof(cmd), "te %s %s %s", argv[2], argv[3], argv[4]);
		return write_proc(RC_PROC_FEED, cmd) == 0 ? 0 : 1;
	}
	if (strcmp(argv[1], "--feed-pg3") == 0 && argc >= 3) {
		snprintf(cmd, sizeof(cmd), "pg3 %s", argv[2]);
		return write_proc(RC_PROC_FEED, cmd) == 0 ? 0 : 1;
	}
	if (strcmp(argv[1], "--feed-pg4") == 0 && argc >= 5) {
		snprintf(cmd, sizeof(cmd), "pg4 %s %s %s", argv[2], argv[3], argv[4]);
		return write_proc(RC_PROC_FEED, cmd) == 0 ? 0 : 1;
	}
	if (strcmp(argv[1], "--scan") == 0) {
		if (write_proc(RC_PROC_FEED, "scan") != 0) return 1;
		printf("RebateCertificates VIII: Scan complete.\n\n");
		return cat_file(RC_PROC_STATUS);
	}
	fprintf(stderr, "Unknown: %s\n", argv[1]); return 1;
}
