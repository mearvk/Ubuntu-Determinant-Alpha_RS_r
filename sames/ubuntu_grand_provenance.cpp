#include "ubuntu_grand_provenance.h"

#include <cstdio>
#include <cstring>

static bool present(const char *s) {
    return s != nullptr && *s != '\0';
}

extern "C" int ug_validate_record(const ug_provenance_record *record) {
    if (!record) return 1;
    if (!present(record->artifact_id) || !present(record->release)) return 2;
    if (!present(record->sha256) || !present(record->observed_at_utc)) return 3;
    if (!present(record->actor) || !present(record->evidence_ref)) return 4;
    if (!present(record->jurisdiction) || !present(record->custody_status)) return 5;
    return 0;
}

extern "C" int ug_fingerprint(const ug_provenance_record *record,
                               char *output,
                               uint64_t output_size) {
    if (!output || output_size == 0 || ug_validate_record(record) != 0) return 1;

    /*
     * Deterministic canonical representation for hand-off to the repository's
     * cryptographic layer. We deliberately do not implement a replacement for
     * SHA-256 here.
     */
    const int needed = std::snprintf(
        output, static_cast<size_t>(output_size),
        "%s|%s|%s|%s|%s|%s|%s|%s",
        record->artifact_id, record->release, record->sha256,
        record->observed_at_utc, record->actor, record->jurisdiction,
        record->custody_status, record->evidence_ref);

    if (needed < 0 || static_cast<uint64_t>(needed) >= output_size) {
        if (output_size) output[0] = '\0';
        return 2;
    }
    return 0;
}
