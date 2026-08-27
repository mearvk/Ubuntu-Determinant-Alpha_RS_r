#include "SmaugCompanions.hpp"

static double clamp01(double value) {
    if (value < 0.0) return 0.0;
    if (value > 1.0) return 1.0;
    return value;
}

static SmaugCompanionAssessment assessment(double primary,
                                           double secondary,
                                           double uncertainty) {
    SmaugCompanionAssessment a;
    a.emerald_score = clamp01(primary);
    a.strike_readiness = clamp01(secondary);
    a.wanderer_score = clamp01((primary + secondary) * 0.5);
    a.uncertainty = clamp01(uncertainty);
    a.review_required = a.uncertainty > 0.35;
    return a;
}

SmaugCompanionAssessment smaug_emerald_strike_pick(double emerald_signal,
                                                   double coverage,
                                                   double uncertainty) {
    return assessment(emerald_signal, coverage, uncertainty);
}

SmaugCompanionAssessment smaug_wanderer_mid_pick(double exploration,
                                                 double evidence,
                                                 double uncertainty) {
    return assessment(evidence, exploration, uncertainty);
}

SmaugCompanionAssessment smaug_prestrike_thoughtfulness(double evidence,
                                                        double reversibility,
                                                        double uncertainty) {
    return assessment(evidence, reversibility, uncertainty);
}
