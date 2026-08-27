#include "SmaugInputSource.hpp"

namespace smaug::input {

SourceAssessment assess(const SourceInput& input) {
    SourceAssessment result;
    result.identity_present = !input.identity.empty();
    result.payload_present = !input.payload.empty();

    if (!result.identity_present || !result.payload_present) {
        result.acceptance = Acceptance::Review;
        result.reason = "Input requires identity and payload before acceptance";
        return result;
    }

    /* Player and Overtine are both valid sources of input; neither becomes
       Smaug authority merely by supplying a request. */
    result.acceptance = Acceptance::Accept;
    result.authority_granted = false;
    result.reason = input.source == Source::Player
        ? "Player input accepted as bounded observation/request"
        : "Overtine input accepted as bounded companion request";
    return result;
}

} // namespace smaug::input
