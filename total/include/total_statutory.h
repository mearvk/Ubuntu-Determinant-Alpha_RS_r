#ifndef TOTAL_STATUTORY_H
#define TOTAL_STATUTORY_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef enum total_source_status {
    TOTAL_SOURCE_REVIEW = 0,
    TOTAL_SOURCE_VERIFIED = 1,
    TOTAL_SOURCE_SUPERSEDED = 2
} total_source_status;

typedef enum total_source_type {
    TOTAL_SOURCE_STATUTE = 1,
    TOTAL_SOURCE_REGULATION = 2,
    TOTAL_SOURCE_JUDICIAL = 3,
    TOTAL_SOURCE_ADMINISTRATIVE = 4,
    TOTAL_SOURCE_CONTRACTUAL = 5,
    TOTAL_SOURCE_PROJECT_POLICY = 6
} total_source_type;

typedef struct total_statutory_source {
    uint32_t version;
    total_source_type source_type;
    const char *jurisdiction;
    const char *source_id;
    const char *title;
    const char *effective_date;
    const char *retrieved_date;
    const char *provenance;
    const char *policy_id;
    const char *policy_version;
    total_source_status status;
} total_statutory_source;

int total_statutory_source_validate(const total_statutory_source *source);

#ifdef __cplusplus
}
#endif

#endif
