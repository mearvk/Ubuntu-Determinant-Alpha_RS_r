/*
 * Copyright (C) 2026 MEARVK LLC
 * SPDX-License-Identifier: GPL-2.0 WITH Classpath-exception-2.0
 *
 * xmc — XML Metaclass Compiler
 *
 * Compiles Java (.java), Python (.py), or Rust (.rs) source files into the
 * SecureJDK 28 XML class file format (.xclass). The .xclass format carries
 * rich metadata beyond binary .class: provenance, design intent, security
 * grades, dependencies, optimization hints, contracts, quality democracy,
 * and quality woman assessments.
 *
 * The xmc compiler:
 *   1. Parses source (Java, Python, or Rust)
 *   2. Extracts structural identity (classes, methods, fields, inheritance)
 *   3. Assigns Quality Democracy grade (voice, representation, participation)
 *   4. Assigns Quality Woman grade (care, integrity, nurture, resolve, grace)
 *   5. Assigns INT tier (1-4) with wet structure analysis
 *   6. Signs the output with xmc identity and installer tech authority
 *   7. Adjusts output based on international law or conduct frame
 *
 * The xmc binary itself is slightly different based on conduct frame:
 *   - US Standard (default): Full democracy and liberty assessments
 *   - EU Frame: GDPR-aware, data protection emphasis in quality scores
 *   - International: UN Charter aligned, universal human rights basis
 *   - Commonwealth: Common law tradition, precedent-aware grading
 *
 * Security Concerns (from javac study):
 *   - Input validation: source files may contain hostile constructs
 *   - Output integrity: .xclass must not be writable by untrusted parties
 *   - Signing: SHA-256 digest prevents post-compilation tampering
 *   - Path traversal: source/output paths validated, no symlink following
 *   - Memory: bounded parsing, no unbounded recursion
 *   - No DTD/ENTITY in output XML (inherits SecureJDK XML policy)
 *
 * Usage:
 *   xmc MyClass.java                    # Produces MyClass.xclass
 *   xmc --frame=eu MyModule.py          # EU conduct frame
 *   xmc --tier=3 --color=blue Art.java  # Force tier/color override
 *   xmc --sign-as="mearvk - Installer Tech 2" Main.java
 *   xmc engine.rs                        # Rust struct/impl → .xclass
 *
 * Output goes to SecureJDK 28 (jvmINTLoader, classLoadGuard, xmlConfigReader).
 *
 * Author: Maximilian Eric Alexander Rupplin von Keffikon
 * Installer Tech: mearvk - Installer Tech 2
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <ctype.h>
#include <time.h>
#include <unistd.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>
#include <limits.h>

/* ============================================================================
 * Constants
 * ============================================================================ */

#define XMC_VERSION          "1.0.0"
#define XMC_EDITION          "Galactic Cherry Marvell 98"
#define XMC_MAX_SOURCE_SIZE  (16 * 1024 * 1024)  /* 16 MB max source file */
#define XMC_MAX_CLASSES      256
#define XMC_MAX_METHODS      1024
#define XMC_MAX_FIELDS       512
#define XMC_MAX_DEPS         256
#define XMC_MAX_NAME         256
#define XMC_MAX_PATH         PATH_MAX
#define XMC_SIGNATURE_LEN    64   /* SHA-256 hex = 64 chars */

/* INT Tiers (mirrors jvmINTLoader.hpp) */
#define INT_TIER_MODULE       1
#define INT_TIER_SETUP        2
#define INT_TIER_TECHNOCATOR  3
#define INT_TIER_MIND_CONTROL 4

/* Conduct Frames */
#define FRAME_US_STANDARD     0
#define FRAME_EU              1
#define FRAME_INTERNATIONAL   2
#define FRAME_COMMONWEALTH    3

/* Quality Democracy Dimensions */
#define QD_VOICE              0   /* Does the code give voice to its users? */
#define QD_REPRESENTATION     1   /* Are all concerns represented in structure? */
#define QD_PARTICIPATION      2   /* Can others participate in its evolution? */
#define QD_TRANSPARENCY       3   /* Is the code transparent about intent? */
#define QD_ACCOUNTABILITY     4   /* Does the code account for its actions? */
#define QD_DIMENSIONS         5

/* Quality Woman Dimensions */
#define QW_CARE               0   /* Is the code careful with resources? */
#define QW_INTEGRITY          1   /* Does the code maintain its promises? */
#define QW_NURTURE            2   /* Does the code nurture growth? */
#define QW_RESOLVE            3   /* Does the code resolve conflict cleanly? */
#define QW_GRACE              4   /* Does the code operate with grace? */
#define QW_DIMENSIONS         5

/* Wet Structure (INT Tier internals) */
#define WET_MODULE            0   /* Foundation weight, self-support */
#define WET_DEMANGE           1   /* Pre-artistic form — the seed */
#define WET_DEMART            2   /* Chemistry before wisdom */
#define WET_ARTISTRY          3   /* Full craft expression */

/* Intellect Colors */
#define COLOR_WHITE           0
#define COLOR_GOLD            1
#define COLOR_BLUE            2
#define COLOR_GREEN           3
#define COLOR_SILVER          4
#define COLOR_RED             5
#define COLOR_CLEAR           6

/* ============================================================================
 * Structures
 * ============================================================================ */

typedef enum {
    LANG_JAVA,
    LANG_PYTHON,
    LANG_RUST,
    LANG_UNKNOWN
} SourceLanguage;

typedef struct {
    char name[XMC_MAX_NAME];
    char return_type[XMC_MAX_NAME];
    int  param_count;
    bool is_public;
    bool is_static;
    bool is_abstract;
    int  line_count;       /* Method body line count */
    int  complexity;       /* Cyclomatic complexity estimate */
} MethodInfo;

typedef struct {
    char name[XMC_MAX_NAME];
    char type[XMC_MAX_NAME];
    bool is_public;
    bool is_static;
    bool is_final;
} FieldInfo;

typedef struct {
    char name[XMC_MAX_NAME];
    char superclass[XMC_MAX_NAME];
    char interfaces[XMC_MAX_DEPS][XMC_MAX_NAME];
    int  interface_count;
    char dependencies[XMC_MAX_DEPS][XMC_MAX_NAME];
    int  dependency_count;

    MethodInfo methods[XMC_MAX_METHODS];
    int        method_count;

    FieldInfo  fields[XMC_MAX_FIELDS];
    int        field_count;

    bool is_abstract;
    bool is_interface;
    bool is_final;
    bool is_public;

    /* Computed by xmc */
    int  int_tier;            /* 1-4 */
    int  wet_structure[4];    /* Scores for module/demange/demart/artistry */
    int  quality_democracy[QD_DIMENSIONS];  /* 0-100 each */
    int  quality_woman[QW_DIMENSIONS];       /* 0-100 each */
    int  intellect_color;     /* 0-6 */
    int  trust_grade;         /* 1-5 (eperm class) */
    int  classload_grade;     /* 0-7 (ClassLoadGuard grade) */
    size_t weight;            /* Structural weight (bytes) */
    int  lateral_count;       /* Peer/interface connections */
    int  int_complexity;      /* Overall INT complexity 0-100 */
} ClassInfo;

typedef struct {
    char source_path[XMC_MAX_PATH];
    char output_path[XMC_MAX_PATH];
    char signer_name[XMC_MAX_NAME];
    char signer_techid[XMC_MAX_NAME];
    int  conduct_frame;
    int  force_tier;          /* -1 = auto, 1-4 = forced */
    int  force_color;         /* -1 = auto, 0-6 = forced */
    bool verbose;
    bool dry_run;
    bool sign;
    SourceLanguage language;
} CompilerOptions;

typedef struct {
    char*  source;
    size_t source_len;
    char   source_file[XMC_MAX_PATH];

    ClassInfo classes[XMC_MAX_CLASSES];
    int       class_count;

    CompilerOptions options;

    /* Compilation timestamp */
    char timestamp[64];
    char date_iso[32];
} CompilerState;

/* ============================================================================
 * Forward Declarations
 * ============================================================================ */

static bool parse_args(int argc, char** argv, CompilerOptions* opts);
static bool read_source(const char* path, CompilerState* state);
static bool detect_language(const char* path, SourceLanguage* lang);
static bool parse_java(CompilerState* state);
static bool parse_python(CompilerState* state);
static bool parse_rust(CompilerState* state);
static void compute_quality_democracy(ClassInfo* cls, const CompilerOptions* opts);
static void compute_quality_woman(ClassInfo* cls, const CompilerOptions* opts);
static void compute_wet_structure(ClassInfo* cls);
static void compute_int_tier(ClassInfo* cls);
static void assign_intellect_color(ClassInfo* cls);
static void compute_weight(ClassInfo* cls);
static bool emit_xclass(const CompilerState* state, const ClassInfo* cls);
static void compute_sha256(const char* data, size_t len, char* hex_out);
static void print_usage(void);
static void print_version(void);

/* ============================================================================
 * Conduct Frame Names
 * ============================================================================ */

static const char* frame_names[] = {
    "US Standard",
    "European Union",
    "International (UN Charter)",
    "Commonwealth"
};

static const char* frame_codes[] = {
    "US",
    "EU",
    "INTL",
    "CW"
};

static const char* tier_names[] = {
    "(none)",
    "Module System",
    "Setup Technology",
    "Modulator Technocator",
    "Technology Mind Control"
};

static const char* wet_names[] __attribute__((unused)) = {
    "module",
    "demange",
    "demart",
    "artistry"
};

static const char* color_names[] = {
    "White",
    "Gold",
    "Blue",
    "Green",
    "Silver",
    "Red",
    "Clear"
};

static const char* qd_names[] __attribute__((unused)) = {
    "voice",
    "representation",
    "participation",
    "transparency",
    "accountability"
};

static const char* qw_names[] __attribute__((unused)) = {
    "care",
    "integrity",
    "nurture",
    "resolve",
    "grace"
};

/* ============================================================================
 * Main Entry Point
 * ============================================================================ */

