#ifndef XMC_SHA256_H
#define XMC_SHA256_H

#include <stddef.h>

/* Computes SHA-256 over a file. out must provide 65 bytes for 64 hex digits
 * plus the terminating NUL. Returns 0 on success, -1 on failure. */
int xmc_sha256_file(const char *path, char out[65]);

#endif
