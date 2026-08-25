/* ASYSMA manifest/host selection helpers for XMC. */
#include <stdio.h>
#include <string.h>

const char *asysma_host_format(void) {
#if defined(_WIN32)
    return "PE/COFF";
#elif defined(__APPLE__)
    return "Mach-O";
#elif defined(__linux__)
    return "ELF";
#else
    return "UNKNOWN";
#endif
}

const char *asysma_host_arch(void) {
#if defined(__x86_64__) || defined(_M_X64)
    return "x86-64";
#elif defined(__aarch64__) || defined(_M_ARM64)
    return "aarch64";
#else
    return "unknown";
#endif
}

int asysma_write_manifest(FILE *out, const char *entry,
                          const char *java_entry, const char *xclass,
                          const char *native_payload) {
    if (!out || !entry || !java_entry) return -1;
    if (fprintf(out,
        "format=ASYSMA\nversion=1\narchitecture=%s\n"
        "native_format=%s\nentry_type=%s\n"
        "java_runtime=SecureJDK-28\njava_entry=%s\n"
        "xmc_metadata=%s\nnative_payload=%s\n"
        "tec_version=1\nmax_transfer=65536\n",
        asysma_host_arch(), asysma_host_format(), entry, java_entry,
        xclass ? "present" : "absent",
        native_payload ? "present" : "absent") < 0) return -1;
    return 0;
}
