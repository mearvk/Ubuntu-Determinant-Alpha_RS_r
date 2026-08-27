#ifndef SMAUG_INPUT_HPP
#define SMAUG_INPUT_HPP

#include "SmaugAtom.hpp"
#include <cstddef>
#include <string>

namespace smaug::input {

inline constexpr std::size_t kMaxInputBytes = 4u * 1024u * 1024u;

struct FeedResult {
    bool accepted{false};
    std::string normalized;
    std::string error;
};

struct TerminalReview {
    std::string event;
    std::string evidence_digest;
    std::string decision;
    bool requires_human_review{true};
};

FeedResult feed_json(const std::string& text);
FeedResult feed_xml(const std::string& text);
FeedResult feed_json_file(const std::string& path);
FeedResult feed_xml_file(const std::string& path);
TerminalReview make_terminal_review(const std::string& event,
                                    const std::string& evidence_digest,
                                    const std::string& decision);

} // namespace smaug::input

#endif /* SMAUG_INPUT_HPP */
