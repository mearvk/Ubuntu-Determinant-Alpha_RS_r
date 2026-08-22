# OpenJDK 28 — MEARVK Custom Build

OpenJDK 28 Early Access (tag jdk-28+8) with MEARVK LLC runtime extensions.

- Source: https://github.com/openjdk/jdk (tag: jdk-28+8)
- License: GPL-2.0 with Classpath Exception
- Trimmed: `test/` directory removed (saves 426MB, not needed for build)

---

## Architecture: Front-End → Interpreter → JDK

The execution path from Java source code through to the underlying JDK runtime:

```
┌──────────────────────────────────────────────────────────────────────┐
│  JAVA SOURCE (.java)                                                  │
│  └─ javac (jdk.compiler/jvm/Gen.java, ByteCodes.java)                │
│     └─ Bytecodes (.class files)                                       │
└──────────────────────────────────────────────────────────────────────┘
        │
        ▼
┌──────────────────────────────────────────────────────────────────────┐
│  JVM STARTUP                                                          │
│  arguments.cpp → xmlConfigReader.cpp                                  │
│    1. Parse command-line flags                                         │
│    2. Load XML config (find_default_config → read_config)             │
│    3. apply_entries() → Arguments::parse_argument()                    │
│    4. Initialize custom runtime components (see below)                │
└──────────────────────────────────────────────────────────────────────┘
        │
        ▼
┌──────────────────────────────────────────────────────────────────────┐
│  CUSTOM RUNTIME INITIALIZATION (in order)                             │
│                                                                       │
│  1. JvmIntegrity    — OS-level anti-hook, strict dlopen menu,         │
│                       1:1/1:2 allocation ratios only                   │
│  2. JvmInspector    — Pause-frame inspection, class history tracking  │
│  3. JvmCircuit      — Observer grade circuits (SSH/telnet/socket)     │
│  4. JvmResourceLoader — Secure file loading (C, S, HPP, JSON, XML)   │
│  5. JvmCodex        — In-resident static module registry              │
│  6. JvmMySQLBridge  — Secure database bridge for operand awareness    │
└──────────────────────────────────────────────────────────────────────┘
        │
        ▼
┌──────────────────────────────────────────────────────────────────────┐
│  CLASS LOADING                                                        │
│  SystemDictionary::load_instance_class()                              │
│    └─ ClassLoadGuard::allow_class_load()                              │
│       - Quantity ceiling enforcement                                   │
│       - Quality grading (Main/Manager/Archetype/.../Substitute)       │
│       - Policy: WARN or REFUSE                                        │
└──────────────────────────────────────────────────────────────────────┘
        │
        ▼
┌──────────────────────────────────────────────────────────────────────┐
│  INTERPRETER / JIT                                                    │
│  - Template Interpreter executes bytecodes                            │
│  - C2 JIT compiler (x86.ad machine description)                       │
│    └─ MachVEPNode (Valhalla inline type entry point — stub)           │
│  - CDS/AOT: lambdaFormInvokers for shared archive optimization        │
│  - JVMTI: can_support_value_objects capability (since JDK 28)         │
└──────────────────────────────────────────────────────────────────────┘
```

---

## Custom Components

### xmlConfigReader (`runtime/xmlConfigReader.cpp`)
Secure XML-based JVM flag configuration. Loaded during `Arguments::parse_vm_init_args()`.

- File permission validation (root or launching user ownership required)
- No world-writable files accepted
- Maximum 64KB config size, 256 entries max
- No external XML entities (security hardening)
- Calls `Arguments::parse_argument()` and `Arguments::add_property()` directly

**XML format:**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<jvm-config version="1" signature="sha256:...">
  <flags>
    <flag name="MaxHeapSize" value="4g"/>
    <flag name="UseG1GC" value="true"/>
  </flags>
  <system-properties>
    <property name="java.io.tmpdir" value="/var/tmp/jvm"/>
  </system-properties>
  <classpath>
    <entry path="/opt/app/lib/*"/>
  </classpath>