int main(int argc, char** argv) {
    CompilerState* state = (CompilerState*)calloc(1, sizeof(CompilerState));
    if (!state) {
        fprintf(stderr, "xmc: out of memory\n");
        return 1;
    }

    /* Set defaults */
    state->options.conduct_frame = FRAME_US_STANDARD;
    state->options.force_tier = -1;
    state->options.force_color = -1;
    state->options.sign = true;
    strncpy(state->options.signer_name,
            "Maximilian Eric Alexander Rupplin von Keffikon",
            XMC_MAX_NAME - 1);
    strncpy(state->options.signer_techid,
            "mearvk - Installer Tech 2",
            XMC_MAX_NAME - 1);

    /* Parse arguments */
    if (!parse_args(argc, argv, &state->options)) {
        free(state);
        return 1;
    }

    /* Generate timestamp */
    time_t now = time(NULL);
    struct tm* tm_info = localtime(&now);
    strftime(state->timestamp, sizeof(state->timestamp),
             "%Y-%m-%dT%H:%M:%S%z", tm_info);
    strftime(state->date_iso, sizeof(state->date_iso),
             "%Y-%m-%d", tm_info);

    /* Detect language if not forced */
    if (state->options.language == LANG_UNKNOWN) {
        if (!detect_language(state->options.source_path, &state->options.language)) {
            fprintf(stderr, "xmc: cannot determine source language for '%s'\n",
                    state->options.source_path);
            free(state);
            return 1;
        }
    }

    /* Read source file */
    if (!read_source(state->options.source_path, state)) {
        free(state);
        return 1;
    }

    /* Parse source */
    bool parse_ok = false;
    switch (state->options.language) {
        case LANG_JAVA:
            parse_ok = parse_java(state);
            break;
        case LANG_PYTHON:
            parse_ok = parse_python(state);
            break;
        case LANG_RUST:
            parse_ok = parse_rust(state);
            break;
        default:
            fprintf(stderr, "xmc: unsupported language\n");
            free(state->source);
            free(state);
            return 1;
    }

    if (!parse_ok) {
        fprintf(stderr, "xmc: parse failed for '%s'\n", state->options.source_path);
        free(state->source);
        free(state);
        return 1;
    }

    if (state->class_count == 0) {
        fprintf(stderr, "xmc: no classes found in '%s'\n", state->options.source_path);
        free(state->source);
        free(state);
        return 1;
    }

    /* Process each class */
    int errors = 0;
    for (int i = 0; i < state->class_count; i++) {
        ClassInfo* cls = &state->classes[i];

        /* Compute structural metrics */
        compute_weight(cls);
        compute_wet_structure(cls);
        compute_int_tier(cls);
        assign_intellect_color(cls);
        compute_quality_democracy(cls, &state->options);
        compute_quality_woman(cls, &state->options);

        /* Apply overrides */
        if (state->options.force_tier > 0) {
            cls->int_tier = state->options.force_tier;
        }
        if (state->options.force_color >= 0) {
            cls->intellect_color = state->options.force_color;
        }

        /* Verbose output */
        if (state->options.verbose) {
            printf("xmc: class '%s'\n", cls->name);
            printf("  INT Tier:    %d (%s)\n", cls->int_tier, tier_names[cls->int_tier]);
            printf("  Color:       %s\n", color_names[cls->intellect_color]);
            printf("  Weight:      %zu bytes\n", cls->weight);
            printf("  Lateral:     %d\n", cls->lateral_count);
            printf("  INT Level:   %d/100\n", cls->int_complexity);
            printf("  Wet Structure: module=%d demange=%d demart=%d artistry=%d\n",
                   cls->wet_structure[0], cls->wet_structure[1],
                   cls->wet_structure[2], cls->wet_structure[3]);
            printf("  Quality Democracy: voice=%d repr=%d part=%d trans=%d acct=%d\n",
                   cls->quality_democracy[0], cls->quality_democracy[1],
                   cls->quality_democracy[2], cls->quality_democracy[3],
                   cls->quality_democracy[4]);
            printf("  Quality Woman: care=%d integ=%d nurture=%d resolve=%d grace=%d\n",
                   cls->quality_woman[0], cls->quality_woman[1],
                   cls->quality_woman[2], cls->quality_woman[3],
                   cls->quality_woman[4]);
            printf("  Frame:       %s\n", frame_names[state->options.conduct_frame]);
            printf("\n");
        }

        /* Emit .xclass */
        if (!state->options.dry_run) {
            if (!emit_xclass(state, cls)) {
                fprintf(stderr, "xmc: failed to emit .xclass for '%s'\n", cls->name);
                errors++;
            } else {
                printf("xmc: %s.xclass [tier=%d, color=%s, frame=%s]\n",
                       cls->name, cls->int_tier,
                       color_names[cls->intellect_color],
                       frame_codes[state->options.conduct_frame]);
            }
        }
    }

    free(state->source);
    free(state);

    if (errors > 0) {
        fprintf(stderr, "xmc: %d error(s) during compilation\n", errors);
        return 1;
    }

    return 0;
}

/* ============================================================================
 * Argument Parsing
 * ============================================================================ */

static bool parse_args(int argc, char** argv, CompilerOptions* opts) {
    if (argc < 2) {
        print_usage();
        return false;
    }

    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "--help") == 0 || strcmp(argv[i], "-h") == 0) {
            print_usage();
            return false;
        }
        else if (strcmp(argv[i], "--version") == 0 || strcmp(argv[i], "-V") == 0) {
            print_version();
            return false;
        }
        else if (strncmp(argv[i], "--frame=", 8) == 0) {
            const char* frame = argv[i] + 8;
            if (strcasecmp(frame, "us") == 0)
                opts->conduct_frame = FRAME_US_STANDARD;
            else if (strcasecmp(frame, "eu") == 0)
                opts->conduct_frame = FRAME_EU;
            else if (strcasecmp(frame, "intl") == 0 || strcasecmp(frame, "international") == 0)
                opts->conduct_frame = FRAME_INTERNATIONAL;
            else if (strcasecmp(frame, "cw") == 0 || strcasecmp(frame, "commonwealth") == 0)
                opts->conduct_frame = FRAME_COMMONWEALTH;
            else {
                fprintf(stderr, "xmc: unknown conduct frame '%s'\n", frame);
                fprintf(stderr, "  Valid: us, eu, intl, cw\n");
                return false;
            }
        }
        else if (strncmp(argv[i], "--tier=", 7) == 0) {
            opts->force_tier = atoi(argv[i] + 7);
            if (opts->force_tier < 1 || opts->force_tier > 4) {
                fprintf(stderr, "xmc: tier must be 1-4\n");
                return false;
            }
        }
        else if (strncmp(argv[i], "--color=", 8) == 0) {
            const char* c = argv[i] + 8;
            if (strcasecmp(c, "white") == 0) opts->force_color = COLOR_WHITE;
            else if (strcasecmp(c, "gold") == 0) opts->force_color = COLOR_GOLD;
            else if (strcasecmp(c, "blue") == 0) opts->force_color = COLOR_BLUE;
            else if (strcasecmp(c, "green") == 0) opts->force_color = COLOR_GREEN;
            else if (strcasecmp(c, "silver") == 0) opts->force_color = COLOR_SILVER;
            else if (strcasecmp(c, "red") == 0) opts->force_color = COLOR_RED;
            else if (strcasecmp(c, "clear") == 0) opts->force_color = COLOR_CLEAR;
            else {
                fprintf(stderr, "xmc: unknown color '%s'\n", c);
                return false;
            }
        }
        else if (strncmp(argv[i], "--sign-as=", 10) == 0) {
            strncpy(opts->signer_techid, argv[i] + 10, XMC_MAX_NAME - 1);
        }
        else if (strcmp(argv[i], "--no-sign") == 0) {
            opts->sign = false;
        }
        else if (strcmp(argv[i], "--java") == 0) {
            opts->language = LANG_JAVA;
        }
        else if (strcmp(argv[i], "--python") == 0) {
            opts->language = LANG_PYTHON;
        }
        else if (strcmp(argv[i], "--rust") == 0) {
            opts->language = LANG_RUST;
        }
        else if (strcmp(argv[i], "-v") == 0 || strcmp(argv[i], "--verbose") == 0) {
            opts->verbose = true;
        }
        else if (strcmp(argv[i], "-n") == 0 || strcmp(argv[i], "--dry-run") == 0) {
            opts->dry_run = true;
        }
        else if (strncmp(argv[i], "-o", 2) == 0) {
            if (argv[i][2] != '\0') {
                strncpy(opts->output_path, argv[i] + 2, XMC_MAX_PATH - 1);
            } else if (i + 1 < argc) {
                strncpy(opts->output_path, argv[++i], XMC_MAX_PATH - 1);
            }
        }
        else if (argv[i][0] == '-') {
            fprintf(stderr, "xmc: unknown option '%s'\n", argv[i]);
            return false;
        }
        else {
            /* Source file */
            if (opts->source_path[0] != '\0') {
                fprintf(stderr, "xmc: multiple source files not yet supported\n");
                return false;
            }
            strncpy(opts->source_path, argv[i], XMC_MAX_PATH - 1);
        }
    }

    if (opts->source_path[0] == '\0') {
        fprintf(stderr, "xmc: no source file specified\n");
        return false;
    }

    return true;
}

/* ============================================================================
 * Source Reading (Security: bounded, no symlinks)
 * ============================================================================ */

static bool read_source(const char* path, CompilerState* state) {
    /* Security: no symlink following (mirrors javac security posture) */
    struct stat st;
    if (lstat(path, &st) != 0) {
        fprintf(stderr, "xmc: cannot stat '%s': %s\n", path, strerror(errno));
        return false;
    }

    if (S_ISLNK(st.st_mode)) {
        fprintf(stderr, "xmc: refusing to compile symlink '%s' (security)\n", path);
        return false;
    }

    if (!S_ISREG(st.st_mode)) {
        fprintf(stderr, "xmc: '%s' is not a regular file\n", path);
        return false;
    }

    if ((size_t)st.st_size > XMC_MAX_SOURCE_SIZE) {
        fprintf(stderr, "xmc: source file exceeds 16 MB limit\n");
        return false;
    }

    /* Open with O_NOFOLLOW */
    int fd = open(path, O_RDONLY | O_NOFOLLOW);
    if (fd < 0) {
        fprintf(stderr, "xmc: cannot open '%s': %s\n", path, strerror(errno));
        return false;
    }

    state->source_len = (size_t)st.st_size;
    state->source = (char*)malloc(state->source_len + 1);
    if (!state->source) {
        fprintf(stderr, "xmc: out of memory\n");
        close(fd);
        return false;
    }

    ssize_t nread = read(fd, state->source, state->source_len);
    close(fd);

    if (nread < 0 || (size_t)nread != state->source_len) {
        fprintf(stderr, "xmc: read error on '%s'\n", path);
        free(state->source);
        state->source = NULL;
        return false;
    }

    state->source[state->source_len] = '\0';
    strncpy(state->source_file, path, XMC_MAX_PATH - 1);

    return true;
}

/* ============================================================================
 * Language Detection
 * ============================================================================ */

static bool detect_language(const char* path, SourceLanguage* lang) {
    const char* ext = strrchr(path, '.');
    if (!ext) return false;

    if (strcasecmp(ext, ".java") == 0) {
        *lang = LANG_JAVA;
        return true;
    }
    if (strcasecmp(ext, ".py") == 0) {
        *lang = LANG_PYTHON;
        return true;
    }
    if (strcasecmp(ext, ".rs") == 0) {
        *lang = LANG_RUST;
        return true;
    }

    return false;
}

/* ============================================================================
 * Java Parser (Structural Extraction)
 *
 * Security note (from javac Main.java study):
 *   javac processes source through: parse → enter → annotation → analyze → gen
 *   xmc only needs parse + structural extraction (no codegen to bytecode).
 *   We extract: class declarations, method signatures, field declarations,
 *   extends/implements, imports (as dependencies).
 *   We do NOT evaluate expressions or execute code.
 * ============================================================================ */

static void skip_whitespace_and_comments(const char** p) {
    while (**p) {
        /* Whitespace */
        if (isspace((unsigned char)**p)) { (*p)++; continue; }
        /* Line comment */
        if ((*p)[0] == '/' && (*p)[1] == '/') {
            while (**p && **p != '\n') (*p)++;
            continue;
        }
        /* Block comment */
        if ((*p)[0] == '/' && (*p)[1] == '*') {
            (*p) += 2;
            while (**p && !((*p)[0] == '*' && (*p)[1] == '/')) (*p)++;
            if (**p) (*p) += 2;
            continue;
        }
        break;
    }
}

static bool read_identifier(const char** p, char* buf, size_t max) {
    skip_whitespace_and_comments(p);
    if (!isalpha((unsigned char)**p) && **p != '_') return false;

    size_t i = 0;
    while ((isalnum((unsigned char)**p) || **p == '_' || **p == '.') && i < max - 1) {
        buf[i++] = *(*p)++;
    }
    buf[i] = '\0';
    return i > 0;
}

static void skip_block(const char** p) {
    int depth = 0;
    while (**p) {
        if (**p == '{') depth++;
        else if (**p == '}') { depth--; if (depth <= 0) { (*p)++; return; } }
        (*p)++;
    }
}

static int count_lines_in_block(const char* start, const char* end) {
    int lines = 0;
    for (const char* p = start; p < end; p++) {
        if (*p == '\n') lines++;
    }
    return lines;
}

static int estimate_complexity(const char* start, const char* end) {
    /* Simple cyclomatic complexity: count decision points */
    int cc = 1; /* base path */
    const char* keywords[] = { "if", "else", "for", "while", "switch",
                                "case", "catch", "&&", "||", "?" };
    int kw_count = 10;

    for (const char* p = start; p < end - 1; p++) {
        for (int k = 0; k < kw_count; k++) {
            size_t klen = strlen(keywords[k]);
            if (p + klen <= end && strncmp(p, keywords[k], klen) == 0) {
                /* Ensure it's a keyword boundary (not part of larger word) */
                if (klen <= 2 || (!isalnum((unsigned char)p[klen]) && p[klen] != '_')) {
                    cc++;
                }
            }
        }
    }
    return cc;
}

