#ifndef SMAUG_OVERTINE_HPP
#define SMAUG_OVERTINE_HPP

#include <cstdint>
#include <string>

namespace smaug::overtine {

inline constexpr std::uint32_t kMaxDimensions = 5;
inline constexpr std::uint32_t kMaxStrandSignatures = 1112;
inline constexpr std::uint64_t kMaxCoilLengths = 1112221ULL;

enum class Phase : std::uint8_t { Before, During, After };
enum class CompanionMode : std::uint8_t { Constantine, Reign, BetterBe, BetterCompanionBe };

struct AxialState {
    std::uint32_t dimensions{3};
    std::uint32_t strand_signatures{0};
    std::uint64_t coil_length{0};
    std::uint64_t unit{0};
    bool coaxial{false};
};

struct CompanionCall {
    CompanionMode mode{CompanionMode::Constantine};
    Phase phase{Phase::Before};
    AxialState state{};
    std::string identity;
};

struct Assessment {
    bool ordered{true};
    bool bounded{true};
    bool stable{true};
    bool review_required{false};
    std::string reason;
};

Assessment assess(const CompanionCall& call);

} // namespace smaug::overtine

#endif /* SMAUG_OVERTINE_HPP */
