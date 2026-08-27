#include "SmaugEmerald.hpp"

#include <algorithm>
#include <cmath>

namespace smaug::emerald {

Router::Router(std::size_t neuron_count) {
    neuron_count = std::min(neuron_count, kMaxNeurons);
    neurons_.reserve(neuron_count);
    const std::size_t side = static_cast<std::size_t>(std::ceil(std::cbrt(
        static_cast<double>(std::max<std::size_t>(1, neuron_count)))));
    for (std::size_t i = 0; i < neuron_count; ++i) {
        const std::size_t x = i % side;
        const std::size_t y = (i / side) % side;
        const std::size_t z = i / (side * side);
        neurons_.push_back({i, {static_cast<double>(x), static_cast<double>(y),
                                static_cast<double>(z)}, 0.0, LifeState::Ready});
    }
}

void Router::step(FieldEntity& entity, const Vec3& direction) {
    if (entity.state == LifeState::Terminal || entity.moves_remaining <= 0) {
        entity.state = LifeState::Terminal;
        entity.moves_remaining = 0;
        return;
    }
    entity.state = LifeState::Moving;
    entity.compass.direction = direction;
    entity.compass.position.x += direction.x;
    entity.compass.position.y += direction.y;
    entity.compass.position.z += direction.z;
    ++entity.compass.time_unit;
    --entity.moves_remaining;
    entity.state = entity.moves_remaining == 0 ? LifeState::Exhausted : LifeState::Ready;
}

EmeraldAssessment Router::decide(const FieldEntity& entity, Token token, double coverage) const {
    EmeraldAssessment result;
    result.coverage = std::clamp(coverage, 0.0, 1.0);
    result.ready = entity.state == LifeState::Ready || entity.state == LifeState::Moving;
    if (entity.moves_remaining <= 0 || result.coverage >= 1.0) {
        result.decision = RouteDecision::Terminal;
        result.terminal = true;
        result.reason = "Modeled field coverage is complete or moves are exhausted";
        return result;
    }
    if (!result.ready) {
        result.decision = RouteDecision::Hold;
        result.reason = "Entity is not ready to move";
        return result;
    }
    result.decision = token == Token::An ? RouteDecision::An : RouteDecision::And;
    result.reason = token == Token::An ? "Single-link route selected" : "Joined-link route selected";
    return result;
}

ScheduleEntry Router::schedule(const FieldEntity& entity, const EmeraldAssessment& assessment) const {
    return {entity.compass.time_unit, entity.id, assessment.decision, assessment.reason};
}

} // namespace smaug::emerald
