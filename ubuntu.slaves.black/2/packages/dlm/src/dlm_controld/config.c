/*
 * Copyright 2004-2012 Red Hat, Inc.
 *
 * This copyrighted material is made available to anyone wishing to use,
 * modify, copy, or redistribute it subject to the terms and conditions
 * of the GNU General Public License v2 or (at your option) any later version.
 */

#include "dlm_daemon.h"

#if 0

lockspace ls_name [ls_args]
master    ls_name node=nodeid [node_args]
master    ls_name node=nodeid [node_args]
master    ls_name node=nodeid [node_args]

lockspace foo nodir=1
master node=1 weight=2
master node=2 weight=1

#endif

/* The max line length in dlm.conf */

#define MAX_LINE 256

int get_weight(struct lockspace *ls, int nodeid)
{
	int i;

	/* if no masters are defined, everyone defaults to weight 1 */

	if (!ls->master_count)
		return 1;

	for (i = 0; i < ls->master_count; i++) {
		if (ls->master_nodeid[i] == nodeid)
			return ls->master_weight[i];
	}

	/* if masters are defined, non-masters default to weight 0 */

	return 0;
}

static void read_master_config(struct lockspace *ls, FILE *file)
{
	char line[MAX_LINE];
	char name[MAX_LINE];
	char args[MAX_LINE];
	char *k;
	int nodeid, weight, i;

	while (fgets(line, MAX_LINE, file)) {
		if (line[0] == '\n')
			break;
		if (line[0] == ' ')
			break;
		if (line[0] == '#')
			continue;

		if (strncmp(line, "master", strlen("master")))
			break;

		memset(name, 0, sizeof(name));
		memset(args, 0, sizeof(args));
		nodeid = 0;
		weight = 1;

		sscanf(line, "master %s %[^\n]s", name, args);

		if (strcmp(name, ls->name))
			break;

		k = strstr(args, "node=");
		if (!k)
			break;

		sscanf(k, "node=%d", &nodeid);
		if (!nodeid)
			break;

		k = strstr(args, "weight=");
		if (k)
			sscanf(k, "weight=%d", &weight);

		log_debug("config lockspace %s nodeid %d weight %d",
			  ls->name, nodeid, weight);

		i = ls->master_count++;
		ls->master_nodeid[i] = nodeid;
		ls->master_weight[i] = weight;

		if (ls->master_count >= MAX_NODES)
			break;
	}
}

void setup_lockspace_config(struct lockspace *ls)
{
	FILE *file;
	char line[MAX_LINE];
	char name[MAX_LINE];
	char args[MAX_LINE];
	char *k;
	int val;

	if (!path_exists(CONF_FILE_PATH))
		return;

	file = fopen(CONF_FILE_PATH, "r");
	if (!file)
		return;

	while (fgets(line, MAX_LINE, file)) {
		if (line[0] == '#')
			continue;
		if (line[0] == '\n')
			continue;

		if (strncmp(line, "lockspace", strlen("lockspace")))
			continue;

		memset(name, 0, sizeof(name));
		memset(args, 0, sizeof(args));
		val = 0;

		sscanf(line, "lockspace %s %[^\n]s", name, args);

		if (strcmp(name, ls->name))
			continue;

		k = strstr(args, "nodir=");
		if (k) {
			sscanf(k, "nodir=%d", &val);
			ls->nodir = val;
		}

		read_master_config(ls, file);
	}

	fclose(file);
}

static void get_val_int(char *line, int *val_out)
{
	char key[MAX_LINE];
	char val[MAX_LINE];
	int rv;

	rv = sscanf(line, "%[^=]=%s", key, val);
	if (rv != 2) {
		log_error("Failed to parse config line %s", line);
		return;
	}

	*val_out = atoi(val);
}

static void get_val_uint(char *line, unsigned int *val_out)
{
	char key[MAX_LINE];
	char val[MAX_LINE];
	int rv;

	rv = sscanf(line, "%[^=]=%s", key, val);
	if (rv != 2) {
		log_error("Failed to parse config line %s", line);
		return;
	}

	*val_out = strtoul(val, NULL, 0);
}

static void get_val_str(char *line, char *val_out)
{
	char key[MAX_LINE];
	char val[MAX_LINE];
	int rv;

	rv = sscanf(line, "%[^=]=%s", key, val);
	if (rv != 2) {
		log_error("Failed to parse config line %s", line);
		return;
	}

	strcpy(val_out, val);
}

inline static void reload_setting(int index)
{
	switch(index) {
	case log_debug_ind:
		set_configfs_opt("log_debug", NULL, opt(log_debug_ind));
		break;
	case debug_logfile_ind:
		set_logfile_priority();
		break;
	default:
		break;
	}
}

