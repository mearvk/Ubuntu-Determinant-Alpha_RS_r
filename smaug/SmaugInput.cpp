#include "SmaugInput.hpp"

#include <algorithm>
#include <cctype>
#include <fstream>
#include <sstream>

namespace smaug::input {

namespace {
std::string read_all(const std::string& path) {
    std::ifstream file(path, std::ios::binary);
    if (!file) return {};
    std::ostringstream stream;
    stream << file.rdbuf();
    return stream.str();
}

bool has_size(const std::string& data) {
    return data.size() <= kMaxInputBytes;
}

std::string trim(std::string value) {
    auto not_space = [](unsigned char c) { return !std::isspace(c); };
    value.erase(value.begin(), std::find_if(value.begin(), value.end(), not_space));
    value.erase(std::find_if(value.rbegin(), value.rend(), not_space).base(), value.end());
    return value;
}
}

FeedResult feed_json_file(const std::string& path) {
    return feed_json(read_all(path));
}

FeedResult feed_xml_file(const std::string& path) {
    return feed_xml(read_all(path));
}

FeedResult feed_json(const std::string& data) {
    FeedResult result;
    if (!has_size(data)) { result.error = "JSON input exceeds bounded size"; return result; }
    const std::string s = trim(data);
    if (s.empty() || s.front() != '{' || s.back() != '}') {
        result.error = "JSON root must be an object";
        return result;
    }
    result.accepted = true;
    result.normalized = s;
    return result;
}

FeedResult feed_xml(const std::string& data) {
    FeedResult result;
    if (!has_size(data)) { result.error = "XML input exceeds bounded size"; return result; }
    const std::string s = trim(data);
    if (s.size() < 5 || s.front() != '<' || s.back() != '>') {
        result.error = "XML input does not have a valid document boundary";
        return result;
    }
    result.accepted = true;
    result.normalized = s;
    return result;
}

TerminalReview make_terminal_review(const std::string& event,
                                    const std::string& evidence_digest,
                                    const std::string& decision) {
    TerminalReview review;
    review.event = event;
    review.evidence_digest = evidence_digest;
    review.decision = decision;
    review.requires_human_review = true;
    return review;
}

} // namespace smaug::input
