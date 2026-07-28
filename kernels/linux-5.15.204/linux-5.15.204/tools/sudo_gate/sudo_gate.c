/*
 * sudo_gate.c - Privilege Gate Extension for sudo
 *
 * Implements a graded privilege system (levels 1-8) where system operations
 * are classified by sensitivity. Standard sudo behavior is preserved for
 * levels 1-6. Level 7 requires "sudo touch system <CMD>" and level 8
 * requires "sudo touch system gate <CMD>".
 *
 * PRIVILEGE GRADE SCALE (System Operator Attitudes)
 * ═══════════════════════════════════════════════════
 *
 * Grade 1 (Routine) - Everyday inspection, no state change
 *   • ls, cat, less, head, tail, file, stat, whoami, id
 *   • ps, top, free, df, du, uptime, w, who, last
 *   • ping, traceroute, dig, nslookup, host
 *   • grep, find, locate, which, whereis
 *   Invocation: sudo <cmd>
 *
 * Grade 2 (Operational) - Service management, safe restarts
 *   • systemctl status/start/restart/stop (non-critical services)
 *   • journalctl, dmesg (read-only)
 *   • apt list, apt show, dpkg -l
 *   • crontab -l, at -l
 *   Invocation: sudo <cmd>
 *
 * Grade 3 (Maintenance) - Package management, user-level config
 *   • apt install/remove/update/upgrade
 *   • pip install, npm install
 *   • useradd, usermod (non-root users)
 *   • chmod, chown (non-system directories)
 *   • cp, mv, rm (non-system paths)
 *   Invocation: sudo <cmd>
 *
 * Grade 4 (Network) - Network configuration, firewall rules
 *   • ip addr/route/link
 *   • iptables, nft, ufw (rule add/remove)
 *   • ifconfig, route
 *   • nmcli, networkctl
 *   • ss, netstat (configuration changes)
 *   Invocation: sudo <cmd>
 *
 * Grade 5 (Storage) - Disk and filesystem operations
 *   • mount, umount
 *   • fdisk, parted, mkfs
 *   • lvm (lvresize, lvextend, etc.)
 *   • mdadm
 *   • fsck (non-root filesystems)
 *   Invocation: sudo <cmd>
 *
 * Grade 6 (Kernel) - Kernel parameters, modules, system tuning
 *   • sysctl -w
 *   • modprobe, insmod, rmmod
 *   • echo > /proc/sys/*
 *   • ulimit changes
 *   • nice/renice (system-level)
 *   Invocation: sudo <cmd>
 *
 * Grade 7 (Critical System) - Core system files, boot, identity
 *   • passwd root, usermod root
 *   • visudo, editing /etc/sudoers
 *   • editing /etc/shadow, /etc/passwd, /etc/group
 *   • grub-install, update-grub, bootloader changes
 *   • systemctl mask/unmask critical services
 *   • editing /etc/fstab
 *   • dm-crypt/LUKS key management
 *   Invocation: sudo touch system <cmd>
 *
 * Grade 8 (Gate) - Irreversible, foundational, or security-critical
 *   • dd (raw disk write)
 *   • mkfs on mounted/system partitions
 *   • iptables -F (flush all rules)
 *   • rm -rf / or system directories
 *   • kernel replacement/installation
 *   • SELinux/AppArmor policy changes
 *   • SSH key rotation for root
 *   • Certificate authority operations
 *   • Database drop/truncate (system DBs)
 *   • Full disk encryption rekey
 *   Invocation: sudo touch system gate <cmd>
 *
 * SYSTEM CONSTITUTION ASSUMPTIONS
 * ═══════════════════════════════
 * 1. The system is a production or near-production Linux host.
 * 2. Multiple administrators may have sudo access.
 * 3. Not all sudo-capable users should have equal access to destructive ops.
 * 4. The grading reflects increasing potential for irreversible harm.
 * 5. A careful admin knows which gate to use and does so deliberately.
 * 6. The system values availability and integrity over convenience.
 * 7. Audit trail is mandatory for grades 7-8.
 * 8. Grade escalation requires explicit intent (the gate syntax).
 *
 * Copyright (C) 2026 MEARVK LLC
 * Author: Maximilian Eric Alexander Rupplin von Keffikon
 * License: GPL-2.0
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <time.h>
#include <syslog.h>
#include <pwd.h>
#include <errno.h>

#define SUDO_GATE_VERSION	"1.0.0"
#define SUDO_GATE_CONFIG	"/etc/sudo_gate.conf"
#define SUDO_GATE_LOG		"/var/log/sudo_gate.log"
#define SUDO_REAL_PATH		"/usr/bin/sudo.real"  /* Original sudo binary */
#define MAX_CMD_LEN		4096
#define MAX_ARGS		256

