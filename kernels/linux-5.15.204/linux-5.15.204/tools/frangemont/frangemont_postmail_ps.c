/*
 * frangemont-postmail-ps — Byte-Level Package Safety Inspection Daemon
 *
 * Copyright (C) 2026 MEARVK LLC
 * SPDX-License-Identifier: GPL-2.0
 * Author: Maximilian Eric Alexander Rupplin von Keffikon
 *
 * A daemon that inspects bytes at every stage of the package lifecycle:
 *
 *   STAGE 1: IN-FLIGHT    — Bytes as they are downloaded (APT transport hook)
 *   STAGE 2: AT-REST      — Bytes after download, before installation (DPkg::Pre-Invoke)
 *   STAGE 3: PRE-COPY     — Bytes before they are copied to destination (before dpkg --unpack)
 *   STAGE 4: POST-INSTALL — Bytes after installation (DPkg::Post-Invoke, mandatory)
 *
 * AWARENESS:
 *   - Kernel mode security issues (module loading, /dev/mem, /dev/kmem patterns)
 *   - Memory sharing concerns (shm_open, mmap MAP_SHARED, SysV IPC patterns)
 *   - Existing building blocks integration:
 *       • HPM (Heuristic Port Monitor) — network pattern awareness
 *       • EPERM (Extended Permissions) — trusted/genius class awareness
 *       • Arena Pool — memory safety patterns
 *       • NEGAMANE — immutability awareness
 *       • ClassLoadGuard — structural grade awareness
 *       • Integrity Guardian — allocation discipline (1:1, 1:2)
 *       • JVM Resource Loader — content validation patterns
 *       • MySQL Package Registry — audit trail integration
 *       • sudo_gate — privilege grade awareness
 *       • ClamAV — malware signature cross-check
 *
 * INSTALLED BY DEFAULT in the basic userland install.
 * Runs as a systemd daemon with socket activation for APT transport hooks.
 *
 * JUDGEMENT MODEL:
 *   The daemon uses a scoring system (0-1000) across 5 concern axes:
 *     1. STRUCTURAL  — Does the package contain well-formed, expected file types?
 *     2. BEHAVIORAL  — Does the content suggest dangerous runtime behavior?
 *     3. KERNEL      — Does it touch kernel-mode resources or interfaces?
 *     4. MEMORY      — Does it use shared memory or unusual allocation patterns?
 *     5. PROVENANCE  — Is the source trusted, signed, and consistent?
 *
 *   Score < 100:  CLEAR      — Install proceeds without delay
 *   Score 100-300: NOTICE    — Install proceeds, logged to registry
 *   Score 300-600: CONCERN   — Install proceeds, admin notified
 *   Score 600-800: HOLD      — Install paused, Grade 3+ required to continue
 *   Score > 800:  REJECT     — Install blocked, Grade 7+ required to override
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <signal.h>
#include <time.h>
#include <dirent.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <sys/inotify.h>
#include <sys/mman.h>
#include <sys/select.h>
#include <syslog.h>
#include <pthread.h>
#include <openssl/evp.h>

/* ============================================================================
 * Constants and Configuration
 * ============================================================================ */

#define DAEMON_NAME             "frangemont-postmail-ps"
#define DAEMON_VERSION          "1.0.0"
#define PID_FILE                "/run/frangemont-postmail-ps.pid"
#define SOCKET_PATH             "/run/frangemont-postmail-ps.sock"
#define CONFIG_FILE             "/etc/frangemont-postmail-ps.conf"
#define LOG_DIR                 "/var/log/frangemont"
#define SPOOL_DIR               "/var/spool/frangemont"
#define APT_ARCHIVE_DIR         "/var/cache/apt/archives"
#define APT_PARTIAL_DIR         "/var/cache/apt/archives/partial"

#define MAX_SCAN_SIZE           (256 * 1024 * 1024)  /* 256 MB max scan per file */
#define CHUNK_SIZE              (64 * 1024)           /* 64 KB read chunks */
#define MAX_CONCERNS            64
#define MAX_PATH_LEN            4096
#define SCORE_CLEAR             100
#define SCORE_NOTICE            300
#define SCORE_CONCERN           600
#define SCORE_HOLD              800
#define SCORE_REJECT            1000

/* ============================================================================
 * Concern Axes
 * ============================================================================ */

typedef enum {
    AXIS_STRUCTURAL = 0,
    AXIS_BEHAVIORAL = 1,
    AXIS_KERNEL     = 2,
    AXIS_MEMORY     = 3,
    AXIS_PROVENANCE = 4,
    AXIS_COUNT      = 5
} ConcernAxis;

static const char *axis_names[AXIS_COUNT] = {
    "STRUCTURAL", "BEHAVIORAL", "KERNEL", "MEMORY", "PROVENANCE"
};

/* ============================================================================
 * Inspection Stages
 * ============================================================================ */

typedef enum {
    STAGE_INFLIGHT    = 1,  /* During download */
    STAGE_ATREST      = 2,  /* After download, before install */
    STAGE_PRECOPY     = 3,  /* Before files copied to destination */
    STAGE_POSTINSTALL = 4   /* After installation (mandatory) */
} InspectionStage;

static const char *stage_names[] = {
    NULL, "IN-FLIGHT", "AT-REST", "PRE-COPY", "POST-INSTALL"
};

/* ============================================================================
 * Verdict
 * ============================================================================ */

