#ifndef XMC_ASYSMA_STANDALONE_H
#define XMC_ASYSMA_STANDALONE_H

#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ASYSMA_STANDALONE_MAGIC "ASYSMAEX"
#define ASYSMA_STANDALONE_VERSION 1u

typedef struct asysma_standalone_header {
    char magic[8];
    unsigned int version;
    unsigned int header_size;
    unsigned long long package_offset;
    unsigned long long package_size;
} asysma_standalone_header;

int asysma_standalone_validate(const unsigned char *data, size_t size);
int asysma_standalone_find_package(const unsigned char *data, size_t size,
                                   size_t *offset, size_t *length);

#ifdef __cplusplus
}
#endif

#endif
