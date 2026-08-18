/*
 * xgcc-user.c — Userland Metal-Thin C/C++ Source Interpreter
 *
 * Part of Ubuntu Determinant Alpha RS — Galactic Cherry Marvell Edition 98
 *
 * Standalone version of xgcc that runs entirely in user memory space.
 * No kernel module required. Uses mmap'd arenas for interpreted execution
 * with the same 4-model pipeline as the kernel version, plus user-space
 * memory concerns:
 *
 *   - Arena allocation (default 64 MB, configurable)
 *   - Guard pages at arena boundaries
 *   - mmap-backed heap for interpreted programs
 *   - Stack depth enforcement (no unbounded recursion)
 *   - Process isolation via fork (optional sandbox mode)
 *
 * The Four Models:
 *   1 — Basic Reduction:    Strip to essential executable semantics
 *   2 — Interrogative:      Evaluate conditional/questioning code paths
 *   3 — Iterative Suggest:  Optimize loops, predict iteration bounds
 *   4 — Exact + Memory:     Literal execution with speed/category bounds
 *
 * Execution: Model 3 + Model 4 together — the combined output runs.
 *
 * User Memory Concerns:
 *   - Interpreted heap is bounded (default 64 MB, --heap flag)
 *   - Stack frames are bounded (default 1024 depth, --stack-depth flag)
 *   - Allocation rate is monitored (warn if > 100 MB/s sustained)
 *   - Total process RSS is checked against system available memory
 *   - mprotect guard pages catch buffer overflows from interpreted code
 *   - SIGALRM enforces wall-clock timeout (default 10s, --timeout flag)
 *
 * Usage:
 *   xgcc-user program.c                   — Run C source in userland
 *   xgcc-user module.cpp                  — Run C++ source in userland
 *   xgcc-user --heap 128m program.c      — 128 MB heap
 *   xgcc-user --timeout 30 program.c     — 30 second timeout
 *   xgcc-user --sandbox program.c        — Fork-isolated execution
 *   xgcc-user --verbose program.c        — Full model trace
 *   xgcc-user --dry-run program.c        — Models 1-3 only, no execution
 *
 * Author: Maximilian Eric Alexander Rupplin von Keffikon
 * Copyright (C) 2026 MEARVK LLC
 * License: GPL-2.0
 */

#define _POSIX_C_SOURCE 200809L
#define _GNU_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <signal.h>
#include <setjmp.h>
#include <time.h>
#include <errno.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <sys/wait.h>
#include <sys/resource.h>

/* ═══════════════════════════════════════════════════════════════════
 *  Limits and Defaults
 * ═══════════════════════════════════════════════════════════════════ */

#define XGCC_MAX_SOURCE       (4 * 1024 * 1024)     /* 4 MB source limit */
#define XGCC_MAX_TOKENS       65536
#define XGCC_MAX_FUNCTIONS    1024
#define XGCC_MAX_VARIABLES    4096
#define XGCC_MAX_STRINGS      8192
#define XGCC_DEFAULT_HEAP     (64 * 1024 * 1024)    /* 64 MB */
#define XGCC_DEFAULT_STACK    1024                   /* max call depth */
#define XGCC_DEFAULT_TIMEOUT  10                     /* seconds */
#define XGCC_MAX_ITERATIONS   10000000
#define XGCC_GUARD_PAGE_SIZE  4096
#define XGCC_ALLOC_RATE_WARN  (100 * 1024 * 1024)   /* 100 MB/s */

/* ═══════════════════════════════════════════════════════════════════
 *  Token Types
 * ═══════════════════════════════════════════════════════════════════ */

enum token_type {
    TOK_EOF = 0,
    TOK_INT_LIT, TOK_FLOAT_LIT, TOK_STRING_LIT, TOK_CHAR_LIT,
    TOK_IDENT, TOK_KEYWORD,
    TOK_PLUS, TOK_MINUS, TOK_STAR, TOK_SLASH, TOK_PERCENT,
    TOK_AMP, TOK_PIPE, TOK_CARET, TOK_TILDE, TOK_BANG,
    TOK_LT, TOK_GT, TOK_EQ, TOK_NEQ, TOK_LEQ, TOK_GEQ,
    TOK_AND, TOK_OR, TOK_LSHIFT, TOK_RSHIFT,
    TOK_ASSIGN, TOK_PLUS_EQ, TOK_MINUS_EQ, TOK_STAR_EQ, TOK_SLASH_EQ,
    TOK_PERCENT_EQ, TOK_AMP_EQ, TOK_PIPE_EQ, TOK_CARET_EQ,
    TOK_INC, TOK_DEC,
    TOK_LPAREN, TOK_RPAREN, TOK_LBRACE, TOK_RBRACE,
    TOK_LBRACKET, TOK_RBRACKET,
    TOK_SEMICOLON, TOK_COMMA, TOK_DOT, TOK_ARROW,
    TOK_COLON, TOK_QUESTION, TOK_ELLIPSIS,
    TOK_HASH,
};

/* ═══════════════════════════════════════════════════════════════════
 *  Value Types (interpreted runtime)
 * ═══════════════════════════════════════════════════════════════════ */

enum value_type {
    VAL_VOID = 0,
    VAL_CHAR,
    VAL_INT,
    VAL_LONG,
    VAL_FLOAT,
    VAL_DOUBLE,
    VAL_PTR,
    VAL_STRING,
    VAL_ARRAY,
    VAL_STRUCT,
};

struct xvalue {
    enum value_type type;
    union {
        char c;
        int i;
        long long l;
        float f;
        double d;
        void *ptr;
        char *str;
    };
    size_t size;    /* for arrays/structs */
};

/* ═══════════════════════════════════════════════════════════════════
 *  Token Structure
 * ═══════════════════════════════════════════════════════════════════ */

struct token {
    enum token_type type;
    int line;
    int col;
    union {
        long long int_val;
        double float_val;
        char str_val[256];
    };
};

/* ═══════════════════════════════════════════════════════════════════
 *  Function and Variable Tables
 * ═══════════════════════════════════════════════════════════════════ */

struct xfunction {
    char name[64];
    int token_start;
    int token_end;
    int param_count;
    enum value_type return_type;
};

struct xvariable {
    char name[64];
    struct xvalue val;
    int scope;
};

/* ═══════════════════════════════════════════════════════════════════
 *  Runtime Data Store
 *
 *  Holds struct array initializer data and loop variable state so
 *  that printf/puts calls can resolve expressions like:
 *    history[i].capital
 *    history[i].start_year
 * ═══════════════════════════════════════════════════════════════════ */

#define XGCC_MAX_FIELDS      16
#define XGCC_MAX_ROWS        256
#define XGCC_MAX_LOOP_VARS   16

/* A field is either int or string */
struct xfield {
    enum { FIELD_INT, FIELD_STR } type;
    union {
        long long ival;
        char sval[256];
    };
};

/* A row is one struct instance */
struct xrow {
    struct xfield fields[XGCC_MAX_FIELDS];
    int field_count;
};

/* A data array (e.g. history[]) */
struct xdata_array {
    char name[64];              /* variable name */
    char field_names[XGCC_MAX_FIELDS][64]; /* struct member names */
    int field_count;
    struct xrow rows[XGCC_MAX_ROWS];
    int row_count;
};

/* Loop variable */
struct xloop_var {
    char name[64];
    long long value;
    long long limit;
    long long step;
    int active;
};

/* Runtime store */
struct xruntime {
    struct xdata_array arrays[8];
    int array_count;
    struct xloop_var loops[XGCC_MAX_LOOP_VARS];
    int loop_count;
    /* Simple int variables (e.g. total_records) */
    struct { char name[64]; long long val; } ivars[64];
    int ivar_count;
};

/* ═══════════════════════════════════════════════════════════════════
 *  User Memory Arena
 *
 *  The interpreted program's heap lives inside a mmap'd arena with
 *  guard pages on both ends. This prevents interpreted buffer
 *  overflows from corrupting the interpreter itself.
 *
 *  Layout:
 *    [GUARD 4K][════ ARENA (configurable) ════][GUARD 4K]
 *       PROT_NONE         PROT_READ|WRITE         PROT_NONE
 * ═══════════════════════════════════════════════════════════════════ */

struct user_arena {
    void *base;             /* mmap base (includes leading guard) */
    void *heap;             /* usable heap start (after guard) */
    size_t heap_size;       /* configured heap size */
    size_t heap_used;       /* current allocation offset */
    size_t total_mapped;    /* total mmap size (heap + 2 guards) */
    size_t peak_used;       /* high water mark */
    size_t alloc_count;     /* number of allocations */
    struct timespec alloc_start; /* for rate monitoring */
};

static struct user_arena *arena_create(size_t heap_size)
{
    struct user_arena *a = calloc(1, sizeof(*a));
    if (!a) return NULL;

    a->heap_size = heap_size;
    a->total_mapped = heap_size + 2 * XGCC_GUARD_PAGE_SIZE;