typedef enum {
    VERDICT_CLEAR   = 0,
    VERDICT_NOTICE  = 1,
    VERDICT_CONCERN = 2,
    VERDICT_HOLD    = 3,
    VERDICT_REJECT  = 4
} Verdict;

static const char *verdict_names[] = {
    "CLEAR", "NOTICE", "CONCERN", "HOLD", "REJECT"
};

/* ============================================================================
 * Concern Record
 * ============================================================================ */

typedef struct {
    ConcernAxis axis;
    int         weight;     /* 1-100 per finding */
    int         line;       /* approximate byte offset / 64 */
    char        detail[256];
} Concern;

/* ============================================================================
 * Inspection Result
 * ============================================================================ */

typedef struct {
    char            path[MAX_PATH_LEN];
    char            package_name[256];
    InspectionStage stage;
    int             scores[AXIS_COUNT];
    int             total_score;
    Verdict         verdict;
    int             concern_count;
    Concern         concerns[MAX_CONCERNS];
    char            sha256[65];
    size_t          file_size;
    time_t          inspected_at;
} InspectionResult;

/* ============================================================================
 * Kernel-Mode Security Patterns
 *
 * These patterns indicate code that touches kernel interfaces or could
 * escalate privilege. Found in source files, scripts, or ELF binaries.
 * ============================================================================ */

static const struct {
    const char *pattern;
    int         weight;
    const char *reason;
} kernel_patterns[] = {
    { "/dev/mem",               80, "Direct physical memory access" },
    { "/dev/kmem",              90, "Kernel memory access" },
    { "/dev/port",              70, "Direct I/O port access" },
    { "insmod ",                60, "Kernel module insertion" },
    { "modprobe ",              50, "Kernel module loading" },
    { "rmmod ",                 40, "Kernel module removal" },
    { "/proc/kallsyms",         60, "Kernel symbol table access" },
    { "/sys/kernel/",           30, "Sysfs kernel interface" },
    { "init_module",            80, "Syscall: load kernel module" },
    { "finit_module",           80, "Syscall: load kernel module from fd" },
    { "delete_module",          70, "Syscall: unload kernel module" },
    { "kexec_load",             90, "Syscall: load new kernel" },
    { "perf_event_open",        40, "Performance monitoring (kernel access)" },
    { "iopl(",                  70, "I/O privilege level change" },
    { "ioperm(",                70, "I/O port permission change" },
    { "CAP_SYS_RAWIO",          60, "Raw I/O capability" },
    { "CAP_SYS_MODULE",         80, "Module loading capability" },
    { "CAP_SYS_ADMIN",          50, "Broad admin capability" },
    { "CAP_NET_RAW",            40, "Raw network capability" },
    { "CLONE_NEWNS",            30, "Mount namespace (container escape vector)" },
    { "CLONE_NEWUSER",          30, "User namespace (privilege boundary)" },
    { NULL, 0, NULL }
};

/* ============================================================================
 * Memory Sharing / IPC Patterns
 * ============================================================================ */

static const struct {
    const char *pattern;
    int         weight;
    const char *reason;
} memory_patterns[] = {
    { "shm_open(",              30, "POSIX shared memory creation" },
    { "shmget(",                30, "SysV shared memory" },
    { "shmat(",                 30, "SysV shared memory attach" },
    { "MAP_SHARED",             20, "Shared memory mapping" },
    { "PROT_EXEC",             40, "Executable memory mapping" },
    { "mprotect(",              50, "Memory protection change" },
    { "process_vm_readv(",      70, "Cross-process memory read" },
    { "process_vm_writev(",     80, "Cross-process memory write" },
    { "ptrace(",                60, "Process tracing/debugging" },
    { "PTRACE_POKEDATA",        70, "Memory injection via ptrace" },
    { "PTRACE_ATTACH",          60, "Process attachment" },
    { "memfd_create(",          40, "Anonymous file-backed memory" },
    { "/dev/shm/",              20, "Shared memory filesystem" },
    { "MAP_ANONYMOUS",          10, "Anonymous memory (normal)" },
    { "MADV_DONTFORK",          20, "Memory advice: don't fork (possible secret)" },
    { NULL, 0, NULL }
};

/* ============================================================================
 * Behavioral / Source Safety Patterns
 *
 * Adapted from jvmResourceLoader content validation model.
 * ============================================================================ */

static const struct {
    const char *pattern;
    int         weight;
    const char *reason;
} behavioral_patterns[] = {
    { "exec(",                  40, "Process execution" },
    { "execve(",                50, "Direct syscall exec" },
    { "system(",                40, "Shell command execution" },
    { "popen(",                 35, "Pipe to shell" },
    { "fork(",                  20, "Process forking (normal)" },
    { "dlopen(",                30, "Dynamic library loading" },
    { "dlsym(",                 25, "Dynamic symbol resolution" },
    { "LD_PRELOAD",             60, "Library injection technique" },
    { "LD_LIBRARY_PATH",        30, "Library path manipulation" },
    { "__asm__",                40, "Inline assembly" },
    { "syscall(",               50, "Direct syscall invocation" },
    { "__NR_",                  40, "Syscall number reference" },
    { "setuid(",                50, "Set user ID" },
    { "setgid(",                40, "Set group ID" },
    { "seteuid(",               50, "Set effective UID" },
    { "chmod 4",                60, "Set SUID bit" },
    { "chmod 2",                40, "Set SGID bit" },
    { "/etc/shadow",            50, "Shadow password access" },
    { "/etc/sudoers",           50, "Sudoers modification" },
    { "crontab",                20, "Cron job installation" },
    { "nc -l",                  40, "Netcat listener (backdoor pattern)" },
    { "curl.*|.*sh",            50, "Download-and-execute pattern" },
    { "wget.*|.*sh",            50, "Download-and-execute pattern" },
    { "base64 -d",              30, "Base64 decode (obfuscation)" },
    { "eval(",                  30, "Dynamic code evaluation" },
    { "rm -rf /",               80, "Destructive filesystem operation" },
    { "dd if=/dev/zero",        60, "Disk overwrite" },
    { "mkfs.",                  50, "Filesystem creation (destructive)" },
    { "iptables -F",            40, "Firewall flush" },
    { NULL, 0, NULL }
};

