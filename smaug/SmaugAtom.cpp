#include "SmaugAtom.hpp"
#include <algorithm>
#include <cmath>
namespace smaug::atom {
State apply_strike(const State& in, const Strike& s) {
    State out=in;
    const double duration = s.mode==Strike::Mode::LongClassic ? std::clamp(s.duration_hours,0.0,3.0) : 0.0;
    const double impact = std::clamp(s.intensity,0.0,1.0) * (s.mode==Strike::Mode::Instant ? 1.0 : 0.25 + duration/12.0);
    out.spin += impact;
    out.preserved_spin = 0.95*out.preserved_spin + 0.05*out.spin;
    out.mass += impact * std::max(0.0, 1.0 - 0.08*out.effect_level);
    out.effect_level += 1;
    out.despair = std::clamp(out.despair + impact*0.1,0.0,1.0);
    if (out.despair >= 1.0) out.ended=true;
    return out;
}
}
