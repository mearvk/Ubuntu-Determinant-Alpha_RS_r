# XMPP State of the Art — 2026

**Review date:** 2026-08-27  
**Project:** Trillian / Dino / XMC

## Executive consensus

XMPP remains a mature, decentralized real-time messaging standard, but its modern capability is defined by a **profile of XEPs**, not by core XMPP alone. The XMPP Standards Foundation describes current work across messaging, mobile use, file transfer, multi-user media, social features, internationalized identifiers, federation security, validation, and abuse resistance. The current XSF roadmap explicitly prioritizes reliable Jingle-based file transfer, MUC + Jingle, distributed chatrooms, validation, vCard4, social/mobile integration, collaborative editing, and resistance to spam/phishing/DoS.

## Current 2026 direction

The XSF's June/July 2026 material shows active protocol development rather than a frozen standard. Recent work includes:

- XEP-0514 Emoji Markup.
- XEP-0515 TLS Channel-Binding Downgrade Protection.
- XEP-0516 XMPP Decentralized ID (XID).
- XEP-0517 Jingle Synchronized Real-Time Text.
- Continued work on stanza content encryption (XEP-0420).
- Continued improvements to MUC, spaces, stickers, affiliations, and related social features.

XMPP Summit 29 is scheduled for September 4–5, 2026, providing another indication that protocol and implementation work remains active.

## Security

TLS-protected transport, modern SASL/SASL2 authentication, and end-to-end encryption are central to a current XMPP deployment. OMEMO remains an important deployed E2EE technology, but its XEP-0384 specification is still marked **Experimental**; production implementations therefore need to pin and test the exact protocol version they support rather than assuming that every OMEMO implementation is interchangeable.

XEP-0420 Stanza Content Encryption is also an important modern direction. Its 2026 revision addresses padding, injection warnings, fallback handling, time-affix verification, and explicit server-processed elements. This should be considered when designing a future Trillian/XMC encryption boundary.

## Messaging and social features

A modern client should consider, as applicable:

- XMPP Core and Service Discovery.
- Message Archive Management (MAM).
- Stream Management for mobile/reconnect reliability.
- Multi-User Chat (MUC).
- PubSub / Personal Eventing Protocol.
- Message Replies, Reactions, Edits and related modern message semantics.
- HTTP File Upload and Jingle-based media/file transfer.
- Avatars and modern vCard handling.
- Spaces and social/discovery features where supported.

The exact set must be selected as an application profile and validated against the current Compliance Suites rather than treated as one universal mandatory list.

## Media and real-time communication

Jingle remains the important XMPP framework for negotiated real-time sessions. Current work is extending it toward synchronized real-time text and broader multi-user media scenarios. For Trillian, this suggests keeping messaging, calls, file transfer, and real-time text as separable protocol modules.

## Interoperability

The XSF publishes Compliance Suites to give developers a practical feature profile and users a way to compare implementations. The currently published suite set is based on XEP-0479 (2023), while the ecosystem continues to evolve. Trillian should therefore maintain its own explicit compatibility matrix and update it when the XSF publishes newer suites.

## State-of-the-art target for Trillian/XMC

The recommended target is **Modern XMPP Client — Advanced Profile**, implemented incrementally:

1. Core XMPP + TLS + modern authentication.
2. Stream Management and reliable reconnect behavior.
3. MAM and message synchronization.
4. MUC and modern group-management behavior.
5. HTTP File Upload plus Jingle where appropriate.
6. E2EE with a carefully pinned, tested protocol implementation.
7. Message replies, reactions, edits, attachments and accessibility-friendly rendering.
8. PubSub/PEP and modern social features where they provide real user value.
9. Calls, real-time text and media negotiation as independent modules.
10. Explicit anti-spam, abuse, privacy and account-security controls.
11. Automated interoperability testing against representative XMPP servers and clients.

## Engineering rule

Do not equate “supports XMPP” with “supports modern XMPP.” A feature is considered supported only when its XEP version, interoperability behavior, security properties, failure behavior, and test coverage are documented.

## Sources

Primary sources reviewed:

- XMPP Standards Foundation roadmap: https://xmpp.org/about/xsf/roadmap/
- XMPP Compliance Suites: https://xmpp.org/about/compliance-suites/
- XMPP Newsletter June 2026: https://xmpp.org/2026/07/the-xmpp-newsletter-june-2026/
- XMPP Newsletter July 2026: https://xmpp.org/categories/newsletter/
- XEP-0384 OMEMO Encryption: https://xmpp.org/extensions/attic/xep-0384-0.9.0.html
- XEP-0420 Stanza Content Encryption: https://xmpp.org/extensions/

These are external standards references. Their status can change; implementation work should verify the current XEP revision before adopting a feature.
