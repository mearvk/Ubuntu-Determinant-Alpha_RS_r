/*
 * muntutils_fs.h - C11 filesystem walk, size measurement, and artifact
 * classification core for the muntutils tool.
 *
 * This C core is called from the C++ trimming and reporting engine through
 * the extern "C" linkage declared below. It mirrors the portable engineering
 * pattern used by the sibling utilities tools/size/size.c and tools/limit,
 * including saturating uint64 size summation and IEC human-readable units.
 *
 * Provenance: part of the MEARVK Ubuntu.Determinant.Beta.Restricted tool set.
 * The provenance framing identifies build origin only. It is not a legal
 * ownership, fiduciary, or execution authorization claim.
 *
 * Program based on Science at NCSU - Max Rupplin - MEARVK LLC 2026.
 */
#ifndef MUNTUTILS_FS_H
#define MUNTUTILS_FS_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Category assigned to a file by extension and best-effort magic. */
typedef enum mu_category {
    MU_CAT_OTHER = 0,     /* anything not recognized below */
    MU_CAT_SOURCE = 1,    /* .c .cc .cpp .cxx .h .hpp .hxx and similar */
    MU_CAT_ARTIFACT = 2   /* .so .dll .a .o .dylib and executables */
} mu_category;

/* Aggregate counts and bytes for one category. */
typedef struct mu_bucket {
    uint64_t files;
    uint64_t bytes;
} mu_bucket;

/* Totals for a whole tree, split by category. */
typedef struct mu_stats {
    mu_bucket source;
    mu_bucket artifact;
    mu_bucket other;
    int ok; /* 1 if the whole walk succeeded, 0 if any entry failed */
} mu_stats;

/* Saturating unsigned 64-bit add (never wraps). */
uint64_t mu_add_u64(uint64_t a, uint64_t b);

/* Classify a single path by its file name extension (and executable bit on
 * POSIX). Does not touch the filesystem beyond an optional magic sniff. */
mu_category mu_classify(const char *path);

/* Write a human-readable IEC size (for example "1.50 MiB") into buf. buf must
 * be at least 32 bytes. Returns buf. */
char *mu_human(uint64_t bytes, char *buf, size_t buflen);

/* Recursively measure a tree rooted at path, filling stats by category.
 * Symbolic links are not followed on POSIX. Returns 0 on full success and
 * non-zero if any entry could not be read (partial totals are still filled).
 * stats is zeroed on entry. */
int mu_measure_tree(const char *path, mu_stats *stats);

/* Callback invoked once per regular source file found under a tree. The
 * relative path is relative to the walk root (no leading separator). Return
 * 0 to continue, non-zero to stop the walk early. */
typedef int (*mu_source_cb)(const char *abs_path,
                            const char *rel_path,
                            void *user);

/* Enumerate every source-category regular file beneath root, invoking cb for
 * each. Symbolic links are not followed. Returns 0 on success, non-zero if the
 * walk failed or the callback requested an early stop. */
int mu_enumerate_sources(const char *root, mu_source_cb cb, void *user);

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif /* MUNTUTILS_FS_H */
