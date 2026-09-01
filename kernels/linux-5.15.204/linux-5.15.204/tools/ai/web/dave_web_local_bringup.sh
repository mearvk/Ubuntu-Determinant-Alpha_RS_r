#!/bin/bash
# =============================================================================
# dave_web_local_bringup.sh
#
# LOCAL TEST bring-up for dave_web in an INTEGRATIONS_ONLY sandbox (no external
# package network). Builds the vendored MySQL 9.7.0 client + server from source,
# builds the dave_web binary, initializes and starts a throwaway test mysqld,
# creates the dave_kb database + passwordless dave_ai user, loads both schemas,
# and exercises dave_web --status and a real headless-Chrome fetch.
#
# This encodes the working sequence discovered across FEAT-002..FEAT-005.
#
# REQUIREMENTS
#   * The vendored MySQL 9.7.0 source under tools/mysql (with extra/boost and
#     extra/tirpc already present) — this is what supplies libmysqlclient and
#     mysqld without any network access.
#   * A working Chrome/Chromium at /usr/local/bin/chrome (Google Chrome for
#     Testing works). Override with DAVE_CHROME.
#   * Build toolchain: gcc, cmake, make. libcurl dev headers on the host.
#
# CRITICAL SANDBOX CAVEAT (PID namespace):
#   In this sandbox EVERY tool/command invocation may run in its own PID
#   namespace (bwrap --unshare-pid --die-with-parent). A mysqld backgrounded in
#   one invocation is KILLED when that invocation returns and does NOT survive
#   into the next one. Therefore you MUST start mysqld in the SAME shell session
#   that runs dave_web. This script does exactly that: it starts mysqld, waits
#   for the socket, then runs dave_web, all in one process. If you split the
#   steps across separate tool calls, restart mysqld first (the datadir persists
#   on disk, so no re-init/re-load is needed — see start_server()).
#
# TEST PATHS (all throwaway; NOT part of the repo):
#   /projects/sandbox/mysql-test/            test datadir + logs + pid + socket lock
#   /run/mysqld/mysqld.sock                  unix socket dave_web connects to
#   /var/lib/kernel-ai/screenshots           dave_web screenshot output
#   <tools/mysql>/build                      throwaway MySQL build tree
#   <tools/ai/web>/dave_web                  throwaway built binary
# See the CLEANUP section at the bottom for how to reverse everything.
#
# USAGE:
#   ./dave_web_local_bringup.sh            # full idempotent bring-up + demo
#   ./dave_web_local_bringup.sh <url>      # bring up, then fetch a specific URL
# =============================================================================
set -u

# ---- Paths -----------------------------------------------------------------
KROOT=/projects/sandbox/udbr/kernels/linux-5.15.204/linux-5.15.204
MYSQL_SRC="$KROOT/tools/mysql"
MYSQL_BUILD="$MYSQL_SRC/build"
LIBDIR="$MYSQL_BUILD/library_output_directory"
RUNDIR="$MYSQL_BUILD/runtime_output_directory"
WEBDIR="$KROOT/tools/ai/web"

# Throwaway test locations (clearly outside the repo so they can never be committed)
TESTROOT=/projects/sandbox/mysql-test
DATADIR="$TESTROOT/data"
SOCK=/run/mysqld/mysqld.sock
PIDFILE="$TESTROOT/mysqld.pid"
ERRLOG="$TESTROOT/error.log"
SCREENSHOT_DIR=/var/lib/kernel-ai/screenshots
CHROME_DATA_DIR=/var/lib/kernel-ai/chrome-data

DAVE_CHROME="${DAVE_CHROME:-/usr/local/bin/chrome}"

log() { echo "[bringup] $*"; }
die() { echo "[bringup][ERROR] $*" >&2; exit 1; }

# ---- (a) Build libmysqlclient + mysqld from vendored source ----------------
# Exact cmake flags from FEAT-002/FEAT-002B (vendored Boost, NO downloads).
build_mysql() {
  if [ -x "$RUNDIR/mysqld" ] && [ -e "$LIBDIR/libmysqlclient.so" ]; then
    log "MySQL artifacts already present (mysqld + libmysqlclient) — skipping build."
    return 0
  fi
  log "Building MySQL 9.7.0 client + server from vendored source (no network)..."
  mkdir -p "$MYSQL_BUILD" || die "cannot create $MYSQL_BUILD"
  ( cd "$MYSQL_BUILD" && cmake .. \
      -DWITH_BOOST="$MYSQL_SRC/extra/boost" \
      -DDOWNLOAD_BOOST=OFF \
      -DCMAKE_INSTALL_PREFIX=/tmp/mysql-local \
      -DWITH_SSL=system \
      -DWITH_ZLIB=bundled \
      -DWITH_TIRPC=bundled \
      -DWITHOUT_GROUP_REPLICATION=1 \
      -DWITH_UNIT_TESTS=OFF \
      -DWITH_ROUTER=OFF \
      -DWITH_EMBEDDED_SERVER=OFF ) || die "cmake configure failed"
  # Client library first (fast), then the client tools, then the server.
  ( cd "$MYSQL_BUILD" && cmake --build . --target libmysql -j"$(nproc)" ) || die "libmysqlclient build failed"
  ( cd "$MYSQL_BUILD" && cmake --build . --target mysql mysqladmin -j"$(nproc)" ) || die "mysql client tools build failed"
  ( cd "$MYSQL_BUILD" && cmake --build . --target mysqld -j"$(nproc)" ) || die "mysqld build failed"
  log "MySQL build complete."
}

