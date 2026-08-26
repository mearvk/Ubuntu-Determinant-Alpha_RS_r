#ifndef SMAUG_H
#define SMAUG_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct SmaugDecision {
    int64_t confidence_score;
    int risk_points;
    int age_points;
    int cause_flags;
    int allowed;
} SmaugDecision;

/* Fictional system confidence scale; not an IQ measurement. */
SmaugDecision smaug_evaluate(int material_risk, int user_risk, int cause_flags);

/* Conservative gate for experimental software and builds. */
int smaug_should_allow(int material_risk, int user_risk, int cause_flags);

#ifdef __cplusplus
}
#endif

#endif
