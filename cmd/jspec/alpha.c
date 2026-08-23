#define _GNU_SOURCE
#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

/*
 * JSpec .alpha Linux v1.
 * The resulting binary is ELF despite the .alpha filename.
 * It performs only the minimum work needed to preserve the native
 * executable contract and hand control to the OS.
 */
int main(int argc, char **argv, char **envp) {
    if (argc < 2) {
        fprintf(stderr, ".alpha: usage: %s <target> [args...]\n", argv[0]);
        return 64;
    }

    execve(argv[1], &argv[1], envp);
    fprintf(stderr, ".alpha: execve(%s): %s\n", argv[1], strerror(errno));
    return 126;
}
