#include "SmaugAIv2.hpp"

#include <cstdint>
#include <sstream>
#include <string>

namespace smaug::ai {
namespace {

std::uint64_t stable_hash(const std::string& text) noexcept {
    std::uint64_t hash = 14695981039346656037ULL;
    for (const unsigned char byte : text) {
        hash ^= byte;
        hash *= 1099511628211ULL;
    }
    return hash;
}

} // namespace

Engine::Engine(CapabilityProfile profile) : profile_(profile) {}

Observation Engine::observe(const ProgramIdentity& program) const {
    Observation observation;
    observation.program = program;
    std::ostringstream material;
    material << program.path << '\n' << program.format << '\n'
             << program.hash << '\n' << program.architecture << '\n'
             << program.compiler << '\n' << program.version;
    const std::string canonical = material.str();
    observation.digest = std::to_string(stable_hash(canonical));
    observation.id = stable_hash(observation.digest);
    observation.executed = false;
    return observation;
}

Inference Engine::infer(const Observation& observation,
                        const std::string& model_name) const {
    Inference inference;
    inference.model = model_name;
    inference.evidence_digest = observation.digest;
    inference.conclusion = "Observation prepared for bounded model inference";
    inference.confidence.confidence = 0.0;
    inference.confidence.uncertainty = 1.0;
    inference.confidence.requires_review = true;
    return inference;
}

DecisionRecord Engine::decide(const Observation& observation,
                              const Inference& inference,
                              const castle::InternalState& castle_state) const {
    DecisionRecord record;
    record.observation_id = observation.id;
    record.inference = inference;

    if (!profile_.evidence_required || inference.evidence_digest != observation.digest) {
        record.decision = castle::Decision::RequireHumanReview;
        record.reason = "Evidence requirement failed";
        return record;
    }

    if (inference.confidence.requires_review ||
        inference.confidence.uncertainty > 0.5) {
        record.decision = castle::Decision::RequireHumanReview;
        record.reason = "Inference remains materially uncertain";
        return record;
    }

    castle::OpponentObservation external;
    external.boundary = castle::Boundary::External;
    external.identity = observation.program.path;
    external.claim = inference.conclusion;
    external.observation_id = observation.id;

    const auto assessment = castle::assess_opponent(castle_state, external);
    record.decision = assessment.decision;
    record.castle_approved = assessment.inclare_holds && assessment.boundary_intact;
    record.reason = assessment.reason;
    return record;
}

} // namespace smaug::ai
