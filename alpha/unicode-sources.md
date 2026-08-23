# Unicode UTF-32 Sources and Maintenance

Primary references:

1. Unicode Standard, Version 17.0, Core Specification, §2.5.1 (`UTF-32`).
2. Unicode Standard, §3.9 (`Unicode Encoding Forms`) in versions where that section is the applicable conformance reference.
3. Unicode FAQ, `UTF-8, UTF-16, UTF-32 & BOM`, especially the UTF-32 FAQ section.
4. Unicode FAQ / Specifications index: Unicode Encoding Forms and Unicode Encoding Schemes.

Maintenance rule: keep the implementation's declared Unicode target version explicit. Recheck the upstream specification when moving the target version. UTF-32's scalar-value encoding rule is stable, while the surrounding Unicode repertoire, properties, and application-level behavior evolve.

Important distinction: UTF-32 encoding form is a sequence of 32-bit code units; UTF-32BE and UTF-32LE are byte-serialization schemes. The implementation should validate scalar values before or during decoding and handle byte order independently.

Upstream links:

- https://www.unicode.org/versions/Unicode17.0.0/UnicodeStandard-17.0.pdf
- https://www.unicode.org/versions/latest/ch03.pdf
- https://www.unicode.org/faq/utf_bom.html
- https://www.unicode.org/faq/specifications.html
- https://www.unicode.org/versions/corrigenda.html