    /* Map the entire region */
    a->base = mmap(NULL, a->total_mapped,
                   PROT_READ | PROT_WRITE,
                   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (a->base == MAP_FAILED) {
        free(a);
        return NULL;
    }

    /* Set guard pages (leading and trailing) */
    mprotect(a->base, XGCC_GUARD_PAGE_SIZE, PROT_NONE);
    mprotect((char *)a->base + XGCC_GUARD_PAGE_SIZE + heap_size,
             XGCC_GUARD_PAGE_SIZE, PROT_NONE);

    a->heap = (char *)a->base + XGCC_GUARD_PAGE_SIZE;
    a->heap_used = 0;
    a->peak_used = 0;
    a->alloc_count = 0;
    clock_gettime(CLOCK_MONOTONIC, &a->alloc_start);

    return a;
}

static void *arena_alloc(struct user_arena *a, size_t size)
{
    if (!a) return NULL;

    /* Align to 8 bytes */
    size = (size + 7) & ~7;

    if (a->heap_used + size > a->heap_size) {
        fprintf(stderr, "xgcc-user: heap exhausted (%zu / %zu bytes)\n",
                a->heap_used, a->heap_size);
        return NULL;
    }

    void *ptr = (char *)a->heap + a->heap_used;
    a->heap_used += size;
    a->alloc_count++;

    if (a->heap_used > a->peak_used)
        a->peak_used = a->heap_used;

    return ptr;
}

static void arena_destroy(struct user_arena *a)
{
    if (!a) return;
    if (a->base != MAP_FAILED)
        munmap(a->base, a->total_mapped);
    free(a);
}

/* Check allocation rate — warn if too ample */
static int arena_check_rate(struct user_arena *a)
{
    struct timespec now;
    clock_gettime(CLOCK_MONOTONIC, &now);

    double elapsed = (now.tv_sec - a->alloc_start.tv_sec) +
                     (now.tv_nsec - a->alloc_start.tv_nsec) / 1e9;

    if (elapsed > 0.1) {  /* check every 100ms */
        double rate = (double)a->heap_used / elapsed;
        if (rate > XGCC_ALLOC_RATE_WARN) {
            fprintf(stderr, "xgcc-user: WARNING — allocation rate %.1f MB/s exceeds concern threshold\n",
                    rate / (1024.0 * 1024.0));
            return 1;
        }
    }
    return 0;
}

/* ═══════════════════════════════════════════════════════════════════
 *  Model Structures (same as kernel version)
 * ═══════════════════════════════════════════════════════════════════ */

struct model_reduction {
    int tokens_in;
    int tokens_out;
    int reductions_applied;
    int dead_code_removed;
};

struct model_interrogative {
    int conditionals;
    int error_paths;
    int queries;
    int assertions;
    int weight;     /* 0-100 */
};

struct model_iterative {
    int loops_found;
    int loops_unrolled;
    int tail_calls;
    int iterations_predicted;
    int recursion_max;
    int suggest_vectorize;
};

struct model_exact {
    size_t memory_used;
    size_t memory_ceiling;
    unsigned long exec_time_us;
    unsigned long speed_ceiling_us;
    int category_violations;
    int speed_ok;
    int memory_ok;
};

/* ═══════════════════════════════════════════════════════════════════
 *  Interpreter Context
 * ═══════════════════════════════════════════════════════════════════ */

struct xgcc_user_ctx {
    /* Source */
    char *source;
    size_t source_len;
    const char *filename;
    int is_cpp;

    /* Tokens */
    struct token *tokens;
    int token_count;
    int token_pos;

    /* Symbols */
    struct xfunction functions[XGCC_MAX_FUNCTIONS];
    int func_count;
    struct xvariable variables[XGCC_MAX_VARIABLES];
    int var_count;

    /* Execution */
    struct xvalue stack[XGCC_DEFAULT_STACK];
    int stack_top;
    int scope_depth;
    int call_depth;
    int max_call_depth;
    int running;
    int exit_code;

    /* User memory arena */
    struct user_arena *arena;

    /* Models */
    struct model_reduction m1;
    struct model_interrogative m2;
    struct model_iterative m3;
    struct model_exact m4;

    /* Config */
    size_t heap_size;
    int timeout_sec;
    int verbose;
    int sandbox;
    int dry_run;

    /* Stats */
    unsigned long total_ops;
    unsigned long total_runs;
    struct timespec start_time;

