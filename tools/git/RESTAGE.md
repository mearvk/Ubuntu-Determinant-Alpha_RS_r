# Native Restage

`restage` is a systems-oriented index-frame operation with two related histories.

## Two levels

1. **Base commit chain** — ordinary Git history (`C1`, `C2`, `C3`, ...). Git object identity and graph ancestry remain authoritative.
2. **Administrative restage chain** — an ordered history of restage observations (`A1`, `A2`, `A3`, ...). Each event records the function call and its surrounding execution data.

The administrative chain references the base commit frame it observed. The base chain does not become subordinate to the administrative chain.

## Relative movement

`restage N` records a relative integer movement of the commit/index frame:

- `restage -2` moves two positions backward.
- `restage +2` moves two positions forward where the selected linear base history makes the target unambiguous.
- `restage 0` records the current frame without relative movement.

A `-2` followed by `+2` is a two-operation round trip. Both observations remain in the administrative chain even though the final index frame returns to the starting frame. A four-movement observation sequence may therefore inspect backward and forward positions without erasing the recorded calls.

Positive movement must use a deterministic, explicitly selected linear history; arbitrary descendant selection in a merge DAG is not permitted.

## Actual index

Restage is not merely an external report. Its selected base commit tree is intended to become the actual Git index state. The working tree is preserved by default. An implementation must validate the target and refuse unsafe index replacement rather than silently discard staged or working-tree changes.

## Saved call context

Each restage event records, at minimum:

- exact function/command call and argument;
- administrative chain ID and administrative parent;
- base commit before and after;
- index state before and after;
- relative offset and direction;
- observation sequence;
- Git author, committer, date, and timestamp;
- parent commit and prior operation;
- relevance marker.

The durable record is committed into Git state; a `.logic` representation may make the chain human-readable, while a `.metadoc` may carry the surrounding structured record.

## `restage chains`

`restage chains` correlates the two histories without rewriting either one. It can show which administrative observation selected which base commit/index frame and preserve round trips as historical events.

The command is an inspection/correlation operation, not an implicit rebase.

## Integrity rule

The base Git commit graph remains authoritative. Administrative records explain observations and deliberate index reseating; they do not manufacture commits, alter ancestry, or silently rewrite history.
