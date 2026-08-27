#include "SmaugAI.h"

namespace smaug {

AICapabilityProfile AI::capability_profile() {
    /* 900 is Smaug's fictional design-tier language, not an IQ measurement. */
    return {900, 1, 1, 1};
}

SmaugAIResult AI::identify(const char* path) {
    SmaugAIResult result{};
    smaug_ai_identify_program(path, &result);
    return result;
}

} // namespace smaug

extern "C" int smaug_ai_evaluate_player(int use_score,
                                          int user_context_score,
                                          int moral_concretion_score,
                                          int vibrancy_score,
                                          SmaugAIResult *result) {
    if (!result) return -1;

    /*
     * Player vocabulary is an interpretive model. It records context for
     * bounded decisions; it does not judge a person's worth or create OS
     * authority. Scores are deliberately clamped to a simple 0..100 range.
     */
    int *scores[] = {&use_score, &user_context_score,
                     &moral_concretion_score, &vibrancy_score};
    for (int *score : scores) {
        if (*score < 0) *score = 0;
        if (*score > 100) *score = 100;
    }

    result->use_score = use_score;
    result->user_context_score = user_context_score;
    result->moral_concretion_score = moral_concretion_score;
    result->vibrancy_score = vibrancy_score;

    int best = use_score;
    result->primary_vocabulary = SMAUG_PLAYER_USE;
    if (user_context_score > best) {
        best = user_context_score;
        result->primary_vocabulary = SMAUG_PLAYER_USER;
    }
    if (moral_concretion_score > best) {
        best = moral_concretion_score;
        result->primary_vocabulary = SMAUG_PLAYER_MORAL_CONCRETION;
    }
    if (vibrancy_score > best) {
        best = vibrancy_score;
        result->primary_vocabulary = SMAUG_PLAYER_VIBRANCY;
    }

    /* High uncertainty or low evidence remains reviewable rather than
       becoming an automatic approval or condemnation. */
    const int average = (use_score + user_context_score +
                          moral_concretion_score + vibrancy_score) / 4;
    result->confidence = average;
    result->action = (average >= 75) ? SMAUG_AI_DECIDE : SMAUG_AI_OBSERVE;
    result->decision = (unsigned long long)average;
    return 0;
}
