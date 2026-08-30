#include "SmaugHerald.hpp"

namespace smaug::herald {

Event Herald::announce(const gate::Decision& decision) const {
    Event event;
    event.sequence = "observe->normalize->provenance->validate->assess->authorize->simulate->record";
    if (!gate::admissible(decision)) {
        event.message = "gate denied or routed to review; no protected-system mutation permitted";
        event.accepted = false;
        event.review = true;
    } else {
        event.message = "simulation proposal admitted; effect remains bounded to simulation state";
        event.accepted = true;
        event.review = decision.review_required;
    }
    events_.push_back(event);
    return event;
}

const std::vector<Event>& Herald::history() const noexcept { return events_; }

void Herald::clear() noexcept { events_.clear(); }

} // namespace smaug::herald
