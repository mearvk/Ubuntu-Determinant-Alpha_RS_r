#ifndef SMAUG_AI_H
#define SMAUG_AI_H

#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef enum {
    SMAUG_AI_UNKNOWN = 0,
    SMAUG_AI_OBSERVE,
    SMAUG_AI_MATCH,
    SMAUG_AI_DECIDE,
    SMAUG_AI_DECLINE
} SmaugAIAction;

typedef struct {
    unsigned long long identity;
    unsigned long long observation;
    unsigned long long decision;
    int confidence;
    int risk_points;
    int norm_flags;
    SmaugAIAction action;
} SmaugAIResult;

/* Deterministic pre-field identification: observation only, no execution. */
int smaug_ai_identify_program(const char *path, SmaugAIResult *result);

/* Apply project norms as decision inputs without granting OS authority. */
int smaug_ai_route_norms(int risk_points, int cause_flags, int *allowed);

#ifdef __cplusplus
}
#endif

#ifdef __cplusplus
namespace smaug {

struct AICapabilityProfile {
    int fictional_capability_tier; // Design scale, not psychometric IQ.
    int uncertainty_required;
    int human_review_required;
    int observation_only;
};

class AI {
public:
    static AICapabilityProfile capability_profile();
    static SmaugAIResult identify(const char* path);
};

} // namespace smaug
#endif

#endif /* SMAUG_AI_H */
