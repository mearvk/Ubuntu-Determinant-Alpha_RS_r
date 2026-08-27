#include "SmaugAI.h"

namespace smaug {

AICapabilityProfile AI::capability_profile() {
    /* 900 is Smaug's fictional design-tier language, not an IQ measurement. */
    return {900, 1, 1, 1};
}

SmaugAIResult AI::identify(const char* path) {
    SmaugAIResult result{};
    smaug_ai_identify_program(path, &result);
    return result;
}

} // namespace smaug
