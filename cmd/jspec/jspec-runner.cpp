#include "jspec-runner.h"
#include <stdexcept>
#include <string>
#include <utility>
#include <vector>

namespace jspec {
class Runner {
public:
    explicit Runner(std::string target) : target_(std::move(target)) {}
    jspec_runner_format identify() const { return jspec_runner_identify(target_.c_str()); }
    void launch(const std::vector<std::string>& arguments) const {
        std::vector<char*> argv;
        argv.reserve(arguments.size() + 2);
        argv.push_back(const_cast<char*>(target_.c_str()));
        for (const auto& argument : arguments) argv.push_back(const_cast<char*>(argument.c_str()));
        argv.push_back(nullptr);
        jspec_runner_request request{};
        request.target = target_.c_str();
        request.argv = argv.data();
        request.envp = nullptr;
        request.working_directory = nullptr;
        if (jspec_runner_launch(&request) != 0) throw std::runtime_error("JSpec runner launch failed");
    }
private:
    std::string target_;
};
} // namespace jspec

/* The C++ layer adds no runtime machinery; C remains the OS handoff boundary. */