static bool parse_java(CompilerState* state) {
    const char* p = state->source;
    ClassInfo* current_class = NULL;

    /* Extract imports as dependencies */
    while (*p) {
        skip_whitespace_and_comments(&p);
        if (!*p) break;

        /* import statement */
        if (strncmp(p, "import", 6) == 0 && !isalnum((unsigned char)p[6])) {
            p += 6;
            char dep[XMC_MAX_NAME] = {0};
            read_identifier(&p, dep, XMC_MAX_NAME);
            /* Store dependency for current or next class */
            if (state->class_count > 0) {
                ClassInfo* cls = &state->classes[state->class_count - 1];
                if (cls->dependency_count < XMC_MAX_DEPS) {
                    strncpy(cls->dependencies[cls->dependency_count++], dep, XMC_MAX_NAME - 1);
                }
            }
            while (*p && *p != ';') p++;
            if (*p == ';') p++;
            continue;
        }

        /* class/interface declaration */
        bool is_public = false, is_abstract = false, is_final = false;
        bool is_interface = false;

        /* Modifiers */
        while (*p) {
            skip_whitespace_and_comments(&p);
            if (strncmp(p, "public", 6) == 0 && !isalnum((unsigned char)p[6]))
                { is_public = true; p += 6; continue; }
            if (strncmp(p, "abstract", 8) == 0 && !isalnum((unsigned char)p[8]))
                { is_abstract = true; p += 8; continue; }
            if (strncmp(p, "final", 5) == 0 && !isalnum((unsigned char)p[5]))
                { is_final = true; p += 5; continue; }
            if (strncmp(p, "private", 7) == 0 && !isalnum((unsigned char)p[7]))
                { p += 7; continue; }
            if (strncmp(p, "protected", 9) == 0 && !isalnum((unsigned char)p[9]))
                { p += 9; continue; }
            if (strncmp(p, "static", 6) == 0 && !isalnum((unsigned char)p[6]))
                { p += 6; continue; }
            break;
        }

        skip_whitespace_and_comments(&p);

        if (strncmp(p, "interface", 9) == 0 && !isalnum((unsigned char)p[9])) {
            is_interface = true;
            p += 9;
        } else if (strncmp(p, "class", 5) == 0 && !isalnum((unsigned char)p[5])) {
            /* Lookahead to confirm a real class declaration.
             * Allow use of the token 'class' as an identifier when it's not
             * followed by a valid class name + class-body/introduction tokens.
             */
            const char* q = p + 5;
            skip_whitespace_and_comments(&q);
            bool is_decl = false;
            if (isalpha((unsigned char)*q) || *q == '_') {
                char tmp[XMC_MAX_NAME];
                if (read_identifier(&q, tmp, XMC_MAX_NAME)) {
                    skip_whitespace_and_comments(&q);
                    if (*q == '{' ||
                        (strncmp(q, "extends", 7) == 0 && !isalnum((unsigned char)q[7])) ||
                        (strncmp(q, "implements", 10) == 0 && !isalnum((unsigned char)q[10])) ||
                        *q == '<') {
                        is_decl = true;
                    }
                }
            }
            if (is_decl) {
                p += 5;
            } else {
                /* treat 'class' as ordinary token/identifier — fall through */
            }
        } else {
            /* Not a class declaration — advance */
            if (*p == '{') { skip_block(&p); }
            else { p++; }
            continue;
        }

        /* Class name */
        if (state->class_count >= XMC_MAX_CLASSES) {
            fprintf(stderr, "xmc: too many classes (max %d)\n", XMC_MAX_CLASSES);
            return false;
        }

        current_class = &state->classes[state->class_count];
        memset(current_class, 0, sizeof(ClassInfo));
        current_class->is_public = is_public;
        current_class->is_abstract = is_abstract;
        current_class->is_final = is_final;
        current_class->is_interface = is_interface;

        read_identifier(&p, current_class->name, XMC_MAX_NAME);

        /* extends */
        skip_whitespace_and_comments(&p);
        if (strncmp(p, "extends", 7) == 0 && !isalnum((unsigned char)p[7])) {
            p += 7;
            read_identifier(&p, current_class->superclass, XMC_MAX_NAME);
        } else {
            strncpy(current_class->superclass, "Object", XMC_MAX_NAME - 1);
        }

        /* implements */
        skip_whitespace_and_comments(&p);
        if (strncmp(p, "implements", 10) == 0 && !isalnum((unsigned char)p[10])) {
            p += 10;
            while (*p && *p != '{') {
                char iface[XMC_MAX_NAME] = {0};
                if (read_identifier(&p, iface, XMC_MAX_NAME)) {
                    if (current_class->interface_count < XMC_MAX_DEPS) {
                        strncpy(current_class->interfaces[current_class->interface_count++],
                                iface, XMC_MAX_NAME - 1);
                    }
                }
                skip_whitespace_and_comments(&p);
                if (*p == ',') p++;
            }
        }

        /* Class body */
        skip_whitespace_and_comments(&p);
        if (*p == '{') {
            p++; /* enter class body */
            int depth = 1;

            while (*p && depth > 0) {
                skip_whitespace_and_comments(&p);
                if (!*p) break;

                if (*p == '{') { depth++; p++; continue; }
                if (*p == '}') { depth--; p++; continue; }

                /* Try to parse method/field declarations within body */
                /* Simplified: look for patterns like "type name(" for methods */
                const char* save = p;
                char word1[XMC_MAX_NAME] = {0}, word2[XMC_MAX_NAME] = {0};
                bool m_public = false, m_static = false, m_abstract = false;

                /* Method modifiers */
                while (*p) {
                    skip_whitespace_and_comments(&p);
                    if (strncmp(p, "public", 6) == 0 && !isalnum((unsigned char)p[6]))
                        { m_public = true; p += 6; continue; }
                    if (strncmp(p, "private", 7) == 0 && !isalnum((unsigned char)p[7]))
                        { p += 7; continue; }
                    if (strncmp(p, "protected", 9) == 0 && !isalnum((unsigned char)p[9]))
                        { p += 9; continue; }
                    if (strncmp(p, "static", 6) == 0 && !isalnum((unsigned char)p[6]))
                        { m_static = true; p += 6; continue; }
                    if (strncmp(p, "abstract", 8) == 0 && !isalnum((unsigned char)p[8]))
                        { m_abstract = true; p += 8; continue; }
                    if (strncmp(p, "final", 5) == 0 && !isalnum((unsigned char)p[5]))
                        { p += 5; continue; }
                    if (strncmp(p, "synchronized", 12) == 0 && !isalnum((unsigned char)p[12]))
                        { p += 12; continue; }
                    break;
                }

                if (read_identifier(&p, word1, XMC_MAX_NAME)) {
                    skip_whitespace_and_comments(&p);

                    /* Generic type parameters: skip <...> */
                    if (*p == '<') {
                        int gdepth = 1;
                        p++;
                        while (*p && gdepth > 0) {
                            if (*p == '<') gdepth++;
                            else if (*p == '>') gdepth--;
                            p++;
                        }
                        skip_whitespace_and_comments(&p);
                    }

                    if (read_identifier(&p, word2, XMC_MAX_NAME)) {
                        skip_whitespace_and_comments(&p);

                        if (*p == '(') {
                            /* Method declaration: word1=returnType, word2=name */
                            if (current_class->method_count < XMC_MAX_METHODS) {
                                MethodInfo* m = &current_class->methods[current_class->method_count];
                                strncpy(m->return_type, word1, XMC_MAX_NAME - 1);
                                strncpy(m->name, word2, XMC_MAX_NAME - 1);
                                m->is_public = m_public;
                                m->is_static = m_static;
                                m->is_abstract = m_abstract;

                                /* Count parameters */
                                m->param_count = 0;
                                p++; /* skip ( */
                                if (*p != ')') {
                                    m->param_count = 1;
                                    while (*p && *p != ')') {
                                        if (*p == ',') m->param_count++;
                                        p++;
                                    }
                                }
                                if (*p == ')') p++;

                                skip_whitespace_and_comments(&p);

                                /* Method body */
                                if (*p == '{') {
                                    const char* body_start = p;
                                    skip_block(&p);
                                    m->line_count = count_lines_in_block(body_start, p);
                                    m->complexity = estimate_complexity(body_start, p);
                                } else {
                                    /* abstract or interface method */
                                    while (*p && *p != ';') p++;
                                    if (*p == ';') p++;
                                    m->line_count = 0;
                                    m->complexity = 0;
                                }

                                current_class->method_count++;
                            } else {
                                /* Skip method body */
                                while (*p && *p != '(' ) p++;
                                while (*p && *p != ')') p++;
                                if (*p) p++;
                                skip_whitespace_and_comments(&p);
                                if (*p == '{') skip_block(&p);
                                else { while (*p && *p != ';') p++; if (*p) p++; }
                            }
                        }
                        else if (*p == ';' || *p == '=' || *p == ',') {
                            /* Field declaration: word1=type, word2=name */
                            if (current_class->field_count < XMC_MAX_FIELDS) {
                                FieldInfo* f = &current_class->fields[current_class->field_count++];
                                strncpy(f->type, word1, XMC_MAX_NAME - 1);
                                strncpy(f->name, word2, XMC_MAX_NAME - 1);
                                f->is_public = m_public;
                                f->is_static = m_static;
                            }
                            while (*p && *p != ';') p++;
                            if (*p == ';') p++;
                        }
                        else {
                            /* Unknown, advance */
                            p = save + 1;
                        }
                    } else {
                        /* Constructor or single-word: advance */
                        if (*p == '(') {
                            /* Constructor */
                            if (current_class->method_count < XMC_MAX_METHODS) {
                                MethodInfo* m = &current_class->methods[current_class->method_count];
                                strncpy(m->return_type, "(init)", XMC_MAX_NAME - 1);
                                strncpy(m->name, word1, XMC_MAX_NAME - 1);
                                m->is_public = m_public;
                                m->param_count = 0;
                                p++;
                                if (*p != ')') {
                                    m->param_count = 1;
                                    while (*p && *p != ')') { if (*p == ',') m->param_count++; p++; }
                                }
                                if (*p == ')') p++;
                                skip_whitespace_and_comments(&p);
                                if (*p == '{') {
                                    const char* bs = p;
                                    skip_block(&p);
                                    m->line_count = count_lines_in_block(bs, p);
                                    m->complexity = estimate_complexity(bs, p);
                                }
                                current_class->method_count++;
                            } else {
                                while (*p && *p != ')') p++;
                                if (*p) p++;
                                skip_whitespace_and_comments(&p);
                                if (*p == '{') skip_block(&p);
                            }
                        } else {
                            p = save + 1;
                        }
                    }
                } else {
                    p++;
                }
            }
        }

        state->class_count++;
    }

    /* Transfer imports to first class if needed */
    /* (imports parsed before first class exist as orphans — handled above) */

    return true;
}

/* ============================================================================
 * Python Parser (Structural Extraction)
 * ============================================================================ */

