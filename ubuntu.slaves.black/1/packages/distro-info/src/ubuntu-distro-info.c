/*
 * Copyright (C) 2012-2013, Benjamin Drung <bdrung@debian.org>
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

#define UBUNTU
#define CSV_NAME "ubuntu"
#define CSV_HEADER "version,codename,series,created,release,eol,eol-server,eol-esm"
#define DISTRO_NAME "Ubuntu"
#define NAME "ubuntu-distro-info"

// C standard libraries
#include <string.h>

#include "distro-info-util.h"

static bool filter_devel(const date_t *date, const distro_t *distro) {
    return created(date, distro) && !released(date, distro);
}

static bool filter_lts(const date_t *date, const distro_t *distro) {
    return strstr(distro->version, "LTS") != NULL &&
           released(date, distro) && !eol(date, distro);
}

#include "distro-info-util.c"