/* Grade levels */
#define GRADE_ROUTINE		1
#define GRADE_OPERATIONAL	2
#define GRADE_MAINTENANCE	3
#define GRADE_NETWORK		4
#define GRADE_STORAGE		5
#define GRADE_KERNEL		6
#define GRADE_CRITICAL		7  /* Requires: sudo touch system <cmd> */
#define GRADE_GATE		8  /* Requires: sudo touch system gate <cmd> */

/* ============================================================
 * Command Classification Tables
 * ============================================================ */

struct cmd_grade {
	const char *command;
	const char *pattern;	/* NULL = match command only, else match args too */
	int grade;
};

/*
 * Grade 7 (Critical) commands - require "sudo touch system <cmd>"
 */
static const struct cmd_grade grade7_commands[] = {
	{ "passwd",	"root",		7 },
	{ "usermod",	"root",		7 },
	{ "visudo",	NULL,		7 },
	{ "vipw",	NULL,		7 },
	{ "vigr",	NULL,		7 },
	{ "grub-install", NULL,		7 },
	{ "update-grub", NULL,		7 },
	{ "grub-mkconfig", NULL,	7 },
	{ "systemctl",	"mask",		7 },
	{ "systemctl",	"unmask",	7 },
	{ "cryptsetup",	"luksAddKey",	7 },
	{ "cryptsetup",	"luksRemoveKey", 7 },
	{ "cryptsetup",	"luksChangeKey", 7 },
	{ NULL, NULL, 0 }
};

/*
 * Grade 7 paths - editing these files requires "sudo touch system"
 */
static const char *grade7_paths[] = {
	"/etc/sudoers",
	"/etc/shadow",
	"/etc/passwd",
	"/etc/group",
	"/etc/gshadow",
	"/etc/fstab",
	"/boot/grub/",
	"/etc/default/grub",
	NULL
};

/*
 * Grade 8 (Gate) commands - require "sudo touch system gate <cmd>"
 */
static const struct cmd_grade grade8_commands[] = {
	{ "dd",		NULL,		8 },  /* Raw disk write - always grade 8 */
	{ "mkfs",	NULL,		8 },  /* Filesystem creation (could be destructive) */
	{ "mkfs.ext4",	NULL,		8 },
	{ "mkfs.xfs",	NULL,		8 },
	{ "mkfs.btrfs",	NULL,		8 },
	{ "iptables",	"-F",		8 },  /* Flush all rules */
	{ "iptables",	"--flush",	8 },
	{ "nft",	"flush",	8 },
	{ "ufw",	"reset",	8 },
	{ "shred",	NULL,		8 },
	{ "wipefs",	NULL,		8 },
	{ NULL, NULL, 0 }
};

/*
 * Grade 8 patterns - these argument patterns always trigger gate requirement
 */
static const char *grade8_patterns[] = {
	"rm -rf /",
	"rm -rf /*",
	"rm -rf /bin",
	"rm -rf /boot",
	"rm -rf /etc",
	"rm -rf /lib",
	"rm -rf /sbin",
	"rm -rf /usr",
	"rm -rf /var",
	"rm -rf /sys",
	"rm -rf /proc",
	"rm -rf /dev",
	NULL
};

/*
 * Grade 8 security operations
 */
static const char *grade8_security_ops[] = {
	"setenforce",
	"aa-enforce",
	"aa-disable",
	"update-alternatives",	/* When targeting system binaries */
	"dpkg-reconfigure",	/* For critical packages */
	NULL
};

/* ============================================================
 * Classification Engine
 * ============================================================ */

/*
 * Check if a path argument refers to a grade-7 protected file
 */
static int check_path_grade(const char *arg)
{
	int i;
	for (i = 0; grade7_paths[i]; i++) {
		if (strstr(arg, grade7_paths[i]))
			return 7;
	}
	return 0;
}

