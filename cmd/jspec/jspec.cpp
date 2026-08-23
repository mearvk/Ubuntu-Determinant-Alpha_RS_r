#include "jspec.h"

#include <stdexcept>
#include <string>
#include <utility>
#include <vector>

namespace jspec {

class Executable {
public:
    explicit Executable(std::string path) : path_(std::move(path)) {}

    jspec_format format() const {
        return jspec_identify_format(path_.c_str());
    }

    int launch(const std::vector<std::string>& arguments) const {
        std::vector<char*> argv;
        argv.reserve(arguments.size() + 2);

        argv.push_back(const_cast<char*>(path_.c_str()));
        for (const auto& argument : arguments) {
            argv.push_back(const_cast<char*>(argument.c_str()));
        }
        argv.push_back(nullptr);

        jspec_request request{};
        jspec_result result{};
        request.target = path_.c_str();
        request.argv = argv.data();
        request.envp = nullptr;
        request.working_directory = nullptr;
        request.wait_for_exit = 0;

        if (jspec_launch(&request, &result) != 0) {
            throw std::runtime_error("JSpec executable launch failed");
        }
        return result.exit_code;
    }

private:
    std::string path_;
};

} // namespace jspec

/*
 * Linux v1 intentionally keeps policy and presentation above this native
 * boundary. A future desktop implementation can arm this object from a
 * .desktop launcher while retaining the exact same executable contract.
 */