static void reset_opt_value(int index)
{
	struct dlm_option *o = &dlm_options[index];

	/* config priority: cli, config file, default */

	if (o->cli_set) {
		o->use_int = o->cli_int;
		o->use_uint = o->cli_uint;
		o->use_str = o->cli_str;

	} else if (o->file_set) {
		o->use_int = o->file_int;
		o->use_uint = o->file_uint;
		o->use_str = o->file_str;

	} else {
		o->use_int = o->default_int;
		o->use_uint = o->default_uint;
		o->use_str = (char *)o->default_str;
	}

	/*
	 * We don't handle reset value same as legacy value.
	 *
	 * i.e.
	 * 1. option abc default value is 0, while in dlm.conf abc=0.
	 * 2. Then remove abc from dlm.conf.
	 * 3. This function still call reload_setting(), and won't bypass this
	 *    calling for no change.
	 */
	reload_setting(index);
	return;
}

void set_opt_file(int update)
{
	unsigned int uval = 0;
	struct dlm_option *o;
	FILE *file;
	char line[MAX_LINE];
	char str[MAX_LINE];
	int i, val = 0, ind;
	char scanned_dlm_opt[dlm_options_max];

	if (!path_exists(CONF_FILE_PATH))
		return;

	file = fopen(CONF_FILE_PATH, "r");
	if (!file)
		return;

	/* In update mode, there is a little bit bother if one option ever set
	 * but later be removed or commented out */
	memset(scanned_dlm_opt, 0, sizeof(scanned_dlm_opt));
	scanned_dlm_opt[help_ind] = 1;
	scanned_dlm_opt[version_ind] = 1;

	while (fgets(line, MAX_LINE, file)) {
		if (line[0] == '#')
			continue;
		if (line[0] == '\n')
			continue;

		memset(str, 0, sizeof(str));

		for (i = 0; i < MAX_LINE; i++) {
			if (line[i] == ' ')
				break;
			if (line[i] == '=')
				break;
			if (line[i] == '\0')
				break;
			if (line[i] == '\n')
				break;
			if (line[i] == '\t')
				break;
			str[i] = line[i];
		}

		ind = get_ind_name(str);
		if (ind < 0)
			continue;
		o = &dlm_options[ind];
		if (!o)
			continue;

		scanned_dlm_opt[ind] = 1;

		/* In update flow, bypass the item which doesn't support reload. */
		if (update && !o->reload)
			continue;

		o->file_set++;

		if (!o->req_arg) {
			/* current only "help" & "version" are no_arg type, ignore them */
			continue;

		} else if (o->req_arg == req_arg_int) {
			get_val_int(line, &val);

			if (update && (o->file_int == val))
				continue;

			o->file_int = val;

			if (!o->cli_set)
				o->use_int = o->file_int;

			log_debug("config file %s = %d cli_set %d use %d",
				  o->name, o->file_int, o->cli_set, o->use_int);

		} else if (o->req_arg == req_arg_uint) {
			get_val_uint(line, &uval);

			if (update && (o->file_uint == uval))
				continue;

			o->file_uint = uval;

			if (!o->cli_set)
				o->use_uint = o->file_uint;

			log_debug("config file %s = %u cli_set %d use %u",
				  o->name, o->file_uint, o->cli_set, o->use_uint);

		} else if (o->req_arg == req_arg_bool) {
			get_val_int(line, &val);
			val = val ? 1 : 0;

			if (update && (o->file_int == val))
				continue;

			o->file_int = val;

			if (!o->cli_set)
				o->use_int = o->file_int;

			log_debug("config file %s = %d cli_set %d use %d",
				  o->name, o->file_int, o->cli_set, o->use_int);
		} else if (o->req_arg == req_arg_str) {
			memset(str, 0, sizeof(str));
			get_val_str(line, str);

			if (update && !strcmp(o->file_str, str))
				continue;

			if (o->file_str)
				free(o->file_str);
			o->file_str = strdup(str);

			if (!o->cli_set)
				o->use_str = o->file_str;

			log_debug("config file %s = %s cli_set %d use %s",
				  o->name, o->file_str, o->cli_set, o->use_str);
		}

		if (update)
			reload_setting(ind);
	}

	if (update) {
		/* handle commented out options  */
		for (i=0; i<dlm_options_max; i++) {
			if (scanned_dlm_opt[i])
				continue;
			if (!dlm_options[i].reload || !dlm_options[i].file_set)
				continue;

			dlm_options[i].file_set = 0;
			dlm_options[i].file_int = 0;
			dlm_options[i].file_uint = 0;
			if(dlm_options[i].file_str) {
				free(dlm_options[i].file_str);
				dlm_options[i].file_str = NULL;
			}
			reset_opt_value(i);
		}
	}

	fclose(file);
}

