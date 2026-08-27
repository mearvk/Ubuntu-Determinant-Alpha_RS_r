#include "xmc-sha256.h"
#include <stdint.h>
#include <stdio.h>
#include <string.h>

static uint32_t rotr(uint32_t x, unsigned n) { return (x >> n) | (x << (32u - n)); }
static uint32_t ch(uint32_t x, uint32_t y, uint32_t z) { return (x & y) ^ (~x & z); }
static uint32_t maj(uint32_t x, uint32_t y, uint32_t z) { return (x & y) ^ (x & z) ^ (y & z); }
static uint32_t bs0(uint32_t x) { return rotr(x,2) ^ rotr(x,13) ^ rotr(x,22); }
static uint32_t bs1(uint32_t x) { return rotr(x,6) ^ rotr(x,11) ^ rotr(x,25); }
static uint32_t ss0(uint32_t x) { return rotr(x,7) ^ rotr(x,18) ^ (x >> 3); }
static uint32_t ss1(uint32_t x) { return rotr(x,17) ^ rotr(x,19) ^ (x >> 10); }

static const uint32_t k[64] = {
    0x428a2f98u,0x71374491u,0xb5c0fbcfu,0xe9b5dba5u,0x3956c25bu,0x59f111f1u,0x923f82a4u,0xab1c5ed5u,
    0xd807aa98u,0x12835b01u,0x243185beu,0x550c7dc3u,0x72be5d74u,0x80deb1feu,0x9bdc06a7u,0xc19bf174u,
    0xe49b69c1u,0xefbe4786u,0x0fc19dc6u,0x240ca1ccu,0x2de92c6fu,0x4a7484aau,0x5cb0a9dcu,0x76f988dau,
    0x983e5152u,0xa831c66du,0xb00327c8u,0xbf597fc7u,0xc6e00bf3u,0xd5a79147u,0x06ca6351u,0x14292967u,
    0x27b70a85u,0x2e1b2138u,0x4d2c6dfcu,0x53380d13u,0x650a7354u,0x766a0abbu,0x81c2c92eu,0x92722c85u,
    0xa2bfe8a1u,0xa81a664bu,0xc24b8b70u,0xc76c51a3u,0xd192e819u,0xd6990624u,0xf40e3585u,0x106aa070u,
    0x19a4c116u,0x1e376c08u,0x2748774cu,0x34b0bcb5u,0x391c0cb3u,0x4ed8aa4au,0x5b9cca4fu,0x682e6ff3u,
    0x748f82eeu,0x78a5636fu,0x84c87814u,0x8cc70208u,0x90befffau,0xa4506cebu,0xbef9a3f7u,0xc67178f2u
};

static void transform(uint32_t h[8], const unsigned char block[64]) {
    uint32_t w[64];
    for (unsigned i = 0; i < 16; ++i)
        w[i] = ((uint32_t)block[i*4] << 24) | ((uint32_t)block[i*4+1] << 16) |
               ((uint32_t)block[i*4+2] << 8) | (uint32_t)block[i*4+3];
    for (unsigned i = 16; i < 64; ++i) w[i] = ss1(w[i-2]) + w[i-7] + ss0(w[i-15]) + w[i-16];

    uint32_t a=h[0],b=h[1],c=h[2],d=h[3],e=h[4],f=h[5],g=h[6],hh=h[7];
    for (unsigned i = 0; i < 64; ++i) {
        uint32_t t1 = hh + bs1(e) + ch(e,f,g) + k[i] + w[i];
        uint32_t t2 = bs0(a) + maj(a,b,c);
        hh=g; g=f; f=e; e=d+t1; d=c; c=b; b=a; a=t1+t2;
    }
    h[0]+=a; h[1]+=b; h[2]+=c; h[3]+=d; h[4]+=e; h[5]+=f; h[6]+=g; h[7]+=hh;
}

int xmc_sha256_file(const char *path, char out[65]) {
    if (!path || !out) return -1;
    FILE *f = fopen(path, "rb");
    if (!f) return -1;

    uint32_t h[8] = { 0x6a09e667u,0xbb67ae85u,0x3c6ef372u,0xa54ff53au,
                      0x510e527fu,0x9b05688cu,0x1f83d9abu,0x5be0cd19u };
    unsigned char block[64];
    unsigned char tail[64];
    size_t tail_len = 0;
    uint64_t total = 0;

    for (;;) {
        size_t n = fread(block, 1, sizeof block, f);
        if (n == 0) {
            if (ferror(f)) { fclose(f); return -1; }
            break;
        }
        total += (uint64_t)n;
        if (n == sizeof block) {
            transform(h, block);
        } else {
            memcpy(tail, block, n);
            tail_len = n;
            break;
        }
    }
    fclose(f);

    tail[tail_len++] = 0x80u;
    if (tail_len > 56) {
        memset(tail + tail_len, 0, 64 - tail_len);
        transform(h, tail);
        tail_len = 0;
    }
    memset(tail + tail_len, 0, 56 - tail_len);
    uint64_t bits = total * 8u;
    for (unsigned i = 0; i < 8; ++i) tail[56+i] = (unsigned char)(bits >> (56u - i*8u));
    transform(h, tail);

    static const char hex[] = "0123456789abcdef";
    for (unsigned i = 0; i < 8; ++i) {
        out[i*8+0] = hex[(h[i] >> 28) & 0xf]; out[i*8+1] = hex[(h[i] >> 24) & 0xf];
        out[i*8+2] = hex[(h[i] >> 20) & 0xf]; out[i*8+3] = hex[(h[i] >> 16) & 0xf];
        out[i*8+4] = hex[(h[i] >> 12) & 0xf]; out[i*8+5] = hex[(h[i] >> 8) & 0xf];
        out[i*8+6] = hex[(h[i] >> 4) & 0xf]; out[i*8+7] = hex[h[i] & 0xf];
    }
    out[64] = '\0';
    return 0;
}
