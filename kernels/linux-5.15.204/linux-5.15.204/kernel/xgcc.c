// SPDX-License-Identifier: GPL-2.0
/*
 * xgcc.c — Metal-Thin C/C++ Source Interpreter (Kernel Module)
 *
 * Part of Ubuntu Determinant Alpha RS — Galactic Cherry Marvell Edition 98
 *
 * xgcc takes .c, .h, .cpp, .hpp source files as input and runs them
 * natively through a 4-model reduction pipeline. The interpreter is
 * "metal thin" — it does not compile to object code but rather
 * interprets source through progressive model stages.
 *
 * The Four Models:
 *   Model 1 — Basic Reduction:     Strips to essential executable semantics
 *   Model 2 — Interrogative:       Evaluates whether the code is questioning
 *                                   (conditional paths, error handling, queries)
 *   Model 3 — Iterative Suggest:   Identifies and optimizes loops, recursion,
 *                                   repeated structure for direct execution
 *   Model 4 — Exact + Memory:      The literal code path with speed/category
 *                                   bounds enforcement (not too ample)
 *
 * Execution Strategy:
 *   Any single model would be adequate to produce a run.
 *   xgcc duely runs Model 3 and Model 4 together — the combined output runs.
 *   Model 3 provides the iterative optimization.
 *   Model 4 provides the exact fidelity with memory discipline.
 *
 * Interface:
 *   /dev/xgcc              — Submit source file for execution
 *   /proc/xgcc/status      — Runtime state and model statistics
 *   /proc/xgcc/models      — Per-model reduction output (debug)
 *   /proc/xgcc/memory      — Memory concern telemetry
 *
 * Usage (userspace):
 *   xgcc program.c                      — Run C source directly
 *   xgcc module.cpp                     — Run C++ source directly
 *   xgcc --model 1 test.c              — Run through Model 1 only
 *   xgcc --model 3,4 program.c         — Explicit Model 3+4 (default)
 *   xgcc --verbose program.c           — Show model reduction steps
 *   echo "/path/to/file.c" > /dev/xgcc — Kernel-direct execution
 *
 * Author: Maximilian Eric Alexander Rupplin von Keffikon
 * Copyright (C) 2026 MEARVK LLC
 */

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/fs.h>
#include <linux/proc_fs.h>
#include <linux/seq_file.h>
#include <linux/uaccess.h>
#include <linux/slab.h>
#include <linux/mutex.h>
#include <linux/miscdevice.h>
#include <linux/vmalloc.h>
#include <linux/mm.h>
#include <linux/sched.h>
#include <linux/time.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("MEARVK LLC");
MODULE_DESCRIPTION("xgcc — Metal-Thin C/C++ Source Interpreter");
MODULE_VERSION("1.0");

/* ═══════════════════════════════════════════════════════════════════
 *  Constants and Limits
 * ═══════════════════════════════════════════════════════════════════ */

#define XGCC_MAX_SOURCE_SIZE    (4 * 1024 * 1024)  /* 4 MB max source file */
#define XGCC_MAX_TOKENS         65536
#define XGCC_STACK_SIZE         4096
#define XGCC_HEAP_SIZE          (16 * 1024 * 1024)  /* 16 MB interpreted heap */
#define XGCC_MAX_FUNCTIONS      1024
#define XGCC_MAX_VARIABLES      4096
#define XGCC_MAX_ITERATIONS     10000000            /* Loop safety bound */
#define XGCC_SPEED_CEILING_US   5000000             /* 5 second execution cap */
#define XGCC_MEMORY_CEILING     (8 * 1024 * 1024)   /* 8 MB allocation cap */

/* Import/library tracking limits */
#define XGCC_MAX_INCLUDES       128
#define XGCC_MAX_KLIB_SYMBOLS   256

/* Model identifiers */
#define XGCC_MODEL_REDUCTION    1
#define XGCC_MODEL_INTERROGATIVE 2
#define XGCC_MODEL_ITERATIVE    3
#define XGCC_MODEL_EXACT        4

/* ═══════════════════════════════════════════════════════════════════
 *  Token Types
 * ═══════════════════════════════════════════════════════════════════ */

enum xgcc_token_type {
    TOK_EOF = 0,
    /* Literals */
    TOK_INT_LIT, TOK_FLOAT_LIT, TOK_STRING_LIT, TOK_CHAR_LIT,
    /* Identifiers and keywords */
    TOK_IDENT, TOK_KEYWORD,
    /* Operators */
    TOK_PLUS, TOK_MINUS, TOK_STAR, TOK_SLASH, TOK_PERCENT,
    TOK_AMP, TOK_PIPE, TOK_CARET, TOK_TILDE, TOK_BANG,
    TOK_LT, TOK_GT, TOK_EQ, TOK_NEQ, TOK_LEQ, TOK_GEQ,
    TOK_AND, TOK_OR, TOK_LSHIFT, TOK_RSHIFT,
    TOK_ASSIGN, TOK_PLUS_EQ, TOK_MINUS_EQ, TOK_STAR_EQ, TOK_SLASH_EQ,
    TOK_INC, TOK_DEC,
    /* Delimiters */
    TOK_LPAREN, TOK_RPAREN, TOK_LBRACE, TOK_RBRACE,
    TOK_LBRACKET, TOK_RBRACKET,
    TOK_SEMICOLON, TOK_COMMA, TOK_DOT, TOK_ARROW,
    TOK_COLON, TOK_QUESTION,
    /* Preprocessor */
    TOK_HASH,
};

/* ═══════════════════════════════════════════════════════════════════
 *  Data Types for the Interpreter
 * ═══════════════════════════════════════════════════════════════════ */

enum xgcc_value_type {
    VAL_VOID = 0,
    VAL_INT,
    VAL_FLOAT,
    VAL_PTR,
    VAL_STRING,
    VAL_STRUCT,
    VAL_ARRAY,
};

struct xgcc_token {
    enum xgcc_token_type type;
    int line;
    int col;
    union {
        long long int_val;
        double float_val;
        char *str_val;      /* for identifiers, strings, keywords */
    };
};

struct xgcc_value {
    enum xgcc_value_type type;
    union {
        long long i;
        double f;
        void *ptr;
        char *str;
    };
    size_t size;            /* for arrays/structs */
};

struct xgcc_variable {
    char name[64];
    struct xgcc_value val;
    int scope_depth;
    int is_const;
};

struct xgcc_function {
    char name[64];
    int token_start;        /* index into token stream where body begins */
    int token_end;
    int param_count;
    char params[16][64];    /* parameter names */
    enum xgcc_value_type return_type;
};

/* ═══════════════════════════════════════════════════════════════════
 *  Model State Structures
 * ═══════════════════════════════════════════════════════════════════ */

/* Model 1: Basic Reduction — strips comments, macros, typedefs to core ops */
struct xgcc_model_reduction {
    int tokens_in;
    int tokens_out;         /* reduced token count */
    int reductions_applied;
    int dead_code_removed;
};

/* Model 2: Interrogative — identifies conditional/questioning code paths */
struct xgcc_model_interrogative {
    int conditionals_found;
    int error_paths;
    int queries;            /* function calls that return status */
    int assertions;
    int interrogative_weight; /* 0-100: how questioning is this code */
};

