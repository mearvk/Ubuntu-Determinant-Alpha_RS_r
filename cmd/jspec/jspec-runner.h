#ifndef JSPEC_RUNNER_H
#define JSPEC_RUNNER_H

#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef enum jspec_runner_format {
    JSPEC_RUNNER_UNKNOWN = 0,
    JSPEC_RUNNER_ALPHA = 1,
    JSPEC_RUNNER_ELF = 2,
    JSPEC_RUNNER_PE = 3
} jspec_runner_format;

typedef struct jspec_runner_request {
    const char *target;
    char *const *argv;
    char *const *envp;
    const char *working_directory;
} jspec_runner_request;

jspec_runner_format jspec_runner_identify(const char *path);
int jspec_runner_preflight(const jspec_runner_request *request);
int jspec_runner_launch(const jspec_runner_request *request);

#ifdef __cplusplus
}
#endif

#endif
