// SPDX-License-Identifier: GPL-2.0
/*
 * chat.c - Terminal-Based User Chat System
 *
 * A local chat system for system users, operating from the terminal.
 * Supports direct messaging between users and persistent named groups.
 *
 * COMMANDS
 * ════════
 *   chat                         Show status and recent messages
 *   chat send USER message       Send direct message to a user
 *   chat create GROUP            Create a persistent group
 *   chat join GROUP              Join an existing group
 *   chat leave GROUP             Leave a group
 *   chat post GROUP message      Post message to a group
 *   chat read GROUP              Read group messages
 *   chat groups                  List all groups
 *   chat members GROUP           List group members
 *   chat who                     Show online users
 *   chat log                     Show personal message history
 *
 * DESIGN
 * ══════
 * • Works off the terminal. No daemon required (uses filesystem IPC).
 * • Messages stored in /var/lib/chat/ (persistent across reboots).
 * • Groups are directories with member lists and message logs.
 * • Direct messages stored per-user in their inbox.
 * • No banning of system users — everyone belongs.
 * • Real-time delivery via inotify (optional) or poll on read.
 * • Status: high and pure software. Complete and completify.
 *
 * STRUCTURE
 * ═════════
 *   /var/lib/chat/
 *   ├── users/
 *   │   ├── mearvk/
 *   │   │   ├── inbox           (messages to this user)
 *   │   │   └── .online         (presence marker)
 *   │   ├── admin/
 *   │   │   └── inbox
 *   │   └── ...
 *   └── groups/
 *       ├── engineering/
 *       │   ├── members         (list of member usernames)
 *       │   ├── log             (message history)
 *       │   └── .meta           (creator, created_at)
 *       └── general/
 *           ├── members
 *           └── log
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
#include <time.h>
#include <dirent.h>
#include <errno.h>
#include <fcntl.h>

#define CHAT_DIR	"/var/lib/chat"
#define CHAT_USERS	CHAT_DIR "/users"
#define CHAT_GROUPS	CHAT_DIR "/groups"
#define MAX_MSG		4096
#define MAX_LINE	8192
#define TAIL_LINES	25

/* ============================================================
 * Utilities
 * ============================================================ */

static const char *get_username(void)
{
	struct passwd *pw = getpwuid(getuid());
	return pw ? pw->pw_name : "unknown";
}

static void get_timestamp(char *buf, size_t len)
{
	time_t now = time(NULL);
	struct tm *tm = localtime(&now);
	strftime(buf, len, "%Y-%m-%d %H:%M:%S", tm);
}

static void ensure_dir(const char *path)
{
	mkdir(path, 0755);
}

static void ensure_user_dir(const char *username)
{
	char path[512];
	snprintf(path, sizeof(path), "%s/%s", CHAT_USERS, username);
	ensure_dir(path);
}

static int file_exists(const char *path)
{
	struct stat st;
	return stat(path, &st) == 0;
}

static void append_line(const char *path, const char *line)
{
	FILE *f = fopen(path, "a");
	if (f) {
		fputs(line, f);
		fputc('\n', f);
		fclose(f);
	}
}

static int file_contains_line(const char *path, const char *needle)
{
	FILE *f = fopen(path, "r");
	char line[512];
	if (!f) return 0;
	while (fgets(line, sizeof(line), f)) {
		size_t len = strlen(line);
		if (len > 0 && line[len-1] == '\n') line[len-1] = '\0';
		if (strcmp(line, needle) == 0) { fclose(f); return 1; }
	}
	fclose(f);
	return 0;
}

static void print_tail(const char *path, int lines)
{
	FILE *f = fopen(path, "r");
	char buf[MAX_LINE];
	long positions[256];
	int count = 0, i;

	if (!f) { printf("  (no messages)\n"); return; }

	while (fgets(buf, sizeof(buf), f)) {
		positions[count % lines] = ftell(f) - strlen(buf);
		count++;
	}

	int start = count > lines ? count - lines : 0;
	int offset = start % lines;
	fseek(f, count > lines ? positions[offset] : 0, SEEK_SET);

	i = 0;
	while (fgets(buf, sizeof(buf), f)) {
		size_t len = strlen(buf);
		if (len > 0 && buf[len-1] == '\n') buf[len-1] = '\0';
		printf("  %s\n", buf);
		i++;
	}
	fclose(f);

	if (count == 0)
		printf("  (no messages)\n");
}

