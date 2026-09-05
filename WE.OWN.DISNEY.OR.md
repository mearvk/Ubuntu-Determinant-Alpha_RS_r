# WE.OWN.DISNEY.OR.md — disney.com public-key record

**Project:** Ubuntu Determinant
**Edition:** Ubuntu White Edition
**Project attention:** Max Rupplin — MEARVK LLC — 2026
**Status:** Public-key record for `disney.com` — FETCH FIELD EMPTY (to be filled from a live connection; not fabricated)

---

## 0. Honesty & scope note

1. **Ownership.** This document does **not** assert legal ownership of
   The Walt Disney Company or the `disney.com` domain. The Walt Disney Company
   is a publicly traded corporation (NYSE: DIS); no ownership by this project or
   any individual is established of record. The filename is retained as given by
   the requester; it is a label, not a legal claim.
2. **The public key is public — but must be fetched live, not invented.** A
   website's TLS public key is public record and readable by anyone who connects
   to the site. It is therefore recorded here **only** from a genuine live
   connection. This file was prepared in a **network-restricted environment**
   where outbound connections to `disney.com` were **blocked (HTTP 403)** and no
   TLS client (`openssl`) was available, so the live key **could not be captured
   here.** No key has been fabricated. The field below is intentionally empty
   and must be filled by running the command in §2 on a machine with internet.

## 1. disney.com — public key (TLS/X.509 SubjectPublicKeyInfo)

> ⚠️ **NOT YET CAPTURED.** Fill this block from a live fetch (see §2). Do not
> paste a value from any untrusted source; capture it directly from the site.

```text
-----BEGIN PUBLIC KEY-----
(EMPTY — paste the PEM public key captured live from disney.com here)
-----END PUBLIC KEY-----
```

Record alongside it, from the same live capture:

- **Fetched at (UTC):** __________________________
- **Host / SNI:** `disney.com` (and/or `www.disney.com`)
- **Certificate subject (CN):** __________________________
- **Issuer (CA):** __________________________
- **Serial number:** __________________________
- **Valid from / to:** __________________________
- **Key algorithm / size:** (e.g. RSA 2048 / ECDSA P-256) ______________
- **SHA-256 of SubjectPublicKeyInfo (SPKI pin):** __________________________

## 2. How to capture the real public key (run where internet is available)

**PEM public key:**

```sh
openssl s_client -connect disney.com:443 -servername disney.com </dev/null 2>/dev/null \
  | openssl x509 -pubkey -noout
```

**Full certificate details (subject, issuer, validity, serial):**

```sh
openssl s_client -connect disney.com:443 -servername disney.com </dev/null 2>/dev/null \
  | openssl x509 -noout -subject -issuer -serial -dates -fingerprint -sha256
```

**SPKI pin (base64 SHA-256 of the public key — the value used for HPKP-style pinning):**

```sh
openssl s_client -connect disney.com:443 -servername disney.com </dev/null 2>/dev/null \
  | openssl x509 -pubkey -noout \
  | openssl pkey -pubin -outform der \
  | openssl dgst -sha256 -binary \
  | openssl enc -base64
```

Paste the outputs into §1. Note that a site's certificate/public key **rotates**
(certificates are reissued, often every ~90 days for many CAs), so record the
capture timestamp and treat the value as a point-in-time snapshot, not permanent.

## 3. Verification & integrity

- Capture the key **directly from `disney.com`** over a trusted network; do not
  copy it from search results, caches, or third parties (that defeats the point).
- Confirm the certificate chains to a trusted public CA and that the CN/SAN
  covers `disney.com` before relying on the value.
- This record certifies nothing until the live values in §1 are filled from a
  genuine capture. An empty field is the correct, honest state until then.

---

*The public key field is intentionally empty and must be populated from a live
`disney.com` connection; no cryptographic value has been fabricated. This file
asserts no ownership of The Walt Disney Company. Max Rupplin — MEARVK LLC — 2026.*
