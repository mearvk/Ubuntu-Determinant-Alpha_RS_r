#ifndef SMAUG_EMERALD_TURN_HPP
#define SMAUG_EMERALD_TURN_HPP

#include <cstdint>

namespace smaug::emerald {

inline constexpr std::uint32_t kEmeraldRollHitDice = 96;

struct EmeraldTurn {
    std::uint64_t turn_id{0};
    std::int64_t smaug_hit_dice{0};
    std::int64_t roll_hit_dice{kEmeraldRollHitDice};
    bool outruled{false};
    bool proposition{false};
};

// Applies the fixed Emerald Roll gain. This is a bounded game/simulation
// mechanic; it does not grant operating-system or administrative authority.
EmeraldTurn apply_roll(EmeraldTurn turn);

} // namespace smaug::emerald

#endif /* SMAUG_EMERALD_TURN_HPP */
