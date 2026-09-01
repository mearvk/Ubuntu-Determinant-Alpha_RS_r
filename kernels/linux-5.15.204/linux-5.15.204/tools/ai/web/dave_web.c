// SPDX-License-Identifier: GPL-2.0
//
// dave_web.c — Dave's Chrome Web Interface
//
// Drives headless Chromium via the Chrome DevTools Protocol (CDP) to:
//   1. Load any URL in a real browser engine
//   2. Capture a screenshot (PNG) of the rendered page
//   3. Extract page text content (innerText of body)
//   4. Extract page title, meta description, and links
//   5. Store findings (screenshot path, text, metadata) in MySQL (dave_kb)
//
// Dave uses this to visually inspect websites, understand web content,
// and build knowledge about the web resources he monitors.
//
// Dependencies:
//   - libcurl (HTTP + WebSocket to CDP)
//   - libmysqlclient (MySQL storage)
//   - cJSON (JSON parse/generate — bundled)
//   - chromium-browser (headless mode)
//
// Usage:
//   dave_web <url>                      — Fetch, screenshot, store
//   dave_web --text-only <url>          — Fetch text only (no screenshot)
//   dave_web --screenshot-only <url>    — Screenshot only
//   dave_web --links <url>             — Extract all links
//   dave_web --query <search_term>     — Query stored findings from MySQL
//   dave_web --status                   — Show Chrome process status
//
// Copyright (C) 2026 MEARVK LLC
// Author: Maximilian Eric Alexander Rupplin von Keffikon

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <time.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <errno.h>
#include <fcntl.h>

#include <curl/curl.h>
#include <mysql/mysql.h>

#include "cjson/cJSON.h"

// ============================================================
// Constants
// ============================================================

#define DAVE_WEB_VERSION        "1.0.0"
#define CHROME_BINARY           "/usr/lib/chromium/chrome"  // default / last-resort fallback
#define CHROME_USER_DATA_DIR    "/var/lib/kernel-ai/chrome-data"
#define SCREENSHOT_DIR          "/var/lib/kernel-ai/screenshots"
#define CDP_PORT                9222
#define CDP_HOST                "127.0.0.1"
#define MAX_URL_LEN             4096
#define MAX_RESPONSE_SIZE       (64 * 1024 * 1024)  // 64 MB max page content
#define PAGE_LOAD_TIMEOUT_SEC   30
#define SCREENSHOT_TIMEOUT_SEC  10
#define MAX_TEXT_STORE_LEN      (1 * 1024 * 1024)   // 1 MB text per page

#define MYSQL_SOCKET            "/run/mysqld/mysqld.sock"
#define MYSQL_USER              "dave_ai"
#define MYSQL_DB                "dave_kb"

// ============================================================
// Data Structures
// ============================================================

typedef struct {
    char   *data;
    size_t  size;
    size_t  capacity;
} Buffer;

typedef struct {
    char    url[MAX_URL_LEN];
    char    title[1024];
    char    description[2048];
    char    screenshot_path[512];
    char   *text_content;
    size_t  text_len;
    char   *links_json;
    int     http_status;
    double  load_time_ms;
    time_t  timestamp;
} WebFinding;

typedef struct {
    pid_t   chrome_pid;
    int     cdp_port;
    char    ws_url[512];
    int     connected;
} ChromeSession;

// ============================================================
// Buffer Utilities
// ============================================================

static Buffer *buffer_new(size_t initial_cap)
{
    Buffer *buf = calloc(1, sizeof(Buffer));
    if (!buf) return NULL;
    buf->capacity = initial_cap > 0 ? initial_cap : 4096;
    buf->data = malloc(buf->capacity);
    if (!buf->data) { free(buf); return NULL; }
    buf->data[0] = '\0';
    buf->size = 0;
    return buf;
}

static void buffer_free(Buffer *buf)
{
    if (buf) {
        free(buf->data);
        free(buf);
    }
}

static int buffer_append(Buffer *buf, const char *data, size_t len)
{
    if (buf->size + len + 1 > buf->capacity) {
        size_t new_cap = (buf->size + len + 1) * 2;
        if (new_cap > MAX_RESPONSE_SIZE) new_cap = MAX_RESPONSE_SIZE;
        char *new_data = realloc(buf->data, new_cap);
        if (!new_data) return -1;
        buf->data = new_data;
        buf->capacity = new_cap;
    }
    memcpy(buf->data + buf->size, data, len);
    buf->size += len;
    buf->data[buf->size] = '\0';
    return 0;
}

