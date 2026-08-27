#ifndef SMAUG_COMPANIONS_H
#define SMAUG_COMPANIONS_H

#ifdef __cplusplus
extern "C" {
#endif

typedef struct {
    double emerald_score;
    double strike_readiness;
    double wanderer_score;
    double uncertainty;
    int review_required;
} SmaugCompanionAssessment;

SmaugCompanionAssessment smaug_emerald_strike_pick(double emerald_signal,
                                                   double coverage,
                                                   double uncertainty);
SmaugCompanionAssessment smaug_wanderer_mid_pick(double exploration,
                                                 double evidence,
                                                 double uncertainty);
SmaugCompanionAssessment smaug_prestrike_thoughtfulness(double evidence,
                                                        double reversibility,
                                                        double uncertainty);

#ifdef __cplusplus
}
#endif

#endif /* SMAUG_COMPANIONS_H */
