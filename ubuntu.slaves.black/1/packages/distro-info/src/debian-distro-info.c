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

#define DEBIAN
#define CSV_NAME "debian"
#define CSV_HEADER "version,codename,series,created,release,eol,eol-lts,eol-elts"
#define DISTRO_NAME "Debian"
#define NAME "debian-distro-info"

// C standard libraries
#include <stdlib.h>

#include "distro-info-util.h"

static bool filter_devel(const date_t *date, const distro_t *distro) {
    return created(date, distro) && !released(date, distro) &&
           *distro->version == '\0';
}

static bool filter_oldstable(const date_t *date, const distro_t *distro) {
    return created(date, distro) && released(date, distro);
}

static bool filter_testing(const date_t *date, const distro_t *distro) {
    return created(date, distro) && !released(date, distro);
}

static const distro_t *select_first(const distro_elem_t *distro_list) {
    return distro_list->distro;
}

static const distro_t *select_oldstable(const distro_elem_t *distro_list) {
    const distro_t *newest;
    const distro_t *second = NULL;

    newest = distro_list->distro;
    while(distro_list != NULL) {
        distro_list = distro_list->next;
        if(distro_list) {
            if(date_ge(distro_list->distro->milestones[MILESTONE_RELEASE],
                       newest->milestones[MILESTONE_RELEASE])) {
                second = newest;
                newest = distro_list->distro;
            } else if(second && date_ge(distro_list->distro->milestones[MILESTONE_RELEASE],
                                        second->milestones[MILESTONE_RELEASE])) {
                second = distro_list->distro;
            }
        }
    }
    return second;
}

#include "distro-info-util.c"