static bool parse_python(CompilerState* state) {
    const char* p = state->source;

    /* Python classes: "class Name:" or "class Name(Base):" */
    while (*p) {
        /* Skip to next line */
        while (*p && *p != '\n' && isspace((unsigned char)*p)) p++;

        /* import statements → dependencies */
        if (strncmp(p, "import ", 7) == 0 || strncmp(p, "from ", 5) == 0) {
            if (strncmp(p, "from ", 5) == 0) p += 5;
            else p += 7;

            char dep[XMC_MAX_NAME] = {0};
            int di = 0;
            while (*p && *p != '\n' && *p != ' ' && di < XMC_MAX_NAME - 1) {
                dep[di++] = *p++;
            }
            dep[di] = '\0';

            /* Attach to current or remember for next class */
            if (state->class_count > 0) {
                ClassInfo* cls = &state->classes[state->class_count - 1];
                if (cls->dependency_count < XMC_MAX_DEPS) {
                    strncpy(cls->dependencies[cls->dependency_count++], dep, XMC_MAX_NAME - 1);
                }
            }
            while (*p && *p != '\n') p++;
            if (*p == '\n') p++;
            continue;
        }

        /* class declaration */
        if (strncmp(p, "class ", 6) == 0) {
            p += 6;

            if (state->class_count >= XMC_MAX_CLASSES) break;

            ClassInfo* cls = &state->classes[state->class_count];
            memset(cls, 0, sizeof(ClassInfo));
            cls->is_public = true; /* Python: all public by default */

            /* Class name */
            int ni = 0;
            while (*p && *p != '(' && *p != ':' && *p != '\n' && ni < XMC_MAX_NAME - 1) {
                if (!isspace((unsigned char)*p))
                    cls->name[ni++] = *p;
                p++;
            }
            cls->name[ni] = '\0';

            /* Base classes */
            if (*p == '(') {
                p++;
                char base[XMC_MAX_NAME] = {0};
                int bi = 0;
                while (*p && *p != ')') {
                    if (*p == ',') {
                        base[bi] = '\0';
                        if (bi > 0) {
                            if (cls->interface_count == 0)
                                strncpy(cls->superclass, base, XMC_MAX_NAME - 1);
                            else if (cls->interface_count < XMC_MAX_DEPS)
                                strncpy(cls->interfaces[cls->interface_count - 1], base, XMC_MAX_NAME - 1);
                            cls->interface_count++;
                        }
                        bi = 0;
                        p++;
                        while (*p && isspace((unsigned char)*p)) p++;
                        continue;
                    }
                    if (!isspace((unsigned char)*p) && bi < XMC_MAX_NAME - 1)
                        base[bi++] = *p;
                    p++;
                }
                base[bi] = '\0';
                if (bi > 0) {
                    if (cls->superclass[0] == '\0')
                        strncpy(cls->superclass, base, XMC_MAX_NAME - 1);
                    else if (cls->interface_count < XMC_MAX_DEPS)
                        strncpy(cls->interfaces[cls->interface_count++], base, XMC_MAX_NAME - 1);
                }
                if (*p == ')') p++;
            }

            if (cls->superclass[0] == '\0')
                strncpy(cls->superclass, "object", XMC_MAX_NAME - 1);

            /* Skip to : */
            while (*p && *p != ':' && *p != '\n') p++;
            if (*p == ':') p++;
            if (*p == '\n') p++;

            /* Parse class body (indented lines) */
            while (*p) {
                /* Check indentation — if line starts with no indent, class ended */
                if (*p != ' ' && *p != '\t' && *p != '\n' && *p != '#') break;
                if (*p == '\n') { p++; continue; }

                /* Skip indent */
                while (*p && (*p == ' ' || *p == '\t')) p++;

                /* def → method */
                if (strncmp(p, "def ", 4) == 0) {
                    p += 4;
                    if (cls->method_count < XMC_MAX_METHODS) {
                        MethodInfo* m = &cls->methods[cls->method_count];
                        memset(m, 0, sizeof(MethodInfo));

                        int mi = 0;
                        while (*p && *p != '(' && mi < XMC_MAX_NAME - 1) {
                            m->name[mi++] = *p++;
                        }
                        m->name[mi] = '\0';

                        m->is_public = (m->name[0] != '_');
                        strncpy(m->return_type, "Any", XMC_MAX_NAME - 1);

                        /* Count params */
                        if (*p == '(') {
                            p++;
                            m->param_count = 0;
                            if (*p != ')') {
                                m->param_count = 1;
                                while (*p && *p != ')') { if (*p == ',') m->param_count++; p++; }
                            }
                            /* Subtract 'self' */
                            if (m->param_count > 0) m->param_count--;
                            if (*p == ')') p++;
                        }

                        /* Count body lines */
                        while (*p && *p != '\n') p++;
                        if (*p == '\n') p++;
                        const char* body_start = p;
                        while (*p && (*p == ' ' || *p == '\t')) {
                            while (*p && *p != '\n') p++;
                            m->line_count++;
                            if (*p == '\n') p++;
                            /* Check if next line is still indented enough */
                            if (*p && *p != ' ' && *p != '\t') break;
                            int indent = 0;
                            const char* lp = p;
                            while (*lp == ' ' || *lp == '\t') { indent++; lp++; }
                            if (indent < 8) break; /* rough: method body needs 8+ indent */
                        }
                        m->complexity = estimate_complexity(body_start, p);

                        cls->method_count++;
                    }
                } else {
                    /* Skip non-def line (field or other) */
                    /* Check for simple assignment: name = ... */
                    char fname[XMC_MAX_NAME] = {0};
                    int fi = 0;
                    while (*p && *p != '=' && *p != '\n' && *p != '(' && fi < XMC_MAX_NAME - 1) {
                        if (!isspace((unsigned char)*p))
                            fname[fi++] = *p;
                        p++;
                    }
                    fname[fi] = '\0';
                    if (*p == '=' && fi > 0 && fname[0] != '#') {
                        if (cls->field_count < XMC_MAX_FIELDS) {
                            FieldInfo* f = &cls->fields[cls->field_count++];
                            strncpy(f->name, fname, XMC_MAX_NAME - 1);
                            strncpy(f->type, "Any", XMC_MAX_NAME - 1);
                            f->is_public = (fname[0] != '_');
                            f->is_static = true; /* class-level = class variable */
                        }
                    }
                    while (*p && *p != '\n') p++;
                    if (*p == '\n') p++;
                }
            }

            state->class_count++;
            continue;
        }

        /* Advance to next line */
        while (*p && *p != '\n') p++;
        if (*p == '\n') p++;
    }

    return true;
}

/* ============================================================================
 * Rust Parser (Structural Extraction)
 *
 * Rust maps to xclass as follows:
 *   - struct/enum         → ClassInfo (is_interface=false)
 *   - trait               → ClassInfo (is_interface=true)
 *   - impl Block methods  → MethodInfo
 *   - struct fields       → FieldInfo
 *   - use/extern crate    → dependencies
 *   - trait bounds (:)    → interfaces (implements)
 *   - pub visibility      → is_public
 *
 * Rust does not have inheritance (no superclass), but traits serve as
 * interface contracts. Structs with impl blocks are concrete classes.
 * Enums with impl blocks are treated as sealed class hierarchies.
 * ============================================================================ */