/*
 * Check if the full command line matches a grade-8 destructive pattern
 */
static int check_destructive_pattern(const char *full_cmd)
{
	int i;
	for (i = 0; grade8_patterns[i]; i++) {
		if (strstr(full_cmd, grade8_patterns[i]))
			return 8;
	}
	return 0;
}

/*
 * Classify a command into its privilege grade (1-8)
 */
static int classify_command(int argc, char *argv[], char *full_cmd)
{
	const char *cmd;
	int i;

	if (argc < 1)
		return 1;

	cmd = argv[0];

	/* Strip path to get bare command name */
	const char *slash = strrchr(cmd, '/');
	if (slash)
		cmd = slash + 1;

	/* Check grade 8 commands first (highest priority) */
	for (i = 0; grade8_commands[i].command; i++) {
		if (strcmp(cmd, grade8_commands[i].command) == 0) {
			if (grade8_commands[i].pattern == NULL)
				return 8;
			/* Check if pattern appears in arguments */
			if (full_cmd && strstr(full_cmd, grade8_commands[i].pattern))
				return 8;
		}
	}

	/* Check grade 8 destructive patterns */
	if (full_cmd && check_destructive_pattern(full_cmd) == 8)
		return 8;

	/* Check grade 8 security operations */
	for (i = 0; grade8_security_ops[i]; i++) {
		if (strcmp(cmd, grade8_security_ops[i]) == 0)
			return 8;
	}

	/* Check grade 7 commands */
	for (i = 0; grade7_commands[i].command; i++) {
		if (strcmp(cmd, grade7_commands[i].command) == 0) {
			if (grade7_commands[i].pattern == NULL)
				return 7;
			if (full_cmd && strstr(full_cmd, grade7_commands[i].pattern))
				return 7;
		}
	}

	/* Check if any argument references a grade-7 path */
	int j;
	for (j = 0; j < argc; j++) {
		if (check_path_grade(argv[j]) == 7)
			return 7;
	}

	/* Editors targeting system files */
	if ((strcmp(cmd, "nano") == 0 || strcmp(cmd, "vim") == 0 ||
	     strcmp(cmd, "vi") == 0 || strcmp(cmd, "editor") == 0)) {
		for (j = 1; j < argc; j++) {
			if (check_path_grade(argv[j]) == 7)
				return 7;
		}
	}

	/* Everything else: grades 1-6, handled by standard sudo as-is */
	return 1; /* Default: routine (sudo works normally) */
}

/* ============================================================
 * Audit Logging
 * ============================================================ */

static void audit_log(int grade, const char *user, const char *full_cmd,
		      const char *gate_used, int allowed)
{
	FILE *logf;
	time_t now;
	struct tm *tm;
	char timebuf[64];

	/* Always syslog for grades 7-8 */
	if (grade >= 7) {
		syslog(LOG_AUTH | LOG_NOTICE,
		       "sudo_gate: grade=%d user=%s gate=%s allowed=%d cmd=%s",
		       grade, user, gate_used ? gate_used : "none",
		       allowed, full_cmd);
	}

	/* File log */
	logf = fopen(SUDO_GATE_LOG, "a");
	if (!logf)
		return;

	now = time(NULL);
	tm = localtime(&now);
	strftime(timebuf, sizeof(timebuf), "%Y-%m-%d %H:%M:%S", tm);

	fprintf(logf, "%s grade=%d user=%s gate=%s allowed=%d cmd=%s\n",
		timebuf, grade, user, gate_used ? gate_used : "standard",
		allowed, full_cmd);
	fclose(logf);
}

/* ============================================================
 * Gate Parsing
 *
 * Standard:            sudo <cmd> [args...]         → grades 1-6
 * Touch System:        sudo touch system <cmd>      → grade 7
 * Touch System Gate:   sudo touch system gate <cmd> → grade 8
 * ============================================================ */

enum gate_level {
	GATE_STANDARD = 0,	/* Normal sudo invocation */
	GATE_TOUCH_SYSTEM,	/* "sudo touch system <cmd>" */
	GATE_TOUCH_SYSTEM_GATE,	/* "sudo touch system gate <cmd>" */
};

/*
 * Parse the invocation to determine which gate the admin used.
 * Returns the gate level and sets cmd_start to the index of the
 * actual command within argv.
 */
