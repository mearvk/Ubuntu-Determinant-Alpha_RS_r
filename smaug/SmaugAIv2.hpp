#ifndef SMAUG_AI_V2_HPP
#define SMAUG_AI_V2_HPP

#include <cstdint>
#include <string>
#include "SmaugCastle.hpp"

namespace smaug::ai {

struct ProgramIdentity {
    std::string path;
    std::string format;
    std::string hash;
    std::string architecture;
    std::string compiler;
    std::string version;
};

struct Observation {
    std::uint64_t id{0};
    ProgramIdentity program;
    std::string digest;
    bool executed{false};
};

struct Confidence {
    double confidence{0.0};
    double uncertainty{1.0};
    bool requires_review{true};
};

struct Inference {
    std::string conclusion;
    Confidence confidence;
    std::string model;
    std::string evidence_digest;
};

struct DecisionRecord {
    std::uint64_t observation_id{0};
    Inference inference;
    castle::Decision decision{castle::Decision::RequireHumanReview};
    bool castle_approved{false};
    std::string reason;
};

/* Fictional capability tier: implementation metadata, not a human IQ score. */
struct CapabilityProfile {
    std::uint32_t reasoning_tier{3000};
    std::uint32_t validation_passes{3};
    bool uncertainty_required{true};
    bool evidence_required{true};
};

class Engine {
public:
    explicit Engine(CapabilityProfile profile = {});
    Observation observe(const ProgramIdentity& program) const;
    Inference infer(const Observation& observation,
                    const std::string& model_name) const;
    DecisionRecord decide(const Observation& observation,
                          const Inference& inference,
                          const castle::InternalState& castle_state) const;
    const CapabilityProfile& capability() const noexcept { return profile_; }

private:
    CapabilityProfile profile_;
};

} // namespace smaug::ai

#endif /* SMAUG_AI_V2_HPP */
