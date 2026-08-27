#include "SmaugCastle.hpp"

#include <functional>

namespace smaug::castle {

InternalState establish_internal_state(const InternalState& prior) {
    InternalState next = prior;
    ++next.generation;
    next.authority_intact = true;
    next.evidence_preserved = true;
    return next;
}

bool inclare_preserved(const InternalState& state,
                       const OpponentObservation& observation) {
    if (!state.authority_intact || !state.evidence_preserved)
        return false;

    /* An observation is information, not authority. */
    if (observation.boundary != Boundary::External)
        return false;

    return true;
}

CastleAssessment assess_opponent(const InternalState& state,
                                 const OpponentObservation& observation) {
    CastleAssessment result;
    result.inclare_holds = inclare_preserved(state, observation);
    result.boundary_intact = state.authority_intact;
    result.reversible = state.evidence_preserved;

    if (!result.inclare_holds) {
        result.decision = Decision::RequireHumanReview;
        result.reason = "INCLARE invariant or internal control boundary failed";
        return result;
    }

    /* Castle observes first. No external claim is itself an authorization. */
    result.decision = Decision::Review;
    result.reason = "External observation retained outside protected internal authority";
    return result;
}

} // namespace smaug::castle
