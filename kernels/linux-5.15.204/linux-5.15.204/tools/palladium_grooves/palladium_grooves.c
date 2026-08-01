// SPDX-License-Identifier: GPL-2.0
/*
 * palladium_grooves - Userspace interface for PalladiumGrooves III
 *
 * Feeds TandemEquals output into the PalladiumGrooves III kernel module
 * and displays social characterizability scoring (-50 to +50).
 *
 * Copyright (C) 2026 MEARVK LLC
 * Author: Maximilian Eric Alexander Rupplin von Keffikon
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

#define PG_PROC_STATUS "/proc/palladium_grooves/status"
#define PG_PROC_FEED   "/proc/palladium_grooves/feed"

static int cat_file(const char *path)
{
	FILE *f;
	char buf[4096];

	f = fopen(path, "r");
	if (!f) {
		fprintf(stderr, "palladium_grooves: Cannot read %s: %s\n",
			path, strerror(errno));
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
		fprintf(stderr, "palladium_grooves: Cannot write %s: %s\n",
			path, strerror(errno));
		return -1;
	}
	fputs(data, f);
	fclose(f);
	return 0;
}


static void usage(const char *prog)
{
	printf("PalladiumGrooves III (TM) — Social Characterizability\n\n");
	printf("Sits in Pi ratio to TandemEquals. Catches output from the\n");
	printf("first module and scores outward social characterizability.\n\n");
	printf("Score range: -50 to +50\n");
	printf("  +50       Block perfect (hard to realize)\n");
	printf("  +20..+40  IDEAL (socially legible, room for growth)\n");
	printf("    0       Neutral\n");
	printf("  -20..-40  Opaque (hard to predict)\n");
	printf("  -50       Social stranger to all known futures\n\n");
	printf("Usage:\n");
	printf("  %s --feed <choice> <noise> <overconf> [stereo]\n", prog);
	printf("                         Feed TandemEquals data\n");
	printf("  %s --score              Compute characterizability\n", prog);
	printf("  %s --status             Show grooves and score\n", prog);
	printf("  %s --help               Show this help\n\n", prog);
	printf("Example (after TandemEquals resolves):\n");
	printf("  %s --feed 700 300 200 1\n", prog);
	printf("  %s --score\n", prog);
	printf("  %s --status\n\n", prog);
	printf("The kernel module catches TandemEquals output automatically\n");
	printf("when both modules are loaded. This tool is for manual feeding.\n");
}

int main(int argc, char *argv[])
{
	char cmd[256];

	if (argc < 2) {
		usage(argv[0]);
		return 1;
	}

	if (strcmp(argv[1], "--help") == 0 || strcmp(argv[1], "-h") == 0) {
		usage(argv[0]);
		return 0;
	}

	if (strcmp(argv[1], "--status") == 0)
		return cat_file(PG_PROC_STATUS);

	if (strcmp(argv[1], "--score") == 0) {
		if (write_proc(PG_PROC_FEED, "score") != 0)
			return 1;
		printf("PalladiumGrooves III: Score computed.\n\n");
		return cat_file(PG_PROC_STATUS);
	}

	if (strcmp(argv[1], "--feed") == 0) {
		if (argc < 5) {
			fprintf(stderr, "Usage: %s --feed <choice> <noise> <overconf> [stereo]\n",
				argv[0]);
			return 1;
		}
		snprintf(cmd, sizeof(cmd), "tandem %s %s %s %s",
			 argv[2], argv[3], argv[4],
			 argc >= 6 ? argv[5] : "0");
		if (write_proc(PG_PROC_FEED, cmd) != 0)
			return 1;
		printf("PalladiumGrooves III: TandemEquals data received.\n");
		printf("Run '%s --score' to compute characterizability.\n", argv[0]);
		return 0;
	}

	fprintf(stderr, "Unknown option: %s\nTry: %s --help\n",
		argv[1], argv[0]);
	return 1;
}
