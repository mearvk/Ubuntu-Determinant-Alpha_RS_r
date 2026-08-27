#include "SmaugAI.h"

#include <stdint.h>
#include <stdio.h>
#include <string.h>

static unsigned long long fnv1a(const unsigned char *p, size_t n) {
    uint64_t h = UINT64_C(1469598103934665603);
    for (size_t i = 0; i < n; ++i) {
        h ^= p[i];
        h *= UINT64_C(1099511628211);
    }
    return h;
}

int smaug_ai_identify_program(const char *path, SmaugAIResult *result) {
    if (!path || !result) return 0;
    memset(result, 0, sizeof(*result));

    FILE *f = fopen(path, "rb");
    if (!f) return 0;

    unsigned char buf[4096];
    size_t n = fread(buf, 1, sizeof(buf), f);
    fclose(f);

    result->identity = fnv1a(buf, n);
    result->observation = result->identity;
    result->decision = result->identity;
    result->confidence = 312;
    result->action = SMAUG_AI_OBSERVE;
    result->norm_flags = 0;
    result->risk_points = 0;
    return 1;
}

int smaug_ai_route_norms(int risk_points, int cause_flags, int *allowed) {
    if (!allowed) return 0;
    if (risk_points < 0) risk_points = 0;
    if (risk_points > 1000) risk_points = 1000;
    *allowed = (cause_flags == 0 && risk_points < 250) ? 1 : 0;
    return 1;
}