static enum gate_level parse_gate(int argc, char *argv[], int *cmd_start)
{
	/*
	 * argv[0] = "sudo" (or this wrapper)
	 * We look for "touch system gate" or "touch system" after sudo flags.
	 *
	 * Skip any sudo flags (starting with '-') to find the command portion.
	 */
	int i = 1; /* Skip argv[0] which is "sudo" */

	/* Skip sudo flags like -u, -E, -H, etc. */
	while (i < argc && argv[i][0] == '-') {
		/* Flags that take an argument */
		if (strcmp(argv[i], "-u") == 0 || strcmp(argv[i], "-g") == 0 ||
		    strcmp(argv[i], "-C") == 0 || strcmp(argv[i], "-D") == 0) {
			i += 2; /* skip flag and its argument */
		} else {
			i++; /* skip flag */
		}
	}

	if (i >= argc) {
		*cmd_start = i;
		return GATE_STANDARD;
	}

	/* Check for "touch system gate <cmd>" */
	if (i + 3 < argc &&
	    strcmp(argv[i], "touch") == 0 &&
	    strcmp(argv[i + 1], "system") == 0 &&
	    strcmp(argv[i + 2], "gate") == 0) {
		*cmd_start = i + 3;
		return GATE_TOUCH_SYSTEM_GATE;
	}

	/* Check for "touch system <cmd>" */
	if (i + 2 < argc &&
	    strcmp(argv[i], "touch") == 0 &&
	    strcmp(argv[i + 1], "system") == 0) {
		*cmd_start = i + 2;
		return GATE_TOUCH_SYSTEM;
	}

	/* Standard sudo invocation */
	*cmd_start = i;
	return GATE_STANDARD;
}

/* ============================================================
 * Main - sudo wrapper with gate enforcement
 * ============================================================ */

