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

For private repositories, credentials should be supplied through the build environment's normal secure Git configuration rather than being written into this script or committed to the repository.

## Repository policy

This tool is infrastructure, not application source. It should remain independent of GNOME, MATE, Ubuntu White Edition, and individual upstream projects so it can be reused by the ISO build system.
