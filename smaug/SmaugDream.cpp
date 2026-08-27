#include <algorithm>
#include <chrono>
#include <cstdlib>
#include <iostream>
#include <thread>

namespace {
constexpr unsigned kMinTurns = 3;
constexpr unsigned kMaxTurns = 36;

unsigned bounded_turns(const char* value) {
    if (!value) return kMinTurns;
    char* end = nullptr;
    const unsigned long parsed = std::strtoul(value, &end, 10);
    if (end == value || *end != '\0') return kMinTurns;
    return static_cast<unsigned>(std::clamp(parsed, static_cast<unsigned long>(kMinTurns), static_cast<unsigned long>(kMaxTurns)));
}
}

int main(int argc, char** argv) {
    const unsigned turns = bounded_turns(argc > 1 ? argv[1] : nullptr);
    std::cout << "Smaug dream: entering bounded rest for " << turns << " turns.\n";
    for (unsigned turn = 1; turn <= turns; ++turn) {
        std::cout << "dream turn " << turn << "/" << turns << "\n";
        std::this_thread::sleep_for(std::chrono::milliseconds(1));
    }
    std::cout << "Smaug dream: complete; returning to Ready.\n";
    return 0;
}
