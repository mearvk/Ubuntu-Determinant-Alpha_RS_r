#ifndef TOTAL_POLICY_H
#define TOTAL_POLICY_H

#include "total_domain.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef enum total_policy_decision {
    TOTAL_POLICY_DENY = 0,
    TOTAL_POLICY_ALLOW = 1,
    TOTAL_POLICY_REVIEW = 2
} total_policy_decision;

typedef struct total_policy_context {
    const char *policy_id;
    const char *policy_version;
    const char *jurisdiction;
    uint64_t now;
} total_policy_context;

total_policy_decision total_policy_evaluate(
    const total_domain_evidence *evidence,
    const total_policy_context *context);

#ifdef __cplusplus
}
#endif

#endif
