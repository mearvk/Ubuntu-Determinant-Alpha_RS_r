/*
 * gitmsg — a small, friendly inspector for the message catalog and its
 * .gitmessages config. It reuses the same native loader (gitmsg-config) the
 * Edition git binary uses, so what it reports is exactly what the binary would
 * apply.
 *
 * Usage:
 *   gitmsg [--config <file>] path         Show which config file is in effect.
 *   gitmsg [--config <file>] validate     Load + validate; report OK or why not.
 *   gitmsg [--config <file>] list         Print the resolved message catalog.
 *   gitmsg [--config <file>] rules        Print the resolved [MAP] rules.
 *   gitmsg help                           This help.
 *
 * Without --config, the file is resolved like the binary does:
 *   $GIT_MESSAGES_CONFIG, else ./.gitmessages, else compiled defaults.
 *
 * Exit status: 0 on success; 2 on a usage error; 1 if `validate` finds the
 * config unusable (in which case the binary would fall back to defaults).
 *
 * Self-contained: links only gitmsg-config.o + messages.o.
 */
#include <stdio.h>
#include <string.h>

#include "gitmsg-config.h"
#include "messages.h"

#define MAX_RULES 512
#define ARENA_SZ  (128 * 1024)

static struct gitmsg_rule rules[MAX_RULES];
static char arena[ARENA_SZ];

static const char *stream_name(enum git_msg_stream s)
{
	return s == GIT_MSG_STDERR ? "stderr" : "stdout";
}

static const char *severity_name(enum git_msg_severity s)
{
	switch (s) {
	case GIT_MSG_NOTE:    return "note";
	case GIT_MSG_WARNING: return "warning";
	case GIT_MSG_ERROR:   return "error";
	case GIT_MSG_FATAL:   return "fatal";
	case GIT_MSG_INFO:
	default:              return "info";
	}
}

static void gm_usage(FILE *out)
{
	fputs(
"gitmsg — inspect the Git message catalog and .gitmessages config\n"
"\n"
"Usage:\n"
"  gitmsg [--config <file>] path       show which config file is in effect\n"
"  gitmsg [--config <file>] validate   load and validate the config\n"
"  gitmsg [--config <file>] list       print the resolved message catalog\n"
"  gitmsg [--config <file>] rules      print the resolved [MAP] rules\n"
"  gitmsg help                         show this help\n"
"\n"
"Without --config, the file is resolved as the git binary does:\n"
"  $GIT_MESSAGES_CONFIG, else ./.gitmessages, else compiled defaults.\n",
	      out);
}

int main(int argc, char **argv)
{
	const char *cfg_path = NULL;
	const char *cmd = NULL;
	struct gitmsg_config cfg;
	int i;

	for (i = 1; i < argc; i++) {
		if (!strcmp(argv[i], "--config") && i + 1 < argc) {
			cfg_path = argv[++i];
		} else if (!strcmp(argv[i], "-h") || !strcmp(argv[i], "--help")) {
			gm_usage(stdout);
			return 0;
		} else if (!cmd) {
			cmd = argv[i];
		} else {
			fprintf(stderr, "gitmsg: unexpected argument: %s\n", argv[i]);
			gm_usage(stderr);
			return 2;
		}
	}

	if (!cmd || !strcmp(cmd, "help")) {
		gm_usage(cmd ? stdout : stderr);
		return cmd ? 0 : 2;
	}

	/* Resolve path like the binary: explicit --config wins, else env/CWD. */
	if (!cfg_path)
		cfg_path = gitmsg_config_path(".");

	if (!strcmp(cmd, "path")) {
		if (cfg_path && cfg_path[0]) {
			FILE *f = fopen(cfg_path, "r");
			printf("%s%s\n", cfg_path, f ? "" : "  (not readable; using defaults)");
			if (f)
				fclose(f);
		} else {
			printf("(no .gitmessages found; using compiled defaults)\n");
		}
		return 0;
	}

	gitmsg_config_load(cfg_path, &cfg, rules, MAX_RULES, arena, sizeof(arena));

	if (!strcmp(cmd, "validate")) {
		int ok = git_msg_catalog_validate(cfg.catalog,
						  cfg.catalog_count) == 0;
		if (!cfg.loaded)
			printf("No config applied; compiled defaults are in effect. OK.\n");
		else if (cfg.dropped_unsafe) {
			printf("Config %s was read, but some [MESSAGE] overrides were unsafe\n"
			       "and were ignored (for example an error/fatal routed to stdout,\n"
			       "or an emptied message). The compiled defaults are in effect for\n"
			       "those; %zu [MAP] rule(s) still apply. Please review your file.\n",
			       cfg.source_path ? cfg.source_path : "(config)",
			       cfg.rule_count);
			return 1;
		} else if (ok)
			printf("Config %s loaded and valid. %zu message(s), %zu rule(s).\n",
			       cfg.source_path ? cfg.source_path : "(defaults)",
			       cfg.catalog_count, cfg.rule_count);
		else {
			printf("Config is unusable; the binary would fall back to defaults.\n");
			return 1;
		}
		return 0;
	}

	if (!strcmp(cmd, "list")) {
		size_t k;
		printf("%-20s %-7s %-8s  %s\n", "id", "stream", "severity", "text");
		printf("%-20s %-7s %-8s  %s\n", "--", "------", "--------", "----");
		for (k = 0; k < cfg.catalog_count; k++) {
			const struct git_msg_entry *e = &cfg.catalog[k];
			printf("%-20s %-7s %-8s  %s\n",
			       gitmsg_id_name(e->id),
			       stream_name(e->stream),
			       severity_name(e->severity),
			       e->text);
		}
		return 0;
	}

	if (!strcmp(cmd, "rules")) {
		size_t k;
		if (cfg.rule_count == 0) {
			printf("No [MAP] rules; every print passes through unchanged.\n");
			return 0;
		}
		printf("%zu [MAP] rule(s):\n", cfg.rule_count);
		for (k = 0; k < cfg.rule_count; k++) {
			const struct gitmsg_rule *r = &rules[k];
			printf("  ");
			if (r->file_substr) printf("file=%s ", r->file_substr);
			if (r->func_substr) printf("func=%s ", r->func_substr);
			if (r->text_substr) printf("text=%s ", r->text_substr);
			printf("-> %s\n", gitmsg_id_name(r->id));
		}
		return 0;
	}

	fprintf(stderr, "gitmsg: unknown command: %s\n", cmd);
	gm_usage(stderr);
	return 2;
}
