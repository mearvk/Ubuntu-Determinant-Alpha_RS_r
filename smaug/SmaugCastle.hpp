#ifndef SMAUG_CASTLE_HPP
#define SMAUG_CASTLE_HPP

#include <cstdint>
#include <string>

namespace smaug::castle {

/*
 * STRONG CASTLE / INCLARE CONTRACT
 *
 * Castle protects Smaug's internal state while permitting deliberate,
 * observable interaction with an external program or opponent.
 * "Inclare" is a project term: define the inside from the inside-out,
 * expose only an intentional interface, and preserve internal invariants.
 *
 * External input may inform, challenge, or trigger reevaluation. It may not
 * silently redefine internal state or authority.
 */

enum class Boundary : std::uint8_t {
    Unknown = 0,
    Internal,
    Interface,
    External
};

enum class Decision : std::uint8_t {
    Observe = 0,
    Review,
    Permit,
    Deny,
    RequireHumanReview
};

struct InternalState {
    std::uint64_t generation{0};
    std::uint64_t invariant_hash{0};
    bool authority_intact{true};
    bool evidence_preserved{true};
};

struct OpponentObservation {
    Boundary boundary{Boundary::External};
    std::string identity;
    std::string claim;
    std::uint64_t observation_id{0};
};

struct CastleAssessment {
    Decision decision{Decision::Observe};
    bool inclare_holds{true};
    bool boundary_intact{true};
    bool reversible{true};
    std::string reason;
};

/* Establish the protected inside before evaluating external input. */
InternalState establish_internal_state(const InternalState& prior);

/* Evaluate an external/opponent observation without granting it authority. */
CastleAssessment assess_opponent(const InternalState& state,
                                 const OpponentObservation& observation);

/* True only when an external transition preserves the INCLARE invariant. */
bool inclare_preserved(const InternalState& state,
                       const OpponentObservation& observation);

} // namespace smaug::castle

#endif /* SMAUG_CASTLE_HPP */
