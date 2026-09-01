/*
 * main.cpp - C++17 command line front end for the muntutils tool.
 *
 * muntutils is a single binary with two capabilities exposed as subcommands:
 *
 *   trim   Analyze a source tree, decide which functions are confidently dead
 *          under conservative reachability rules, and emit a slimmed copy. Safe
 *          by default: it never overwrites or deletes originals unless the
 *          explicit --in-place (alias --apply) flag is given, and even then it
 *          backs up each file to <file>.bak before rewriting it.
 *
 *   report Measure the raw source tree, an optional slimmed tree, and compiled
 *          artifacts, then write a dual-audience report. The report has a plain
 *          language summary for an ordinary adult reader and a detailed numbers
 *          section for a programmer.
 *
 * The measurement work is delegated to the C11 core in muntutils_fs.h through
 * its extern "C" API. The analysis and trimming live in the C++17 engine in
 * muntutils_trim.hpp. Both languages are genuinely used together here.
 *
 * Provenance: part of the MEARVK Ubuntu.Determinant.Beta.Restricted tool set.
 * The provenance framing identifies build origin only. It is not a legal
 * ownership, fiduciary, or execution authorization claim.
 *
 * Program based on Science at NCSU - Max Rupplin - MEARVK LLC 2026.
 */
#include "muntutils_fs.h"
#include "muntutils_trim.hpp"

#include <cstdint>
#include <cstdio>
#include <cstring>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>

#define MUNTUTILS_VERSION "1.00"

