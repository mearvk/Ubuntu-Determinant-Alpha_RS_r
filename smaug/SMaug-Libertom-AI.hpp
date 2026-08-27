#ifndef SMAUG_LIBERTOM_AI_HPP
#define SMAUG_LIBERTOM_AI_HPP

#include "SmaugLibertom.hpp"

namespace smaug::libertom::ai {

// Small advisory module: converts reeducation evidence into a bounded choice.
// It does not authorize OS operations or override Castle/INCLARE.
LibertomDecision advise_elevation(const LibertomState& state,
                                  double reeducation_score);

} // namespace smaug::libertom::ai

#endif /* SMAUG_LIBERTOM_AI_HPP */
