#include "total_domain.h"
#include <assert.h>
#include <stdio.h>

static total_domain_evidence valid_evidence(void) {
    total_domain_evidence e = {0};
    e.version = 1;
    e.domain = TOTAL_DOMAIN_BANKING;
    e.kind = TOTAL_EVIDENCE_AUTHORIZATION;
    e.source = "test-provider";
    e.subject = "test-subject";
    e.jurisdiction = "US";
    e.provenance = "signed-test-fixture";
    e.purpose = "unit-test";
    e.policy_reference = "test-policy-v1";
    e.audit_reference = "test-audit-1";
    e.integrity_ok = 1;
    return e;
}

int main(void) {
    total_domain_evidence e = valid_evidence();
    total_domain_result r;

    assert(total_domain_validate(&e, &r) == 1);
    assert(r.accepted == 1);

    e.provenance = "";
    assert(total_domain_validate(&e, &r) == 0);
    assert(r.provenance_error == 1);

    e = valid_evidence();
    e.integrity_ok = 0;
    assert(total_domain_validate(&e, &r) == 0);
    assert(r.provenance_error == 1);

    e = valid_evidence();
    e.expires_at = 1;
    assert(total_domain_validate(&e, &r) == 0);
    assert(r.expired == 1);

    puts("total_domain_test: ok");
    return 0;
}
