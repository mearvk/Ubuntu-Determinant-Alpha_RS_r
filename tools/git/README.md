# Git Tooling

This directory contains small, self-contained tooling for working with Git in the Ubuntu Determinant build and source-management environment.

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

## `verify-source.sh`

`verify-source.sh` is a read-only provenance and cleanliness check for a source tree acquired by `pull-source.sh`.

It verifies:

- the destination is a Git repository;
- `HEAD` can be resolved;
- when `.source-commit` exists, it exactly matches `HEAD`;
- an optional expected branch/ref exists locally;
- the tracked working tree has no modifications; and
- no untracked files are present.

## Native push policy

Push-size enforcement is implemented in the native Git source rather than as a Bash wrapper.

`git push` now enters a guarded front-end in `git/push-budget.h` for builtin push callers. The policy uses the actual Git ref/object graph to determine the candidate local tips selected by the push refspec, obtains the remote's advertised tips, and asks Git's own `rev-list` object traversal to calculate the disk usage of objects reachable from the candidate tips but not already reachable from the remote tips.

The default maximum is a compiled **200 MiB (209,715,200 bytes)** per push effort:

```text
GIT_PUSH_MAX_BYTES = 200 MiB
```

When the calculated object budget exceeds that ceiling, the push is rejected before the normal transport push is entered. No shell wrapper or environment-variable override is required. Dry runs perform the same analysis so a user can see whether the corresponding real push would fit the policy.

The calculation deliberately operates on commits, refs, and Git objects rather than summing working-tree files. Multiple selected refs are considered together and shared reachable objects are naturally deduplicated by Git's revision/object traversal. Remote object reachability is used as the exclusion set, so objects already represented by advertised remote refs do not count toward the new-object budget.

The measured value is an on-disk object-size estimate, not a prediction of the final network packet size. Git transport compression can change the wire size; the 200 MiB policy therefore acts as a conservative pre-transfer object budget.

The underlying upstream `transport_push()` implementation remains responsible for normal ref matching, hooks, status reporting, transport selection, negotiation, and actual transfer. The native policy is a front-end safety decision before that operation.

## Repository policy

These tools are infrastructure, not application source. They should remain independent of GNOME, MATE, Ubuntu White Edition, and individual upstream projects so they can be reused by the ISO build system.

Source acquisition, verification, and push are separate stages: acquisition obtains and records a source snapshot; verification independently checks that snapshot; native push policy evaluates the object graph before transport and prevents an oversized push effort from being attempted.
