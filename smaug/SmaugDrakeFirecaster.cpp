#include "SmaugDrakeFirecaster.hpp"
namespace smaug::drake {
FirecasterRoll resolve(std::int32_t die_one, std::int32_t die_two, std::int32_t perch_rank) {
    FirecasterRoll r;
    r.die_one = die_one < 1 ? 1 : (die_one > kDieSides ? kDieSides : die_one);
    r.die_two = die_two < 1 ? 1 : (die_two > kDieSides ? kDieSides : die_two);
    r.perch_rank = perch_rank < 0 ? 0 : perch_rank;
    r.hit_dice = kBaseHitDice + r.perch_rank * kPerchRankHitDice;
    r.total = r.die_one + r.die_two + r.hit_dice;
    return r;
}
}
