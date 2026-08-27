#include "SMaug-Libertom-AI.hpp"

namespace smaug::libertom::ai {

LibertomDecision advise_elevation(const LibertomState& state,
                                  double reeducation_score) {
    return choose_elevation(state, reeducation_score);
}

} // namespace smaug::libertom::ai
