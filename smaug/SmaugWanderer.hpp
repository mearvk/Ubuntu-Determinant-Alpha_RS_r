#ifndef SMAUG_WANDERER_HPP
#define SMAUG_WANDERER_HPP

#include <array>
#include <cstdint>
#include <string>

namespace smaug::wanderer {

enum class Level : std::uint8_t { Level1 = 1, Level2, Level3, Level4 };

enum class Habit : std::uint8_t {
    Observe = 0, Explore, Compare, Preserve, Revisit, Commit, Retreat
};

enum class Pick : std::uint8_t {
    None = 0, Safe, Novel, Proven, Reversible, EvidenceRich, Review
};

struct Pattern {
    double observation{0.0};
    double exploration{0.0};
    double evidence{0.0};
    double novelty{0.0};
    double reversibility{0.0};
    double stability{0.0};
    double uncertainty{1.0};
};

struct Wanderer {
    Level level{Level::Level4};
    std::array<Pattern, 8> patterns{};
    std::array<Habit, 7> habits{};
    std::array<Pick, 7> picks{};
    std::uint64_t observations{0};
    std::uint64_t moves_remaining{0};
};

/* Builds a bounded Level-4 exploration profile; it is a routing heuristic,
 * not a claim about a human being or a fixed personality. */
Wanderer level4_profile();

/* Produces a stable Net Uniform summary for system-level comparison. */
Pattern net_uniform(const Wanderer& wanderer);

/* Chooses a habit-level pick without bypassing Castle/INCLARE authority. */
Pick choose_pick(const Wanderer& wanderer, const Pattern& context);

} // namespace smaug::wanderer

#endif /* SMAUG_WANDERER_HPP */
