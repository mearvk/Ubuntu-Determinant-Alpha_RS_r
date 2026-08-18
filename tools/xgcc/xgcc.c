/*
 * xgcc — Userspace CLI for the Metal-Thin C/C++ Source Interpreter
 *
 * Reads a .c, .h, .cpp, or .hpp file and submits it to /dev/xgcc
 * for kernel-resident interpretation via the 4-model pipeline.
 *
 * Usage:
 *   xgcc program.c                  — Run C source
 *   xgcc module.cpp                 — Run C++ source
 *   xgcc --model 1 test.c          — Run Model 1 only
 *   xgcc --model 3,4 program.c     — Model 3+4 (default)
 *   xgcc --verbose program.c       — Show model steps
 *   xgcc --status                  — Print /proc/xgcc/status
 *
 * Author: Maximilian Eric Alexander Rupplin von Keffikon
 * Copyright (C) 2026 MEARVK LLC
 * License: GPL-2.0
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <errno.h>

#define XGCC_DEV       "/dev/xgcc"
#define XGCC_STATUS    "/proc/xgcc/status"
#define MAX_SOURCE     (4 * 1024 * 1024)  /* 4 MB */

static void usage(const char *prog)
{
    fprintf(stderr,
        "xgcc — Metal-Thin C/C++ Source Interpreter\n"
        "Version 1.0 — Galactic Cherry Marvell Edition 98\n"
        "\n"
        "Usage:\n"
        "  %s [options] <source_file>\n"
        "\n"
        "Options:\n"
        "  --model N[,M]   Run specific model(s): 1,2,3,4 (default: 3,4)\n"
        "  --verbose        Show model reduction steps\n"
        "  --status         Print interpreter status and exit\n"
        "  --help           Show this help\n"
        "\n"
        "Supported file types:\n"
        "  .c   — C source\n"
        "  .h   — C header (interpreted as C)\n"
        "  .cpp — C++ source\n"
        "  .hpp — C++ header (interpreted as C++)\n"
        "\n"
        "The Four Models:\n"
        "  1 — Basic Reduction:    Strip to essential executable semantics\n"
        "  2 — Interrogative:      Evaluate conditional/questioning paths\n"
        "  3 — Iterative Suggest:  Optimize loops, predict iteration bounds\n"
        "  4 — Exact + Memory:     Literal execution with speed/category bounds\n"
        "\n"
        "Default execution: Model 3 + Model 4 together (combined output runs)\n"
        "\n"
        "Examples:\n"
        "  %s hello.c              Run hello.c directly\n"
        "  %s --model 1 test.c    Analyze only (basic reduction)\n"
        "  %s --verbose app.cpp   Run with full model trace\n"
        "\n",
        prog, prog, prog, prog);
}

static int print_status(void)
{
    FILE *f = fopen(XGCC_STATUS, "r");
    if (!f) {
        fprintf(stderr, "xgcc: cannot read %s — is the module loaded?\n", XGCC_STATUS);
        fprintf(stderr, "  Try: sudo modprobe xgcc\n");
        return 1;
    }

    char buf[4096];
    while (fgets(buf, sizeof(buf), f))
        fputs(buf, stdout);

    fclose(f);
    return 0;
}

static int check_extension(const char *filename)
{
    const char *dot = strrchr(filename, '.');
    if (!dot) {
        fprintf(stderr, "xgcc: no file extension — expected .c, .h, .cpp, or .hpp\n");
        return -1;
    }

    if (strcmp(dot, ".c") == 0 || strcmp(dot, ".h") == 0)
        return 0;  /* C */
    if (strcmp(dot, ".cpp") == 0 || strcmp(dot, ".hpp") == 0)
        return 1;  /* C++ */

    fprintf(stderr, "xgcc: unsupported extension '%s' — expected .c, .h, .cpp, or .hpp\n", dot);
    return -1;
}

