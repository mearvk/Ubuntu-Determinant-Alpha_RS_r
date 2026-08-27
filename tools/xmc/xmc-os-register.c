/* XMC OS registration helper. User-scoped; no privilege escalation. */
/* Copyright (C) 2026 MEARVK LLC
 * SPDX-License-Identifier: GPL-2.0 WITH Classpath-exception-2.0 */
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

#define XMC_PATH_MAX 4096

static int run_argv(char *const argv[]) {
    pid_t pid = fork();
    if (pid < 0) return -1;
    if (pid == 0) { execvp(argv[0], argv); _exit(127); }
    int status = 0;
    if (waitpid(pid, &status, 0) < 0) return -1;
    return WIFEXITED(status) && WEXITSTATUS(status) == 0 ? 0 : -1;
}

static int join_path(char *out, size_t cap, const char *dir, const char *name) {
    if (!out || !dir || !name || cap == 0) return -1;
    size_t a = strlen(dir), b = strlen(name);
    size_t sep = (a && dir[a - 1] != '/') ? 1u : 0u;
    if (a > cap - 1 || b > cap - 1 - a - sep) return -1;
    memcpy(out, dir, a);
    if (sep) out[a++] = '/';
    memcpy(out + a, name, b + 1);
    return 0;
}

static int mkdir_p(const char *path) {
    char tmp[XMC_PATH_MAX];
    if (!path || snprintf(tmp, sizeof tmp, "%s", path) >= (int)sizeof tmp) return -1;
    size_t n = strlen(tmp);
    if (n == 0) return -1;
    for (size_t i = 1; i < n; ++i) {
        if (tmp[i] == '/') {
            tmp[i] = '\0';
            if (mkdir(tmp, 0755) != 0 && errno != EEXIST) return -1;
            tmp[i] = '/';
        }
    }
    if (mkdir(tmp, 0755) != 0 && errno != EEXIST) return -1;
    return 0;
}

static int copy_file(const char *src, const char *dst, mode_t mode) {
    int in = open(src, O_RDONLY | O_CLOEXEC);
    if (in < 0) return -1;
    int out = open(dst, O_WRONLY | O_CREAT | O_TRUNC | O_CLOEXEC, mode);
    if (out < 0) { close(in); return -1; }
    char buf[16384];
    int rc = 0;
    for (;;) {
        ssize_t r = read(in, buf, sizeof buf);
        if (r < 0) { if (errno == EINTR) continue; rc = -1; break; }
        if (r == 0) break;
        ssize_t off = 0;
        while (off < r) {
            ssize_t w = write(out, buf + off, (size_t)(r - off));
            if (w < 0) { if (errno == EINTR) continue; rc = -1; break; }
            off += w;
        }
        if (rc != 0) break;
    }
    if (close(out) != 0) rc = -1;
    close(in);
    return rc;
}

static int write_mime_xml(const char *path) {
    FILE *m = fopen(path, "w");
    if (!m) return -1;
    fputs("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
          "<mime-info xmlns=\"http://www.freedesktop.org/standards/shared-mime-info\">\n"
          "  <mime-type type=\"application/x-asysma\">\n"
          "    <comment>ASYSMA Application Package</comment>\n"
          "    <icon name=\"xmc-asysma\"/>\n"
          "    <glob pattern=\"*.asysma\" weight=\"80\"/>\n"
          "    <magic priority=\"80\"><match type=\"string\" offset=\"0\" value=\"ASYSMA\\x00\\x01\"/></magic>\n"
          "  </mime-type>\n</mime-info>\n", m);
    return fclose(m) == 0 ? 0 : -1;
}