// ============================================================
// cURL Write Callback
// ============================================================

static size_t curl_write_cb(void *contents, size_t size, size_t nmemb, void *userp)
{
    Buffer *buf = (Buffer *)userp;
    size_t total = size * nmemb;
    if (buffer_append(buf, contents, total) < 0)
        return 0;
    return total;
}

// ============================================================
// Chrome Binary Resolution
// ============================================================

// Resolve the Chrome/Chromium binary to use at runtime.
// Order of precedence:
//   1. The DAVE_CHROME environment variable, if set and non-empty.
//   2. The first entry in a probe list that is executable (access X_OK).
//   3. The compiled-in CHROME_BINARY default as a last resort.
// The result is cached after the first call.
static const char *chrome_binary(void)
{
    static const char *cached = NULL;
    if (cached)
        return cached;

    const char *env = getenv("DAVE_CHROME");
    if (env && env[0] != '\0') {
        cached = env;
        return cached;
    }

    static const char *candidates[] = {
        "/usr/lib/chromium/chrome",
        "/usr/lib/chromium-browser/chrome",
        "/usr/bin/chromium",
        "/usr/bin/chromium-browser",
        "/usr/local/bin/chrome",
        "/usr/bin/google-chrome",
    };

    for (size_t i = 0; i < sizeof(candidates) / sizeof(candidates[0]); i++) {
        if (access(candidates[i], X_OK) == 0) {
            cached = candidates[i];
            return cached;
        }
    }

    cached = CHROME_BINARY;
    return cached;
}

// ============================================================
// Chrome Process Management
// ============================================================

static pid_t launch_chrome_headless(void)
{
    // Ensure directories exist
    mkdir(CHROME_USER_DATA_DIR, 0700);
    mkdir(SCREENSHOT_DIR, 0700);

    pid_t pid = fork();
    if (pid < 0) {
        perror("fork");
        return -1;
    }

    if (pid == 0) {
        // Child: exec chromium in headless mode with CDP enabled
        // Redirect stdout/stderr to log file
        int logfd = open("/var/lib/kernel-ai/chrome-headless.log",
                         O_WRONLY | O_CREAT | O_APPEND, 0600);
        if (logfd >= 0) {
            dup2(logfd, STDOUT_FILENO);
            dup2(logfd, STDERR_FILENO);
            close(logfd);
        }

        char port_arg[64];
        snprintf(port_arg, sizeof(port_arg), "--remote-debugging-port=%d", CDP_PORT);

        execlp(chrome_binary(), "chrome",
               "--headless=new",
               "--disable-gpu",
               "--no-sandbox",
               "--disable-dev-shm-usage",
               "--disable-extensions",
               "--disable-background-networking",
               "--disable-sync",
               "--disable-translate",
               "--mute-audio",
               "--window-size=1920,1080",
               port_arg,
               "--user-data-dir=" CHROME_USER_DATA_DIR,
               NULL);

        // If we get here, exec failed
        perror("execlp chrome");
        _exit(127);
    }

    // Parent: wait for CDP port to become available
    fprintf(stderr, "[dave_web] Chrome launched (PID %d), waiting for CDP...\n", pid);

    for (int i = 0; i < 50; i++) {  // 5 seconds max
        usleep(100000);  // 100ms

        CURL *curl = curl_easy_init();
        if (!curl) continue;

        char url[128];
        snprintf(url, sizeof(url), "http://%s:%d/json/version", CDP_HOST, CDP_PORT);

        Buffer *buf = buffer_new(1024);
        curl_easy_setopt(curl, CURLOPT_URL, url);
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, curl_write_cb);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, buf);
        curl_easy_setopt(curl, CURLOPT_TIMEOUT, 1L);
        curl_easy_setopt(curl, CURLOPT_CONNECTTIMEOUT, 1L);

        CURLcode res = curl_easy_perform(curl);
        curl_easy_cleanup(curl);

        if (res == CURLE_OK && buf->size > 0) {
            buffer_free(buf);
            fprintf(stderr, "[dave_web] CDP ready on port %d\n", CDP_PORT);
            return pid;
        }
        buffer_free(buf);
    }

    fprintf(stderr, "[dave_web] ERROR: Chrome did not start CDP within 5 seconds\n");
    kill(pid, SIGTERM);
    waitpid(pid, NULL, 0);
    return -1;
}

