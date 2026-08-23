#include "total_statutory.h"

static int nonempty(const char *s) { return s != 0 && s[0] != '\0'; }

int total_statutory_source_validate(const total_statutory_source *source) {
    if (source == 0 || source->version == 0 ||
        source->source_type < TOTAL_SOURCE_STATUTE ||
        source->source_type > TOTAL_SOURCE_PROJECT_POLICY ||
        !nonempty(source->jurisdiction) ||
        !nonempty(source->source_id) ||
        !nonempty(source->title) ||
        !nonempty(source->provenance)) {
        return 0;
    }

    /* Unverified material is admissible as evidence only for review. */
    if (source->status == TOTAL_SOURCE_VERIFIED ||
        source->status == TOTAL_SOURCE_REVIEW ||
        source->status == TOTAL_SOURCE_SUPERSEDED) {
        return 1;
    }

    return 0;
}