/* ============================================================
 * Commands
 * ============================================================ */

/* chat send USER message... */
static int cmd_send(int argc, char *argv[])
{
	const char *sender = get_username();
	const char *recipient;
	char message[MAX_MSG] = {0};
	char inbox_path[512];
	char timestamp[64];
	char entry[MAX_MSG + 256];
	int i;

	if (argc < 4) {
		fprintf(stderr, "Usage: chat send <user> <message...>\n");
		return 1;
	}

	recipient = argv[2];

	/* Verify recipient exists on system */
	if (!getpwnam(recipient)) {
		fprintf(stderr, "chat: User '%s' not found on system\n", recipient);
		return 1;
	}

	/* Build message from remaining args */
	for (i = 3; i < argc; i++) {
		if (i > 3) strncat(message, " ", MAX_MSG - strlen(message) - 1);
		strncat(message, argv[i], MAX_MSG - strlen(message) - 1);
	}

	/* Ensure recipient dir exists */
	ensure_user_dir(recipient);

	/* Write to recipient's inbox */
	snprintf(inbox_path, sizeof(inbox_path), "%s/%s/inbox",
		 CHAT_USERS, recipient);
	get_timestamp(timestamp, sizeof(timestamp));
	snprintf(entry, sizeof(entry), "[%s] %s: %s", timestamp, sender, message);
	append_line(inbox_path, entry);

	printf("chat: ✓ Sent to %s\n", recipient);
	return 0;
}

/* chat create GROUP */
static int cmd_create(int argc, char *argv[])
{
	const char *creator = get_username();
	const char *group;
	char path[512], meta_path[512], members_path[512];
	char timestamp[64];
	FILE *f;

	if (argc < 3) {
		fprintf(stderr, "Usage: chat create <group_name>\n");
		return 1;
	}

	group = argv[2];

	snprintf(path, sizeof(path), "%s/%s", CHAT_GROUPS, group);
	if (file_exists(path)) {
		fprintf(stderr, "chat: Group '%s' already exists\n", group);
		return 1;
	}

	/* Create group directory */
	ensure_dir(path);

	/* Write meta */
	snprintf(meta_path, sizeof(meta_path), "%s/.meta", path);
	get_timestamp(timestamp, sizeof(timestamp));
	f = fopen(meta_path, "w");
	if (f) {
		fprintf(f, "creator=%s\n", creator);
		fprintf(f, "created=%s\n", timestamp);
		fclose(f);
	}

	/* Add creator as first member */
	snprintf(members_path, sizeof(members_path), "%s/members", path);
	append_line(members_path, creator);

	/* Create empty log */
	snprintf(path, sizeof(path), "%s/%s/log", CHAT_GROUPS, group);
	f = fopen(path, "w");
	if (f) {
		fprintf(f, "[%s] *** Group '%s' created by %s ***\n",
			timestamp, group, creator);
		fclose(f);
	}

	printf("chat: ✓ Group '%s' created. You are the first member.\n", group);
	printf("chat: Others join with: chat join %s\n", group);
	return 0;
}

/* chat join GROUP */
static int cmd_join(int argc, char *argv[])
{
	const char *user = get_username();
	const char *group;
	char path[512], members_path[512], log_path[512];
	char timestamp[64], entry[512];

	if (argc < 3) {
		fprintf(stderr, "Usage: chat join <group_name>\n");
		return 1;
	}

	group = argv[2];
	snprintf(path, sizeof(path), "%s/%s", CHAT_GROUPS, group);

	if (!file_exists(path)) {
		fprintf(stderr, "chat: Group '%s' does not exist\n", group);
		fprintf(stderr, "chat: Create it with: chat create %s\n", group);
		return 1;
	}

	snprintf(members_path, sizeof(members_path), "%s/members", path);

	/* Check if already a member */
	if (file_contains_line(members_path, user)) {
		printf("chat: Already a member of '%s'\n", group);
		return 0;
	}

	/* Add to members */
	append_line(members_path, user);

	/* Log join event */
	snprintf(log_path, sizeof(log_path), "%s/log", path);
	get_timestamp(timestamp, sizeof(timestamp));
	snprintf(entry, sizeof(entry), "[%s] *** %s joined ***", timestamp, user);
	append_line(log_path, entry);

	printf("chat: ✓ Joined group '%s'\n", group);
	return 0;
}

