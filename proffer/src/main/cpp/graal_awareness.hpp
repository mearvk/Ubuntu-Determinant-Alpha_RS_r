#pragma once

#include "net_universe.hpp"
#include <cstdint>

namespace proffer {

struct GraalAwareness {
    std::uint32_t abi_version{1};
    double net_center{2.0};
    std::uint32_t feature_flags{0};

    bool understands_3d_space() const noexcept;
    bool understands_memory_time() const noexcept;
    bool understands_fielter() const noexcept;
    bool understands_proffer() const noexcept;
    bool valid() const noexcept;
};

GraalAwareness graal_awareness();

}
