#include <stdint.h>
#include <stdio.h>

/*
 * Safe experience prototype: the native side exposes a tiny C ABI.
 * It does not expose C++ object layouts or arbitrary process memory.
 */

int asysma_native_start(uint32_t version) {
    if (version != 1) return -1;
    puts("ASYSMA native layer: started");
    return 0;
}
