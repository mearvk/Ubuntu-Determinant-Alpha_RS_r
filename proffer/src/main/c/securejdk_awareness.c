#include "securejdk_awareness.h"

ProfferAwareness proffer_securejdk_awareness(void) {
    ProfferAwareness a;
    a.abi_version = 1u;
    a.net_center = 2.0;
    a.feature_flags = PROFFER_AWARE_3D_SPACE |
                      PROFFER_AWARE_MEMORY_TIME |
                      PROFFER_AWARE_PROCESS_DIAGONAL |
                      PROFFER_AWARE_FIELTER |
                      PROFFER_AWARE_PROFFER;
    return a;
}

int proffer_validate_awareness(ProfferAwareness awareness) {
    const uint32_t required = PROFFER_AWARE_3D_SPACE |
                               PROFFER_AWARE_MEMORY_TIME |
                               PROFFER_AWARE_PROCESS_DIAGONAL |
                               PROFFER_AWARE_FIELTER |
                               PROFFER_AWARE_PROFFER;
    return awareness.abi_version == 1u &&
           awareness.net_center == 2.0 &&
           (awareness.feature_flags & required) == required;
}