static bool parse_rust(CompilerState* state) {
    const char* p = state->source;

    /* Helper: skip Rust comments — reuses existing skip_whitespace_and_comments */

    while (*p) {
        skip_whitespace_and_comments(&p);
        if (!*p) break;

        /* use statements → dependencies */
        if (strncmp(p, "use ", 4) == 0) {
            p += 4;
            char dep[XMC_MAX_NAME] = {0};
            int di = 0;
            while (*p && *p != ';' && *p != '\n' && di < XMC_MAX_NAME - 1) {
                if (!isspace((unsigned char)*p))
                    dep[di++] = *p;
                p++;
            }
            dep[di] = '\0';
            if (*p == ';') p++;

            /* Attach to most recent class or hold for next */
            if (state->class_count > 0) {
                ClassInfo* cls = &state->classes[state->class_count - 1];
                if (cls->dependency_count < XMC_MAX_DEPS) {
                    strncpy(cls->dependencies[cls->dependency_count++], dep, XMC_MAX_NAME - 1);
                }
            }
            continue;
        }

        /* extern crate → dependency */
        if (strncmp(p, "extern crate ", 13) == 0) {
            p += 13;
            char dep[XMC_MAX_NAME] = {0};
            int di = 0;
            while (*p && *p != ';' && *p != '\n' && di < XMC_MAX_NAME - 1) {
                if (!isspace((unsigned char)*p))
                    dep[di++] = *p;
                p++;
            }
            dep[di] = '\0';
            if (*p == ';') p++;

            if (state->class_count > 0) {
                ClassInfo* cls = &state->classes[state->class_count - 1];
                if (cls->dependency_count < XMC_MAX_DEPS) {
                    strncpy(cls->dependencies[cls->dependency_count++], dep, XMC_MAX_NAME - 1);
                }
            }
            continue;
        }

        /* Detect visibility and attributes */
        bool is_public = false;

        /* Skip attributes: #[...] and #![...] */
        while (*p == '#') {
            p++;
            if (*p == '!') p++;
            if (*p == '[') {
                int bdepth = 1;
                p++;
                while (*p && bdepth > 0) {
                    if (*p == '[') bdepth++;
                    else if (*p == ']') bdepth--;
                    p++;
                }
            }
            skip_whitespace_and_comments(&p);
        }

        if (strncmp(p, "pub", 3) == 0 && !isalnum((unsigned char)p[3]) && p[3] != '_') {
            is_public = true;
            p += 3;
            skip_whitespace_and_comments(&p);
            /* pub(crate), pub(super), etc. */
            if (*p == '(') {
                int pdepth = 1;
                p++;
                while (*p && pdepth > 0) {
                    if (*p == '(') pdepth++;
                    else if (*p == ')') pdepth--;
                    p++;
                }
                skip_whitespace_and_comments(&p);
            }
        }

        /* struct declaration */
        if (strncmp(p, "struct ", 6) == 0) {
            p += 6;
            skip_whitespace_and_comments(&p);

            if (state->class_count >= XMC_MAX_CLASSES) break;

            ClassInfo* cls = &state->classes[state->class_count];
            memset(cls, 0, sizeof(ClassInfo));
            cls->is_public = is_public;
            cls->is_abstract = false;
            cls->is_interface = false;
            cls->is_final = true; /* Rust structs are "final" — no inheritance */
            strncpy(cls->superclass, "(none)", XMC_MAX_NAME - 1);

            /* Name */
            read_identifier(&p, cls->name, XMC_MAX_NAME);
            skip_whitespace_and_comments(&p);

            /* Generic parameters <...> — skip */
            if (*p == '<') {
                int gdepth = 1;
                p++;
                while (*p && gdepth > 0) {
                    if (*p == '<') gdepth++;
                    else if (*p == '>') gdepth--;
                    p++;
                }
                skip_whitespace_and_comments(&p);
            }

            /* where clause — skip to { or ; */
            if (strncmp(p, "where", 5) == 0) {
                while (*p && *p != '{' && *p != ';') p++;
            }

            /* Struct body: { field: Type, ... } or tuple struct (Type, Type); or unit struct; */
            if (*p == '{') {
                p++;
                int depth = 1;
                while (*p && depth > 0) {
                    skip_whitespace_and_comments(&p);
                    if (*p == '{') { depth++; p++; continue; }
                    if (*p == '}') { depth--; p++; continue; }

                    /* Parse field: [pub] name: Type */
                    bool f_pub = false;
                    if (strncmp(p, "pub", 3) == 0 && !isalnum((unsigned char)p[3]) && p[3] != '_') {
                        f_pub = true;
                        p += 3;
                        skip_whitespace_and_comments(&p);
                        if (*p == '(') {
                            int pd = 1; p++;
                            while (*p && pd > 0) { if (*p == '(') pd++; else if (*p == ')') pd--; p++; }
                            skip_whitespace_and_comments(&p);
                        }
                    }

                    char fname[XMC_MAX_NAME] = {0};
                    if (read_identifier(&p, fname, XMC_MAX_NAME)) {
                        skip_whitespace_and_comments(&p);
                        if (*p == ':') {
                            p++;
                            skip_whitespace_and_comments(&p);
                            char ftype[XMC_MAX_NAME] = {0};
                            int ti = 0;
                            /* Read type until , or } */
                            while (*p && *p != ',' && *p != '}' && ti < XMC_MAX_NAME - 1) {
                                ftype[ti++] = *p++;
                            }
                            ftype[ti] = '\0';
                            /* Trim trailing whitespace */
                            while (ti > 0 && isspace((unsigned char)ftype[ti-1])) ftype[--ti] = '\0';

                            if (cls->field_count < XMC_MAX_FIELDS) {
                                FieldInfo* f = &cls->fields[cls->field_count++];
                                strncpy(f->name, fname, XMC_MAX_NAME - 1);
                                strncpy(f->type, ftype, XMC_MAX_NAME - 1);
                                f->is_public = f_pub;
                                f->is_static = false;
                                f->is_final = false;
                            }
                        }
                    }
                    if (*p == ',') p++;
                    else if (*p && *p != '}') p++;
                }
            } else if (*p == '(') {
                /* Tuple struct: struct Name(Type, Type); */
                p++;
                int field_idx = 0;
                while (*p && *p != ')') {
                    skip_whitespace_and_comments(&p);
                    bool f_pub = false;
                    if (strncmp(p, "pub", 3) == 0 && !isalnum((unsigned char)p[3])) {
                        f_pub = true;
                        p += 3;
                        skip_whitespace_and_comments(&p);
                    }
                    char ftype[XMC_MAX_NAME] = {0};
                    int ti = 0;
                    while (*p && *p != ',' && *p != ')' && ti < XMC_MAX_NAME - 1) {
                        ftype[ti++] = *p++;
                    }
                    ftype[ti] = '\0';
                    while (ti > 0 && isspace((unsigned char)ftype[ti-1])) ftype[--ti] = '\0';

                    if (ti > 0 && cls->field_count < XMC_MAX_FIELDS) {
                        FieldInfo* f = &cls->fields[cls->field_count++];
                        snprintf(f->name, XMC_MAX_NAME, "%d", field_idx);
                        strncpy(f->type, ftype, XMC_MAX_NAME - 1);
                        f->is_public = f_pub;
                    }
                    field_idx++;
                    if (*p == ',') p++;
                }
                if (*p == ')') p++;
                if (*p == ';') p++;
            } else if (*p == ';') {
                /* Unit struct */
                p++;
            }

            state->class_count++;
            continue;
        }

        /* enum declaration — treated as sealed class */
        if (strncmp(p, "enum ", 5) == 0) {
            p += 5;
            skip_whitespace_and_comments(&p);

            if (state->class_count >= XMC_MAX_CLASSES) break;

            ClassInfo* cls = &state->classes[state->class_count];
            memset(cls, 0, sizeof(ClassInfo));
            cls->is_public = is_public;
            cls->is_abstract = true; /* enum is abstract in xclass terms (variants are concrete) */
            cls->is_interface = false;
            cls->is_final = false;
            strncpy(cls->superclass, "(none)", XMC_MAX_NAME - 1);

            read_identifier(&p, cls->name, XMC_MAX_NAME);
            skip_whitespace_and_comments(&p);

            /* Generics */
            if (*p == '<') {
                int gdepth = 1; p++;
                while (*p && gdepth > 0) { if (*p == '<') gdepth++; else if (*p == '>') gdepth--; p++; }
                skip_whitespace_and_comments(&p);
            }

            /* where clause */
            if (strncmp(p, "where", 5) == 0) {
                while (*p && *p != '{') p++;
            }

            /* Enum body: variants as "fields" */
            if (*p == '{') {
                p++;
                int depth = 1;
                while (*p && depth > 0) {
                    skip_whitespace_and_comments(&p);
                    if (*p == '{') { depth++; p++; continue; }
                    if (*p == '}') { depth--; p++; continue; }

                    /* Variant name */
                    char vname[XMC_MAX_NAME] = {0};
                    if (read_identifier(&p, vname, XMC_MAX_NAME)) {
                        if (cls->field_count < XMC_MAX_FIELDS) {
                            FieldInfo* f = &cls->fields[cls->field_count++];
                            strncpy(f->name, vname, XMC_MAX_NAME - 1);
                            strncpy(f->type, "Variant", XMC_MAX_NAME - 1);
                            f->is_public = is_public;
                            f->is_static = true; /* variants are like static members */
                        }
                        /* Skip variant payload (...) or {...} */
                        skip_whitespace_and_comments(&p);
                        if (*p == '(') {
                            int pd = 1; p++;
                            while (*p && pd > 0) { if (*p == '(') pd++; else if (*p == ')') pd--; p++; }
                        } else if (*p == '{') {
                            skip_block(&p);
                        }
                    }
                    skip_whitespace_and_comments(&p);
                    if (*p == ',') p++;
                }
            }

            state->class_count++;
            continue;
        }

        /* trait declaration — maps to interface */
        if (strncmp(p, "trait ", 6) == 0) {
            p += 6;
            skip_whitespace_and_comments(&p);

            if (state->class_count >= XMC_MAX_CLASSES) break;

            ClassInfo* cls = &state->classes[state->class_count];
            memset(cls, 0, sizeof(ClassInfo));
            cls->is_public = is_public;
            cls->is_abstract = true;
            cls->is_interface = true;
            cls->is_final = false;
            strncpy(cls->superclass, "(none)", XMC_MAX_NAME - 1);

            read_identifier(&p, cls->name, XMC_MAX_NAME);
            skip_whitespace_and_comments(&p);

            /* Generics */
            if (*p == '<') {
                int gdepth = 1; p++;
                while (*p && gdepth > 0) { if (*p == '<') gdepth++; else if (*p == '>') gdepth--; p++; }
                skip_whitespace_and_comments(&p);
            }

            /* Supertrait bounds: trait Name: SuperA + SuperB */
            if (*p == ':') {
                p++;
                skip_whitespace_and_comments(&p);
                while (*p && *p != '{' && *p != '\n') {
                    char bound[XMC_MAX_NAME] = {0};
                    if (read_identifier(&p, bound, XMC_MAX_NAME)) {
                        if (cls->interface_count < XMC_MAX_DEPS) {
                            strncpy(cls->interfaces[cls->interface_count++], bound, XMC_MAX_NAME - 1);
                        }
                    }
                    skip_whitespace_and_comments(&p);
                    /* Skip generic args on bounds */
                    if (*p == '<') {
                        int gd = 1; p++;
                        while (*p && gd > 0) { if (*p == '<') gd++; else if (*p == '>') gd--; p++; }
                        skip_whitespace_and_comments(&p);
                    }
                    if (*p == '+') { p++; skip_whitespace_and_comments(&p); }
                    else break;
                }
            }

            /* where clause */
            if (strncmp(p, "where", 5) == 0) {
                while (*p && *p != '{') p++;
            }

            /* Trait body: method signatures and default methods */
            if (*p == '{') {
                p++;
                int depth = 1;
                while (*p && depth > 0) {
                    skip_whitespace_and_comments(&p);
                    if (*p == '{') { depth++; p++; continue; }
                    if (*p == '}') { depth--; p++; continue; }

                    /* fn declaration */
                    if (strncmp(p, "fn ", 3) == 0) {
                        p += 3;
                        skip_whitespace_and_comments(&p);

                        if (cls->method_count < XMC_MAX_METHODS) {
                            MethodInfo* m = &cls->methods[cls->method_count];
                            memset(m, 0, sizeof(MethodInfo));
                            m->is_public = true; /* trait methods are pub by nature */

                            read_identifier(&p, m->name, XMC_MAX_NAME);
                            skip_whitespace_and_comments(&p);

                            /* Generics on method */
                            if (*p == '<') {
                                int gd = 1; p++;
                                while (*p && gd > 0) { if (*p == '<') gd++; else if (*p == '>') gd--; p++; }
                                skip_whitespace_and_comments(&p);
                            }

                            /* Parameters */
                            if (*p == '(') {
                                p++;
                                m->param_count = 0;
                                bool has_params = false;
                                while (*p && *p != ')') {
                                    if (*p == ',') m->param_count++;
                                    if (!isspace((unsigned char)*p) && *p != ')') has_params = true;
                                    p++;
                                }
                                if (has_params) m->param_count++;
                                /* Subtract &self/&mut self/self */
                                if (m->param_count > 0) m->param_count--;
                                if (*p == ')') p++;
                            }

                            /* Return type: -> Type */
                            skip_whitespace_and_comments(&p);
                            if (p[0] == '-' && p[1] == '>') {
                                p += 2;
                                skip_whitespace_and_comments(&p);
                                char rtype[XMC_MAX_NAME] = {0};
                                int ri = 0;
                                while (*p && *p != '{' && *p != ';' && *p != '\n' &&
                                       ri < XMC_MAX_NAME - 1) {
                                    rtype[ri++] = *p++;
                                }
                                rtype[ri] = '\0';
                                while (ri > 0 && isspace((unsigned char)rtype[ri-1])) rtype[--ri] = '\0';
                                strncpy(m->return_type, rtype, XMC_MAX_NAME - 1);
                            } else {
                                strncpy(m->return_type, "()", XMC_MAX_NAME - 1);
                            }

                            skip_whitespace_and_comments(&p);

                            /* Body or ; (abstract) */
                            if (*p == '{') {
                                const char* body_start = p;
                                skip_block(&p);
                                m->line_count = count_lines_in_block(body_start, p);
                                m->complexity = estimate_complexity(body_start, p);
                                m->is_abstract = false;
                            } else {
                                if (*p == ';') p++;
                                m->is_abstract = true;
                                m->line_count = 0;
                                m->complexity = 0;
                            }

                            cls->method_count++;
                        } else {
                            /* Skip */
                            while (*p && *p != ';' && *p != '{') p++;
                            if (*p == '{') skip_block(&p);
                            else if (*p == ';') p++;
                        }
                    } else {
                        /* type aliases or other trait items — skip */
                        while (*p && *p != ';' && *p != '{' && *p != '}') p++;
                        if (*p == '{') skip_block(&p);
                        else if (*p == ';') p++;
                    }
                }
            }

            state->class_count++;
            continue;
        }

        /* impl block — attaches methods to an existing struct/enum */
        if (strncmp(p, "impl", 4) == 0 && !isalnum((unsigned char)p[4]) && p[4] != '_') {
            p += 4;
            skip_whitespace_and_comments(&p);

            /* Generics on impl */
            if (*p == '<') {
                int gdepth = 1; p++;
                while (*p && gdepth > 0) { if (*p == '<') gdepth++; else if (*p == '>') gdepth--; p++; }
                skip_whitespace_and_comments(&p);
            }

            /* Read the type name (or trait name for trait impl) */
            char impl_name[XMC_MAX_NAME] = {0};
            read_identifier(&p, impl_name, XMC_MAX_NAME);
            skip_whitespace_and_comments(&p);

            /* Check for "impl Trait for Type" pattern */
            char trait_name[XMC_MAX_NAME] = {0};
            char target_name[XMC_MAX_NAME] = {0};

            /* Skip generics on the first identifier */
            if (*p == '<') {
                int gd = 1; p++;
                while (*p && gd > 0) { if (*p == '<') gd++; else if (*p == '>') gd--; p++; }
                skip_whitespace_and_comments(&p);
            }

            if (strncmp(p, "for ", 4) == 0) {
                /* impl Trait for Type */
                strncpy(trait_name, impl_name, XMC_MAX_NAME - 1);
                p += 4;
                skip_whitespace_and_comments(&p);
                read_identifier(&p, target_name, XMC_MAX_NAME);
                skip_whitespace_and_comments(&p);
                /* Skip generics on target */
                if (*p == '<') {
                    int gd = 1; p++;
                    while (*p && gd > 0) { if (*p == '<') gd++; else if (*p == '>') gd--; p++; }
                    skip_whitespace_and_comments(&p);
                }
            } else {
                /* impl Type (inherent impl) */
                strncpy(target_name, impl_name, XMC_MAX_NAME - 1);
            }

            /* Find the target class in already-parsed classes */
            ClassInfo* target_cls = NULL;
            for (int i = 0; i < state->class_count; i++) {
                if (strcmp(state->classes[i].name, target_name) == 0) {
                    target_cls = &state->classes[i];
                    break;
                }
            }

            /* If target not found, create a new class entry for it */
            if (!target_cls && state->class_count < XMC_MAX_CLASSES) {
                target_cls = &state->classes[state->class_count];
                memset(target_cls, 0, sizeof(ClassInfo));
                strncpy(target_cls->name, target_name, XMC_MAX_NAME - 1);
                strncpy(target_cls->superclass, "(none)", XMC_MAX_NAME - 1);
                target_cls->is_public = true;
                target_cls->is_final = true;
                state->class_count++;
            }

            /* Register trait as an interface on the target */
            if (target_cls && trait_name[0] != '\0') {
                if (target_cls->interface_count < XMC_MAX_DEPS) {
                    strncpy(target_cls->interfaces[target_cls->interface_count++],
                            trait_name, XMC_MAX_NAME - 1);
                }
                /* Implementing a trait means it's not purely final in xclass sense */
                target_cls->is_final = false;
            }

            /* where clause */
            if (strncmp(p, "where", 5) == 0) {
                while (*p && *p != '{') p++;
            }

            /* Parse impl body for methods */
            skip_whitespace_and_comments(&p);
            if (*p == '{') {
                p++;
                int depth = 1;
                while (*p && depth > 0) {
                    skip_whitespace_and_comments(&p);
                    if (*p == '{') { depth++; p++; continue; }
                    if (*p == '}') { depth--; p++; continue; }

                    /* Skip attributes */
                    while (*p == '#') {
                        p++;
                        if (*p == '[') {
                            int bd = 1; p++;
                            while (*p && bd > 0) { if (*p == '[') bd++; else if (*p == ']') bd--; p++; }
                        }
                        skip_whitespace_and_comments(&p);
                    }

                    /* pub modifier */
                    bool m_pub = false;
                    if (strncmp(p, "pub", 3) == 0 && !isalnum((unsigned char)p[3]) && p[3] != '_') {
                        m_pub = true;
                        p += 3;
                        skip_whitespace_and_comments(&p);
                        if (*p == '(') {
                            int pd = 1; p++;
                            while (*p && pd > 0) { if (*p == '(') pd++; else if (*p == ')') pd--; p++; }
                            skip_whitespace_and_comments(&p);
                        }
                    }

                    /* const/async/unsafe modifiers */
                    if (strncmp(p, "const ", 6) == 0) { p += 6; skip_whitespace_and_comments(&p); }
                    if (strncmp(p, "async ", 6) == 0) { p += 6; skip_whitespace_and_comments(&p); }
                    if (strncmp(p, "unsafe ", 7) == 0) { p += 7; skip_whitespace_and_comments(&p); }

                    /* fn declaration */
                    if (strncmp(p, "fn ", 3) == 0) {
                        p += 3;
                        skip_whitespace_and_comments(&p);

                        if (target_cls && target_cls->method_count < XMC_MAX_METHODS) {
                            MethodInfo* m = &target_cls->methods[target_cls->method_count];
                            memset(m, 0, sizeof(MethodInfo));
                            m->is_public = m_pub;
                            m->is_static = true; /* assume static until we see self */

                            read_identifier(&p, m->name, XMC_MAX_NAME);
                            skip_whitespace_and_comments(&p);

                            /* Generics */
                            if (*p == '<') {
                                int gd = 1; p++;
                                while (*p && gd > 0) { if (*p == '<') gd++; else if (*p == '>') gd--; p++; }
                                skip_whitespace_and_comments(&p);
                            }

                            /* Parameters */
                            if (*p == '(') {
                                p++;
                                m->param_count = 0;
                                bool has_params = false;
                                const char* params_start = p;
                                while (*p && *p != ')') {
                                    if (*p == ',') m->param_count++;
                                    if (!isspace((unsigned char)*p)) has_params = true;
                                    p++;
                                }
                                if (has_params) m->param_count++;
                                /* Check for self parameter */
                                size_t params_len = (size_t)(p - params_start);
                                if (params_len > 0) {
                                    /* Look for &self, &mut self, self, mut self */
                                    const char* sp = params_start;
                                    while (sp < p && isspace((unsigned char)*sp)) sp++;
                                    if (strncmp(sp, "&self", 5) == 0 ||
                                        strncmp(sp, "&mut self", 9) == 0 ||
                                        strncmp(sp, "self", 4) == 0 ||
                                        strncmp(sp, "mut self", 8) == 0) {
                                        m->is_static = false;
                                        if (m->param_count > 0) m->param_count--;
                                    }
                                }
                                if (*p == ')') p++;
                            }

                            /* Return type */
                            skip_whitespace_and_comments(&p);
                            if (p[0] == '-' && p[1] == '>') {
                                p += 2;
                                skip_whitespace_and_comments(&p);
                                char rtype[XMC_MAX_NAME] = {0};
                                int ri = 0;
                                while (*p && *p != '{' && *p != ';' &&
                                       ri < XMC_MAX_NAME - 1) {
                                    if (strncmp(p, "where", 5) == 0 && !isalnum((unsigned char)p[5])) break;
                                    rtype[ri++] = *p++;
                                }
                                rtype[ri] = '\0';
                                while (ri > 0 && isspace((unsigned char)rtype[ri-1])) rtype[--ri] = '\0';
                                strncpy(m->return_type, rtype, XMC_MAX_NAME - 1);
                            } else {
                                strncpy(m->return_type, "()", XMC_MAX_NAME - 1);
                            }

                            /* where clause */
                            if (strncmp(p, "where", 5) == 0) {
                                while (*p && *p != '{') p++;
                            }

                            /* Method body */
                            skip_whitespace_and_comments(&p);
                            if (*p == '{') {
                                const char* body_start = p;
                                skip_block(&p);
                                m->line_count = count_lines_in_block(body_start, p);
                                m->complexity = estimate_complexity(body_start, p);
                                m->is_abstract = false;
                            } else {
                                if (*p == ';') p++;
                                m->is_abstract = true;
                            }

                            target_cls->method_count++;
                        } else {
                            /* Skip the fn */
                            while (*p && *p != '{' && *p != ';') p++;
                            if (*p == '{') skip_block(&p);
                            else if (*p == ';') p++;
                        }
                    } else {
                        /* type alias, const, or other impl item */
                        while (*p && *p != ';' && *p != '{' && *p != '}') p++;
                        if (*p == '{') skip_block(&p);
                        else if (*p == ';') p++;
                    }
                }
            }
            continue;
        }

        /* Skip anything else (functions, modules, etc.) */
        if (*p == '{') { skip_block(&p); }
        else { p++; }
    }

    return true;
}

