# ICC — Legal Standings documents

**Project:** Ubuntu Determinant
**Edition:** Ubuntu White Edition
**Project attention:** Max Rupplin — MEARVK LLC — 2026
**Status:** Folder established — awaiting lossless upload of the original `.docx` files

---

## Purpose

This folder holds the ICC Legal Standings documents:

1. **ICC Legal Standings 1**
2. **ICC Legal Standings 2**
3. **ICC Legal Standing 3**

## Current state (important)

The original files are Microsoft Word `.docx` documents (Office Open XML — ZIP
archives of binary parts). They have **not yet been added in their exact form.**
An earlier attempt to transfer them by pasting their contents as chat text was
**lossy**: pasting binary as text replaces bytes it cannot represent with the
Unicode replacement character (U+FFFD), which permanently destroys those bytes.
Because a `.docx` is a ZIP with a CRC-32 checksum over each part's exact bytes,
even a single altered byte makes the file fail to open. The pasted version could
therefore not be preserved and was intentionally **not** committed.

The three files below are **placeholders** until the intact originals are added.

## How to add the exact documents (lossless)

Provide each document as **base64** so the exact bytes survive transfer:

```sh
base64 "ICC Legal Standings 1.docx" > icc1.b64
base64 "ICC Legal Standings 2.docx" > icc2.b64
base64 "ICC Legal Standing 3.docx"  > icc3.b64
```

Send the `.b64` text; it is plain ASCII and transfers without corruption. The
exact original bytes will be decoded and committed as:

- `ICC/ICC-Legal-Standings-1.docx`
- `ICC/ICC-Legal-Standings-2.docx`
- `ICC/ICC-Legal-Standing-3.docx`

Integrity can then be verified by comparing SHA-256 sums against the originals.

Alternatively, paste the **readable text** of each document and it will be stored
as clean Markdown (`ICC/ICC-Legal-Standings-1.md`, etc.) instead.

## Note

Placement in this repository does not assert any official ICC status or
endorsement; these are documents supplied by the requester for storage.
