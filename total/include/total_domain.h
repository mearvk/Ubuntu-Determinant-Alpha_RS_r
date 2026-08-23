#ifndef TOTAL_DOMAIN_H
#define TOTAL_DOMAIN_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef enum total_domain_kind {
    TOTAL_DOMAIN_BANKING = 1,
    TOTAL_DOMAIN_HOSPITALITY = 2,
    TOTAL_DOMAIN_REGULATED_ADULT = 3,
    TOTAL_DOMAIN_REGULATED_COMMERCE = 4
} total_domain_kind;

typedef enum total_evidence_kind {
    TOTAL_EVIDENCE_IDENTITY = 1,
    TOTAL_EVIDENCE_AUTHORIZATION = 2,
    TOTAL_EVIDENCE_TRANSACTION = 3,
    TOTAL_EVIDENCE_LIFECYCLE = 4,
    TOTAL_EVIDENCE_INTEGRITY = 5,
    TOTAL_EVIDENCE_COMPLIANCE = 6,
    TOTAL_EVIDENCE_AUDIT = 7
} total_evidence_kind;

typedef struct total_domain_evidence {
    uint32_t version;
    total_domain_kind domain;
    total_evidence_kind kind;
    const char *source;
    const char *subject;
    const char *jurisdiction;
    const char *provenance;
    const char *purpose;
    const char *policy_reference;
    const char *audit_reference;
    uint64_t issued_at;
    uint64_t expires_at;
    uint32_t integrity_ok;
} total_domain_evidence;

typedef struct total_domain_result {
    int accepted;
    int policy_error;
    int provenance_error;
    int expired;
} total_domain_result;

int total_domain_validate(const total_domain_evidence *evidence,
                          total_domain_result *result);
int total_domain_minimum_retention(total_domain_kind domain,
                                   total_evidence_kind kind);

#ifdef __cplusplus
}
#endif

#endif
