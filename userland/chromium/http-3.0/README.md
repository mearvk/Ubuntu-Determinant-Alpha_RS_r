# HTTP 3.0 — Chromium Additional I/O Pane

## Status

**Specification / design stage.** This directory defines a project-specific **HTTP 3.0 UI and I/O specification**. It does not redefine the IETF HTTP/3 protocol.

The existing Internet standard is HTTP/3, specified by RFC 9114, which maps HTTP semantics onto QUIC. QUIC provides multiplexed streams, flow control, connection migration, and integrated TLS 1.3 negotiation. citeturn0search0turn0search2

The project name `HTTP 3.0` is therefore treated as a **UI/I/O feature designation** unless and until a separate wire-protocol specification is deliberately created. It MUST NOT claim wire compatibility with a hypothetical new HTTP protocol merely because the directory is named `http-3.0`.

## Chromium UI geometry

The White Edition Chromium layout is:

```text
┌───────────────────────────────────────────────────────────────┐
│ tabs                                                          │
├───────────────────────────────────────────────────────────────┤
│ URL / omnibox                                      ≈ 100%     │
├───────────────────────────────────────────────────────────────┤
│ secondary tasking / HTTP I/O bar                    ≈ 80%     │
├───────────────────────────────────────────────────────────────┤
│                                                               │
│ web content                                                   │
│                                                               │
└───────────────────────────────────────────────────────────────┘
```

The **secondary tasking bar is approximately 80% of the usable width of the URL input pane**. It is not required to span the entire browser width. The remaining horizontal area is reserved for balancing, status, window controls, or future White Edition controls.

The 80% value is a design target rather than a hard-coded device pixel measurement. Responsive layout MUST calculate the actual width from the current omnibox/content geometry.

## Additional I/O information pane

The secondary bar is the visible control surface for the project's additional HTTP I/O information model. It should expose information without replacing Chromium's normal navigation controls.

Recommended fields:

| Field | Purpose |
|---|---|
| Protocol | Display negotiated application protocol, e.g. `h3`. |
| Transport | Display QUIC transport state/version where available. |
| Connection | Connection state and reuse status. |
| Stream | Active request/response stream information. |
| Security | TLS/security state without exposing secrets. |
| Origin | Current origin/authority. |
| Latency | Coarse request/connection timing. |
| Transfer | Request/response byte counters. |
| Flow | High-level flow-control/congestion state when safely available. |
| Cache | Relevant cache/result status. |
| Errors | Human-readable connection/protocol errors. |
| Activity | Current request, response, idle, reconnecting, or failed state. |

Sensitive cryptographic material, cookies, authorization credentials, session tickets, private keys, raw secret headers, and equivalent secret values MUST NOT be displayed in this pane.

## HTTP/3 interoperability baseline

The pane should model the established HTTP/3 vocabulary rather than inventing incompatible transport semantics:

- HTTP/3 uses QUIC.
- HTTP/3 support is negotiated with the `h3` ALPN identifier.
- HTTP/3 uses QUIC streams for request/response exchanges.
- HTTP/3 uses QPACK for field compression rather than HTTP/2 HPACK.
- HTTP/3 uses SETTINGS on the HTTP control stream.
- HTTP/3 may be advertised through `Alt-Svc`.

These are protocol facts from RFC 9114, not project-specific inventions. citeturn0search0

## I/O state model

The UI should derive its state from an internal read-only observation model:

```text
network event
     ↓
protocol observer
     ↓
normalized I/O state
     ↓
Chromium UI model
     ↓
secondary tasking bar
```

The presentation layer MUST NOT directly mutate transport state merely by rendering an indicator.

Suggested states:

```text
IDLE
RESOLVING
CONNECTING
NEGOTIATING
CONNECTED
REQUESTING
RECEIVING
STREAMING
REUSED
RECONNECTING
FAILED
CLOSED
```

## HTTP 3.0 project extension boundary

If the project later defines new protocol behavior beyond standardized HTTP/3, it MUST be specified separately from this UI document. At minimum, that future specification must define:

1. wire framing;
2. version negotiation;
3. transport requirements;
4. authentication/security;
5. request/response semantics;
6. error codes;
7. flow-control behavior;
8. interoperability/fallback behavior;
9. compatibility with RFC 9114 HTTP/3;
10. Chromium integration boundary.

Until then, `http-3.0` means **project UI/I/O specification layered on standard HTTP/3**, not a replacement for RFC 9114.

## Fallback

Because HTTP/3 depends on QUIC, connectivity conditions can prevent an HTTP/3 connection. RFC 9114 notes that clients should use TCP-based HTTP versions when QUIC connectivity fails. citeturn0search0

The secondary bar should therefore remain useful when the active connection is HTTP/1.1 or HTTP/2. It should report the actual negotiated protocol rather than claiming HTTP/3 merely because the feature is enabled.

## Security

The UI information pane is observational. It MUST NOT weaken Chromium's certificate validation, origin isolation, cookie protections, TLS handling, or QUIC security. QUIC provides confidentiality and integrity through its TLS integration; HTTP/3 relies on those protections. citeturn0search0turn0search2

## Implementation relationship

```text
userland/chromium/
├── WHITE_EDITION_TASKBAR.md
└── http-3.0/
    ├── README.md
    └── UI_IO_SPEC.md
```

The existing White Edition tasking-bar specification defines the visual surface. This directory defines the additional HTTP I/O information carried by that surface.
