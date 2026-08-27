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

typedef enum {
    SMAUG_PLAYER_UNKNOWN = 0,
    SMAUG_PLAYER_USE,
    SMAUG_PLAYER_USER,
    SMAUG_PLAYER_MORAL_CONCRETION,
    SMAUG_PLAYER_VIBRANCY
} SmaugPlayerVocabulary;

typedef struct {
    unsigned long long identity;
    unsigned long long observation;
    unsigned long long decision;
    int confidence;
    int risk_points;
    int norm_flags;
    SmaugAIAction action;
    int use_score;
    int user_context_score;
    int moral_concretion_score;
    int vibrancy_score;
    SmaugPlayerVocabulary primary_vocabulary;
} SmaugAIResult;

/* Deterministic pre-field identification: observation only, no execution. */
int smaug_ai_identify_program(const char *path, SmaugAIResult *result);

/* Apply project norms as decision inputs without granting OS authority. */
int smaug_ai_route_norms(int risk_points, int cause_flags, int *allowed);

/* Interpret Player vocabulary as bounded decision inputs, never as authority. */
int smaug_ai_evaluate_player(int use_score,
                             int user_context_score,
                             int moral_concretion_score,
                             int vibrancy_score,
                             SmaugAIResult *result);

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
