#ifndef SMAUG_SHIELD_HPP
#define SMAUG_SHIELD_HPP

#include <array>
#include <cstdint>

namespace smaug::shield {

enum class Layer : std::uint8_t { Shield1 = 0, Shield2, Shield3, Pragma1, Pragma2 };
enum class HabitDecision : std::uint8_t { Unknown = 0, Observe, Match, Review, Permit, Deny };

struct Node {
    double idea_weight{0.0};
    double evidence_weight{0.0};
    double practical_weight{0.0};
    double uncertainty{1.0};
};

struct Shield {
    Layer layer{Layer::Shield1};
    std::array<Node, 8> nodes{};
    double originality{0.0};
    double agreement{0.0};
    bool intact{true};
};

struct HabitPattern {
    std::array<Shield, 5> shields{};
    HabitDecision decision{HabitDecision::Unknown};
    double stability{0.0};
    std::uint64_t observations{0};
};

/* Three parallel AI shields and two pragmatic companion layers. */
HabitPattern build_pattern(const std::array<Shield, 5>& shields,
                           std::uint64_t observations);

/* Stable mid/basic decision habit; it never grants authority by itself. */
HabitDecision route_basic(const HabitPattern& pattern);

} // namespace smaug::shield

#endif /* SMAUG_SHIELD_HPP */
