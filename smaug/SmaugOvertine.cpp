#include "SmaugOvertine.hpp"

namespace smaug::overtine {

Assessment assess(const CompanionCall& call) {
    Assessment result;
    result.bounded = call.state.dimensions > 0 &&
                     call.state.dimensions <= kMaxDimensions &&
                     call.state.strand_signatures <= kMaxStrandSignatures &&
                     call.state.coil_length <= kMaxCoilLengths;
    result.ordered = call.identity.size() <= kMaxStrandSignatures;
    result.stable = call.mode == CompanionMode::Constantine ||
                    call.mode == CompanionMode::Reign;
    result.review_required = !result.bounded || !result.ordered;
    result.reason = result.review_required
        ? "Overtine bounds or identity capacity require review"
        : "Bounded companion call is ready for controlled routing";
    return result;
}

} // namespace smaug::overtine
