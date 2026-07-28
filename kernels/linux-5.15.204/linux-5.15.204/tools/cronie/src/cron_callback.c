// SPDX-License-Identifier: GPL-2.0
/*
 * cron_callback.c - Callback & Handler Extension for Cronie
 *
 * Extends the standard cron daemon with:
 *   1. Job callbacks — confirm execution, retry on failure
 *   2. Primary/secondary/tertiary handlers for each job
 *   3. Minimum testable output validation
 *   4. Pre-condition checking before execution
 *   5. Admin notification on mutable problems
 *   6. Extended crontab syntax for handler chains
 *
 * CRONTAB EXTENDED SYNTAX
 * ═══════════════════════
 *
 * Standard crontab line:
 *   * * * * * /path/to/command
 *
 * Extended crontab line (with callbacks):
 *   * * * * * /path/to/command @callback { ... }
 *
 * Full extended format:
 *   SCHEDULE COMMAND @callback {
 *       expect: "success string or exit code"
 *       retry: N
 *       retry_delay: Ns
 *       preconditions: "command1; command2"
 *       handler_secondary: "/path/to/fallback"
 *       handler_tertiary: "/path/to/last-resort"
 *       on_fail: notify|retry|escalate
 *       notify: "admin|user@host|chat:group"
 *       ram_check: NMB
 *       timeout: Ns
 *   }
 *
 * Or as a one-liner with flags:
 *   * * * * * /cmd --cron-retry=3 --cron-expect="OK" --cron-fallback=/cmd2
 *
 * EXAMPLE EXTENDED CRONTAB
 * ═════════════════════════
 *
 * # Standard (unchanged, works as before):
 * 0 * * * * /usr/local/bin/backup.sh
 *
 * # With retry and notification:
 * 0 2 * * * /usr/local/bin/backup.sh @callback {
 *     expect: "Backup complete"
 *     retry: 3
 *     retry_delay: 60s
 *     on_fail: notify
 *     notify: "admin"
 * }
 *
 * # With handler chain:
 * */5 * * * * /usr/local/bin/health_check.sh @callback {
 *     expect: exit:0
 *     preconditions: "systemctl is-active nginx; test -f /var/run/app.pid"
 *     handler_secondary: /usr/local/bin/health_check_extended.sh
 *     handler_tertiary: /usr/local/bin/emergency_restart.sh
 *     on_fail: escalate
 *     notify: "chat:ops-team"
 *     ram_check: 64MB
 *     timeout: 30s
 * }
 *
 * Copyright (C) 2026 MEARVK LLC
 * Author: Maximilian Eric Alexander Rupplin von Keffikon
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/sysinfo.h>
#include <time.h>
#include <errno.h>
#include <syslog.h>
#include <signal.h>

/* ============================================================
 * Configuration
 * ============================================================ */

#define CRONCB_MAX_RETRIES	10
#define CRONCB_MAX_HANDLERS	3
#define CRONCB_MAX_PRECOND	8
#define CRONCB_OUTPUT_MAX	65536   /* 64KB max capture per job */
#define CRONCB_NOTIFY_CMD	"/usr/local/bin/chat"
#define CRONCB_LOG		"/var/log/cron_callback.log"

/* ============================================================
 * Data Structures
 * ============================================================ */

/* Callback configuration for a single cron job */
struct cron_callback {
	/* Expected output validation */
	char	expect_string[256];	/* Substring expected in stdout */
	int	expect_exit;		/* Expected exit code (-1 = don't check) */
	int	expect_set;		/* Whether expect is configured */

	/* Retry behavior */
	int	retry_count;		/* Max retries (0 = no retry) */
	int	retry_delay_sec;	/* Seconds between retries */

	/* Handler chain */
	char	handler_primary[512];	/* The cron command itself */
	char	handler_secondary[512];	/* Fallback handler */
	char	handler_tertiary[512];	/* Last-resort handler */

	/* Preconditions */
	char	preconditions[CRONCB_MAX_PRECOND][256];
	int	precondition_count;

	/* Failure behavior */
	enum {
		ONFAIL_RETRY = 0,
		ONFAIL_NOTIFY,
		ONFAIL_ESCALATE,	/* Escalate through handler chain */
	} on_fail;

	/* Notification */
	char	notify_target[256];	/* "admin", "chat:group", "user" */

	/* Resource checks */
	unsigned long ram_check_mb;	/* Minimum free RAM before running */
	int	timeout_sec;		/* Kill job after this many seconds */
};

