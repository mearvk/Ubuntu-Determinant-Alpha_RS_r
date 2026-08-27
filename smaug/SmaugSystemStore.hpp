#ifndef SMAUG_SYSTEM_STORE_HPP
#define SMAUG_SYSTEM_STORE_HPP

#include <cstdint>
#include <string>

namespace smaug::system {

struct SystemRecord {
    std::uint64_t sequence{0};
    std::string os_family;
    std::string program_id;
    std::string observation_digest;
    std::string event;
    std::string decision;
    std::string timestamp;
};

class Store {
public:
    virtual ~Store() = default;
    virtual bool append(const SystemRecord& record) = 0;
    virtual bool flush() = 0;
};

/* Portable local backend. It can be replaced by a MySQL-backed implementation. */
class FileStore final : public Store {
public:
    explicit FileStore(std::string path);
    bool append(const SystemRecord& record) override;
    bool flush() override;

private:
    std::string path_;
};

} // namespace smaug::system

#endif /* SMAUG_SYSTEM_STORE_HPP */
