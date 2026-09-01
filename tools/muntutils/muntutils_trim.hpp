/*
 * muntutils_trim.hpp - C++17 source-analysis, reachability, and trimming
 * engine interface for the muntutils tool.
 *
 * The engine reads C and C++ source files with a pragmatic heuristic scanner
 * (it is not a full compiler), builds a call and reference graph, computes a
 * conservative reachable set from a set of roots, and emits a slimmed copy of
 * the tree with confidently dead functions stubbed. It calls the C11 core in
 * muntutils_fs.h through extern "C" for filesystem measurement and walking.
 *
 * Safety philosophy of this repository is inspect, plan, authorize, apply,
 * verify. A default run never overwrites or deletes originals. See the trim
 * options below for the in-place opt-in and its mandatory backup step.
 *
 * Provenance: part of the MEARVK Ubuntu.Determinant.Beta.Restricted tool set.
 * The provenance framing identifies build origin only. It is not a legal
 * ownership, fiduciary, or execution authorization claim.
 *
 * Program based on Science at NCSU - Max Rupplin - MEARVK LLC 2026.
 */
#ifndef MUNTUTILS_TRIM_HPP
#define MUNTUTILS_TRIM_HPP

#include <cstdint>
#include <string>
#include <vector>

namespace muntutils {

// Options controlling a trim operation.
struct TrimOptions {
    std::string src_tree;         // required: root of the source tree to analyze
    std::string out_dir;          // required unless in_place: slim tree destination
    bool in_place = false;        // rewrite originals in place (backs up first)
    bool strict = false;          // treat non-static functions as trimmable
};

// A construct the static scanner could not fully resolve. These are the honest
// limits of heuristic analysis and are surfaced in the report.
struct Unresolved {
    std::string file;
    std::string detail;
};

// One function definition discovered by the scanner.
struct FunctionInfo {
    std::string name;
    std::string file;      // relative path within the tree
    bool is_static = false;
    bool reachable = false;
    bool address_taken = false;
    size_t name_offset = 0; // byte offset of the name token in its file
    size_t body_begin = 0;  // byte offset of the definition start in the file
    size_t body_end = 0;    // byte offset just past the closing brace
};

// Summary produced by a trim run, used by both the console output and report.
struct TrimResult {
    uint64_t files_scanned = 0;
    uint64_t functions_found = 0;
    uint64_t functions_reachable = 0;
    uint64_t functions_dead = 0;
    uint64_t functions_stubbed = 0;
    double confidence = 1.0;              // 0.0 to 1.0, tree-wide estimate
    std::vector<Unresolved> unresolved;   // things the scanner could not resolve
    std::vector<std::string> dead_names;  // names classified as dead
    std::vector<std::string> backups;     // .bak files created (in-place mode)
    bool ok = false;
};

// Analyze src_tree and emit a slimmed representation according to opts.
// Returns true on success. On any safety violation (missing out dir without
// in-place, or a backup that cannot be created) it fails safely and returns
// false with an explanation appended to error.
bool run_trim(const TrimOptions &opts, TrimResult &result, std::string &error);

} // namespace muntutils

#endif // MUNTUTILS_TRIM_HPP
