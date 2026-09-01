/*
 * muntutils_trim.cpp - C++17 source-analysis, reachability, and trimming
 * engine implementation for the muntutils tool.
 *
 * Approach: a pragmatic heuristic scanner (not a full compiler front end)
 * strips comments and string literals, finds top-level function definitions by
 * matching a name followed by a parenthesized parameter list and a
 * brace-balanced body, and records every identifier reference across the whole
 * tree. It then computes a conservative reachable set. Roots include main, any
 * function whose address is taken, symbols named in dlsym or GetProcAddress
 * string arguments, and by default every externally linkable (non-static)
 * function. A function is trimmed only when it is provably unreferenced under
 * these rules. When uncertain the engine keeps the function.
 *
 * It calls the C11 filesystem core through the extern "C" API in
 * muntutils_fs.h to enumerate source files in a portable, symlink-safe way.
 *
 * Provenance: part of the MEARVK Ubuntu.Determinant.Beta.Restricted tool set.
 * The provenance framing identifies build origin only. It is not a legal
 * ownership, fiduciary, or execution authorization claim.
 *
 * Program based on Science at NCSU - Max Rupplin - MEARVK LLC 2026.
 */
#include "muntutils_trim.hpp"
#include "muntutils_fs.h"

#include <algorithm>
#include <cctype>
#include <cstdio>
#include <fstream>
#include <map>
#include <set>
#include <sstream>
#include <sys/stat.h>
#include <sys/types.h>
#include <unordered_map>
#include <unordered_set>

#if defined(_WIN32)
#include <direct.h>
#else
#include <unistd.h>
#endif