/*
 * do the clean/restore job:
 * - clean up dlm_options[].dynamic_xx
 * - using top priority item to set use option
 */
static void reset_dynamic(int index)
{
	struct dlm_option *o = &dlm_options[index];

	if (!o->reload)
		return;

	o->dynamic_set = 0;
	o->dynamic_int = 0;
	if (o->dynamic_str){
		free(o->dynamic_str);
		o->dynamic_str = NULL;
	}
	o->dynamic_uint = 0;
	reset_opt_value(index);

	return;
}

/* copy code from exec_command() */
void set_opt_online(char *cmd_str, int cmd_len)
{
	int i, ind, val = 0;
	int av_count = 0;
	int arg_len;
	unsigned int uval = 0;
	struct dlm_option *o;
	char str[MAX_LINE];
	char arg[ONE_ARG_LEN];
	char *av[MAX_AV_COUNT + 1]; /* +1 for NULL */

	if (cmd_len > RUN_COMMAND_LEN)
		return;

	for (i = 0; i < MAX_AV_COUNT + 1; i++)
		av[i] = NULL;

	if (!cmd_str[0])
		return;

	/* this should already be done, but make sure */
	cmd_str[cmd_len - 1] = '\0';

	memset(&arg, 0, sizeof(arg));
	arg_len = 0;
	cmd_len = strlen(cmd_str);

	for (i = 0; i < cmd_len; i++) {
		if (!cmd_str[i])
			break;

		if (av_count == MAX_AV_COUNT)
			break;

		if (cmd_str[i] == '\\') {
			if (i == (cmd_len - 1))
				break;
			i++;

			if (cmd_str[i] == '\\') {
				arg[arg_len++] = cmd_str[i];
				continue;
			}
			if (isspace(cmd_str[i])) {
				arg[arg_len++] = cmd_str[i];
				continue;
			} else {
				break;
			}
		}

		if (isalnum(cmd_str[i]) || ispunct(cmd_str[i])) {
			arg[arg_len++] = cmd_str[i];
		} else if (isspace(cmd_str[i])) {
			if (arg_len)
				av[av_count++] = strdup(arg);

			memset(arg, 0, sizeof(arg));
			arg_len = 0;
		} else {
			break;
		}
	}

	if ((av_count < MAX_AV_COUNT) && arg_len) {
		av[av_count++] = strdup(arg);
	}

	/*
	for (i = 0; i < MAX_AV_COUNT + 1; i++) {
		if (!av[i])
			break;

		syslog(LOG_ERR, "command av[%d] \"%s\"", i, av[i]);
	}
	*/

	if (!strcmp(av[0], "restore_all")) {
		for (i = 0; i < dlm_options_max; i++)
			reset_dynamic(i);
		return;
	}

	for (i = 0; i < av_count; i++) {
		ind = get_ind_name(av[i]);
		if (ind < 0)
			continue;
		o = &dlm_options[ind];
		if (!o || !o->reload)
			continue;

		get_val_str(av[i], str);
		if (!strcmp(str, "restore")) {
			reset_dynamic(ind);
			continue;
		}

		o->dynamic_set++;

		if (!o->req_arg || o->req_arg == req_arg_int) {
			get_val_int(av[i], &val);
			if (!o->req_arg)
				val = val ? 1 : 0;

			o->dynamic_int = val;

			log_debug("config dynamic %s = %d previous use %d",
				  o->name, o->dynamic_int, o->use_int);
			o->use_int = o->dynamic_int;

		} else if (o->req_arg == req_arg_uint) {
			get_val_uint(av[i], &uval);
			o->dynamic_uint = uval;

			log_debug("config dynamic %s = %u previous use %u",
				  o->name, o->dynamic_uint, o->use_uint);
			o->use_uint = o->dynamic_uint;

		} else if (o->req_arg == req_arg_bool) {
			get_val_int(av[i], &val);
			o->dynamic_int = val ? 1 : 0;

			log_debug("config dynamic %s = %d previous use %d",
				  o->name, o->dynamic_int, o->use_int);
			o->use_int = o->dynamic_int;

		} else if (o->req_arg == req_arg_str) {
			memset(str, 0, sizeof(str));
			get_val_str(av[i], str);

			o->dynamic_str = strdup(str);

			log_debug("config dynamic %s = %s previous use %s",
				  o->name, o->dynamic_str, o->use_str);
			o->use_str = o->dynamic_str;
		}

		reload_setting(ind);
	}

	return;
}
