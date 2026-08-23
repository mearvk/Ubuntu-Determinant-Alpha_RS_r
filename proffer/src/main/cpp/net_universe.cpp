#include "net_universe.hpp"
#include <cmath>

namespace proffer {
Vec3 memory_fall(const MemoryObject& object, std::int64_t tick) {
    const auto age = std::max<std::int64_t>(0, tick - object.born_tick);
    return {object.position.x, object.position.y, object.position.z - static_cast<double>(age)};
}

ProcessDiagonal diagonalize(Vec3 ram, Vec3 processor, double process_time) {
    return {ram, processor, process_time};
}
}
