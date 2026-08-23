#ifndef SECUREJDK_AWARENESS_H
#define SECUREJDK_AWARENESS_H

#include "net_universe.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct {
    uint32_t abi_version;
    double net_center;
    uint32_t feature_flags;
} ProfferAwareness;

enum {
    PROFFER_AWARE_3D_SPACE = 1u << 0,
    PROFFER_AWARE_MEMORY_TIME = 1u << 1,
    PROFFER_AWARE_PROCESS_DIAGONAL = 1u << 2,
    PROFFER_AWARE_FIELTER = 1u << 3,
    PROFFER_AWARE_PROFFER = 1u << 4
};

ProfferAwareness proffer_securejdk_awareness(void);
int proffer_validate_awareness(ProfferAwareness awareness);

#ifdef __cplusplus
}
#endif

#endif
