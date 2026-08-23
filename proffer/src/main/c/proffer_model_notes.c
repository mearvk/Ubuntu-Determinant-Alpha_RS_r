/*
 * SecureJDK/Graal native texture seed.
 *
 * This file deliberately contains no OS hooks and no privilege escalation.
 * It records the model vocabulary at the native boundary so an implementation
 * can later connect it to a platform-specific security/runtime adapter.
 */
#include "securejdk_awareness.h"

int proffer_native_quality_seed_is_complete(void) {
    return proffer_validate_awareness(proffer_securejdk_awareness());
}
