#ifndef SMAUG_HERALD_HPP
#define SMAUG_HERALD_HPP

#include "SmaugGateStandards.hpp"
#include <string>
#include <vector>

namespace smaug::herald {

struct Event {
    std::string sequence;
    std::string message;
    bool accepted{false};
    bool review{true};
};

class Herald {
public:
    Event announce(const gate::Decision& decision) const;
    const std::vector<Event>& history() const noexcept;
    void clear() noexcept;
private:
    mutable std::vector<Event> events_;
};

} // namespace smaug::herald
#endif