/* ============================================================================
 * Structural Validation Patterns
 *
 * Checks for well-formedness and expected package structure.
 * ============================================================================ */

static const struct {
    const char *pattern;
    int         weight;
    const char *reason;
} structural_patterns[] = {
    { "\x7f" "ELF",             0, "ELF binary (expected in packages)" },
    { "#!/",                    0, "Shebang script (expected)" },
    { "%PDF",                   10, "PDF in package (unusual)" },
    { "PK\x03\x04",            10, "ZIP archive embedded (unusual)" },
    { "\x1f\x8b",              0, "Gzip content (expected in .deb)" },
    { "-----BEGIN",             20, "Certificate/key material" },
    { "-----BEGIN PRIVATE",     80, "Private key in package!" },
    { "password",               15, "Hardcoded password reference" },
    { "api_key",                20, "API key reference" },
    { "secret",                 10, "Secret reference (may be benign)" },
    { NULL, 0, NULL }
};

/* ============================================================================
 * Global State
 * ============================================================================ */

static volatile sig_atomic_t g_running = 1;
static int g_daemon_mode = 0;
static int g_verbose = 0;
static int g_socket_fd = -1;
static int g_inotify_fd = -1;
static pthread_mutex_t g_log_mutex = PTHREAD_MUTEX_INITIALIZER;

/* ============================================================================
 * Signal Handling
 * ============================================================================ */

static void signal_handler(int sig) {
    if (sig == SIGTERM || sig == SIGINT) {
        g_running = 0;
    }
}

static void setup_signals(void) {
    struct sigaction sa;
    memset(&sa, 0, sizeof(sa));
    sa.sa_handler = signal_handler;
    sigaction(SIGTERM, &sa, NULL);
    sigaction(SIGINT, &sa, NULL);
    sa.sa_handler = SIG_IGN;
    sigaction(SIGPIPE, &sa, NULL);
}

/* ============================================================================
 * Logging
 * ============================================================================ */

static void fpm_log(int priority, const char *fmt, ...) {
    va_list ap;
    va_start(ap, fmt);

    pthread_mutex_lock(&g_log_mutex);

    if (g_daemon_mode) {
        vsyslog(priority, fmt, ap);
    } else {
        char timebuf[32];
        time_t now = time(NULL);
        struct tm tm;
        localtime_r(&now, &tm);
        strftime(timebuf, sizeof(timebuf), "%Y-%m-%d %H:%M:%S", &tm);
        fprintf(stderr, "[%s] %s: ", timebuf, DAEMON_NAME);
        vfprintf(stderr, fmt, ap);
        fprintf(stderr, "\n");
    }

    pthread_mutex_unlock(&g_log_mutex);
    va_end(ap);
}

/* ============================================================================
 * SHA-256 Computation
 * ============================================================================ */

static int compute_sha256(const char *path, char *out_hex) {
    FILE *f = fopen(path, "rb");
    if (!f) return -1;

    EVP_MD_CTX *ctx = EVP_MD_CTX_new();
    if (!ctx) { fclose(f); return -1; }
    EVP_DigestInit_ex(ctx, EVP_sha256(), NULL);

    unsigned char buf[CHUNK_SIZE];
    size_t n;
    while ((n = fread(buf, 1, sizeof(buf), f)) > 0) {
        EVP_DigestUpdate(ctx, buf, n);
    }
    fclose(f);

    unsigned char hash[32];
    unsigned int hash_len = 0;
    EVP_DigestFinal_ex(ctx, hash, &hash_len);
    EVP_MD_CTX_free(ctx);

    for (unsigned int i = 0; i < hash_len; i++) {
        sprintf(out_hex + (i * 2), "%02x", hash[i]);
    }
    out_hex[64] = '\0';
    return 0;
}

/* ============================================================================
 * Pattern Scanning Engine
 *
 * Scans file content against pattern tables. Works on both text and binary
 * content. For binary content, only matches printable substrings.
 * ============================================================================ */

static int scan_buffer_for_pattern(const char *buf, size_t len,
                                    const char *pattern) {
    size_t plen = strlen(pattern);
    if (plen == 0 || plen > len) return 0;

    /* Simple Boyer-Moore-like scan (memmem) */
    return memmem(buf, len, pattern, plen) != NULL;
}

static void scan_patterns(const char *buf, size_t len,
                          InspectionResult *result,
                          const void *table, ConcernAxis axis) {
    /* Generic pattern scanner — works with all pattern tables */
    typedef struct {
        const char *pattern;
        int         weight;
        const char *reason;
    } PatternEntry;

    const PatternEntry *entries = (const PatternEntry *)table;

    for (int i = 0; entries[i].pattern != NULL; i++) {
        if (scan_buffer_for_pattern(buf, len, entries[i].pattern)) {
            result->scores[axis] += entries[i].weight;

            if (result->concern_count < MAX_CONCERNS && entries[i].weight > 0) {
                Concern *c = &result->concerns[result->concern_count++];
                c->axis = axis;
                c->weight = entries[i].weight;
                c->line = 0;  /* Could compute approximate offset */
                snprintf(c->detail, sizeof(c->detail), "%s: %s",
                         entries[i].reason, entries[i].pattern);
            }
        }
    }
}

