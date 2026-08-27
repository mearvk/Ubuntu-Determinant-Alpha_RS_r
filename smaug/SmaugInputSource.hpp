#ifndef SMAUG_INPUT_SOURCE_HPP
#define SMAUG_INPUT_SOURCE_HPP

#include <cstdint>
#include <string>

namespace smaug::input {

enum class Source : std::uint8_t { Player, Overtine };
enum class Acceptance : std::uint8_t { Observe, Accept, Review, Reject };

struct SourceInput {
    Source source{Source::Player};
    std::string identity;
    std::string payload;
    std::uint64_t sequence{0};
};

struct SourceAssessment {
    Acceptance acceptance{Acceptance::Review};
    bool identity_present{false};
    bool payload_present{false};
    bool authority_granted{false};
    std::string reason;
};

SourceAssessment assess(const SourceInput& input);

} // namespace smaug::input

#endif /* SMAUG_INPUT_SOURCE_HPP */
