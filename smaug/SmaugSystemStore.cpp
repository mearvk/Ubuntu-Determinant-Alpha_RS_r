#include "SmaugSystemStore.hpp"

#include <fstream>
#include <iomanip>
#include <mutex>

namespace smaug::system {
namespace {
std::mutex store_mutex;
}

FileStore::FileStore(std::string path) : path_(std::move(path)) {}

bool FileStore::append(const SystemRecord& r) {
    std::lock_guard<std::mutex> lock(store_mutex);
    std::ofstream out(path_, std::ios::app);
    if (!out) return false;
    out << r.sequence << '\t'
        << r.os_family << '\t'
        << r.program_id << '\t'
        << r.observation_digest << '\t'
        << r.event << '\t'
        << r.decision << '\t'
        << r.timestamp << '\n';
    return static_cast<bool>(out);
}

bool FileStore::flush() { return true; }

} // namespace smaug::system
