# ASYSMA Format v0.1

The rehearsal format uses a ZIP-compatible container with a required manifest and signature material.

```text
package.asysma
  META-INF/ASYSMA.MF
  META-INF/ASYSMA.SIG
  META-INF/ASYSMA.PUB
  payload/...
```

## Required manifest fields

```text
format=ASYSMA-0.1
package-id=<stable identifier>
package-version=<semantic version>
entrypoint=<relative path>
target-platform=<linux|windows|macos|any>
target-architecture=<x86_64|aarch64|any>
minimum-java=<major version>
permissions=<comma-separated ordered set>
```

The manifest also contains one `sha384` record for every payload file. Paths are UTF-8, forward-slash separated, relative, normalized, and must not contain `..` or absolute roots.

## Signature

The signature covers the canonical manifest bytes plus the ordered payload digest records. The public key is carried separately and is itself authenticated by the deployment trust policy.

The package must fail closed on malformed fields, duplicate paths, digest mismatch, unsupported algorithms, or signature failure.
