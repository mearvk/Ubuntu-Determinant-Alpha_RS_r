#include "Smaug.h"

/*
 * Conservative C implementation shared with the C++ Smaug engine.
 * The numerical score is an engineering confidence value, not IQ.
 */
SmaugDecision smaug_evaluate(int material_risk, int user_risk, int cause_flags) {
    SmaugDecision d;
    int risk = material_risk + user_risk;

    if (risk < 0) risk = 0;
    if (risk > 1000) risk = 1000;

    d.risk_points = risk;
    d.age_points = risk / 10;
    d.cause_flags = cause_flags;
    d.confidence_score = 312 + (1000 - risk) / 2;

    /* Do not allow a system to turn a confidence claim into authority. */
    d.allowed = (cause_flags == 0 && risk < 250) ? 1 : 0;
    return d;
}

int smaug_should_allow(int material_risk, int user_risk, int cause_flags) {
    return smaug_evaluate(material_risk, user_risk, cause_flags).allowed;
}