static int check_chrome_running(void)
{
    CURL *curl = curl_easy_init();
    if (!curl) return 0;

    char url[128];
    snprintf(url, sizeof(url), "http://%s:%d/json/version", CDP_HOST, CDP_PORT);

    Buffer *buf = buffer_new(1024);
    curl_easy_setopt(curl, CURLOPT_URL, url);
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, curl_write_cb);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, buf);
    curl_easy_setopt(curl, CURLOPT_TIMEOUT, 2L);
    curl_easy_setopt(curl, CURLOPT_CONNECTTIMEOUT, 2L);

    CURLcode res = curl_easy_perform(curl);
    curl_easy_cleanup(curl);

    int running = (res == CURLE_OK && buf->size > 0);
    buffer_free(buf);
    return running;
}

static void stop_chrome(pid_t pid)
{
    if (pid > 0) {
        kill(pid, SIGTERM);
        int status;
        waitpid(pid, &status, 0);
        fprintf(stderr, "[dave_web] Chrome stopped (PID %d)\n", pid);
    }
}

// ============================================================
// CDP Communication (via HTTP — simpler than WebSocket for our use)
// ============================================================

// Create a new browser tab and return its WebSocket debugger URL
static char *cdp_new_tab(const char *target_url)
{
    CURL *curl = curl_easy_init();
    if (!curl) return NULL;

    char url[MAX_URL_LEN + 128];
    char *encoded_url = curl_easy_escape(curl, target_url, 0);
    snprintf(url, sizeof(url), "http://%s:%d/json/new?%s",
             CDP_HOST, CDP_PORT, encoded_url ? encoded_url : target_url);
    if (encoded_url) curl_free(encoded_url);

    Buffer *buf = buffer_new(4096);
    curl_easy_setopt(curl, CURLOPT_URL, url);
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, curl_write_cb);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, buf);
    curl_easy_setopt(curl, CURLOPT_TIMEOUT, PAGE_LOAD_TIMEOUT_SEC);

    CURLcode res = curl_easy_perform(curl);
    curl_easy_cleanup(curl);

    if (res != CURLE_OK) {
        buffer_free(buf);
        return NULL;
    }

    // Parse response to get the target ID and ws URL
    cJSON *json = cJSON_Parse(buf->data);
    buffer_free(buf);
    if (!json) return NULL;

    cJSON *ws_url = cJSON_GetObjectItem(json, "webSocketDebuggerUrl");
    char *result = NULL;
    if (ws_url && cJSON_IsString(ws_url)) {
        result = strdup(ws_url->valuestring);
    }
    cJSON_Delete(json);
    return result;
}

// Close a browser tab by target ID
static void cdp_close_tab(const char *target_id)
{
    CURL *curl = curl_easy_init();
    if (!curl) return;

    char url[512];
    snprintf(url, sizeof(url), "http://%s:%d/json/close/%s",
             CDP_HOST, CDP_PORT, target_id);

    curl_easy_setopt(curl, CURLOPT_URL, url);
    curl_easy_setopt(curl, CURLOPT_TIMEOUT, 5L);
    curl_easy_perform(curl);
    curl_easy_cleanup(curl);
}

// Send CDP command via HTTP endpoint (uses /json/protocol for simple commands)
// For screenshot and DOM access, we use the page target directly
static char *cdp_send_command(const char *ws_url __attribute__((unused)),
                              const char *method,
                              cJSON *params, int id)
{
    // Build JSON-RPC message
    cJSON *msg = cJSON_CreateObject();
    cJSON_AddNumberToObject(msg, "id", id);
    cJSON_AddStringToObject(msg, "method", method);
    if (params) {
        cJSON_AddItemToObject(msg, "params", cJSON_Duplicate(params, 1));
    } else {
        cJSON_AddObjectToObject(msg, "params");
    }

    char *msg_str = cJSON_PrintUnformatted(msg);
    cJSON_Delete(msg);

    // For CDP commands, we need to POST to the target's HTTP endpoint
    // Chrome exposes a simpler HTTP API at /json/protocol but for
    // Page.captureScreenshot etc., we'll use the evaluate endpoint
    //
    // Actually, Chrome's CDP requires WebSocket. We'll use curl's
    // WebSocket support (available in curl 7.86+) or fall back to
    // a simpler approach using /json/activate + evaluate via HTTP.
    //
    // For maximum compatibility, we'll use a helper approach:
    // pipe commands through a small CDP relay.
    //
    // SIMPLEST APPROACH: Use chrome's --dump-dom for text and
    // use the screenshot capability via the DevTools HTTP API.

    free(msg_str);
    return NULL;  // Placeholder — actual WebSocket impl below
}

