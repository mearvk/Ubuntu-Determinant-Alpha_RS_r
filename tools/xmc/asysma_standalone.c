#include "asysma_standalone.h"

#include <stdint.h>
#include <string.h>

static uint64_t read_u64(const unsigned char *p) {
    uint64_t v = 0;
    memcpy(&v, p, sizeof(v));
    return v;
}

static uint32_t read_u32(const unsigned char *p) {
    uint32_t v = 0;
    memcpy(&v, p, sizeof(v));
    return v;
}

int asysma_standalone_validate(const unsigned char *data, size_t size) {
    if (!data || size < sizeof(asysma_standalone_header)) return 0;
    if (memcmp(data, ASYSMA_STANDALONE_MAGIC, 8) != 0) return 0;
    if (read_u32(data + 8) != ASYSMA_STANDALONE_VERSION) return 0;
    uint32_t hs = read_u32(data + 12);
    uint64_t off = read_u64(data + 16);
    uint64_t len = read_u64(data + 24);
    if (hs < sizeof(asysma_standalone_header)) return 0;
    if (off < hs || off > size || len > size - off) return 0;
    return 1;
}

int asysma_standalone_find_package(const unsigned char *data, size_t size,
                                   size_t *offset, size_t *length) {
    if (!offset || !length || !asysma_standalone_validate(data, size)) return 0;
    *offset = (size_t)read_u64(data + 16);
    *length = (size_t)read_u64(data + 24);
    return 1;
}