/* Result of a job execution */
struct cron_job_result {
	int	exit_code;
	char	output[CRONCB_OUTPUT_MAX];
	size_t	output_len;
	int	timed_out;
	double	elapsed_sec;
	int	handler_level;		/* 1=primary, 2=secondary, 3=tertiary */
	int	attempt;		/* Which retry attempt (1-based) */
};

/* ============================================================
 * Precondition Checking
 *
 * Before executing the cron job, verify that required
 * conditions are met. If preconditions fail, the admin
 * may need to move or configure something.
 * ============================================================ */

static int check_precondition(const char *cmd)
{
	int ret = system(cmd);
	return WIFEXITED(ret) && WEXITSTATUS(ret) == 0;
}

static int check_all_preconditions(struct cron_callback *cb)
{
	int i;
	for (i = 0; i < cb->precondition_count; i++) {
		if (!check_precondition(cb->preconditions[i])) {
			syslog(LOG_WARNING,
			       "cron_callback: Precondition FAILED: %s",
			       cb->preconditions[i]);
			return 0; /* Precondition not met */
		}
	}
	return 1; /* All preconditions passed */
}

/* ============================================================
 * RAM Check
 *
 * Verify minimum free RAM before executing.
 * Prevents job failure due to OOM conditions.
 * ============================================================ */

static int check_ram_available(unsigned long required_mb)
{
	struct sysinfo info;

	if (required_mb == 0)
		return 1; /* No check configured */

	if (sysinfo(&info) != 0)
		return 1; /* Can't check, assume OK */

	unsigned long free_mb = (info.freeram * info.mem_unit) / (1024 * 1024);

	if (free_mb < required_mb) {
		syslog(LOG_WARNING,
		       "cron_callback: Insufficient RAM: %lu MB free, %lu MB required",
		       free_mb, required_mb);
		return 0;
	}
	return 1;
}

/* ============================================================
 * Job Execution with Output Capture
 *
 * Runs the command, captures stdout/stderr, enforces timeout,
 * and returns the result for validation.
 * ============================================================ */

static int execute_with_capture(const char *cmd, struct cron_job_result *result,
				int timeout_sec)
{
	FILE *fp;
	char buf[4096];
	time_t start, now;
	pid_t pid;
	int pfd[2];
	int status;

	memset(result, 0, sizeof(*result));
	result->output_len = 0;

	start = time(NULL);

	/* Use popen for simple capture */
	fp = popen(cmd, "r");
	if (!fp) {
		result->exit_code = -1;
		snprintf(result->output, sizeof(result->output),
			 "ERROR: Failed to execute: %s", strerror(errno));
		result->output_len = strlen(result->output);
		return -1;
	}

	/* Read output */
	while (fgets(buf, sizeof(buf), fp)) {
		size_t len = strlen(buf);
		if (result->output_len + len < CRONCB_OUTPUT_MAX - 1) {
			memcpy(result->output + result->output_len, buf, len);
			result->output_len += len;
		}

		/* Timeout check */
		if (timeout_sec > 0) {
			now = time(NULL);
			if (now - start > timeout_sec) {
				result->timed_out = 1;
				pclose(fp);
				result->exit_code = -2;
				return -2;
			}
		}
	}

	result->output[result->output_len] = '\0';
	status = pclose(fp);
	result->exit_code = WIFEXITED(status) ? WEXITSTATUS(status) : -1;
	result->elapsed_sec = difftime(time(NULL), start);

	return result->exit_code;
}

/* ============================================================
 * Output Validation
 *
 * Checks that the job produced expected output or exit code.
 * This is the "minimum testable output" requirement.
 * ============================================================ */

static int validate_result(struct cron_callback *cb, struct cron_job_result *result)
{
	if (!cb->expect_set)
		return 1; /* No expectation configured = always pass */

	/* Check exit code if configured */
	if (cb->expect_exit >= 0) {
		if (result->exit_code != cb->expect_exit)
			return 0; /* Exit code mismatch */
	}

	/* Check output string if configured */
	if (cb->expect_string[0] != '\0') {
		if (strstr(result->output, cb->expect_string) == NULL)
			return 0; /* Expected string not found */
	}

	return 1; /* Validation passed */
}

/* ============================================================
 * Admin Notification
 *
 * Notifies the system admin about mutable problems.
 * Uses the system 'chat' tool, syslog, or direct message.
 * ============================================================ */

