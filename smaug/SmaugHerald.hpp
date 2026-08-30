#ifndef SMAUG_HERALD_HPP
#define SMAUG_HERALD_HPP

#include "SmaugGateStandards.hpp"
#include <cstdint>
#include <string>
#include <vector>

namespace smaug::herald {

enum class EventStatus : std::uint8_t {
    Accepted,
    Review,
    Denied,
    DependencyFailure,
    Invalid
};

struct Event {
    std::string sequence;
    std::string message;
    std::string subject;
    std::string reason;
    std::string provenance;
    std::string audit_token;
    std::uint64_t fingerprint{0};
    std::uint64_t sequence_number{0};
    bool accepted{false};
    bool review{true};
    EventStatus status{EventStatus::Invalid};
};

struct Configuration {
    bool retain_history{true};
    bool require_independent_evidence{true};
    bool fail_closed{true};
    std::size_t history_limit{4096};
};

class Herald {
public:
    Herald() = default;
    explicit Herald(Configuration configuration);

    Event announce(const gate::Decision& decision) const;
    std::vector<Event> announce_batch(const std::vector<gate::Decision>& decisions) const;
    bool verify(const Event& event) const noexcept;
    std::string render(const Event& event) const;
    const std::vector<Event>& history() const noexcept;
    void clear() noexcept;
    void configure(Configuration configuration) const;
    Configuration configuration() const noexcept;

private:
    mutable std::vector<Event> events_;
    mutable Configuration configuration_{};
    mutable std::uint64_t next_sequence_{1};
};

} // namespace smaug::herald
#endif
