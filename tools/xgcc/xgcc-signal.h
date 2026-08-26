#ifndef XGCC_SIGNAL_H
#define XGCC_SIGNAL_H

/* XGCC project-defined signal vocabulary.
 * Author: Max Rupplin - MEARVK LLC 2026
 */

enum xgcc_signal_class {
    XGCC_SIGNAL_CLOUD = 0,
    XGCC_SIGNAL_PERTINOUS = 1
};

const char *xgcc_signal_name(enum xgcc_signal_class signal);
int xgcc_signal_is_grave(enum xgcc_signal_class signal);

#endif
