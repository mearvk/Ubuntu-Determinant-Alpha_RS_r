#ifndef UBUNTU_GRAND_PROVENANCE_H
#define UBUNTU_GRAND_PROVENANCE_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct {
    const char *artifact_id;
    const char *release;
    const char *sha256;
    const char *observed_at_utc;
    const char *actor;
    const char *jurisdiction;
    const char *custody_status;
    const char *evidence_ref;
} ug_provenance_record;

/*
 * Returns 0 when the record has the minimum fields required for an
 * evidence-backed provenance entry. This validates structure only; it does
 * not determine legal ownership, jurisdiction, or custody.
 */
int ug_validate_record(const ug_provenance_record *record);

/*
 * Produce a stable textual fingerprint of the record fields. The caller owns
 * the output buffer. This helper intentionally does not claim cryptographic
 * security; production SHA-256 should be supplied by the repository's
 * existing verification layer.
 */
int ug_fingerprint(const ug_provenance_record *record,
                   char *output,
                   uint64_t output_size);

#ifdef __cplusplus
}
#endif

#endif