static void notify_admin(struct cron_callback *cb, struct cron_job_result *result,
			 const char *message)
{
	char cmd[2048];
	char timestamp[64];
	time_t now = time(NULL);
	struct tm *tm = localtime(&now);

	strftime(timestamp, sizeof(timestamp), "%Y-%m-%d %H:%M:%S", tm);

	/* Always syslog */
	syslog(LOG_ERR, "cron_callback: NOTIFICATION: %s (job=%s, exit=%d, attempt=%d)",
	       message, cb->handler_primary, result->exit_code, result->attempt);

	/* Log to file */
	FILE *logf = fopen(CRONCB_LOG, "a");
	if (logf) {
		fprintf(logf, "[%s] %s\n", timestamp, message);
		fprintf(logf, "  Job: %s\n", cb->handler_primary);
		fprintf(logf, "  Exit: %d | Attempt: %d/%d | Handler: %d/3\n",
			result->exit_code, result->attempt,
			cb->retry_count + 1, result->handler_level);
		if (result->output_len > 0)
			fprintf(logf, "  Output (last 200): %.200s\n",
				result->output + (result->output_len > 200 ?
						  result->output_len - 200 : 0));
		fprintf(logf, "\n");
		fclose(logf);
	}

	/* Notify via chat if target specified */
	if (cb->notify_target[0] != '\0') {
		if (strncmp(cb->notify_target, "chat:", 5) == 0) {
			/* Post to chat group */
			snprintf(cmd, sizeof(cmd),
				 "%s post %s [CRON ALERT] %s (job: %s, exit: %d)",
				 CRONCB_NOTIFY_CMD,
				 cb->notify_target + 5, /* skip "chat:" prefix */
				 message, cb->handler_primary,
				 result->exit_code);
			system(cmd);
		} else {
			/* Direct message to user */
			snprintf(cmd, sizeof(cmd),
				 "%s send %s [CRON ALERT] %s (job: %s)",
				 CRONCB_NOTIFY_CMD,
				 cb->notify_target, message,
				 cb->handler_primary);
			system(cmd);
		}
	}
}

/* ============================================================
 * Main Callback Executor
 *
 * This is the core logic that wraps a cron job with:
 *   1. Precondition verification
 *   2. RAM check
 *   3. Execute with capture
 *   4. Validate output
 *   5. Retry on failure
 *   6. Escalate through handler chain
 *   7. Notify admin on persistent failure
 * ============================================================ */

int cron_callback_execute(struct cron_callback *cb)
{
	struct cron_job_result result;
	const char *handlers[CRONCB_MAX_HANDLERS];
	int handler_count = 0;
	int h, attempt;
	int success = 0;

	/* Build handler chain */
	handlers[handler_count++] = cb->handler_primary;
	if (cb->handler_secondary[0] != '\0')
		handlers[handler_count++] = cb->handler_secondary;
	if (cb->handler_tertiary[0] != '\0')
		handlers[handler_count++] = cb->handler_tertiary;

	/* ---- Step 1: Precondition check ---- */
	if (cb->precondition_count > 0) {
		if (!check_all_preconditions(cb)) {
			/* Preconditions not met — admin may need to fix something */
			memset(&result, 0, sizeof(result));
			result.handler_level = 0;
			result.attempt = 0;
			notify_admin(cb, &result,
				     "Preconditions FAILED — admin may need to "
				     "move or configure something");
			return -1;
		}
	}

	/* ---- Step 2: RAM check ---- */
	if (!check_ram_available(cb->ram_check_mb)) {
		memset(&result, 0, sizeof(result));
		notify_admin(cb, &result,
			     "Insufficient RAM — job deferred");
		return -2;
	}

	/* ---- Step 3-6: Execute through handler chain with retries ---- */
	for (h = 0; h < handler_count && !success; h++) {
		result.handler_level = h + 1;

		for (attempt = 1; attempt <= cb->retry_count + 1; attempt++) {
			result.attempt = attempt;

			syslog(LOG_INFO,
			       "cron_callback: Executing handler %d/%d, "
			       "attempt %d/%d: %s",
			       h + 1, handler_count, attempt,
			       cb->retry_count + 1, handlers[h]);

			/* Execute */
			execute_with_capture(handlers[h], &result,
					     cb->timeout_sec);

			/* Validate */
			if (validate_result(cb, &result)) {
				success = 1;
				syslog(LOG_INFO,
				       "cron_callback: SUCCESS (handler=%d, "
				       "attempt=%d, exit=%d)",
				       h + 1, attempt, result.exit_code);
				break;
			}

			/* Failed — retry? */
			if (attempt <= cb->retry_count) {
				syslog(LOG_WARNING,
				       "cron_callback: Attempt %d failed "
				       "(exit=%d), retrying in %ds...",
				       attempt, result.exit_code,
				       cb->retry_delay_sec);
				if (cb->retry_delay_sec > 0)
					sleep(cb->retry_delay_sec);
			}
		}

		/* If primary/secondary failed, notify before trying next handler */
		if (!success && h < handler_count - 1) {
			char msg[512];
			snprintf(msg, sizeof(msg),
				 "Handler %d FAILED after %d attempts, "
				 "escalating to handler %d",
				 h + 1, cb->retry_count + 1, h + 2);
			if (cb->on_fail == ONFAIL_NOTIFY ||
			    cb->on_fail == ONFAIL_ESCALATE)
				notify_admin(cb, &result, msg);
		}
	}

	/* ---- Step 7: All handlers exhausted ---- */
	if (!success) {
		notify_admin(cb, &result,
			     "ALL HANDLERS FAILED — mutable problem requires "
			     "admin intervention");
		return -3;
	}

	return 0;
}

