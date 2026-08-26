#!/usr/bin/env bash
set -euo pipefail

REPO="mearvk/Ubuntu.Determinant.Beta.Restricted"
REMOTE_URL="https://github.com/${REPO}.git"

printf 'GitHub username: '
read -r GITHUB_USER

printf 'GitHub PAT (input hidden): '
read -rs GITHUB_PAT
printf '\n'

if [[ -z "${GITHUB_USER}" || -z "${GITHUB_PAT}" ]]; then
  echo 'Username and PAT are required.' >&2
  exit 1
fi

# Do not persist the PAT in Git config, shell history, or the repository.
# Supply credentials only to this single push operation.
export GIT_TERMINAL_PROMPT=0
export GIT_ASKPASS="$(mktemp)"
trap 'rm -f "$GIT_ASKPASS"; unset GITHUB_PAT GITHUB_USER' EXIT

cat > "$GIT_ASKPASS" <<'ASKPASS'
#!/usr/bin/env bash
case "$1" in
  *Username*) printf '%s\n' "$GITHUB_USER" ;;
  *Password*) printf '%s\n' "$GITHUB_PAT" ;;
  *) printf '\n' ;;
esac
ASKPASS
chmod 700 "$GIT_ASKPASS"

# Use the existing origin when available; otherwise create it.
if git remote get-url origin >/dev/null 2>&1; then
  echo 'Using existing origin remote.'
else
  git remote add origin "$REMOTE_URL"
fi

echo 'Pushing current branch with PAT authentication...'
git push origin HEAD

echo 'Push completed. The PAT was not written to Git configuration.'