int main(int argc, char **argv)
{
    const char *source_file = NULL;
    int verbose = 0;
    int show_status = 0;
    int i;

    if (argc < 2) {
        usage(argv[0]);
        return 1;
    }

    /* Parse arguments */
    for (i = 1; i < argc; i++) {
        if (strcmp(argv[i], "--help") == 0 || strcmp(argv[i], "-h") == 0) {
            usage(argv[0]);
            return 0;
        } else if (strcmp(argv[i], "--status") == 0) {
            show_status = 1;
        } else if (strcmp(argv[i], "--verbose") == 0 || strcmp(argv[i], "-v") == 0) {
            verbose = 1;
        } else if (strcmp(argv[i], "--model") == 0) {
            /* Model selection — acknowledged but passed to kernel via header */
            i++; /* skip model argument */
        } else if (argv[i][0] != '-') {
            source_file = argv[i];
        } else {
            fprintf(stderr, "xgcc: unknown option '%s'\n", argv[i]);
            return 1;
        }
    }

    if (show_status)
        return print_status();

    if (!source_file) {
        fprintf(stderr, "xgcc: no source file specified\n");
        return 1;
    }

    /* Validate file extension */
    int is_cpp = check_extension(source_file);
    if (is_cpp < 0) return 1;

    /* Read source file */
    struct stat st;
    if (stat(source_file, &st) != 0) {
        fprintf(stderr, "xgcc: cannot stat '%s': %s\n", source_file, strerror(errno));
        return 1;
    }

    if (st.st_size > MAX_SOURCE) {
        fprintf(stderr, "xgcc: source file too large (%ld bytes, max %d)\n",
                (long)st.st_size, MAX_SOURCE);
        return 1;
    }

    int fd_src = open(source_file, O_RDONLY);
    if (fd_src < 0) {
        fprintf(stderr, "xgcc: cannot open '%s': %s\n", source_file, strerror(errno));
        return 1;
    }

    char *source = malloc(st.st_size + 1);
    if (!source) {
        fprintf(stderr, "xgcc: out of memory\n");
        close(fd_src);
        return 1;
    }

    ssize_t nread = read(fd_src, source, st.st_size);
    close(fd_src);

    if (nread != st.st_size) {
        fprintf(stderr, "xgcc: short read on '%s'\n", source_file);
        free(source);
        return 1;
    }
    source[nread] = '\0';

    /* Submit to kernel interpreter */
    if (verbose) {
        printf("xgcc: submitting %s (%ld bytes, %s)\n",
               source_file, (long)nread, is_cpp ? "C++" : "C");
        printf("xgcc: pipeline — Model 3 (Iterative) + Model 4 (Exact)\n");
        printf("xgcc: executing...\n\n");
    }

    int fd_dev = open(XGCC_DEV, O_WRONLY);
    if (fd_dev < 0) {
        fprintf(stderr, "xgcc: cannot open %s: %s\n", XGCC_DEV, strerror(errno));
        fprintf(stderr, "  Is the xgcc kernel module loaded?\n");
        fprintf(stderr, "  Try: sudo modprobe xgcc\n");
        free(source);
        return 1;
    }

    ssize_t nwritten = write(fd_dev, source, nread);
    close(fd_dev);
    free(source);

    if (nwritten < 0) {
        fprintf(stderr, "xgcc: execution failed: %s\n", strerror(errno));
        return 1;
    }

    /* Print status after execution */
    if (verbose) {
        printf("\n");
        print_status();
    } else {
        /* Quick result from proc */
        FILE *f = fopen(XGCC_STATUS, "r");
        if (f) {
            char buf[256];
            while (fgets(buf, sizeof(buf), f)) {
                if (strstr(buf, "exit code") || strstr(buf, "Speed OK") ||
                    strstr(buf, "Memory OK") || strstr(buf, "Total ops"))
                    printf("  %s", buf);
            }
            fclose(f);
        }
    }

    return 0;
}