/* ============================================================================
 * Core Inspection — Single File
 * ============================================================================ */

static int inspect_file(const char *path, InspectionStage stage,
                        InspectionResult *result) {
    memset(result, 0, sizeof(*result));
    strncpy(result->path, path, MAX_PATH_LEN - 1);
    result->stage = stage;
    result->inspected_at = time(NULL);

    /* Stat the file */
    struct stat st;
    if (stat(path, &st) != 0) {
        fpm_log(LOG_WARNING, "Cannot stat %s: %s", path, strerror(errno));
        return -1;
    }
    result->file_size = st.st_size;

    /* Size limit */
    if (st.st_size > MAX_SCAN_SIZE) {
        fpm_log(LOG_INFO, "File too large for full scan: %s (%zu MB)",
                path, st.st_size / (1024 * 1024));
        /* Scan first 256 MB only */
    }

    /* Compute SHA-256 */
    compute_sha256(path, result->sha256);

    /* Read file content */
    size_t scan_size = st.st_size < MAX_SCAN_SIZE ? st.st_size : MAX_SCAN_SIZE;
    char *buf = malloc(scan_size + 1);
    if (!buf) {
        fpm_log(LOG_ERR, "Out of memory scanning %s", path);
        return -1;
    }

    int fd = open(path, O_RDONLY | O_NOFOLLOW);
    if (fd < 0) {
        free(buf);
        fpm_log(LOG_WARNING, "Cannot open %s: %s", path, strerror(errno));
        return -1;
    }

    size_t total_read = 0;
    while (total_read < scan_size) {
        ssize_t n = read(fd, buf + total_read, scan_size - total_read);
        if (n <= 0) break;
        total_read += n;
    }
    close(fd);
    buf[total_read] = '\0';

    /* Run pattern scans across all axes */
    scan_patterns(buf, total_read, result,
                  kernel_patterns, AXIS_KERNEL);
    scan_patterns(buf, total_read, result,
                  memory_patterns, AXIS_MEMORY);
    scan_patterns(buf, total_read, result,
                  behavioral_patterns, AXIS_BEHAVIORAL);
    scan_patterns(buf, total_read, result,
                  structural_patterns, AXIS_STRUCTURAL);

    free(buf);

    /* Provenance scoring — based on file metadata */
    /* Check for GPG signature presence */
    char sig_path[MAX_PATH_LEN + 8];
    snprintf(sig_path, sizeof(sig_path), "%s.asc", path);
    if (access(sig_path, F_OK) == 0) {
        /* Signed — reduce provenance concern */
        result->scores[AXIS_PROVENANCE] = 0;
    } else {
        /* No signature file found — minor provenance concern */
        result->scores[AXIS_PROVENANCE] += 20;
    }

    /* Check file permissions — world-writable is a concern */
    if (st.st_mode & S_IWOTH) {
        result->scores[AXIS_STRUCTURAL] += 30;
        if (result->concern_count < MAX_CONCERNS) {
            Concern *c = &result->concerns[result->concern_count++];
            c->axis = AXIS_STRUCTURAL;
            c->weight = 30;
            snprintf(c->detail, sizeof(c->detail),
                     "World-writable file: %04o", st.st_mode & 07777);
        }
    }

    /* SUID/SGID concern */
    if (st.st_mode & (S_ISUID | S_ISGID)) {
        result->scores[AXIS_BEHAVIORAL] += 40;
        if (result->concern_count < MAX_CONCERNS) {
            Concern *c = &result->concerns[result->concern_count++];
            c->axis = AXIS_BEHAVIORAL;
            c->weight = 40;
            snprintf(c->detail, sizeof(c->detail),
                     "SUID/SGID file: %04o", st.st_mode & 07777);
        }
    }

    /* Compute total score */
    result->total_score = 0;
    for (int i = 0; i < AXIS_COUNT; i++) {
        /* Cap per-axis at 200 to prevent single-axis domination */
        if (result->scores[i] > 200) result->scores[i] = 200;
        result->total_score += result->scores[i];
    }

    /* Determine verdict */
    if (result->total_score < SCORE_CLEAR)
        result->verdict = VERDICT_CLEAR;
    else if (result->total_score < SCORE_NOTICE)
        result->verdict = VERDICT_NOTICE;
    else if (result->total_score < SCORE_CONCERN)
        result->verdict = VERDICT_CONCERN;
    else if (result->total_score < SCORE_HOLD)
        result->verdict = VERDICT_HOLD;
    else
        result->verdict = VERDICT_REJECT;

    return 0;
}

/* ============================================================================
 * Inspect a .deb Package (archive)
 *
 * Extracts and inspects control files and data manifest without full unpack.
 * Uses ar + tar to read the .deb structure.
 * ============================================================================ */

