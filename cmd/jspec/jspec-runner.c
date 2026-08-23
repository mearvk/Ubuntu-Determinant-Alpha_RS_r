#define _GNU_SOURCE
#include "jspec-runner.h"

#include <errno.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <unistd.h>

extern char **environ;

static jspec_runner_format identify_magic(int fd) {
    unsigned char magic[4];
    ssize_t n;

    n = pread(fd, magic, sizeof magic, 0);
    if (n != (ssize_t)sizeof magic) return JSPEC_RUNNER_UNKNOWN;

    if (magic[0] == 0x7f && magic[1] == 'E' &&
        magic[2] == 'L' && magic[3] == 'F') {
        return JSPEC_RUNNER_ELF;
    }
    if (magic[0] == 'M' && magic[1] == 'Z') {
        return JSPEC_RUNNER_PE;
    }
    return JSPEC_RUNNER_UNKNOWN;
}

jspec_runner_format jspec_runner_identify(const char *path) {
    int fd;
    jspec_runner_format format;

    if (!path) return JSPEC_RUNNER_UNKNOWN;

    fd = open(path, O_RDONLY | O_CLOEXEC);
    if (fd < 0) return JSPEC_RUNNER_UNKNOWN;

    format = identify_magic(fd);
    close(fd);
    return format;
}

int jspec_runner_preflight(const jspec_runner_request *request) {
    struct stat st;
    jspec_runner_format format;

    if (!request || !request->target) {
        errno = EINVAL;
        return -1;
    }

    if (stat(request->target, &st) != 0) return -1;
    if (!S_ISREG(st.st_mode)) {
        errno = EINVAL;
        return -1;
    }
    if (access(request->target, X_OK) != 0) return -1;

    format = jspec_runner_identify(request->target);
    if (format != JSPEC_RUNNER_ELF) {
        /* Linux v1 executes native ELF. PE is identified for future Windows use. */
        errno = ENOEXEC;
        return -1;
    }

    return 0;
}

int jspec_runner_launch(const jspec_runner_request *request) {
    char *const fallback_argv[] = { (char *)request->target, NULL };

    if (jspec_runner_preflight(request) != 0) return -1;

    if (request->working_directory &&
        chdir(request->working_directory) != 0) {
        return -1;
    }

    /* The runner performs no shell parsing and no privilege transition. */
    execve(request->target,
           request->argv ? request->argv : fallback_argv,
           request->envp ? request->envp : environ);
    return -1;
}

#ifdef JSPEC_RUNNER_STANDALONE
#include <stdio.h>

int main(int argc, char **argv) {
    jspec_runner_request request;

    if (argc < 2) {
        fprintf(stderr, "usage: %s <.alpha/.elf executable> [args...]\n", argv[0]);
        return 64;
    }

    request.target = argv[1];
    request.argv = &argv[1];
    request.envp = environ;
    request.working_directory = NULL;

    if (jspec_runner_launch(&request) != 0) {
        perror("jspec-runner");
        return 126;
    }
    return 0;
}
#endif