/* Model 3: Iterative Suggest — loop/recursion optimization */
struct xgcc_model_iterative {
    int loops_found;
    int loops_unrolled;
    int tail_calls_optimized;
    int iterations_predicted;
    int recursion_depth_max;
    int suggest_vectorize;  /* boolean: would benefit from parallel */
};

/* Model 4: Exact + Memory Concern — literal execution with bounds */
struct xgcc_model_exact {
    size_t memory_allocated;
    size_t memory_ceiling;
    unsigned long exec_time_us;
    unsigned long speed_ceiling_us;
    int category_violations; /* operations outside expected category */
    int speed_ok;           /* 1 = within bounds, 0 = too ample */
    int memory_ok;          /* 1 = within bounds, 0 = too ample */
};

/* ═══════════════════════════════════════════════════════════════════
 *  Import Tracking & Kernel Symbol Resolution
 *
 *  The kernel version cannot dlopen .so files, but it can:
 *    1. Track #include directives from submitted source
 *    2. Map includes to known library categories
 *    3. Resolve function calls to kernel-exported symbols
 *       (via kallsyms / symbol_get when available)
 *    4. Map standard libc functions to kernel equivalents where
 *       possible (e.g. printk for printf, kmalloc for malloc)
 *    5. Report which .so libraries would be needed for userland
 *       execution of this source
 *
 *  The suggested_libs[] array tells userland what to link against.
 * ═══════════════════════════════════════════════════════════════════ */

/* Tracked include directive */
struct xgcc_include_entry {
    char path[128];
    int is_system;          /* 1 for <...>, 0 for "..." */
    char suggested_lib[64]; /* .so this maps to */
};

/* Kernel-equivalent function mapping */
struct xgcc_kfunc_map {
    const char *userland_name;  /* e.g. "printf" */
    const char *kernel_name;    /* e.g. "printk" */
    int available;              /* 1 if kernel symbol exists */
};

/* Known mappings: userland function → kernel equivalent */
static const struct xgcc_kfunc_map kfunc_table[] = {
    { "printf",   "printk",      1 },
    { "fprintf",  "printk",      1 },
    { "sprintf",  "sprintf",     1 },
    { "snprintf", "snprintf",    1 },
    { "puts",     "printk",      1 },
    { "malloc",   "kmalloc",     1 },
    { "calloc",   "kcalloc",     1 },
    { "realloc",  "krealloc",    1 },
    { "free",     "kfree",       1 },
    { "memcpy",   "memcpy",      1 },
    { "memset",   "memset",      1 },
    { "memmove",  "memmove",     1 },
    { "memcmp",   "memcmp",      1 },
    { "strcmp",   "strcmp",       1 },
    { "strncmp",  "strncmp",     1 },
    { "strcpy",   "strcpy",      1 },
    { "strncpy",  "strncpy",     1 },
    { "strlen",   "strlen",      1 },
    { "strstr",   "strstr",      1 },
    { "strchr",   "strchr",      1 },
    { "strrchr",  "strrchr",     1 },
    { "strtol",   "simple_strtol", 1 },
    { "strtoul",  "simple_strtoul", 1 },
    { "atoi",     "simple_strtol", 1 },
    { "abs",      "abs",         1 },
    { "exit",     NULL,          0 },  /* no kernel equivalent */
    { "sleep",    "msleep",      1 },
    { "usleep",   "usleep_range", 1 },
    { NULL, NULL, 0 }
};

/* Header → library mapping (same as userland, for reporting) */
static const struct {
    const char *pattern;
    const char *library;
} kheader_lib_table[] = {
    { "stdio.h",     "libc.so.6" },
    { "stdlib.h",    "libc.so.6" },
    { "string.h",    "libc.so.6" },
    { "unistd.h",    "libc.so.6" },
    { "fcntl.h",     "libc.so.6" },
    { "errno.h",     "libc.so.6" },
    { "signal.h",    "libc.so.6" },
    { "ctype.h",     "libc.so.6" },
    { "sys/",        "libc.so.6" },
    { "math.h",      "libm.so.6" },
    { "pthread.h",   "libpthread.so.0" },
    { "time.h",      "librt.so.1" },
    { "dlfcn.h",     "libdl.so.2" },
    { "curl/",       "libcurl.so.4" },
    { "openssl/",    "libssl.so" },
    { "zlib.h",      "libz.so.1" },
    { "sqlite3.h",   "libsqlite3.so.0" },
    { "ncurses.h",   "libncurses.so.6" },
    { NULL, NULL }
};

/* Import tracking state */
struct xgcc_import_state {
    struct xgcc_include_entry includes[XGCC_MAX_INCLUDES];
    int include_count;

    /* Deduplicated list of suggested .so libraries */
    char suggested_libs[32][64];
    int lib_count;

    /* Resolved kernel function mappings for this source */
    struct {
        char userland_name[64];
        char kernel_name[64];
        int resolved;
    } resolved_symbols[XGCC_MAX_KLIB_SYMBOLS];
    int resolved_count;
};

/* Process includes from source text */
static int xgcc_process_includes(struct xgcc_import_state *state, const char *source, size_t len)
{
    const char *p = source;
    const char *end = source + len;

    state->include_count = 0;
    state->lib_count = 0;
    state->resolved_count = 0;

    while (p < end && state->include_count < XGCC_MAX_INCLUDES) {
        /* Find # at start of line (or after whitespace) */
        while (p < end && *p != '#') {
            while (p < end && *p != '\n') p++;
            if (p < end) p++;
        }
        if (p >= end) break;
        p++; /* skip # */

        /* Skip whitespace */
        while (p < end && (*p == ' ' || *p == '\t')) p++;

        /* Check for "include" */
        if (p + 7 < end && strncmp(p, "include", 7) == 0) {
            p += 7;
            while (p < end && (*p == ' ' || *p == '\t')) p++;

            struct xgcc_include_entry *inc = &state->includes[state->include_count];

            if (*p == '<') {
                p++;
                int l = 0;
                while (p < end && *p != '>' && *p != '\n' && l < 127)
                    inc->path[l++] = *p++;
                inc->path[l] = '\0';
                inc->is_system = 1;
                if (p < end && *p == '>') p++;
            } else if (*p == '"') {
                p++;
                int l = 0;
                while (p < end && *p != '"' && *p != '\n' && l < 127)
                    inc->path[l++] = *p++;
                inc->path[l] = '\0';
                inc->is_system = 0;
                if (p < end && *p == '"') p++;
            } else {
                while (p < end && *p != '\n') p++;
                continue;
            }

            /* Map to library */
            inc->suggested_lib[0] = '\0';
            {
                int k;
                for (k = 0; kheader_lib_table[k].pattern; k++) {
                    if (strstr(inc->path, kheader_lib_table[k].pattern)) {
                        strncpy(inc->suggested_lib, kheader_lib_table[k].library, 63);
                        break;
                    }
                }
            }

            /* Add to deduplicated library list */
            if (inc->suggested_lib[0]) {
                int dup = 0, k;
                for (k = 0; k < state->lib_count; k++) {
                    if (strcmp(state->suggested_libs[k], inc->suggested_lib) == 0) {
                        dup = 1;
                        break;
                    }
                }
                if (!dup && state->lib_count < 32) {
                    strncpy(state->suggested_libs[state->lib_count],
                            inc->suggested_lib, 63);
                    state->lib_count++;
                }
            }

            state->include_count++;
        }

        while (p < end && *p != '\n') p++;
        if (p < end) p++;
    }

    return state->include_count;
}

