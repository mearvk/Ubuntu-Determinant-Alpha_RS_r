# White Edition Experimental Maven Contract

## Default posture

Maven is a build orchestrator, not a passive compiler. A Maven build can invoke plugins and resolve artifacts, so an experimental environment must treat both the build file and its plugin/dependency graph as executable input.

## Required controls

### 1. Isolation

Run experiments in a disposable workspace. Do not expose SSH keys, cloud credentials, signing keys, production source, or personal Maven credentials to an untrusted build.

### 2. Network

The first experiment should be offline (`mvn -o`) against a deliberately prepared local repository. Network access should be an explicit experiment setting, not an implicit default.

### 3. Dependency cache

Use a dedicated `-Dmaven.repo.local=<experiment-cache>` directory. Never make the White Edition experiment cache the user's ordinary Maven repository by default.

### 4. Reproducibility

Record:

- Maven version
- exact upstream Git revision
- Java version and vendor
- operating system and architecture
- POM/project revision
- local repository/cache location
- command line
- test result

### 5. Change discipline

Keep upstream Maven source unmodified. Put White Edition changes in a separate patch layer or wrapper. This makes comparison with Apache Maven straightforward and keeps upstream provenance clear.

### 6. Upgrade discipline

Do not use `master` as a production dependency. The acquisition scripts use it only as a convenient source-development default; a release build should replace it with an exact tag or commit and record that immutable revision.

### 7. Plugin trust

Do not assume that a plugin is safe merely because the POM is declarative. Plugin execution is code execution. Review plugin coordinates, versions, provenance, and permissions before running unfamiliar builds.

## Proposed White Edition modes

- **Observe:** inspect the POM and dependency graph; no build execution.
- **Offline:** execute only against an approved local repository.
- **Network-approved:** permit dependency retrieval only after explicit approval.
- **Sandboxed:** run the experiment inside an OS/container sandbox with restricted filesystem and network access.

The desired default is **Observe**, followed by **Offline** for experiments.

## Upstream relationship

This layer is an integration and experimental-safety contract around Apache Maven; it is not represented as an Apache Maven project or as an official Apache Software Foundation security boundary.
