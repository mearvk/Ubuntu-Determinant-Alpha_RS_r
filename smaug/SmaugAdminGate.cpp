#include "SmaugAdminGate.hpp"

namespace smaug::admin {

Result authorize(const Summon& summon, Effect requested) {
    Result result;
    result.effect = Effect::None;

    if (summon.sudo_level < 3) {
        result.reason = "sudo gate below level 3";
        return result;
    }
    if (summon.sudo_level > 7) {
        result.reason = "sudo gate exceeds modeled privilege ceiling";
        return result;
    }
    if (summon.protected_path.empty()) {
        result.reason = "protected path is required";
        return result;
    }
    if (!summon.whole_cloth || !summon.yard_evidence) {
        result.reason = "protected object provenance is incomplete";
        return result;
    }
    if (requested == Effect::None) {
        result.reason = "no effect requested";
        return result;
    }
    if (requested != Effect::Firecaster && requested != Effect::BreathWeapon) {
        result.reason = "effect is outside the administrative simulation vocabulary";
        return result;
    }

    /* Authorization is declarative. The gate has no filesystem write primitive.
       Firecaster/BreathWeapon remain simulation effects and never write, delete,
       encrypt, rename, chmod, chown, or otherwise alter the protected path. */
    result.permitted = true;
    result.effect = requested;
    result.reason = "simulation effect authorized; protected contents remain intact";
    return result;
}

} // namespace smaug::admin
