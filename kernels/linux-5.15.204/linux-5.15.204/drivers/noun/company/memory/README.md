# Memory — Noun Recognition

**Tuple:** `(Memory, Company)`

Recognize memory devices/controllers by type, then company, then exact device/family and generation. Typical kernel relationships include memory controllers, ECC, NUMA, persistent memory, and platform-specific memory devices.

## Review path
`Memory → company → controller/device → identifier → kernel subsystem → verification`

Company association requires concrete source/device evidence. Preserve upstream attribution and licensing.

**Project attention:** Max Rupplin — MEARVK LLC — 2026.