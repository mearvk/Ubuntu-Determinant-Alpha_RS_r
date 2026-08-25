# ASYSMA Header v1

The header is fixed-size and deliberately minimal. It identifies the container and locates later sections.

Required logical fields:

```text
magic[6]          = "ASYSMA"
format_major
format_minor
header_size
architecture
flags
manifest_offset
manifest_size
integrity_offset
integrity_size
payload_offset
payload_size
```

## Rules

1. All integer fields have an explicitly defined byte order in the implementation profile.
2. Offsets and sizes are unsigned and must be bounds-checked against the complete file size.
3. Arithmetic must detect overflow before an offset is added to a size.
4. Unknown mandatory flags cause rejection.
5. Unsupported architecture causes rejection before native payload execution.
6. A malformed header never falls through into native code.

The first implementation may use a compact little-endian x86-64 encoding, but the format specification must keep the encoding explicit so a future reader does not infer it.