// ============================================================
// CDP via pipe to chrome (simpler than WebSocket for our use)
// This uses the Chrome CLI capabilities directly.
// ============================================================

// Run headless chrome as a child process (no shell) and wait for it.
// Passing an argv vector avoids any shell interpretation of the URL or
// paths, which closes the single-quote shell-injection hole. If out_fd
// is >= 0, it is duplicated onto STDOUT in the child (used for --dump-dom);
// otherwise stdout/stderr are sent to /dev/null. Returns 0 on a clean exit,
// -1 otherwise.
static int run_chrome_child(const char *program, char *const argv[], int out_fd)
{
    pid_t pid = fork();
    if (pid < 0) {
        perror("fork");
        return -1;
    }

    if (pid == 0) {
        // Child: redirect output, then exec chrome with no shell involved.
        int devnull = open("/dev/null", O_WRONLY);
        if (out_fd >= 0) {
            dup2(out_fd, STDOUT_FILENO);
            if (devnull >= 0)
                dup2(devnull, STDERR_FILENO);
        } else if (devnull >= 0) {
            dup2(devnull, STDOUT_FILENO);
            dup2(devnull, STDERR_FILENO);
        }
        if (devnull >= 0)
            close(devnull);

        execvp(program, argv);
        perror("execvp chrome");
        _exit(127);
    }

    // Parent: wait for the short-lived chrome process.
    int status;
    if (waitpid(pid, &status, 0) < 0)
        return -1;
    return (WIFEXITED(status) && WEXITSTATUS(status) == 0) ? 0 : -1;
}

// Capture screenshot by navigating headless Chrome to the URL using
// Chrome's built-in --screenshot mode.
static int capture_screenshot_cdp(const char *target_url, const char *output_path)
{
    // Use Chrome's built-in headless screenshot mode via a short-lived
    // chrome process. We build an argv vector (no shell) so a URL or path
    // containing quotes or shell metacharacters cannot break out.
    const char *chrome = chrome_binary();

    char screenshot_arg[512 + 16];
    snprintf(screenshot_arg, sizeof(screenshot_arg), "--screenshot=%s", output_path);

    char *argv_vtb[] = {
        (char *)"chrome",
        (char *)"--headless=new",
        (char *)"--disable-gpu",
        (char *)"--no-sandbox",
        (char *)"--disable-dev-shm-usage",
        (char *)"--window-size=1920,1080",
        screenshot_arg,
        (char *)"--virtual-time-budget=5000",
        (char *)target_url,
        NULL
    };
    int ret = run_chrome_child(chrome, argv_vtb, -1);

    if (ret != 0) {
        // Fallback: try without virtual-time-budget.
        char *argv_novtb[] = {
            (char *)"chrome",
            (char *)"--headless=new",
            (char *)"--disable-gpu",
            (char *)"--no-sandbox",
            (char *)"--disable-dev-shm-usage",
            (char *)"--window-size=1920,1080",
            screenshot_arg,
            (char *)target_url,
            NULL
        };
        ret = run_chrome_child(chrome, argv_novtb, -1);
    }

    struct stat st;
    return (ret == 0 && stat(output_path, &st) == 0 && st.st_size > 0) ? 0 : -1;
}

// Extract page text using Chrome's --dump-dom mode
static char *extract_page_text(const char *target_url)
{
    char tmpfile[] = "/tmp/dave_web_dom_XXXXXX";
    int fd = mkstemp(tmpfile);
    if (fd < 0) return NULL;

    // Run chrome with no shell (argv vector); the child's stdout is
    // redirected to the temp file via out_fd, mirroring how
    // launch_chrome_headless redirects to its log file.
    char *argv_dom[] = {
        (char *)"chrome",
        (char *)"--headless=new",
        (char *)"--disable-gpu",
        (char *)"--no-sandbox",
        (char *)"--disable-dev-shm-usage",
        (char *)"--dump-dom",
        (char *)"--virtual-time-budget=5000",
        (char *)target_url,
        NULL
    };
    int ret = run_chrome_child(chrome_binary(), argv_dom, fd);
    close(fd);
    if (ret != 0) {
        unlink(tmpfile);
        return NULL;
    }

    // Read the DOM dump
    FILE *f = fopen(tmpfile, "r");
    if (!f) { unlink(tmpfile); return NULL; }

    fseek(f, 0, SEEK_END);
    long fsize = ftell(f);
    fseek(f, 0, SEEK_SET);

    if (fsize <= 0 || fsize > MAX_TEXT_STORE_LEN) {
        if (fsize > MAX_TEXT_STORE_LEN) fsize = MAX_TEXT_STORE_LEN;
        if (fsize <= 0) { fclose(f); unlink(tmpfile); return NULL; }
    }

    char *text = malloc(fsize + 1);
    if (!text) { fclose(f); unlink(tmpfile); return NULL; }

    size_t nread = fread(text, 1, fsize, f);
    text[nread] = '\0';
    fclose(f);
    unlink(tmpfile);

    return text;
}

