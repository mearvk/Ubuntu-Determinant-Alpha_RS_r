#ifndef SMAUG_SMITE_HPP
#define SMAUG_SMITE_HPP

#include <cstdint>
#include <string>

namespace smaug::smite {

/*
 * SMITE: a modest decision-awareness envelope.
 * It observes the immediate context just-before, just-during, and
 * immediately-after a decision. It does not itself grant authority.
 *
 * Terminology:
 *   SMITH = prepared decision context.
 *   SMOTE = the completed decision event/record.
 *   COLD  = an intentionally neutral observation state.
 *   HIT   = the decision boundary/event being evaluated.
 */
enum class Phase : std::uint8_t {
    Smith = 0,
    Hit,
    Smote,
    Cold
};

struct Awareness {
    Phase phase{Phase::Cold};
    std::uint64_t decision_id{0};
    std::uint64_t sequence{0};
    bool system_ready{false};
    bool authority_intact{true};
    bool external_input_present{false};
    bool outcome_recorded{false};
    std::string note;
};

/* Establish the just-before state. */
Awareness smith(std::uint64_t decision_id, std::uint64_t sequence);

/* Mark the decision boundary without changing authority. */
Awareness hit(const Awareness& before, const std::string& note = {});

/* Record the immediately-after state. */
Awareness smote(const Awareness& during, const std::string& outcome);

/* Return to a neutral observation state. */
Awareness cold(const Awareness& prior);

/* Conservative update: no Smite transition can create authority. */
bool hit_preserves_control(const Awareness& state);

} // namespace smaug::smite

#endif /* SMAUG_SMITE_HPP */
