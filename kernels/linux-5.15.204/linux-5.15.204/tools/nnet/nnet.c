// SPDX-License-Identifier: GPL-2.0
/*
 * nnet.c - User Identity & Nobility Space Query Tool
 *
 * Provides 'nnet' (query own profile) and 'nnot USERNAME' (query other
 * profiles) commands for local users. Reads from per-user identity files
 * stored in /var/lib/nnet/<username>/.
 *
 * Each user has a "hobby hole" — a small RAM-backed identity space (4-44MB)
 * that grows with their adequacy and functional tenure. Contains:
 *   - IQ rank
 *   - Ethical rank
 *   - Years worked
 *   - Importances / keys
 *   - Noble RAM space allocation
 *   - System role and functionary grade
 *
 * Usage:
 *   nnet              - Show own profile (logged-in user)
 *   nnot USERNAME     - Show another user's profile (local access only)
 *
 * The data directory /var/lib/nnet/ is structured:
 *   /var/lib/nnet/mearvk/identity
 *   /var/lib/nnet/mearvk/keys
 *   /var/lib/nnet/mearvk/rank
 *   /var/lib/nnet/admin/identity
 *   ...
 *
 * Also queryable by:
 *   cd /var/lib/nnet/<username>
 *   cat identity
 *   cat rank
 *   cat keys
 *
 * Root installers (TechIDs) are stored in kernel-adjacent space:
 *   /var/lib/nnet/.installers/techid_mearvk_installer_tech_2
 *   /var/lib/nnet/.installers/techid_mearvk_state_medical_ref
 *
 * Copyright (C) 2026 MEARVK LLC
 * Author: Maximilian Eric Alexander Rupplin von Keffikon
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <pwd.h>
#include <dirent.h>
#include <errno.h>

#define NNET_BASE_DIR		"/var/lib/nnet"
#define NNET_INSTALLER_DIR	"/var/lib/nnet/.installers"
#define NNET_MAX_FILE_SIZE	(44 * 1024 * 1024)  /* 44MB max per user */
#define NNET_LINE_MAX		4096

/* ============================================================
 * Display Helpers
 * ============================================================ */

static void print_separator(void)
{
	printf("════════════════════════════════════════════════════════════════\n");
}

static void print_header(const char *username)
{
	printf("\n");
	print_separator();
	printf("  NNET — User Identity & Nobility Space\n");
	printf("  Profile: %s\n", username);
	print_separator();
	printf("\n");
}

static void print_file(const char *path, const char *label)
{
	FILE *f;
	char line[NNET_LINE_MAX];

	f = fopen(path, "r");
	if (!f)
		return;

	if (label)
		printf("  ┌─ %s\n", label);

	while (fgets(line, sizeof(line), f)) {
		/* Strip trailing newline for clean display */
		size_t len = strlen(line);
		if (len > 0 && line[len - 1] == '\n')
			line[len - 1] = '\0';
		printf("  │ %s\n", line);
	}
	printf("  └────────────────────────────────────\n\n");
	fclose(f);
}

/* ============================================================
 * Profile Display
 * ============================================================ */

static int show_profile(const char *username)
{
	char path[512];
	struct stat st;

	/* Check if user directory exists */
	snprintf(path, sizeof(path), "%s/%s", NNET_BASE_DIR, username);
	if (stat(path, &st) != 0 || !S_ISDIR(st.st_mode)) {
		fprintf(stderr, "nnet: No profile found for '%s'\n", username);
		fprintf(stderr, "      Expected at: %s\n", path);
		return 1;
	}

	print_header(username);

	/* Display identity */
	snprintf(path, sizeof(path), "%s/%s/identity", NNET_BASE_DIR, username);
	print_file(path, "Identity");

	/* Display rank */
	snprintf(path, sizeof(path), "%s/%s/rank", NNET_BASE_DIR, username);
	print_file(path, "Rank & Metrics");

	/* Display keys/importances */
	snprintf(path, sizeof(path), "%s/%s/keys", NNET_BASE_DIR, username);
	print_file(path, "Keys & Importances");

	/* Display RAM allocation */
	snprintf(path, sizeof(path), "%s/%s/ramspace", NNET_BASE_DIR, username);
	print_file(path, "Noble RAM Space");

	/* Display functional notes */
	snprintf(path, sizeof(path), "%s/%s/notes", NNET_BASE_DIR, username);
	if (stat(path, &st) == 0)
		print_file(path, "Notes");

	print_separator();
	printf("\n");

	return 0;
}

/* ============================================================
 * Installer TechID Display
 * ============================================================ */

static void show_installers(void)
{
	DIR *dir;
	struct dirent *ent;
	char path[512];

	dir = opendir(NNET_INSTALLER_DIR);
	if (!dir)
		return;

	printf("  ┌─ Root Installers (TechIDs)\n");

	while ((ent = readdir(dir)) != NULL) {
		if (ent->d_name[0] == '.')
			continue;
		snprintf(path, sizeof(path), "%s/%s",
			 NNET_INSTALLER_DIR, ent->d_name);

		FILE *f = fopen(path, "r");
		if (f) {
			char line[NNET_LINE_MAX];
			printf("  │\n");
			printf("  │ [%s]\n", ent->d_name);
			while (fgets(line, sizeof(line), f)) {
				size_t len = strlen(line);
				if (len > 0 && line[len - 1] == '\n')
					line[len - 1] = '\0';
				printf("  │   %s\n", line);
			}
			fclose(f);
		}
	}
	printf("  └────────────────────────────────────\n\n");
	closedir(dir);
}

/* ============================================================
 * Main
 * ============================================================ */

int main(int argc, char *argv[])
{
	const char *target_user;
	struct passwd *pw;

	if (argc == 1) {
		/* nnet: show own profile */
		pw = getpwuid(getuid());
		if (!pw) {
			fprintf(stderr, "nnet: Cannot determine current user\n");
			return 1;
		}
		target_user = pw->pw_name;
	} else if (argc == 2) {
		/* nnet USERNAME or nnot USERNAME */
		target_user = argv[1];
	} else {
		fprintf(stderr, "Usage: nnet [USERNAME]\n");
		fprintf(stderr, "       nnot USERNAME\n");
		return 1;
	}

	/* Local users only */
	if (getpwnam(target_user) == NULL) {
		fprintf(stderr, "nnet: User '%s' not found on this system\n",
			target_user);
		return 1;
	}

	int ret = show_profile(target_user);

	/* If querying own profile, also show installers */
	if (argc == 1 || strcmp(target_user, "mearvk") == 0)
		show_installers();

	return ret;
}