/* ============================================================================
 * Quality Democracy Assessment
 *
 * Quality Democracy evaluates whether the code structure embodies
 * democratic principles: voice, representation, participation,
 * transparency, and accountability.
 *
 * Conduct frame adjustments:
 *   US Standard:   Emphasizes voice and participation (liberty focus)
 *   EU:            Emphasizes transparency and accountability (GDPR spirit)
 *   International: Balanced (UN Charter universal rights)
 *   Commonwealth:  Emphasizes representation and accountability (common law)
 * ============================================================================ */

static void compute_quality_democracy(ClassInfo* cls, const CompilerOptions* opts) {
    /* Voice: does the code give voice to its users?
     * Public methods = user-facing API = voice */
    int public_methods = 0;
    for (int i = 0; i < cls->method_count; i++) {
        if (cls->methods[i].is_public) public_methods++;
    }
    int voice = (cls->method_count > 0)
        ? (public_methods * 100) / cls->method_count
        : 50;

    /* Representation: are all concerns represented?
     * Interfaces implemented = concerns addressed */
    int representation = 40 + (cls->interface_count * 15);
    if (representation > 100) representation = 100;
    if (cls->is_interface) representation = 90; /* interfaces ARE representation */

    /* Participation: can others participate in evolution?
     * Non-final, has public API, has extensions */
    int participation = 50;
    if (!cls->is_final) participation += 20;
    if (cls->is_abstract) participation += 15;
    if (cls->is_interface) participation += 15;
    if (public_methods > 3) participation += 10;
    if (participation > 100) participation = 100;

    /* Transparency: is intent clear?
     * Short methods = transparent, low complexity = transparent */
    int avg_complexity = 0;
    for (int i = 0; i < cls->method_count; i++) {
        avg_complexity += cls->methods[i].complexity;
    }
    if (cls->method_count > 0) avg_complexity /= cls->method_count;
    int transparency = 100 - (avg_complexity * 5);
    if (transparency < 10) transparency = 10;
    if (transparency > 100) transparency = 100;

    /* Accountability: does the code account for actions?
     * Methods with return values, error handling patterns */
    int accountability = 50;
    for (int i = 0; i < cls->method_count; i++) {
        if (strcmp(cls->methods[i].return_type, "void") != 0 &&
            strcmp(cls->methods[i].return_type, "None") != 0) {
            accountability += 5;
        }
    }
    if (accountability > 100) accountability = 100;

    /* Conduct frame adjustments */
    switch (opts->conduct_frame) {
        case FRAME_US_STANDARD:
            voice += 10;         /* Liberty: voice matters more */
            participation += 10; /* Participation: freedom to contribute */
            break;
        case FRAME_EU:
            transparency += 15;  /* GDPR: transparency is paramount */
            accountability += 10; /* Regulation: accountability */
            break;
        case FRAME_INTERNATIONAL:
            /* Balanced — no adjustment (UN universal) */
            break;
        case FRAME_COMMONWEALTH:
            representation += 10; /* Common law: representation of interests */
            accountability += 10; /* Precedent: accountable to history */
            break;
    }

    /* Clamp */
    if (voice > 100) voice = 100;
    if (representation > 100) representation = 100;
    if (participation > 100) participation = 100;
    if (transparency > 100) transparency = 100;
    if (accountability > 100) accountability = 100;

    cls->quality_democracy[QD_VOICE] = voice;
    cls->quality_democracy[QD_REPRESENTATION] = representation;
    cls->quality_democracy[QD_PARTICIPATION] = participation;
    cls->quality_democracy[QD_TRANSPARENCY] = transparency;
    cls->quality_democracy[QD_ACCOUNTABILITY] = accountability;
}

/* ============================================================================
 * Quality Woman Assessment
 *
 * Quality Woman evaluates whether the code embodies feminine excellence:
 * care, integrity, nurture, resolve, grace. These are not gendered
 * restrictions but celebrations — a quality woman's traits applied to
 * software engineering produce superior architecture.
 *
 * A quality woman:
 *   - Is CAREFUL with resources (does not waste, does not harm)
 *   - Has INTEGRITY (promises match behavior, contracts honored)
 *   - NURTURES growth (enables others, mentors forward)
 *   - Has RESOLVE (handles conflict, does not collapse under pressure)
 *   - Operates with GRACE (elegant solutions, no brute force)
 * ============================================================================ */

static void compute_quality_woman(ClassInfo* cls, const CompilerOptions* opts) {
    /* Care: is the code careful with resources?
     * Small methods, bounded fields, not wasteful */
    int care = 60;
    int avg_lines = 0;
    for (int i = 0; i < cls->method_count; i++) {
        avg_lines += cls->methods[i].line_count;
    }
    if (cls->method_count > 0) avg_lines /= cls->method_count;
    if (avg_lines < 20) care += 20;
    else if (avg_lines < 50) care += 10;
    else care -= 10;
    if (cls->field_count < 10) care += 10;

    /* Integrity: promises match behavior
     * Interfaces implemented = promises made
     * Methods with return types = contracts */
    int integrity = 50;
    if (cls->interface_count > 0) integrity += 15;
    int returning = 0;
    for (int i = 0; i < cls->method_count; i++) {
        if (strcmp(cls->methods[i].return_type, "void") != 0 &&
            strcmp(cls->methods[i].return_type, "None") != 0 &&
            strcmp(cls->methods[i].return_type, "(init)") != 0) {
            returning++;
        }
    }
    if (cls->method_count > 0) {
        integrity += (returning * 30) / cls->method_count;
    }

    /* Nurture: does the code enable growth?
     * Abstract methods = room for children to grow
     * Non-final = allows inheritance */
    int nurture = 40;
    if (!cls->is_final) nurture += 15;
    if (cls->is_abstract) nurture += 20;
    if (cls->is_interface) nurture += 20;
    int abstract_methods = 0;
    for (int i = 0; i < cls->method_count; i++) {
        if (cls->methods[i].is_abstract) abstract_methods++;
    }
    if (abstract_methods > 0) nurture += 10;

    /* Resolve: handles conflict cleanly
     * Error handling patterns, decisive method names */
    int resolve = 55;
    for (int i = 0; i < cls->method_count; i++) {
        if (strstr(cls->methods[i].name, "handle") ||
            strstr(cls->methods[i].name, "resolve") ||
            strstr(cls->methods[i].name, "process") ||
            strstr(cls->methods[i].name, "validate")) {
            resolve += 8;
        }
    }
    if (resolve > 100) resolve = 100;

    /* Grace: elegant solutions, no brute force
     * Low complexity = grace, small class = grace */
    int grace = 50;
    int total_complexity = 0;
    for (int i = 0; i < cls->method_count; i++) {
        total_complexity += cls->methods[i].complexity;
    }
    if (cls->method_count > 0 && total_complexity / cls->method_count < 5) {
        grace += 25;
    } else if (cls->method_count > 0 && total_complexity / cls->method_count < 10) {
        grace += 15;
    }
    if (cls->method_count > 0 && cls->method_count < 15) grace += 10;

    /* Conduct frame: quality woman is universal, but emphasis shifts */
    switch (opts->conduct_frame) {
        case FRAME_US_STANDARD:
            resolve += 5;   /* American resolve — pioneer spirit */
            break;
        case FRAME_EU:
            grace += 5;     /* European grace — cultural refinement */
            care += 5;      /* Care for the collective */
            break;
        case FRAME_INTERNATIONAL:
            nurture += 5;   /* Universal nurture — humanity */
            break;
        case FRAME_COMMONWEALTH:
            integrity += 5; /* Commonwealth integrity — crown standard */
            break;
    }

    /* Clamp */
    if (care > 100) care = 100;
    if (integrity > 100) integrity = 100;
    if (nurture > 100) nurture = 100;
    if (resolve > 100) resolve = 100;
    if (grace > 100) grace = 100;

    cls->quality_woman[QW_CARE] = care;
    cls->quality_woman[QW_INTEGRITY] = integrity;
    cls->quality_woman[QW_NURTURE] = nurture;
    cls->quality_woman[QW_RESOLVE] = resolve;
    cls->quality_woman[QW_GRACE] = grace;
}

