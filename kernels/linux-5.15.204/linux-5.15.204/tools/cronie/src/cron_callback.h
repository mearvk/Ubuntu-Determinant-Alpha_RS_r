/* SPDX-License-Identifier: GPL-2.0 */
/*
 * cron_callback.h - Callback & Handler Extension API
 *
 * Integration header for cronie's do_command.c
 *
 * Copyright (C) 2026 MEARVK LLC
 */

#ifndef _CRON_CALLBACK_H
#define _CRON_CALLBACK_H

#define CRONCB_MAX_RETRIES	10
#define CRONCB_MAX_HANDLERS	3
#define CRONCB_MAX_PRECOND	8
#define CRONCB_OUTPUT_MAX	65536

struct cron_callback;
struct cron_job_result;

/*
 * cron_callback_execute - Run a job with full callback handling
 *
 * Performs:
 *   1. Precondition checks
 *   2. RAM verification
 *   3. Execute primary handler
 *   4. Validate output (minimum testable output)
 *   5. Retry on failure
 *   6. Escalate to secondary/tertiary handlers
 *   7. Notify admin on persistent failure
 *
 * Returns: 0 on success, negative on failure
 */
int cron_callback_execute(struct cron_callback *cb);

/*
 * cron_callback_parse - Parse @callback { ... } block from crontab
 *
 * Returns: 0 on success
 */
int cron_callback_parse(const char *config_block, struct cron_callback *cb);

/*
 * cron_has_callback - Check if a crontab line has @callback syntax
 *
 * Returns: pointer to the callback block start, or NULL
 */
static inline const char *cron_has_callback(const char *crontab_line)
{
	return strstr(crontab_line, "@callback");
}

#endif /* _CRON_CALLBACK_H */
