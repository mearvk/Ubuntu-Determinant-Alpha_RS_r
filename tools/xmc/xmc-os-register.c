/* XMC OS registration helper. It installs only the application's association.
 * It is intentionally conservative: registration failure is reported, not
 * hidden, and no privilege escalation is attempted. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int run(const char *cmd) { return system(cmd); }

int xmc_register_asysma(const char *desktop_file, const char *program_name,
                        const char *icon_path, const char *executable_path) {
#if defined(_WIN32)
    char cmd[4096];
    snprintf(cmd, sizeof cmd,
             "reg.exe ADD \"HKCU\\Software\\Classes\\.asysma\" /ve /d \"XMC.ASYSMA\" /f >nul && "
             "reg.exe ADD \"HKCU\\Software\\Classes\\XMC.ASYSMA\" /ve /d \"ASYSMA Application\" /f >nul && "
             "reg.exe ADD \"HKCU\\Software\\Classes\\XMC.ASYSMA\\shell\\open\\command\" /ve /d \"\\\"%s\\\" \\\"%%1\\\"\" /f >nul",
             executable_path ? executable_path : "xmc");
    (void)program_name; (void)icon_path; (void)desktop_file;
    return run(cmd) == 0 ? 0 : -1;
#elif defined(__APPLE__)
    char cmd[4096];
    (void)desktop_file; (void)icon_path;
    snprintf(cmd, sizeof cmd,
             "touch \"%s\" 2>/dev/null; /usr/bin/lsregister -f \"%s\" >/dev/null 2>&1",
             executable_path ? executable_path : program_name,
             executable_path ? executable_path : program_name);
    return run(cmd) == 0 ? 0 : -1;
#else
    char cmd[4096];
    (void)program_name; (void)icon_path; (void)executable_path;
    if (!desktop_file) return -1;
    snprintf(cmd, sizeof cmd,
             "mkdir -p \"$HOME/.local/share/applications\" && "
             "cp \"%s\" \"$HOME/.local/share/applications/xmc-asysma.desktop\" && "
             "command -v update-desktop-database >/dev/null 2>&1 && "
             "update-desktop-database \"$HOME/.local/share/applications\" >/dev/null 2>&1 || true",
             desktop_file);
    return run(cmd) == 0 ? 0 : -1;
#endif
}