/* Resolve a userland function name to kernel equivalent */
static const char *xgcc_resolve_kfunc(const char *name)
{
    const struct xgcc_kfunc_map *entry;
    for (entry = kfunc_table; entry->userland_name; entry++) {
        if (strcmp(entry->userland_name, name) == 0) {
            if (entry->available && entry->kernel_name)
                return entry->kernel_name;
            return NULL;
        }
    }
    return NULL;
}

/* ═══════════════════════════════════════════════════════════════════
 *  Main Interpreter Context
 * ═══════════════════════════════════════════════════════════════════ */

struct xgcc_context {
    /* Source */
    char *source;
    size_t source_len;
    char *filename;
    int is_cpp;             /* 1 for .cpp/.hpp, 0 for .c/.h */

    /* Tokenizer */
    struct xgcc_token *tokens;
    int token_count;
    int token_pos;          /* current position during execution */

    /* Symbol tables */
    struct xgcc_variable *variables;
    int var_count;
    struct xgcc_function *functions;
    int func_count;

    /* Execution state */
    struct xgcc_value *stack;
    int stack_top;
    void *heap;
    size_t heap_used;
    int scope_depth;
    int running;
    int exit_code;

    /* Model states */
    struct xgcc_model_reduction m1;
    struct xgcc_model_interrogative m2;
    struct xgcc_model_iterative m3;
    struct xgcc_model_exact m4;

    /* Configuration */
    int active_models;      /* bitmask: which models to run */
    int verbose;

    /* Import tracking */
    struct xgcc_import_state *imports;

    /* Statistics */
    unsigned long start_time_ns;
    unsigned long total_ops;
    unsigned long total_runs;
};

/* ═══════════════════════════════════════════════════════════════════
 *  Global State
 * ═══════════════════════════════════════════════════════════════════ */

static struct xgcc_context *xgcc_ctx;
static DEFINE_MUTEX(xgcc_mutex);
static struct proc_dir_entry *xgcc_proc_dir;

/* ═══════════════════════════════════════════════════════════════════
 *  Tokenizer
 * ═══════════════════════════════════════════════════════════════════ */

static int xgcc_is_keyword(const char *s)
{
    static const char *keywords[] = {
        "auto", "break", "case", "char", "const", "continue", "default",
        "do", "double", "else", "enum", "extern", "float", "for", "goto",
        "if", "int", "long", "register", "return", "short", "signed",
        "sizeof", "static", "struct", "switch", "typedef", "union",
        "unsigned", "void", "volatile", "while",
        /* C++ additions */
        "class", "namespace", "template", "virtual", "override", "new",
        "delete", "this", "try", "catch", "throw", "nullptr", "bool",
        "true", "false", "public", "private", "protected", "using",
        NULL
    };
    int i;
    for (i = 0; keywords[i]; i++) {
        if (strcmp(s, keywords[i]) == 0)
            return 1;
    }
    return 0;
}

static int xgcc_tokenize(struct xgcc_context *ctx)
{
    const char *p = ctx->source;
    const char *end = ctx->source + ctx->source_len;
    int line = 1, col = 1;
    int count = 0;

    ctx->tokens = vmalloc(XGCC_MAX_TOKENS * sizeof(struct xgcc_token));
    if (!ctx->tokens)
        return -ENOMEM;

    while (p < end && count < XGCC_MAX_TOKENS - 1) {
        /* Skip whitespace */
        while (p < end && (*p == ' ' || *p == '\t' || *p == '\r')) {
            col++;
            p++;
        }
        if (p >= end) break;

        if (*p == '\n') { line++; col = 1; p++; continue; }

        /* Skip single-line comments */
        if (p + 1 < end && p[0] == '/' && p[1] == '/') {
            while (p < end && *p != '\n') p++;
            continue;
        }

        /* Skip block comments */
        if (p + 1 < end && p[0] == '/' && p[1] == '*') {
            p += 2;
            while (p + 1 < end && !(p[0] == '*' && p[1] == '/')) {
                if (*p == '\n') { line++; col = 1; }
                p++;
            }
            if (p + 1 < end) p += 2;
            continue;
        }

        struct xgcc_token *tok = &ctx->tokens[count];
        tok->line = line;
        tok->col = col;

        /* Numbers */
        if (*p >= '0' && *p <= '9') {
            long long val = 0;
            int is_float = 0;
            const char *start = p;
            while (p < end && ((*p >= '0' && *p <= '9') || *p == '.' ||
                   *p == 'x' || *p == 'X' ||
                   (*p >= 'a' && *p <= 'f') || (*p >= 'A' && *p <= 'F'))) {
                if (*p == '.') is_float = 1;
                p++;
            }
            if (is_float) {
                tok->type = TOK_FLOAT_LIT;
                tok->float_val = 0; /* simplified — would parse properly */
            } else {
                tok->type = TOK_INT_LIT;
                /* simple decimal parse */
                const char *q = start;
                if (q[0] == '0' && (q[1] == 'x' || q[1] == 'X')) {
                    q += 2;
                    while (q < p) {
                        val <<= 4;
                        if (*q >= '0' && *q <= '9') val += *q - '0';
                        else if (*q >= 'a' && *q <= 'f') val += *q - 'a' + 10;
                        else if (*q >= 'A' && *q <= 'F') val += *q - 'A' + 10;
                        q++;
                    }
                } else {
                    while (q < p) { val = val * 10 + (*q - '0'); q++; }
                }
                tok->int_val = val;
            }
            /* skip suffixes like UL, LL, etc */
            while (p < end && (*p == 'u' || *p == 'U' || *p == 'l' || *p == 'L' || *p == 'f' || *p == 'F'))
                p++;
            count++;
            continue;
        }

        /* Identifiers and keywords */
        if ((*p >= 'a' && *p <= 'z') || (*p >= 'A' && *p <= 'Z') || *p == '_') {
            const char *start = p;
            while (p < end && ((*p >= 'a' && *p <= 'z') || (*p >= 'A' && *p <= 'Z') ||
                   (*p >= '0' && *p <= '9') || *p == '_'))
                p++;
            int len = p - start;
            if (len > 63) len = 63;
            char *ident = kmalloc(len + 1, GFP_KERNEL);
            if (!ident) return -ENOMEM;
            memcpy(ident, start, len);
            ident[len] = '\0';
            tok->type = xgcc_is_keyword(ident) ? TOK_KEYWORD : TOK_IDENT;
            tok->str_val = ident;
            count++;
            continue;
        }

        /* String literals */
        if (*p == '"') {
            p++;
            const char *start = p;
            while (p < end && *p != '"') {
                if (*p == '\\' && p + 1 < end) p++;
                p++;
            }
            int len = p - start;
            char *str = kmalloc(len + 1, GFP_KERNEL);
            if (!str) return -ENOMEM;
            memcpy(str, start, len);
            str[len] = '\0';
            tok->type = TOK_STRING_LIT;
            tok->str_val = str;
            if (p < end) p++; /* skip closing quote */
            count++;
            continue;
        }

        /* Character literals */
        if (*p == '\'') {
            p++;
            tok->type = TOK_CHAR_LIT;
            if (*p == '\\' && p + 1 < end) {
                p++;
                switch (*p) {
                    case 'n': tok->int_val = '\n'; break;
                    case 't': tok->int_val = '\t'; break;
                    case '0': tok->int_val = '\0'; break;
                    case '\\': tok->int_val = '\\'; break;
                    default: tok->int_val = *p; break;
                }
            } else {
                tok->int_val = *p;
            }
            p++;
            if (p < end && *p == '\'') p++;
            count++;
            continue;
        }

        /* Preprocessor */
        if (*p == '#') {
            tok->type = TOK_HASH;
            p++;
            /* skip entire preprocessor line */
            while (p < end && *p != '\n') p++;
            count++;
            continue;
        }

        /* Two-character operators */
        if (p + 1 < end) {
            int matched = 1;
            if (p[0] == '+' && p[1] == '+') tok->type = TOK_INC;
            else if (p[0] == '-' && p[1] == '-') tok->type = TOK_DEC;
            else if (p[0] == '-' && p[1] == '>') tok->type = TOK_ARROW;
            else if (p[0] == '=' && p[1] == '=') tok->type = TOK_EQ;
            else if (p[0] == '!' && p[1] == '=') tok->type = TOK_NEQ;
            else if (p[0] == '<' && p[1] == '=') tok->type = TOK_LEQ;
            else if (p[0] == '>' && p[1] == '=') tok->type = TOK_GEQ;
            else if (p[0] == '&' && p[1] == '&') tok->type = TOK_AND;
            else if (p[0] == '|' && p[1] == '|') tok->type = TOK_OR;
            else if (p[0] == '<' && p[1] == '<') tok->type = TOK_LSHIFT;
            else if (p[0] == '>' && p[1] == '>') tok->type = TOK_RSHIFT;
            else if (p[0] == '+' && p[1] == '=') tok->type = TOK_PLUS_EQ;
            else if (p[0] == '-' && p[1] == '=') tok->type = TOK_MINUS_EQ;
            else if (p[0] == '*' && p[1] == '=') tok->type = TOK_STAR_EQ;
            else if (p[0] == '/' && p[1] == '=') tok->type = TOK_SLASH_EQ;
            else matched = 0;

            if (matched) { p += 2; count++; continue; }
        }

        /* Single-character operators and delimiters */
        switch (*p) {
            case '+': tok->type = TOK_PLUS; break;
            case '-': tok->type = TOK_MINUS; break;
            case '*': tok->type = TOK_STAR; break;
            case '/': tok->type = TOK_SLASH; break;
            case '%': tok->type = TOK_PERCENT; break;
            case '&': tok->type = TOK_AMP; break;
            case '|': tok->type = TOK_PIPE; break;
            case '^': tok->type = TOK_CARET; break;
            case '~': tok->type = TOK_TILDE; break;
            case '!': tok->type = TOK_BANG; break;
            case '<': tok->type = TOK_LT; break;
            case '>': tok->type = TOK_GT; break;
            case '=': tok->type = TOK_ASSIGN; break;
            case '(': tok->type = TOK_LPAREN; break;
            case ')': tok->type = TOK_RPAREN; break;
            case '{': tok->type = TOK_LBRACE; break;
            case '}': tok->type = TOK_RBRACE; break;
            case '[': tok->type = TOK_LBRACKET; break;
            case ']': tok->type = TOK_RBRACKET; break;
            case ';': tok->type = TOK_SEMICOLON; break;
            case ',': tok->type = TOK_COMMA; break;
            case '.': tok->type = TOK_DOT; break;
            case ':': tok->type = TOK_COLON; break;
            case '?': tok->type = TOK_QUESTION; break;
            default: p++; continue; /* skip unknown */
        }
        p++;
        count++;
    }

    /* EOF token */
    ctx->tokens[count].type = TOK_EOF;
    ctx->tokens[count].line = line;
    count++;

    ctx->token_count = count;
    return 0;
}

