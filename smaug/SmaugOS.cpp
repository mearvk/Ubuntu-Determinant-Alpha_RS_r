#include "smaug_os.h"

#include <string>

#if defined(__linux__)
static const SmaugOSProfile LINUX_PROFILE = {
    SMAUG_OS_LINUX,
    "Linux kernel",
    "processes, threads, signals",
    "users, groups, POSIX permissions, ACLs",
    "virtual and mounted filesystems",
    "ELF and platform-specific executables",
    "services and process supervisors",
    1, 1, 1
};
#elif defined(_WIN32)
static const SmaugOSProfile WINDOWS_PROFILE = {
    SMAUG_OS_WINDOWS,
    "Windows NT kernel",
    "processes, threads, handles",
    "security tokens, ACLs",
    "volumes, filesystems, drives",
    "PE/COFF executables",
    "Windows services",
    1, 1, 1
};
#elif defined(__APPLE__)
static const SmaugOSProfile MACOS_PROFILE = {
    SMAUG_OS_MACOS,
    "XNU kernel",
    "processes, threads, Mach/BSD facilities",
    "POSIX permissions, ACLs, entitlements",
    "mounted filesystems and application bundles",
    "Mach-O executables",
    "launchd services",
    1, 1, 1
};
#endif

extern "C" int smaug_detect_os(SmaugOSProfile *profile) {
    if (!profile) return 0;

#if defined(__linux__)
    *profile = LINUX_PROFILE;
#elif defined(_WIN32)
    *profile = WINDOWS_PROFILE;
#elif defined(__APPLE__)
    *profile = MACOS_PROFILE;
#else
    *profile = {SMAUG_OS_UNKNOWN, "unknown", "unknown", "unknown", "unknown", "unknown", "unknown", 0, 0, 0};
#endif
    return profile->family != SMAUG_OS_UNKNOWN;
}

extern "C" const char *smaug_os_family_name(SmaugOSFamily family) {
    switch (family) {
        case SMAUG_OS_LINUX: return "Linux";
        case SMAUG_OS_WINDOWS: return "Windows";
        case SMAUG_OS_MACOS: return "macOS";
        default: return "Unknown";
    }
}