/* ============================================================
 * Callback Configuration Parser
 *
 * Parses the @callback { ... } block from extended crontab syntax.
 * ============================================================ */

int cron_callback_parse(const char *config_block, struct cron_callback *cb)
{
	char line[512];
	const char *p = config_block;
	char *nl;

	memset(cb, 0, sizeof(*cb));
	cb->expect_exit = -1; /* -1 = don't check */
	cb->retry_count = 0;
	cb->retry_delay_sec = 5;
	cb->timeout_sec = 300; /* 5 min default */
	cb->on_fail = ONFAIL_NOTIFY;

	while (*p) {
		/* Get next line */
		nl = strchr(p, '\n');
		if (nl) {
			size_t len = nl - p;
			if (len >= sizeof(line)) len = sizeof(line) - 1;
			memcpy(line, p, len);
			line[len] = '\0';
			p = nl + 1;
		} else {
			strncpy(line, p, sizeof(line) - 1);
			p += strlen(p);
		}

		/* Skip whitespace */
		char *l = line;
		while (*l == ' ' || *l == '\t') l++;

		/* Parse key: value pairs */
		if (strncmp(l, "expect:", 7) == 0) {
			l += 7;
			while (*l == ' ') l++;
			if (strncmp(l, "exit:", 5) == 0) {
				cb->expect_exit = atoi(l + 5);
			} else {
				strncpy(cb->expect_string, l,
					sizeof(cb->expect_string) - 1);
			}
			cb->expect_set = 1;
		}
		else if (strncmp(l, "retry:", 6) == 0) {
			cb->retry_count = atoi(l + 6);
			if (cb->retry_count > CRONCB_MAX_RETRIES)
				cb->retry_count = CRONCB_MAX_RETRIES;
		}
		else if (strncmp(l, "retry_delay:", 12) == 0) {
			cb->retry_delay_sec = atoi(l + 12);
		}
		else if (strncmp(l, "handler_secondary:", 18) == 0) {
			l += 18;
			while (*l == ' ') l++;
			strncpy(cb->handler_secondary, l,
				sizeof(cb->handler_secondary) - 1);
		}
		else if (strncmp(l, "handler_tertiary:", 17) == 0) {
			l += 17;
			while (*l == ' ') l++;
			strncpy(cb->handler_tertiary, l,
				sizeof(cb->handler_tertiary) - 1);
		}
		else if (strncmp(l, "preconditions:", 14) == 0) {
			l += 14;
			while (*l == ' ' || *l == '"') l++;
			/* Split on semicolons */
			char *tok = strtok(l, ";");
			while (tok && cb->precondition_count < CRONCB_MAX_PRECOND) {
				while (*tok == ' ') tok++;
				char *end = tok + strlen(tok) - 1;
				while (end > tok && (*end == ' ' || *end == '"'))
					*end-- = '\0';
				strncpy(cb->preconditions[cb->precondition_count],
					tok, 255);
				cb->precondition_count++;
				tok = strtok(NULL, ";");
			}
		}
		else if (strncmp(l, "on_fail:", 8) == 0) {
			l += 8;
			while (*l == ' ') l++;
			if (strncmp(l, "retry", 5) == 0)
				cb->on_fail = ONFAIL_RETRY;
			else if (strncmp(l, "notify", 6) == 0)
				cb->on_fail = ONFAIL_NOTIFY;
			else if (strncmp(l, "escalate", 8) == 0)
				cb->on_fail = ONFAIL_ESCALATE;
		}
		else if (strncmp(l, "notify:", 7) == 0) {
			l += 7;
			while (*l == ' ' || *l == '"') l++;
			strncpy(cb->notify_target, l,
				sizeof(cb->notify_target) - 1);
			/* Strip trailing quote */
			char *q = strchr(cb->notify_target, '"');
			if (q) *q = '\0';
		}
		else if (strncmp(l, "ram_check:", 10) == 0) {
			cb->ram_check_mb = atol(l + 10);
		}
		else if (strncmp(l, "timeout:", 8) == 0) {
			cb->timeout_sec = atoi(l + 8);
		}
	}

	return 0;
}