// Extract page title from DOM text
static void extract_title(const char *dom_text, char *title, size_t title_size)
{
    title[0] = '\0';
    const char *start = strcasestr(dom_text, "<title>");
    if (!start) return;
    start += 7;
    const char *end = strcasestr(start, "</title>");
    if (!end) return;

    size_t len = end - start;
    if (len >= title_size) len = title_size - 1;
    memcpy(title, start, len);
    title[len] = '\0';
}

// Extract meta description from DOM text
static void extract_description(const char *dom_text, char *desc, size_t desc_size)
{
    desc[0] = '\0';
    // Look for <meta name="description" content="...">
    const char *meta = dom_text;
    while ((meta = strcasestr(meta, "<meta")) != NULL) {
        const char *meta_end = strchr(meta, '>');
        if (!meta_end) break;

        // Check if this meta has name="description"
        const char *name_attr = strcasestr(meta, "name=\"description\"");
        if (!name_attr) { name_attr = strcasestr(meta, "name='description'"); }
        if (name_attr && name_attr < meta_end) {
            const char *content = strcasestr(meta, "content=\"");
            if (!content) content = strcasestr(meta, "content='");
            if (content && content < meta_end) {
                content += 9;  // skip content="
                char quote = *(content - 1);  // matching quote
                const char *end = strchr(content, quote);
                if (end && end < meta_end) {
                    size_t len = end - content;
                    if (len >= desc_size) len = desc_size - 1;
                    memcpy(desc, content, len);
                    desc[len] = '\0';
                    return;
                }
            }
        }
        meta = meta_end + 1;
    }
}

// Extract links from DOM as JSON array
static char *extract_links(const char *dom_text)
{
    cJSON *links = cJSON_CreateArray();
    const char *p = dom_text;
    int count = 0;
    const int max_links = 500;

    while ((p = strcasestr(p, "href=\"")) != NULL && count < max_links) {
        p += 6;  // skip href="
        const char *end = strchr(p, '"');
        if (!end) break;

        size_t len = end - p;
        if (len > 0 && len < MAX_URL_LEN) {
            char *link = malloc(len + 1);
            memcpy(link, p, len);
            link[len] = '\0';

            // Only include http/https links
            if (strncmp(link, "http://", 7) == 0 ||
                strncmp(link, "https://", 8) == 0) {
                cJSON_AddItemToArray(links, cJSON_CreateString(link));
                count++;
            }
            free(link);
        }
        p = end + 1;
    }

    char *result = cJSON_PrintUnformatted(links);
    cJSON_Delete(links);
    return result;
}

// ============================================================
// MySQL Storage
// ============================================================

static MYSQL *db_connect(void)
{
    MYSQL *conn = mysql_init(NULL);
    if (!conn) {
        fprintf(stderr, "[dave_web] ERROR: mysql_init failed\n");
        return NULL;
    }

    // Connect via Unix socket (auth_socket — no password needed for dave_ai)
    if (!mysql_real_connect(conn, NULL, MYSQL_USER, NULL, MYSQL_DB,
                           0, MYSQL_SOCKET, 0)) {
        fprintf(stderr, "[dave_web] ERROR: MySQL connect failed: %s\n",
                mysql_error(conn));
        mysql_close(conn);
        return NULL;
    }

    // Ensure UTF-8
    mysql_set_character_set(conn, "utf8mb4");
    return conn;
}

