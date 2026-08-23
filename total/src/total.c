#define _GNU_SOURCE
#include "total.h"
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

static uint64_t g_reserved_bytes;
static total_config_t g_config;

static uint64_t read_vm_value(const char *wanted) {
    FILE *f = fopen("/proc/self/status", "r");
    char line[256];
    uint64_t value = 0;
    if (!f) return 0;
    while (fgets(line, sizeof(line), f)) {
        char key[128];
        unsigned long long kb;
        if (sscanf(line, "%127[^:]: %llu kB", key, &kb) == 2 && strcmp(key, wanted) == 0) {
            value = (uint64_t)kb * 1024ULL;
            break;
        }
    }
    fclose(f);
    return value;
}

int total_config_load(const char *path, total_config_t *out) {
    if (!out) return EINVAL;
    memset(out, 0, sizeof(*out));
    out->path = path;
    out->poll_interval_ms = 1000;
    out->observe_descriptors = 1;
    out->allow_jvm_assist = 1;
    if (!path) return 0;
    FILE *f = fopen(path, "r");
    if (!f) return errno;
    char line[256];
    while (fgets(line, sizeof(line), f)) {
        char key[128], value[128];
        if (sscanf(line, " %127[^=]= %127s", key, value) != 2) continue;
        if (!strcmp(key, "poll_interval_ms")) out->poll_interval_ms = strtoull(value, NULL, 10);
        else if (!strcmp(key, "soft_memory_limit_bytes")) out->soft_memory_limit_bytes = strtoull(value, NULL, 10);
        else if (!strcmp(key, "hard_memory_limit_bytes")) out->hard_memory_limit_bytes = strtoull(value, NULL, 10);
        else if (!strcmp(key, "observe_descriptors")) out->observe_descriptors = atoi(value) != 0;
        else if (!strcmp(key, "allow_jvm_assist")) out->allow_jvm_assist = atoi(value) != 0;
    }
    fclose(f);
    return 0;
}

int total_memory_snapshot(total_memory_snapshot_t *out) {
    if (!out) return EINVAL;
    memset(out, 0, sizeof(*out));
    out->resident_bytes = read_vm_value("VmRSS");
    out->virtual_bytes = read_vm_value("VmSize");
    out->process_bytes = out->resident_bytes;
    out->soft_limit_bytes = g_config.soft_memory_limit_bytes;
    out->hard_limit_bytes = g_config.hard_memory_limit_bytes;
    return 0;
}

int total_memory_admit(uint64_t requested_bytes) {
    total_memory_snapshot_t s;
    if (total_memory_snapshot(&s) != 0) return EIO;
    if (s.hard_limit_bytes && s.resident_bytes + g_reserved_bytes + requested_bytes > s.hard_limit_bytes)
        return ENOMEM;
    g_reserved_bytes += requested_bytes;
    return 0;
}

void total_memory_release(uint64_t released_bytes) {
    g_reserved_bytes = released_bytes >= g_reserved_bytes ? 0 : g_reserved_bytes - released_bytes;
}

int total_service_run(const total_config_t *config) {
    if (!config) return EINVAL;
    g_config = *config;
    for (;;) {
        total_memory_snapshot_t snapshot;
        (void)total_memory_snapshot(&snapshot);
        usleep((useconds_t)g_config.poll_interval_ms * 1000U);
    }
}
