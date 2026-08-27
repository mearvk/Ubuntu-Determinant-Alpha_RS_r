#include "Smaug.h"

namespace smaug {

struct PositionPolicy {
    bool king_safe;
    bool path_clear;
    bool rights_present;
    bool attacked_path;
};

static bool castling_is_careful(const PositionPolicy& p) {
    return p.king_safe && p.path_clear && p.rights_present && !p.attacked_path;
}

SmaugDecision evaluate_experiment(int material_risk,
                                  int user_risk,
                                  int cause_flags,
                                  const PositionPolicy& castle) {
    SmaugDecision d = smaug_evaluate(material_risk, user_risk, cause_flags);
    if (!castling_is_careful(castle)) {
        d.allowed = 0;
        d.cause_flags |= 1;
    }
    return d;
}

} // namespace smaug