# ---- (b) Build dave_web with correct -I / -L -------------------------------
# dave_web.c does #include <mysql/mysql.h>, but the vendored tree ships mysql.h
# at tools/mysql/include/mysql.h (no mysql/ subdir). We create a throwaway
# staging dir with a `mysql` symlink so <mysql/mysql.h> resolves WITHOUT editing
# any committed source.
build_dave_web() {
  if [ -x "$WEBDIR/dave_web" ]; then
    log "dave_web binary already present — skipping build."
    return 0
  fi
  log "Building dave_web..."
  local stage="$MYSQL_BUILD/dave_include_stage"
  mkdir -p "$stage" || die "cannot create include staging dir"
  ln -sfn "$MYSQL_SRC/include" "$stage/mysql"
  ( cd "$WEBDIR" && make clean >/dev/null 2>&1; \
    make \
      CFLAGS="-Wall -Wextra -O2 -std=c11 -D_GNU_SOURCE -I$stage -I$MYSQL_SRC/include -I$MYSQL_BUILD/include" \
      LDFLAGS="-L$LIBDIR -lcurl -lmysqlclient -lrt" ) || die "dave_web build failed"
  [ -x "$WEBDIR/dave_web" ] || die "dave_web binary not produced"
  log "dave_web built: $WEBDIR/dave_web"
}

# ---- (c) Initialize the test datadir (skip if it already exists) -----------
init_datadir() {
  if [ -d "$DATADIR" ] && [ -n "$(ls -A "$DATADIR" 2>/dev/null)" ]; then
    log "Datadir $DATADIR already initialized — skipping init (persists on disk)."
    return 0
  fi
  log "Initializing test datadir at $DATADIR (empty root password)..."
  mkdir -p "$DATADIR" "$TESTROOT" || die "cannot create test dirs"
  LD_LIBRARY_PATH="$LIBDIR" "$RUNDIR/mysqld" \
    --initialize-insecure --datadir="$DATADIR" --user=root \
    || die "mysqld --initialize-insecure failed"
  log "Datadir initialized."
}

# ---- Start mysqld on the socket dave_web expects, wait for ping ------------
# Clears any stale socket/lock left by a mysqld killed with its PID namespace.
start_server() {
  log "Starting test mysqld on $SOCK ..."
  mkdir -p /run/mysqld 2>/dev/null || true
  rm -f "$SOCK" "$SOCK.lock" "$PIDFILE" /tmp/mysqlx.sock /tmp/mysqlx.sock.lock 2>/dev/null || true
  LD_LIBRARY_PATH="$LIBDIR" "$RUNDIR/mysqld" \
    --datadir="$DATADIR" \
    --socket="$SOCK" \
    --pid-file="$PIDFILE" \
    --user=root \
    --port=3306 \
    --log-error="$ERRLOG" >/dev/null 2>&1 &
  MYSQLD_BG=$!
  for i in $(seq 1 60); do
    if LD_LIBRARY_PATH="$LIBDIR" "$RUNDIR/mysqladmin" --socket="$SOCK" -u root ping 2>/dev/null | grep -q alive; then
      log "mysqld is alive (after ${i}s)."
      return 0
    fi
    sleep 1
  done
  die "mysqld did not come up within 60s (see $ERRLOG)"
}

