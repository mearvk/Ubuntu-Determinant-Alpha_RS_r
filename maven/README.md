# Ubuntu White Edition — Maven Workbench

This component provides a carefully controlled integration point for Apache Maven source and builds.

## Why Maven

Apache Maven is a long-established Java build and project-management system centered on the Project Object Model (POM). Its conventions became a practical norm across a large part of the Java ecosystem. The upstream project remains actively maintained; the current upstream `master` line is Maven 4.1.x, while Maven 4.x development releases are explicitly not production-safe until released as stable. Maven is licensed under Apache License 2.0. See the upstream project and official download page for authoritative release information.

## White Edition approach

We should **not silently fork or rewrite Maven's source**. Instead, this repository keeps the upstream source identifiable and adds a safety-oriented experimental layer around it.

The experimental layer should:

1. Pin an explicit upstream revision before source acquisition.
2. Preserve Apache `LICENSE` and `NOTICE` material.
3. Prefer offline execution for repeatable experiments.
4. Use a dedicated local Maven repository/cache rather than a user's normal `~/.m2` repository.
5. Require explicit opt-in before network dependency resolution.
6. Keep experimental patches separate from upstream source.
7. Record source revision, Java version, Maven version, and test results for each experiment.
8. Treat Maven plugins as executable code and therefore as a trust boundary.
9. Avoid automatic upgrades during controlled experiments.
10. Make clean, reversible workspaces the default.

## Source

Upstream source: `https://github.com/apache/maven`

The source-acquisition scripts in `scripts/` clone a pinned upstream revision into a local `upstream/` workspace. This avoids copying a large third-party tree into this repository while preserving a reproducible source origin.

## Important safety note

Maven builds can execute plugin code and can download dependencies. The White Edition wrapper is therefore deliberately conservative, but it is not a security sandbox. Run untrusted builds only inside an operating-system/container sandbox with appropriate filesystem, network, and credential isolation.

## License

Apache Maven is Apache License 2.0. Upstream attribution and notices must remain with any redistributed Maven source.
