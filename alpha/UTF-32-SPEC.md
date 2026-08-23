# UTF-32 Implementation Specification

## 1. Scope

This document is an implementation-oriented summary of the Unicode UTF-32 encoding form. It does not reproduce the Unicode Standard. The authoritative upstream specification is the Unicode Standard, §2.5/§3.9 as applicable to the referenced version.

## 2. Code-unit model

UTF-32 uses a fixed-width 32-bit code unit. For a valid encoded character, the code-unit value is the Unicode scalar value itself.

Valid scalar values are:

- `U+0000..U+D7FF`
- `U+E000..U+10FFFF`

The surrogate range `U+D800..U+DFFF` is not valid in UTF-32 as an encoded scalar value. Values above `U+10FFFF` are also invalid.

## 3. Encoding

For a Unicode scalar value `S`, the UTF-32 code unit is the unsigned 32-bit integer whose numerical value is `S`.

Examples:

- `U+0041` -> `0x00000041`
- `U+20AC` -> `0x000020AC`
- `U+1F600` -> `0x0001F600`

No surrogate-pair transformation is performed.

## 4. Decoding

A 32-bit code unit decodes to a Unicode scalar value if and only if it is in one of the two scalar-value ranges above. Otherwise the decoder must report an invalid scalar value rather than silently accepting the integer as a character.

## 5. Encoding form versus byte serialization

UTF-32 as an encoding form describes 32-bit code units. When those units are serialized as octets, byte order must be specified. Unicode defines UTF-32BE and UTF-32LE encoding schemes for this purpose. A BOM may be used as a signature in an appropriate serialized stream; it is not part of the abstract scalar-to-code-unit mapping.

## 6. Round trip

For every valid scalar value `S`, encoding followed by decoding must return `S` unchanged. Invalid surrogate and out-of-range values must not acquire a valid character interpretation through conversion.

## 7. Noncharacters and unassigned values

The UTF transformation is concerned with scalar-value validity. UTF-32 can represent reserved/unassigned scalar values and Unicode noncharacters as 32-bit code-unit values; policy about whether an application permits particular noncharacters is a separate layer.

## 8. Security and interoperability

Implementations should validate UTF-32 input at the boundary. In particular, do not treat all possible `uint32_t` values as Unicode characters, do not reinterpret surrogate values as scalar values, and keep byte-order handling separate from scalar-value validation.

## 9. Conformance target

The implementation in this directory targets the Unicode UTF-32 encoding-form model and is intended to be maintained against a declared Unicode Standard version. See `unicode-sources.md` for the current upstream references.