# Git Tooling

This directory contains small, self-contained Bash tooling for working with Git in the Ubuntu Determinant build and source-management environment.

## `pull-source.sh`

`pull-source.sh` provides a safe, reproducible wrapper for acquiring a Git repository into a local source directory.

Design goals:

- Do not require interactive username/password prompts for public repositories.
- Use HTTPS by default.
- Disable configured Git credential helpers unless the caller explicitly opts in.
- Support a pinned branch, tag, or commit through `GIT_SOURCE_REF`.
- Support shallow clones for build environments through `GIT_CLONE_DEPTH`.
- Keep downloaded source separate from our customization/offset layers.
- Fail rather than silently continue when the source cannot be obtained.
- Record the resolved source commit in `.source-commit`.

Example:

```bash
./tools/git/pull-source.sh \
  https://github.com/example/project.git \
  /path/to/source
```

Optional environment variables:

```text
GIT_SOURCE_REF=main
GIT_CLONE_DEPTH=1
GIT_ALLOW_CREDENTIAL_HELPER=0
```

## `verify-source.sh`

`verify-source.sh` is a read-only provenance and cleanliness check for a source tree acquired by `pull-source.sh`.

It verifies:

- the destination is a Git repository;
- `HEAD` can be resolved;
- when `.source-commit` exists, it exactly matches `HEAD`;
- an optional expected branch/ref exists locally;
- the tracked working tree has no modifications; and
- no untracked files are present.

Example:

```bash
./tools/git/verify-source.sh /path/to/source main
```

A successful run ends with `Result: VERIFIED`. A missing `.source-commit` is reported as a warning because the tree can still be checked for cleanliness, but its acquisition provenance cannot be independently verified.

## `push-safe.sh`

`push-safe.sh` is the guarded push entry point for repository changes. It estimates the new Git object payload before invoking `git push` and refuses the operation when that estimate exceeds **200 MiB (209,715,200 bytes)**.

The guard is deliberately pre-push: when the limit is exceeded, no `git push` is attempted. The default limit can be overridden for controlled environments with `GIT_PUSH_MAX_BYTES`, but the repository policy is 200 MiB unless an explicit operational exception is made.

Example:

```bash
./tools/git/push-safe.sh origin main
```

The payload estimate is based on the sizes of objects reachable from the local source ref and not already advertised by the selected remote. It is a conservative local estimate rather than an exact network wire-size prediction because Git transport may delta-compress objects.

The helper reports the remote, refspec, object count, estimated payload, and configured limit before proceeding. A rejected push ends with `No git push was attempted.`

## Repository policy

These tools are infrastructure, not application source. They should remain independent of GNOME, MATE, Ubuntu White Edition, and individual upstream projects so they can be reused by the ISO build system.

Source acquisition, verification, and push are intentionally separate operations: acquisition obtains and records a source snapshot; verification independently checks that snapshot before it is consumed; the guarded push path prevents an oversized object transfer from being attempted.
