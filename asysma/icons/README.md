# ASYSMA Icon Identity

## Origin

The **CMD icon family came first**. The established source artwork is:

`icons/cmd/cmd/cmd-icon-four-trimmed-transparent-v2.zip`

This CMD artwork is the original visual identity for the command/Java launcher program.

## ASYSMA initialization

For the initial ASYSMA implementation, the **same CMD icon set is reused unchanged** for `.asysma` executables and launchers.

This is an intentional identity inheritance:

```text
CMD / Java launcher (original)
        │
        ▼
Canonical CMD icon set
        │
        ▼
Initial ASYSMA executable icon
        │
        ├── Linux
        ├── Windows
        └── macOS
```

The ASYSMA project does not replace, redesign, or reinterpret the original artwork during this initial stage.

## Packaging rule

Platform packaging may convert the source artwork into the native icon representation required by the target OS (`.ico`, `.icns`, desktop icon assets, etc.), but the source visual identity remains the CMD icon family.

## Provenance

The source archive remains in the repository at:

`/icons/cmd/cmd/cmd-icon-four-trimmed-transparent-v2.zip`

Future ASYSMA icon revisions should preserve this provenance and explicitly document any departure from the original CMD identity.
