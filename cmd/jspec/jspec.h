#ifndef JSPEC_H
#define JSPEC_H

#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef enum jspec_format {
    JSPEC_FORMAT_UNKNOWN = 0,
    JSPEC_FORMAT_ELF,
    JSPEC_FORMAT_PE
} jspec_format;

typedef struct jspec_request {
    const char *target;
    char *const *argv;
    char *const *envp;
    const char *working_directory;
    int wait_for_exit;
} jspec_request;

typedef struct jspec_result {
    jspec_format format;
    int launched;
    int exit_code;
    long long preflight_ns;
} jspec_result;

/* Identify a target from its on-disk executable header. */
jspec_format jspec_identify_format(const char *path);

/* Validate the minimum launch contract without executing the target. */
int jspec_preflight(const jspec_request *request, jspec_result *result);

/* Native handoff. Linux v1 uses exec-style process semantics. */
int jspec_launch(const jspec_request *request, jspec_result *result);

#ifdef __cplusplus
}
#endif

#endif /* JSPEC_H */
