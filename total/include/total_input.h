#ifndef TOTAL_INPUT_H
#define TOTAL_INPUT_H

#include <stdint.h>
#include "total_domain.h"

#ifdef __cplusplus
extern "C" {
#endif

#define TOTAL_INPUT_MIN 3u
#define TOTAL_INPUT_MAX 1000u

typedef struct total_input_slot {
    uint32_t id;
    uint32_t enabled;
    total_domain_evidence evidence;
} total_input_slot;

typedef struct total_input_registry {
    total_input_slot *slots;
    uint32_t capacity;
    uint32_t active;
} total_input_registry;

int total_input_registry_init(total_input_registry *registry,
                              total_input_slot *storage,
                              uint32_t capacity);
int total_input_register(total_input_registry *registry,
                         uint32_t id,
                         const total_domain_evidence *evidence);
int total_input_disable(total_input_registry *registry, uint32_t id);

#ifdef __cplusplus
}
#endif

#endif
