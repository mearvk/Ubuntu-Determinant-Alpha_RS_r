#include "tec.h"

int tec_validate(tec_flow_t flow, const tec_transfer_t *transfer) {
    if (!transfer || transfer->version != TEC_VERSION) return -1;
    if (transfer->input_size > TEC_MAX_TRANSFER ||
        transfer->output_size > TEC_MAX_TRANSFER) return -2;

    switch (flow) {
        case TEC_ISOLATED:
            return -3;
        case TEC_NATIVE_TO_JAVA:
        case TEC_JAVA_TO_NATIVE:
            return 0;
        default:
            return -4;
    }
}