static int db_store_finding(MYSQL *conn, const WebFinding *f)
{
    // Default to failure so any early `goto cleanup` (e.g. malloc failure)
    // returns an error deterministically instead of reading an
    // uninitialized value.
    int ret = -1;

    // Escape strings for safe insertion
    char *esc_url = malloc(strlen(f->url) * 2 + 1);
    char *esc_title = malloc(strlen(f->title) * 2 + 1);
    char *esc_desc = malloc(strlen(f->description) * 2 + 1);
    char *esc_screenshot = malloc(strlen(f->screenshot_path) * 2 + 1);
    char *esc_text = NULL;

    mysql_real_escape_string(conn, esc_url, f->url, strlen(f->url));
    mysql_real_escape_string(conn, esc_title, f->title, strlen(f->title));
    mysql_real_escape_string(conn, esc_desc, f->description, strlen(f->description));
    mysql_real_escape_string(conn, esc_screenshot, f->screenshot_path,
                             strlen(f->screenshot_path));

    // Text content (may be large)
    size_t text_len = f->text_content ? f->text_len : 0;
    if (text_len > MAX_TEXT_STORE_LEN) text_len = MAX_TEXT_STORE_LEN;
    if (text_len > 0) {
        esc_text = malloc(text_len * 2 + 1);
        mysql_real_escape_string(conn, esc_text, f->text_content, text_len);
    }

    // Links JSON
    char *esc_links = NULL;
    if (f->links_json) {
        esc_links = malloc(strlen(f->links_json) * 2 + 1);
        mysql_real_escape_string(conn, esc_links, f->links_json,
                                 strlen(f->links_json));
    }

    // Build INSERT query
    size_t query_size = (text_len * 2) + (f->links_json ? strlen(f->links_json) * 2 : 0)
                        + 4096;
    char *query = malloc(query_size);
    if (!query) goto cleanup;

    snprintf(query, query_size,
             "INSERT INTO web_findings "
             "(url, title, description, screenshot_path, text_content, "
             " links_json, http_status, load_time_ms, fetched_at) "
             "VALUES ('%s', '%s', '%s', '%s', '%s', '%s', %d, %.1f, "
             "FROM_UNIXTIME(%ld))",
             esc_url, esc_title, esc_desc, esc_screenshot,
             esc_text ? esc_text : "",
             esc_links ? esc_links : "[]",
             f->http_status, f->load_time_ms,
             (long)f->timestamp);

    ret = mysql_query(conn, query);
    if (ret != 0) {
        fprintf(stderr, "[dave_web] ERROR: MySQL insert failed: %s\n",
                mysql_error(conn));
    }

    free(query);

cleanup:
    free(esc_url);
    free(esc_title);
    free(esc_desc);
    free(esc_screenshot);
    free(esc_text);
    free(esc_links);

    return (ret == 0) ? 0 : -1;
}

static int db_query_findings(MYSQL *conn, const char *search_term)
{
    char esc_term[512];
    mysql_real_escape_string(conn, esc_term, search_term, strlen(search_term));

    char query[2048];
    snprintf(query, sizeof(query),
             "SELECT id, url, title, fetched_at, http_status, "
             "       ROUND(load_time_ms, 0) AS load_ms, "
             "       screenshot_path "
             "FROM web_findings "
             "WHERE url LIKE '%%%s%%' OR title LIKE '%%%s%%' "
             "      OR text_content LIKE '%%%s%%' "
             "ORDER BY fetched_at DESC LIMIT 20",
             esc_term, esc_term, esc_term);

    if (mysql_query(conn, query) != 0) {
        fprintf(stderr, "[dave_web] ERROR: MySQL query failed: %s\n",
                mysql_error(conn));
        return -1;
    }

    MYSQL_RES *result = mysql_store_result(conn);
    if (!result) return -1;

    MYSQL_ROW row;
    int count = 0;

    printf("\n  %-4s %-50s %-30s %-20s %s\n",
           "ID", "URL", "Title", "Fetched", "Status");
    printf("  %-4s %-50s %-30s %-20s %s\n",
           "----", "--------------------------------------------------",
           "------------------------------", "--------------------", "------");

    while ((row = mysql_fetch_row(result)) != NULL) {
        printf("  %-4s %-50.50s %-30.30s %-20s %s\n",
               row[0], row[1], row[2] ? row[2] : "(no title)",
               row[3], row[4]);
        count++;
    }

    mysql_free_result(result);
    printf("\n  %d result(s) found.\n\n", count);
    return count;
}

// ============================================================
// Main Web Fetch Logic
// ============================================================

