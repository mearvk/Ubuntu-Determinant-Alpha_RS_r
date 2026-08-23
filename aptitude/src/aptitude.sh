#!/usr/bin/env bash
set -euo pipefail

# Aptitude prototype: context-aware Linux installation planner.
# Dry-run is the default. State-changing operations require `apply`.

usage() {
  cat <<'EOF'
Aptitude — context-aware installer

Usage:
  aptitude inspect ARTIFACT
  aptitude plan ARTIFACT
  aptitude apply ARTIFACT
  aptitude verify NAME

The prototype discovers host surfaces and produces a plan. `apply` is
intentionally conservative and currently performs only a verified staging
operation; privileged service changes are not performed implicitly.
EOF
}

need_cmd() { command -v "$1" >/dev/null 2>&1; }

artifact_info() {
  local file="$1"
  [[ -f "$file" ]] || { echo "artifact not found: $file" >&2; exit 2; }
  echo "artifact=$file"
  echo "sha256=$(sha256sum "$file" | awk '{print $1}')"
  echo "size=$(stat -c '%s' "$file")"
  echo "mode=$(stat -c '%A' "$file")"
  if file "$file" | grep -q 'ELF'; then
    echo "format=ELF"
    if need_cmd readelf; then
      readelf -h "$file" | awk -F: '/Class|Machine/ {gsub(/^ +/,"",$2); print tolower($1) "=" $2}'
      echo "dynamic_dependencies="
      readelf -d "$file" 2>/dev/null | awk '/NEEDED/ {gsub(/[\[\]]/,"",$5); print "  - " $5}' || true
    fi
  else
    echo "format=$(file -b "$file")"
  fi
}

surfaces() {
  echo "host=$(uname -s)"
  echo "kernel=$(uname -r)"
  echo "arch=$(uname -m)"
  for surface in systemctl crontab at getent ldconfig java javac; do
    if need_cmd "$surface"; then
      echo "surface.$surface=available"
    else
      echo "surface.$surface=unavailable"
    fi
  done
  if [[ -d /run/systemd/system ]]; then
    echo "surface.systemd_runtime=available"
  else
    echo "surface.systemd_runtime=unavailable"
  fi
  if [[ -d /sys/fs/cgroup ]]; then
    echo "surface.cgroup=available"
  else
    echo "surface.cgroup=unavailable"
  fi
}

inspect() {
  echo '--- ARTIFACT ---'
  artifact_info "$1"
  echo '--- HOST SURFACES ---'
  surfaces
}

plan() {
  local file="$1"
  echo 'APTITUDE INSTALL PLAN'
  echo '====================='
  inspect "$file"
  echo
  echo 'proposed_operations='
  echo '  1. verify artifact identity and SHA-256'
  echo '  2. verify architecture/ABI compatibility'
  echo '  3. resolve required shared libraries'
  echo '  4. select an installation target'
  echo '  5. propose PATH/JAVA_HOME changes when applicable'
  echo '  6. detect systemd/cron/timer integration opportunities'
  echo '  7. request explicit authorization for privileged changes'
  echo '  8. stage files atomically'
  echo '  9. verify executable and installed metadata'
  echo ' 10. retain an installation evidence record'
  echo
  echo 'decision=dry-run; no system state changed'
}

apply() {
  local file="$1"
  echo 'Aptitude apply: conservative prototype'
  echo '---------------------------------------'
  plan "$file"
  echo
  echo 'apply_status=not_applied'
  echo 'reason=prototype refuses implicit privileged or persistent system changes'
  echo 'next=review the plan and implement a signed adapter for the desired surface'
}

verify() {
  local name="$1"
  if [[ -x "$(command -v "$name" 2>/dev/null || true)" ]]; then
    echo "verified=$name"
    "$name" --version 2>&1 | head -n 2 || true
  else
    echo "not_found=$name"
    exit 1
  fi
}

case "${1:-}" in
  inspect|plan|apply)
    [[ $# -eq 2 ]] || { usage; exit 2; }
    "$1" "$2"
    ;;
  verify)
    [[ $# -eq 2 ]] || { usage; exit 2; }
    verify "$2"
    ;;
  *)
    usage
    exit 2
    ;;
esac
