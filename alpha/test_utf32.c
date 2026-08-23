#include "utf32.h"
#include <assert.h>
#include <stdint.h>

int main(void) {
    uint32_t out;
    uint8_t bytes[4];

    assert(utf32_is_scalar(0x00000000u));
    assert(utf32_is_scalar(0x0000D7FFu));
    assert(utf32_is_scalar(0x0000E000u));
    assert(utf32_is_scalar(0x0010FFFFu));
    assert(!utf32_is_scalar(0x0000D800u));
    assert(!utf32_is_scalar(0x0000DFFFu));
    assert(!utf32_is_scalar(0x00110000u));

    assert(utf32_encode(0x00000041u, &out) == 0 && out == 0x41u);
    assert(utf32_encode(0x001F600u, &out) == 0 && out == 0x1F600u);
    assert(utf32_encode(0xD800u, &out) != 0);
    assert(utf32_decode(0x10FFFFu, &out) == 0 && out == 0x10FFFFu);
    assert(utf32_decode(0xD800u, &out) != 0);

    utf32_to_be(0x001F600u, bytes);
    assert(bytes[0] == 0x00 && bytes[1] == 0x01 && bytes[2] == 0xF6 && bytes[3] == 0x00);
    assert(utf32_from_be(bytes) == 0x001F600u);

    utf32_to_le(0x001F600u, bytes);
    assert(bytes[0] == 0x00 && bytes[1] == 0xF6 && bytes[2] == 0x01 && bytes[3] == 0x00);
    assert(utf32_from_le(bytes) == 0x001F600u);

    return 0;
}