int xmc_register_asysma(const char *desktop_file, const char *program_name,
                        const char *icon_path, const char *executable_path) {
#if defined(_WIN32)
    if (!executable_path) return -1;
    char icon_arg[1024], command_arg[2048];
    if (snprintf(icon_arg, sizeof icon_arg, "%s,0", icon_path ? icon_path : executable_path) >= (int)sizeof icon_arg ||
        snprintf(command_arg, sizeof command_arg, "\"%s\" \"%%1\"", executable_path) >= (int)sizeof command_arg) return -1;
    char *r1[] = { (char *)"reg.exe", (char *)"ADD", (char *)"HKCU\\Software\\Classes\\.asysma", (char *)"/ve", (char *)"/d", (char *)"XMC.ASYSMA", (char *)"/f", NULL };
    char *r2[] = { (char *)"reg.exe", (char *)"ADD", (char *)"HKCU\\Software\\Classes\\XMC.ASYSMA", (char *)"/ve", (char *)"/d", (char *)"ASYSMA Application", (char *)"/f", NULL };
    char *r3[] = { (char *)"reg.exe", (char *)"ADD", (char *)"HKCU\\Software\\Classes\\XMC.ASYSMA\\DefaultIcon", (char *)"/ve", (char *)"/d", icon_arg, (char *)"/f", NULL };
    char *r4[] = { (char *)"reg.exe", (char *)"ADD", (char *)"HKCU\\Software\\Classes\\XMC.ASYSMA\\shell\\open\\command", (char *)"/ve", (char *)"/d", command_arg, (char *)"/f", NULL };
    (void)desktop_file; (void)program_name;
    return run_argv(r1) || run_argv(r2) || run_argv(r3) || run_argv(r4) ? -1 : 0;
#elif defined(__APPLE__)
    const char *lsregister = "/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister";
    if (!executable_path) return -1;
    char *args[] = { (char *)lsregister, (char *)"-f", (char *)executable_path, NULL };
    (void)desktop_file; (void)program_name; (void)icon_path;
    return run_argv(args);
#else
    char mime_dir[XMC_PATH_MAX], mime_file[XMC_PATH_MAX];
    char icon_dir[XMC_PATH_MAX], icon_file[XMC_PATH_MAX];
    char mime_icon_dir[XMC_PATH_MAX], mime_icon_file[XMC_PATH_MAX];
    char desktop_dir[XMC_PATH_MAX], installed_desktop[XMC_PATH_MAX];
    const char *home = getenv("HOME");
    if (!home || !desktop_file || !program_name || !icon_path) return -1;
    if (join_path(mime_dir, sizeof mime_dir, home, ".local/share/mime/packages") ||
        join_path(mime_file, sizeof mime_file, mime_dir, "xmc-asysma.xml") ||
        join_path(icon_dir, sizeof icon_dir, home, ".local/share/icons/hicolor/scalable/apps") ||
        join_path(icon_file, sizeof icon_file, icon_dir, "xmc-asysma.svg") ||
        join_path(mime_icon_dir, sizeof mime_icon_dir, home, ".local/share/icons/hicolor/scalable/mimetypes") ||
        join_path(mime_icon_file, sizeof mime_icon_file, mime_icon_dir, "xmc-asysma.svg") ||
        join_path(desktop_dir, sizeof desktop_dir, home, ".local/share/applications") ||
        join_path(installed_desktop, sizeof installed_desktop, desktop_dir, "xmc-asysma.desktop")) return -1;

    if (mkdir_p(mime_dir) || mkdir_p(icon_dir) || mkdir_p(mime_icon_dir) || mkdir_p(desktop_dir)) return -1;
    if (write_mime_xml(mime_file) || copy_file(icon_path, icon_file, 0644) ||
        copy_file(icon_path, mime_icon_file, 0644) || copy_file(desktop_file, installed_desktop, 0644)) return -1;

    char mime_root[XMC_PATH_MAX];
    if (join_path(mime_root, sizeof mime_root, home, ".local/share/mime")) return -1;
    char *mime_db[] = { (char *)"update-mime-database", mime_root, NULL };
    char *desktop_db[] = { (char *)"update-desktop-database", desktop_dir, NULL };
    char *xdg[] = { (char *)"xdg-mime", (char *)"default", (char *)"xmc-asysma.desktop", (char *)"application/x-asysma", NULL };
    char *gio[] = { (char *)"gio", (char *)"mime", (char *)"application/x-asysma", (char *)"xmc-asysma.desktop", NULL };
    (void)run_argv(mime_db);
    (void)run_argv(desktop_db);
    (void)run_argv(xdg);
    (void)run_argv(gio);
    return 0;
#endif
}
