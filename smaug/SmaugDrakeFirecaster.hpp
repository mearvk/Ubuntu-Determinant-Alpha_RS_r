#ifndef SMAUG_DRAKE_FIRECASTER_HPP
#define SMAUG_DRAKE_FIRECASTER_HPP
#include <cstdint>
namespace smaug::drake {
inline constexpr std::int32_t kBaseHitDice = 48;
inline constexpr std::int32_t kDiceCount = 2;
inline constexpr std::int32_t kDieSides = 8;
inline constexpr std::int32_t kPerchRankHitDice = 72;
struct FirecasterRoll { std::int32_t die_one{0}; std::int32_t die_two{0}; std::int32_t perch_rank{0}; std::int32_t hit_dice{0}; std::int32_t total{0}; };
FirecasterRoll resolve(std::int32_t die_one, std::int32_t die_two, std::int32_t perch_rank);
}
#endif
