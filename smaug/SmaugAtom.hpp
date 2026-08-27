#ifndef SMAUG_ATOM_HPP
#define SMAUG_ATOM_HPP
#include <cstdint>
namespace smaug::atom {
struct State { double spin{0.0}; double preserved_spin{0.0}; double sphere_radius{1.0}; double mass{1.0}; double unitness{1.0}; double heart_size{1.0}; double universe_mass{0.0}; double heart_universe_mass{0.0}; std::uint64_t nutrition_id{0}; std::uint32_t effect_level{0}; double despair{0.0}; bool ended{false}; };
struct Strike { enum class Mode : std::uint8_t { Instant=0, LongClassic=1 }; Mode mode{Mode::Instant}; double intensity{0.0}; double duration_hours{0.0}; };
State apply_strike(const State& state, const Strike& strike);
}
#endif
