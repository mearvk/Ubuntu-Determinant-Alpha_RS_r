/*
 * a52.h
 * Copyright (C) 2000-2002 Michel Lespinasse <walken@zoy.org>
 * Copyright (C) 1999-2000 Aaron Holtzman <aholtzma@ess.engr.uvic.ca>
 *
 * This file is part of a52dec, a free ATSC A-52 stream decoder.
 * See http://liba52.sourceforge.net/ for updates.
 *
 * a52dec is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * a52dec is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

#ifndef A52_H
#define A52_H

#ifndef LIBA52_DOUBLE
typedef float sample_t;
#else
typedef double sample_t;
#endif

typedef struct {
    uint8_t bai;              /* fine SNR offset, fast gain */
    uint8_t deltbae;          /* delta bit allocation exists */
    int8_t deltba[50];        /* per-band delta bit allocation */
} ba_t;

typedef struct {
    uint8_t exp[256];         /* decoded channel exponents */
    int8_t bap[256];          /* derived channel bit allocation */
} expbap_t;

typedef struct {
    sample_t real;
    sample_t imag;
} complex_t;

typedef struct {
    uint8_t fscod;            /* sample rate */
    uint8_t halfrate;         /* halfrate factor */
    uint8_t acmod;            /* coded channels */
    uint8_t lfeon;            /* coded lfe channel */
    sample_t clev;            /* centre channel mix level */
    sample_t slev;            /* surround channels mix level */

    int output;               /* type of output */
    sample_t level;           /* output level */
    sample_t bias;            /* output bias */

    int dynrnge;              /* apply dynamic range */
    sample_t dynrng;          /* dynamic range */
    void * dynrngdata;        /* dynamic range callback funtion and data */
    sample_t (* dynrngcall) (sample_t range, void * dynrngdata);

    uint8_t chincpl;          /* channel coupled */
    uint8_t phsflginu;        /* phase flags in use (stereo only) */
    uint8_t cplstrtmant;      /* coupling channel start mantissa */
    uint8_t cplendmant;       /* coupling channel end mantissa */
    uint32_t cplbndstrc;      /* coupling band structure */
    sample_t cplco[5][18];    /* coupling coordinates */

    /* derived information */
    uint8_t cplstrtbnd;       /* coupling start band (for bit allocation) */
    uint8_t ncplbnd;          /* number of coupling bands */

    uint8_t rematflg;         /* stereo rematrixing */

    uint8_t endmant[5];       /* channel end mantissa */

    uint16_t bai;             /* bit allocation information */

    uint32_t * buffer_start;
    uint16_t lfsr_state;      /* dither state */
    uint32_t bits_left;
    uint32_t current_word;

    uint8_t csnroffst;        /* coarse SNR offset */
    ba_t cplba;               /* coupling bit allocation parameters */
    ba_t ba[5];               /* channel bit allocation parameters */
    ba_t lfeba;               /* lfe bit allocation parameters */

    uint8_t cplfleak;         /* coupling fast leak init */
    uint8_t cplsleak;         /* coupling slow leak init */

    expbap_t cpl_expbap;
    expbap_t fbw_expbap[5];
    expbap_t lfe_expbap;

    sample_t * samples;
    int downmixed;

    /* Root values for IFFT */
    sample_t * roots16;           // size 3
    sample_t * roots32;           // size 7
    sample_t * roots64;           // size 15
    sample_t * roots128;          // size 31

    /* Twiddle factors for IMDCT */
    complex_t * pre1;             // size 128
    complex_t * post1;            // size 64
    complex_t * pre2;             // size 64
    complex_t * post2;            // size 32

    sample_t * a52_imdct_window;  // size 256
} a52_state_t;

#define A52_CHANNEL 0
#define A52_MONO 1
#define A52_STEREO 2
#define A52_3F 3
#define A52_2F1R 4
#define A52_3F1R 5
#define A52_2F2R 6
#define A52_3F2R 7
#define A52_CHANNEL1 8
#define A52_CHANNEL2 9
#define A52_DOLBY 10
#define A52_CHANNEL_MASK 15

#define A52_LFE 16
#define A52_ADJUST_LEVEL 32

a52_state_t * a52_init (uint32_t mm_accel);
sample_t * a52_samples (a52_state_t * state);
int a52_syncinfo (uint8_t * buf, int * flags,
		  int * sample_rate, int * bit_rate);
int a52_frame (a52_state_t * state, uint8_t * buf, int * flags,
	       sample_t * level, sample_t bias);
void a52_dynrng (a52_state_t * state,
		 sample_t (* call) (sample_t, void *), void * data);
int a52_block (a52_state_t * state);
void a52_free (a52_state_t * state);

#endif /* A52_H */
