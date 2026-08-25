/*
 * Native ASYSMA bootstrap.
 * The bootstrap is prepended to an .asysma artifact. It locates the
 * versioned ASYSMAEX layout, validates bounds and extracts the embedded
 * native payload before delegating execution to the host OS loader.
 */
#include "asysma_native_layout.h"
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

#if defined(_WIN32)
#include <windows.h>
#else
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <unistd.h>
#if defined(__APPLE__)
#include <mach-o/dyld.h>
#include <spawn.h>
extern char **environ;
#endif
#endif

static int find_layout(FILE *f, asysma_native_layout *layout, long *position) {
    unsigned char block[65536]; long base = 0;
    if (fseek(f, 0, SEEK_SET) != 0) return 0;
    for (;;) {
        size_t n = fread(block, 1, sizeof block, f);
        if (n == 0) break;
        for (size_t i = 0; i + sizeof *layout <= n; ++i) {
            if (memcmp(block + i, ASYSMA_NATIVE_MAGIC, 8) != 0) continue;
            asysma_native_layout candidate; memcpy(&candidate, block + i, sizeof candidate);
            if (candidate.version != ASYSMA_NATIVE_LAYOUT_VERSION || candidate.header_size < sizeof candidate) continue;
            if (candidate.manifest_offset < (uint64_t)(base + (long)i + sizeof candidate)) continue;
            if (candidate.payload_offset && candidate.payload_offset < candidate.manifest_offset + candidate.manifest_size) continue;
            *layout = candidate; *position = base + (long)i; return 1;
        }
        if (n < sizeof block) break; base += (long)n;
        if (fseek(f, base, SEEK_SET) != 0) break;
    }
    return 0;
}

static int copy_payload(FILE *in, uint64_t offset, uint64_t length, const char *path) {
    FILE *out = fopen(path, "wb"); unsigned char buf[65536]; uint64_t left = length;
    if (!out) return 0;
    if (fseek(in, (long)offset, SEEK_SET) != 0) { fclose(out); return 0; }
    while (left) {
        size_t want = left > sizeof buf ? sizeof buf : (size_t)left;
        size_t n = fread(buf, 1, want, in);
        if (n != want || fwrite(buf, 1, n, out) != n) { fclose(out); return 0; }
        left -= n;
    }
    fclose(out); return 1;
}

static int executable_path(char *path, size_t capacity) {
#if defined(_WIN32)
    DWORD n = GetModuleFileNameA(NULL, path, (DWORD)capacity);
    return n > 0 && n < capacity;
#elif defined(__APPLE__)
    uint32_t size = (uint32_t)capacity;
    return _NSGetExecutablePath(path, &size) == 0;
#else
    ssize_t n = readlink("/proc/self/exe", path, capacity - 1);
    if (n <= 0 || (size_t)n >= capacity) return 0;
    path[n] = '\0'; return 1;
#endif
}

int main(void) {
    char self[4096];
    if (!executable_path(self, sizeof self)) { fprintf(stderr, "ASYSMA bootstrap: cannot locate executable\n"); return 1; }
    FILE *in = fopen(self, "rb");
    if (!in) { perror("ASYSMA bootstrap"); return 1; }
    asysma_native_layout layout; long header_pos = 0;
    if (!find_layout(in, &layout, &header_pos)) { fprintf(stderr, "ASYSMA bootstrap: no valid ASYSMAEX layout\n"); fclose(in); return 1; }
    if (layout.payload_size == 0 || layout.payload_offset < (uint64_t)header_pos || layout.payload_offset > UINT64_MAX - layout.payload_size) {
        fprintf(stderr, "ASYSMA bootstrap: no executable native payload\n"); fclose(in); return 1;
    }

#if defined(_WIN32)
    char temp[MAX_PATH], payload[MAX_PATH];
    if (!GetTempPathA(sizeof temp, temp) || !GetTempFileNameA(temp, "asy", 0, payload)) { fprintf(stderr, "ASYSMA bootstrap: temporary path unavailable\n"); fclose(in); return 1; }
    if (!copy_payload(in, layout.payload_offset, layout.payload_size, payload)) { fclose(in); DeleteFileA(payload); return 1; }
    fclose(in); SetFileAttributesA(payload, FILE_ATTRIBUTE_NORMAL);
    char cmd[MAX_PATH + 4]; snprintf(cmd, sizeof cmd, "\"%s\"", payload);
    STARTUPINFOA si; PROCESS_INFORMATION pi; memset(&si,0,sizeof si); memset(&pi,0,sizeof pi); si.cb=sizeof si;
    if (!CreateProcessA(NULL, cmd, NULL, NULL, FALSE, 0, NULL, NULL, &si, &pi)) { DeleteFileA(payload); return 1; }
    CloseHandle(pi.hThread); WaitForSingleObject(pi.hProcess, INFINITE); DWORD code=1; GetExitCodeProcess(pi.hProcess,&code); CloseHandle(pi.hProcess); DeleteFileA(payload); return (int)code;
#else
    char payload[] = "/tmp/asysma-native-XXXXXX"; int fd=mkstemp(payload);
    if(fd<0){perror("ASYSMA bootstrap: mkstemp");fclose(in);return 1;} close(fd);
    if(!copy_payload(in,layout.payload_offset,layout.payload_size,payload)){fclose(in);unlink(payload);return 1;} fclose(in);
    if(chmod(payload,0700)!=0){perror("ASYSMA bootstrap: chmod");unlink(payload);return 1;}
#if defined(__APPLE__)
    pid_t pid; char *const child_argv[]={payload,NULL}; int rc=posix_spawn(&pid,payload,NULL,NULL,child_argv,environ);
    if(rc!=0){fprintf(stderr,"ASYSMA bootstrap: posix_spawn: %s\n",strerror(rc));unlink(payload);return 1;}
    int status=0; waitpid(pid,&status,0); unlink(payload); return WIFEXITED(status)?WEXITSTATUS(status):1;
#else
    execl(payload,payload,(char *)NULL); perror("ASYSMA bootstrap: exec"); unlink(payload); return 1;
#endif
#endif
}
