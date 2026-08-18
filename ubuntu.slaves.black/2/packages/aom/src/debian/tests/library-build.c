/*
 * Copyright 2018, James Cowgill <jcowgill@debian.org>
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
 * ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#include <aom/aomcx.h>
#include <aom/aomdx.h>
#include <aom/aom_encoder.h>
#include <aom/aom_decoder.h>
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*
 * Simple smoke test program to work the encoder and decoder
 *
 * - Generate simple test frame (200x200 all black)
 * - Encode it
 * - Decode it
 * - Test that the result is all black (while not strictly correct, hopefully
 *   the encoder can do this!)
 */

#define FRAME_WIDTH 200
#define FRAME_HEIGHT 200

// Exit on error
void die_on_fail(aom_codec_err_t result, aom_codec_ctx_t* ctx, const char* func)
{
    if (result != AOM_CODEC_OK) {
        fprintf(stderr, "error at %s (%s)\n", func, aom_codec_err_to_string(result));
        if (ctx != NULL)
            fputs(aom_codec_error_detail(ctx), stderr);
        abort();
    }
}

// Header for packet linked list entries
struct packet_ll_head {
    struct packet_ll_head* next;
    size_t size;
    unsigned char buf[];
};

// Linked list for storing packet data
struct packet_ll {
    struct packet_ll_head* first;
    struct packet_ll_head* last;
};

// Appends a compressed video frame packet to the list (other packets ignored)
void packet_ll_append(struct packet_ll* list, const aom_codec_cx_pkt_t* packet)
{
    if (packet->kind != AOM_CODEC_CX_FRAME_PKT)
        return;

    // Allocate new list head and copy data
    struct packet_ll_head* new_head = malloc(sizeof(struct packet_ll_head) + packet->data.frame.sz);
    if (new_head == NULL)
        die_on_fail(AOM_CODEC_MEM_ERROR, NULL, "malloc");

    new_head->next = NULL;
    new_head->size = packet->data.frame.sz;
    memcpy(new_head->buf, packet->data.frame.buf, packet->data.frame.sz);

    // Append head to the list
    if (list->last == NULL)
        list->first = new_head;
    else
        list->last->next = new_head;

    list->last = new_head;
}

// Returns the size of a packet list
int packet_ll_size(const struct packet_ll* list)
{
    const struct packet_ll_head* current = list->first;
    int size = 0;
    while (current) {
        size++;
        current = current->next;
    }

    return size;
}

// Frees a packet list and all its elements
void packet_ll_free(struct packet_ll* list)
{
    struct packet_ll_head* current = list->first;
    while (current) {
        struct packet_ll_head* next = current->next;
        free(current);
        current = next;
    }

    list->first = NULL;
    list->last = NULL;
}

// Encodes a frame and writes any packets to the list
//  Returns nuber of appended packets
int encode_frame(aom_codec_ctx_t* ctx, const aom_image_t* img, int index, int flags, struct packet_ll* list)
{
    die_on_fail(aom_codec_encode(ctx, img, index, 1, flags), ctx, "aom_codec_encode");

    const aom_codec_cx_pkt_t* packet;
    aom_codec_iter_t iter = NULL;
    int packets = 0;

    while ((packet = aom_codec_get_cx_data(ctx, &iter)) != NULL) {
        packet_ll_append(list, packet);
        packets++;
    }

    return packets;
}

// Encodes a blank image and returns the packet data
struct packet_ll encode_black_image(void)
{
    // Create blank image
    aom_image_t* img = aom_img_alloc(NULL, AOM_IMG_FMT_I420 , FRAME_WIDTH, FRAME_HEIGHT, 1);
    if (img == NULL)
        die_on_fail(AOM_CODEC_MEM_ERROR, NULL, "aom_img_alloc");

    for (int plane = 0; plane < 3; plane++) {
        unsigned char* buf = img->planes[plane];
        const int stride = img->stride[plane];
        const int w = aom_img_plane_width(img, plane);
        const int h = aom_img_plane_height(img, plane);

        for (int line = 0; line < h; line++, buf += stride)
            memset(buf, 0, w);
    }

    // Initialize encoder
    aom_codec_enc_cfg_t enc_config;
    die_on_fail(aom_codec_enc_config_default(aom_codec_av1_cx(), &enc_config, 0),
            NULL, "aom_codec_enc_config_default");

    enc_config.g_w = FRAME_WIDTH;
    enc_config.g_h = FRAME_HEIGHT;
    enc_config.g_timebase.num = 1;
    enc_config.g_timebase.den = 30;

    aom_codec_ctx_t ctx;
    die_on_fail(aom_codec_enc_init(&ctx, aom_codec_av1_cx(), &enc_config, 0),
            NULL, "aom_codec_enc_init");

    // Encode frame
    struct packet_ll encoded = { NULL, NULL };
    encode_frame(&ctx, img, 0, AOM_EFLAG_FORCE_KF, &encoded);

    // Flush encoder, destroy context and destroy image
    while (encode_frame(&ctx, NULL, -1, 0, &encoded));
    aom_codec_destroy(&ctx);
    aom_img_free(img);

    return encoded;
}

// Decodes the first frame of a packet list and returns it
aom_image_t* decode_first_frame(aom_codec_ctx_t* ctx, const struct packet_ll* encoded)
{
    // Initialize Decoder
    die_on_fail(aom_codec_dec_init(ctx, aom_codec_av1_dx(), NULL, 0),
            NULL, "aom_codec_dec_init");

    // Decode packets until we get the first frame
    struct packet_ll_head* current = encoded->first;
    while (current) {
        die_on_fail(aom_codec_decode(ctx, current->buf, current->size, NULL),
                ctx, "aom_codec_decode");

        aom_codec_iter_t iter = NULL;
        aom_image_t* img = aom_codec_get_frame(ctx, &iter);
        if (img != NULL)
            return img;

        current = current->next;
    }

    die_on_fail(AOM_CODEC_ERROR, NULL, "no packets decoded");
    return NULL;
}

int main(void)
{
    printf("aom library version: %s\n", aom_codec_version_str());
    printf("aom library config: %s\n", aom_codec_build_config());

    // Run one encode / decode cycle
    puts("encoding...");
    struct packet_ll encoded = encode_black_image();
    int encoded_size = packet_ll_size(&encoded);
    printf("encoded into %i packets\n", encoded_size);
    assert(encoded_size > 0);

    puts("decoding...");
    aom_codec_ctx_t decode_ctx;
    aom_image_t* decoded = decode_first_frame(&decode_ctx, &encoded);

    // Verify the decoded image is black and the right size
    assert(decoded->d_w == FRAME_WIDTH);
    assert(decoded->d_h == FRAME_HEIGHT);

    for (int plane = 0; plane < 3; plane++) {
        unsigned char* buf = decoded->planes[plane];
        const int stride = decoded->stride[plane];
        const int w = aom_img_plane_width(decoded, plane);
        const int h = aom_img_plane_height(decoded, plane);

        for (int line = 0; line < h; line++, buf += stride)
            for (int x = 0; x < w; x++)
                assert(buf[x] == 0);
    }

    puts("done!");

    packet_ll_free(&encoded);
    aom_codec_destroy(&decode_ctx);
    return 0;
}
