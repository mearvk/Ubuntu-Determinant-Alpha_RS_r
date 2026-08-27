#include "SmaugShield.hpp"

namespace smaug::shield {

HabitPattern build_pattern(const std::array<Shield, 5>& shields,
                           std::uint64_t observations) {
    HabitPattern pattern;
    pattern.shields = shields;
    pattern.observations = observations;
    double agreement = 0.0;
    double originality = 0.0;
    std::size_t intact = 0;
    for (const auto& shield : shields) {
        agreement += shield.agreement;
        originality += shield.originality;
        if (shield.intact) ++intact;
    }
    agreement /= static_cast<double>(shields.size());
    originality /= static_cast<double>(shields.size());
    pattern.stability = 0.5 * agreement + 0.5 * (static_cast<double>(intact) / shields.size());
    if (observations == 0) pattern.stability *= 0.5;
    pattern.decision = HabitDecision::Review;
    if (pattern.stability >= 0.75 && originality >= 0.5)
        pattern.decision = HabitDecision::Match;
    return pattern;
}

HabitDecision route_basic(const HabitPattern& pattern) {
    if (pattern.observations == 0) return HabitDecision::Observe;
    if (pattern.stability < 0.5) return HabitDecision::Review;
    return pattern.decision;
}

} // namespace smaug::shield
