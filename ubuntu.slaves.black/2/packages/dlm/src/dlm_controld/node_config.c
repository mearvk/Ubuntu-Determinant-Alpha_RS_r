/*
 * Copyright 2020 Red Hat, Inc.
 *
 * This copyrighted material is made available to anyone wishing to use,
 * modify, copy, or redistribute it subject to the terms and conditions
 * of the GNU General Public License v2 or (at your option) any later version.
 */

#include "dlm_daemon.h"

#define MAX_LINE 4096

static struct node_config nc[MAX_NODES];

static const struct node_config nc_default = {
	.mark = 0,
};

int node_config_init(const char *path)
{
	char line[MAX_LINE], tmp[MAX_LINE];
	unsigned long mark;
	FILE *file;
	int nodeid;
	int rv;

	/* if no config file is given we assume default node configuration */
	file = fopen(path, "r");
	if (!file) {
		log_debug("No config file %s, we assume default node configuration: mark %" PRIu32,
			  path, nc_default.mark);
		return 0;
	}

	while (fgets(line, MAX_LINE, file)) {
		if (line[0] == '#')
			continue;
		if (line[0] == '\n')
			continue;

		if (!strncmp(line, "node", strlen("node"))) {
			rv = sscanf(line, "node id=%d mark=%s", &nodeid, tmp);
			if (rv < 2) {
				log_error("Invalid configuration line: %s", line);
				rv = -EINVAL;
				goto out;
			}

			/* skip invalid nodeid's */
			if (nodeid <= 0 || nodeid > MAX_NODES - 1)
				continue;

			mark = strtoul(tmp, NULL, 0);
			if (mark == ULONG_MAX) {
				log_error("Failed to pars mark value %s will use %" PRIu32,
					  tmp, nc_default.mark);
				mark = nc_default.mark;
			}
			nc[nodeid].mark = mark;

			log_debug("parsed node config id=%d mark=%" PRIu32,
				  nodeid, mark);
		}
	}

	fclose(file);
	return 0;

out:
	fclose(file);
	return rv;
}

const struct node_config *node_config_get(int nodeid)
{
	if (nodeid <= 0 || nodeid > MAX_NODES - 1) {
		log_debug("node config requested for id=%d returning defaults", nodeid);
		return &nc_default;
	}

	return &nc[nodeid];
}
