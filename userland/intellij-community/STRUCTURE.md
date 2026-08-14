# IntelliJ Community — Structure & Safety Analysis

**Source:** github.com/JetBrains/intellij-community  
**License:** Apache 2.0  
**Document Date:** 2026-08-13  
**Distribution:** Galactic Cherry Marvell Edition 98

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Native Code — Memory Safety](#native-code--memory-safety)
3. [GUI Threading (EDT)](#gui-threading-edt)
4. [Memory Pressure & GC](#memory-pressure--gc)
5. [fsNotifier — Filesystem Watcher](#fsnotifier--filesystem-watcher)
6. [Applied Fixes](#applied-fixes)

---

## Architecture Overview

IntelliJ is a JVM application (Java/Kotlin) with native components for platform-specific operations.

### Process Model

| Component | Language | Role |
|-----------|----------|------|
| IDE JVM | Java/Kotlin | Main process — editor, PSI, indexing, UI |
| fsNotifier | C | External daemon — inotify filesystem watching |
| XPlatLauncher | Rust | IDE launcher, JVM argument resolution |
| Restarter | Rust | IDE restart after updates |
| Repair Utility | Go | IDE self-repair |
| Git subprocess | External | Git operations via `git` CLI |

### Threading Model

| Thread | Role | Blocking Risk |
|--------|------|---------------|
| **EDT (Event Dispatch Thread)** | All Swing UI rendering, paint, input | ANY block freezes the GUI |
| **Read Action threads** | Background indexing, analysis | Block on write lock |
| **Write Action (EDT)** | PSI/VFS mutations, project model changes | Blocks ALL read actions |
| **Application Pool** | General background tasks | Can starve EDT if too many |
| **VFS Refresh** | File system change processing | Requires write action → EDT |
| **Git operations** | Background git calls | Report results via EDT |

### Lock Architecture

```
┌─────────────────────────────────────────────┐
│  WRITE LOCK (exclusive, EDT-only)            │
│  Blocks: all read actions, all write actions │
│  Held by: EDT during VFS refresh, PSI edits │
└──────────────────────┬──────────────────────┘
                       │ blocks
┌──────────────────────┴──────────────────────┐
│  READ LOCK (shared, any thread)              │
│  Blocks: nothing (unless write pending)      │
│  Held by: indexing, analysis, PSI queries    │
└─────────────────────────────────────────────┘
```

**Deadlock vectors:**
- `invokeAndWait()` from a thread holding read lock → EDT needs write lock → dead
- `invokeAndWait()` from write action → EDT re-entrant write → dead
- VFS refresh storm → write lock held long → all read actions stall → pool exhaustion

---

## Native Code — Memory Safety

### Files Audited

| File | Lines | Issues Found |
|------|-------|-------------|
| `native/WslTools/wslproxy.c` | ~200 | 2 HIGH severity |
| `native/WinFsNotifier/fileWatcher3.c` | ~500 | 1 HIGH severity |
| `native/fsNotifier/linux/inotify.c` | ~420 | 2 MEDIUM severity |

### Bug 1: errno Logic Error (wslproxy.c)

**Severity: HIGH — Write retry logic completely broken**

```c
// BEFORE (always-true tautology):
if (errno != EINTR || errno != EAGAIN) { goto end; }

// AFTER (correct — retry on transient errors):
if (errno != EINTR && errno != EAGAIN) { goto end; }
```

**Impact:** Every transient write interruption (EINTR from signal, EAGAIN from full buffer) incorrectly terminates the connection. On systems with high signal activity (timer signals, profiling), socket relay is unreliable.

### Bug 2: malloc Without NULL Check (wslproxy.c)

**Severity: HIGH — NULL dereference crash on OOM**

```c
// BEFORE:
jb_sockpair *pair = malloc(sizeof(jb_sockpair));
pair->src_socket_fd = src_fd;  // ← crash if malloc returns NULL

// AFTER:
jb_sockpair *pair = malloc(sizeof(jb_sockpair));
if (pair == NULL) { perror("malloc failed"); return NULL; }
pair->src_socket_fd = src_fd;
```

### Bug 3: malloc Without NULL Check (fileWatcher3.c)

**Severity: HIGH — NULL dereference crash on OOM**

```c
// BEFORE:
char *newData = (char *)malloc(newSize);
// ... immediately dereferences newData without check

// AFTER:
char *newData = (char *)malloc(newSize);
if (newData == NULL) { return; }
```

### Bug 4: Use-After-Free Ordering (inotify.c)

**Severity: MEDIUM — Defensive fix for correct ordering**

```c
// BEFORE (free before table invalidation):
free(node);
table_put(watches, wd, NULL);

// AFTER (invalidate lookup before free):
table_put(watches, wd, NULL);
free(node);
```

### Bug 5: inotify Watch Exhaustion (inotify.c)

**Severity: MEDIUM — System-wide inotify limit consumed by .git internals**

The `walk_tree` function recursively adds inotify watches to ALL subdirectories. A `.git/objects/` tree with 256 hash-prefix directories × N loose objects can consume the entire system's inotify watch limit (default 8192).

**Fix:** Skip `.git`, `node_modules`, `.hg` directories during recursive watch setup.

---

## GUI Threading (EDT)

### The Freeze Chain

IntelliJ's GUI freezes follow a predictable pattern:

```
Git checkout / branch switch
    │
    ├──► fsNotifier receives flood of inotify events
    │    (thousands of file creates/deletes/modifies)
    │
    ├──► VFS refresh batches these into a write action
    │    (single write action for entire batch)
    │
    ├──► Write lock acquired on EDT
    │    │
    │    ├──► ALL read actions blocked (indexing, analysis, find)
    │    ├──► EDT processes VFS events one by one
    │    ├──► For large git operations: 10,000+ events
    │    └──► EDT blocked for seconds processing events
    │
    └──► During this time:
         - No UI painting
         - No keyboard/mouse input processed
         - No code completion responses
         - IDE appears frozen
```

### EDT Protection Mechanisms (Existing)

| Mechanism | What It Does | Limitation |
|-----------|-------------|------------|
| `PotemkinProgress` | Shows fake progress dialog during EDT block | Doesn't prevent the block |
| `PerformanceWatcherImpl` | Detects freeze, dumps threads | Forensic only, no prevention |
| `LowMemoryWatcher` | Fires on GC overload | Can cause MORE EDT work (cache eviction) |
| `executeByImpatientReader` | Throws instead of blocking on write lock | Caller must handle exception |
| `NonBlockingReadAction` | Restartable read that yields to write | Only for new code patterns |

### Key Risk: `invokeAndWait` Deadlock Windows

```java
// SAFE: Background thread calling invokeAndWait (no locks held)
ApplicationManager.getApplication().invokeAndWait(() -> { ... });

// DEADLOCK: invokeAndWait from inside a read action
// EDT may need write lock → waits for read to release → read waits for EDT
ApplicationManager.getApplication().runReadAction(() -> {
    SwingUtilities.invokeAndWait(() -> updateUI());  // ← DEADLOCK
});
```

IntelliJ has runtime checks that throw `IllegalStateException` for the most obvious cases (line 616, 621 of `ApplicationImpl.java`), but edge cases remain.

---

## Memory Pressure & GC

### GC-Induced Freezes

The JVM garbage collector causes stop-the-world (STW) pauses that freeze ALL threads including EDT:

| GC Type | Typical STW Duration | Impact |
|---------|---------------------|--------|
| Young GC (G1) | 5-50ms | Usually imperceptible |
| Mixed GC (G1) | 50-200ms | Noticeable micro-stutter |
| Full GC | 500ms-5s | Complete IDE freeze |
| Concurrent mark abort → Full GC | 2-10s | Long freeze, often during indexing |

### Memory Pressure Detection

IntelliJ's `LowMemoryWatcherManager` monitors:
- GC load: If GC consumes >15% of CPU over 90s window → system overloaded
- Memory threshold: 95% heap utilization → trigger cache eviction
- Regular polling every 15s for gradual pressure detection
- Throttling: Same-priority events suppressed within 300ms

### Cache Eviction Cascade

When low memory fires, caches evict:
- PSI element cache (parsed syntax trees)
- Virtual file system caches
- Stub index caches
- Completion item caches

**Problem:** After eviction, the NEXT access to any evicted item must recompute it. If that happens on EDT (e.g., painting needs PSI for syntax highlighting), it causes a micro-freeze. Many such micro-freezes in succession = perceived hang.

---

## fsNotifier — Filesystem Watcher

### Communication Protocol

```
IDE (Java)                          fsNotifier (C)
    │                                    │
    │──── ROOTS [paths] #  ────────────►│  Set watch roots
    │                                    │
    │◄──── CHANGE /path ─────────────────│  File changed
    │◄──── CREATE /path ─────────────────│  File created
    │◄──── DELETE /path ─────────────────│  File deleted
    │◄──── DIRTY /path ──────────────────│  Directory dirty
    │◄──── RECDIRTY /path ───────────────│  Recursive dirty
    │◄──── RESET ────────────────────────│  Overflow — full rescan needed
    │                                    │
    │──── EXIT ─────────────────────────►│  Shutdown
```

### Freeze Vectors via fsNotifier

| Vector | Mechanism | Impact |
|--------|-----------|--------|
| Event flood | Git checkout generates thousands of events | VFS write lock held for seconds |
| Process stall | fsNotifier blocked on inotify read | VFS changes not delivered → stale state |
| Process death | fsNotifier crashes (OOM, bug) | 500ms restart timeout × 10 retries |
| Watch exhaustion | .git fills inotify limits | RESET event → full VFS rescan (expensive) |
| Pipe buffer full | IDE not reading fast enough | `writeLine()` blocks in fsNotifier → events queued |
| RESET storm | inotify queue overflow (`IN_Q_OVERFLOW`) | Triggers RESET → full recursive rescan |

### git + fsNotifier Interaction

During `git checkout`:
1. Git writes/deletes hundreds of files in rapid succession
2. fsNotifier's inotify receives events for ALL of them
3. If `.git/` is watched, internal git operations (pack, index) also generate events
4. Events flood the pipe to the IDE
5. IDE batches them into a single VFS refresh (write action)
6. Write action on EDT processes all events sequentially
7. **EDT frozen for the entire duration**

---

## Applied Fixes

### Fix 1: wslproxy.c — errno Logic Bug

**File:** `native/WslTools/wslproxy.c`  
**Line:** ~132  
**Change:** `||` → `&&` + `continue` for retry  
**Impact:** Socket relay now correctly retries on EINTR/EAGAIN instead of immediately terminating

### Fix 2: wslproxy.c — malloc NULL Check

**File:** `native/WslTools/wslproxy.c`  
**Line:** ~167  
**Change:** Added `if (pair == NULL) { perror(...); return NULL; }`  
**Impact:** Prevents NULL dereference crash under memory pressure

### Fix 3: fileWatcher3.c — malloc NULL Check

**File:** `native/WinFsNotifier/fileWatcher3.c`  
**Line:** ~52  
**Change:** Added `if (newData == NULL) { return; }`  
**Impact:** Prevents NULL dereference crash in Windows file watcher buffer growth

### Fix 4: inotify.c — Use-After-Free Ordering

**File:** `native/fsNotifier/linux/inotify.c`  
**Line:** ~209  
**Change:** `table_put(watches, wd, NULL)` moved BEFORE `free(node)`  
**Impact:** Prevents potential dangling pointer access via table lookup

### Fix 5: inotify.c — .git Directory Skip

**File:** `native/fsNotifier/linux/inotify.c`  
**Line:** ~258  
**Change:** Added skip for `.git`, `node_modules`, `.hg` in `walk_tree` directory iteration  
**Impact:** Prevents inotify watch exhaustion and event flooding during git operations

### Summary of Changed Files

| File | Change | Severity |
|------|--------|----------|
| `native/WslTools/wslproxy.c` | errno logic fix + malloc NULL check | HIGH |
| `native/WinFsNotifier/fileWatcher3.c` | malloc NULL check | HIGH |
| `native/fsNotifier/linux/inotify.c` | Use-after-free fix + .git skip | MEDIUM |

---

*Document generated for Galactic Cherry Marvell Edition 98.*