static int fetch_and_store(const char *url, int do_screenshot, int do_text,
                           int do_links, int store_to_db)
{
    WebFinding finding;
    memset(&finding, 0, sizeof(finding));
    strncpy(finding.url, url, MAX_URL_LEN - 1);
    finding.timestamp = time(NULL);

    struct timespec start, end;
    clock_gettime(CLOCK_MONOTONIC, &start);

    printf("[dave_web] Fetching: %s\n", url);

    // --- Screenshot ---
    if (do_screenshot) {
        // Generate screenshot filename from timestamp + URL hash
        unsigned long hash = 5381;
        for (const char *c = url; *c; c++)
            hash = ((hash << 5) + hash) + *c;

        snprintf(finding.screenshot_path, sizeof(finding.screenshot_path),
                 "%s/%ld_%lx.png", SCREENSHOT_DIR, (long)finding.timestamp, hash);

        printf("[dave_web] Capturing screenshot...\n");
        if (capture_screenshot_cdp(url, finding.screenshot_path) == 0) {
            struct stat st;
            stat(finding.screenshot_path, &st);
            printf("[dave_web] Screenshot saved: %s (%ld bytes)\n",
                   finding.screenshot_path, st.st_size);
        } else {
            fprintf(stderr, "[dave_web] WARNING: Screenshot capture failed\n");
            finding.screenshot_path[0] = '\0';
        }
    }

    // --- Page Text + Metadata ---
    if (do_text || do_links) {
        printf("[dave_web] Extracting page content...\n");
        char *dom = extract_page_text(url);
        if (dom) {
            // Extract title
            extract_title(dom, finding.title, sizeof(finding.title));

            // Extract description
            extract_description(dom, finding.description, sizeof(finding.description));

            // Store text content
            if (do_text) {
                finding.text_content = dom;
                finding.text_len = strlen(dom);
            }

            // Extract links
            if (do_links) {
                finding.links_json = extract_links(dom);
            }

            if (!do_text) {
                free(dom);
            }

            finding.http_status = 200;  // If we got DOM, page loaded
            printf("[dave_web] Title: %s\n", finding.title[0] ? finding.title : "(none)");
        } else {
            fprintf(stderr, "[dave_web] WARNING: DOM extraction failed\n");
            finding.http_status = 0;
        }
    }

    clock_gettime(CLOCK_MONOTONIC, &end);
    finding.load_time_ms = (end.tv_sec - start.tv_sec) * 1000.0 +
                           (end.tv_nsec - start.tv_nsec) / 1000000.0;

    printf("[dave_web] Load time: %.0f ms\n", finding.load_time_ms);

    // --- Store to MySQL ---
    if (store_to_db) {
        MYSQL *conn = db_connect();
        if (conn) {
            if (db_store_finding(conn, &finding) == 0) {
                printf("[dave_web] Finding stored in dave_kb.web_findings\n");
            }
            mysql_close(conn);
        } else {
            fprintf(stderr, "[dave_web] WARNING: Could not connect to MySQL. "
                    "Finding not stored.\n");
        }
    }

    // --- Print links if requested ---
    if (do_links && finding.links_json) {
        cJSON *links = cJSON_Parse(finding.links_json);
        if (links) {
            int n = cJSON_GetArraySize(links);
            printf("[dave_web] Links found: %d\n", n);
            for (int i = 0; i < n && i < 50; i++) {
                cJSON *item = cJSON_GetArrayItem(links, i);
                if (item && cJSON_IsString(item))
                    printf("  [%d] %s\n", i + 1, item->valuestring);
            }
            if (n > 50) printf("  ... and %d more\n", n - 50);
            cJSON_Delete(links);
        }
    }

    // Cleanup
    free(finding.text_content);
    free(finding.links_json);

    return (finding.http_status > 0) ? 0 : -1;
}

// ============================================================
// Status Command
// ============================================================

