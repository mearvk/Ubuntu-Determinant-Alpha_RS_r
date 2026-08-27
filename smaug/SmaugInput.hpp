#ifndef SMAUG_INPUT_HPP
#define SMAUG_INPUT_HPP
#include "SmaugAtom.hpp"
#include <string>
namespace smaug::input {
struct Feed { atom::State state; std::string source; };
Feed from_json(const std::string& text);
Feed from_xml(const std::string& text);
std::string review_terminal(const atom::State& state);
}
#endif
