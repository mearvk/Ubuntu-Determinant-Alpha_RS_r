# WE.OWN.DISNEY.OR.md — disney.com public-key record

**Project:** Ubuntu Determinant
**Edition:** Ubuntu White Edition
**Project attention:** Max Rupplin — MEARVK LLC — 2026
**Status:** Public-key record for `disney.com` — POPULATED AS SUPPLIED BY REQUESTER (RSA-2048 PEM + SHA-256); NOT independently verified against a live connection in this environment

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

> **Provenance: SUPPLIED BY REQUESTER — NOT INDEPENDENTLY VERIFIED.** The values
> below were provided by the requester, not captured live from `disney.com` in
> this (network-restricted) environment. They are recorded as provided. Before
> relying on them, verify against a live capture using §2 and confirm the fetched
> key/fingerprint match exactly.

**Public key (RSA 2048-bit).** Reconstructed as a standard X.509
SubjectPublicKeyInfo PEM from the supplied 256-byte modulus with public exponent
65537 (F4):

```text
-----BEGIN PUBLIC KEY-----
MIIBITANBgkqhkiG9w0BAQEFAAOCAQ4AMIIBCQKCAQBD+AcUIMqcOvs+qRNV/MJU
g0DMRd+PjeHFV6QIh9p6g9UJCG+luzCLTzRyUqFpoIGZ2cqGy3Y+dqg6eJBfFPSj
APg2gWp9Y9cgTiybZoXLAb3L/AvZHlMsIaHSnDh7aJPHBpGyQLgXUcPlxsjnF2Ou
YXqyTLj0qMfCkgSujw70gY14MDDIeZtb6Moc8ieAYzZ719iRgbgz91Yi2eS2jd6L
LI7CmjMUlkW1miACBquUolPwQYvdV9erETvBcKESOoW8XSJZDWBIpw3+Zg5xzqaX
jcRHW3XZHd7RH79/TGWkQ6gAFCaA8qMDgrrHURXHKQUuVqXxUjx+Xkc63qHErqR3
AgMBAAE=
-----END PUBLIC KEY-----
```

- **Key algorithm / size:** RSA, 2048-bit modulus, exponent 65537 (0x10001)
- **Modulus (n), hex (256 bytes, as supplied):**
- 
  `43F8071420CA9C3AFB3EA91355FCC2548340CC45DF8F8DE1C557A40887DA7A83`
  `D509086FA5BB308B4F347252A169A08199D9CA86CB763E76A83A78905F14F4A3`
  `00F836816A7D63D7204E2C9B6685CB01BDCBFC0BD91E532C21A1D29C387B6893`
  `C70691B240B81751C3E5C6C8E71763AE617AB24CB8F4A8C7C29204AE8F0EF481`
  `8D783030C8799B5BE8CA1CF22780633667BD7D89181B833F75622D9E4B68DDE8B`
  `2C8EC29A33149645B59A200206AB94A253F0418BDD57D7AB113BC170A1123A85`
  `BC5D22590D6048A70DFE660E71CEA6978DC4475B75D91DDED11FBF7F4C65A443`
  `A800142680F2A30382BAC75115C729052E56A5F1523C7E5E473ADEA1C4AEA477`

**SHA-256 fingerprint / SPKI pin (as supplied):**

```text
2d8e0e595849a4538093bee907d0e59848a846f7e6320c3fcd033dc49e976242
```

> Note: verify whether the supplied SHA-256 is a **certificate** fingerprint or
> an **SPKI** pin, and confirm it against the §2 capture — the two are computed
> over different inputs and will differ.

Record alongside, from a live capture (still to be filled):

- **Fetched at (UTC):** __________________________
- **Host / SNI:** `disney.com` (and/or `www.disney.com`)
- **Certificate subject (CN):** __________________________
- **Issuer (CA):** __________________________
- **Serial number:** __________________________
- **Valid from / to:** __________________________
- **SHA-256 of SubjectPublicKeyInfo (SPKI pin), recomputed live:** __________________________


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
