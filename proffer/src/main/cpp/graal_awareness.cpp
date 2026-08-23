#include "graal_awareness.hpp"

namespace proffer {
namespace {
constexpr std::uint32_t SPACE = 1u << 0;
constexpr std::uint32_t MEMORY_TIME = 1u << 1;
constexpr std::uint32_t PROCESS_DIAGONAL = 1u << 2;
constexpr std::uint32_t FIELTER = 1u << 3;
constexpr std::uint32_t PROFFER = 1u << 4;
constexpr std::uint32_t REQUIRED = SPACE | MEMORY_TIME | PROCESS_DIAGONAL | FIELTER | PROFFER;
}

bool GraalAwareness::understands_3d_space() const noexcept { return (feature_flags & SPACE) != 0; }
bool GraalAwareness::understands_memory_time() const noexcept { return (feature_flags & MEMORY_TIME) != 0; }
bool GraalAwareness::understands_fielter() const noexcept { return (feature_flags & FIELTER) != 0; }
bool GraalAwareness::understands_proffer() const noexcept { return (feature_flags & PROFFER) != 0; }
bool GraalAwareness::valid() const noexcept {
    return abi_version == 1 && net_center == 2.0 && (feature_flags & REQUIRED) == REQUIRED;
}

GraalAwareness graal_awareness() {
    return {1, 2.0, REQUIRED};
}
}