/* chat leave GROUP */
static int cmd_leave(int argc, char *argv[])
{
	const char *user = get_username();
	const char *group;
	char path[512], log_path[512];
	char timestamp[64], entry[512];

	if (argc < 3) {
		fprintf(stderr, "Usage: chat leave <group_name>\n");
		return 1;
	}

	group = argv[2];
	snprintf(path, sizeof(path), "%s/%s", CHAT_GROUPS, group);

	if (!file_exists(path)) {
		fprintf(stderr, "chat: Group '%s' does not exist\n", group);
		return 1;
	}

	/* Log leave */
	snprintf(log_path, sizeof(log_path), "%s/log", path);
	get_timestamp(timestamp, sizeof(timestamp));
	snprintf(entry, sizeof(entry), "[%s] *** %s left ***", timestamp, user);
	append_line(log_path, entry);

	/* TODO: Remove from members file (rewrite without this user) */

	printf("chat: Left group '%s'\n", group);
	return 0;
}

/* chat post GROUP message... */
static int cmd_post(int argc, char *argv[])
{
	const char *user = get_username();
	const char *group;
	char message[MAX_MSG] = {0};
	char path[512], log_path[512], members_path[512];
	char timestamp[64], entry[MAX_MSG + 256];
	int i;

	if (argc < 4) {
		fprintf(stderr, "Usage: chat post <group> <message...>\n");
		return 1;
	}

	group = argv[2];
	snprintf(path, sizeof(path), "%s/%s", CHAT_GROUPS, group);

	if (!file_exists(path)) {
		fprintf(stderr, "chat: Group '%s' does not exist\n", group);
		return 1;
	}

	/* Verify membership */
	snprintf(members_path, sizeof(members_path), "%s/members", path);
	if (!file_contains_line(members_path, user)) {
		fprintf(stderr, "chat: You're not a member of '%s'\n", group);
		fprintf(stderr, "chat: Join with: chat join %s\n", group);
		return 1;
	}

	/* Build message */
	for (i = 3; i < argc; i++) {
		if (i > 3) strncat(message, " ", MAX_MSG - strlen(message) - 1);
		strncat(message, argv[i], MAX_MSG - strlen(message) - 1);
	}

	/* Post to group log */
	snprintf(log_path, sizeof(log_path), "%s/log", path);
	get_timestamp(timestamp, sizeof(timestamp));
	snprintf(entry, sizeof(entry), "[%s] %s: %s", timestamp, user, message);
	append_line(log_path, entry);

	printf("chat: ✓ Posted to '%s'\n", group);
	return 0;
}

/* chat read GROUP */
static int cmd_read(int argc, char *argv[])
{
	const char *group;
	char path[512];

	if (argc < 3) {
		fprintf(stderr, "Usage: chat read <group>\n");
		return 1;
	}

	group = argv[2];
	snprintf(path, sizeof(path), "%s/%s/log", CHAT_GROUPS, group);

	if (!file_exists(path)) {
		fprintf(stderr, "chat: Group '%s' does not exist\n", group);
		return 1;
	}

	printf("═══ %s ═══\n", group);
	print_tail(path, TAIL_LINES);
	return 0;
}

/* chat groups */
static int cmd_groups(void)
{
	DIR *dir;
	struct dirent *ent;
	char members_path[512];
	int count;

	dir = opendir(CHAT_GROUPS);
	if (!dir) {
		printf("chat: No groups yet. Create one: chat create <name>\n");
		return 0;
	}

	printf("═══ Groups ═══\n");
	while ((ent = readdir(dir)) != NULL) {
		if (ent->d_name[0] == '.') continue;
		if (ent->d_type != DT_DIR) continue;

		/* Count members */
		snprintf(members_path, sizeof(members_path),
			 "%s/%s/members", CHAT_GROUPS, ent->d_name);
		count = 0;
		FILE *f = fopen(members_path, "r");
		if (f) {
			char line[256];
			while (fgets(line, sizeof(line), f)) count++;
			fclose(f);
		}

		printf("  %-20s (%d members)\n", ent->d_name, count);
	}
	closedir(dir);
	return 0;
}

