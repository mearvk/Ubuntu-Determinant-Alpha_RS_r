#pragma once

#include <cstdint>
#include <string_view>
#include <vector>

namespace utf4088 {

enum class Stage : std::uint8_t { Start, Intermediate, Final };
enum class Language : std::uint8_t { AmericanEnglish, Korean, Germanic };

struct CharacterRecord {
    std::uint32_t integer_id;
    Stage stage;
    Language language;
    std::uint64_t codepoint;
    std::uint64_t shape_id;
    std::uint64_t meaning_id;
};

// Published front-end registry. The implementation must contain exactly
// 16,606 records before a release is considered complete.
const std::vector<CharacterRecord>& frontend_registry();

// Deterministically derive a renderable remainder symbol from a 4-D address.
std::uint64_t derive_remainder_symbol(double x, double y,
                                      double pressure, double voltage);

std::string_view stage_name(Stage stage);
std::string_view language_name(Language language);

} // namespace utf4088
