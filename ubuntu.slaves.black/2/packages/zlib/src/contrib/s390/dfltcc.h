#ifndef DFLTCC_H
#define DFLTCC_H

#include "../../zlib.h"
#include "../../zutil.h"

voidpf ZLIB_INTERNAL dfltcc_alloc_state OF((z_streamp strm, uInt items,
                                            uInt size));
void ZLIB_INTERNAL dfltcc_copy_state OF((voidpf dst, const voidpf src,
                                         uInt size));
void ZLIB_INTERNAL dfltcc_reset OF((z_streamp strm, uInt size));
voidpf ZLIB_INTERNAL dfltcc_alloc_window OF((z_streamp strm, uInt items,
                                             uInt size));
void ZLIB_INTERNAL dfltcc_free_window OF((z_streamp strm, voidpf w));
#define DFLTCC_BLOCK_HEADER_BITS 3
#define DFLTCC_HLITS_COUNT_BITS 5
#define DFLTCC_HDISTS_COUNT_BITS 5
#define DFLTCC_HCLENS_COUNT_BITS 4
#define DFLTCC_MAX_HCLENS 19
#define DFLTCC_HCLEN_BITS 3
#define DFLTCC_MAX_HLITS 286
#define DFLTCC_MAX_HDISTS 30
#define DFLTCC_MAX_HLIT_HDIST_BITS 7
#define DFLTCC_MAX_SYMBOL_BITS 16
#define DFLTCC_MAX_EOBS_BITS 15
#define DFLTCC_MAX_PADDING_BITS 7
#define DEFLATE_BOUND_COMPLEN(source_len) \
    ((DFLTCC_BLOCK_HEADER_BITS + \
      DFLTCC_HLITS_COUNT_BITS + \
      DFLTCC_HDISTS_COUNT_BITS + \
      DFLTCC_HCLENS_COUNT_BITS + \
      DFLTCC_MAX_HCLENS * DFLTCC_HCLEN_BITS + \
      (DFLTCC_MAX_HLITS + DFLTCC_MAX_HDISTS) * DFLTCC_MAX_HLIT_HDIST_BITS + \
      (source_len) * DFLTCC_MAX_SYMBOL_BITS + \
      DFLTCC_MAX_EOBS_BITS + \
      DFLTCC_MAX_PADDING_BITS) >> 3)
int ZLIB_INTERNAL dfltcc_can_inflate OF((z_streamp strm));
typedef enum {
    DFLTCC_INFLATE_CONTINUE,
    DFLTCC_INFLATE_BREAK,
    DFLTCC_INFLATE_SOFTWARE,
} dfltcc_inflate_action;
dfltcc_inflate_action ZLIB_INTERNAL dfltcc_inflate OF((z_streamp strm,
                                                       int flush, int *ret));
int ZLIB_INTERNAL dfltcc_was_inflate_used OF((z_streamp strm));
int ZLIB_INTERNAL dfltcc_inflate_disable OF((z_streamp strm));

#define ZALLOC_STATE dfltcc_alloc_state
#define ZFREE_STATE ZFREE
#define ZCOPY_STATE dfltcc_copy_state
#define ZALLOC_WINDOW dfltcc_alloc_window
#define ZFREE_WINDOW dfltcc_free_window
#define TRY_FREE_WINDOW dfltcc_free_window
#define INFLATE_RESET_KEEP_HOOK(strm) \
    dfltcc_reset((strm), sizeof(struct inflate_state))
#define INFLATE_PRIME_HOOK(strm, bits, value) \
    do { if (dfltcc_inflate_disable((strm))) return Z_STREAM_ERROR; } while (0)
#define INFLATE_TYPEDO_HOOK(strm, flush) \
    if (dfltcc_can_inflate((strm))) { \
        dfltcc_inflate_action action; \
\
        RESTORE(); \
        action = dfltcc_inflate((strm), (flush), &ret); \
        LOAD(); \
        if (action == DFLTCC_INFLATE_CONTINUE) \
            break; \
        else if (action == DFLTCC_INFLATE_BREAK) \
            goto inf_leave; \
    }
#define INFLATE_NEED_CHECKSUM(strm) (!dfltcc_can_inflate((strm)))
#define INFLATE_NEED_UPDATEWINDOW(strm) (!dfltcc_can_inflate((strm)))
#define INFLATE_MARK_HOOK(strm) \
    do { \
        if (dfltcc_was_inflate_used((strm))) return -(1L << 16); \
    } while (0)
#define INFLATE_SYNC_POINT_HOOK(strm) \
    do { \
        if (dfltcc_was_inflate_used((strm))) return Z_STREAM_ERROR; \
    } while (0)

#endif