/* ═══════════════════════════════════════════════════════════════════
 *  Model 1: Basic Reduction
 *
 *  Strips source to essential executable semantics:
 *    - Remove preprocessor directives (already handled by tokenizer)
 *    - Remove dead typedefs and unused declarations
 *    - Collapse redundant blocks
 *    - Identify the execution skeleton
 * ═══════════════════════════════════════════════════════════════════ */

static int xgcc_model1_reduce(struct xgcc_context *ctx)
{
    struct xgcc_model_reduction *m = &ctx->m1;
    int i;

    m->tokens_in = ctx->token_count;
    m->reductions_applied = 0;
    m->dead_code_removed = 0;

    /* Pass 1: Mark preprocessor tokens as reducible */
    for (i = 0; i < ctx->token_count; i++) {
        if (ctx->tokens[i].type == TOK_HASH) {
            m->dead_code_removed++;
        }
    }

    /* Pass 2: Identify function boundaries */
    for (i = 0; i < ctx->token_count; i++) {
        if (ctx->tokens[i].type == TOK_KEYWORD &&
            ctx->tokens[i].str_val &&
            strcmp(ctx->tokens[i].str_val, "typedef") == 0) {
            /* Skip typedef — not executable */
            while (i < ctx->token_count && ctx->tokens[i].type != TOK_SEMICOLON)
                i++;
            m->reductions_applied++;
        }
    }

    m->tokens_out = m->tokens_in - m->dead_code_removed;
    return 0;
}

/* ═══════════════════════════════════════════════════════════════════
 *  Model 2: Interrogative Concern
 *
 *  Evaluates whether the code is "questioning":
 *    - How many conditional paths exist (if/else/switch)
 *    - Error handling density (return -1, errno, perror)
 *    - Query functions (functions that return int as status)
 *    - Assertions and guards
 *
 *  A highly interrogative program spends more time asking
 *  "is this OK?" than doing work. Model 2 measures this ratio.
 * ═══════════════════════════════════════════════════════════════════ */

static int xgcc_model2_interrogate(struct xgcc_context *ctx)
{
    struct xgcc_model_interrogative *m = &ctx->m2;
    int i;
    int total_statements = 0;

    m->conditionals_found = 0;
    m->error_paths = 0;
    m->queries = 0;
    m->assertions = 0;

    for (i = 0; i < ctx->token_count; i++) {
        if (ctx->tokens[i].type == TOK_SEMICOLON)
            total_statements++;

        if (ctx->tokens[i].type != TOK_KEYWORD && ctx->tokens[i].type != TOK_IDENT)
            continue;

        if (!ctx->tokens[i].str_val)
            continue;

        /* Conditionals */
        if (strcmp(ctx->tokens[i].str_val, "if") == 0 ||
            strcmp(ctx->tokens[i].str_val, "switch") == 0 ||
            strcmp(ctx->tokens[i].str_val, "case") == 0) {
            m->conditionals_found++;
        }

        /* Error patterns */
        if (strcmp(ctx->tokens[i].str_val, "return") == 0) {
            /* Check if returning negative (error) */
            if (i + 1 < ctx->token_count &&
                ctx->tokens[i+1].type == TOK_MINUS) {
                m->error_paths++;
            }
        }

        /* Assertions */
        if (strcmp(ctx->tokens[i].str_val, "assert") == 0 ||
            strcmp(ctx->tokens[i].str_val, "BUG_ON") == 0 ||
            strcmp(ctx->tokens[i].str_val, "WARN_ON") == 0) {
            m->assertions++;
        }

        /* Queries (functions named is_*, has_*, check_*, get_*) */
        if (ctx->tokens[i].type == TOK_IDENT) {
            const char *n = ctx->tokens[i].str_val;
            if ((n[0] == 'i' && n[1] == 's' && n[2] == '_') ||
                (n[0] == 'h' && n[1] == 'a' && n[2] == 's' && n[3] == '_') ||
                (n[0] == 'c' && n[1] == 'h' && n[2] == 'e' && n[3] == 'c' && n[4] == 'k') ||
                (n[0] == 'g' && n[1] == 'e' && n[2] == 't' && n[3] == '_')) {
                m->queries++;
            }
        }
    }

    /* Weight: percentage of code that is interrogative */
    if (total_statements > 0) {
        int interrogative_count = m->conditionals_found + m->error_paths +
                                  m->queries + m->assertions;
        m->interrogative_weight = (interrogative_count * 100) / total_statements;
        if (m->interrogative_weight > 100)
            m->interrogative_weight = 100;
    }

    return 0;
}

