/* XMC OS registration helper. User-scoped; no privilege escalation. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>

#define XMC_PATH_MAX 4096

static int run(const char *cmd) { return system(cmd); }

static int join_path(char *out, size_t cap, const char *dir, const char *name) {
    size_t a, b;
    if (!out || !dir || !name) return -1;
    a = strlen(dir); b = strlen(name);
    if (a > cap - 1 || b > cap - 1 - a - (a ? 1 : 0)) return -1;
    memcpy(out, dir, a);
    if (a && dir[a - 1] != '/') out[a++] = '/';
    memcpy(out + a, name, b + 1);
    return 0;
}

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
    char mime_dir[XMC_PATH_MAX], mime_file[XMC_PATH_MAX];
    char icon_dir[XMC_PATH_MAX], icon_file[XMC_PATH_MAX];
    char mime_icon_dir[XMC_PATH_MAX], mime_icon_file[XMC_PATH_MAX];
    char desktop_dir[XMC_PATH_MAX], installed_desktop[XMC_PATH_MAX], cmd[8192];
    const char *home = getenv("HOME");
    if (!home || !desktop_file || !program_name || !icon_path) return -1;
    if (join_path(mime_dir, sizeof mime_dir, home, ".local/share/mime/packages") != 0 ||
        join_path(mime_file, sizeof mime_file, mime_dir, "xmc-asysma.xml") != 0 ||
        join_path(icon_dir, sizeof icon_dir, home, ".local/share/icons/hicolor/scalable/apps") != 0 ||
        join_path(icon_file, sizeof icon_file, icon_dir, "xmc-asysma.svg") != 0 ||
        join_path(mime_icon_dir, sizeof mime_icon_dir, home, ".local/share/icons/hicolor/scalable/mimetypes") != 0 ||
        join_path(mime_icon_file, sizeof mime_icon_file, mime_icon_dir, "xmc-asysma.svg") != 0 ||
        join_path(desktop_dir, sizeof desktop_dir, home, ".local/share/applications") != 0 ||
        join_path(installed_desktop, sizeof installed_desktop, desktop_dir, "xmc-asysma.desktop") != 0) return -1;

    if (snprintf(cmd, sizeof cmd, "mkdir -p '%s' '%s' '%s' '%s'", mime_dir, icon_dir, mime_icon_dir, desktop_dir) >= (int)sizeof cmd || run(cmd) != 0) return -1;

    FILE *m = fopen(mime_file, "w");
    if (!m) return -1;
    fputs("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
          "<mime-info xmlns=\"http://www.freedesktop.org/standards/shared-mime-info\">\n"
          "  <mime-type type=\"application/x-asysma\">\n"
          "    <comment>ASYSMA Application Package</comment>\n"
          "    <icon name=\"xmc-asysma\"/>\n"
          "    <glob pattern=\"*.asysma\" weight=\"80\"/>\n"
          "    <magic priority=\"80\"><match type=\"string\" offset=\"0\" value=\"ASYSMA\\x00\\x01\"/></magic>\n"
          "  </mime-type>\n</mime-info>\n", m);
    fclose(m);

    if (snprintf(cmd, sizeof cmd, "cp '%s' '%s' && cp '%s' '%s'", icon_path, icon_file, icon_path, mime_icon_file) >= (int)sizeof cmd || run(cmd) != 0) return -1;
    if (snprintf(cmd, sizeof cmd, "cp '%s' '%s'", desktop_file, installed_desktop) >= (int)sizeof cmd || run(cmd) != 0) return -1;
    if (snprintf(cmd, sizeof cmd,
        "if command -v update-mime-database >/dev/null 2>&1; then update-mime-database '%s/.local/share/mime' >/dev/null 2>&1; fi; "
        "if command -v update-desktop-database >/dev/null 2>&1; then update-desktop-database '%s' >/dev/null 2>&1; fi; "
        "if command -v xdg-mime >/dev/null 2>&1; then xdg-mime default xmc-asysma.desktop application/x-asysma >/dev/null 2>&1; fi; "
        "if command -v gtk-update-icon-cache >/dev/null 2>&1; then gtk-update-icon-cache -f -t '%s/.local/share/icons/hicolor' >/dev/null 2>&1 || true; fi; "
        "if command -v gio >/dev/null 2>&1; then gio mime application/x-asysma xmc-asysma.desktop >/dev/null 2>&1 || true; fi",
        home, desktop_dir, home) >= (int)sizeof cmd) return -1;
    (void)program_name; (void)executable_path;
    return run(cmd) == 0 ? 0 : -1;
#endif
}
