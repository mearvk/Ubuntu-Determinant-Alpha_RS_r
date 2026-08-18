/*
 * subarch-riscv64-linux.c
 *
 * Copyright (C) 2019 Karsten Merker <merker@debian.org>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 *
 * On Debian systems, the full text of the GPLv2 is available in the file
 * /usr/share/common-licenses/GPL-2.
 *
 */

#include <debian-installer/system/subarch.h>
#include <debian-installer/system/efi.h>

const char *di_system_subarch_analyze(void)
{
	/* Check whether we have been booted in EFI mode. If yes, provide  */
	/* "efi" as the subarch, otherwise return "generic". This is used  */
	/* to choose the appropriate partition table layout (mbr/gpt) and  */
	/* bootloader setup as those need to be different between the EFI  */
	/* and the non-EFI case. On riscv64 we have a single multiplatform */
	/* kernel, so there is no need to differentiate further between    */
	/* different non-EFI platforms.                                    */
	if (di_system_is_efi()) {
		return "efi";
	} else {
		return "generic";
	}
}
