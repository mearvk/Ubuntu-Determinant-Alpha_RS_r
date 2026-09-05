# ICC — Integrity, Verification & Timestamping Record

**Project:** Ubuntu Determinant
**Edition:** Ubuntu White Edition
**Project attention:** Max Rupplin — MEARVK LLC — 2026
**Status:** Local hashes computed & files validated; third-party notarized timestamp PENDING (see §4)
**Hashes computed (UTC):** 2026-09-05T15:54Z

---

## 0. What this record is (and is not)

This file records the **cryptographic digests (SHA-256)** of the ICC documents in
this folder, and validates that the `.docx` files are intact. The digest is the
exact value a notarization / timestamping service signs over, so this is the
verifiable foundation for certification.

**Honest status of "notarized / certified / verified / timestamped":**
- **Verified (integrity):** DONE locally — the `.docx` files were parsed as
  OOXML/ZIP and **all internal CRC-32 checksums pass** (not corrupted), and
  SHA-256 digests were computed (below).
- **Notarized / third-party timestamped:** **NOT YET.** A trusted timestamp must
  be obtained from an external service (an RFC 3161 Time-Stamping Authority,
  OpenTimestamps/Bitcoin, or similar). That requires outbound internet, which was
  **blocked in the authoring environment (HTTP 403)**, so no third-party token
  could be fetched here. No timestamp token has been fabricated. Run the commands
  in §4 on a networked machine and paste the returned proof into §5.

## 1. File integrity validation

| File | Format | ZIP CRC | `word/document.xml` |
|---|---|---|---|
| ICC Legal Standings 1.docx | OOXML (.docx) | OK (all entries) | present |
| ICC Legal Standings 2.docx | OOXML (.docx) | OK (all entries) | present |
| ICC Legal Standing 3.docx  | OOXML (.docx) | OK (all entries) | present |

## 2. SHA-256 digests (authoritative digests of the exact bytes)

```text
eba50a4bc0fbb4b08cacb3ff42e0dd85f8c09da994ada5010be7b4553d745555  ICC Legal Standings 1.docx
d191fa1a7733e78c1f815e40d0c9668e11fcd0b3a047d56af5cf96d50d84bf6f  ICC Legal Standings 2.docx
afb6534a4ecf4a370a33059d14e50de0d863d62d112d7dab866448ca18fe2a51  ICC Legal Standing 3.docx
fcfe1aaef631c5db0f65976bfe92e4e42a19de8e6765d4a89cb7da2525394f41  ABOUT-THE-COURT.md
5e0d5006ed01768aedd096f6ed943e8e5eb6256c4aff86d13cf4f2147612b080  README.md
```

The machine-readable copy is `ICC/SHA256SUMS`.

## 3. Verify these hashes yourself

From inside the `ICC/` folder:

```sh
sha256sum -c SHA256SUMS
# expect: each file "OK"
```

Or per file:

```sh
sha256sum "ICC Legal Standings 1.docx"
# compare against §2
```

## 4. Obtain a trusted third-party timestamp (run on a networked machine)

Any of the following produces an independently-verifiable proof that these exact
bytes existed at/before a point in time. Pick one (or several) and paste the
result into §5.

**A. OpenTimestamps (free; anchored to the Bitcoin blockchain)**
```sh
pip install opentimestamps-client        # provides `ots`
ots stamp "ICC Legal Standings 1.docx"   # creates "ICC Legal Standings 1.docx.ots"
ots stamp "ICC Legal Standings 2.docx"
ots stamp "ICC Legal Standing 3.docx"
# later (after Bitcoin confirmation), upgrade + verify:
ots upgrade *.ots
ots verify "ICC Legal Standings 1.docx.ots"
```
Commit the `*.ots` files here alongside the documents.

**B. RFC 3161 Time-Stamping Authority (signed timestamp token, .tsr)**
```sh
# create a timestamp request over the file's SHA-256, send to a public TSA:
openssl ts -query -data "ICC Legal Standings 1.docx" -sha256 -cert -out req1.tsq
curl -s -H "Content-Type: application/timestamp-query" \
     --data-binary @req1.tsq https://freetsa.org/tsr > icc1.tsr
# verify against the TSA's cert chain:
openssl ts -reply -in icc1.tsr -text | head
```
Commit the `.tsq`/`.tsr` tokens here.

**C. A commercial/notary e-timestamp service**
Upload the file (or paste its §2 SHA-256) to the chosen service, download the
signed certificate/receipt, and commit it here.

> Note on "a known online legal source": a *legal* notarization/e-signature
> provider or an RFC 3161 TSA gives a legally-oriented, signed timestamp; the
> OpenTimestamps/Bitcoin route gives a decentralized, publicly-verifiable proof.
> Either can be recorded in §5. The SHA-256 in §2 is what they all attest to.

## 5. Third-party timestamp proofs (to be filled after §4)

> Paste the returned proof(s) here, and commit the token files
> (`*.ots`, `*.tsr`, or the service's certificate) into `ICC/`.

- **Service used:** __________________________
- **Timestamp (UTC):** __________________________
- **Proof file(s) committed:** __________________________
- **Digest attested (must match §2):** __________________________
- **Independent verification command / URL:** __________________________

---

*Integrity digests are authoritative for the exact bytes hashed. Third-party
timestamping is pending an online service (see §4); no timestamp has been
fabricated. Not legal advice; placement here asserts no official ICC status.
Max Rupplin — MEARVK LLC — 2026.*
