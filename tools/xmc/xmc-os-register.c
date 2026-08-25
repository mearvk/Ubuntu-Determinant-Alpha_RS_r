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
    char mime_dir[4096], mime_file[4096], desktop_dir[4096], installed_desktop[4096], cmd[8192];
    const char *home = getenv("HOME");
    if (!home || !desktop_file || !program_name) return -1;
    snprintf(mime_dir, sizeof mime_dir, "%s/.local/share/mime/packages", home);
    snprintf(mime_file, sizeof mime_file, "%s/xmc-asysma.xml", mime_dir);
    snprintf(desktop_dir, sizeof desktop_dir, "%s/.local/share/applications", home);
    snprintf(installed_desktop, sizeof installed_desktop, "%s/xmc-asysma.desktop", desktop_dir);
    if (snprintf(cmd, sizeof cmd, "mkdir -p '%s' '%s'", mime_dir, desktop_dir) >= (int)sizeof cmd || run(cmd) != 0) return -1;
    FILE *m = fopen(mime_file, "w");
    if (!m) return -1;
    fprintf(m, "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<mime-info xmlns=\"http://www.freedesktop.org/standards/shared-mime-info\"><mime-type type=\"application/x-asysma\"><comment>ASYSMA application</comment><glob pattern=\"*.asysma\"/><icon name=\"xmc-asysma\"/></mime-type></mime-info>\n");
    fclose(m);
    if (snprintf(cmd, sizeof cmd, "cp '%s' '%s'", desktop_file, installed_desktop) >= (int)sizeof cmd || run(cmd) != 0) return -1;
    if (snprintf(cmd, sizeof cmd, "if command -v update-mime-database >/dev/null 2>&1; then update-mime-database '%s/.local/share/mime' >/dev/null 2>&1; fi; if command -v update-desktop-database >/dev/null 2>&1; then update-desktop-database '%s' >/dev/null 2>&1; fi; if command -v xdg-mime >/dev/null 2>&1; then xdg-mime default xmc-asysma.desktop application/x-asysma >/dev/null 2>&1; fi", home, desktop_dir) >= (int)sizeof cmd) return -1;
    (void)icon_path; (void)executable_path;
    return run(cmd) == 0 ? 0 : -1;
#endif
}
