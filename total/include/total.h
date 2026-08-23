#ifndef TOTAL_H
#define TOTAL_H

#include <stdint.h>
#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct total_config {
    const char *path;
    uint32_t poll_interval_ms;
    uint64_t soft_memory_limit_bytes;
    uint64_t hard_memory_limit_bytes;
    int observe_descriptors;
    int allow_jvm_assist;
} total_config_t;

typedef struct total_memory_snapshot {
    uint64_t process_bytes;
    uint64_t resident_bytes;
    uint64_t virtual_bytes;
    uint64_t soft_limit_bytes;
    uint64_t hard_limit_bytes;
} total_memory_snapshot_t;

int total_config_load(const char *path, total_config_t *out);
int total_memory_snapshot(total_memory_snapshot_t *out);
int total_memory_admit(uint64_t requested_bytes);
void total_memory_release(uint64_t released_bytes);
int total_service_run(const total_config_t *config);

#ifdef __cplusplus
}
#endif

#endif /* TOTAL_H */