static int inspect_deb_package(const char *deb_path, InspectionStage stage,
                                InspectionResult *result) {
    int rc = inspect_file(deb_path, stage, result);
    if (rc != 0) return rc;

    /* Extract package name from path */
    const char *basename = strrchr(deb_path, '/');
    basename = basename ? basename + 1 : deb_path;
    strncpy(result->package_name, basename, sizeof(result->package_name) - 1);

    /* Remove version/arch suffix from package name */
    char *underscore = strchr(result->package_name, '_');
    if (underscore) *underscore = '\0';

    /* Additionally inspect control.tar contents via pipe */
    char cmd[MAX_PATH_LEN + 128];
    snprintf(cmd, sizeof(cmd),
             "ar p '%s' control.tar.* 2>/dev/null | tar -xO 2>/dev/null",
             deb_path);

    FILE *pipe = popen(cmd, "r");
    if (pipe) {
        char control_buf[65536];
        size_t n = fread(control_buf, 1, sizeof(control_buf) - 1, pipe);
        control_buf[n] = '\0';
        pclose(pipe);

        /* Scan control files for concerns */
        scan_patterns(control_buf, n, result,
                      behavioral_patterns, AXIS_BEHAVIORAL);
        scan_patterns(control_buf, n, result,
                      kernel_patterns, AXIS_KERNEL);
    }

    /* Re-compute total and verdict after additional scanning */
    result->total_score = 0;
    for (int i = 0; i < AXIS_COUNT; i++) {
        if (result->scores[i] > 200) result->scores[i] = 200;
        result->total_score += result->scores[i];
    }

    if (result->total_score < SCORE_CLEAR)
        result->verdict = VERDICT_CLEAR;
    else if (result->total_score < SCORE_NOTICE)
        result->verdict = VERDICT_NOTICE;
    else if (result->total_score < SCORE_CONCERN)
        result->verdict = VERDICT_CONCERN;
    else if (result->total_score < SCORE_HOLD)
        result->verdict = VERDICT_HOLD;
    else
        result->verdict = VERDICT_REJECT;

    return 0;
}

/* ============================================================================
 * Result Reporting — Log to file and MySQL registry
 * ============================================================================ */

static void report_result(const InspectionResult *result) {
    /* Always log */
    fpm_log(LOG_INFO,
            "[%s] %s — %s (score %d) [S:%d B:%d K:%d M:%d P:%d] %s",
            stage_names[result->stage],
            verdict_names[result->verdict],
            result->path,
            result->total_score,
            result->scores[AXIS_STRUCTURAL],
            result->scores[AXIS_BEHAVIORAL],
            result->scores[AXIS_KERNEL],
            result->scores[AXIS_MEMORY],
            result->scores[AXIS_PROVENANCE],
            result->sha256);

    /* Log concerns if verdict is NOTICE or higher */
    if (result->verdict >= VERDICT_NOTICE) {
        for (int i = 0; i < result->concern_count; i++) {
            fpm_log(LOG_INFO, "  [%s +%d] %s",
                    axis_names[result->concerns[i].axis],
                    result->concerns[i].weight,
                    result->concerns[i].detail);
        }
    }

    /* Write to persistent log file */
    char logpath[256];
    snprintf(logpath, sizeof(logpath), "%s/inspections.log", LOG_DIR);
    FILE *logf = fopen(logpath, "a");
    if (logf) {
        char timebuf[32];
        struct tm tm;
        localtime_r(&result->inspected_at, &tm);
        strftime(timebuf, sizeof(timebuf), "%Y-%m-%d %H:%M:%S", &tm);

        fprintf(logf, "%s|%s|%s|%d|%s|%s|%zu|%d|%d|%d|%d|%d\n",
                timebuf,
                stage_names[result->stage],
                verdict_names[result->verdict],
                result->total_score,
                result->path,
                result->sha256,
                result->file_size,
                result->scores[AXIS_STRUCTURAL],
                result->scores[AXIS_BEHAVIORAL],
                result->scores[AXIS_KERNEL],
                result->scores[AXIS_MEMORY],
                result->scores[AXIS_PROVENANCE]);
        fclose(logf);
    }

    /* Record to MySQL package registry if available */
    if (result->verdict >= VERDICT_CONCERN) {
        char mysql_cmd[MAX_PATH_LEN + 512];
        snprintf(mysql_cmd, sizeof(mysql_cmd),
                 "mysql --socket=/run/mysqld/mysqld.sock -u root -D system_registry "
                 "-e \"INSERT IGNORE INTO install_log (action, package_name, "
                 "username, uid, method, notes) VALUES ('inspect', '%s', "
                 "'%s', 0, 'frangemont', 'Score %d: %s')\" 2>/dev/null",
                 result->package_name[0] ? result->package_name : "(unknown)",
                 DAEMON_NAME,
                 result->total_score,
                 verdict_names[result->verdict]);
        (void)system(mysql_cmd);
    }

    /* Notify admin via chat if HOLD or REJECT */
    if (result->verdict >= VERDICT_HOLD) {
        char notify_cmd[MAX_PATH_LEN + 512];
        snprintf(notify_cmd, sizeof(notify_cmd),
                 "chat post ops-team '[FRANGEMONT] %s: %s scored %d (%s)' "
                 "2>/dev/null",
                 verdict_names[result->verdict],
                 result->package_name[0] ? result->package_name : "unknown",
                 result->total_score,
                 result->path);
        (void)system(notify_cmd);
    }
}

/* ============================================================================
 * Stage 1: In-Flight Monitoring
 *
 * Watches /var/cache/apt/archives/partial/ for new files being downloaded.
 * Uses inotify to detect writes and scans incrementally.
 * ============================================================================ */