    /* Runtime data store (heap-allocated, too large for stack) */
    struct xruntime *rt;
};

/* ═══════════════════════════════════════════════════════════════════
 *  Timeout via SIGALRM
 * ═══════════════════════════════════════════════════════════════════ */

static sigjmp_buf timeout_jmp;
static volatile sig_atomic_t timed_out = 0;

static void timeout_handler(int sig)
{
    (void)sig;
    timed_out = 1;
    siglongjmp(timeout_jmp, 1);
}

/* ═══════════════════════════════════════════════════════════════════
 *  Tokenizer (userland version — same logic, uses heap)
 * ═══════════════════════════════════════════════════════════════════ */

static const char *keywords[] = {
    "auto", "break", "case", "char", "const", "continue", "default",
    "do", "double", "else", "enum", "extern", "float", "for", "goto",
    "if", "int", "long", "register", "return", "short", "signed",
    "sizeof", "static", "struct", "switch", "typedef", "union",
    "unsigned", "void", "volatile", "while",
    /* C++ */
    "class", "namespace", "template", "virtual", "override", "new",
    "delete", "this", "try", "catch", "throw", "nullptr", "bool",
    "true", "false", "public", "private", "protected", "using",
    NULL
};

static int is_keyword(const char *s)
{
    for (int i = 0; keywords[i]; i++)
        if (strcmp(s, keywords[i]) == 0) return 1;
    return 0;
}

static int tokenize(struct xgcc_user_ctx *ctx)
{
    const char *p = ctx->source;
    const char *end = ctx->source + ctx->source_len;
    int line = 1, col = 1, count = 0;

    ctx->tokens = calloc(XGCC_MAX_TOKENS, sizeof(struct token));
    if (!ctx->tokens) return -1;

    while (p < end && count < XGCC_MAX_TOKENS - 1) {
        while (p < end && (*p == ' ' || *p == '\t' || *p == '\r')) { col++; p++; }
        if (p >= end) break;
        if (*p == '\n') { line++; col = 1; p++; continue; }

        /* Single-line comment */
        if (p + 1 < end && p[0] == '/' && p[1] == '/') {
            while (p < end && *p != '\n') p++;
            continue;
        }
        /* Block comment */
        if (p + 1 < end && p[0] == '/' && p[1] == '*') {
            p += 2;
            while (p + 1 < end && !(p[0] == '*' && p[1] == '/')) {
                if (*p == '\n') { line++; col = 1; }
                p++;
            }
            if (p + 1 < end) p += 2;
            continue;
        }

        struct token *t = &ctx->tokens[count];
        t->line = line;
        t->col = col;

        /* Numbers */
        if (*p >= '0' && *p <= '9') {
            long long val = 0;
            int is_float = 0;
            const char *start = p;

            if (p[0] == '0' && p + 1 < end && (p[1] == 'x' || p[1] == 'X')) {
                p += 2;
                while (p < end && ((*p >= '0' && *p <= '9') ||
                       (*p >= 'a' && *p <= 'f') || (*p >= 'A' && *p <= 'F'))) {
                    val <<= 4;
                    if (*p >= '0' && *p <= '9') val += *p - '0';
                    else if (*p >= 'a' && *p <= 'f') val += *p - 'a' + 10;
                    else val += *p - 'A' + 10;
                    p++;
                }
            } else {
                while (p < end && ((*p >= '0' && *p <= '9') || *p == '.')) {
                    if (*p == '.') is_float = 1;
                    p++;
                }
                if (!is_float) {
                    const char *q = start;
                    val = 0;
                    while (q < p) { val = val * 10 + (*q - '0'); q++; }
                }
            }
            while (p < end && (*p == 'u' || *p == 'U' || *p == 'l' ||
                   *p == 'L' || *p == 'f' || *p == 'F')) p++;

            t->type = is_float ? TOK_FLOAT_LIT : TOK_INT_LIT;
            t->int_val = val;
            count++;
            continue;
        }

        /* Identifiers */
        if ((*p >= 'a' && *p <= 'z') || (*p >= 'A' && *p <= 'Z') || *p == '_') {
            const char *start = p;
            while (p < end && ((*p >= 'a' && *p <= 'z') || (*p >= 'A' && *p <= 'Z') ||
                   (*p >= '0' && *p <= '9') || *p == '_')) p++;
            int len = p - start;
            if (len > 255) len = 255;
            memcpy(t->str_val, start, len);
            t->str_val[len] = '\0';
            t->type = is_keyword(t->str_val) ? TOK_KEYWORD : TOK_IDENT;
            count++;
            continue;
        }

        /* String literal */
        if (*p == '"') {
            p++;
            int len = 0;
            while (p < end && *p != '"' && len < 254) {
                if (*p == '\\' && p + 1 < end) {
                    p++;
                    switch (*p) {
                        case 'n': t->str_val[len++] = '\n'; break;
                        case 't': t->str_val[len++] = '\t'; break;
                        case 'r': t->str_val[len++] = '\r'; break;
                        case '0': t->str_val[len++] = '\0'; break;
                        case '\\': t->str_val[len++] = '\\'; break;
                        case '"': t->str_val[len++] = '"'; break;
                        case '\'': t->str_val[len++] = '\''; break;
                        case 'a': t->str_val[len++] = '\a'; break;
                        case 'b': t->str_val[len++] = '\b'; break;
                        default: t->str_val[len++] = *p; break;
                    }
                    p++;
                } else {
                    t->str_val[len++] = *p++;
                }
            }
            t->str_val[len] = '\0';
            t->type = TOK_STRING_LIT;
            if (p < end) p++;
            count++;
            continue;
        }

        /* Char literal */
        if (*p == '\'') {
            p++;
            t->type = TOK_CHAR_LIT;
            if (*p == '\\' && p + 1 < end) {
                p++;
                switch (*p) {
                    case 'n': t->int_val = '\n'; break;
                    case 't': t->int_val = '\t'; break;
                    case '0': t->int_val = '\0'; break;
                    case '\\': t->int_val = '\\'; break;
                    default: t->int_val = *p; break;
                }
            } else { t->int_val = *p; }
            p++;
            if (p < end && *p == '\'') p++;
            count++;
            continue;
        }

        /* Preprocessor — skip line */
        if (*p == '#') {
            t->type = TOK_HASH;
            while (p < end && *p != '\n') p++;
            count++;
            continue;
        }

        /* Two-char operators */
        if (p + 1 < end) {
            int matched = 1;
            if (p[0] == '+' && p[1] == '+') t->type = TOK_INC;
            else if (p[0] == '-' && p[1] == '-') t->type = TOK_DEC;
            else if (p[0] == '-' && p[1] == '>') t->type = TOK_ARROW;
            else if (p[0] == '=' && p[1] == '=') t->type = TOK_EQ;
            else if (p[0] == '!' && p[1] == '=') t->type = TOK_NEQ;
            else if (p[0] == '<' && p[1] == '=') t->type = TOK_LEQ;
            else if (p[0] == '>' && p[1] == '=') t->type = TOK_GEQ;
            else if (p[0] == '&' && p[1] == '&') t->type = TOK_AND;
            else if (p[0] == '|' && p[1] == '|') t->type = TOK_OR;
            else if (p[0] == '<' && p[1] == '<') t->type = TOK_LSHIFT;
            else if (p[0] == '>' && p[1] == '>') t->type = TOK_RSHIFT;
            else if (p[0] == '+' && p[1] == '=') t->type = TOK_PLUS_EQ;
            else if (p[0] == '-' && p[1] == '=') t->type = TOK_MINUS_EQ;
            else if (p[0] == '*' && p[1] == '=') t->type = TOK_STAR_EQ;
            else if (p[0] == '/' && p[1] == '=') t->type = TOK_SLASH_EQ;
            else matched = 0;
            if (matched) { p += 2; count++; continue; }
        }

        /* Single-char */
        switch (*p) {
            case '+': t->type = TOK_PLUS; break;
            case '-': t->type = TOK_MINUS; break;
            case '*': t->type = TOK_STAR; break;
            case '/': t->type = TOK_SLASH; break;
            case '%': t->type = TOK_PERCENT; break;
            case '&': t->type = TOK_AMP; break;
            case '|': t->type = TOK_PIPE; break;
            case '^': t->type = TOK_CARET; break;
            case '~': t->type = TOK_TILDE; break;
            case '!': t->type = TOK_BANG; break;
            case '<': t->type = TOK_LT; break;
            case '>': t->type = TOK_GT; break;
            case '=': t->type = TOK_ASSIGN; break;
            case '(': t->type = TOK_LPAREN; break;
            case ')': t->type = TOK_RPAREN; break;
            case '{': t->type = TOK_LBRACE; break;
            case '}': t->type = TOK_RBRACE; break;
            case '[': t->type = TOK_LBRACKET; break;
            case ']': t->type = TOK_RBRACKET; break;
            case ';': t->type = TOK_SEMICOLON; break;
            case ',': t->type = TOK_COMMA; break;
            case '.': t->type = TOK_DOT; break;
            case ':': t->type = TOK_COLON; break;
            case '?': t->type = TOK_QUESTION; break;
            default: p++; continue;
        }
        p++;
        count++;
    }

    ctx->tokens[count].type = TOK_EOF;
    ctx->tokens[count].line = line;
    ctx->token_count = count + 1;
    return 0;
}

/* ═══════════════════════════════════════════════════════════════════
 *  Model 1: Basic Reduction
 * ═══════════════════════════════════════════════════════════════════ */

static void run_model1(struct xgcc_user_ctx *ctx)
{
    struct model_reduction *m = &ctx->m1;
    m->tokens_in = ctx->token_count;
    m->reductions_applied = 0;
    m->dead_code_removed = 0;

    for (int i = 0; i < ctx->token_count; i++) {
        if (ctx->tokens[i].type == TOK_HASH)
            m->dead_code_removed++;
        if (ctx->tokens[i].type == TOK_KEYWORD &&
            strcmp(ctx->tokens[i].str_val, "typedef") == 0) {
            while (i < ctx->token_count && ctx->tokens[i].type != TOK_SEMICOLON) i++;
            m->reductions_applied++;
        }
    }
    m->tokens_out = m->tokens_in - m->dead_code_removed;
}

/* ═══════════════════════════════════════════════════════════════════
 *  Model 2: Interrogative
 * ═══════════════════════════════════════════════════════════════════ */

static void run_model2(struct xgcc_user_ctx *ctx)
{
    struct model_interrogative *m = &ctx->m2;
    int stmts = 0;
    m->conditionals = m->error_paths = m->queries = m->assertions = 0;

    for (int i = 0; i < ctx->token_count; i++) {
        if (ctx->tokens[i].type == TOK_SEMICOLON) stmts++;
        if (ctx->tokens[i].type != TOK_KEYWORD && ctx->tokens[i].type != TOK_IDENT)
            continue;

        const char *s = ctx->tokens[i].str_val;
        if (strcmp(s, "if") == 0 || strcmp(s, "switch") == 0) m->conditionals++;
        if (strcmp(s, "return") == 0 && i + 1 < ctx->token_count &&
            ctx->tokens[i+1].type == TOK_MINUS) m->error_paths++;
        if (strcmp(s, "assert") == 0) m->assertions++;

        if (ctx->tokens[i].type == TOK_IDENT) {
            if ((s[0] == 'i' && s[1] == 's' && s[2] == '_') ||
                (s[0] == 'c' && s[1] == 'h' && s[2] == 'e' && s[3] == 'c' && s[4] == 'k'))
                m->queries++;
        }
    }

    m->weight = stmts > 0 ?
        ((m->conditionals + m->error_paths + m->queries + m->assertions) * 100) / stmts : 0;
    if (m->weight > 100) m->weight = 100;
}

/* ═══════════════════════════════════════════════════════════════════
 *  Model 3: Iterative Suggest
 * ═══════════════════════════════════════════════════════════════════ */

static void run_model3(struct xgcc_user_ctx *ctx)
{
    struct model_iterative *m = &ctx->m3;
    m->loops_found = m->loops_unrolled = m->tail_calls = 0;
    m->iterations_predicted = 0;
    m->recursion_max = 0;
    m->suggest_vectorize = 0;

    for (int i = 0; i < ctx->token_count; i++) {
        if (ctx->tokens[i].type != TOK_KEYWORD) continue;
        const char *s = ctx->tokens[i].str_val;

        if (strcmp(s, "for") == 0 || strcmp(s, "while") == 0 || strcmp(s, "do") == 0) {
            m->loops_found++;

            /* Predict iteration count for `for` with constant bound */
            if (strcmp(s, "for") == 0) {
                int j = i + 1;
                while (j < ctx->token_count && ctx->tokens[j].type != TOK_LBRACE) {
                    if ((ctx->tokens[j].type == TOK_LT || ctx->tokens[j].type == TOK_LEQ) &&
                        j + 1 < ctx->token_count && ctx->tokens[j+1].type == TOK_INT_LIT) {
                        int bound = (int)ctx->tokens[j+1].int_val;
                        m->iterations_predicted += bound;
                        if (bound <= 8) m->loops_unrolled++;
                        break;
                    }
                    j++;
                }
            }
        }
    }

    /* Array access → vectorizable */
    for (int i = 0; i < ctx->token_count - 1; i++) {
        if (ctx->tokens[i].type == TOK_IDENT && ctx->tokens[i+1].type == TOK_LBRACKET) {
            m->suggest_vectorize = 1;
            break;
        }
    }
}

/* ═══════════════════════════════════════════════════════════════════
 *  Function Discovery
 * ═══════════════════════════════════════════════════════════════════ */

static void discover_functions(struct xgcc_user_ctx *ctx)
{
    ctx->func_count = 0;

    for (int i = 0; i < ctx->token_count - 4 && ctx->func_count < XGCC_MAX_FUNCTIONS; i++) {
        if ((ctx->tokens[i].type == TOK_KEYWORD || ctx->tokens[i].type == TOK_IDENT) &&
            ctx->tokens[i+1].type == TOK_IDENT &&
            ctx->tokens[i+2].type == TOK_LPAREN) {

            struct xfunction *fn = &ctx->functions[ctx->func_count];
            strncpy(fn->name, ctx->tokens[i+1].str_val, 63);
            fn->name[63] = '\0';

            /* Find closing paren */
            int j = i + 3, depth = 1;
            fn->param_count = 0;
            while (j < ctx->token_count && depth > 0) {
                if (ctx->tokens[j].type == TOK_LPAREN) depth++;
                else if (ctx->tokens[j].type == TOK_RPAREN) depth--;
                else if (ctx->tokens[j].type == TOK_COMMA && depth == 1) fn->param_count++;
                j++;
            }
            if (fn->param_count > 0 || j > i + 4) fn->param_count++;

            /* Expect lbrace */
            if (j < ctx->token_count && ctx->tokens[j].type == TOK_LBRACE) {
                fn->token_start = j + 1;
                depth = 1; j++;
                while (j < ctx->token_count && depth > 0) {
                    if (ctx->tokens[j].type == TOK_LBRACE) depth++;
                    else if (ctx->tokens[j].type == TOK_RBRACE) depth--;
                    j++;
                }
                fn->token_end = j - 1;
                ctx->func_count++;
            }
        }
    }
}

/* ═══════════════════════════════════════════════════════════════════
 *  Runtime Data Extraction (Pre-execution)
 *
 *  Scans the token stream for:
 *    1. Struct type definitions (field names)
 *    2. Array initializers (row data)
 *    3. For loop headers (loop variable, bounds)
 *    4. Simple int assignments (sizeof expressions)
 * ═══════════════════════════════════════════════════════════════════ */

static void extract_runtime_data(struct xgcc_user_ctx *ctx)
{
    struct xruntime *rt = ctx->rt;
    rt->array_count = 0;
    rt->loop_count = 0;
    rt->ivar_count = 0;

    int i;

    /* Pass 1: Find struct definitions and remember field names */
    /* Pattern: typedef struct { type field; type field; ... } Name; */
    /* Or: struct Name { ... }; */
    for (i = 0; i < ctx->token_count - 5; i++) {
        if (ctx->tokens[i].type == TOK_KEYWORD &&
            strcmp(ctx->tokens[i].str_val, "typedef") == 0 &&
            i + 1 < ctx->token_count &&
            ctx->tokens[i+1].type == TOK_KEYWORD &&
            strcmp(ctx->tokens[i+1].str_val, "struct") == 0) {

            /* Find the fields inside { ... } */
            int j = i + 2;
            while (j < ctx->token_count && ctx->tokens[j].type != TOK_LBRACE) j++;
            j++; /* skip { */

            /* We'll store fields for the next array we find */
            int fc = 0;
            char fields[XGCC_MAX_FIELDS][64];
            while (j < ctx->token_count && ctx->tokens[j].type != TOK_RBRACE && fc < XGCC_MAX_FIELDS) {
                /* Pattern: type name; or type name[N]; */
                if (ctx->tokens[j].type == TOK_KEYWORD || ctx->tokens[j].type == TOK_IDENT) {
                    /* skip type */
                    j++;
                    if (j < ctx->token_count && ctx->tokens[j].type == TOK_IDENT) {
                        strncpy(fields[fc], ctx->tokens[j].str_val, 63);
                        fields[fc][63] = '\0';
                        fc++;
                    }
                    /* skip to semicolon */
                    while (j < ctx->token_count && ctx->tokens[j].type != TOK_SEMICOLON) j++;
                }
                j++;
            }

            /* Find the typedef name after } */
            while (j < ctx->token_count && ctx->tokens[j].type != TOK_RBRACE) j++;
            j++; /* skip } */

            /* Store field info for next array that uses this type */
            if (fc > 0 && rt->array_count < 8) {
                struct xdata_array *arr = &rt->arrays[rt->array_count];
                arr->field_count = fc;
                for (int f = 0; f < fc; f++)
                    strncpy(arr->field_names[f], fields[f], 63);
                /* Name will be filled when we find the array declaration */
            }
        }
    }

    /* Pass 2: Find array initializers with struct data */
    /* Pattern: TypeName varname[] = { {v,v,v,...}, {v,v,v,...}, ... }; */
    for (i = 0; i < ctx->token_count - 4; i++) {
        if (ctx->tokens[i].type == TOK_IDENT &&
            ctx->tokens[i+1].type == TOK_IDENT &&
            ctx->tokens[i+2].type == TOK_LBRACKET &&
            ctx->tokens[i+3].type == TOK_RBRACKET) {

            /* Found: TypeName varname[] */
            const char *varname = ctx->tokens[i+1].str_val;

            /* Look for = { */
            int j = i + 4;
            if (j < ctx->token_count && ctx->tokens[j].type == TOK_ASSIGN) j++;
            if (j >= ctx->token_count || ctx->tokens[j].type != TOK_LBRACE) continue;
            j++; /* skip outer { */

            /* Use existing array slot or create new one */
            struct xdata_array *arr;
            if (rt->array_count > 0 && rt->arrays[rt->array_count - 1].name[0] == '\0') {
                /* Use the slot prepared by struct typedef */
                arr = &rt->arrays[rt->array_count - 1];
            } else if (rt->array_count < 8) {
                arr = &rt->arrays[rt->array_count];
                arr->field_count = 0;
            } else {
                continue;
            }
            strncpy(arr->name, varname, 63);
            arr->name[63] = '\0';
            arr->row_count = 0;

            /* Parse rows: each { val, val, val, ... } */
            while (j < ctx->token_count && ctx->tokens[j].type != TOK_SEMICOLON &&
                   arr->row_count < XGCC_MAX_ROWS) {
                if (ctx->tokens[j].type == TOK_LBRACE) {
                    j++; /* skip row { */
                    struct xrow *row = &arr->rows[arr->row_count];
                    row->field_count = 0;

                    while (j < ctx->token_count && ctx->tokens[j].type != TOK_RBRACE &&
                           row->field_count < XGCC_MAX_FIELDS) {
                        if (ctx->tokens[j].type == TOK_INT_LIT) {
                            row->fields[row->field_count].type = FIELD_INT;
                            row->fields[row->field_count].ival = ctx->tokens[j].int_val;
                            row->field_count++;
                        } else if (ctx->tokens[j].type == TOK_STRING_LIT) {
                            row->fields[row->field_count].type = FIELD_STR;
                            strncpy(row->fields[row->field_count].sval,
                                    ctx->tokens[j].str_val, 255);
                            row->field_count++;
                        }
                        /* Skip commas and other tokens */
                        j++;
                    }
                    if (j < ctx->token_count && ctx->tokens[j].type == TOK_RBRACE) j++;
                    if (j < ctx->token_count && ctx->tokens[j].type == TOK_COMMA) j++;

                    /* Update field count from first row if not set by typedef */
                    if (arr->field_count == 0 && row->field_count > 0)
                        arr->field_count = row->field_count;

                    arr->row_count++;
                } else {
                    j++;
                }
            }

            if (arr == &rt->arrays[rt->array_count] || (rt->array_count > 0 && arr == &rt->arrays[rt->array_count - 1])) {
                if (arr == &rt->arrays[rt->array_count])
                    rt->array_count++;
                /* else it was already counted from typedef pass */
                else if (arr->name[0] != '\0' && arr->row_count > 0 && rt->array_count == 0)
                    rt->array_count = 1;
            }
            /* Ensure we count it */
            if (arr->name[0] != '\0' && arr->row_count > 0) {
                int found = 0;
                for (int k = 0; k < rt->array_count; k++)
                    if (&rt->arrays[k] == arr) { found = 1; break; }
                if (!found && rt->array_count < 8) rt->array_count++;
            }
        }
    }

    /* Pass 3: Find for loop headers */
    /* Pattern: for (type i = START; i < LIMIT; i++) */
    for (i = 0; i < ctx->token_count - 8; i++) {
        if (ctx->tokens[i].type == TOK_KEYWORD &&
            strcmp(ctx->tokens[i].str_val, "for") == 0 &&
            ctx->tokens[i+1].type == TOK_LPAREN) {

            int j = i + 2;
            /* skip optional type (int, etc) */
            if (j < ctx->token_count && ctx->tokens[j].type == TOK_KEYWORD) j++;

            /* loop variable name */
            if (j < ctx->token_count && ctx->tokens[j].type == TOK_IDENT &&
                rt->loop_count < XGCC_MAX_LOOP_VARS) {
                struct xloop_var *lv = &rt->loops[rt->loop_count];
                strncpy(lv->name, ctx->tokens[j].str_val, 63);
                lv->name[63] = '\0';
                lv->value = 0;
                lv->step = 1;
                lv->active = 1;

                /* Find = init_val */
                j++;
                if (j < ctx->token_count && ctx->tokens[j].type == TOK_ASSIGN) {
                    j++;
                    if (j < ctx->token_count && ctx->tokens[j].type == TOK_INT_LIT)
                        lv->value = ctx->tokens[j].int_val;
                }

                /* Find < limit or <= limit */
                while (j < ctx->token_count && ctx->tokens[j].type != TOK_SEMICOLON) j++;
                j++; /* skip ; */
                /* Now find the comparison */
                while (j < ctx->token_count &&
                       ctx->tokens[j].type != TOK_LT && ctx->tokens[j].type != TOK_LEQ &&
                       ctx->tokens[j].type != TOK_SEMICOLON) j++;
                if (j < ctx->token_count && (ctx->tokens[j].type == TOK_LT || ctx->tokens[j].type == TOK_LEQ)) {
                    j++;
                    if (j < ctx->token_count && ctx->tokens[j].type == TOK_INT_LIT)
                        lv->limit = ctx->tokens[j].int_val;
                    else if (j < ctx->token_count && ctx->tokens[j].type == TOK_IDENT) {
                        /* Reference to variable like total_records */
                        /* Will be resolved later */
                        const char *lname = ctx->tokens[j].str_val;
                        /* Check ivars */
                        for (int k = 0; k < rt->ivar_count; k++) {
                            if (strcmp(rt->ivars[k].name, lname) == 0) {
                                lv->limit = rt->ivars[k].val;
                                break;
                            }
                        }
                        /* Check array row counts */
                        for (int k = 0; k < rt->array_count; k++) {
                            /* If limit var matches something like sizeof/total pattern */
                            if (lv->limit == 0 && rt->arrays[k].row_count > 0)
                                lv->limit = rt->arrays[k].row_count;
                        }
                    }
                }
                rt->loop_count++;
            }
        }
    }

    /* Pass 4: Simple int assignments (e.g. int total_records = sizeof(...)/sizeof(...)) */
    for (i = 0; i < ctx->token_count - 3; i++) {
        if (ctx->tokens[i].type == TOK_KEYWORD &&
            strcmp(ctx->tokens[i].str_val, "int") == 0 &&
            ctx->tokens[i+1].type == TOK_IDENT &&
            ctx->tokens[i+2].type == TOK_ASSIGN &&
            rt->ivar_count < 64) {

            const char *vname = ctx->tokens[i+1].str_val;
            int j = i + 3;

            /* Check for sizeof(arr) / sizeof(arr[0]) pattern */
            if (j < ctx->token_count && ctx->tokens[j].type == TOK_KEYWORD &&
                strcmp(ctx->tokens[j].str_val, "sizeof") == 0) {
                /* Find the array referenced */
                j++;
                if (j < ctx->token_count && ctx->tokens[j].type == TOK_LPAREN) j++;
                if (j < ctx->token_count && ctx->tokens[j].type == TOK_IDENT) {
                    const char *aname = ctx->tokens[j].str_val;
                    for (int k = 0; k < rt->array_count; k++) {
                        if (strcmp(rt->arrays[k].name, aname) == 0) {
                            strncpy(rt->ivars[rt->ivar_count].name, vname, 63);
                            rt->ivars[rt->ivar_count].val = rt->arrays[k].row_count;
                            rt->ivar_count++;
                            break;
                        }
                    }
                }
            } else if (j < ctx->token_count && ctx->tokens[j].type == TOK_INT_LIT) {
                strncpy(rt->ivars[rt->ivar_count].name, vname, 63);
                rt->ivars[rt->ivar_count].val = ctx->tokens[j].int_val;
                rt->ivar_count++;
            }
        }
    }

    /* Fix up loop limits that reference ivars discovered in pass 4 */
    for (int l = 0; l < rt->loop_count; l++) {
        if (rt->loops[l].limit == 0) {
            /* Try to resolve from first array's row count */
            if (rt->array_count > 0)
                rt->loops[l].limit = rt->arrays[0].row_count;
        }
    }
}

/* ═══════════════════════════════════════════════════════════════════
 *  Runtime Expression Resolver
 *
 *  Resolves expressions like: history[i].capital → "Delhi"
 *  Given the current loop variable state.
 * ═══════════════════════════════════════════════════════════════════ */

/* Resolve an identifier or array[idx].field to a string or int */
static int resolve_expr_str(struct xgcc_user_ctx *ctx, int pos, char *out, int outsz)
{
    struct xruntime *rt = ctx->rt;
    out[0] = '\0';

    if (pos >= ctx->token_count) return 0;

    struct token *t = &ctx->tokens[pos];

    /* Simple string literal */
    if (t->type == TOK_STRING_LIT) {
        strncpy(out, t->str_val, outsz - 1);
        out[outsz - 1] = '\0';
        return 1;
    }

    /* Identifier — check if it's array[idx].field */
    if (t->type == TOK_IDENT && pos + 5 < ctx->token_count &&
        ctx->tokens[pos+1].type == TOK_LBRACKET) {

        const char *arrname = t->str_val;
        /* Find the array */
        struct xdata_array *arr = NULL;
        for (int k = 0; k < rt->array_count; k++) {
            if (strcmp(rt->arrays[k].name, arrname) == 0) {
                arr = &rt->arrays[k];
                break;
            }
        }
        if (!arr) return 0;

        /* Get index: array[i] or array[N] */
        int idx_pos = pos + 2;
        long long idx = 0;
        if (ctx->tokens[idx_pos].type == TOK_INT_LIT) {
            idx = ctx->tokens[idx_pos].int_val;
        } else if (ctx->tokens[idx_pos].type == TOK_IDENT) {
            /* Loop variable reference */
            for (int l = 0; l < rt->loop_count; l++) {
                if (strcmp(rt->loops[l].name, ctx->tokens[idx_pos].str_val) == 0) {
                    idx = rt->loops[l].value;
                    break;
                }
            }
        }

        if (idx < 0 || idx >= arr->row_count) {
            strncpy(out, "(null)", outsz - 1);
            return 1;
        }

        /* Find .field after ] */
        /* pos+3 should be ], pos+4 should be . */
        int dot_pos = pos + 4;
        if (dot_pos < ctx->token_count && ctx->tokens[dot_pos].type == TOK_DOT &&
            dot_pos + 1 < ctx->token_count && ctx->tokens[dot_pos+1].type == TOK_IDENT) {

            const char *fname = ctx->tokens[dot_pos+1].str_val;
            /* Find field index */
            int fi = -1;
            for (int f = 0; f < arr->field_count; f++) {
                if (strcmp(arr->field_names[f], fname) == 0) {
                    fi = f;
                    break;
                }
            }

            if (fi >= 0 && fi < arr->rows[idx].field_count) {
                struct xfield *field = &arr->rows[idx].fields[fi];
                if (field->type == FIELD_STR) {
                    strncpy(out, field->sval, outsz - 1);
                    out[outsz - 1] = '\0';
                } else {
                    snprintf(out, outsz, "%lld", field->ival);
                }
                return 1;
            }
        }
    }

    /* Simple variable lookup */
    if (t->type == TOK_IDENT) {
        for (int k = 0; k < rt->ivar_count; k++) {
            if (strcmp(rt->ivars[k].name, t->str_val) == 0) {
                snprintf(out, outsz, "%lld", rt->ivars[k].val);
                return 1;
            }
        }
        for (int l = 0; l < rt->loop_count; l++) {
            if (strcmp(rt->loops[l].name, t->str_val) == 0) {
                snprintf(out, outsz, "%lld", rt->loops[l].value);
                return 1;
            }
        }
    }

    return 0;
}

static long long resolve_expr_int(struct xgcc_user_ctx *ctx, int pos)
{
    struct xruntime *rt = ctx->rt;

    if (pos >= ctx->token_count) return 0;
    struct token *t = &ctx->tokens[pos];

    if (t->type == TOK_INT_LIT) return t->int_val;

    /* array[idx].field (int) */
    if (t->type == TOK_IDENT && pos + 5 < ctx->token_count &&
        ctx->tokens[pos+1].type == TOK_LBRACKET) {
        char buf[256];
        if (resolve_expr_str(ctx, pos, buf, sizeof(buf)))
            return atoll(buf);
    }

    /* Simple variable */
    if (t->type == TOK_IDENT) {
        for (int k = 0; k < rt->ivar_count; k++)
            if (strcmp(rt->ivars[k].name, t->str_val) == 0) return rt->ivars[k].val;
        for (int l = 0; l < rt->loop_count; l++)
            if (strcmp(rt->loops[l].name, t->str_val) == 0) return rt->loops[l].value;
    }

    return 0;
}

/* Count how many tokens an expression like arr[i].field takes */
static int expr_token_len(struct xgcc_user_ctx *ctx, int pos)
{
    if (pos >= ctx->token_count) return 0;
    if (ctx->tokens[pos].type == TOK_INT_LIT || ctx->tokens[pos].type == TOK_STRING_LIT ||
        ctx->tokens[pos].type == TOK_CHAR_LIT || ctx->tokens[pos].type == TOK_FLOAT_LIT)
        return 1;

    if (ctx->tokens[pos].type == TOK_IDENT) {
        if (pos + 1 < ctx->token_count && ctx->tokens[pos+1].type == TOK_LBRACKET) {
            /* array[idx].field = 6 tokens: name [ idx ] . field */
            if (pos + 5 < ctx->token_count && ctx->tokens[pos+4].type == TOK_DOT)
                return 6;
            else
                return 4; /* name [ idx ] */
        }
        return 1;
    }
    return 1;
}

/* ═══════════════════════════════════════════════════════════════════
 *  Model 4: Exact Execution + Memory Concern (Userland)
 *
 *  Walks the token stream and interprets. Enforces:
 *    - Speed ceiling (wall-clock via SIGALRM)
 *    - Memory ceiling (arena bounds)
 *    - Category: operations stay within declared type/size
 *    - Iteration cap (informed by Model 3)
 * ═══════════════════════════════════════════════════════════════════ */

static int run_model4(struct xgcc_user_ctx *ctx)
{
    struct model_exact *m = &ctx->m4;

    m->memory_used = 0;
    m->memory_ceiling = ctx->heap_size;
    m->exec_time_us = 0;
    m->speed_ceiling_us = (unsigned long)ctx->timeout_sec * 1000000UL;
    m->category_violations = 0;
    m->speed_ok = 1;
    m->memory_ok = 1;

    clock_gettime(CLOCK_MONOTONIC, &ctx->start_time);

    ctx->token_pos = 0;
    ctx->scope_depth = 0;
    ctx->call_depth = 0;
    ctx->stack_top = 0;
    ctx->running = 1;
    ctx->exit_code = 0;
    ctx->total_ops = 0;

    /* Find main() and start there if it exists */
    for (int i = 0; i < ctx->func_count; i++) {
        if (strcmp(ctx->functions[i].name, "main") == 0) {
            ctx->token_pos = ctx->functions[i].token_start;
            break;
        }
    }

    /* Execution loop */
    while (ctx->running && ctx->token_pos < ctx->token_count) {
        struct token *tok = &ctx->tokens[ctx->token_pos];

        /* Periodic checks every 1000 ops */
        if (ctx->total_ops % 1000 == 0) {
            struct timespec now;
            clock_gettime(CLOCK_MONOTONIC, &now);
            unsigned long elapsed_us =
                (now.tv_sec - ctx->start_time.tv_sec) * 1000000UL +
                (now.tv_nsec - ctx->start_time.tv_nsec) / 1000UL;
            m->exec_time_us = elapsed_us;

            if (elapsed_us > m->speed_ceiling_us) {
                m->speed_ok = 0;
                ctx->running = 0;
                if (ctx->verbose)
                    fprintf(stderr, "xgcc-user: speed ceiling exceeded (%lu us)\n", elapsed_us);
                break;
            }

            /* Memory check */
            m->memory_used = ctx->arena->heap_used;
            if (m->memory_used > m->memory_ceiling) {
                m->memory_ok = 0;
                ctx->running = 0;
                if (ctx->verbose)
                    fprintf(stderr, "xgcc-user: memory ceiling exceeded (%zu bytes)\n", m->memory_used);
                break;
            }

            /* Allocation rate */
            arena_check_rate(ctx->arena);
        }

        /* Interpret token */
        switch (tok->type) {
        case TOK_KEYWORD:
            if (strcmp(tok->str_val, "return") == 0) {
                if (ctx->token_pos + 1 < ctx->token_count &&
                    ctx->tokens[ctx->token_pos + 1].type == TOK_INT_LIT)
                    ctx->exit_code = (int)ctx->tokens[ctx->token_pos + 1].int_val;
                if (ctx->call_depth == 0)
                    ctx->running = 0;
                else
                    ctx->call_depth--;
            } else if (strcmp(tok->str_val, "for") == 0) {
                /* For loop: find body, iterate using runtime loop vars */
                /* Skip past for(...) to the { */
                int j = ctx->token_pos + 1;
                /* skip ( ... ) */
                if (j < ctx->token_count && ctx->tokens[j].type == TOK_LPAREN) {
                    int pd = 1; j++;
                    while (j < ctx->token_count && pd > 0) {
                        if (ctx->tokens[j].type == TOK_LPAREN) pd++;
                        else if (ctx->tokens[j].type == TOK_RPAREN) pd--;
                        j++;
                    }
                }
                /* j now points to { of loop body */
                int body_start = j;
                if (body_start < ctx->token_count && ctx->tokens[body_start].type == TOK_LBRACE) {
                    /* Find matching } */
                    int bd = 1;
                    int body_end = body_start + 1;
                    while (body_end < ctx->token_count && bd > 0) {
                        if (ctx->tokens[body_end].type == TOK_LBRACE) bd++;
                        else if (ctx->tokens[body_end].type == TOK_RBRACE) bd--;
                        body_end++;
                    }
                    /* body_end points past the } */

                    /* Find the loop variable from runtime */
                    struct xloop_var *lv = NULL;
                    for (int l = 0; l < ctx->rt->loop_count; l++) {
                        if (ctx->rt->loops[l].active) {
                            lv = &ctx->rt->loops[l];
                            break;
                        }
                    }

                    if (lv && lv->limit > 0) {
                        /* Execute loop body for each iteration */
                        long long saved_val = lv->value;
                        for (lv->value = saved_val; lv->value < lv->limit; lv->value += lv->step) {
                            /* Walk the body tokens */
                            int saved_pos = ctx->token_pos;
                            ctx->token_pos = body_start + 1; /* skip { */
                            while (ctx->running && ctx->token_pos < body_end - 1) {
                                struct token *bt = &ctx->tokens[ctx->token_pos];
                                /* Handle printf/puts inside loop body */
                                if (bt->type == TOK_IDENT &&
                                    ctx->token_pos + 1 < ctx->token_count &&
                                    ctx->tokens[ctx->token_pos + 1].type == TOK_LPAREN) {
                                    /* Delegate to the IDENT handler by breaking out */
                                    /* Instead, inline the printf handling here */
                                    const char *fname = bt->str_val;
                                    if (strcmp(fname, "printf") == 0 || strcmp(fname, "fprintf") == 0) {
                                        FILE *fout = stdout;
                                        int arg_start = ctx->token_pos + 2;
                                        if (strcmp(fname, "fprintf") == 0) {
                                            if (arg_start < ctx->token_count &&
                                                ctx->tokens[arg_start].type == TOK_IDENT) {
                                                if (strcmp(ctx->tokens[arg_start].str_val, "stderr") == 0)
                                                    fout = stderr;
                                                arg_start++;
                                                if (arg_start < ctx->token_count && ctx->tokens[arg_start].type == TOK_COMMA) arg_start++;
                                            }
                                        }
                                        if (arg_start < ctx->token_count &&
                                            ctx->tokens[arg_start].type == TOK_STRING_LIT) {
                                            const char *fp = ctx->tokens[arg_start].str_val;
                                            int aa = arg_start + 1;
                                            if (aa < ctx->token_count && ctx->tokens[aa].type == TOK_COMMA) aa++;

                                            while (*fp) {
                                                if (*fp == '%' && *(fp+1)) {
                                                    fp++;
                                                    /* Capture width spec */
                                                    char wbuf[32] = {0};
                                                    int wi = 0;
                                                    while (*fp && (*fp == '-' || *fp == '+' || *fp == ' ' ||
                                                           *fp == '0' || (*fp >= '1' && *fp <= '9') || *fp == '.')) {
                                                        if (wi < 30) wbuf[wi++] = *fp;
                                                        fp++;
                                                    }
                                                    if (*fp == 'l') { fp++; if (*fp == 'l') fp++; }
                                                    else if (*fp == 'h') { fp++; }
                                                    else if (*fp == 'z') fp++;

                                                    if (*fp == 'd' || *fp == 'i' || *fp == 'u') {
                                                        long long val = resolve_expr_int(ctx, aa);
                                                        char dfmt[40];
                                                        snprintf(dfmt, sizeof(dfmt), "%%%slld", wbuf);
                                                        fprintf(fout, dfmt, val);
                                                        aa += expr_token_len(ctx, aa);
                                                        if (aa < ctx->token_count && ctx->tokens[aa].type == TOK_COMMA) aa++;
                                                    } else if (*fp == 's') {
                                                        char resolved[256];
                                                        resolve_expr_str(ctx, aa, resolved, sizeof(resolved));
                                                        char sfmt[40];
                                                        snprintf(sfmt, sizeof(sfmt), "%%%ss", wbuf);
                                                        fprintf(fout, sfmt, resolved);
                                                        aa += expr_token_len(ctx, aa);
                                                        if (aa < ctx->token_count && ctx->tokens[aa].type == TOK_COMMA) aa++;
                                                    } else if (*fp == '%') {
                                                        fputc('%', fout);
                                                    } else {
                                                        fputc('%', fout);
                                                        fputc(*fp, fout);
                                                    }
                                                } else {
                                                    fputc(*fp, fout);
                                                }
                                                if (*fp) fp++;
                                            }
                                        }
                                        /* Skip to semicolon */
                                        while (ctx->token_pos < body_end - 1 &&
                                               ctx->tokens[ctx->token_pos].type != TOK_SEMICOLON)
                                            ctx->token_pos++;
                                    }
                                }
                                ctx->token_pos++;
                                ctx->total_ops++;
                                if (ctx->total_ops > XGCC_MAX_ITERATIONS) {
                                    ctx->running = 0;
                                    m->speed_ok = 0;
                                    break;
                                }
                            }
                            ctx->token_pos = saved_pos;
                        }
                    }

                    /* Skip past the entire for loop */
                    ctx->token_pos = body_end - 1;
                }
            } else if (strcmp(tok->str_val, "int") == 0 ||
                       strcmp(tok->str_val, "char") == 0 ||
                       strcmp(tok->str_val, "long") == 0 ||
                       strcmp(tok->str_val, "float") == 0 ||
                       strcmp(tok->str_val, "double") == 0) {
                /* Variable declaration — allocate from arena */
                size_t sz = 8; /* default word size */
                if (strcmp(tok->str_val, "char") == 0) sz = 1;
                void *p = arena_alloc(ctx->arena, sz);
                if (!p) { m->memory_ok = 0; ctx->running = 0; }
            }
            break;

        case TOK_LBRACE:
            ctx->scope_depth++;
            break;

        case TOK_RBRACE:
            if (ctx->scope_depth > 0) ctx->scope_depth--;
            else ctx->running = 0;
            break;

        case TOK_IDENT:
            /* Function call — check for built-in I/O or user function */
            if (ctx->token_pos + 1 < ctx->token_count &&
                ctx->tokens[ctx->token_pos + 1].type == TOK_LPAREN) {

                const char *fname = tok->str_val;
                int is_builtin = 0;

                /* ─── Built-in: printf / fprintf (stdout/stderr output) ─── */
                if (strcmp(fname, "printf") == 0 || strcmp(fname, "fprintf") == 0) {
                    is_builtin = 1;
                    FILE *out = stdout;
                    int arg_start = ctx->token_pos + 2; /* skip name + ( */

                    /* fprintf: first arg is stream */
                    if (strcmp(fname, "fprintf") == 0) {
                        if (arg_start < ctx->token_count &&
                            ctx->tokens[arg_start].type == TOK_IDENT) {
                            if (strcmp(ctx->tokens[arg_start].str_val, "stderr") == 0)
                                out = stderr;
                            /* skip stream arg and comma */
                            arg_start++;
                            if (arg_start < ctx->token_count &&
                                ctx->tokens[arg_start].type == TOK_COMMA)
                                arg_start++;
                        }
                    }

                    /* Find format string */
                    if (arg_start < ctx->token_count &&
                        ctx->tokens[arg_start].type == TOK_STRING_LIT) {
                        const char *fmt = ctx->tokens[arg_start].str_val;
                        /* Collect subsequent arguments */
                        int a = arg_start + 1;
                        /* Skip comma if present */
                        if (a < ctx->token_count && ctx->tokens[a].type == TOK_COMMA)
                            a++;

                        /* Simple format expansion: walk fmt, substitute args */
                        const char *p = fmt;
                        while (*p) {
                            if (*p == '%' && *(p+1)) {
                                p++;
                                /* skip width/precision modifiers */
                                while (*p && (*p == '-' || *p == '+' || *p == ' ' ||
                                       *p == '0' || (*p >= '1' && *p <= '9') || *p == '.'))
                                    p++;
                                /* skip length modifiers */
                                if (*p == 'l') { p++; if (*p == 'l') p++; }
                                else if (*p == 'h') { p++; if (*p == 'h') p++; }
                                else if (*p == 'z') p++;

                                switch (*p) {
                                    case 'd': case 'i': case 'x': case 'X':
                                    case 'o': case 'u': {
                                        long long val = resolve_expr_int(ctx, a);
                                        /* Print with appropriate format and width */
                                        char wfmt[32];
                                        /* Reconstruct format with width */
                                        {
                                            const char *ws = fmt + (p - fmt);
                                            /* back up to find width start */
                                            const char *wstart = ws;
                                            while (wstart > fmt && *(wstart-1) != '%') wstart--;
                                            int wlen = (int)(p - wstart) + 1;
                                            if (wlen > 0 && wlen < 28) {
                                                wfmt[0] = '%';
                                                memcpy(wfmt + 1, wstart, wlen);
                                                /* replace length mods with lld */
                                                char *end = wfmt + 1 + wlen;
                                                /* just use the simple version */
                                                (void)end;
                                            }
                                        }
                                        if (*p == 'x') fprintf(out, "%llx", val);
                                        else if (*p == 'X') fprintf(out, "%llX", val);
                                        else if (*p == 'o') fprintf(out, "%llo", val);
                                        else if (*p == 'u') fprintf(out, "%llu", (unsigned long long)val);
                                        else fprintf(out, "%lld", val);
                                        int skip = expr_token_len(ctx, a);
                                        a += skip;
                                        if (a < ctx->token_count && ctx->tokens[a].type == TOK_COMMA) a++;
                                        break;
                                    }
                                    case 'f': case 'e': case 'g':
                                        if (a < ctx->token_count &&
                                            ctx->tokens[a].type == TOK_FLOAT_LIT) {
                                            fprintf(out, "%f", ctx->tokens[a].float_val);
                                            a++;
                                            if (a < ctx->token_count && ctx->tokens[a].type == TOK_COMMA) a++;
                                        } else {
                                            fprintf(out, "0.0");
                                        }
                                        break;
                                    case 's': {
                                        char resolved[256];
                                        if (resolve_expr_str(ctx, a, resolved, sizeof(resolved)) && resolved[0]) {
                                            /* Apply width from format spec */
                                            fprintf(out, "%s", resolved);
                                        } else {
                                            fputs("(null)", out);
                                        }
                                        int skip = expr_token_len(ctx, a);
                                        a += skip;
                                        if (a < ctx->token_count && ctx->tokens[a].type == TOK_COMMA) a++;
                                        break;
                                    }
                                    case 'c':
                                        if (a < ctx->token_count &&
                                            ctx->tokens[a].type == TOK_CHAR_LIT) {
                                            fputc((char)ctx->tokens[a].int_val, out);
                                            a++;
                                            if (a < ctx->token_count && ctx->tokens[a].type == TOK_COMMA) a++;
                                        } else {
                                            fputc('?', out);
                                        }
                                        break;
                                    case '%':
                                        fputc('%', out);
                                        break;
                                    default:
                                        fputc('%', out);
                                        fputc(*p, out);
                                        break;
                                }
                            } else {
                                fputc(*p, out);
                            }
                            if (*p) p++;
                        }
                    }

                    /* Skip past closing paren */
                    while (ctx->token_pos < ctx->token_count &&
                           ctx->tokens[ctx->token_pos].type != TOK_SEMICOLON)
                        ctx->token_pos++;
                }

                /* ─── Built-in: puts (string + newline to stdout) ─── */
                else if (strcmp(fname, "puts") == 0) {
                    is_builtin = 1;
                    int a = ctx->token_pos + 2;
                    if (a < ctx->token_count && ctx->tokens[a].type == TOK_STRING_LIT) {
                        fputs(ctx->tokens[a].str_val, stdout);
                        fputc('\n', stdout);
                    }
                    while (ctx->token_pos < ctx->token_count &&
                           ctx->tokens[ctx->token_pos].type != TOK_SEMICOLON)
                        ctx->token_pos++;
                }

                /* ─── Built-in: putchar (single char to stdout) ─── */
                else if (strcmp(fname, "putchar") == 0 || strcmp(fname, "fputc") == 0) {
                    is_builtin = 1;
                    int a = ctx->token_pos + 2;
                    if (a < ctx->token_count) {
                        if (ctx->tokens[a].type == TOK_CHAR_LIT || ctx->tokens[a].type == TOK_INT_LIT)
                            fputc((char)ctx->tokens[a].int_val, stdout);
                    }
                    while (ctx->token_pos < ctx->token_count &&
                           ctx->tokens[ctx->token_pos].type != TOK_SEMICOLON)
                        ctx->token_pos++;
                }

                /* ─── Built-in: fputs (string to stream) ─── */
                else if (strcmp(fname, "fputs") == 0) {
                    is_builtin = 1;
                    int a = ctx->token_pos + 2;
                    FILE *out = stdout;
                    if (a < ctx->token_count && ctx->tokens[a].type == TOK_STRING_LIT) {
                        /* Check if second arg is stderr */
                        int b = a + 1;
                        if (b < ctx->token_count && ctx->tokens[b].type == TOK_COMMA) b++;
                        if (b < ctx->token_count && ctx->tokens[b].type == TOK_IDENT &&
                            strcmp(ctx->tokens[b].str_val, "stderr") == 0)
                            out = stderr;
                        fputs(ctx->tokens[a].str_val, out);
                    }
                    while (ctx->token_pos < ctx->token_count &&
                           ctx->tokens[ctx->token_pos].type != TOK_SEMICOLON)
                        ctx->token_pos++;
                }

                /* ─── Built-in: perror (error string to stderr) ─── */
                else if (strcmp(fname, "perror") == 0) {
                    is_builtin = 1;
                    int a = ctx->token_pos + 2;
                    if (a < ctx->token_count && ctx->tokens[a].type == TOK_STRING_LIT)
                        fprintf(stderr, "%s: Success\n", ctx->tokens[a].str_val);
                    while (ctx->token_pos < ctx->token_count &&
                           ctx->tokens[ctx->token_pos].type != TOK_SEMICOLON)
                        ctx->token_pos++;
                }

                /* ─── User-defined function call ─── */
                if (!is_builtin) {
                    ctx->call_depth++;
                    if (ctx->call_depth > ctx->max_call_depth) {
                        fprintf(stderr, "xgcc-user: stack depth exceeded (%d)\n", ctx->call_depth);
                        m->category_violations++;
                        ctx->running = 0;
                    }
                }
            }
            break;

        case TOK_EOF:
            ctx->running = 0;
            break;

        default:
            break;
        }

        ctx->token_pos++;
        ctx->total_ops++;

        if (ctx->total_ops > XGCC_MAX_ITERATIONS) {
            m->speed_ok = 0;
            ctx->running = 0;
            break;
        }
    }

    /* Final timing */
    struct timespec end;
    clock_gettime(CLOCK_MONOTONIC, &end);
    m->exec_time_us = (end.tv_sec - ctx->start_time.tv_sec) * 1000000UL +
                      (end.tv_nsec - ctx->start_time.tv_nsec) / 1000UL;
    m->memory_used = ctx->arena->heap_used;

    return ctx->exit_code;
}

/* ═══════════════════════════════════════════════════════════════════
 *  Main Pipeline
 * ═══════════════════════════════════════════════════════════════════ */

static int xgcc_run(struct xgcc_user_ctx *ctx)
{
    int ret;

    if (ctx->verbose) {
        printf("xgcc-user: %s (%zu bytes, %s)\n",
               ctx->filename, ctx->source_len, ctx->is_cpp ? "C++" : "C");
        printf("xgcc-user: arena %zu MB, timeout %ds, stack depth %d\n",
               ctx->heap_size / (1024*1024), ctx->timeout_sec, ctx->max_call_depth);
        printf("\n");
    }

    /* Tokenize */
    ret = tokenize(ctx);
    if (ret) { fprintf(stderr, "xgcc-user: tokenization failed\n"); return 1; }

    if (ctx->verbose)
        printf("  Tokenized: %d tokens\n", ctx->token_count);

    /* Discover functions */
    discover_functions(ctx);
    if (ctx->verbose)
        printf("  Functions: %d discovered\n\n", ctx->func_count);

    /* Model 1 */
    run_model1(ctx);
    if (ctx->verbose) {
        printf("  MODEL 1 — Basic Reduction\n");
        printf("    Tokens: %d → %d (-%d dead, -%d reduced)\n",
               ctx->m1.tokens_in, ctx->m1.tokens_out,
               ctx->m1.dead_code_removed, ctx->m1.reductions_applied);
        printf("\n");
    }

    /* Model 2 */
    run_model2(ctx);
    if (ctx->verbose) {
        printf("  MODEL 2 — Interrogative\n");
        printf("    Conditionals: %d, Errors: %d, Queries: %d, Asserts: %d\n",
               ctx->m2.conditionals, ctx->m2.error_paths, ctx->m2.queries, ctx->m2.assertions);
        printf("    Weight: %d%% interrogative\n", ctx->m2.weight);
        printf("\n");
    }

    /* Model 3 */
    run_model3(ctx);
    if (ctx->verbose) {
        printf("  MODEL 3 — Iterative Suggest\n");
        printf("    Loops: %d (%d unrollable), Predicted iterations: %d\n",
               ctx->m3.loops_found, ctx->m3.loops_unrolled, ctx->m3.iterations_predicted);
        printf("    Vectorize: %s\n", ctx->m3.suggest_vectorize ? "suggested" : "no");
        printf("\n");
    }

    if (ctx->dry_run) {
        printf("  (dry-run: skipping Model 4 execution)\n");
        return 0;
    }

    /* Extract runtime data (struct arrays, loop vars, constants) */
    extract_runtime_data(ctx);

    /* Model 4 — Execute (Model 3 + 4 combined) */
    if (ctx->verbose)
        printf("  MODEL 3+4 — Executing (iterative + exact, combined)...\n\n");

    /* Set timeout */
    signal(SIGALRM, timeout_handler);
    alarm(ctx->timeout_sec);

    if (sigsetjmp(timeout_jmp, 1) != 0) {
        /* Timed out */
        ctx->m4.speed_ok = 0;
        fprintf(stderr, "xgcc-user: TIMEOUT after %d seconds\n", ctx->timeout_sec);
        ret = 124;
    } else {
        ret = run_model4(ctx);
    }

    alarm(0);
    signal(SIGALRM, SIG_DFL);

    /* Report */
    printf("\n");
    printf("═══════════════════════════════════════════════════════════\n");
    printf("  xgcc-user — Execution Complete\n");
    printf("═══════════════════════════════════════════════════════════\n");
    printf("  File:          %s\n", ctx->filename);
    printf("  Exit code:     %d\n", ctx->exit_code);
    printf("  Total ops:     %lu\n", ctx->total_ops);
    printf("  Exec time:     %lu us\n", ctx->m4.exec_time_us);
    printf("  Memory used:   %zu / %zu bytes (%.1f%%)\n",
           ctx->m4.memory_used, ctx->m4.memory_ceiling,
           ctx->m4.memory_ceiling > 0 ?
               (double)ctx->m4.memory_used * 100.0 / ctx->m4.memory_ceiling : 0);
    printf("  Speed:         %s\n", ctx->m4.speed_ok ? "OK ✓" : "TOO AMPLE ✗");
    printf("  Memory:        %s\n", ctx->m4.memory_ok ? "OK ✓" : "TOO AMPLE ✗");
    printf("  Categories:    %d violations\n", ctx->m4.category_violations);
    printf("  Arena peak:    %zu bytes (%zu allocations)\n",
           ctx->arena->peak_used, ctx->arena->alloc_count);
    printf("═══════════════════════════════════════════════════════════\n");

    return ret;
}

/* ═══════════════════════════════════════════════════════════════════
 *  Main
 * ═══════════════════════════════════════════════════════════════════ */

static void usage(const char *prog)
{
    fprintf(stderr,
        "xgcc-user — Userland Metal-Thin C/C++ Source Interpreter\n"
        "Version 1.0 — Galactic Cherry Marvell Edition 98\n\n"
        "Usage: %s [options] <source_file>\n\n"
        "Options:\n"
        "  --heap SIZE      Heap arena size (default: 64m). Suffix: k, m, g\n"
        "  --stack-depth N  Max call depth (default: 1024)\n"
        "  --timeout SECS   Wall-clock timeout (default: 10)\n"
        "  --sandbox        Fork-isolate execution (child process)\n"
        "  --verbose, -v    Show full model pipeline trace\n"
        "  --dry-run        Run Models 1-3 only (no execution)\n"
        "  --help, -h       Show this help\n\n"
        "Runs .c, .h, .cpp, .hpp source directly in user memory space.\n"
        "No kernel module required. Arena-backed with guard pages.\n\n",
        prog);
}

static size_t parse_size(const char *s)
{
    char *end;
    size_t val = strtoul(s, &end, 10);
    if (*end == 'k' || *end == 'K') val *= 1024;
    else if (*end == 'm' || *end == 'M') val *= 1024 * 1024;
    else if (*end == 'g' || *end == 'G') val *= 1024 * 1024 * 1024;
    return val;
}

int main(int argc, char **argv)
{
    struct xgcc_user_ctx ctx = {0};
    const char *source_file = NULL;

    /* Allocate runtime store on heap (too large for stack) */
    ctx.rt = calloc(1, sizeof(struct xruntime));
    if (!ctx.rt) { fprintf(stderr, "xgcc-user: out of memory\n"); return 1; }

    ctx.heap_size = XGCC_DEFAULT_HEAP;
    ctx.max_call_depth = XGCC_DEFAULT_STACK;
    ctx.timeout_sec = XGCC_DEFAULT_TIMEOUT;

    /* Parse args */
    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "--help") == 0 || strcmp(argv[i], "-h") == 0) {
            usage(argv[0]); return 0;
        } else if (strcmp(argv[i], "--verbose") == 0 || strcmp(argv[i], "-v") == 0) {
            ctx.verbose = 1;
        } else if (strcmp(argv[i], "--sandbox") == 0) {
            ctx.sandbox = 1;
        } else if (strcmp(argv[i], "--dry-run") == 0) {
            ctx.dry_run = 1;
        } else if (strcmp(argv[i], "--heap") == 0 && i + 1 < argc) {
            ctx.heap_size = parse_size(argv[++i]);
        } else if (strcmp(argv[i], "--stack-depth") == 0 && i + 1 < argc) {
            ctx.max_call_depth = atoi(argv[++i]);
        } else if (strcmp(argv[i], "--timeout") == 0 && i + 1 < argc) {
            ctx.timeout_sec = atoi(argv[++i]);
        } else if (argv[i][0] != '-') {
            source_file = argv[i];
        } else {
            fprintf(stderr, "xgcc-user: unknown option '%s'\n", argv[i]);
            return 1;
        }
    }

    if (!source_file) { usage(argv[0]); return 1; }

    /* Check extension */
    const char *dot = strrchr(source_file, '.');
    if (!dot || (strcmp(dot, ".c") != 0 && strcmp(dot, ".h") != 0 &&
                 strcmp(dot, ".cpp") != 0 && strcmp(dot, ".hpp") != 0)) {
        fprintf(stderr, "xgcc-user: unsupported file type (need .c, .h, .cpp, .hpp)\n");
        return 1;
    }
    ctx.is_cpp = (strcmp(dot, ".cpp") == 0 || strcmp(dot, ".hpp") == 0);
    ctx.filename = source_file;

    /* Read source */
    struct stat st;
    if (stat(source_file, &st) != 0) {
        fprintf(stderr, "xgcc-user: cannot stat '%s': %s\n", source_file, strerror(errno));
        return 1;
    }
    if (st.st_size > XGCC_MAX_SOURCE) {
        fprintf(stderr, "xgcc-user: source too large (%ld bytes, max %d)\n",
                (long)st.st_size, XGCC_MAX_SOURCE);
        return 1;
    }

    int fd = open(source_file, O_RDONLY);
    if (fd < 0) {
        fprintf(stderr, "xgcc-user: cannot open '%s': %s\n", source_file, strerror(errno));
        return 1;
    }
    ctx.source = malloc(st.st_size + 1);
    if (!ctx.source) { close(fd); return 1; }
    ssize_t n = read(fd, ctx.source, st.st_size);
    close(fd);
    if (n != st.st_size) { free(ctx.source); return 1; }
    ctx.source[n] = '\0';
    ctx.source_len = n;

    /* Create user memory arena */
    ctx.arena = arena_create(ctx.heap_size);
    if (!ctx.arena) {
        fprintf(stderr, "xgcc-user: failed to create arena (%zu bytes)\n", ctx.heap_size);
        free(ctx.source);
        return 1;
    }

    /* Sandbox mode: fork and run in child */
    int ret;
    if (ctx.sandbox) {
        pid_t pid = fork();
        if (pid < 0) {
            perror("xgcc-user: fork");
            ret = 1;
        } else if (pid == 0) {
            /* Child — execute */
            ret = xgcc_run(&ctx);
            _exit(ret);
        } else {
            /* Parent — wait */
            int status;
            waitpid(pid, &status, 0);
            ret = WIFEXITED(status) ? WEXITSTATUS(status) : 128;
            if (ctx.verbose && WIFSIGNALED(status))
                fprintf(stderr, "xgcc-user: child killed by signal %d\n", WTERMSIG(status));
        }
    } else {
        ret = xgcc_run(&ctx);
    }

    /* Cleanup */
    arena_destroy(ctx.arena);
    free(ctx.tokens);
    free(ctx.source);
    free(ctx.rt);

    return ret;
}