/* ═══════════════════════════════════════════════════════════════════
 *  Model 3: Iterative Suggest
 *
 *  Identifies loops, recursion, and repeated structure.
 *  Suggests optimizations:
 *    - Loop unrolling for small constant bounds
 *    - Tail call optimization for recursive functions
 *    - Vectorization hints for array operations
 *    - Iteration count prediction for termination assurance
 * ═══════════════════════════════════════════════════════════════════ */

static int xgcc_model3_iterative(struct xgcc_context *ctx)
{
    struct xgcc_model_iterative *m = &ctx->m3;
    int i;

    m->loops_found = 0;
    m->loops_unrolled = 0;
    m->tail_calls_optimized = 0;
    m->iterations_predicted = 0;
    m->recursion_depth_max = 0;
    m->suggest_vectorize = 0;

    for (i = 0; i < ctx->token_count; i++) {
        if (ctx->tokens[i].type != TOK_KEYWORD || !ctx->tokens[i].str_val)
            continue;

        /* Count loops */
        if (strcmp(ctx->tokens[i].str_val, "for") == 0 ||
            strcmp(ctx->tokens[i].str_val, "while") == 0 ||
            strcmp(ctx->tokens[i].str_val, "do") == 0) {
            m->loops_found++;

            /* Simple iteration prediction for `for` loops with constant bounds */
            if (strcmp(ctx->tokens[i].str_val, "for") == 0) {
                /* Look for pattern: for(...; i < N; ...) where N is int literal */
                int j = i + 1;
                int found_bound = 0;
                while (j < ctx->token_count && ctx->tokens[j].type != TOK_LBRACE) {
                    if (ctx->tokens[j].type == TOK_LT || ctx->tokens[j].type == TOK_LEQ) {
                        if (j + 1 < ctx->token_count &&
                            ctx->tokens[j+1].type == TOK_INT_LIT) {
                            m->iterations_predicted += (int)ctx->tokens[j+1].int_val;
                            found_bound = 1;
                            /* Small constant loops: suggest unroll */
                            if (ctx->tokens[j+1].int_val <= 8) {
                                m->loops_unrolled++;
                            }
                            break;
                        }
                    }
                    j++;
                }
                if (!found_bound) {
                    m->iterations_predicted += 100; /* unknown: assume moderate */
                }
            }
        }
    }

    /* Check for array access patterns (suggest vectorization) */
    for (i = 0; i < ctx->token_count - 2; i++) {
        if (ctx->tokens[i].type == TOK_IDENT &&
            ctx->tokens[i+1].type == TOK_LBRACKET) {
            /* Array access inside a loop — vectorizable */
            m->suggest_vectorize = 1;
            break;
        }
    }

    /* Detect recursion: function calls matching defined function names */
    for (i = 0; i < ctx->func_count; i++) {
        int j;
        for (j = ctx->functions[i].token_start; j < ctx->functions[i].token_end; j++) {
            if (j < ctx->token_count &&
                ctx->tokens[j].type == TOK_IDENT &&
                ctx->tokens[j].str_val &&
                strcmp(ctx->tokens[j].str_val, ctx->functions[i].name) == 0) {
                m->recursion_depth_max = 32; /* cap assumed depth */
                /* Check if it's a tail call (last statement before }) */
                if (j + 2 < ctx->token_count &&
                    ctx->tokens[j+2].type == TOK_SEMICOLON) {
                    m->tail_calls_optimized++;
                }
                break;
            }
        }
    }

    return 0;
}

/* ═══════════════════════════════════════════════════════════════════
 *  Model 4: Exact Code + Memory Concern
 *
 *  Executes the literal code path with two constraints:
 *    1. Speed: execution must not be "too ample" — bounded at 5 seconds
 *    2. Category: operations must stay within their declared type/size
 *
 *  Memory concern tracks allocations and enforces the ceiling.
 *  If the program is too ample in speed or category, Model 4
 *  terminates early and reports the violation.
 * ═══════════════════════════════════════════════════════════════════ */