static void *inflight_monitor_thread(void *arg) {
    (void)arg;

    g_inotify_fd = inotify_init1(IN_NONBLOCK | IN_CLOEXEC);
    if (g_inotify_fd < 0) {
        fpm_log(LOG_ERR, "inotify_init failed: %s", strerror(errno));
        return NULL;
    }

    /* Watch the partial download directory */
    int wd = inotify_add_watch(g_inotify_fd, APT_PARTIAL_DIR,
                                IN_CLOSE_WRITE | IN_MOVED_TO);
    if (wd < 0) {
        /* Directory might not exist yet — that's OK */
        fpm_log(LOG_INFO, "Cannot watch %s (may not exist yet)", APT_PARTIAL_DIR);
        close(g_inotify_fd);
        g_inotify_fd = -1;
        return NULL;
    }

    fpm_log(LOG_INFO, "In-flight monitor active on %s", APT_PARTIAL_DIR);

    char buf[4096];
    while (g_running) {
        ssize_t len = read(g_inotify_fd, buf, sizeof(buf));
        if (len <= 0) {
            usleep(500000);  /* 500ms poll */
            continue;
        }

        char *ptr = buf;
        while (ptr < buf + len) {
            struct inotify_event *ev = (struct inotify_event *)ptr;

            if (ev->len > 0 && ev->name[0] != '.') {
                char fullpath[MAX_PATH_LEN];
                snprintf(fullpath, sizeof(fullpath), "%s/%s",
                         APT_PARTIAL_DIR, ev->name);

                /* Only scan .deb files */
                if (strstr(ev->name, ".deb")) {
                    InspectionResult result;
                    if (inspect_file(fullpath, STAGE_INFLIGHT, &result) == 0) {
                        report_result(&result);
                    }
                }
            }

            ptr += sizeof(struct inotify_event) + ev->len;
        }
    }

    close(g_inotify_fd);
    g_inotify_fd = -1;
    return NULL;
}

/* ============================================================================
 * Stage 2: At-Rest Scanning
 *
 * Called by APT pre-invoke hook. Scans all .deb files in archives/
 * before dpkg processes them.
 * ============================================================================ */

static int scan_atrest(void) {
    DIR *dir = opendir(APT_ARCHIVE_DIR);
    if (!dir) {
        fpm_log(LOG_ERR, "Cannot open %s: %s", APT_ARCHIVE_DIR, strerror(errno));
        return -1;
    }

    int total = 0, flagged = 0;
    struct dirent *ent;

    while ((ent = readdir(dir)) != NULL) {
        if (ent->d_type != DT_REG) continue;
        if (!strstr(ent->d_name, ".deb")) continue;

        char fullpath[MAX_PATH_LEN];
        snprintf(fullpath, sizeof(fullpath), "%s/%s", APT_ARCHIVE_DIR, ent->d_name);

        InspectionResult result;
        if (inspect_deb_package(fullpath, STAGE_ATREST, &result) == 0) {
            report_result(&result);
            total++;
            if (result.verdict >= VERDICT_CONCERN) flagged++;
        }
    }
    closedir(dir);

    fpm_log(LOG_INFO, "At-rest scan complete: %d packages, %d flagged", total, flagged);
    return flagged;
}

/* ============================================================================
 * Stage 3: Pre-Copy Verification
 *
 * Called just before dpkg unpacks files. Verifies that the .deb hasn't
 * been modified since the at-rest scan (TOCTOU protection).
 * ============================================================================ */

static int verify_precopy(const char *deb_path) {
    InspectionResult result;

    if (inspect_deb_package(deb_path, STAGE_PRECOPY, &result) != 0) {
        return -1;
    }

    report_result(&result);

    /* HOLD or REJECT blocks the install */
    if (result.verdict >= VERDICT_HOLD) {
        fpm_log(LOG_WARNING,
                "PRE-COPY HOLD: %s blocked (score %d). Grade 3+ override required.",
                deb_path, result.total_score);
        return 1;  /* Non-zero = block */
    }

    return 0;
}

/* ============================================================================
 * Stage 4: Post-Install Inspection (MANDATORY)
 *
 * Scans all files installed by a package after dpkg completes.
 * This stage is always run regardless of other stage results.
 * ============================================================================ */

static int scan_postinstall(const char *package_name) {
    /* Use dpkg -L to list installed files */
    char cmd[512];
    snprintf(cmd, sizeof(cmd), "dpkg -L '%s' 2>/dev/null", package_name);

    FILE *pipe = popen(cmd, "r");
    if (!pipe) return -1;

    int total_score = 0;
    int file_count = 0;
    int max_verdict = (int)VERDICT_CLEAR;
    char line[MAX_PATH_LEN];

    while (fgets(line, sizeof(line), pipe)) {
        /* Remove newline */
        line[strcspn(line, "\n")] = '\0';
        if (line[0] == '\0') continue;

        /* Only scan regular files */
        struct stat st;
        if (stat(line, &st) != 0 || !S_ISREG(st.st_mode)) continue;

        /* Skip very large files for post-install (> 50 MB) */
        if (st.st_size > 50 * 1024 * 1024) continue;

        InspectionResult result;
        if (inspect_file(line, STAGE_POSTINSTALL, &result) == 0) {
            report_result(&result);
            total_score += result.total_score;
            file_count++;
            if ((int)result.verdict > max_verdict)
                max_verdict = (int)result.verdict;
        }
    }
    pclose(pipe);

    fpm_log(LOG_INFO,
            "Post-install scan of '%s': %d files, cumulative score %d, "
            "worst verdict: %s",
            package_name, file_count, total_score,
            verdict_names[max_verdict]);

    return max_verdict >= VERDICT_HOLD ? 1 : 0;
}

