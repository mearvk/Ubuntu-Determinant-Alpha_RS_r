#include "total_input.h"
#include <string.h>

int total_input_registry_init(total_input_registry *registry,
                              total_input_slot *storage,
                              uint32_t capacity) {
    if (registry == NULL || storage == NULL ||
        capacity < TOTAL_INPUT_MIN || capacity > TOTAL_INPUT_MAX) {
        return -1;
    }
    memset(storage, 0, sizeof(*storage) * capacity);
    registry->slots = storage;
    registry->capacity = capacity;
    registry->active = 0;
    return 0;
}

int total_input_register(total_input_registry *registry,
                         uint32_t id,
                         const total_domain_evidence *evidence) {
    uint32_t i;
    if (registry == NULL || registry->slots == NULL || evidence == NULL ||
        id >= registry->capacity) return -1;

    for (i = 0; i < registry->capacity; ++i) {
        if (registry->slots[i].enabled && registry->slots[i].id == id) {
            registry->slots[i].evidence = *evidence;
            return 0;
        }
    }

    registry->slots[id].id = id;
    registry->slots[id].enabled = 1;
    registry->slots[id].evidence = *evidence;
    ++registry->active;
    return 0;
}

int total_input_disable(total_input_registry *registry, uint32_t id) {
    if (registry == NULL || registry->slots == NULL ||
        id >= registry->capacity || !registry->slots[id].enabled) return -1;
    registry->slots[id].enabled = 0;
    if (registry->active > 0) --registry->active;
    return 0;
}
