/* XMC OS registration helper. User-scoped; no privilege escalation. */
#include <stdio.h>
#include <stdlib.h>

static int run(const char *cmd) { return system(cmd); }

int xmc_register_asysma(const char *desktop_file, const char *program_name,
                        const char *icon_path, const char *executable_path) {
#if defined(_WIN32)
    char cmd[4096];
    if (!executable_path) return -1;
    snprintf(cmd, sizeof cmd,
        "reg.exe ADD \"HKCU\\Software\\Classes\\.asysma\" /ve /d \"XMC.ASYSMA\" /f >nul && "
        "reg.exe ADD \"HKCU\\Software\\Classes\\XMC.ASYSMA\" /ve /d \"ASYSMA Application\" /f >nul && "
        "reg.exe ADD \"HKCU\\Software\\Classes\\XMC.ASYSMA\\DefaultIcon\" /ve /d \"\\\"%s\\\",0\" /f >nul && "
        "reg.exe ADD \"HKCU\\Software\\Classes\\XMC.ASYSMA\\shell\\open\\command\" /ve /d \"\\\"%s\\\" \\\"%%1\\\"\" /f >nul",
        icon_path ? icon_path : executable_path, executable_path);
    (void)desktop_file; (void)program_name;
    return run(cmd) == 0 ? 0 : -1;
#elif defined(__APPLE__)
    const char *lsregister = "/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister";
    char cmd[4096];
    if (!executable_path) return -1;
    snprintf(cmd, sizeof cmd, "\"%s\" -f \"%s\" >/dev/null 2>&1", lsregister, executable_path);
    (void)desktop_file; (void)program_name; (void)icon_path;
    return run(cmd) == 0 ? 0 : -1;
#else
    char cmd[4096];
    if (!desktop_file) return -1;
    snprintf(cmd, sizeof cmd,
        "mkdir -p \"$HOME/.local/share/applications\" && "
        "cp \"%s\" \"$HOME/.local/share/applications/xmc-asysma.desktop\" && "
        "if command -v update-desktop-database >/dev/null 2>&1; then "
        "update-desktop-database \"$HOME/.local/share/applications\" >/dev/null 2>&1; fi",
        desktop_file);
    (void)program_name; (void)icon_path; (void)executable_path;
    return run(cmd) == 0 ? 0 : -1;
#endif
}