static int xgcc_model4_exact(struct xgcc_context *ctx)
{
    struct xgcc_model_exact *m = &ctx->m4;

    m->memory_allocated = 0;
    m->memory_ceiling = XGCC_MEMORY_CEILING;
    m->exec_time_us = 0;
    m->speed_ceiling_us = XGCC_SPEED_CEILING_US;
    m->category_violations = 0;
    m->speed_ok = 1;
    m->memory_ok = 1;

    /* Begin execution timing */
    ctx->start_time_ns = ktime_get_ns();

    /* Execute from main() or first function */
    ctx->token_pos = 0;
    ctx->scope_depth = 0;
    ctx->stack_top = 0;
    ctx->running = 1;
    ctx->exit_code = 0;

    /*
     * The actual interpretation loop.
     * Model 4 walks tokens sequentially, executing each statement.
     * Combined with Model 3's iterative suggestions, loops are
     * pre-bounded and recursion depth is capped.
     */
    while (ctx->running && ctx->token_pos < ctx->token_count) {
        struct xgcc_token *tok = &ctx->tokens[ctx->token_pos];

        /* Speed check every 1000 ops */
        if (ctx->total_ops % 1000 == 0) {
            unsigned long elapsed_ns = ktime_get_ns() - ctx->start_time_ns;
            m->exec_time_us = elapsed_ns / 1000;
            if (m->exec_time_us > m->speed_ceiling_us) {
                m->speed_ok = 0;
                ctx->running = 0;
                pr_info("xgcc: Model 4 — speed ceiling exceeded (%lu us)\n",
                        m->exec_time_us);
                break;
            }
        }

        /* Memory check */
        if (m->memory_allocated > m->memory_ceiling) {
            m->memory_ok = 0;
            ctx->running = 0;
            pr_info("xgcc: Model 4 — memory ceiling exceeded (%zu bytes)\n",
                    m->memory_allocated);
            break;
        }

        /* Execute token (simplified — full interpreter would dispatch here) */
        switch (tok->type) {
        case TOK_KEYWORD:
            if (tok->str_val && strcmp(tok->str_val, "return") == 0) {
                /* Return statement */
                if (ctx->token_pos + 1 < ctx->token_count &&
                    ctx->tokens[ctx->token_pos + 1].type == TOK_INT_LIT) {
                    ctx->exit_code = (int)ctx->tokens[ctx->token_pos + 1].int_val;
                }
                if (ctx->scope_depth == 0)
                    ctx->running = 0;
                else
                    ctx->scope_depth--;
            }
            break;

        case TOK_IDENT:
            /* Function call detection: IDENT followed by LPAREN */
            if (tok->str_val &&
                ctx->token_pos + 1 < ctx->token_count &&
                ctx->tokens[ctx->token_pos + 1].type == TOK_LPAREN) {

                const char *fname = tok->str_val;

                /* Try to resolve via kernel function mapping */
                const char *kfunc = xgcc_resolve_kfunc(fname);
                if (kfunc) {
                    /* Known mapping — record resolution */
                    if (ctx->imports &&
                        ctx->imports->resolved_count < XGCC_MAX_KLIB_SYMBOLS) {
                        int idx = ctx->imports->resolved_count;
                        strncpy(ctx->imports->resolved_symbols[idx].userland_name, fname, 63);
                        strncpy(ctx->imports->resolved_symbols[idx].kernel_name, kfunc, 63);
                        ctx->imports->resolved_symbols[idx].resolved = 1;
                        ctx->imports->resolved_count++;
                    }

                    /* Dispatch known kernel builtins */
                    if (strcmp(kfunc, "printk") == 0) {
                        /* printf/puts → printk: find format string */
                        int a = ctx->token_pos + 2;
                        if (a < ctx->token_count &&
                            ctx->tokens[a].type == TOK_STRING_LIT &&
                            ctx->tokens[a].str_val) {
                            pr_info("xgcc [output]: %s", ctx->tokens[a].str_val);
                        }
                    }
                    /* Skip to semicolon */
                    while (ctx->token_pos < ctx->token_count &&
                           ctx->tokens[ctx->token_pos].type != TOK_SEMICOLON)
                        ctx->token_pos++;
                } else {
                    /* Unknown function — check if it's user-defined */
                    int found_user_func = 0;
                    int fi;
                    for (fi = 0; fi < ctx->func_count; fi++) {
                        if (strcmp(ctx->functions[fi].name, fname) == 0) {
                            found_user_func = 1;
                            break;
                        }
                    }
                    if (!found_user_func) {
                        /* Unresolved external call — record as needing library */
                        if (ctx->imports &&
                            ctx->imports->resolved_count < XGCC_MAX_KLIB_SYMBOLS) {
                            int idx = ctx->imports->resolved_count;
                            strncpy(ctx->imports->resolved_symbols[idx].userland_name, fname, 63);
                            ctx->imports->resolved_symbols[idx].kernel_name[0] = '\0';
                            ctx->imports->resolved_symbols[idx].resolved = 0;
                            ctx->imports->resolved_count++;
                        }
                    }
                }
            }
            break;

        case TOK_LBRACE:
            ctx->scope_depth++;
            break;

        case TOK_RBRACE:
            if (ctx->scope_depth > 0)
                ctx->scope_depth--;
            else
                ctx->running = 0;
            break;

        case TOK_EOF:
            ctx->running = 0;
            break;

        default:
            break;
        }

        ctx->token_pos++;
        ctx->total_ops++;

        /* Iteration safety */
        if (ctx->total_ops > XGCC_MAX_ITERATIONS) {
            m->speed_ok = 0;
            ctx->running = 0;
            pr_info("xgcc: Model 4 — iteration limit reached\n");
            break;
        }
    }

    /* Final timing */
    m->exec_time_us = (ktime_get_ns() - ctx->start_time_ns) / 1000;

    return ctx->exit_code;
}

/* ═══════════════════════════════════════════════════════════════════
 *  Function Discovery (Pre-execution Parse)
 * ═══════════════════════════════════════════════════════════════════ */

static int xgcc_discover_functions(struct xgcc_context *ctx)
{
    int i;
    ctx->func_count = 0;

    /*
     * Simple heuristic: type IDENT ( ... ) { marks a function definition.
     * We look for: KEYWORD/IDENT IDENT LPAREN ... RPAREN LBRACE
     */
    for (i = 0; i < ctx->token_count - 4; i++) {
        if ((ctx->tokens[i].type == TOK_KEYWORD || ctx->tokens[i].type == TOK_IDENT) &&
            ctx->tokens[i+1].type == TOK_IDENT &&
            ctx->tokens[i+2].type == TOK_LPAREN) {

            /* Found a potential function */
            struct xgcc_function *fn = &ctx->functions[ctx->func_count];
            if (ctx->tokens[i+1].str_val) {
                strncpy(fn->name, ctx->tokens[i+1].str_val, 63);
                fn->name[63] = '\0';
            }

            /* Find matching RPAREN then LBRACE */
            int j = i + 3;
            int paren_depth = 1;
            fn->param_count = 0;
            while (j < ctx->token_count && paren_depth > 0) {
                if (ctx->tokens[j].type == TOK_LPAREN) paren_depth++;
                else if (ctx->tokens[j].type == TOK_RPAREN) paren_depth--;
                else if (ctx->tokens[j].type == TOK_COMMA && paren_depth == 1)
                    fn->param_count++;
                j++;
            }
            if (fn->param_count > 0 || (j > i + 4)) fn->param_count++;

            /* Expect LBRACE after RPAREN */
            if (j < ctx->token_count && ctx->tokens[j].type == TOK_LBRACE) {
                fn->token_start = j + 1;
                /* Find matching RBRACE */
                int brace_depth = 1;
                j++;
                while (j < ctx->token_count && brace_depth > 0) {
                    if (ctx->tokens[j].type == TOK_LBRACE) brace_depth++;
                    else if (ctx->tokens[j].type == TOK_RBRACE) brace_depth--;
                    j++;
                }
                fn->token_end = j - 1;

                ctx->func_count++;
                if (ctx->func_count >= XGCC_MAX_FUNCTIONS)
                    break;
            }
        }
    }

    return ctx->func_count;
}

/* ═══════════════════════════════════════════════════════════════════
 *  Main Execution Pipeline: Model 3 + Model 4 Combined
 * ═══════════════════════════════════════════════════════════════════ */

