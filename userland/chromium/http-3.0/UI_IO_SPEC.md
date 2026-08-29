# Chromium White Edition — HTTP 3.0 Additional I/O Pane

## 1. Purpose

This document specifies the data contract for the secondary tasking bar beneath the URL/omnibox in the White Edition Chromium UI.

The bar is approximately **80% of the usable width of the URL input pane** and presents compact, non-secret network/I/O information.

This specification is a UI and observation contract. It does not create a new wire protocol.

## 2. Layout contract

```text
URL / omnibox:       100% reference width
Secondary I/O pane:   80% reference width
```

The implementation should use responsive layout measurements rather than a fixed pixel width.

Suggested layout:

```text
[Protocol] [Transport] [Connection] [Stream] [Security] [Latency] [Transfer] [Activity]
```

On narrow windows, fields should collapse by priority rather than forcing horizontal overflow.

## 3. Data model

A logical observation record may contain:

```text
protocol
transport
connection_state
stream_state
origin
security_state
latency_ms
request_bytes
response_bytes
flow_state
cache_state
activity_state
error_code
error_text
last_updated
```

All values are observational and should be treated as potentially transient.

## 4. Protocol field

`protocol` represents the protocol actually negotiated by Chromium.

Examples:

```text
h3
h2
http/1.1
unknown
```

For HTTP/3, `h3` corresponds to the ALPN identifier defined by RFC 9114. citeturn0search0

The UI MUST NOT display `h3` solely because the HTTP 3.0 feature is enabled.

## 5. Transport field

For HTTP/3, the transport is QUIC. QUIC provides multiplexed streams, flow control, connection migration, and integrated TLS handshake functionality. citeturn0search2

Example display:

```text
QUIC v1
```

The display should be concise. Detailed diagnostics belong in a diagnostic view, not the primary tasking bar.

## 6. Connection state

Allowed presentation states:

```text
idle
connecting
negotiating
connected
reused
reconnecting
closed
failed
```

Connection reuse is significant because HTTP/3 connections are persistent and can service multiple requests. citeturn0search0

## 7. Stream state

HTTP/3 maps request/response exchanges onto QUIC streams. Independent streams allow unrelated transactions to make progress independently. citeturn0search0

Suggested states:

```text
none
opening
requesting
receiving
streaming
complete
cancelled
failed
```

## 8. Security state

The pane may show a coarse state such as:

```text
secure
certificate-valid
certificate-warning
certificate-error
unknown
```

It MUST NOT expose:

- private keys;
- session tickets;
- TLS secrets;
- cookies;
- authorization credentials;
- bearer tokens;
- raw credential-bearing headers;
- decrypted secret material.

HTTP/3 relies on QUIC's TLS integration for confidentiality, integrity, and peer authentication. citeturn0search0turn0search2

## 9. Latency

`latency_ms` is an approximate presentation metric. It should never be presented as a precise measurement of end-to-end network performance unless the underlying measurement definition supports that precision.

Recommended display:

```text
12 ms
```

or, when unavailable:

```text
—
```

## 10. Transfer counters

`request_bytes` and `response_bytes` are presentation counters.

They should use compact formatting:

```text
↑ 4.2 KB
↓ 1.8 MB
```

The counters should reset only according to an explicitly defined request/navigation scope.

## 11. Flow state

The UI may summarize transport flow conditions without exposing implementation-specific internal data.

Suggested states:

```text
normal
limited
backpressured
unknown
```

Detailed congestion-control and QUIC packet diagnostics belong outside the primary UI.

## 12. Cache state

Suggested presentation values:

```text
network
cache-hit
cache-revalidated
cache-miss
unknown
```

This field must not imply that all network traffic was observed by the UI layer.

## 13. Activity

The tasking bar should expose one compact activity indicator:

```text
idle
loading
uploading
downloading
streaming
waiting
complete
failed
```

The activity indicator is a presentation of state, not a transport command.

## 14. Error handling

Errors should use a safe short label in the tasking bar and retain detailed diagnostics in a separate diagnostic surface.

Example:

```text
HTTP/3 unavailable
Falling back to HTTP/2
```

RFC 9114 notes that clients should use TCP-based HTTP versions when QUIC connectivity fails. citeturn0search0

## 15. Responsive behavior

At full width, all high-priority fields may be visible. At reduced widths, use this priority order:

1. protocol;
2. connection;
3. activity;
4. security;
5. stream;
6. latency;
7. transfer;
8. transport detail;
9. cache/flow detail.

No field should cause the browser content area to become unusable.

## 16. Accessibility

Every status must have a text representation available to assistive technologies. Color alone MUST NOT communicate security, failure, or protocol state.

The bar must support keyboard focus and navigation without interfering with omnibox shortcuts.

## 17. Rendering

White Edition presentation:

- predominantly white surface;
- dark-gray text and controls;
- subtle gray elevation/shadow;
- restrained Ubuntu-red active/focus indication;
- precision upper-left lighting consistent with the desktop LAF;
- no unnecessary animation.

The information pane should visually read as a **professional instrumentation strip**, not as a second browser toolbar.

## 18. Data ownership

The network/IO observer owns the observation record. The UI owns presentation state only.

```text
Chromium network stack
        ↓
observation adapter
        ↓
HTTP 3.0 UI model
        ↓
secondary tasking bar
```

No UI event should directly mutate transport internals through this interface.

## 19. Versioning

This UI contract should expose a schema version independently of the negotiated HTTP protocol.

Initial proposal:

```text
ui_io_schema = 1
wire_protocol = negotiated
```

A future project-specific wire protocol must receive a separate protocol specification and compatibility matrix.

## 20. Reference standards

The current interoperability baseline is standardized HTTP/3 from RFC 9114 over QUIC. RFC 9114 defines HTTP/3 as HTTP semantics mapped onto QUIC and specifies its framing, streams, SETTINGS, connection management, and QPACK use. citeturn0search0

QUIC Version 1 is specified by RFC 9000. citeturn0search2