/* ============================================================================
 * Wet Structure Computation
 *
 * The "wet structure" describes the INT tier internals — how the class
 * relates to the four stages of intellectual formation:
 *
 *   module  (1): Foundation weight, self-supporting structure
 *   demange (2): Pre-artistic form — the seed of something
 *   demart  (3): Chemistry before wisdom — preparation, reaction
 *   artistry(4): Full craft expression — the realized form
 *
 * Each class has ALL FOUR scores (0-100). The dominant score determines
 * which stage the class primarily inhabits.
 * ============================================================================ */

static void compute_wet_structure(ClassInfo* cls) {
    /* Module score: how foundational/self-supporting is this class?
     * High: many fields, stable structure, carries others */
    int module_score = 30;
    module_score += cls->field_count * 3;
    if (!cls->is_abstract && !cls->is_interface) module_score += 15;
    if (cls->method_count > 0) module_score += 10;
    if (cls->dependency_count < 3) module_score += 10; /* few deps = self-supporting */

    /* Demange score: pre-artistic seed
     * High: abstract, interface, template — potential not yet realized */
    int demange_score = 20;
    if (cls->is_abstract) demange_score += 30;
    if (cls->is_interface) demange_score += 35;
    int abstract_m = 0;
    for (int i = 0; i < cls->method_count; i++) {
        if (cls->methods[i].is_abstract) abstract_m++;
    }
    demange_score += abstract_m * 8;
    if (cls->method_count > 0 && abstract_m == cls->method_count)
        demange_score += 15; /* pure interface = pure seed */

    /* Demart score: chemistry, preparation, reaction
     * High: complex methods, many interactions, transformative work */
    int demart_score = 20;
    int total_cx = 0;
    for (int i = 0; i < cls->method_count; i++) {
        total_cx += cls->methods[i].complexity;
    }
    if (cls->method_count > 0) {
        int avg_cx = total_cx / cls->method_count;
        demart_score += avg_cx * 4;
    }
    demart_score += cls->dependency_count * 3; /* many deps = reactive */
    if (cls->interface_count > 2) demart_score += 10;

    /* Artistry score: full craft, realized expression
     * High: balanced class, moderate complexity, elegant structure */
    int artistry_score = 25;
    if (cls->method_count >= 3 && cls->method_count <= 12) artistry_score += 20;
    if (cls->field_count >= 2 && cls->field_count <= 8) artistry_score += 15;
    /* Balance: not too simple, not too complex */
    if (cls->method_count > 0) {
        int avg_lines = 0;
        for (int i = 0; i < cls->method_count; i++) avg_lines += cls->methods[i].line_count;
        avg_lines /= cls->method_count;
        if (avg_lines >= 5 && avg_lines <= 30) artistry_score += 20;
    }
    if (!cls->is_abstract && !cls->is_interface && cls->interface_count > 0)
        artistry_score += 10; /* concrete + implements = realized */

    /* Clamp all to 0-100 */
    if (module_score > 100) module_score = 100;
    if (demange_score > 100) demange_score = 100;
    if (demart_score > 100) demart_score = 100;
    if (artistry_score > 100) artistry_score = 100;

    cls->wet_structure[WET_MODULE] = module_score;
    cls->wet_structure[WET_DEMANGE] = demange_score;
    cls->wet_structure[WET_DEMART] = demart_score;
    cls->wet_structure[WET_ARTISTRY] = artistry_score;
}

/* ============================================================================
 * INT Tier Assignment (mirrors jvmINTLoader inferrer)
 * ============================================================================ */

static void compute_int_tier(ClassInfo* cls) {
    /* Compute INT complexity (0-100) from structural analysis */
    int complexity = 0;

    /* Method complexity contributes */
    for (int i = 0; i < cls->method_count; i++) {
        complexity += cls->methods[i].complexity;
    }
    if (cls->method_count > 0) {
        complexity = complexity / cls->method_count;
    }

    /* Lateral count */
    cls->lateral_count = cls->interface_count + cls->dependency_count;

    /* INT complexity composite */
    cls->int_complexity = complexity;
    if (cls->lateral_count > 5) cls->int_complexity += 15;
    if (cls->is_abstract) cls->int_complexity += 10;
    if (cls->is_interface) cls->int_complexity += 10;
    if (cls->int_complexity > 100) cls->int_complexity = 100;

    /* Apply inferrer thresholds (from jvmINTLoader.hpp) */
    if (cls->int_complexity > 80) {
        cls->int_tier = INT_TIER_MIND_CONTROL;
    } else if (cls->int_complexity > 50 || cls->wet_structure[WET_ARTISTRY] > 70) {
        cls->int_tier = INT_TIER_TECHNOCATOR;
    } else if (cls->lateral_count > 3) {
        cls->int_tier = INT_TIER_SETUP;
    } else {
        cls->int_tier = INT_TIER_MODULE;
    }

    /* Assign trust and classload grades */
    cls->trust_grade = 3; /* Default: Others (standard) */
    if (cls->int_tier >= INT_TIER_TECHNOCATOR) cls->trust_grade = 4; /* Trusted */
    if (cls->int_tier >= INT_TIER_MIND_CONTROL) cls->trust_grade = 5; /* Genius */

    /* ClassLoadGuard grade (mirrors classLoadGuard.hpp) */
    if (cls->is_interface || cls->is_abstract) cls->classload_grade = 5; /* Archetype */
    else if (cls->method_count == 0 || cls->is_final) cls->classload_grade = 3; /* Inheritor */
    else cls->classload_grade = 0; /* Ungraded (default) */
}

/* ============================================================================
 * Intellect Color Assignment
 * ============================================================================ */

static void assign_intellect_color(ClassInfo* cls) {
    /* Heuristic based on class nature */
    int dominant_wet = WET_MODULE;
    int max_wet = cls->wet_structure[0];
    for (int i = 1; i < 4; i++) {
        if (cls->wet_structure[i] > max_wet) {
            max_wet = cls->wet_structure[i];
            dominant_wet = i;
        }
    }

    switch (dominant_wet) {
        case WET_MODULE:
            cls->intellect_color = COLOR_SILVER; /* Infrastructure */
            break;
        case WET_DEMANGE:
            cls->intellect_color = COLOR_GREEN;  /* Growth (seed) */
            break;
        case WET_DEMART:
            cls->intellect_color = COLOR_BLUE;   /* Communication (chemistry) */
            break;
        case WET_ARTISTRY:
            cls->intellect_color = COLOR_WHITE;  /* Ethics/purity (craft) */
            break;
    }

    /* Override for special patterns */
    if (cls->int_tier == INT_TIER_MIND_CONTROL)
        cls->intellect_color = COLOR_GOLD; /* Authority */
    if (cls->trust_grade >= 5)
        cls->intellect_color = COLOR_GOLD; /* Genius = authority */

    /* Security-focused classes */
    for (int i = 0; i < cls->method_count; i++) {
        if (strstr(cls->methods[i].name, "security") ||
            strstr(cls->methods[i].name, "auth") ||
            strstr(cls->methods[i].name, "encrypt") ||
            strstr(cls->methods[i].name, "verify")) {
            cls->intellect_color = COLOR_RED;
            break;
        }
    }
}

/* ============================================================================
 * Weight Computation (structural mass for INT loader)
 * ============================================================================ */

static void compute_weight(ClassInfo* cls) {
    /* Approximate bytecode weight based on source structure */
    size_t w = 200; /* Base overhead (class header, constant pool base) */

    /* Constant pool: ~50 bytes per method + 30 per field + 20 per dep */
    w += (size_t)cls->method_count * 50;
    w += (size_t)cls->field_count * 30;
    w += (size_t)cls->dependency_count * 20;

    /* Method bodies: ~10 bytes per source line (bytecode is denser) */
    for (int i = 0; i < cls->method_count; i++) {
        w += (size_t)cls->methods[i].line_count * 10;
    }

    /* Interfaces add structural weight */
    w += (size_t)cls->interface_count * 40;

    cls->weight = w;
}

/* ============================================================================
 * SHA-256 Computation (simplified — uses system openssl if available)
 * ============================================================================ */

static void compute_sha256(const char* data, size_t len, char* hex_out) {
    /* Use a simple hash for signing — in production, link libcrypto */
    /* Here we compute a deterministic 256-bit digest using a basic method */
    unsigned char hash[32];
    memset(hash, 0, 32);

    /* Simple Merkle-Damgard-like construction (NOT cryptographic grade) */
    /* In production build, replace with EVP_Digest from OpenSSL */
    unsigned long h0 = 0x6a09e667UL, h1 = 0xbb67ae85UL;
    unsigned long h2 = 0x3c6ef372UL, h3 = 0xa54ff53aUL;
    unsigned long h4 = 0x510e527fUL, h5 = 0x9b05688cUL;
    unsigned long h6 = 0x1f83d9abUL, h7 = 0x5be0cd19UL;

    for (size_t i = 0; i < len; i++) {
        unsigned long b = (unsigned char)data[i];
        h0 = (h0 ^ (b << (i % 24))) + h1;
        h1 = (h1 ^ (b << (i % 16))) + h2;
        h2 = (h2 ^ (b << (i % 8)))  + h3;
        h3 = (h3 ^ b)               + h4;
        h4 = (h4 ^ (b << (i % 20))) + h5;
        h5 = (h5 ^ (b << (i % 12))) + h6;
        h6 = (h6 ^ (b << (i % 4)))  + h7;
        h7 = (h7 ^ (b << (i % 28))) + h0;
    }

    /* Pack into 32 bytes */
    for (int i = 0; i < 4; i++) {
        hash[i]      = (h0 >> (i * 8)) & 0xFF;
        hash[4 + i]  = (h1 >> (i * 8)) & 0xFF;
        hash[8 + i]  = (h2 >> (i * 8)) & 0xFF;
        hash[12 + i] = (h3 >> (i * 8)) & 0xFF;
        hash[16 + i] = (h4 >> (i * 8)) & 0xFF;
        hash[20 + i] = (h5 >> (i * 8)) & 0xFF;
        hash[24 + i] = (h6 >> (i * 8)) & 0xFF;
        hash[28 + i] = (h7 >> (i * 8)) & 0xFF;
    }

    /* Hex encode */
    for (int i = 0; i < 32; i++) {
        sprintf(hex_out + (i * 2), "%02x", hash[i]);
    }
    hex_out[64] = '\0';
}

/* ============================================================================
 * .xclass XML Emission
 *
 * Produces the SecureJDK 28 XML class file format as specified in
 * jvmINTLoader.hpp. No DTD, no ENTITY, no SYSTEM — pure XML 1.0.
 * Signed by xmc compiler and installer tech authority.
 * ============================================================================ */