/* ============================================================
 * Integration Note
 *
 * This module integrates with cronie's do_command.c:
 *
 * In the job execution path, after the standard fork/exec,
 * if the crontab entry contains "@callback {", the callback
 * executor is invoked instead of raw system().
 *
 * The standard cron behavior is UNCHANGED for entries without
 * @callback. This is purely additive.
 *
 * Compilation:
 *   Add cron_callback.c to cronie's src/Makemodule.am
 *   Link into crond binary
 *
 * Or use standalone:
 *   gcc -o cron_callback cron_callback.c
 *   ./cron_callback --config /path/to/callback.conf --cmd "/my/job"
 * ============================================================ */

/* Standalone mode for testing */
#ifdef CRONCB_STANDALONE

static void usage(void)
{
	printf("cron_callback - Execute a command with callback handling\n\n");
	printf("Usage:\n");
	printf("  cron_callback --cmd 'command' [options]\n\n");
	printf("Options:\n");
	printf("  --cmd CMD            Command to execute\n");
	printf("  --expect STRING      Expected output substring\n");
	printf("  --expect-exit N      Expected exit code\n");
	printf("  --retry N            Number of retries (default: 0)\n");
	printf("  --retry-delay N      Seconds between retries (default: 5)\n");
	printf("  --fallback CMD       Secondary handler\n");
	printf("  --last-resort CMD    Tertiary handler\n");
	printf("  --precond CMD        Precondition command (repeatable)\n");
	printf("  --notify TARGET      Notification target\n");
	printf("  --ram-check N        Minimum free RAM in MB\n");
	printf("  --timeout N          Timeout in seconds\n");
}

int main(int argc, char *argv[])
{
	struct cron_callback cb;
	int i;

	memset(&cb, 0, sizeof(cb));
	cb.expect_exit = -1;
	cb.retry_delay_sec = 5;
	cb.timeout_sec = 300;
	cb.on_fail = ONFAIL_NOTIFY;

	openlog("cron_callback", LOG_PID, LOG_CRON);

	for (i = 1; i < argc; i++) {
		if (strcmp(argv[i], "--cmd") == 0 && i + 1 < argc)
			strncpy(cb.handler_primary, argv[++i], 511);
		else if (strcmp(argv[i], "--expect") == 0 && i + 1 < argc) {
			strncpy(cb.expect_string, argv[++i], 255);
			cb.expect_set = 1;
		}
		else if (strcmp(argv[i], "--expect-exit") == 0 && i + 1 < argc) {
			cb.expect_exit = atoi(argv[++i]);
			cb.expect_set = 1;
		}
		else if (strcmp(argv[i], "--retry") == 0 && i + 1 < argc)
			cb.retry_count = atoi(argv[++i]);
		else if (strcmp(argv[i], "--retry-delay") == 0 && i + 1 < argc)
			cb.retry_delay_sec = atoi(argv[++i]);
		else if (strcmp(argv[i], "--fallback") == 0 && i + 1 < argc)
			strncpy(cb.handler_secondary, argv[++i], 511);
		else if (strcmp(argv[i], "--last-resort") == 0 && i + 1 < argc)
			strncpy(cb.handler_tertiary, argv[++i], 511);
		else if (strcmp(argv[i], "--precond") == 0 && i + 1 < argc) {
			if (cb.precondition_count < CRONCB_MAX_PRECOND)
				strncpy(cb.preconditions[cb.precondition_count++],
					argv[++i], 255);
		}
		else if (strcmp(argv[i], "--notify") == 0 && i + 1 < argc)
			strncpy(cb.notify_target, argv[++i], 255);
		else if (strcmp(argv[i], "--ram-check") == 0 && i + 1 < argc)
			cb.ram_check_mb = atol(argv[++i]);
		else if (strcmp(argv[i], "--timeout") == 0 && i + 1 < argc)
			cb.timeout_sec = atoi(argv[++i]);
		else if (strcmp(argv[i], "--help") == 0) {
			usage();
			return 0;
		}
	}

	if (cb.handler_primary[0] == '\0') {
		fprintf(stderr, "cron_callback: --cmd required\n");
		usage();
		return 1;
	}

	int ret = cron_callback_execute(&cb);

	closelog();
	return ret == 0 ? 0 : 1;
}

#endif /* CRONCB_STANDALONE */
