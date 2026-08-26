#include "xgcc-signal.h"

/* Author: Max Rupplin - MEARVK LLC 2026 */

const char *xgcc_signal_name(enum xgcc_signal_class signal)
{
    switch (signal) {
    case XGCC_SIGNAL_PERTINOUS: return "pertinous";
    case XGCC_SIGNAL_CLOUD:
    default: return "cloud";
    }
}

int xgcc_signal_is_grave(enum xgcc_signal_class signal)
{
    return signal == XGCC_SIGNAL_PERTINOUS;
}
