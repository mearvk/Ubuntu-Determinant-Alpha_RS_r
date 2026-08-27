#ifndef SMAUG_LIBERTOM_HPP
#define SMAUG_LIBERTOM_HPP

#include <cstdint>

namespace smaug::libertom {

inline constexpr double kBaseLibertom = 0.92;
inline constexpr double kStandardLibertom = 0.95;
inline constexpr double kElevatedLibertom = 0.96;
inline constexpr double kPeakLibertom = 0.98;
inline constexpr std::uint64_t kGraduationDieEvents = 1096;
inline constexpr std::uint64_t kPersistentOsMonths = 3000;

struct ScalePair {
    double careful{0.92};
    double reciprocal{0.92};
};

enum class Special3D : std::uint8_t {
    TradingTechnology = 0,
    Law,
    Scaffold,
    Mirror
};

enum class Elevation : std::uint8_t {
    Hold = 0,
    Consider,
    Elevate
};

struct LibertomState {
    double value{kStandardLibertom};
    ScalePair scales{};
    std::uint64_t die_events{0};
    std::uint64_t os_months{0};
    double reeducation{0.0};
    bool graduated{false};
    Elevation elevation{Elevation::Hold};
};

struct LibertomDecision {
    LibertomState state{};
    bool permitted{false};
    const char* reason{"Insufficient reeducation evidence"};
};

// Clamp the persistent Libertom state to the project's careful range.
LibertomState normalize(LibertomState state);

// Record reeducation and allow a bounded choice to elevate only when evidence
// is strong enough. This never grants OS authority.
LibertomDecision choose_elevation(LibertomState state, double reeducation_score);

// Apply a named 3-D special to the paired/binary-map scales.
LibertomState refold(LibertomState state, Special3D special);

} // namespace smaug::libertom

#endif /* SMAUG_LIBERTOM_HPP */
