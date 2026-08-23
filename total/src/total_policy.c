#include "total_policy.h"

#include <string.h>

/* First-edition fail-closed policy stub. Domain policy remains external. */
total_policy_decision total_policy_evaluate(
    const total_domain_evidence *evidence,
    const total_policy_context *context) {
    if (evidence == NULL || context == NULL ||
        context->policy_id == NULL || context->policy_version == NULL ||
        context->jurisdiction == NULL || evidence->integrity_ok == 0 ||
        evidence->provenance == NULL || evidence->provenance[0] == '\0') {
        return TOTAL_POLICY_DENY;
    }

    /* A production provider must verify the policy itself before ALLOW. */
    return TOTAL_POLICY_REVIEW;
}
