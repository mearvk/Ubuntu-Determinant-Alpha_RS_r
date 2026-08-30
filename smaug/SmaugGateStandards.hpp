#ifndef SMAUG_GATE_STANDARDS_HPP
#define SMAUG_GATE_STANDARDS_HPP

#include "SmaugAdminGate.hpp"
#include <cstdint>
#include <cstddef>
#include <string>

namespace smaug::gate {

enum class Stage : std::uint8_t {
    Intake, Normalize, Provenance, Validate, Assess, Authorize, Simulate, Record
};

struct Decision {
    Stage stage{Stage::Intake};
    Effect requested_effect{Effect::None};
    std::uint32_t privilege{0};
    bool has_provenance{false};
    bool protected_target{false};
    bool review_required{true};
    std::string subject;
    std::string reason;
};

bool admissible(const Decision& decision) noexcept;
const char* standard_name(std::size_t index) noexcept;

} // namespace smaug::gate
#endif
