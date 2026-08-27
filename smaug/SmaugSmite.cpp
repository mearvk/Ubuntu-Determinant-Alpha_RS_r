#include "SmaugSmite.hpp"

namespace smaug::smite {

Awareness smith(std::uint64_t decision_id, std::uint64_t sequence) {
    Awareness state;
    state.phase = Phase::Smith;
    state.decision_id = decision_id;
    state.sequence = sequence;
    state.system_ready = true;
    state.authority_intact = true;
    return state;
}

Awareness hit(const Awareness& before, const std::string& note) {
    Awareness state = before;
    state.phase = Phase::Hit;
    state.note = note;
    /* HIT marks the boundary; it never manufactures permission. */
    state.authority_intact = before.authority_intact;
    return state;
}

Awareness smote(const Awareness& during, const std::string& outcome) {
    Awareness state = during;
    state.phase = Phase::Smote;
    state.note = outcome;
    state.outcome_recorded = true;
    state.authority_intact = during.authority_intact;
    return state;
}

Awareness cold(const Awareness& prior) {
    Awareness state = prior;
    state.phase = Phase::Cold;
    state.external_input_present = false;
    state.note.clear();
    return state;
}

bool hit_preserves_control(const Awareness& state) {
    return state.authority_intact && state.decision_id != 0;
}

} // namespace smaug::smite
