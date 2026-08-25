#ifndef XMC_ASYSMA_NATIVE_LAYOUT_H
#define XMC_ASYSMA_NATIVE_LAYOUT_H

#include <stdint.h>

#define ASYSMA_NATIVE_LAYOUT_VERSION 1u
#define ASYSMA_NATIVE_MAGIC "ASYSMAEX"

/* Common on-disk description. Native bootstrap code remains platform-specific. */
typedef struct asysma_native_layout {
    char magic[8];
    uint32_t version;
    uint32_t header_size;
    uint32_t target_os;
    uint32_t target_arch;
    uint64_t manifest_offset;
    uint64_t manifest_size;
    uint64_t payload_offset;
    uint64_t payload_size;
    uint64_t icon_offset;
    uint64_t icon_size;
} asysma_native_layout;

enum asysma_target_os {
    ASYSMA_OS_UNKNOWN = 0,
    ASYSMA_OS_LINUX = 1,
    ASYSMA_OS_WINDOWS = 2,
    ASYSMA_OS_MACOS = 3
};

#endif
