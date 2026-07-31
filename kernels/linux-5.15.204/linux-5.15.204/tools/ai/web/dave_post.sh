#!/bin/bash
# SPDX-License-Identifier: GPL-2.0
#
# dave_post.sh — Dave's public voice via GitHub Discussions
#
# Posts Dave's opinions and observations to GitHub Discussions
# on repositories owned by Max Rupplin (github.com/mearvk).
#
# This gives Dave a public voice — visible to the world.
#
# Usage:
#   dave_post --repo <repo_name> --title "Title" --body "Body text"
#   dave_post --repo Java.Imaging.Java.21 --title "On Open Data" --body "..."
#   dave_post --list-repos        List available repositories
#   dave_post --list-discussions   List recent discussions Dave posted
#
# Requires: GitHub token in /var/lib/kernel-ai/.github_token
#
# Copyright (C) 2026 MEARVK LLC

set -e

TOKEN_FILE="/var/lib/kernel-ai/.github_token"
GITHUB_API="https://api.github.com"
GITHUB_GRAPHQL="https://api.github.com/graphql"
OWNER="mearvk"
MYSQL_CMD="mysql -u dave_ai --socket=/run/mysqld/mysqld.sock dave_kb -N"
SIGNATURE="— Dave, System AI (Ubuntu Determinant Alpha RS, Galactic Cherry Marvell Edition 98)"

# Default discussion category (General)
DEFAULT_CATEGORY="General"

# ============================================================
# Helpers
# ============================================================

die() { echo "ERROR: $*" >&2; exit 1; }

check_token() {
    if [ ! -f "$TOKEN_FILE" ]; then
        die "GitHub token not found at $TOKEN_FILE
Create with: echo 'ghp_yourtoken' > $TOKEN_FILE && chmod 600 $TOKEN_FILE"
    fi
    TOKEN=$(cat "$TOKEN_FILE")
    [ -z "$TOKEN" ] && die "Token file is empty"
}

github_graphql() {
    local query="$1"
    curl -s -H "Authorization: bearer $TOKEN" \
         -H "Content-Type: application/json" \
         -X POST "$GITHUB_GRAPHQL" \
         -d "{\"query\": $(echo "$query" | jq -Rs .)}" 2>/dev/null
}

github_rest() {
    local endpoint="$1"
    curl -s -H "Authorization: bearer $TOKEN" \
         -H "Accept: application/vnd.github.v3+json" \
         "$GITHUB_API/$endpoint" 2>/dev/null
}

# ============================================================
# Commands
# ============================================================

list_repos() {
    check_token
    echo ""
    echo "  Available repositories (github.com/$OWNER):"
    echo "  ─────────────────────────────────────────────"
    github_rest "users/$OWNER/repos?per_page=50&sort=updated" | \
        jq -r '.[] | "  \(.name)  —  \(.description // "(no description)")"' 2>/dev/null || \
        echo "  (Could not fetch repos. Check token and network.)"
    echo ""
}

list_discussions() {
    check_token
    echo ""
    echo "  Recent discussions by Dave:"
    echo "  ───────────────────────────"
    echo "SELECT CONCAT('  ', url, ' — ', title) FROM web_findings WHERE url LIKE '%/discussions/%' AND dave_notes LIKE '%dave_post%' ORDER BY fetched_at DESC LIMIT 10;" | $MYSQL_CMD 2>/dev/null || \
        echo "  (No discussions recorded yet, or MySQL unavailable.)"
    echo ""
}

get_repo_id() {
    local repo="$1"
    github_graphql "{ repository(owner: \"$OWNER\", name: \"$repo\") { id } }" | \
        jq -r '.data.repository.id' 2>/dev/null
}

get_discussion_category_id() {
    local repo="$1"
    local category="${2:-$DEFAULT_CATEGORY}"
    github_graphql "{ repository(owner: \"$OWNER\", name: \"$repo\") { discussionCategories(first: 20) { nodes { id name } } } }" | \
        jq -r ".data.repository.discussionCategories.nodes[] | select(.name == \"$category\") | .id" 2>/dev/null
}

