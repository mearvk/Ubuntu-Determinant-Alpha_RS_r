#include "../xmc-sha256.h"
#include <stdio.h>
#include <string.h>

int main(void) {
    const char *path = "xmc-sha256-test-input";
    FILE *f = fopen(path, "wb");
    if (!f) return 1;
    if (fwrite("abc", 1, 3, f) != 3 || fclose(f) != 0) return 1;

    char digest[65];
    int rc = xmc_sha256_file(path, digest);
    remove(path);
    if (rc != 0) return 1;

    const char *expected = "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad";
    if (strcmp(digest, expected) != 0) {
        fprintf(stderr, "SHA-256 mismatch: %s\n", digest);
        return 1;
    }
    puts("test_sha256: PASS");
    return 0;
}
