# EXPLANATIONS — Git Command (Method) Set

**Project:** Ubuntu Determinant
**Edition:** Ubuntu White Edition
**Project attention:** Max Rupplin — MEARVK LLC — 2026
**Status:** Reference for the vendored Git command set

---

## 1. Purpose

This document explains the **known method set for Git** — the command surface a
user or script invokes — for the source vendored under
[`git/`](git/). It is a companion to the founding note
([`FOUNDING.md`](FOUNDING.md)) and the modification record
([`../../MODIFICATIONS.md`](../../MODIFICATIONS.md)).

For every command it records:

- the canonical command name and its `git <verb>` invocation,
- an **importance** rating from **1 to 10** (10 = most important),
- Git's own **classification** of the command,
- the **purpose**, taken verbatim from the upstream documentation `NAME` line.

The full set is listed **alphabetically** in [Section 5](#5-full-method-set-alphabetical).
Detailed **major flags** for the highest-importance commands are in
[Section 4](#4-major-flags-for-the-highest-importance-commands).

## 2. Source of truth

The command inventory and classifications are taken directly from the vendored
Git source, not from memory:

- **Inventory + classification:** `git/command-list.txt`
- **Purpose lines:** the `NAME` section of each `git/Documentation/git-*.adoc`
- **Snapshot:** Git `v2.55.GIT`, upstream commit
  `c73e85354c275c9d409b26445089bc16940fc527` (see [`git/.source-commit`](git/.source-commit))

Documentation-only pages (`gitglossary`, `gittutorial`, format/protocol specs,
and other guides) are **not** commands and are excluded. The set below is the
**159 invocable commands** Git classifies, plus `scalar`.

Flag lists in Section 4 describe long-standing, stable options and are a
practical summary, not a replacement for the authoritative per-command manual
pages in `git/Documentation/`.

## 3. Importance rating (1–10)

The rating is derived from Git's own command classification in
`command-list.txt`, so it is principled rather than arbitrary:

| Rating | Meaning | Basis |
|:--:|---|---|
| **10** | Core daily driver | The commands almost every user runs constantly: staging, committing, inspecting, branching, and syncing. |
| **9** | Very common porcelain | Frequently used everyday commands just outside the core. |
| **8** | Common porcelain | `mainporcelain` commands flagged "common" by Git (worktree/history/info/etc.). |
| **7** | Other porcelain | Remaining user-facing `mainporcelain` commands. |
| **6** | Ancillary | `ancillary*` — configuration, inspection, and maintenance helpers users invoke directly but less often. |
| **5** | Plumbing | `plumbing*` — low-level building blocks used by scripts, tools, and porcelain internals. |
| **4** | Other | Anything not otherwise classified. |
| **3** | Synchronization internals | `synchingrepositories` / `synchelpers` — transport backends invoked indirectly by fetch/push. |
| **2** | Helpers & foreign SCM | `purehelpers` and `foreignscminterface` — internal scriptlets and non-Git SCM bridges. |

Ratings reflect **typical importance to a general working experience**, not a
judgment of engineering quality. A rating of 2 (e.g. `git-upload-pack`) can still
be indispensable to an operation a user triggers indirectly.

## 4. Major flags for the highest-importance commands

The following summarizes the major, stable flags for the rating-10 core and a
few rating-9 commands. Flags are grouped by the effect a user most often wants.

### `git add` — stage file contents
- `-A`, `--all` — stage all changes (new, modified, deleted) across the tree.
- `-u`, `--update` — stage modifications and deletions, but not new files.
- `-p`, `--patch` — interactively choose hunks to stage.
- `-n`, `--dry-run` — show what would be staged without doing it.
- `-f`, `--force` — allow adding otherwise ignored files.

### `git commit` — record changes
- `-m <msg>` — set the commit message inline.
- `-a`, `--all` — automatically stage tracked, modified/deleted files first.
- `--amend` — replace the tip commit (edit message or contents).
- `-s`, `--signoff` — add a `Signed-off-by` trailer.
- `--no-verify` — skip pre-commit / commit-msg hooks.
- `--allow-empty` — permit a commit with no changes.

### `git status` — show working-tree state
- `-s`, `--short` — compact status output.
- `-b`, `--branch` — show branch and tracking info.
- `--porcelain[=v1|v2]` — stable, script-friendly format.
- `-u[mode]`, `--untracked-files[=mode]` — control untracked-file display (`no`/`normal`/`all`).

### `git log` — show commit history
- `--oneline` — one condensed line per commit.
- `--graph` — draw the commit graph.
- `-p`, `--patch` — show diffs with each commit.
- `--stat` — show diffstat per commit.
- `--since` / `--until`, `--author`, `--grep` — filter by date, author, or message.
- `-n <count>` — limit the number of commits.

### `git diff` — show changes
- `--staged` / `--cached` — diff the index against `HEAD`.
- `--stat` — summarize changes as a diffstat.
- `--name-only` / `--name-status` — list changed paths (with status).
- `-w`, `--ignore-all-space` — ignore whitespace differences.
- `<commit>..<commit>` / `<commit>...<commit>` — diff ranges.

### `git branch` — manage branches
- `-a`, `--all` / `-r`, `--remotes` — list all / remote-tracking branches.
- `-d` / `-D` — delete (safe / forced).
- `-m` / `-M` — rename (safe / forced).
- `--set-upstream-to=<upstream>` — set tracking.
- `-v`, `--verbose` — show tip commit and tracking status.

### `git checkout` — switch branches / restore files
- `-b <name>` / `-B <name>` — create (or reset) and switch to a branch.
- `-t`, `--track` — set up upstream tracking on creation.
- `--` `<path>` — restore working-tree paths (legacy; see `git restore`).
- `-f`, `--force` — discard local changes when switching.

### `git merge` — join histories
- `--no-ff` — always create a merge commit.
- `--ff-only` — refuse unless a fast-forward is possible.
- `--squash` — combine changes without recording a merge commit.
- `--abort` / `--continue` — stop or resume a conflicted merge.
- `-m <msg>` — set the merge commit message.

### `git init` — create a repository
- `--bare` — create a repository with no working tree.
- `-b <name>`, `--initial-branch=<name>` — set the initial branch name.
- `--separate-git-dir=<dir>` — place the repository database elsewhere.

### `git clone` — copy a repository
- `--depth <n>` — shallow clone with truncated history.
- `--branch <name>` / `--single-branch` — clone one ref.
- `--filter=<spec>` (e.g. `blob:none`) — partial (blobless/treeless) clone.
- `--recurse-submodules` — clone submodules too.
- `--bare` / `--mirror` — server-style clones.

### `git push` — publish refs
- `-u`, `--set-upstream` — set the tracking relationship while pushing.
- `--force-with-lease` — safer forced push that respects remote state.
- `-f`, `--force` — unconditional forced push (use with care).
- `--tags` — push tags as well.
- `--delete` — delete a remote ref.
- `-n`, `--dry-run` — show what would be pushed.

### `git pull` — fetch and integrate
- `--rebase[=<mode>]` — integrate by rebasing instead of merging.
- `--ff-only` — only fast-forward; otherwise stop.
- `--no-commit` — merge without auto-committing.
- `--autostash` — stash/unstash local changes around the pull.

### `git fetch` — download refs/objects (rating 9)
- `--all` — fetch from all remotes.
- `-p`, `--prune` — delete remote-tracking refs that no longer exist upstream.
- `--tags` — fetch all tags.
- `--depth <n>` / `--unshallow` — control shallow history.

### `git rebase` — reapply commits (rating 9)
- `-i`, `--interactive` — edit, reorder, squash, or drop commits.
- `--onto <newbase>` — rebase a range onto a specific base.
- `--continue` / `--abort` / `--skip` — drive a rebase in progress.
- `--autosquash` — auto-order `fixup!`/`squash!` commits.
- `--autostash` — stash/unstash around the rebase.

### `git reset` — move HEAD / index (rating 9)
- `--soft` — move `HEAD` only; keep index and working tree.
- `--mixed` (default) — move `HEAD` and reset the index; keep the working tree.
- `--hard` — reset `HEAD`, index, and working tree (destructive).
- `<paths>` — unstage specific paths.

### `git switch` / `git restore` — modern branch/file operations (rating 9)
- `git switch <branch>` — change branches; `-c <name>` creates one.
- `git switch --detach <commit>` — detached `HEAD` checkout.
- `git restore <path>` — restore working-tree files; `--staged` restores the index;
  `--source=<tree>` picks the content source.

## 5. Full method set (alphabetical)

Sorted alphabetically by command name. The **Importance** column is the 1–10
rating from [Section 3](#3-importance-rating-110). The **Purpose** column is the
verbatim upstream `NAME` line.

| Command | Invocation | Importance | Classification | Purpose (upstream NAME line) |
|---|---|:--:|---|---|
| `git-add` | `git add` | 10 | Main porcelain (everyday command) | Add file contents to the index |
| `git-am` | `git am` | 7 | Main porcelain (everyday command) | Apply a series of patches from a mailbox |
| `git-annotate` | `git annotate` | 6 | Ancillary interrogator | Annotate file lines with commit information |
| `git-apply` | `git apply` | 5 | Plumbing manipulator (low-level, write) | Apply a patch to files and/or to the index |
| `git-archimport` | `git archimport` | 2 | Foreign SCM interface | Import a GNU Arch repository into Git |
| `git-archive` | `git archive` | 7 | Main porcelain (everyday command) | Create an archive of files from a named tree |
| `git-backfill` | `git backfill` | 8 | Main porcelain (everyday command) | Download missing objects in a partial clone |
| `git-bisect` | `git bisect` | 8 | Main porcelain (everyday command) | Use binary search to find the commit that introduced a bug |
| `git-blame` | `git blame` | 6 | Ancillary interrogator | Show what revision and author last modified each line of a file |
| `git-branch` | `git branch` | 10 | Main porcelain (everyday command) | List, create, or delete branches |
| `git-bugreport` | `git bugreport` | 6 | Ancillary interrogator | Collect information for user to file a bug report |
| `git-bundle` | `git bundle` | 7 | Main porcelain (everyday command) | Move objects and refs by archive |
| `git-cat-file` | `git cat-file` | 5 | Plumbing interrogator (low-level, read) | Provide contents or details of repository objects |
| `git-check-attr` | `git check-attr` | 2 | Pure helper | Display gitattributes information |
| `git-check-ignore` | `git check-ignore` | 2 | Pure helper | Debug gitignore / exclude files |
| `git-check-mailmap` | `git check-mailmap` | 2 | Pure helper | Show canonical names and email addresses of contacts |
| `git-check-ref-format` | `git check-ref-format` | 2 | Pure helper | Ensures that a reference name is well formed |
| `git-checkout` | `git checkout` | 10 | Main porcelain (everyday command) | Switch branches or restore working tree files |
| `git-checkout-index` | `git checkout-index` | 5 | Plumbing manipulator (low-level, write) | Copy files from the index to the working tree |
| `git-cherry` | `git cherry` | 5 | Plumbing interrogator (low-level, read) | Find commits yet to be applied to upstream |
| `git-cherry-pick` | `git cherry-pick` | 7 | Main porcelain (everyday command) | Apply the changes introduced by some existing commits |
| `git-citool` | `git citool` | 7 | Main porcelain (everyday command) | Graphical alternative to git-commit |
| `git-clean` | `git clean` | 7 | Main porcelain (everyday command) | Remove untracked files from the working tree |
| `git-clone` | `git clone` | 10 | Main porcelain (everyday command) | Clone a repository into a new directory |
| `git-column` | `git column` | 2 | Pure helper | Display data in columns |
| `git-commit` | `git commit` | 10 | Main porcelain (everyday command) | Record changes to the repository |
| `git-commit-graph` | `git commit-graph` | 5 | Plumbing manipulator (low-level, write) | Write and verify Git commit-graph files |
| `git-commit-tree` | `git commit-tree` | 5 | Plumbing manipulator (low-level, write) | Create a new commit object |
| `git-config` | `git config` | 6 | Ancillary manipulator | Get and set repository or global options |
| `git-count-objects` | `git count-objects` | 6 | Ancillary interrogator | Count unpacked number of objects and their disk consumption |
| `git-credential` | `git credential` | 2 | Pure helper | Retrieve and store user credentials |
| `git-credential-cache` | `git credential-cache` | 2 | Pure helper | Helper to temporarily store passwords in memory |
| `git-credential-store` | `git credential-store` | 2 | Pure helper | Helper to store credentials on disk |
| `git-cvsexportcommit` | `git cvsexportcommit` | 2 | Foreign SCM interface | Export a single commit to a CVS checkout |
| `git-cvsimport` | `git cvsimport` | 2 | Foreign SCM interface | Salvage your data out of another SCM people love to hate |
| `git-cvsserver` | `git cvsserver` | 2 | Foreign SCM interface | A CVS server emulator for Git |
| `git-daemon` | `git daemon` | 3 | Repository synchronization | A really simple server for Git repositories |
| `git-describe` | `git describe` | 7 | Main porcelain (everyday command) | Give an object a human readable name based on an available ref |
| `git-diagnose` | `git diagnose` | 6 | Ancillary interrogator | Generate a zip archive of diagnostic information |
| `git-diff` | `git diff` | 10 | Main porcelain (everyday command) | Show changes between commits, commit and working tree, etc |
| `git-diff-files` | `git diff-files` | 5 | Plumbing interrogator (low-level, read) | Compares files in the working tree and the index |
| `git-diff-index` | `git diff-index` | 5 | Plumbing interrogator (low-level, read) | Compare a tree to the working tree or index |
| `git-diff-pairs` | `git diff-pairs` | 5 | Plumbing interrogator (low-level, read) | Compare the content and mode of provided blob pairs |
| `git-diff-tree` | `git diff-tree` | 5 | Plumbing interrogator (low-level, read) | Compares the content and mode of blobs found via two tree objects |
| `git-difftool` | `git difftool` | 6 | Ancillary interrogator | Show changes using common diff tools |
| `git-fast-export` | `git fast-export` | 6 | Ancillary manipulator | Git data exporter |
| `git-fast-import` | `git fast-import` | 6 | Ancillary manipulator | Backend for fast Git data importers |
| `git-fetch` | `git fetch` | 9 | Main porcelain (everyday command) | Download objects and refs from another repository |
| `git-fetch-pack` | `git fetch-pack` | 3 | Repository synchronization | Receive missing objects from another repository |
| `git-filter-branch` | `git filter-branch` | 6 | Ancillary manipulator | Rewrite branches |
| `git-fmt-merge-msg` | `git fmt-merge-msg` | 2 | Pure helper | Produce a merge commit message |
| `git-for-each-ref` | `git for-each-ref` | 5 | Plumbing interrogator (low-level, read) | Output information on each ref |
| `git-for-each-repo` | `git for-each-repo` | 5 | Plumbing interrogator (low-level, read) | Run a Git command on a list of repositories |
| `git-format-patch` | `git format-patch` | 7 | Main porcelain (everyday command) | Prepare patches for e-mail submission |
| `git-format-rev` | `git format-rev` | 5 | Plumbing interrogator (low-level, read) | EXPERIMENTAL: Pretty format revisions on demand |
| `git-fsck` | `git fsck` | 6 | Ancillary interrogator | Verifies the connectivity and validity of the objects in the database |
| `git-gc` | `git gc` | 7 | Main porcelain (everyday command) | Cleanup unnecessary files and optimize the local repository |
| `git-get-tar-commit-id` | `git get-tar-commit-id` | 5 | Plumbing interrogator (low-level, read) | Extract commit ID from an archive created using git-archive |
| `git-grep` | `git grep` | 8 | Main porcelain (everyday command) | Print lines matching a pattern |
| `git-gui` | `git gui` | 7 | Main porcelain (everyday command) | A portable graphical interface to Git |
| `git-hash-object` | `git hash-object` | 5 | Plumbing manipulator (low-level, write) | Compute object ID and optionally create an object from a file |
| `git-help` | `git help` | 6 | Ancillary interrogator | Display help information about Git |
| `git-history` | `git history` | 7 | Main porcelain (everyday command) | EXPERIMENTAL: Rewrite history |
| `git-hook` | `git hook` | 2 | Pure helper | Run Git hooks |
| `git-http-backend` | `git http-backend` | 3 | Repository synchronization | Server side implementation of Git over HTTP |
| `git-http-fetch` | `git http-fetch` | 3 | Synchronization helper | Download from a remote Git repository via HTTP |
| `git-http-push` | `git http-push` | 3 | Synchronization helper | Push objects over HTTP/DAV to another repository |
| `git-imap-send` | `git imap-send` | 2 | Foreign SCM interface | Send a collection of patches from stdin to an IMAP folder |
| `git-index-pack` | `git index-pack` | 5 | Plumbing manipulator (low-level, write) | Build pack index file for an existing packed archive |
| `git-init` | `git init` | 10 | Main porcelain (everyday command) | Create an empty Git repository or reinitialize an existing one |
| `git-instaweb` | `git instaweb` | 6 | Ancillary interrogator | Instantly browse your working repository in gitweb |
| `git-interpret-trailers` | `git interpret-trailers` | 2 | Pure helper | Add or parse metadata in commit messages |
| `git-last-modified` | `git last-modified` | 5 | Plumbing interrogator (low-level, read) | EXPERIMENTAL: Show when files were last modified |
| `git-log` | `git log` | 10 | Main porcelain (everyday command) | Show commit logs |
| `git-ls-files` | `git ls-files` | 5 | Plumbing interrogator (low-level, read) | Show information about files in the index and the working tree |
| `git-ls-remote` | `git ls-remote` | 5 | Plumbing interrogator (low-level, read) | List references in a remote repository |
| `git-ls-tree` | `git ls-tree` | 5 | Plumbing interrogator (low-level, read) | List the contents of a tree object |
| `git-mailinfo` | `git mailinfo` | 2 | Pure helper | Extracts patch and authorship from a single e-mail message |
| `git-mailsplit` | `git mailsplit` | 2 | Pure helper | Simple UNIX mbox splitter program |
| `git-maintenance` | `git maintenance` | 7 | Main porcelain (everyday command) | Run tasks to optimize Git repository data |
| `git-merge` | `git merge` | 10 | Main porcelain (everyday command) | Join two or more development histories together |
| `git-merge-base` | `git merge-base` | 5 | Plumbing interrogator (low-level, read) | Find as good common ancestors as possible for a merge |
| `git-merge-file` | `git merge-file` | 5 | Plumbing manipulator (low-level, write) | Run a three-way file merge |
| `git-merge-index` | `git merge-index` | 5 | Plumbing manipulator (low-level, write) | Run a merge for files needing merging |
| `git-merge-one-file` | `git merge-one-file` | 2 | Pure helper | The standard helper program to use with git-merge-index |
| `git-merge-tree` | `git merge-tree` | 6 | Ancillary interrogator | Perform merge without touching index or working tree |
| `git-mergetool` | `git mergetool` | 6 | Ancillary manipulator | Run merge conflict resolution tools to resolve merge conflicts |
| `git-mktag` | `git mktag` | 5 | Plumbing manipulator (low-level, write) | Creates a tag object with extra validation |
| `git-mktree` | `git mktree` | 5 | Plumbing manipulator (low-level, write) | Build a tree-object from ls-tree formatted text |
| `git-multi-pack-index` | `git multi-pack-index` | 5 | Plumbing manipulator (low-level, write) | Write and verify multi-pack-indexes |
| `git-mv` | `git mv` | 9 | Main porcelain (everyday command) | Move or rename a file, a directory, or a symlink |
| `git-name-rev` | `git name-rev` | 5 | Plumbing interrogator (low-level, read) | Find symbolic names for given revs |
| `git-notes` | `git notes` | 7 | Main porcelain (everyday command) | Add or inspect object notes |
| `git-p4` | `git p4` | 2 | Foreign SCM interface | Import from and submit to Perforce repositories |
| `git-pack-objects` | `git pack-objects` | 5 | Plumbing manipulator (low-level, write) | Create a packed archive of objects |
| `git-pack-redundant` | `git pack-redundant` | 5 | Plumbing interrogator (low-level, read) | Find redundant pack files |
| `git-pack-refs` | `git pack-refs` | 6 | Ancillary manipulator | Pack heads and tags for efficient repository access |
| `git-patch-id` | `git patch-id` | 2 | Pure helper | Compute unique IDs for patches |
| `git-prune` | `git prune` | 6 | Ancillary manipulator | Prune all unreachable objects from the object database |
| `git-prune-packed` | `git prune-packed` | 5 | Plumbing manipulator (low-level, write) | Remove extra objects that are already in pack files |
| `git-pull` | `git pull` | 10 | Main porcelain (everyday command) | Fetch from and integrate with another repository or a local branch |
| `git-push` | `git push` | 10 | Main porcelain (everyday command) | Update remote refs along with associated objects |
| `git-quiltimport` | `git quiltimport` | 2 | Foreign SCM interface | Applies a quilt patchset onto the current branch |
| `git-range-diff` | `git range-diff` | 7 | Main porcelain (everyday command) | Compare two commit ranges (e.g. two versions of a branch) |
| `git-read-tree` | `git read-tree` | 5 | Plumbing manipulator (low-level, write) | Reads tree information into the index |
| `git-rebase` | `git rebase` | 9 | Main porcelain (everyday command) | Reapply commits on top of another base tip |
| `git-receive-pack` | `git receive-pack` | 3 | Synchronization helper | Receive what is pushed into the repository |
| `git-reflog` | `git reflog` | 6 | Ancillary manipulator | Manage reflog information |
| `git-refs` | `git refs` | 6 | Ancillary manipulator | Low-level access to refs |
| `git-remote` | `git remote` | 9 | Ancillary manipulator | Manage set of tracked repositories |
| `git-repack` | `git repack` | 6 | Ancillary manipulator | Pack unpacked objects in a repository |
| `git-replace` | `git replace` | 6 | Ancillary manipulator | Create, list, delete refs to replace objects |
| `git-replay` | `git replay` | 5 | Plumbing manipulator (low-level, write) | EXPERIMENTAL: Replay commits on a new base, works with bare repos too |
| `git-repo` | `git repo` | 5 | Plumbing interrogator (low-level, read) | Retrieve information about the repository |
| `git-request-pull` | `git request-pull` | 2 | Foreign SCM interface | Generates a summary of pending changes |
| `git-rerere` | `git rerere` | 6 | Ancillary interrogator | Reuse recorded resolution of conflicted merges |
| `git-reset` | `git reset` | 9 | Main porcelain (everyday command) | Set `HEAD` or the index to a known state |
| `git-restore` | `git restore` | 9 | Main porcelain (everyday command) | Restore working tree files |
| `git-rev-list` | `git rev-list` | 5 | Plumbing interrogator (low-level, read) | Lists commit objects in reverse chronological order |
| `git-rev-parse` | `git rev-parse` | 5 | Plumbing interrogator (low-level, read) | Pick out and massage parameters |
| `git-revert` | `git revert` | 7 | Main porcelain (everyday command) | Revert some existing commits |
| `git-rm` | `git rm` | 9 | Main porcelain (everyday command) | Remove files from the working tree and from the index |
| `git-send-email` | `git send-email` | 2 | Foreign SCM interface | Send a collection of patches as emails |
| `git-send-pack` | `git send-pack` | 3 | Repository synchronization | Push objects over Git protocol to another repository |
| `git-sh-i18n` | `git sh-i18n` | 2 | Pure helper | Git's i18n setup code for shell scripts |
| `git-sh-setup` | `git sh-setup` | 2 | Pure helper | Common Git shell script setup code |
| `git-shell` | `git shell` | 3 | Synchronization helper | Restricted login shell for Git-only SSH access |
| `git-shortlog` | `git shortlog` | 7 | Main porcelain (everyday command) | Summarize `git log` output |
| `git-show` | `git show` | 9 | Main porcelain (everyday command) | Show various types of objects |
| `git-show-branch` | `git show-branch` | 6 | Ancillary interrogator | Show branches and their commits |
| `git-show-index` | `git show-index` | 5 | Plumbing interrogator (low-level, read) | Show packed archive index |
| `git-show-ref` | `git show-ref` | 5 | Plumbing interrogator (low-level, read) | List references in a local repository |
| `git-sparse-checkout` | `git sparse-checkout` | 7 | Main porcelain (everyday command) | Reduce your working tree to a subset of tracked files |
| `git-stage` | `git stage` | 7 | Main porcelain (everyday command) | Add file contents to the staging area |
| `git-stash` | `git stash` | 9 | Main porcelain (everyday command) | Stash the changes in a dirty working directory away |
| `git-status` | `git status` | 10 | Main porcelain (everyday command) | Show the working tree status |
| `git-stripspace` | `git stripspace` | 2 | Pure helper | Remove unnecessary whitespace |
| `git-submodule` | `git submodule` | 7 | Main porcelain (everyday command) | Initialize, update or inspect submodules |
| `git-svn` | `git svn` | 2 | Foreign SCM interface | Bidirectional operation between a Subversion repository and Git |
| `git-switch` | `git switch` | 9 | Main porcelain (everyday command) | Switch branches |
| `git-symbolic-ref` | `git symbolic-ref` | 5 | Plumbing manipulator (low-level, write) | Read, modify and delete symbolic refs |
| `git-tag` | `git tag` | 9 | Main porcelain (everyday command) | Create, list, delete or verify tags |
| `git-unpack-file` | `git unpack-file` | 5 | Plumbing interrogator (low-level, read) | Creates a temporary file with a blob's contents |
| `git-unpack-objects` | `git unpack-objects` | 5 | Plumbing manipulator (low-level, write) | Unpack objects from a packed archive |
| `git-update-index` | `git update-index` | 5 | Plumbing manipulator (low-level, write) | Register file contents in the working tree to the index |
| `git-update-ref` | `git update-ref` | 5 | Plumbing manipulator (low-level, write) | Update the object name stored in a ref safely |
| `git-update-server-info` | `git update-server-info` | 3 | Repository synchronization | Update auxiliary info file to help dumb servers |
| `git-upload-archive` | `git upload-archive` | 3 | Synchronization helper | Send archive back to git-archive |
| `git-upload-pack` | `git upload-pack` | 3 | Synchronization helper | Send objects packed back to git-fetch-pack |
| `git-url-parse` | `git url-parse` | 2 | Pure helper | Parse and extract git URL components |
| `git-var` | `git var` | 5 | Plumbing interrogator (low-level, read) | Show a Git logical variable |
| `git-verify-commit` | `git verify-commit` | 6 | Ancillary interrogator | Check the GPG signature of commits |
| `git-verify-pack` | `git verify-pack` | 5 | Plumbing interrogator (low-level, read) | Validate packed Git archive files |
| `git-verify-tag` | `git verify-tag` | 6 | Ancillary interrogator | Check the GPG signature of tags |
| `git-version` | `git version` | 6 | Ancillary interrogator | Display version information about Git |
| `git-whatchanged` | `git whatchanged` | 6 | Ancillary interrogator | Show logs with differences each commit introduces |
| `git-worktree` | `git worktree` | 8 | Main porcelain (everyday command) | Manage multiple working trees |
| `git-write-tree` | `git write-tree` | 5 | Plumbing manipulator (low-level, write) | Create a tree object from the current index |
| `scalar` | `scalar` | 7 | Main porcelain (everyday command) | A tool for managing large Git repositories |


## 6. Distribution by importance

| Importance | Count | Representative commands |
|:--:|:--:|---|
| 10 | 12 | `git-add`, `git-commit`, `git-status`, `git-log`, `git-diff`, `git-branch`, `git-checkout`, `git-merge`, `git-init`, `git-clone`, `git-push`, `git-pull` |
| 9 | 11 | `git-fetch`, `git-rebase`, `git-reset`, `git-switch`, `git-restore`, `git-stash`, `git-tag`, `git-remote`, `git-show`, `git-rm`, `git-mv` |
| 8 | 4 | `git-grep`, `git-bisect`, `git-worktree`, `git-backfill` |
| 7 | 20 | `git-am`, `git-clean`, `git-gc`, `git-notes`, `git-submodule`, `git-revert`, `git-cherry-pick`, `scalar`, … |
| 6 | 27 | `git-config`, `git-blame`, `git-fsck`, `git-repack`, `git-reflog`, `git-mergetool`, … |
| 5 | 45 | `git-cat-file`, `git-rev-parse`, `git-rev-list`, `git-update-ref`, `git-ls-files`, `git-pack-objects`, … |
| 3 | 11 | `git-daemon`, `git-upload-pack`, `git-receive-pack`, `git-send-pack`, `git-shell`, … |
| 2 | 29 | `git-credential`, `git-svn`, `git-p4`, `git-send-email`, `git-mailinfo`, `git-hook`, … |

Total: **159 commands** (plus documentation/format/guide pages, which are not
commands and are excluded).

## 7. Continuance

This reference tracks the vendored snapshot. When the Git source is advanced to a
newer upstream release, regenerate this file from the new `command-list.txt` and
`Documentation/git-*.adoc`, and update the snapshot fields in
[Section 2](#2-source-of-truth) so the record stays truthful. The importance
model in [Section 3](#3-importance-rating-110) is stable and can be reapplied
directly to the refreshed inventory.

This document is authored for this repository under the attribution defined in
[`../../HEADINGS.md`](../../HEADINGS.md).
