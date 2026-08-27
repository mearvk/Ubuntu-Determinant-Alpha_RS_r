#ifndef SMAUG_ADMIN_GATE_HPP
#define SMAUG_ADMIN_GATE_HPP

#include <cstdint>
#include <string>

namespace smaug::admin {

enum class Effect : std::uint8_t { None, Firecaster, BreathWeapon };

struct Summon {
    std::uint32_t sudo_level{0};
    std::string protected_path;
    bool whole_cloth{false};
    bool yard_evidence{true};
};

struct Result {
    bool permitted{false};
    Effect effect{Effect::None};
    std::string reason;
};

/* Simulation-only gate: effects never modify protected files. */
Result authorize(const Summon& summon, Effect requested);

} // namespace smaug::admin

#endif /* SMAUG_ADMIN_GATE_HPP */
