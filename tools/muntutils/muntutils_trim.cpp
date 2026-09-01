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
 * string arguments, any function whose name appears verbatim inside a string
 * literal anywhere in the tree (general name-based dynamic dispatch), and by
 * default every externally linkable (non-static) function. A function is
 * trimmed only when it is provably unreferenced under these rules. When
 * uncertain the engine keeps the function.
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

// Extract every whitespace-free identifier-shaped token that appears as (or
// inside) a double-quoted string literal in the raw text. This is the general
// defense against name-based dynamic dispatch: any custom loader, plugin
// registry, command table, or config-driven handler that selects a function by
// its textual name leaves that name in a string literal, even when there is no
// dlsym or GetProcAddress call. Any such token that matches a defined function
// name is treated as a conservative root so the function is never trimmed.
//
// A string may hold more than a bare identifier (paths, format strings,
// messages), so we tokenize the string body on non-identifier characters and
// emit each maximal identifier run. This over-collects harmlessly: a stray
// word that happens to equal a function name only causes that function to be
// kept, which is the safe direction.
void collect_quoted_identifiers(const std::string &raw,
                                std::unordered_set<std::string> &quoted_idents) {
    size_t n = raw.size();
    size_t i = 0;
    while (i < n) {
        char c = raw[i];
        // Skip line comments so commented-out text does not create phantom
        // roots; block comments are handled the same way for consistency.
        if (c == '/' && i + 1 < n && raw[i + 1] == '/') {
            i += 2;
            while (i < n && raw[i] != '\n') ++i;
            continue;
        }
        if (c == '/' && i + 1 < n && raw[i + 1] == '*') {
            i += 2;
            while (i + 1 < n && !(raw[i] == '*' && raw[i + 1] == '/')) ++i;
            i += 2;
            continue;
        }
        if (c == '\'') {
            // Character literal: skip its contents so an escaped quote inside
            // does not desynchronize the double-quote scanner.
            ++i;
            while (i < n && raw[i] != '\'') {
                if (raw[i] == '\\' && i + 1 < n) { i += 2; continue; }
                ++i;
            }
            if (i < n) ++i;
            continue;
        }
        if (c == '"') {
            ++i;
            std::string body;
            while (i < n && raw[i] != '"') {
                if (raw[i] == '\\' && i + 1 < n) {
                    // Keep the escaped character verbatim minus the backslash so
                    // runs are not artificially split; good enough heuristically.
                    body.push_back(raw[i + 1]);
                    i += 2;
                    continue;
                }
                body.push_back(raw[i]);
                ++i;
            }
            if (i < n) ++i; // consume closing quote
            // Tokenize the string body into maximal identifier runs.
            size_t k = 0;
            size_t bn = body.size();
            while (k < bn) {
                if (is_ident_start(body[k])) {
                    size_t s = k;
                    while (k < bn && is_ident_char(body[k])) ++k;
                    quoted_idents.insert(body.substr(s, k - s));
                } else {
                    ++k;
                }
            }
            continue;
        }
        ++i;
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

// Canonicalize a path for containment comparison. On POSIX, realpath resolves
// symlinks and "." / ".." components for existing paths; for a not-yet-created
// --out dir we canonicalize its existing parent and re-append the leaf. The
// returned string has no trailing slash. On failure the input is returned as
// given (a lexical best effort), which still catches the common cases.
std::string canonical_path(const std::string &p) {
    if (p.empty()) return p;
#if !defined(_WIN32)
    char resolved[4096];
    if (realpath(p.c_str(), resolved) != nullptr) {
        return std::string(resolved);
    }
    // Path may not exist yet (typical for --out). Resolve the parent instead.
    {
        std::string path = p;
        while (path.size() > 1 && path.back() == '/') path.pop_back();
        size_t slash = path.find_last_of('/');
        std::string parent = (slash == std::string::npos) ? "." : path.substr(0, slash);
        std::string leaf = (slash == std::string::npos) ? path : path.substr(slash + 1);
        if (parent.empty()) parent = "/";
        if (realpath(parent.c_str(), resolved) != nullptr) {
            std::string base(resolved);
            if (!base.empty() && base.back() == '/') base.pop_back();
            return base + "/" + leaf;
        }
    }
#endif
    std::string lexical = p;
    while (lexical.size() > 1 && (lexical.back() == '/' || lexical.back() == '\\'))
        lexical.pop_back();
    return lexical;
}

// True if child is equal to, or lexically nested inside, parent (both assumed
// already canonicalized with no trailing separator).
bool path_within(const std::string &child, const std::string &parent) {
    if (parent.empty() || child.empty()) return false;
    if (child == parent) return true;
    if (child.size() > parent.size() &&
        child.compare(0, parent.size(), parent) == 0 &&
        (child[parent.size()] == '/' || child[parent.size()] == '\\')) {
        return true;
    }
    return false;
}

bool run_trim(const TrimOptions &opts, TrimResult &result, std::string &error) {
    // Safety gate: default runs must never touch originals.
    if (!opts.in_place && opts.out_dir.empty()) {
        error = "trim requires --out <dir> unless --in-place is given explicitly";
        result.ok = false;
        return false;
    }

    // Reject an --out directory that resolves inside the source tree. If it did,
    // a subsequent run would enumerate the generated slim copy as fresh input,
    // conflating output with input and re-analyzing produced files. The source
    // tree itself is also not a valid output root.
    if (!opts.in_place && !opts.out_dir.empty()) {
        std::string csrc = canonical_path(opts.src_tree);
        std::string cout = canonical_path(opts.out_dir);
        if (path_within(cout, csrc)) {
            error = "refusing to write slim output into the source tree (--out '" +
                    opts.out_dir + "' resolves inside '" + opts.src_tree +
                    "'); choose an --out directory outside the source tree";
            result.ok = false;
            return false;
        }
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

    // Pass 2: collect references, address-taken uses, dynamic symbols, and
    // every identifier-shaped token found inside a string literal.
    std::unordered_set<std::string> referenced;
    std::unordered_set<std::string> address_taken;
    std::unordered_set<std::string> dynamic;
    std::unordered_set<std::string> quoted_idents;
    for (const auto &ft : files) {
        const auto it = def_offsets.find(ft.rel);
        static const std::unordered_set<size_t> empty_offsets;
        const std::unordered_set<size_t> &skip =
            it != def_offsets.end() ? it->second : empty_offsets;
        collect_references(ft.stripped, func_names, skip, referenced, address_taken);
        collect_dynamic_symbols(ft.raw, dynamic);
        collect_quoted_identifiers(ft.raw, quoted_idents);
    }

    // Any quoted token that matches a defined function name is a
    // name-in-string root. This closes the general name-based dispatch hole:
    // a function selected by textual name through a custom (non-dlsym) loader,
    // a plugin/command registry, or config-driven dispatch stays alive because
    // its name is present in the source, just inside a string literal. A name
    // present in the source is not proven unreferenced, so we keep it.
    std::unordered_set<std::string> string_named;
    for (const auto &f : funcs) {
        if (quoted_idents.count(f.name)) string_named.insert(f.name);
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
        // Name appears verbatim inside a string literal: possible name-based
        // dynamic dispatch. Keep it regardless of --strict.
        if (string_named.count(f.name)) root = true;
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

    // When the tree both proposes a removal and contains string literals whose
    // text matches a defined function name, the analysis is operating in the
    // exact blind spot where name-based dispatch can hide a live reference.
    // Even though those matched names were promoted to roots above, other
    // functions may be dispatched by names we could not correlate (assembled
    // strings, substrings, names built at runtime). Surface this honestly as an
    // unresolved construct so the reported confidence degrades here rather than
    // only for the patterns we happen to match syntactically.
    bool string_dispatch_blindspot = false;
    if (result.functions_dead > 0 && !string_named.empty()) {
        string_dispatch_blindspot = true;
        std::string names;
        size_t shown = 0;
        for (const auto &nm : string_named) {
            if (shown++) names += ", ";
            names += nm;
            if (shown >= 8) { names += ", ..."; break; }
        }
        result.unresolved.push_back(
            {opts.src_tree,
             "string literals name defined functions (" + names +
                 "); name-based dynamic dispatch may reference other functions "
                 "by textual name. Matched names were kept; review removals."});
    }

    // Confidence: start at full and reduce for each unresolved construct,
    // floored at a modest value so we never claim certainty we do not have.
    double penalty = 0.03 * (double)result.unresolved.size();
    result.confidence = penalty >= 0.6 ? 0.4 : (1.0 - penalty);
    // Never report full certainty when a removal is proposed while string
    // literals matching defined function names exist: that is precisely the
    // situation where a heuristic scanner is most likely to be wrong.
    if (string_dispatch_blindspot && result.confidence > 0.90) {
        result.confidence = 0.90;
    }

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