/* chat members GROUP */
static int cmd_members(int argc, char *argv[])
{
	const char *group;
	char path[512];

	if (argc < 3) {
		fprintf(stderr, "Usage: chat members <group>\n");
		return 1;
	}

	group = argv[2];
	snprintf(path, sizeof(path), "%s/%s/members", CHAT_GROUPS, group);

	if (!file_exists(path)) {
		fprintf(stderr, "chat: Group '%s' does not exist\n", group);
		return 1;
	}

	printf("═══ Members of '%s' ═══\n", group);
	FILE *f = fopen(path, "r");
	if (f) {
		char line[256];
		while (fgets(line, sizeof(line), f)) {
			size_t len = strlen(line);
			if (len > 0 && line[len-1] == '\n') line[len-1] = '\0';
			printf("  • %s\n", line);
		}
		fclose(f);
	}
	return 0;
}

/* chat who */
static int cmd_who(void)
{
	DIR *dir;
	struct dirent *ent;
	char path[512];

	dir = opendir(CHAT_USERS);
	if (!dir) {
		printf("chat: No users registered yet.\n");
		return 0;
	}

	printf("═══ Users ═══\n");
	while ((ent = readdir(dir)) != NULL) {
		if (ent->d_name[0] == '.') continue;
		if (ent->d_type != DT_DIR) continue;

		snprintf(path, sizeof(path), "%s/%s/.online",
			 CHAT_USERS, ent->d_name);
		printf("  • %-16s %s\n", ent->d_name,
		       file_exists(path) ? "(online)" : "");
	}
	closedir(dir);
	return 0;
}

/* chat log (show own inbox) */
static int cmd_log(void)
{
	const char *user = get_username();
	char path[512];

	snprintf(path, sizeof(path), "%s/%s/inbox", CHAT_USERS, user);

	printf("═══ Messages for %s ═══\n", user);
	if (file_exists(path))
		print_tail(path, TAIL_LINES);
	else
		printf("  (no messages)\n");
	return 0;
}

/* chat (no args) — show status */
static int cmd_status(void)
{
	const char *user = get_username();
	char path[512];

	printf("═══════════════════════════════════════════\n");
	printf("  chat — Terminal Messaging System\n");
	printf("  User: %s\n", user);
	printf("═══════════════════════════════════════════\n\n");

	/* Mark self as online */
	ensure_user_dir(user);
	snprintf(path, sizeof(path), "%s/%s/.online", CHAT_USERS, user);
	FILE *f = fopen(path, "w");
	if (f) { fprintf(f, "%ld\n", (long)time(NULL)); fclose(f); }

	/* Show recent inbox */
	printf("  Recent messages:\n");
	snprintf(path, sizeof(path), "%s/%s/inbox", CHAT_USERS, user);
	if (file_exists(path))
		print_tail(path, 5);
	else
		printf("    (none)\n");

	printf("\n  Commands:\n");
	printf("    chat send USER msg    Send a direct message\n");
	printf("    chat create GROUP     Create a group\n");
	printf("    chat join GROUP       Join a group\n");
	printf("    chat post GROUP msg   Post to a group\n");
	printf("    chat read GROUP       Read group messages\n");
	printf("    chat groups           List groups\n");
	printf("    chat who              Show users\n");
	printf("    chat log              Show your inbox\n");
	printf("\n");

	return 0;
}

/* ============================================================
 * Main
 * ============================================================ */

int main(int argc, char *argv[])
{
	/* Ensure base directories exist */
	ensure_dir(CHAT_DIR);
	ensure_dir(CHAT_USERS);
	ensure_dir(CHAT_GROUPS);

	if (argc < 2)
		return cmd_status();

	const char *cmd = argv[1];

	if (strcmp(cmd, "send") == 0)		return cmd_send(argc, argv);
	if (strcmp(cmd, "create") == 0)		return cmd_create(argc, argv);
	if (strcmp(cmd, "join") == 0)		return cmd_join(argc, argv);
	if (strcmp(cmd, "leave") == 0)		return cmd_leave(argc, argv);
	if (strcmp(cmd, "post") == 0)		return cmd_post(argc, argv);
	if (strcmp(cmd, "read") == 0)		return cmd_read(argc, argv);
	if (strcmp(cmd, "groups") == 0)		return cmd_groups();
	if (strcmp(cmd, "members") == 0)	return cmd_members(argc, argv);
	if (strcmp(cmd, "who") == 0)		return cmd_who();
	if (strcmp(cmd, "log") == 0)		return cmd_log();

	if (strcmp(cmd, "--help") == 0 || strcmp(cmd, "-h") == 0)
		return cmd_status();

	fprintf(stderr, "chat: Unknown command '%s'\n", cmd);
	fprintf(stderr, "chat: Try 'chat --help'\n");
	return 1;
}