namespace {

std::string human(uint64_t bytes) {
    char buf[32];
    mu_human(bytes, buf, sizeof buf);
    return std::string(buf);
}

void print_usage(std::FILE *out) {
    std::fprintf(out,
        "usage: muntutils <command> [options]\n"
        "\n"
        "Commands:\n"
        "  trim <src-tree> --out <dir> [--in-place|--apply] [--strict]\n"
        "      Analyze the source tree and write a slimmed copy with confidently\n"
        "      dead functions removed. Safe by default: originals are never\n"
        "      changed unless --in-place (alias --apply) is given, and each file\n"
        "      rewritten in place is first backed up to <file>.bak.\n"
        "      --strict treats non-static functions as trimmable when unreferenced.\n"
        "\n"
        "  report <src-tree> [--slim <dir>] [--out <report>]\n"
        "      Measure raw source, optional slimmed source, and compiled\n"
        "      artifacts, then write a dual-audience text/markdown report.\n"
        "      Writes to <report> if given, otherwise to standard output.\n"
        "\n"
        "Options:\n"
        "  --help, -h       Show this help and exit.\n"
        "  --version, -V    Show the version (1.00) and exit.\n");
}

// Append the size stats for one tree into a report stream.
void write_stats_block(std::ostream &os, const char *label, const mu_stats &st) {
    os << "### " << label << "\n\n";
    if (!st.ok) {
        os << "Note: some entries under this tree could not be read; totals are partial.\n\n";
    }
    os << "| Category | Files | Bytes | Human |\n";
    os << "|----------|------:|------:|-------|\n";
    os << "| Source   | " << st.source.files << " | " << st.source.bytes
       << " | " << human(st.source.bytes) << " |\n";
    os << "| Artifact | " << st.artifact.files << " | " << st.artifact.bytes
       << " | " << human(st.artifact.bytes) << " |\n";
    os << "| Other    | " << st.other.files << " | " << st.other.bytes
       << " | " << human(st.other.bytes) << " |\n\n";
}

int cmd_report(const std::string &src, const std::string &slim,
               const std::string &out_path) {
    mu_stats raw;
    mu_measure_tree(src.c_str(), &raw);

    bool have_slim = !slim.empty();
    mu_stats slim_stats;
    std::memset(&slim_stats, 0, sizeof slim_stats);
    if (have_slim) mu_measure_tree(slim.c_str(), &slim_stats);

    // Source shrink estimate.
    uint64_t raw_src = raw.source.bytes;
    uint64_t slim_src = slim_stats.source.bytes;
    double pct = 0.0;
    if (have_slim && raw_src > 0 && slim_src <= raw_src) {
        pct = 100.0 * (double)(raw_src - slim_src) / (double)raw_src;
    }

    std::ostringstream os;
    os << "# muntutils source and artifact report\n\n";
    os << "muntutils " << MUNTUTILS_VERSION << "\n\n";
    os << "Source tree measured: `" << src << "`\n\n";
    if (have_slim) os << "Slimmed tree measured: `" << slim << "`\n\n";

    // Plain-language summary for an ordinary adult reader.
    os << "## Summary for everyone\n\n";
    os << "This report looks at a folder of program source code and measures how\n";
    os << "much of it there is. The raw source is the code as written. If a\n";
    os << "slimmed copy was provided, that is a trimmed version where code that\n";
    os << "the tool judged to be unused has been removed.\n\n";
    os << "In plain numbers, the raw source is " << raw.source.files
       << " file(s) totaling " << human(raw_src) << ".\n";
    if (have_slim) {
        os << "The slimmed source is " << slim_stats.source.files
           << " file(s) totaling " << human(slim_src) << ", which is about "
           << std::fixed;
        os.precision(1);
        os << pct << " percent smaller than the raw source.\n";
    } else {
        os << "No slimmed copy was provided, so only the raw source is reported.\n";
    }
    os << "The tool also found " << raw.artifact.files
       << " compiled program file(s) (things like .so, .dll, .a, .o, and\n";
    os << "executables) totaling " << human(raw.artifact.bytes) << ".\n\n";
    os << "Please note: the source size comparison is an estimate of how much\n";
    os << "source text was removed. It is not the same thing as the size of the\n";
    os << "compiled program. Compiled program sizes are measured separately and\n";
    os << "shown in their own line above.\n\n";

    // Detailed numbers section for a programmer.
    os << "## Details for a programmer\n\n";
    write_stats_block(os, "Raw source tree", raw);
    if (have_slim) {
        write_stats_block(os, "Slimmed source tree", slim_stats);
        os << "Source-text reduction (source category only): raw "
           << raw_src << " bytes vs slim " << slim_src << " bytes";
        if (raw_src >= slim_src) os << ", removed " << (raw_src - slim_src) << " bytes";
        os << ".\n\n";
    }
    os << "Compiled artifacts under the raw source tree: "
       << raw.artifact.files << " file(s), " << raw.artifact.bytes
       << " bytes (" << human(raw.artifact.bytes) << ").\n\n";
    os << "Measurement notes: sizes are logical file sizes, not allocated\n";
    os << "filesystem blocks. Symbolic links are not followed. Raw-vs-slim is a\n";
    os << "source-size estimate; compiled-artifact sizes are measured directly\n";
    os << "and independently of the source comparison.\n";

    std::string text = os.str();
    if (out_path.empty()) {
        std::cout << text;
    } else {
        std::ofstream f(out_path, std::ios::binary | std::ios::trunc);
        if (!f) {
            std::fprintf(stderr, "muntutils: cannot write report to %s\n", out_path.c_str());
            return 1;
        }
        f << text;
        if (!f.good()) {
            std::fprintf(stderr, "muntutils: error writing report to %s\n", out_path.c_str());
            return 1;
        }
        std::fprintf(stderr, "muntutils: report written to %s\n", out_path.c_str());
    }
    return 0;
}

int cmd_trim(int argc, char **argv, int start) {
    muntutils::TrimOptions opts;
    for (int i = start; i < argc; ++i) {
        std::string a = argv[i];
        if (a == "--out") {
            if (i + 1 >= argc) { std::fprintf(stderr, "muntutils: --out needs a directory\n"); return 2; }
            opts.out_dir = argv[++i];
        } else if (a == "--in-place" || a == "--apply") {
            opts.in_place = true;
        } else if (a == "--strict") {
            opts.strict = true;
        } else if (!a.empty() && a[0] == '-') {
            std::fprintf(stderr, "muntutils: unknown trim option %s\n", a.c_str());
            return 2;
        } else if (opts.src_tree.empty()) {
            opts.src_tree = a;
        } else {
            std::fprintf(stderr, "muntutils: unexpected argument %s\n", a.c_str());
            return 2;
        }
    }

    if (opts.src_tree.empty()) {
        std::fprintf(stderr, "muntutils: trim requires a source tree path\n");
        return 2;
    }

    muntutils::TrimResult result;
    std::string error;
    bool ok = muntutils::run_trim(opts, result, error);
    if (!ok) {
        std::fprintf(stderr, "muntutils: %s\n", error.c_str());
        return 1;
    }

    std::printf("muntutils trim complete\n");
    std::printf("  files scanned:      %llu\n", (unsigned long long)result.files_scanned);
    std::printf("  functions found:    %llu\n", (unsigned long long)result.functions_found);
    std::printf("  kept (reachable):   %llu\n", (unsigned long long)result.functions_reachable);
    std::printf("  dead (removed):     %llu\n", (unsigned long long)result.functions_dead);
    std::printf("  files changed:      %llu\n", (unsigned long long)result.functions_stubbed);
    std::printf("  confidence:         %.0f%%\n", result.confidence * 100.0);
    if (opts.in_place) {
        std::printf("  mode:               in-place (originals backed up to .bak)\n");
        for (const auto &b : result.backups) std::printf("    backup: %s\n", b.c_str());
    } else {
        std::printf("  mode:               safe (slim tree written to %s; originals untouched)\n",
                    opts.out_dir.c_str());
    }
    if (!result.dead_names.empty()) {
        std::printf("  removed functions:\n");
        for (const auto &d : result.dead_names) std::printf("    - %s\n", d.c_str());
    }
    if (!result.unresolved.empty()) {
        std::printf("  constructs the analysis could not fully resolve:\n");
        for (const auto &u : result.unresolved)
            std::printf("    - [%s] %s\n", u.file.c_str(), u.detail.c_str());
        std::printf("  These are the honest limits of heuristic static analysis\n");
        std::printf("  (function pointers, dynamic dispatch, dlopen/dlsym, and\n");
        std::printf("  preprocessor conditionals). Uncertain functions were KEPT.\n");
    }
    return 0;
}

int cmd_report_parse(int argc, char **argv, int start) {
    std::string src, slim, out;
    for (int i = start; i < argc; ++i) {
        std::string a = argv[i];
        if (a == "--slim") {
            if (i + 1 >= argc) { std::fprintf(stderr, "muntutils: --slim needs a directory\n"); return 2; }
            slim = argv[++i];
        } else if (a == "--out") {
            if (i + 1 >= argc) { std::fprintf(stderr, "muntutils: --out needs a path\n"); return 2; }
            out = argv[++i];
        } else if (!a.empty() && a[0] == '-') {
            std::fprintf(stderr, "muntutils: unknown report option %s\n", a.c_str());
            return 2;
        } else if (src.empty()) {
            src = a;
        } else {
            std::fprintf(stderr, "muntutils: unexpected argument %s\n", a.c_str());
            return 2;
        }
    }
    if (src.empty()) {
        std::fprintf(stderr, "muntutils: report requires a source tree path\n");
        return 2;
    }
    return cmd_report(src, slim, out);
}

} // namespace

int main(int argc, char **argv) {
    if (argc < 2) {
        print_usage(stderr);
        return 2;
    }
    std::string cmd = argv[1];
    if (cmd == "--version" || cmd == "-V") {
        std::printf("muntutils %s\n", MUNTUTILS_VERSION);
        return 0;
    }
    if (cmd == "--help" || cmd == "-h") {
        print_usage(stdout);
        return 0;
    }
    if (cmd == "trim") {
        return cmd_trim(argc, argv, 2);
    }
    if (cmd == "report") {
        return cmd_report_parse(argc, argv, 2);
    }
    std::fprintf(stderr, "muntutils: unknown command '%s'\n\n", cmd.c_str());
    print_usage(stderr);
    return 2;
}