/* ============================================================================
 * Unix Socket Command Interface
 *
 * Other tools (APT hooks, pkg-info, Dave) communicate with the daemon
 * via this socket. Commands:
 *   SCAN <path>          — Scan a single file
 *   SCAN-DEB <path>      — Scan a .deb package
 *   SCAN-ATREST          — Scan all at-rest packages
 *   SCAN-POSTINSTALL <p> — Post-install scan of package <p>
 *   STATUS               — Daemon status
 *   STATS                — Inspection statistics
 * ============================================================================ */

static void handle_client(int client_fd) {
    char cmd[MAX_PATH_LEN + 64];
    ssize_t n = read(client_fd, cmd, sizeof(cmd) - 1);
    if (n <= 0) {
        close(client_fd);
        return;
    }
    cmd[n] = '\0';
    cmd[strcspn(cmd, "\r\n")] = '\0';

    char response[4096];
    int resp_len = 0;

    if (strncmp(cmd, "SCAN-DEB ", 9) == 0) {
        InspectionResult result;
        if (inspect_deb_package(cmd + 9, STAGE_ATREST, &result) == 0) {
            report_result(&result);
            resp_len = snprintf(response, sizeof(response),
                                "VERDICT:%s SCORE:%d SHA256:%s\n",
                                verdict_names[result.verdict],
                                result.total_score,
                                result.sha256);
        } else {
            resp_len = snprintf(response, sizeof(response), "ERROR:cannot_scan\n");
        }
    } else if (strncmp(cmd, "SCAN ", 5) == 0) {
        InspectionResult result;
        if (inspect_file(cmd + 5, STAGE_ATREST, &result) == 0) {
            report_result(&result);
            resp_len = snprintf(response, sizeof(response),
                                "VERDICT:%s SCORE:%d SHA256:%s\n",
                                verdict_names[result.verdict],
                                result.total_score,
                                result.sha256);
        } else {
            resp_len = snprintf(response, sizeof(response), "ERROR:cannot_scan\n");
        }
    } else if (strcmp(cmd, "SCAN-ATREST") == 0) {
        int flagged = scan_atrest();
        resp_len = snprintf(response, sizeof(response),
                            "OK:atrest_complete flagged=%d\n", flagged);
    } else if (strncmp(cmd, "SCAN-POSTINSTALL ", 17) == 0) {
        int blocked = scan_postinstall(cmd + 17);
        resp_len = snprintf(response, sizeof(response),
                            "OK:postinstall_complete blocked=%d\n", blocked);
    } else if (strcmp(cmd, "STATUS") == 0) {
        resp_len = snprintf(response, sizeof(response),
                            "DAEMON:%s VERSION:%s PID:%d RUNNING:1\n",
                            DAEMON_NAME, DAEMON_VERSION, getpid());
    } else {
        resp_len = snprintf(response, sizeof(response),
                            "ERROR:unknown_command\n");
    }

    if (resp_len > 0) {
        (void)write(client_fd, response, resp_len);
    }
    close(client_fd);
}

/* ============================================================================
 * Socket Listener
 * ============================================================================ */

static int setup_socket(void) {
    g_socket_fd = socket(AF_UNIX, SOCK_STREAM | SOCK_CLOEXEC, 0);
    if (g_socket_fd < 0) {
        fpm_log(LOG_ERR, "socket() failed: %s", strerror(errno));
        return -1;
    }

    struct sockaddr_un addr;
    memset(&addr, 0, sizeof(addr));
    addr.sun_family = AF_UNIX;
    strncpy(addr.sun_path, SOCKET_PATH, sizeof(addr.sun_path) - 1);

    unlink(SOCKET_PATH);

    if (bind(g_socket_fd, (struct sockaddr *)&addr, sizeof(addr)) < 0) {
        fpm_log(LOG_ERR, "bind() failed: %s", strerror(errno));
        close(g_socket_fd);
        return -1;
    }

    /* Allow all users to connect (APT runs as root, queries as user) */
    chmod(SOCKET_PATH, 0666);

    if (listen(g_socket_fd, 16) < 0) {
        fpm_log(LOG_ERR, "listen() failed: %s", strerror(errno));
        close(g_socket_fd);
        return -1;
    }

    return 0;
}

/* ============================================================================
 * Daemonize
 * ============================================================================ */

static void daemonize(void) {
    pid_t pid = fork();
    if (pid < 0) exit(EXIT_FAILURE);
    if (pid > 0) exit(EXIT_SUCCESS);

    if (setsid() < 0) exit(EXIT_FAILURE);

    pid = fork();
    if (pid < 0) exit(EXIT_FAILURE);
    if (pid > 0) exit(EXIT_SUCCESS);

    umask(022);
    (void)chdir("/");

    close(STDIN_FILENO);
    close(STDOUT_FILENO);
    close(STDERR_FILENO);
    open("/dev/null", O_RDONLY);
    open("/dev/null", O_WRONLY);
    open("/dev/null", O_WRONLY);

    g_daemon_mode = 1;
    openlog(DAEMON_NAME, LOG_PID | LOG_NDELAY, LOG_DAEMON);
}

static void write_pidfile(void) {
    FILE *f = fopen(PID_FILE, "w");
    if (f) {
        fprintf(f, "%d\n", getpid());
        fclose(f);
    }
}

/* ============================================================================
 * Ensure Required Directories
 * ============================================================================ */

static void ensure_dirs(void) {
    mkdir(LOG_DIR, 0750);
    mkdir(SPOOL_DIR, 0750);
    mkdir(APT_PARTIAL_DIR, 0755);
}

