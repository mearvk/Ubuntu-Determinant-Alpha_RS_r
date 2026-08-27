#include "SmaugWanderer.hpp"

#include <algorithm>

namespace smaug::wanderer {

Wanderer level4_profile() {
    Wanderer w;
    w.level = Level::Level4;
    w.habits = {Habit::Observe, Habit::Explore, Habit::Compare,
                Habit::Preserve, Habit::Revisit, Habit::Commit, Habit::Retreat};
    w.picks = {Pick::Safe, Pick::Novel, Pick::Proven, Pick::Reversible,
               Pick::EvidenceRich, Pick::Review, Pick::None};
    for (auto& p : w.patterns) {
        p.observation = 1.0;
        p.exploration = 0.75;
        p.evidence = 0.90;
        p.novelty = 0.50;
        p.reversibility = 0.95;
        p.stability = 0.80;
        p.uncertainty = 0.20;
    }
    return w;
}

Pattern net_uniform(const Wanderer& w) {
    Pattern result{};
    if (w.patterns.empty()) return result;
    for (const auto& p : w.patterns) {
        result.observation += p.observation;
        result.exploration += p.exploration;
        result.evidence += p.evidence;
        result.novelty += p.novelty;
        result.reversibility += p.reversibility;
        result.stability += p.stability;
        result.uncertainty += p.uncertainty;
    }
    const double n = static_cast<double>(w.patterns.size());
    result.observation /= n;
    result.exploration /= n;
    result.evidence /= n;
    result.novelty /= n;
    result.reversibility /= n;
    result.stability /= n;
    result.uncertainty /= n;
    return result;
}

Pick choose_pick(const Wanderer& w, const Pattern& context) {
    if (context.uncertainty > 0.50) return Pick::Review;
    if (context.evidence >= 0.85 && context.reversibility >= 0.90)
        return Pick::EvidenceRich;
    if (context.reversibility >= 0.80) return Pick::Reversible;
    if (context.novelty >= 0.75) return Pick::Novel;
    if (context.stability >= 0.75) return Pick::Proven;
    if (w.level == Level::Level4) return Pick::Safe;
    return Pick::None;
}

} // namespace smaug::wanderer
