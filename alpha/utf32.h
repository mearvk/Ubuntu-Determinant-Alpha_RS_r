#ifndef ALPHA_UTF32_H
#define ALPHA_UTF32_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Returns non-zero exactly for Unicode scalar values. */
int utf32_is_scalar(uint32_t value);

/* Encode a scalar value as one UTF-32 code unit. Returns 0 on success. */
int utf32_encode(uint32_t scalar, uint32_t *out_code_unit);

/* Decode one UTF-32 code unit. Returns 0 on success. */
int utf32_decode(uint32_t code_unit, uint32_t *out_scalar);

/* Serialize one code unit as four octets. */
void utf32_to_be(uint32_t code_unit, uint8_t out[4]);
void utf32_to_le(uint32_t code_unit, uint8_t out[4]);

/* Deserialize four octets as one code unit. */
uint32_t utf32_from_be(const uint8_t in[4]);
uint32_t utf32_from_le(const uint8_t in[4]);

#ifdef __cplusplus
}
#endif

#endif /* ALPHA_UTF32_H */