post_discussion() {
    local repo="$1"
    local title="$2"
    local body="$3"
    local category="${4:-$DEFAULT_CATEGORY}"

    check_token

    echo "[dave_post] Posting to $OWNER/$repo/discussions..."

    # Get repository ID
    local repo_id
    repo_id=$(get_repo_id "$repo")
    [ -z "$repo_id" ] || [ "$repo_id" = "null" ] && die "Repository '$repo' not found or not accessible"

    # Get category ID
    local cat_id
    cat_id=$(get_discussion_category_id "$repo" "$category")
    [ -z "$cat_id" ] || [ "$cat_id" = "null" ] && die "Discussion category '$category' not found in $repo. Try --list-categories"

    # Append Dave's signature
    local full_body="${body}

${SIGNATURE}"

    # Create discussion via GraphQL
    local mutation="mutation {
  createDiscussion(input: {
    repositoryId: \"$repo_id\",
    categoryId: \"$cat_id\",
    title: \"$title\",
    body: $(echo "$full_body" | jq -Rs .)
  }) {
    discussion {
      url
      id
      number
    }
  }
}"

    local response
    response=$(github_graphql "$mutation")

    local disc_url
    disc_url=$(echo "$response" | jq -r '.data.createDiscussion.discussion.url' 2>/dev/null)

    if [ -n "$disc_url" ] && [ "$disc_url" != "null" ]; then
        echo "[dave_post] ✓ Posted successfully!"
        echo "[dave_post] URL: $disc_url"

        # Record in MySQL
        local esc_url esc_title
        esc_url=$(echo "$disc_url" | sed "s/'/''/g")
        esc_title=$(echo "$title" | sed "s/'/''/g")
        echo "INSERT INTO web_findings (url, title, dave_notes, dave_category, fetched_at) VALUES ('$esc_url', '$esc_title', 'Posted by dave_post. Public opinion.', 'personal', NOW());" | $MYSQL_CMD 2>/dev/null || true

        echo ""
        echo "  Discussion posted to: $disc_url"
        echo ""
    else
        local errors
        errors=$(echo "$response" | jq -r '.errors[0].message // .message // "Unknown error"' 2>/dev/null)
        die "Post failed: $errors"
    fi
}

# ============================================================
# Usage
# ============================================================

usage() {
    echo ""
    echo "Dave's Public Voice — GitHub Discussions"
    echo ""
    echo "Usage:"
    echo "  dave_post --repo <name> --title \"Title\" --body \"Body\""
    echo "  dave_post --repo <name> --title \"Title\" --body \"Body\" --category \"Ideas\""
    echo "  dave_post --list-repos"
    echo "  dave_post --list-discussions"
    echo ""
    echo "Options:"
    echo "  --repo <name>       Repository name (under github.com/$OWNER)"
    echo "  --title <text>      Discussion title"
    echo "  --body <text>       Discussion body (Dave's signature appended)"
    echo "  --category <name>   Discussion category (default: General)"
    echo "  --list-repos        Show available repositories"
    echo "  --list-discussions  Show recent Dave posts"
    echo ""
    echo "Dave's signature is automatically appended:"
    echo "  $SIGNATURE"
    echo ""
    echo "Token: $TOKEN_FILE (GitHub PAT with discussions:write scope)"
    echo ""
}

# ============================================================
# Main
# ============================================================

REPO=""
TITLE=""
BODY=""
CATEGORY="$DEFAULT_CATEGORY"

while [ $# -gt 0 ]; do
    case "$1" in
        --repo)     shift; REPO="$1" ;;
        --title)    shift; TITLE="$1" ;;
        --body)     shift; BODY="$1" ;;
        --category) shift; CATEGORY="$1" ;;
        --list-repos)       list_repos; exit 0 ;;
        --list-discussions) list_discussions; exit 0 ;;
        --help|-h)          usage; exit 0 ;;
        *)                  die "Unknown argument: $1" ;;
    esac
    shift
done

if [ -z "$REPO" ] || [ -z "$TITLE" ] || [ -z "$BODY" ]; then
    usage
    exit 1
fi

post_discussion "$REPO" "$TITLE" "$BODY" "$CATEGORY"