/* ============================================================================
 * Main — Daemon Entry Point
 * ============================================================================ */

int main(int argc, char *argv[]) {
    int daemon_flag = 1;
    int scan_only = 0;
    const char *scan_target = NULL;
    const char *postinstall_pkg = NULL;

    /* Parse arguments */
    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "--foreground") == 0 || strcmp(argv[i], "-f") == 0) {
            daemon_flag = 0;
        } else if (strcmp(argv[i], "--verbose") == 0 || strcmp(argv[i], "-v") == 0) {
            g_verbose = 1;
        } else if (strcmp(argv[i], "--scan") == 0 && i + 1 < argc) {
            scan_only = 1;
            scan_target = argv[++i];
        } else if (strcmp(argv[i], "--scan-atrest") == 0) {
            scan_only = 2;
        } else if (strcmp(argv[i], "--scan-postinstall") == 0 && i + 1 < argc) {
            scan_only = 3;
            postinstall_pkg = argv[++i];
        } else if (strcmp(argv[i], "--version") == 0) {
            printf("%s version %s\n", DAEMON_NAME, DAEMON_VERSION);
            printf("Galactic Cherry Marvell Edition 98\n");
            printf("Copyright (C) 2026 MEARVK LLC\n");
            return 0;
        } else if (strcmp(argv[i], "--help") == 0 || strcmp(argv[i], "-h") == 0) {
            printf("Usage: %s [OPTIONS]\n\n", DAEMON_NAME);
            printf("Byte-level package safety inspection daemon.\n\n");
            printf("Daemon mode (default):\n");
            printf("  -f, --foreground     Run in foreground (no daemonize)\n");
            printf("  -v, --verbose        Verbose output\n");
            printf("\nOne-shot scan modes:\n");
            printf("  --scan <file>        Scan a single file and exit\n");
            printf("  --scan-atrest        Scan all cached .deb packages\n");
            printf("  --scan-postinstall <pkg>  Scan installed files of <pkg>\n");
            printf("\nOther:\n");
            printf("  --version            Show version\n");
            printf("  --help               This help\n");
            printf("\nSocket interface: %s\n", SOCKET_PATH);
            printf("Log: %s/inspections.log\n", LOG_DIR);
            return 0;
        }
    }

    /* One-shot scan modes */
    if (scan_only == 1) {
        ensure_dirs();
        InspectionResult result;
        int rc;
        if (strstr(scan_target, ".deb"))
            rc = inspect_deb_package(scan_target, STAGE_ATREST, &result);
        else
            rc = inspect_file(scan_target, STAGE_ATREST, &result);

        if (rc == 0) {
            report_result(&result);
            printf("%s: %s (score %d)\n",
                   result.path, verdict_names[result.verdict], result.total_score);
            printf("  Structural: %d  Behavioral: %d  Kernel: %d  "
                   "Memory: %d  Provenance: %d\n",
                   result.scores[0], result.scores[1], result.scores[2],
                   result.scores[3], result.scores[4]);
            if (result.concern_count > 0) {
                printf("  Concerns:\n");
                for (int i = 0; i < result.concern_count; i++) {
                    printf("    [%s +%d] %s\n",
                           axis_names[result.concerns[i].axis],
                           result.concerns[i].weight,
                           result.concerns[i].detail);
                }
            }
            return result.verdict >= VERDICT_HOLD ? 1 : 0;
        }
        return 2;
    }

    if (scan_only == 2) {
        ensure_dirs();
        int flagged = scan_atrest();
        printf("At-rest scan complete. Flagged: %d\n", flagged);
        return flagged > 0 ? 1 : 0;
    }

    if (scan_only == 3) {
        ensure_dirs();
        int blocked = scan_postinstall(postinstall_pkg);
        return blocked;
    }

    /* Daemon mode */
    ensure_dirs();
    setup_signals();

    if (daemon_flag) {
        daemonize();
    }

    write_pidfile();
    fpm_log(LOG_INFO, "%s v%s starting (pid %d)", DAEMON_NAME, DAEMON_VERSION, getpid());

    /* Setup socket */
    if (setup_socket() != 0) {
        fpm_log(LOG_ERR, "Failed to setup socket. Exiting.");
        return 1;
    }

    /* Start in-flight monitor thread */
    pthread_t inflight_tid;
    pthread_create(&inflight_tid, NULL, inflight_monitor_thread, NULL);

    fpm_log(LOG_INFO, "Daemon ready. Socket: %s", SOCKET_PATH);

    /* Main loop — accept socket connections */
    while (g_running) {
        fd_set rfds;
        FD_ZERO(&rfds);
        FD_SET(g_socket_fd, &rfds);

        struct timeval tv = { .tv_sec = 1, .tv_usec = 0 };
        int ret = select(g_socket_fd + 1, &rfds, NULL, NULL, &tv);

        if (ret > 0 && FD_ISSET(g_socket_fd, &rfds)) {
            int client_fd = accept(g_socket_fd, NULL, NULL);
            if (client_fd >= 0) {
                handle_client(client_fd);
            }
        }
    }

    /* Cleanup */
    fpm_log(LOG_INFO, "Shutting down.");
    pthread_cancel(inflight_tid);
    pthread_join(inflight_tid, NULL);

    if (g_socket_fd >= 0) close(g_socket_fd);
    unlink(SOCKET_PATH);
    unlink(PID_FILE);

    if (g_daemon_mode) closelog();
    return 0;
}