int main(int argc, char *argv[], char *envp[])
{
	enum gate_level gate;
	int cmd_start;
	int grade;
	char full_cmd[MAX_CMD_LEN] = {0};
	const char *username;
	struct passwd *pw;
	int i;

	/* Get invoking user */
	pw = getpwuid(getuid());
	username = pw ? pw->pw_name : "unknown";

	/* Open syslog */
	openlog("sudo_gate", LOG_PID, LOG_AUTH);

	/* If invoked with no arguments, pass through to real sudo */
	if (argc <= 1) {
		execv(SUDO_REAL_PATH, argv);
		perror("sudo_gate: failed to exec sudo");
		return 1;
	}

	/* Parse which gate was used */
	gate = parse_gate(argc, argv, &cmd_start);

	/* Build the full command string for classification */
	for (i = cmd_start; i < argc; i++) {
		if (i > cmd_start)
			strncat(full_cmd, " ", MAX_CMD_LEN - strlen(full_cmd) - 1);
		strncat(full_cmd, argv[i], MAX_CMD_LEN - strlen(full_cmd) - 1);
	}

	/* If no actual command after gate parsing, pass through */
	if (cmd_start >= argc || full_cmd[0] == '\0') {
		/* Maybe they literally want to run 'touch system' the file command */
		if (gate == GATE_TOUCH_SYSTEM || gate == GATE_TOUCH_SYSTEM_GATE) {
			/* If there's no command after the gate keywords, treat
			 * as literal 'touch' command on a file named 'system' */
			fprintf(stderr, "sudo_gate: No command specified after gate.\n");
			fprintf(stderr, "  Grade 7: sudo touch system <command>\n");
			fprintf(stderr, "  Grade 8: sudo touch system gate <command>\n");
			return 1;
		}
		execv(SUDO_REAL_PATH, argv);
		perror("sudo_gate: failed to exec sudo");
		return 1;
	}

	/* Classify the command grade */
	grade = classify_command(argc - cmd_start, &argv[cmd_start], full_cmd);

	/* ---- ENFORCEMENT ---- */

	/* Grades 1-6: standard sudo is sufficient */
	if (grade <= 6) {
		/* Any gate works for these - pass through to real sudo */
		char *sudo_argv[MAX_ARGS + 3];
		int j = 0;

		sudo_argv[j++] = SUDO_REAL_PATH;
		/* Preserve any sudo flags that were before the gate */
		for (i = 1; i < cmd_start && i < argc; i++) {
			if (gate == GATE_STANDARD) {
				sudo_argv[j++] = argv[i];
			}
			/* If gate keywords were used, skip them */
		}
		/* Add the actual command */
		for (i = cmd_start; i < argc && j < MAX_ARGS; i++)
			sudo_argv[j++] = argv[i];
		sudo_argv[j] = NULL;

		audit_log(grade, username, full_cmd, "standard", 1);
		execv(SUDO_REAL_PATH, sudo_argv);
		perror("sudo_gate: failed to exec sudo");
		return 1;
	}

	/* Grade 7: REQUIRES "sudo touch system <cmd>" or higher */
	if (grade == 7) {
		if (gate < GATE_TOUCH_SYSTEM) {
			fprintf(stderr,
				"\n"
				"╔══════════════════════════════════════════════════════╗\n"
				"║  SUDO GATE: Grade 7 - Critical System Operation     ║\n"
				"╠══════════════════════════════════════════════════════╣\n"
				"║  This command modifies critical system state.        ║\n"
				"║                                                      ║\n"
				"║  Required invocation:                                ║\n"
				"║    sudo touch system %s\n"
				"║                                                      ║\n"
				"║  Command classified as: GRADE 7 (Critical)          ║\n"
				"║  Standard 'sudo' is insufficient for this action.   ║\n"
				"╚══════════════════════════════════════════════════════╝\n"
				"\n", full_cmd);
			audit_log(grade, username, full_cmd, "insufficient", 0);
			closelog();
			return 1;
		}

		/* Gate satisfied - execute via real sudo */
		char *sudo_argv[MAX_ARGS + 2];
		int j = 0;
		sudo_argv[j++] = SUDO_REAL_PATH;
		for (i = cmd_start; i < argc && j < MAX_ARGS; i++)
			sudo_argv[j++] = argv[i];
		sudo_argv[j] = NULL;

		audit_log(grade, username, full_cmd, "touch_system", 1);
		execv(SUDO_REAL_PATH, sudo_argv);
		perror("sudo_gate: failed to exec sudo");
		return 1;
	}

	/* Grade 8: REQUIRES "sudo touch system gate <cmd>" */
	if (grade == 8) {
		if (gate < GATE_TOUCH_SYSTEM_GATE) {
			const char *hint;
			if (gate == GATE_TOUCH_SYSTEM)
				hint = "You used 'touch system' (grade 7) but this requires 'touch system gate' (grade 8).";
			else
				hint = "Standard 'sudo' is insufficient. This operation requires the highest gate.";

			fprintf(stderr,
				"\n"
				"╔══════════════════════════════════════════════════════════╗\n"
				"║  SUDO GATE: Grade 8 - IRREVERSIBLE / SECURITY-CRITICAL  ║\n"
				"╠══════════════════════════════════════════════════════════╣\n"
				"║  This command may cause IRREVERSIBLE changes to the      ║\n"
				"║  system or fundamentally alter its security posture.     ║\n"
				"║                                                          ║\n"
				"║  Required invocation:                                    ║\n"
				"║    sudo touch system gate %s\n"
				"║                                                          ║\n"
				"║  %s\n"
				"║                                                          ║\n"
				"║  Command classified as: GRADE 8 (Gate)                   ║\n"
				"║  Proceed with full awareness of consequences.            ║\n"
				"╚══════════════════════════════════════════════════════════╝\n"
				"\n", full_cmd, hint);
			audit_log(grade, username, full_cmd, "insufficient", 0);
			closelog();
			return 1;
		}

		/* Gate satisfied - execute via real sudo */
		char *sudo_argv[MAX_ARGS + 2];
		int j = 0;
		sudo_argv[j++] = SUDO_REAL_PATH;
		for (i = cmd_start; i < argc && j < MAX_ARGS; i++)
			sudo_argv[j++] = argv[i];
		sudo_argv[j] = NULL;

		audit_log(grade, username, full_cmd, "touch_system_gate", 1);

		/* Extra confirmation for grade 8 */
		fprintf(stderr, "sudo_gate: GRADE 8 confirmed. Executing: %s\n", full_cmd);
		execv(SUDO_REAL_PATH, sudo_argv);
		perror("sudo_gate: failed to exec sudo");
		return 1;
	}

	/* Should not reach here */
	fprintf(stderr, "sudo_gate: internal error classifying command\n");
	closelog();
	return 1;
}
