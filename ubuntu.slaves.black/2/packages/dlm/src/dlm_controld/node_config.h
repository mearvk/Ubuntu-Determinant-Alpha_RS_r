/*
 * Copyright 2020 Red Hat, Inc.
 *
 * This copyrighted material is made available to anyone wishing to use,
 * modify, copy, or redistribute it subject to the terms and conditions
 * of the GNU General Public License v2 or (at your option) any later version.
 */

#ifndef _NODE_CONFIG_H_
#define _NODE_CONFIG_H_

#include <stdint.h>

struct node_config {
	uint32_t mark;
};

/*
 * Returns -ENOENT if path does not exist or there is no
 * config for nodeid in the file.
 *
 * Returns -EXYZ if there's a problem with the config.
 *
 * Returns 0 if a config was found with no problems.
 */

int node_config_init(const char *path);

const struct node_config *node_config_get(int nodeid);

#endif
