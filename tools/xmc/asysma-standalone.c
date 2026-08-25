#include "asysma_standalone.h"

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv) {
    (void)argc;
    (void)argv;
    fprintf(stderr,
            "ASYSMA standalone bootstrap: package validation is available; "
            "native payload execution is target-specific and must be supplied by the XMC build.\n");
    return EXIT_FAILURE;
}
