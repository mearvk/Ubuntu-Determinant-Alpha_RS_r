#pragma once
#include <cstdint>
#include <vector>

namespace proffer {
struct Vec3 { double x{}, y{}, z{}; };
struct MemoryObject { std::int64_t id{}; Vec3 position{}; double mass{}; std::int64_t born_tick{}; };
struct NetUniverse { double net_center{2.0}; double perfection_tolerance{0.0}; };
struct ProcessDiagonal { Vec3 start{}, end{}; double process_time{}; };

Vec3 memory_fall(const MemoryObject& object, std::int64_t tick);
ProcessDiagonal diagonalize(Vec3 ram, Vec3 processor, double process_time);
}
