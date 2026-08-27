#include "SmaugEmeraldTurn.hpp"
#include <limits>

namespace smaug::emerald {

EmeraldTurn apply_roll(EmeraldTurn turn) {
    constexpr std::int64_t gain = static_cast<std::int64_t>(kEmeraldRollHitDice);
    if (turn.smaug_hit_dice > std::numeric_limits<std::int64_t>::max() - gain) {
        turn.smaug_hit_dice = std::numeric_limits<std::int64_t>::max();
    } else {
        turn.smaug_hit_dice += gain;
    }
    turn.roll_hit_dice = gain;
    return turn;
}

} // namespace smaug::emerald
