// SPDX-License-Identifier: GPL-2.0
/*
 * palladium_grooves_iv - Userspace tool for PalladiumGrooves IV Mill Matter
 * Copyright (C) 2026 MEARVK LLC
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

#define PG4_PROC_STATUS "/proc/palladium_grooves_iv/status"
#define PG4_PROC_FEED   "/proc/palladium_grooves_iv/feed"

static int cat_file(const char *path)
{
	FILE *f;
	char buf[4096];
	f = fopen(path, "r");
	if (!f) { fprintf(stderr, "pg4: Cannot read %s: %s\n", path, strerror(errno)); return -1; }
	while (fgets(buf, sizeof(buf), f)) fputs(buf, stdout);
	fclose(f);
	return 0;
}

static int write_proc(const char *path, const char *data)
{
	FILE *f;
	f = fopen(path, "w");
	if (!f) { fprintf(stderr, "pg4: Cannot write %s: %s\n", path, strerror(errno)); return -1; }
	fputs(data, f);
	fclose(f);
	return 0;
}

static void usage(const char *prog)
{
	printf("PalladiumGrooves IV (TM) — Mill Matter\n");
	printf("INT Advantages | Replacement of Similars\n\n");
	printf("Catches under both TandemEquals and PalladiumGrooves III.\n\n");
	printf("Usage:\n");
	printf("  %s --feed-te <choice> <noise> <overconf>\n", prog);
	printf("  %s --feed-pg3 <score> <social> <predict>\n", prog);
	printf("  %s --mill           Run the mill (ingest/identify/replace/forward)\n", prog);
	printf("  %s --status         Show mill state and forward vector\n", prog);
	printf("  %s --help           Show this help\n\n", prog);
	printf("Workflow:\n");
	printf("  1. Feed TandemEquals output\n");
	printf("  2. Feed PalladiumGrooves III output\n");
	printf("  3. Run the mill\n");
	printf("  4. Read forward vector and INT advantages\n");
}

int main(int argc, char *argv[])
{
	char cmd[256];

	if (argc < 2) { usage(argv[0]); return 1; }
	if (strcmp(argv[1], "--help") == 0) { usage(argv[0]); return 0; }
	if (strcmp(argv[1], "--status") == 0) return cat_file(PG4_PROC_STATUS);

	if (strcmp(argv[1], "--feed-te") == 0) {
		if (argc < 5) { fprintf(stderr, "Need: <choice> <noise> <overconf>\n"); return 1; }
		snprintf(cmd, sizeof(cmd), "te %s %s %s", argv[2], argv[3], argv[4]);
		if (write_proc(PG4_PROC_FEED, cmd) != 0) return 1;
		printf("PG4: TandemEquals data received.\n");
		return 0;
	}
	if (strcmp(argv[1], "--feed-pg3") == 0) {
		if (argc < 5) { fprintf(stderr, "Need: <score> <social> <predict>\n"); return 1; }
		snprintf(cmd, sizeof(cmd), "pg3 %s %s %s", argv[2], argv[3], argv[4]);
		if (write_proc(PG4_PROC_FEED, cmd) != 0) return 1;
		printf("PG4: PalladiumGrooves III data received.\n");
		return 0;
	}
	if (strcmp(argv[1], "--mill") == 0) {
		if (write_proc(PG4_PROC_FEED, "mill") != 0) return 1;
		printf("PG4: Mill complete.\n\n");
		return cat_file(PG4_PROC_STATUS);
	}

	fprintf(stderr, "Unknown: %s\nTry --help\n", argv[1]);
	return 1;
}