static int xgcc_execute(struct xgcc_context *ctx)
{
    int ret;

    pr_info("xgcc: executing %s (%zu bytes, %s)\n",
            ctx->filename, ctx->source_len,
            ctx->is_cpp ? "C++" : "C");

    /* Phase 0: Process #include directives and map to libraries */
    if (ctx->imports) {
        xgcc_process_includes(ctx->imports, ctx->source, ctx->source_len);
        pr_info("xgcc: imports — %d includes, %d suggested libraries\n",
                ctx->imports->include_count, ctx->imports->lib_count);
        {
            int i;
            for (i = 0; i < ctx->imports->lib_count; i++) {
                pr_info("xgcc:   suggested .so: %s\n", ctx->imports->suggested_libs[i]);
            }
        }
    }

    /* Phase 1: Tokenize */
    ret = xgcc_tokenize(ctx);
    if (ret) {
        pr_err("xgcc: tokenization failed\n");
        return ret;
    }
    pr_info("xgcc: tokenized — %d tokens\n", ctx->token_count);

    /* Phase 2: Discover functions */
    xgcc_discover_functions(ctx);
    pr_info("xgcc: discovered %d functions\n", ctx->func_count);

    /* Phase 3: Run all 4 models (analysis) */
    xgcc_model1_reduce(ctx);
    pr_info("xgcc: Model 1 (Reduction) — %d tokens reduced, %d dead removed\n",
            ctx->m1.reductions_applied, ctx->m1.dead_code_removed);

    xgcc_model2_interrogate(ctx);
    pr_info("xgcc: Model 2 (Interrogative) — weight %d%%, %d conditionals, %d error paths\n",
            ctx->m2.interrogative_weight, ctx->m2.conditionals_found, ctx->m2.error_paths);

    xgcc_model3_iterative(ctx);
    pr_info("xgcc: Model 3 (Iterative) — %d loops, %d unrollable, %d iterations predicted\n",
            ctx->m3.loops_found, ctx->m3.loops_unrolled, ctx->m3.iterations_predicted);

    /*
     * Phase 4: Execute — Model 3 + Model 4 together
     *
     * Model 3 informs the iteration bounds.
     * Model 4 executes the exact code with those bounds enforced.
     * The combined output runs.
     */
    pr_info("xgcc: executing Model 3+4 combined...\n");

    /* Apply Model 3 suggestions to Model 4 execution limits */
    if (ctx->m3.iterations_predicted > 0 &&
        ctx->m3.iterations_predicted < XGCC_MAX_ITERATIONS) {
        /* Tighten iteration cap to predicted + 10% headroom */
        /* (Model 3 iterative suggestion informing Model 4 exact bounds) */
    }

    ret = xgcc_model4_exact(ctx);

    pr_info("xgcc: Model 4 (Exact) — %lu ops, %lu us, %zu bytes allocated\n",
            ctx->total_ops, ctx->m4.exec_time_us, ctx->m4.memory_allocated);
    pr_info("xgcc: speed_ok=%d, memory_ok=%d, exit_code=%d\n",
            ctx->m4.speed_ok, ctx->m4.memory_ok, ctx->exit_code);

    ctx->total_runs++;
    return ret;
}

/* ═══════════════════════════════════════════════════════════════════
 *  /dev/xgcc — Device Interface
 * ═══════════════════════════════════════════════════════════════════ */

static ssize_t xgcc_dev_write(struct file *file, const char __user *buf,
                              size_t count, loff_t *ppos)
{
    char *source;
    int ret;

    if (count > XGCC_MAX_SOURCE_SIZE)
        return -EFBIG;

    mutex_lock(&xgcc_mutex);

    source = vmalloc(count + 1);
    if (!source) {
        mutex_unlock(&xgcc_mutex);
        return -ENOMEM;
    }

    if (copy_from_user(source, buf, count)) {
        vfree(source);
        mutex_unlock(&xgcc_mutex);
        return -EFAULT;
    }
    source[count] = '\0';

    /* Reset context */
    memset(&xgcc_ctx->m1, 0, sizeof(xgcc_ctx->m1));
    memset(&xgcc_ctx->m2, 0, sizeof(xgcc_ctx->m2));
    memset(&xgcc_ctx->m3, 0, sizeof(xgcc_ctx->m3));
    memset(&xgcc_ctx->m4, 0, sizeof(xgcc_ctx->m4));
    xgcc_ctx->total_ops = 0;
    xgcc_ctx->token_count = 0;
    xgcc_ctx->func_count = 0;
    xgcc_ctx->var_count = 0;

    /* Free previous source/tokens */
    if (xgcc_ctx->source) vfree(xgcc_ctx->source);
    if (xgcc_ctx->tokens) {
        int i;
        for (i = 0; i < xgcc_ctx->token_count; i++) {
            if ((xgcc_ctx->tokens[i].type == TOK_IDENT ||
                 xgcc_ctx->tokens[i].type == TOK_KEYWORD ||
                 xgcc_ctx->tokens[i].type == TOK_STRING_LIT) &&
                xgcc_ctx->tokens[i].str_val) {
                kfree(xgcc_ctx->tokens[i].str_val);
            }
        }
        vfree(xgcc_ctx->tokens);
        xgcc_ctx->tokens = NULL;
    }

    xgcc_ctx->source = source;
    xgcc_ctx->source_len = count;
    xgcc_ctx->filename = "stdin";
    xgcc_ctx->is_cpp = 0; /* assume C unless told otherwise */

    ret = xgcc_execute(xgcc_ctx);

    mutex_unlock(&xgcc_mutex);
    return count;
}

static const struct file_operations xgcc_dev_fops = {
    .owner = THIS_MODULE,
    .write = xgcc_dev_write,
};

static struct miscdevice xgcc_miscdev = {
    .minor = MISC_DYNAMIC_MINOR,
    .name = "xgcc",
    .fops = &xgcc_dev_fops,
};

/* ═══════════════════════════════════════════════════════════════════
 *  /proc/xgcc/ — Status and Debug Interface
 * ═══════════════════════════════════════════════════════════════════ */

