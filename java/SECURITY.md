# Security Design

**Author:** Max Rupplin - MEARVK LLC 2026

The initial server uses bounded SMTP lines, bounded message size, bounded recipient count, explicit TLS policy, constant-time credential comparison, atomic message publication, and append-only audit events.

STARTTLS is a policy boundary and currently returns an explicit configuration response until a real certificate/key context is supplied. The server must not pretend plaintext has become encrypted.

Production deployment should add certificate lifecycle management, authentication storage, queue isolation, abuse controls, DNS policy, DKIM/SPF/DMARC handling, and operational monitoring before exposure to an untrusted Internet.