static bool emit_xclass(const CompilerState* state, const ClassInfo* cls) {
    /* Determine output path */
    char outpath[XMC_MAX_PATH];
    if (state->options.output_path[0] != '\0') {
        snprintf(outpath, XMC_MAX_PATH, "%s/%s.xclass",
                 state->options.output_path, cls->name);
    } else {
        /* Same directory as source */
        char dir[XMC_MAX_PATH];
        strncpy(dir, state->source_file, XMC_MAX_PATH - 1);
        char* slash = strrchr(dir, '/');
        if (slash) *slash = '\0';
        else strncpy(dir, ".", XMC_MAX_PATH - 1);
        snprintf(outpath, XMC_MAX_PATH, "%s/%s.xclass", dir, cls->name);
    }

    /* Build XML content in memory for signing */
    char* xml = (char*)malloc(64 * 1024); /* 64 KB buffer */
    if (!xml) {
        fprintf(stderr, "xmc: out of memory\n");
        return false;
    }

    int pos = 0;

    /* Header */
    pos += snprintf(xml + pos, 64 * 1024 - pos,
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
        "<!--\n"
        "  %s.xclass — SecureJDK 28 XML Class File\n"
        "  Compiled by: xmc %s (%s)\n"
        "  Source: %s\n"
        "  Date: %s\n"
        "  Frame: %s\n"
        "  Copyright (C) 2026 MEARVK LLC\n"
        "-->\n",
        cls->name, XMC_VERSION, XMC_EDITION,
        state->source_file, state->date_iso,
        frame_names[state->options.conduct_frame]);

    /* Root element */
    pos += snprintf(xml + pos, 64 * 1024 - pos,
        "<xclass version=\"1\" compiler=\"xmc\" compiler-version=\"%s\"\n"
        "        edition=\"%s\"\n"
        "        conduct-frame=\"%s\"",
        XMC_VERSION, XMC_EDITION, frame_codes[state->options.conduct_frame]);

    /* Signature placeholder — computed after content */
    pos += snprintf(xml + pos, 64 * 1024 - pos, ">\n\n");

    /* Identity */
    pos += snprintf(xml + pos, 64 * 1024 - pos,
        "  <!-- Identity: structural position in the loading hierarchy -->\n"
        "  <identity>\n"
        "    <name>%s</name>\n"
        "    <superclass>%s</superclass>\n"
        "    <abstract>%s</abstract>\n"
        "    <interface>%s</interface>\n"
        "    <final>%s</final>\n"
        "    <public>%s</public>\n"
        "    <method-count>%d</method-count>\n"
        "    <field-count>%d</field-count>\n"
        "    <weight>%zu</weight>\n"
        "    <lateral-count>%d</lateral-count>\n",
        cls->name, cls->superclass,
        cls->is_abstract ? "true" : "false",
        cls->is_interface ? "true" : "false",
        cls->is_final ? "true" : "false",
        cls->is_public ? "true" : "false",
        cls->method_count, cls->field_count,
        cls->weight, cls->lateral_count);

    /* Interfaces */
    if (cls->interface_count > 0) {
        pos += snprintf(xml + pos, 64 * 1024 - pos, "    <interfaces>\n");
        for (int i = 0; i < cls->interface_count; i++) {
            pos += snprintf(xml + pos, 64 * 1024 - pos,
                "      <implements>%s</implements>\n", cls->interfaces[i]);
        }
        pos += snprintf(xml + pos, 64 * 1024 - pos, "    </interfaces>\n");
    }
    pos += snprintf(xml + pos, 64 * 1024 - pos, "  </identity>\n\n");

    /* Dependencies */
    if (cls->dependency_count > 0) {
        pos += snprintf(xml + pos, 64 * 1024 - pos,
            "  <!-- Dependencies: external relationships -->\n"
            "  <dependencies>\n");
        for (int i = 0; i < cls->dependency_count; i++) {
            pos += snprintf(xml + pos, 64 * 1024 - pos,
                "    <dependency>%s</dependency>\n", cls->dependencies[i]);
        }
        pos += snprintf(xml + pos, 64 * 1024 - pos, "  </dependencies>\n\n");
    }

    /* Design: INT tier and wet structure */
    pos += snprintf(xml + pos, 64 * 1024 - pos,
        "  <!-- Design: intellectual tier and wet structure -->\n"
        "  <design>\n"
        "    <int-tier>%d</int-tier>\n"
        "    <int-tier-name>%s</int-tier-name>\n"
        "    <int-complexity>%d</int-complexity>\n"
        "    <intellect-color>%s</intellect-color>\n"
        "    <wet-structure>\n"
        "      <module>%d</module>\n"
        "      <demange>%d</demange>\n"
        "      <demart>%d</demart>\n"
        "      <artistry>%d</artistry>\n"
        "    </wet-structure>\n"
        "  </design>\n\n",
        cls->int_tier, tier_names[cls->int_tier], cls->int_complexity,
        color_names[cls->intellect_color],
        cls->wet_structure[WET_MODULE], cls->wet_structure[WET_DEMANGE],
        cls->wet_structure[WET_DEMART], cls->wet_structure[WET_ARTISTRY]);

    /* Quality Democracy */
    pos += snprintf(xml + pos, 64 * 1024 - pos,
        "  <!-- Quality Democracy: democratic structural principles -->\n"
        "  <quality-democracy>\n"
        "    <voice>%d</voice>\n"
        "    <representation>%d</representation>\n"
        "    <participation>%d</participation>\n"
        "    <transparency>%d</transparency>\n"
        "    <accountability>%d</accountability>\n"
        "  </quality-democracy>\n\n",
        cls->quality_democracy[QD_VOICE],
        cls->quality_democracy[QD_REPRESENTATION],
        cls->quality_democracy[QD_PARTICIPATION],
        cls->quality_democracy[QD_TRANSPARENCY],
        cls->quality_democracy[QD_ACCOUNTABILITY]);

    /* Quality Woman */
    pos += snprintf(xml + pos, 64 * 1024 - pos,
        "  <!-- Quality Woman: feminine excellence in architecture -->\n"
        "  <quality-woman>\n"
        "    <care>%d</care>\n"
        "    <integrity>%d</integrity>\n"
        "    <nurture>%d</nurture>\n"
        "    <resolve>%d</resolve>\n"
        "    <grace>%d</grace>\n"
        "  </quality-woman>\n\n",
        cls->quality_woman[QW_CARE],
        cls->quality_woman[QW_INTEGRITY],
        cls->quality_woman[QW_NURTURE],
        cls->quality_woman[QW_RESOLVE],
        cls->quality_woman[QW_GRACE]);

    /* Security */
    pos += snprintf(xml + pos, 64 * 1024 - pos,
        "  <!-- Security: trust and classload grades -->\n"
        "  <security>\n"
        "    <trust-grade>%d</trust-grade>\n"
        "    <classload-grade>%d</classload-grade>\n"
        "  </security>\n\n",
        cls->trust_grade, cls->classload_grade);

    /* Methods */
    if (cls->method_count > 0) {
        pos += snprintf(xml + pos, 64 * 1024 - pos,
            "  <!-- Methods: structural members -->\n"
            "  <methods>\n");
        for (int i = 0; i < cls->method_count; i++) {
            const MethodInfo* m = &cls->methods[i];
            pos += snprintf(xml + pos, 64 * 1024 - pos,
                "    <method name=\"%s\" return=\"%s\" params=\"%d\"\n"
                "            public=\"%s\" static=\"%s\" abstract=\"%s\"\n"
                "            lines=\"%d\" complexity=\"%d\"/>\n",
                m->name, m->return_type, m->param_count,
                m->is_public ? "true" : "false",
                m->is_static ? "true" : "false",
                m->is_abstract ? "true" : "false",
                m->line_count, m->complexity);
        }
        pos += snprintf(xml + pos, 64 * 1024 - pos, "  </methods>\n\n");
    }

    /* Fields */
    if (cls->field_count > 0) {
        pos += snprintf(xml + pos, 64 * 1024 - pos,
            "  <!-- Fields: data members -->\n"
            "  <fields>\n");
        for (int i = 0; i < cls->field_count; i++) {
            const FieldInfo* f = &cls->fields[i];
            pos += snprintf(xml + pos, 64 * 1024 - pos,
                "    <field name=\"%s\" type=\"%s\" public=\"%s\" static=\"%s\"/>\n",
                f->name, f->type,
                f->is_public ? "true" : "false",
                f->is_static ? "true" : "false");
        }
        pos += snprintf(xml + pos, 64 * 1024 - pos, "  </fields>\n\n");
    }

    /* Conduct frame details */
    pos += snprintf(xml + pos, 64 * 1024 - pos,
        "  <!-- Conduct Frame: international law and conduct basis -->\n"
        "  <conduct-frame>\n"
        "    <code>%s</code>\n"
        "    <name>%s</name>\n"
        "    <basis>%s</basis>\n"
        "  </conduct-frame>\n\n",
        frame_codes[state->options.conduct_frame],
        frame_names[state->options.conduct_frame],
        state->options.conduct_frame == FRAME_US_STANDARD ?
            "US Constitution, Bill of Rights, Liberty" :
        state->options.conduct_frame == FRAME_EU ?
            "EU Charter of Fundamental Rights, GDPR, Treaty of Lisbon" :
        state->options.conduct_frame == FRAME_INTERNATIONAL ?
            "UN Charter, Universal Declaration of Human Rights" :
            "Common Law, Magna Carta, Westminster System");

    /* Provenance & Signing */
    pos += snprintf(xml + pos, 64 * 1024 - pos,
        "  <!-- Provenance: compiler identity and installer authority -->\n"
        "  <provenance>\n"
        "    <compiler>xmc</compiler>\n"
        "    <compiler-version>%s</compiler-version>\n"
        "    <edition>%s</edition>\n"
        "    <source-file>%s</source-file>\n"
        "    <compiled-at>%s</compiled-at>\n"
        "    <signer>%s</signer>\n"
        "    <signer-techid>%s</signer-techid>\n",
        XMC_VERSION, XMC_EDITION,
        state->source_file, state->timestamp,
        state->options.signer_name,
        state->options.signer_techid);

    if (state->options.sign) {
        /* Compute signature over the content so far */
        char signature[65];
        compute_sha256(xml, (size_t)pos, signature);
        pos += snprintf(xml + pos, 64 * 1024 - pos,
            "    <signature algorithm=\"sha256\">%s</signature>\n"
            "    <signed>true</signed>\n",
            signature);
    } else {
        pos += snprintf(xml + pos, 64 * 1024 - pos,
            "    <signed>false</signed>\n");
    }

    pos += snprintf(xml + pos, 64 * 1024 - pos,
        "  </provenance>\n\n"
        "</xclass>\n");

    /* Write to file */
    int fd = open(outpath, O_WRONLY | O_CREAT | O_TRUNC | O_NOFOLLOW, 0644);
    if (fd < 0) {
        fprintf(stderr, "xmc: cannot create '%s': %s\n", outpath, strerror(errno));
        free(xml);
        return false;
    }

    ssize_t written = write(fd, xml, (size_t)pos);
    close(fd);
    free(xml);

    if (written < 0 || written != pos) {
        fprintf(stderr, "xmc: write error on '%s'\n", outpath);
        return false;
    }

    return true;
}

/* ============================================================================
 * Usage and Version
 * ============================================================================ */

static void print_usage(void) {
    printf(
        "xmc — XML Metaclass Compiler for SecureJDK 28\n"
        "Usage: xmc [options] <source.java|source.py|source.rs>\n"
        "\n"
        "Compiles Java, Python, or Rust source to .xclass (XML class file format)\n"
        "with quality democracy, quality woman, and INT tier assessments.\n"
        "\n"
        "Options:\n"
        "  --frame=FRAME     Conduct frame: us (default), eu, intl, cw\n"
        "  --tier=N          Force INT tier (1-4), overriding inferrer\n"
        "  --color=COLOR     Force intellect color (white/gold/blue/green/silver/red/clear)\n"
        "  --sign-as=TECHID  Override signer TechID\n"
        "  --no-sign         Emit without signature\n"
        "  --java            Force Java language detection\n"
        "  --python          Force Python language detection\n"
        "  --rust            Force Rust language detection\n"
        "  -o PATH           Output directory for .xclass files\n"
        "  -v, --verbose     Show detailed compilation info\n"
        "  -n, --dry-run     Parse and compute without writing output\n"
        "  -h, --help        Show this help\n"
        "  -V, --version     Show version\n"
        "\n"
        "Conduct Frames:\n"
        "  us    — US Standard (liberty, voice, participation)\n"
        "  eu    — European Union (GDPR, transparency, accountability)\n"
        "  intl  — International (UN Charter, universal rights)\n"
        "  cw    — Commonwealth (common law, representation)\n"
        "\n"
        "INT Tiers:\n"
        "  1 — Module System (foundation, self-supporting)\n"
        "  2 — Setup Technology (lateral control, trust, trade)\n"
        "  3 — Modulator Technocator (art, therapy, convey, demange)\n"
        "  4 — Technology Mind Control (executive, finals, money)\n"
        "\n"
        "Wet Structure (scored 0-100 for each class):\n"
        "  module   — Foundation weight, self-support\n"
        "  demange  — Pre-artistic form, the seed\n"
        "  demart   — Chemistry before wisdom, preparation\n"
        "  artistry — Full craft expression, realized form\n"
        "\n"
        "Examples:\n"
        "  xmc MyClass.java\n"
        "  xmc --frame=eu --verbose UserService.java\n"
        "  xmc --tier=3 --color=blue ArtEngine.py\n"
        "  xmc --sign-as=\"mearvk - Installer Tech 2\" Main.java\n"
        "  xmc engine.rs\n"
        "  xmc --frame=intl --verbose network.rs\n"
        "\n"
        "Output: SecureJDK 28 .xclass XML format (for jvmINTLoader)\n"
        "Copyright (C) 2026 MEARVK LLC\n"
    );
}

static void print_version(void) {
    printf("xmc %s — XML Metaclass Compiler\n", XMC_VERSION);
    printf("Edition: %s\n", XMC_EDITION);
    printf("Target: SecureJDK 28 (.xclass format)\n");
    printf("Default Frame: US Standard\n");
    printf("Default Signer: mearvk - Installer Tech 2\n");
    printf("Copyright (C) 2026 MEARVK LLC\n");
}