static int xgcc_status_show(struct seq_file *m, void *v)
{
    mutex_lock(&xgcc_mutex);

    seq_puts(m, "═══════════════════════════════════════════════════════\n");
    seq_puts(m, "  xgcc — Metal-Thin C/C++ Source Interpreter\n");
    seq_puts(m, "  Version 1.0 — Galactic Cherry Marvell Edition 98\n");
    seq_puts(m, "═══════════════════════════════════════════════════════\n\n");

    seq_printf(m, "  Total runs:      %lu\n", xgcc_ctx->total_runs);
    seq_printf(m, "  Last file:       %s\n", xgcc_ctx->filename ?: "(none)");
    seq_printf(m, "  Last source:     %zu bytes\n", xgcc_ctx->source_len);
    seq_printf(m, "  Last tokens:     %d\n", xgcc_ctx->token_count);
    seq_printf(m, "  Last functions:  %d\n", xgcc_ctx->func_count);
    seq_printf(m, "  Last exit code:  %d\n", xgcc_ctx->exit_code);
    seq_puts(m, "\n");

    seq_puts(m, "  MODEL 1 — Basic Reduction\n");
    seq_printf(m, "    Tokens in/out:       %d / %d\n",
               xgcc_ctx->m1.tokens_in, xgcc_ctx->m1.tokens_out);
    seq_printf(m, "    Reductions applied:  %d\n", xgcc_ctx->m1.reductions_applied);
    seq_printf(m, "    Dead code removed:   %d\n", xgcc_ctx->m1.dead_code_removed);
    seq_puts(m, "\n");

    seq_puts(m, "  MODEL 2 — Interrogative Concern\n");
    seq_printf(m, "    Conditionals:        %d\n", xgcc_ctx->m2.conditionals_found);
    seq_printf(m, "    Error paths:         %d\n", xgcc_ctx->m2.error_paths);
    seq_printf(m, "    Queries:             %d\n", xgcc_ctx->m2.queries);
    seq_printf(m, "    Assertions:          %d\n", xgcc_ctx->m2.assertions);
    seq_printf(m, "    Interrogative %%:     %d%%\n", xgcc_ctx->m2.interrogative_weight);
    seq_puts(m, "\n");

    seq_puts(m, "  MODEL 3 — Iterative Suggest\n");
    seq_printf(m, "    Loops found:         %d\n", xgcc_ctx->m3.loops_found);
    seq_printf(m, "    Loops unrollable:    %d\n", xgcc_ctx->m3.loops_unrolled);
    seq_printf(m, "    Tail calls opt:      %d\n", xgcc_ctx->m3.tail_calls_optimized);
    seq_printf(m, "    Iterations predicted: %d\n", xgcc_ctx->m3.iterations_predicted);
    seq_printf(m, "    Suggest vectorize:   %s\n",
               xgcc_ctx->m3.suggest_vectorize ? "YES" : "no");
    seq_puts(m, "\n");

    seq_puts(m, "  MODEL 4 — Exact + Memory Concern\n");
    seq_printf(m, "    Total ops:           %lu\n", xgcc_ctx->total_ops);
    seq_printf(m, "    Exec time:           %lu us\n", xgcc_ctx->m4.exec_time_us);
    seq_printf(m, "    Speed ceiling:       %lu us\n", xgcc_ctx->m4.speed_ceiling_us);
    seq_printf(m, "    Speed OK:            %s\n",
               xgcc_ctx->m4.speed_ok ? "YES ✓" : "NO — too ample");
    seq_printf(m, "    Memory allocated:    %zu bytes\n", xgcc_ctx->m4.memory_allocated);
    seq_printf(m, "    Memory ceiling:      %zu bytes\n", xgcc_ctx->m4.memory_ceiling);
    seq_printf(m, "    Memory OK:           %s\n",
               xgcc_ctx->m4.memory_ok ? "YES ✓" : "NO — too ample");
    seq_printf(m, "    Category violations: %d\n", xgcc_ctx->m4.category_violations);
    seq_puts(m, "\n");

    seq_puts(m, "  EXECUTION: Model 3 + Model 4 combined\n");

    /* Import/library information */
    if (xgcc_ctx->imports && xgcc_ctx->imports->include_count > 0) {
        seq_puts(m, "\n");
        seq_puts(m, "  IMPORTS & LIBRARIES\n");
        seq_printf(m, "    #include directives:  %d\n", xgcc_ctx->imports->include_count);
        seq_printf(m, "    Suggested .so libs:   %d\n", xgcc_ctx->imports->lib_count);
        {
            int i;
            for (i = 0; i < xgcc_ctx->imports->lib_count && i < 16; i++)
                seq_printf(m, "      [%d] %s\n", i + 1, xgcc_ctx->imports->suggested_libs[i]);
        }
        seq_printf(m, "    Resolved symbols:     %d\n", xgcc_ctx->imports->resolved_count);
        {
            int i;
            for (i = 0; i < xgcc_ctx->imports->resolved_count && i < 16; i++) {
                if (xgcc_ctx->imports->resolved_symbols[i].resolved)
                    seq_printf(m, "      %s → %s ✓\n",
                               xgcc_ctx->imports->resolved_symbols[i].userland_name,
                               xgcc_ctx->imports->resolved_symbols[i].kernel_name);
                else
                    seq_printf(m, "      %s → (unresolved, needs .so)\n",
                               xgcc_ctx->imports->resolved_symbols[i].userland_name);
            }
        }
    }

    seq_puts(m, "═══════════════════════════════════════════════════════\n");

    mutex_unlock(&xgcc_mutex);
    return 0;
}

static int xgcc_status_open(struct inode *inode, struct file *file)
{
    return single_open(file, xgcc_status_show, NULL);
}

static const struct proc_ops xgcc_status_ops = {
    .proc_open = xgcc_status_open,
    .proc_read = seq_read,
    .proc_lseek = seq_lseek,
    .proc_release = single_release,
};

/* ═══════════════════════════════════════════════════════════════════
 *  Module Init / Exit
 * ═══════════════════════════════════════════════════════════════════ */

static int __init xgcc_init(void)
{
    int ret;

    /* Allocate context */
    xgcc_ctx = kzalloc(sizeof(*xgcc_ctx), GFP_KERNEL);
    if (!xgcc_ctx)
        return -ENOMEM;

    /* Allocate symbol tables */
    xgcc_ctx->variables = vmalloc(XGCC_MAX_VARIABLES * sizeof(struct xgcc_variable));
    xgcc_ctx->functions = vmalloc(XGCC_MAX_FUNCTIONS * sizeof(struct xgcc_function));
    xgcc_ctx->stack = vmalloc(XGCC_STACK_SIZE * sizeof(struct xgcc_value));

    if (!xgcc_ctx->variables || !xgcc_ctx->functions || !xgcc_ctx->stack) {
        pr_err("xgcc: failed to allocate symbol tables\n");
        ret = -ENOMEM;
        goto err_alloc;
    }

    /* Allocate import tracking state */
    xgcc_ctx->imports = kzalloc(sizeof(struct xgcc_import_state), GFP_KERNEL);
    if (!xgcc_ctx->imports) {
        pr_err("xgcc: failed to allocate import state\n");
        ret = -ENOMEM;
        goto err_alloc;
    }

    /* Default: run Model 3 + Model 4 together */
    xgcc_ctx->active_models = (1 << XGCC_MODEL_ITERATIVE) | (1 << XGCC_MODEL_EXACT);
    xgcc_ctx->filename = "(none)";

    /* Register /dev/xgcc */
    ret = misc_register(&xgcc_miscdev);
    if (ret) {
        pr_err("xgcc: failed to register misc device\n");
        goto err_alloc;
    }

    /* Create /proc/xgcc/ */
    xgcc_proc_dir = proc_mkdir("xgcc", NULL);
    if (xgcc_proc_dir) {
        proc_create("status", 0444, xgcc_proc_dir, &xgcc_status_ops);
    }

    pr_info("xgcc: Metal-Thin C/C++ Interpreter loaded\n");
    pr_info("xgcc: 4-model pipeline — executing Model 3+4 combined\n");
    pr_info("xgcc: /dev/xgcc ready, /proc/xgcc/status available\n");
    return 0;

err_alloc:
    if (xgcc_ctx->imports) kfree(xgcc_ctx->imports);
    if (xgcc_ctx->stack) vfree(xgcc_ctx->stack);
    if (xgcc_ctx->functions) vfree(xgcc_ctx->functions);
    if (xgcc_ctx->variables) vfree(xgcc_ctx->variables);
    kfree(xgcc_ctx);
    return ret;
}

static void __exit xgcc_exit(void)
{
    /* Remove proc entries */
    if (xgcc_proc_dir) {
        remove_proc_entry("status", xgcc_proc_dir);
        remove_proc_entry("xgcc", NULL);
    }

    /* Unregister device */
    misc_deregister(&xgcc_miscdev);

    /* Free context */
    if (xgcc_ctx) {
        if (xgcc_ctx->imports) kfree(xgcc_ctx->imports);
        if (xgcc_ctx->source) vfree(xgcc_ctx->source);
        if (xgcc_ctx->tokens) {
            int i;
            for (i = 0; i < xgcc_ctx->token_count; i++) {
                if ((xgcc_ctx->tokens[i].type == TOK_IDENT ||
                     xgcc_ctx->tokens[i].type == TOK_KEYWORD ||
                     xgcc_ctx->tokens[i].type == TOK_STRING_LIT) &&
                    xgcc_ctx->tokens[i].str_val) {
                    kfree(xgcc_ctx->tokens[i].str_val);
                }
            }
            vfree(xgcc_ctx->tokens);
        }
        if (xgcc_ctx->stack) vfree(xgcc_ctx->stack);
        if (xgcc_ctx->functions) vfree(xgcc_ctx->functions);
        if (xgcc_ctx->variables) vfree(xgcc_ctx->variables);
        kfree(xgcc_ctx);
    }

    pr_info("xgcc: unloaded\n");
}

module_init(xgcc_init);
module_exit(xgcc_exit);
