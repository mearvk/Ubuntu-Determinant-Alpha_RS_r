/*
 * This file is subject to the terms and conditions of the GNU General Public
 * License.  See the file "COPYING" in the main directory of this archive
 * for more details.
 *
 * Copyright (C) 1995, 96, 97, 98, 99, 2000 by Ralf Baechle
 * Copyright (C) 1999, 2000 Silicon Graphics, Inc.
 */

#ifndef _MIPS_SIM_ABI32
#define _MIPS_SIM_ABI32			1
#define _MIPS_SIM_NABI32		2
#define _MIPS_SIM_ABI64			3
#endif

#if _MIPS_SIM == _MIPS_SIM_ABI32

/*
 * Linux o32 style syscalls are in the range from 4000 to 4999.
 */
#define __NR_Linux			4000
#define __NR_io_setup			(__NR_Linux + 241)
#define __NR_io_destroy			(__NR_Linux + 242)
#define __NR_io_getevents		(__NR_Linux + 243)
#define __NR_io_submit			(__NR_Linux + 244)
#define __NR_io_cancel			(__NR_Linux + 245)

#endif /* _MIPS_SIM == _MIPS_SIM_ABI32 */

#if _MIPS_SIM == _MIPS_SIM_ABI64

/*
 * Linux 64-bit syscalls are in the range from 5000 to 5999.
 */
#define __NR_Linux			5000
#define __NR_io_setup			(__NR_Linux + 200)
#define __NR_io_destroy			(__NR_Linux + 201)
#define __NR_io_getevents		(__NR_Linux + 202)
#define __NR_io_submit			(__NR_Linux + 203)
#define __NR_io_cancel			(__NR_Linux + 204)
#endif /* _MIPS_SIM == _MIPS_SIM_ABI64 */

#if _MIPS_SIM == _MIPS_SIM_NABI32

/*
 * Linux N32 syscalls are in the range from 6000 to 6999.
 */
#define __NR_Linux			6000
#define __NR_io_setup			(__NR_Linux + 200)
#define __NR_io_destroy			(__NR_Linux + 201)
#define __NR_io_getevents		(__NR_Linux + 202)
#define __NR_io_submit			(__NR_Linux + 203)
#define __NR_io_cancel			(__NR_Linux + 204)
#endif /* _MIPS_SIM == _MIPS_SIM_NABI32 */
