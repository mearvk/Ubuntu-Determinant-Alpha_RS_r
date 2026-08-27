#ifndef SMAUG_EMERALD_HPP
#define SMAUG_EMERALD_HPP

#include <cstddef>
#include <cstdint>
#include <string>
#include <vector>

namespace smaug::emerald {

/* Emerald is a bounded 3-D routing/simulation layer, not a weapon or agent
 * for acting against real people. "Death" below means terminal state in the
 * modeled system: an entity can lose all remaining moves and leave the field.
 */

inline constexpr std::size_t kMaxNeurons = 1048576;

struct Vec3 { double x{0.0}, y{0.0}, z{0.0}; };
struct Compass { Vec3 position; Vec3 direction; std::uint64_t time_unit{0}; std::string identity; };
enum class Token : std::uint8_t { An, And };
enum class LifeState : std::uint8_t { Ready, Moving, Exhausted, Terminal };
enum class RouteDecision : std::uint8_t { Observe = 0, An, And, Hold, Terminal };
struct Neuron { std::uint64_t id{0}; Vec3 position; double activation{0.0}; LifeState state{LifeState::Ready}; };
struct FieldEntity { std::uint64_t id{0}; std::string identity; Compass compass; std::int32_t moves_remaining{0}; LifeState state{LifeState::Ready}; };
struct ScheduleEntry { std::uint64_t time_unit{0}; std::uint64_t entity_id{0}; RouteDecision decision{RouteDecision::Observe}; std::string reason; };
struct EmeraldAssessment { RouteDecision decision{RouteDecision::Observe}; double coverage{0.0}; bool ready{false}; bool terminal{false}; std::string reason; };

class Router {
public:
    explicit Router(std::size_t neuron_count = 27);
    void step(FieldEntity& entity, const Vec3& direction);
    EmeraldAssessment decide(const FieldEntity& entity, Token token, double coverage) const;
    ScheduleEntry schedule(const FieldEntity& entity, const EmeraldAssessment& assessment) const;
    const std::vector<Neuron>& neurons() const noexcept { return neurons_; }
private:
    std::vector<Neuron> neurons_;
};

} // namespace smaug::emerald

#endif /* SMAUG_EMERALD_HPP */
