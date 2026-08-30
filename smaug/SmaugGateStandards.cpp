#include "SmaugGateStandards.hpp"
#include <array>
#include <cstddef>

namespace smaug::gate {

namespace {
constexpr bool bounded(std::uint32_t value, std::uint32_t lo, std::uint32_t hi) noexcept {
    return value >= lo && value <= hi;
}
constexpr bool valid_stage(Stage stage) noexcept {
    return static_cast<unsigned>(stage) <= static_cast<unsigned>(Stage::Record);
}
constexpr bool valid_effect(Effect effect) noexcept {
    return effect == Effect::Firecaster || effect == Effect::BreathWeapon;
}
}

bool admissible(const Decision& decision) noexcept {
    if (!valid_stage(decision.stage)) return false;
    if (!valid_effect(decision.requested_effect)) return false;
    if (!bounded(decision.privilege, 3, 7)) return false;
    if (!decision.has_provenance) return false;
    if (!decision.protected_target) return false;
    return true;
}

const char* standard_name(std::size_t index) noexcept {
    static constexpr std::array<const char*, 12> names{{
        "identity", "provenance", "scope", "privilege", "integrity", "target",
        "intent", "simulation", "non-destructive", "audit", "review", "record"
    }};
    return names[index % names.size()];
}

} // namespace smaug::gate