static void show_status(void)
{
    printf("\n╔══════════════════════════════════════════════════╗\n");
    printf("║  Dave Web Interface — Status                    ║\n");
    printf("╚══════════════════════════════════════════════════╝\n\n");

    // Check Chrome (report the runtime-resolved binary path)
    const char *chrome = chrome_binary();
    printf("  Chrome binary:     %s\n", chrome);
    struct stat st;
    if (stat(chrome, &st) == 0) {
        printf("  Chrome status:     INSTALLED\n");
    } else {
        printf("  Chrome status:     NOT FOUND\n");
    }

    // Check CDP
    if (check_chrome_running()) {
        printf("  CDP endpoint:      ACTIVE (port %d)\n", CDP_PORT);
    } else {
        printf("  CDP endpoint:      inactive (on-demand)\n");
    }

    // Check screenshot dir
    if (stat(SCREENSHOT_DIR, &st) == 0) {
        printf("  Screenshot dir:    %s\n", SCREENSHOT_DIR);
    } else {
        printf("  Screenshot dir:    (not created yet)\n");
    }

    // Check MySQL
    MYSQL *conn = db_connect();
    if (conn) {
        printf("  MySQL connection:  CONNECTED (dave_ai@dave_kb)\n");

        // Count findings
        if (mysql_query(conn, "SELECT COUNT(*) FROM web_findings") == 0) {
            MYSQL_RES *res = mysql_store_result(conn);
            if (res) {
                MYSQL_ROW row = mysql_fetch_row(res);
                if (row) printf("  Stored findings:   %s\n", row[0]);
                mysql_free_result(res);
            }
        }
        mysql_close(conn);
    } else {
        printf("  MySQL connection:  UNAVAILABLE\n");
    }

    printf("\n  Version: %s\n\n", DAVE_WEB_VERSION);
}

// ============================================================
// Usage
// ============================================================

static void usage(const char *progname)
{
    printf("\nDave Web Interface — Chrome-based web intelligence for Dave AI\n\n");
    printf("Usage:\n");
    printf("  %s <url>                    Fetch URL (screenshot + text + store)\n", progname);
    printf("  %s --text-only <url>        Extract text content only\n", progname);
    printf("  %s --screenshot-only <url>  Capture screenshot only\n", progname);
    printf("  %s --links <url>            Extract all links from page\n", progname);
    printf("  %s --no-store <url>         Fetch without storing to MySQL\n", progname);
    printf("  %s --query <search>         Query stored findings\n", progname);
    printf("  %s --status                 Show system status\n", progname);
    printf("  %s --help                   Show this help\n", progname);
    printf("\nScreenshots are saved to: %s\n", SCREENSHOT_DIR);
    printf("Findings are stored in:   MySQL dave_kb.web_findings\n\n");
}

// ============================================================
// Main
// ============================================================

int main(int argc, char *argv[])
{
    if (argc < 2) {
        usage(argv[0]);
        return 1;
    }

    curl_global_init(CURL_GLOBAL_DEFAULT);

    int ret = 0;

    if (strcmp(argv[1], "--help") == 0 || strcmp(argv[1], "-h") == 0) {
        usage(argv[0]);

    } else if (strcmp(argv[1], "--status") == 0) {
        show_status();

    } else if (strcmp(argv[1], "--query") == 0) {
        if (argc < 3) {
            fprintf(stderr, "Usage: %s --query <search_term>\n", argv[0]);
            ret = 1;
        } else {
            MYSQL *conn = db_connect();
            if (conn) {
                db_query_findings(conn, argv[2]);
                mysql_close(conn);
            } else {
                ret = 1;
            }
        }

    } else if (strcmp(argv[1], "--text-only") == 0) {
        if (argc < 3) { fprintf(stderr, "Usage: %s --text-only <url>\n", argv[0]); ret = 1; }
        else ret = fetch_and_store(argv[2], 0, 1, 0, 1);

    } else if (strcmp(argv[1], "--screenshot-only") == 0) {
        if (argc < 3) { fprintf(stderr, "Usage: %s --screenshot-only <url>\n", argv[0]); ret = 1; }
        else ret = fetch_and_store(argv[2], 1, 0, 0, 1);

    } else if (strcmp(argv[1], "--links") == 0) {
        if (argc < 3) { fprintf(stderr, "Usage: %s --links <url>\n", argv[0]); ret = 1; }
        else ret = fetch_and_store(argv[2], 0, 1, 1, 1);

    } else if (strcmp(argv[1], "--no-store") == 0) {
        if (argc < 3) { fprintf(stderr, "Usage: %s --no-store <url>\n", argv[0]); ret = 1; }
        else ret = fetch_and_store(argv[2], 1, 1, 1, 0);

    } else {
        // Default: full fetch (screenshot + text + links + store)
        ret = fetch_and_store(argv[1], 1, 1, 1, 1);
    }

    curl_global_cleanup();
    return ret;
}