namespace muntutils {
namespace {

// C and C++ keywords that can be immediately followed by "(" but are not
// function calls or definitions. Used to avoid misclassifying control flow.
const std::set<std::string> &control_keywords() {
    static const std::set<std::string> kw = {
        "if", "for", "while", "switch", "return", "sizeof", "catch",
        "do", "else", "case", "default", "goto", "typedef", "struct",
        "union", "enum", "class", "namespace", "template", "operator",
        "static_assert", "alignof", "_Alignof", "decltype", "noexcept",
        "throw", "new", "delete", "and", "or", "not"
    };
    return kw;
}

struct FileText {
    std::string rel;
    std::string abs;
    std::string raw;      // original bytes, preserved verbatim for emitting
    std::string stripped; // comments and string literals blanked, same length
};

// Blank out comments, string literals, and character literals while preserving
// byte length so offsets stay valid against the original text.
std::string strip_noise(const std::string &s) {
    std::string out = s;
    size_t n = s.size();
    size_t i = 0;
    while (i < n) {
        char c = s[i];
        if (c == '/' && i + 1 < n && s[i + 1] == '/') {
            while (i < n && s[i] != '\n') { out[i] = ' '; ++i; }
        } else if (c == '/' && i + 1 < n && s[i + 1] == '*') {
            out[i] = ' ';
            out[i + 1] = ' ';
            i += 2;
            while (i < n && !(s[i] == '*' && i + 1 < n && s[i + 1] == '/')) {
                if (s[i] != '\n') out[i] = ' ';
                ++i;
            }
            if (i < n) { out[i] = ' '; if (i + 1 < n) out[i + 1] = ' '; i += 2; }
        } else if (c == '"' || c == '\'') {
            char q = c;
            out[i] = ' ';
            ++i;
            while (i < n && s[i] != q) {
                if (s[i] == '\\' && i + 1 < n) { out[i] = ' '; out[i + 1] = ' '; i += 2; continue; }
                if (s[i] != '\n') out[i] = ' ';
                ++i;
            }
            if (i < n) { out[i] = ' '; ++i; }
        } else {
            ++i;
        }
    }
    return out;
}

bool is_ident_start(char c) { return std::isalpha((unsigned char)c) || c == '_'; }
bool is_ident_char(char c) { return std::isalnum((unsigned char)c) || c == '_'; }

// Find the matching close brace given the index of an open brace in stripped.
size_t match_brace(const std::string &s, size_t open) {
    int depth = 0;
    for (size_t i = open; i < s.size(); ++i) {
        if (s[i] == '{') ++depth;
        else if (s[i] == '}') {
            --depth;
            if (depth == 0) return i;
        }
    }
    return std::string::npos; // unbalanced
}

// Scan a file for top-level function definitions. A definition is a plain
// identifier (the name) followed by optional whitespace, a "(", a balanced
// parameter list ")", optional trailing tokens, then "{". Only brace-depth 0
// definitions are recorded so nested lambdas and struct members are ignored.
void find_functions(const FileText &ft, std::vector<FunctionInfo> &out,
                    TrimResult &result) {
    const std::string &s = ft.stripped;
    size_t n = s.size();
    int brace_depth = 0;
    int paren_depth = 0;
    size_t i = 0;

    while (i < n) {
        char c = s[i];
        if (c == '{') { ++brace_depth; ++i; continue; }
        if (c == '}') { if (brace_depth > 0) --brace_depth; ++i; continue; }
        if (c == '(') { ++paren_depth; ++i; continue; }
        if (c == ')') { if (paren_depth > 0) --paren_depth; ++i; continue; }

        if (brace_depth == 0 && paren_depth == 0 && is_ident_start(c)) {
            size_t start = i;
            while (i < n && is_ident_char(s[i])) ++i;
            std::string ident = s.substr(start, i - start);
            size_t j = i;
            while (j < n && std::isspace((unsigned char)s[j])) ++j;
            if (j < n && s[j] == '(' && !control_keywords().count(ident)) {
                // Balance the parameter list.
                int pd = 0;
                size_t k = j;
                for (; k < n; ++k) {
                    if (s[k] == '(') ++pd;
                    else if (s[k] == ')') { --pd; if (pd == 0) { ++k; break; } }
                }
                if (pd != 0) continue; // unbalanced, bail on this token
                // Skip trailing qualifiers, then require an opening brace to
                // treat this as a definition rather than a declaration/call.
                size_t m = k;
                while (m < n) {
                    if (std::isspace((unsigned char)s[m])) { ++m; continue; }
                    // trailing tokens like const, noexcept, throw(...), attributes
                    if (is_ident_start(s[m])) { while (m < n && is_ident_char(s[m])) ++m; continue; }
                    if (s[m] == '(') { int q = 0; while (m < n) { if (s[m]=='(') ++q; else if (s[m]==')'){--q; if(!q){++m;break;}} ++m; } continue; }
                    break;
                }
                if (m < n && s[m] == '{') {
                    size_t close = match_brace(s, m);
                    if (close != std::string::npos) {
                        // Determine static linkage by looking backward on the
                        // same logical line for the "static" keyword.
                        bool is_static = false;
                        size_t back = start;
                        size_t line_start = start;
                        while (line_start > 0 && s[line_start - 1] != '\n' &&
                               s[line_start - 1] != '}' && s[line_start - 1] != ';')
                            --line_start;
                        std::string prefix = s.substr(line_start, back - line_start);
                        if (prefix.find("static") != std::string::npos) is_static = true;

                        FunctionInfo fi;
                        fi.name = ident;
                        fi.file = ft.rel;
                        fi.is_static = is_static;
                        fi.name_offset = start; // offset of the name token
                        fi.body_begin = line_start; // include return type/qualifiers
                        fi.body_end = close + 1;
                        out.push_back(fi);
                        (void)result;
                        // Jump past the body so nested content is not rescanned
                        // as top-level definitions.
                        i = close + 1;
                        continue;
                    }
                }
            }
            continue;
        }
        ++i;
    }
}

// Record every identifier occurrence in the stripped text along with whether
// the very next non-space token is "(" (a call) or something else. An
// identifier used without a following "(" and that names a function is treated
// as address-taken, which makes that function a conservative root.
// skip_offsets holds byte offsets in s that are function definition-name
// tokens. Those occurrences are the definitions themselves and must not count
// as references, otherwise every function would appear to reference itself and
// nothing could ever be trimmed.
void collect_references(const std::string &s,
                        const std::set<std::string> &func_names,
                        const std::unordered_set<size_t> &skip_offsets,
                        std::unordered_set<std::string> &referenced,
                        std::unordered_set<std::string> &address_taken) {
    size_t n = s.size();
    size_t i = 0;
    while (i < n) {
        if (is_ident_start(s[i])) {
            size_t start = i;
            while (i < n && is_ident_char(s[i])) ++i;
            std::string ident = s.substr(start, i - start);
            if (func_names.count(ident) && !skip_offsets.count(start)) {
                size_t j = i;
                while (j < n && std::isspace((unsigned char)s[j])) ++j;
                bool call = (j < n && s[j] == '(');
                referenced.insert(ident);
                if (!call) address_taken.insert(ident);
            }
        } else {
            ++i;
        }
    }
}

// Best-effort scan for names passed to dlsym/GetProcAddress. Uses the original
// (non-stripped) text so the quoted symbol name is visible.
void collect_dynamic_symbols(const std::string &raw,
                             std::unordered_set<std::string> &dynamic) {
    static const char *fns[] = {"dlsym", "GetProcAddress"};
    for (const char *fn : fns) {
        size_t pos = 0;
        std::string key = fn;
        while ((pos = raw.find(key, pos)) != std::string::npos) {
            size_t p = pos + key.size();
            // find first quote after the call
            size_t q = raw.find('"', p);
            size_t paren_end = raw.find(')', p);
            if (q != std::string::npos && (paren_end == std::string::npos || q < paren_end)) {
                size_t e = raw.find('"', q + 1);
                if (e != std::string::npos && e > q + 1) {
                    dynamic.insert(raw.substr(q + 1, e - q - 1));
                }
            }
            pos = p;
        }
    }
}

// Note preprocessor conditionals and function-pointer typedefs as unresolved
// constructs so the report is honest about analysis limits.
void note_unresolved(const FileText &ft, TrimResult &result) {
    std::istringstream in(ft.raw);
    std::string line;
    int lineno = 0;
    bool saw_cond = false;
    while (std::getline(in, line)) {
        ++lineno;
        std::string t = line;
        size_t h = t.find_first_not_of(" \t");
        if (h != std::string::npos && t[h] == '#') {
            std::string d = t.substr(h + 1);
            if (d.rfind("if", 0) == 0 || d.rfind("ifdef", 0) == 0 ||
                d.rfind("ifndef", 0) == 0 || d.rfind("elif", 0) == 0) {
                saw_cond = true;
            }
        }
    }
    if (saw_cond) {
        result.unresolved.push_back(
            {ft.rel, "preprocessor conditionals may hide or expose definitions"});
    }
    // Heuristic function-pointer detection: "(*name)" pattern in stripped text.
    const std::string &s = ft.stripped;
    if (s.find("(*") != std::string::npos && s.find(")(") != std::string::npos) {
        result.unresolved.push_back(
            {ft.rel, "function pointers or indirect dispatch present"});
    }
}

bool read_file(const std::string &path, std::string &out) {
    std::ifstream in(path, std::ios::binary);
    if (!in) return false;
    std::ostringstream ss;
    ss << in.rdbuf();
    out = ss.str();
    return true;
}

bool write_file(const std::string &path, const std::string &data) {
    std::ofstream out(path, std::ios::binary | std::ios::trunc);
    if (!out) return false;
    out.write(data.data(), (std::streamsize)data.size());
    return out.good();
}

// Create parent directories for a relative path under base (mkdir -p style).
void ensure_dirs(const std::string &base, const std::string &rel) {
    std::string path = base;
    auto mkdir_one = [](const std::string &p) {
#if defined(_WIN32)
        _mkdir(p.c_str());
#else
        mkdir(p.c_str(), 0755);
#endif
    };
    mkdir_one(path);
    size_t start = 0;
    for (size_t i = 0; i < rel.size(); ++i) {
        if (rel[i] == '/' || rel[i] == '\\') {
            path += "/";
            path += rel.substr(start, i - start);
            mkdir_one(path);
            start = i + 1;
        }
    }
}

// Build the slimmed text of one file by replacing each dead function body span
// with a clearly commented stub marker. Spans are applied back to front so
// earlier offsets remain valid.
std::string build_slim_text(const FileText &ft,
                            const std::vector<FunctionInfo> &funcs) {
    std::vector<const FunctionInfo *> dead;
    for (const auto &f : funcs) {
        if (f.file == ft.rel && !f.reachable) dead.push_back(&f);
    }
    std::sort(dead.begin(), dead.end(),
              [](const FunctionInfo *a, const FunctionInfo *b) {
                  return a->body_begin > b->body_begin;
              });
    std::string text = ft.raw;
    for (const FunctionInfo *f : dead) {
        if (f->body_end > text.size() || f->body_begin >= f->body_end) continue;
        std::string stub = "/* muntutils: function '" + f->name +
                           "' removed as confidently dead (unreferenced). */\n";
        text.replace(f->body_begin, f->body_end - f->body_begin, stub);
    }
    return text;
}

struct Collector {
    std::vector<std::string> abs;
    std::vector<std::string> rel;
};

extern "C" int collect_cb(const char *abs_path, const char *rel_path, void *user) {
    auto *c = static_cast<Collector *>(user);
    c->abs.emplace_back(abs_path);
    c->rel.emplace_back(rel_path);
    return 0;
}

} // namespace

bool run_trim(const TrimOptions &opts, TrimResult &result, std::string &error) {
    // Safety gate: default runs must never touch originals.
    if (!opts.in_place && opts.out_dir.empty()) {
        error = "trim requires --out <dir> unless --in-place is given explicitly";
        result.ok = false;
        return false;
    }

    Collector col;
    if (mu_enumerate_sources(opts.src_tree.c_str(), collect_cb, &col) != 0) {
        // Non-fatal: partial enumeration still yields a usable analysis, but
        // report the condition through unresolved notes.
        result.unresolved.push_back({opts.src_tree, "some paths could not be fully enumerated"});
    }

    std::vector<FileText> files;
    for (size_t i = 0; i < col.abs.size(); ++i) {
        FileText ft;
        ft.abs = col.abs[i];
        ft.rel = col.rel[i];
        if (!read_file(ft.abs, ft.raw)) {
            result.unresolved.push_back({ft.rel, "file could not be read"});
            continue;
        }
        ft.stripped = strip_noise(ft.raw);
        files.push_back(std::move(ft));
    }
    result.files_scanned = files.size();

    // Pass 1: find all function definitions across the tree.
    std::vector<FunctionInfo> funcs;
    for (const auto &ft : files) {
        find_functions(ft, funcs, result);
        note_unresolved(ft, result);
    }
    result.functions_found = funcs.size();

    std::set<std::string> func_names;
    for (const auto &f : funcs) func_names.insert(f.name);

    // Map each file to the set of definition-name offsets in it, so those
    // defining occurrences are not miscounted as references.
    std::unordered_map<std::string, std::unordered_set<size_t>> def_offsets;
    for (const auto &f : funcs) def_offsets[f.file].insert(f.name_offset);

    // Pass 2: collect references, address-taken uses, and dynamic symbols.
    std::unordered_set<std::string> referenced;
    std::unordered_set<std::string> address_taken;
    std::unordered_set<std::string> dynamic;
    for (const auto &ft : files) {
        const auto it = def_offsets.find(ft.rel);
        static const std::unordered_set<size_t> empty_offsets;
        const std::unordered_set<size_t> &skip =
            it != def_offsets.end() ? it->second : empty_offsets;
        collect_references(ft.stripped, func_names, skip, referenced, address_taken);
        collect_dynamic_symbols(ft.raw, dynamic);
    }

    // Determine the conservative root set and mark reachability. Because the
    // reference scan is tree-wide (not a precise per-caller graph), any
    // function referenced anywhere outside its own definition is kept. This is
    // deliberately conservative: it never trims something that is named.
    std::unordered_map<std::string, int> def_count;
    for (const auto &f : funcs) def_count[f.name]++;

    for (auto &f : funcs) {
        bool root = false;
        if (f.name == "main") root = true;
        if (address_taken.count(f.name)) { root = true; f.address_taken = true; }
        if (dynamic.count(f.name)) root = true;
        if (!opts.strict && !f.is_static) root = true; // externally linkable
        // Referenced anywhere in the tree keeps it alive.
        if (referenced.count(f.name)) root = true;
        // Ambiguous overloads / duplicate names: keep to stay safe.
        if (def_count[f.name] > 1) root = true;
        f.reachable = root;
    }

    for (const auto &f : funcs) {
        if (f.reachable) {
            ++result.functions_reachable;
        } else {
            ++result.functions_dead;
            result.dead_names.push_back(f.name + " (" + f.file + ")");
        }
    }

    // Confidence: start at full and reduce for each unresolved construct,
    // floored at a modest value so we never claim certainty we do not have.
    double penalty = 0.03 * (double)result.unresolved.size();
    result.confidence = penalty >= 0.6 ? 0.4 : (1.0 - penalty);

    // Emit slimmed output.
    if (opts.in_place) {
        // In-place: back up every file that will actually change, then rewrite.
        for (const auto &ft : files) {
            std::string slim = build_slim_text(ft, funcs);
            if (slim == ft.raw) continue; // nothing dead in this file
            std::string bak = ft.abs + ".bak";
            if (!write_file(bak, ft.raw)) {
                error = "refusing to rewrite in place: cannot create backup " + bak;
                result.ok = false;
                return false;
            }
            result.backups.push_back(bak);
            if (!write_file(ft.abs, slim)) {
                error = "failed to write in-place slim file " + ft.abs +
                        " (backup preserved at " + bak + ")";
                result.ok = false;
                return false;
            }
            ++result.functions_stubbed;
        }
    } else {
        for (const auto &ft : files) {
            std::string slim = build_slim_text(ft, funcs);
            ensure_dirs(opts.out_dir, ft.rel);
            std::string dest = opts.out_dir + "/" + ft.rel;
            if (!write_file(dest, slim)) {
                error = "failed to write slim file " + dest;
                result.ok = false;
                return false;
            }
            if (slim != ft.raw) ++result.functions_stubbed;
        }
    }

    result.ok = true;
    return true;
}

} // namespace muntutils