# ---- (d) Create dave_kb + passwordless dave_ai + load both schemas ---------
# auth_socket.so is not built in this reduced server, so dave_ai is provisioned
# with an EMPTY caching_sha2_password: a passwordless socket connect (exactly
# what dave_web's db_connect() does) is admitted for any OS user.
provision_db() {
  log "Provisioning dave_kb + dave_ai + schemas..."
  LD_LIBRARY_PATH="$LIBDIR" "$RUNDIR/mysql" --socket="$SOCK" -u root <<'SQL' || die "db provisioning failed"
CREATE DATABASE IF NOT EXISTS dave_kb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'dave_ai'@'localhost' IDENTIFIED WITH caching_sha2_password BY '';
GRANT ALL PRIVILEGES ON dave_kb.* TO 'dave_ai'@'localhost';
FLUSH PRIVILEGES;
SQL
  LD_LIBRARY_PATH="$LIBDIR" "$RUNDIR/mysql" --socket="$SOCK" -u root dave_kb < "$WEBDIR/dave_web_schema.sql" \
    || die "loading dave_web_schema.sql failed"
  LD_LIBRARY_PATH="$LIBDIR" "$RUNDIR/mysql" --socket="$SOCK" -u root dave_kb < "$WEBDIR/dave_ssl_schema.sql" \
    || die "loading dave_ssl_schema.sql failed"
  mkdir -p "$SCREENSHOT_DIR" "$CHROME_DATA_DIR"
  # Verify passwordless dave_ai connect over the socket.
  LD_LIBRARY_PATH="$LIBDIR" "$RUNDIR/mysql" --socket="$SOCK" -u dave_ai dave_kb \
    -e 'SELECT COUNT(*) AS web_findings_count FROM web_findings;' \
    || die "dave_ai passwordless socket connect FAILED"
  log "dave_kb provisioned; dave_ai connects passwordless over the socket."
}

# ---- (e) Run --status and a fetch ------------------------------------------
run_demo() {
  local url="${1:-https://example.com}"
  log "Running dave_web --status ..."
  DAVE_CHROME="$DAVE_CHROME" LD_LIBRARY_PATH="$LIBDIR" "$WEBDIR/dave_web" --status \
    || die "dave_web --status failed"

  log "Fetching $url (headless Chrome -> DOM + screenshot -> dave_kb.web_findings) ..."
  if ! DAVE_CHROME="$DAVE_CHROME" LD_LIBRARY_PATH="$LIBDIR" timeout 90 "$WEBDIR/dave_web" "$url"; then
    # INTEGRATIONS_ONLY fallback: external HTTPS may be unreachable. Serve a
    # trivial page locally and fetch it so the full Chrome->DOM->DB path runs.
    log "External fetch failed/unreachable; falling back to a local HTTP server."
    local tmp; tmp="$(mktemp -d)"
    printf '<!doctype html><html><head><title>dave local test</title></head><body><h1>dave local bringup</h1><p>local http fallback page</p></body></html>' > "$tmp/index.html"
    ( cd "$tmp" && python3 -m http.server 8099 --bind 127.0.0.1 >/dev/null 2>&1 & echo $! > "$tmp/httpd.pid" )
    sleep 1
    DAVE_CHROME="$DAVE_CHROME" LD_LIBRARY_PATH="$LIBDIR" timeout 90 "$WEBDIR/dave_web" "http://127.0.0.1:8099/" \
      || log "WARNING: even the local-http fallback fetch failed."
    [ -f "$tmp/httpd.pid" ] && kill "$(cat "$tmp/httpd.pid")" 2>/dev/null || true
  fi

  log "Stored findings:"
  LD_LIBRARY_PATH="$LIBDIR" "$RUNDIR/mysql" --socket="$SOCK" -u dave_ai dave_kb \
    -e 'SELECT id,url,title,http_status,screenshot_path FROM web_findings;'
  log "Screenshots on disk:"
  ls -la "$SCREENSHOT_DIR"
}

# ---- Main ------------------------------------------------------------------
main() {
  [ -x "$DAVE_CHROME" ] || [ -L "$DAVE_CHROME" ] || log "WARNING: DAVE_CHROME=$DAVE_CHROME not found; fetches will fail."
  build_mysql
  build_dave_web
  init_datadir
  start_server        # MUST be in the same session as run_demo (PID-namespace caveat)
  provision_db
  run_demo "${1:-}"
  log "Bring-up complete. mysqld PID $MYSQLD_BG is running in THIS session only."
  log "NOTE: if this process exits, mysqld exits too. Re-run start_server (datadir persists)."
}

main "$@"

# =============================================================================
# CLEANUP (reverse everything — run manually when done):
#
#   # 1. Stop the test server (if still running in this session):
#   LD_LIBRARY_PATH="$LIBDIR" "$RUNDIR/mysqladmin" --socket=/run/mysqld/mysqld.sock -u root shutdown
#   # or: pkill -f 'mysqld .*--datadir=/projects/sandbox/mysql-test/data'
#
#   # 2. Remove the throwaway test datadir + logs + socket artifacts:
#   rm -rf /projects/sandbox/mysql-test
#   rm -f  /run/mysqld/mysqld.sock /run/mysqld/mysqld.sock.lock /tmp/mysqlx.sock /tmp/mysqlx.sock.lock
#
#   # 3. Remove dave_web runtime dirs (screenshots + chrome profile):
#   rm -rf /var/lib/kernel-ai/screenshots /var/lib/kernel-ai/chrome-data
#
#   # 4. Remove the throwaway build artifacts:
#   rm -rf "$KROOT/tools/mysql/build"
#   ( cd "$KROOT/tools/ai/web" && make clean )
#
# None of the above paths are part of the repo; only this script is checked in.
# =============================================================================
