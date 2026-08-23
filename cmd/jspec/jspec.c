#define _GNU_SOURCE
#include "jspec.h"

#include <errno.h>
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <time.h>
#include <unistd.h>

static long long monotonic_ns(void) {
    struct timespec ts;
    if (clock_gettime(CLOCK_MONOTONIC, &ts) != 0) {
        return 0;
    }
    return (long long)ts.tv_sec * 1000000000LL + ts.tv_nsec;
}

jspec_format jspec_identify_format(const char *path) {
    unsigned char magic[4];
    int fd;
    ssize_t n;

    if (!path) return JSPEC_FORMAT_UNKNOWN;

    fd = open(path, O_RDONLY | O_CLOEXEC);
    if (fd < 0) return JSPEC_FORMAT_UNKNOWN;

    n = read(fd, magic, sizeof(magic));
    close(fd);
    if (n != (ssize_t)sizeof(magic)) return JSPEC_FORMAT_UNKNOWN;

    if (magic[0] == 0x7f && magic[1] == 'E' && magic[2] == 'L' && magic[3] == 'F') {
        return JSPEC_FORMAT_ELF;
    }

    if (magic[0] == 'M' && magic[1] == 'Z') {
        return JSPEC_FORMAT_PE;
    }

    return JSPEC_FORMAT_UNKNOWN;
}

int jspec_preflight(const jspec_request *request, jspec_result *result) {
    struct stat st;
    long long start;

    if (!request || !request->target || !result) {
        errno = EINVAL;
        return -1;
    }

    memset(result, 0, sizeof(*result));
    start = monotonic_ns();

    if (stat(request->target, &st) != 0) return -1;
    if (!S_ISREG(st.st_mode)) {
        errno = EINVAL;
        return -1;
    }
    if (access(request->target, X_OK) != 0) return -1;

    result->format = jspec_identify_format(request->target);
    if (result->format == JSPEC_FORMAT_UNKNOWN) {
        errno = ENOEXEC;
        return -1;
    }

    result->preflight_ns = monotonic_ns() - start;
    return 0;
}

int jspec_launch(const jspec_request *request, jspec_result *result) {
    if (jspec_preflight(request, result) != 0) return -1;

    if (request->working_directory && chdir(request->working_directory) != 0) {
        return -1;
    }

    /* JSpec deliberately hands execution back to the OS loader. */
    if (request->argv && request->argv[0]) {
        execve(request->target, request->argv, request->envp ? request->envp : environ);
    } else {
        char *const argv[] = {(char *)request->target, NULL};
        execve(request->target, argv, request->envp ? request->envp : environ);
    }

    return -1;
}

#ifdef JSPEC_STANDALONE
int main(int argc, char **argv) {
    jspec_request request;
    jspec_result result;

    if (argc < 2) {
        fprintf(stderr, "usage: %s <executable> [args...]\n", argv[0]);
        return 64;
    }

    request.target = argv[1];
    request.argv = &argv[1];
    request.envp = environ;
    request.working_directory = NULL;
    request.wait_for_exit = 0;

    if (jspec_launch(&request, &result) != 0) {
        fprintf(stderr, "jspec: launch failed for %s: %s\n", request.target, strerror(errno));
        return 126;
    }

    return result.exit_code;
}
#endif
