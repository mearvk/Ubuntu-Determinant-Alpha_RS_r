#ifndef ASYSMA_TEC_H
#define ASYSMA_TEC_H

#include <stdint.h>

#define TEC_VERSION 1u
#define TEC_MAX_TRANSFER 65536u

typedef enum {
    TEC_ISOLATED = 0,
    TEC_NATIVE_TO_JAVA = 1,
    TEC_JAVA_TO_NATIVE = 2
} tec_flow_t;

typedef struct {
    uint32_t version;
    uint32_t operation;
    uint32_t permissions;
    uint32_t input_size;
    uint32_t output_size;
} tec_transfer_t;

int tec_validate(tec_flow_t flow, const tec_transfer_t *transfer);

#endif
