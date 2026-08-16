/* Prune Firebird database file from random garbage
   Copyright (c) 2015 Damyan Ivanov <dmn@debian.org>
   Permission is granted to use this work, with or without modifications,
   provided that this notice is retained. If we meet some day, and you think this
   stuff is worth it, you can buy me a beer in return.
 */

#include "gen/autoconfig.h"
#include "fb_types.h"
#include "src/common/common.h"
#include "src/jrd/ods.h"
#include <errno.h>
#include <error.h>
#include <ibase.h>
#include <stdio.h>
#include <time.h>

int main(int argc, char** argv) {
    FILE *f;
    Ods::header_page pag;
    typeof(Ods::header_page.hds_ods_version) ods_major;
    tm time;
    int page_size;

    if( argc != 3 ) {
        error( 1, 0, "expecting exactly two arguments - database file path and 'yyyy-mm-dd' date" );
    }

    f = fopen(argv[1], "r+");

    if (f == NULL) {
        error( 2, errno, "fopen(%s)", argv[1] );
    }

    if ( fread( &pag, sizeof(pag), 1, f ) != 1 ) {
        error( 3, errno, "Read error" );
    }

    fprintf( stdout, "Page type is %d\n", pag.hdr_header.pag_type );
    if ( pag.hdr_header.pag_type != pag_header )
        error( 4, 0, "Unexpected page type" );

    ods_major = pag.hdr_ods_version & ~ODS_FIREBIRD_FLAG;
    fprintf( stdout, "ODS is %d.%d\n", ods_major, pag.hdr_ods_minor );

    if ( ods_major != ODS_VERSION )
        error( 4, 0, "Unsupported ODS version" );

    page_size = pag.hdr_page_size;
    fprintf(stdout, "Page size: %d (0x%x)\n", page_size, page_size );

    isc_decode_timestamp( (ISC_TIMESTAMP *)pag.hdr_creation_date, &time);
    fprintf(stdout, "Creation: %d.%d.%d %d:%02d:%02d\n",
                           time.tm_mday, time.tm_mon + 1, time.tm_year + 1900,
                           time.tm_hour, time.tm_min, time.tm_sec);

    if ( strptime( argv[2], "%Y-%m-%d", &time ) == NULL )
        error( 5, 0, "Unable to parse timestamp" );
    time.tm_sec = 0;
    time.tm_min = 0;
    time.tm_hour = 0;
    time.tm_isdst = 0;

    isc_encode_timestamp( &time, (ISC_TIMESTAMP *)pag.hdr_creation_date );

    if ( fseek( f, 0, SEEK_SET ) != 0 )
        error( 6, errno, "fseek(0)" );

    if ( fwrite( &pag, sizeof(pag), 1, f ) != 1 )
        error( 7, errno, "fwrite" );

    // read all pages, pruning b-tree index pages and data pages
    // also resets pag_generation and pag_reserved on all pages
    {
        int page_no = 0;
        typedef union {
            unsigned char bytes[MAX(sizeof(Ods::pag), MAX(sizeof(Ods::data_page), sizeof(Ods::btree_page)))];
            Ods::pag header;
            Ods::data_page data;
            Ods::btree_page btree;
        } PAGE;
        PAGE *pbuf;
        bool *pmap;

        pbuf = (PAGE*) malloc( page_size );
        if (pbuf == NULL )
            error( 8, 0, "Unable to allocate page buffer" );

        pmap = (bool*) malloc( page_size * sizeof(bool) );
        if (pmap == NULL )
            error( 8, 0, "Unable to allocate page map" );

        while(true) {
            page_no++;
            if ( fseek( f, page_no * page_size, SEEK_SET ) != 0 )
                error( 8, errno, "fseek(page %d)", page_no );

            if ( fread( pbuf, page_size, 1, f ) != 1 ) {
                if ( feof(f) )
                    break;
                error( 8, errno, "Error reading page %d", page_no );
            }

            switch (pbuf->header.pag_type) {
                case pag_index:
                    fprintf( stdout, "Index page %d (0x%x) for relation %d\n", page_no, page_no, pbuf->btree.btr_relation );
                    if ( pbuf->btree.btr_length < page_size ) {
                        int wipe_size = page_size - pbuf->btree.btr_length;
                        fprintf( stdout, " 0x%x bytes used; wiping 0x%x bytes\n", pbuf->btree.btr_length, wipe_size );
                        memset( pbuf->bytes + pbuf->btree.btr_length, 0, wipe_size );
                    }
                    break;
                case pag_data: {
                    int min_data_offset = offsetof( Ods::data_page, dpg_rpt ) + pbuf->data.dpg_count * sizeof(pbuf->data.dpg_rpt[0]);
                    memset( pmap, 0, page_size * sizeof(bool) );
                    fprintf( stdout, "Data page %d (0x%x), #%d for relation %d, with %d fragments, data starts at 0x%x, @%0x\n",
                            page_no, page_no, pbuf->data.dpg_sequence, pbuf->data.dpg_relation, pbuf->data.dpg_count, min_data_offset, page_no * page_size );
                    for(int i = 0; i < min_data_offset; i++ ) pmap[i] = true;

                    for( int frag = 0; frag < pbuf->data.dpg_count; frag++ ) {
//                        Ods::rhd *rh;
                        USHORT fr_ofs, fr_len;
                        if ((fr_ofs = pbuf->data.dpg_rpt[frag].dpg_offset) == 0)
                            continue;
                        fr_len = pbuf->data.dpg_rpt[frag].dpg_length;

//                        fprintf( stdout, "  Fragment #%d is at 0x%x-0x%x, %d (0x%x) bytes\n", frag, fr_ofs, fr_ofs + fr_len - 1, fr_len, fr_len );
//                        rh = (Ods::rhd*)((UCHAR*)pbuf + fr_ofs);
//                        fprintf( stdout, "    trn: %d\n", rh->rhd_transaction );
//                        fprintf( stdout, "    back page: %d\n", rh->rhd_b_page );
//                        fprintf( stdout, "    back line: %d\n", rh->rhd_b_line );
//                        fprintf( stdout, "    flags: 0x%x", rh->rhd_flags );
//                        if (rh->rhd_flags != 0 ) {
//                            bool any = false;
//#define RHD_FLAG_MAYBE(flag, label) if (rh->rhd_flags & flag ) { \
//                                if (any) fprintf( stdout, ", " ); else fprintf(stdout, " ("); \
//                                fprintf(stdout, label); \
//                                any = true; \
//                                }
//                            RHD_FLAG_MAYBE(Ods::rhd_deleted, "deleted")
//                            RHD_FLAG_MAYBE(Ods::rhd_chain, "chain")
//                            RHD_FLAG_MAYBE(Ods::rhd_fragment, "fragment")
//                            RHD_FLAG_MAYBE(Ods::rhd_incomplete, "incomplete")
//                            RHD_FLAG_MAYBE(Ods::rhd_blob, "blob")
//                            RHD_FLAG_MAYBE(Ods::rhd_stream_blob, "stream blob or delta")
//                            RHD_FLAG_MAYBE(Ods::rhd_large, "large")
//                            RHD_FLAG_MAYBE(Ods::rhd_damaged, "damaged")
//                            RHD_FLAG_MAYBE(Ods::rhd_gc_active, "GC active")
//                            RHD_FLAG_MAYBE(Ods::rhd_uk_modified, "UK modified")
//                            RHD_FLAG_MAYBE(Ods::rhd_long_tranum, "Long transaction number")
//                            if (any) fprintf(stdout, ")");
//                        }
//                        fprintf( stdout, "\n");
//                        fprintf( stdout, "    format: %d\n", rh->rhd_format );

//                        if ( rh->rhd_flags & Ods::rhd_blob ) {
//                            Ods::blh *bl = (Ods::blh *)rh;
//                            fprintf(stdout, "    BLOB record (header = %d (0x%x) bytes):\n", BLH_SIZE, BLH_SIZE);
//                            fprintf(stdout, "      Lead page: %d (0x%x)\n", bl->blh_lead_page, bl->blh_lead_page);
//                            fprintf(stdout, "      Pages: %d (0x%x)\n", bl->blh_max_sequence, bl->blh_max_sequence);
//                            fprintf(stdout, "      Largest segment: %d (0x%x)\n", bl->blh_max_segment, bl->blh_max_segment);
//                            fprintf(stdout, "      Flags: 0x%x\n", bl->blh_flags);
//                            fprintf(stdout, "      Level: %d\n", bl->blh_level);
//                            fprintf(stdout, "      Segment count: %d\n", bl->blh_count);
//                            fprintf(stdout, "      Data length: %d 0x%x\n", bl->blh_length, bl->blh_length);
//                            fprintf(stdout, "      Sub-type: %d\n", bl->blh_sub_type);
//                            fprintf(stdout, "      Charset: %d\n", bl->blh_charset);
//                            fprintf(stdout, "      Unused: 0x%x\n", bl->blh_unused);
//                            if ( (bl->blh_lead_page == 0) && (bl->blh_max_sequence == 0) ) {
//                                for(ULONG i = 0; i < BLH_SIZE+bl->blh_length; i++ ) pmap[fr_ofs + i] = true;
//                            }
//                            else {
//                                for(USHORT i = 0; i < fr_len; i++ ) pmap[fr_ofs + i] = true;
//                            }
//                        }
//                        else {
                            for(USHORT i = 0; i < fr_len; i++ ) pmap[fr_ofs + i] = true;
//                        }
                    }

                    for(int i = 0; i < page_size; i++) {
                        if (!pmap[i])
                            pbuf->bytes[i] = 0;
                    }
                    break;
                }
            }

            pbuf->header.pag_generation = 1;
            pbuf->header.pag_reserved = 0;

            if ( fseek( f, page_no * page_size, SEEK_SET ) != 0 )
                error( 8, errno, "fseek(page %d)", page_no );
            if ( fwrite( pbuf, page_size, 1, f ) != 1 )
                error( 8, errno, "fwrite(page %d)", page_no );
        }
    }

    fclose(f);

    return 0;
}