</jvm-config>
```

### JvmIntegrity (`runtime/jvmIntegrity.cpp`)
OS-level security guardian. Strict "menu loading" — only authorized library paths can be dlopened.

- Authorized prefixes: `/usr/lib/jvm/`, `/lib/x86_64-linux-gnu/`, `/usr/lib/`, `/opt/app/lib/`
- Canary-based memory corruption detection
- Agent locking (prevents late-attach of rogue agents)
- 1:1 or 1:2 allocation ratio discipline

### ClassLoadGuard (`classfile/classLoadGuard.cpp`)
Quantity/quality safety for class loading. Integrates directly with `SystemDictionary`.

- Global class count ceiling (configurable, unlimited by default)
- Quality grades: Main(7), Manager(6), Archetype(5), Builder(4), Inheritor(3), Gainer(2), Substitute(1), Ungraded(0)
- Policy modes: WARN (log only) or REFUSE (throw ClassNotFoundException)
- Spinlock-protected statistics per grade level

### JvmCircuit (`runtime/jvmCircuit.cpp`)
Observer-grade circuits for remote JVM monitoring.

- SSH listener (port 2222), telnet (port 2223, off by default), Unix socket
- Carrier-chain linking across multiple JVMs
- Grading reports for system-purpose analysis
- Session management with observer authentication

### JvmInspector (`runtime/jvmInspector.cpp`)
Pause-frame inspection for loaded classes and runtime state.

### JvmCodex (`runtime/jvmCodex.cpp`)
In-resident static module registry with `ICodexAware` interface.

### JvmMySQLBridge (`runtime/jvmMySQLBridge.cpp`)
Secure database bridge for operand awareness — allows the JVM to query MySQL for configuration and state without going through JDBC class loading overhead.

### JvmResourceLoader (`runtime/jvmResourceLoader.cpp`)
Secure native file loading for C headers, shader files, HPP, JSON, and XML at the JVM level (before classloading is fully operational).

---

## Valhalla / Value Types Status

JDK 28 includes Valhalla preparatory APIs. This build provides **stubs only**:

- `MachVEPNode::emit()` — empty implementation (no inline types generated)
- `can_support_value_objects` — JVMTI capability declared (since 28)
- `ValueClass.c` native — **removed** (not needed without full Valhalla)

**Known issue:** In `jvmtiManageCapabilities.cpp`, the `can_support_value_objects` increment block is incorrectly nested inside the `can_support_virtual_threads` block (lines 278–283). Non-critical since value types aren't used, but should be fixed for correctness.

---

## Build

```bash
cd userland/java/openjdk-28-src
bash configure --with-boot-jdk=/path/to/jdk-27
make images
```

The built JDK will be in `build/linux-x86_64-server-release/images/jdk/`.

Requires a boot JDK (JDK N-1). JDK 27 or 26 works.

### CUPS Sysroot

A local CUPS sysroot is provided at `userland/java/sysroot/usr/include/cups/raster.h` for builds on systems without CUPS development headers installed.

---

## Recent Build Fixes (Aug 2, 2026)

1. **x86.ad API updates** — Removed deprecated `MachNode::size()` overrides, aligned with JDK 28 `MachNode::emit_size()` API
2. **CDS obj_at/object_size refactoring** — `objArrayOop` access via `.inline.hpp`, explicit handle wrapping
3. **AtomicAccess migration** — ClassLoadGuard and custom components moved from `Atomic::cmpxchg()` to `AtomicAccess::cmpxchg()`
4. **Valhalla stubs** — `MachVEPNode` emit/format, `can_support_value_objects` capability field in jvmti.xml
5. **Arguments API access** — `XmlConfigReader` declared as friend class; `parse_argument()` and `add_property()` made accessible
6. **CUPS sysroot** — Added `raster.h` stub to satisfy configure check

---

## File Layout

```
src/
├── hotspot/                          # HotSpot JVM (C++)
│   ├── cpu/x86/x86.ad               # x86 machine description (JIT)
│   ├── share/
│   │   ├── classfile/
│   │   │   ├── classLoadGuard.cpp    # ★ Class loading safety
│   │   │   ├── classLoadGuard.hpp
│   │   │   └── systemDictionary.cpp  # ClassLoadGuard integration point
│   │   ├── prims/
│   │   │   ├── jvmti.xml            # JVMTI capability definitions
│   │   │   └── jvmtiManageCapabilities.cpp
│   │   ├── runtime/
│   │   │   ├── arguments.cpp         # JVM startup (initializes all custom components)
│   │   │   ├── arguments.hpp
│   │   │   ├── xmlConfigReader.cpp   # ★ XML config → JVM flags
│   │   │   ├── xmlConfigReader.hpp
│   │   │   ├── jvmIntegrity.cpp      # ★ OS-level security
│   │   │   ├── jvmIntegrity.hpp
│   │   │   ├── jvmCircuit.cpp        # ★ Observer circuits
│   │   │   ├── jvmCircuit.hpp
│   │   │   ├── jvmCodex.cpp          # ★ Module registry
│   │   │   ├── jvmCodex.hpp
│   │   │   ├── jvmInspector.cpp      # ★ Pause-frame inspection
│   │   │   ├── jvmInspector.hpp
│   │   │   ├── jvmMySQLBridge.cpp    # ★ Database bridge
│   │   │   ├── jvmMySQLBridge.hpp
│   │   │   ├── jvmResourceLoader.cpp # ★ Secure file loading
│   │   │   └── jvmResourceLoader.hpp
│   │   ├── cds/
│   │   │   └── lambdaFormInvokers.cpp # CDS shared archive
│   │   └── oops/
│   │       ├── objArrayOop.hpp
│   │       └── objArrayOop.inline.hpp
│   └── ...
├── java.base/                         # Core Java library
├── jdk.compiler/                      # javac (front-end)
│   └── share/classes/com/sun/tools/javac/jvm/
│       ├── Gen.java                   # Bytecode generation
│       └── ByteCodes.java             # Bytecode definitions
└── ...

make/                                  # Build system (GNU Make + autoconf)
```

★ = MEARVK custom component

---

*Copyright (C) 2026 MEARVK LLC*
*Author: Maximilian Eric Alexander Rupplin von Keffikon*
