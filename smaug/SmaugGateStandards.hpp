#ifndef SMAUG_GATE_STANDARDS_HPP
#define SMAUG_GATE_STANDARDS_HPP

#include "SmaugAdminGate.hpp"
#include <cstddef>
#include <cstdint>
#include <string>
#include <string_view>

namespace smaug::gate {

using admin::Effect;

enum class Stage : std::uint8_t {
    Intake,
    Normalize,
    Provenance,
    Validate,
    Assess,
    Authorize,
    Simulate,
    Record
};

enum class Status : std::uint8_t {
    Allow,
    Deny,
    Review,
    DependencyFailure,
    Invalid
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
const char* stage_name_public(Stage stage) noexcept;
bool is_dependency_safe(const Decision& decision) noexcept;
bool is_independently_evidenced(const Decision& decision) noexcept;
bool is_protected_scope(const Decision& decision) noexcept;
std::uint64_t decision_fingerprint(const Decision& decision) noexcept;
std::string decision_summary(const Decision& decision);
std::size_t rule_count() noexcept;
const char* rule_name(std::size_t index) noexcept;
const char* rule_description(std::size_t index) noexcept;
bool rule_requires_provenance(std::size_t index) noexcept;
bool rule_protects_target(std::size_t index) noexcept;
bool rule_simulation_only(std::size_t index) noexcept;
std::uint32_t rule_minimum_privilege(std::size_t index) noexcept;
bool validate_subject(std::string_view subject) noexcept;
bool validate_reason(std::string_view reason) noexcept;
bool validate_provenance(std::string_view provenance) noexcept;
bool validate_privilege(std::uint32_t privilege) noexcept;
bool validate_stage(Stage stage) noexcept;
bool validate_effect(Effect effect) noexcept;
bool validate_dependency_chain(const Decision& decision) noexcept;
bool requires_review(const Decision& decision) noexcept;
bool fail_closed(const Decision& decision) noexcept;
std::string failure_reason(const Decision& decision);
std::string audit_token(const Decision& decision);

} // namespace smaug::gate
#endif
