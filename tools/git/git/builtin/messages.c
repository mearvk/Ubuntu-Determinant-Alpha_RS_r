/*
 * "git messages" — inspect the Ubuntu Determinant message catalog and the
 * active .gitmessages config from inside the git binary itself.
 *
 *   git messages [--config <file>] [path|validate|list|rules]
 *
 * It reuses the same native loader (gitmsg-config) the binary uses to apply
 * messages, so what it reports is exactly what the binary would emit. This is
 * the builtin front-end of the standalone `gitmsg` inspector.
 */
#include "builtin.h"
#include "parse-options.h"
#include "gitmsg-config.h"
#include "messages.h"

#define GITMSG_MAX_RULES 512
#define GITMSG_ARENA_SZ  (128 * 1024)

static const char *const messages_usage[] = {
	"git messages [--config <file>] [path|validate|list|rules]",
	NULL
};

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

int cmd_messages(int argc, const char **argv, const char *prefix,
		 struct repository *repo)
{
	const char *cfg_path = NULL;
	const char *cmd = "list";
	struct option options[] = {
		OPT_STRING(0, "config", &cfg_path, "file",
			   "inspect a specific .gitmessages file"),
		OPT_END()
	};
	static struct gitmsg_rule rules[GITMSG_MAX_RULES];
	static char arena[GITMSG_ARENA_SZ];
	struct gitmsg_config cfg;
	size_t k;

	argc = parse_options(argc, argv, prefix, options, messages_usage, 0);
	if (argc > 0)
		cmd = argv[0];

	/* Resolve like the binary: explicit --config wins, else env/CWD. */
	if (!cfg_path)
		cfg_path = gitmsg_config_path(".");

	if (!strcmp(cmd, "path")) {
		if (cfg_path && cfg_path[0])
			printf("%s\n", cfg_path);
		else
			printf("(no .gitmessages found; using compiled defaults)\n");
		return 0;
	}

	gitmsg_config_load(cfg_path, &cfg, rules, GITMSG_MAX_RULES,
			   arena, sizeof(arena));

	if (!strcmp(cmd, "validate")) {
		if (!cfg.loaded) {
			printf("No config applied; compiled defaults are in effect. OK.\n");
			return 0;
		}
		if (cfg.dropped_unsafe) {
			fprintf(stderr,
				"warning: %s was read, but some [MESSAGE] overrides were unsafe\n"
				"         and were ignored (for example an error/fatal routed to\n"
				"         stdout, or an emptied message). Compiled defaults are in\n"
				"         effect for those; %"PRIuMAX" [MAP] rule(s) still apply.\n",
				cfg.source_path ? cfg.source_path : "(config)",
				(uintmax_t)cfg.rule_count);
			return 1;
		}
		printf("Config %s loaded and valid. %"PRIuMAX" message(s), %"PRIuMAX" rule(s).\n",
		       cfg.source_path ? cfg.source_path : "(defaults)",
		       (uintmax_t)cfg.catalog_count, (uintmax_t)cfg.rule_count);
		return 0;
	}

	if (!strcmp(cmd, "list")) {
		printf("%-20s %-7s %-8s  %s\n", "id", "stream", "severity", "text");
		printf("%-20s %-7s %-8s  %s\n", "--", "------", "--------", "----");
		for (k = 0; k < cfg.catalog_count; k++) {
			const struct git_msg_entry *e = &cfg.catalog[k];
			printf("%-20s %-7s %-8s  %s\n",
			       gitmsg_id_name(e->id), stream_name(e->stream),
			       severity_name(e->severity), e->text);
		}
		return 0;
	}

	if (!strcmp(cmd, "rules")) {
		if (cfg.rule_count == 0) {
			printf("No [MAP] rules; every print passes through unchanged.\n");
			return 0;
		}
		printf("%"PRIuMAX" [MAP] rule(s):\n", (uintmax_t)cfg.rule_count);
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

	usage_with_options(messages_usage, options);
	return 129;
}
